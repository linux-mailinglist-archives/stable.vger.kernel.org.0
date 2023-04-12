Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E76EE6DEE13
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbjDLIjt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:39:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbjDLIjc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:39:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B038276BF
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:38:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0824162F9F
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:37:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F9A6C433EF;
        Wed, 12 Apr 2023 08:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288637;
        bh=P80lURY9cfCIAVGdr0sa7TssZUnaaijC+nj0BNcbLjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ckM/TNBNDtM2G2QLXVI0MwR+91I/AFr9fubefVV7H6FsL8l7FwmDsVYbV7KH73Iaj
         cCn9kuliwlGpxD5YWOXCoEaztGDukQWNihszDbVxZOBtJDBsRisdVsW2DO3wqoeXqM
         BoMPjl3yd/x9kdhjrgriE/0EH4aefqWpzVEoQE3w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mohammed Gamal <mgamal@redhat.com>,
        Dexuan Cui <decui@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 24/93] Drivers: vmbus: Check for channel allocation before looking up relids
Date:   Wed, 12 Apr 2023 10:33:25 +0200
Message-Id: <20230412082824.075835306@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
References: <20230412082823.045155996@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mohammed Gamal <mgamal@redhat.com>

[ Upstream commit 1eb65c8687316c65140b48fad27133d583178e15 ]

relid2channel() assumes vmbus channel array to be allocated when called.
However, in cases such as kdump/kexec, not all relids will be reset by the host.
When the second kernel boots and if the guest receives a vmbus interrupt during
vmbus driver initialization before vmbus_connect() is called, before it finishes,
or if it fails, the vmbus interrupt service routine is called which in turn calls
relid2channel() and can cause a null pointer dereference.

Print a warning and error out in relid2channel() for a channel id that's invalid
in the second kernel.

Fixes: 8b6a877c060e ("Drivers: hv: vmbus: Replace the per-CPU channel lists with a global array of channels")

Signed-off-by: Mohammed Gamal <mgamal@redhat.com>
Reviewed-by: Dexuan Cui <decui@microsoft.com>
Link: https://lore.kernel.org/r/20230217204411.212709-1-mgamal@redhat.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/connection.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index 5e479d54918cf..47fb412eafd35 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -315,6 +315,10 @@ void vmbus_disconnect(void)
  */
 struct vmbus_channel *relid2channel(u32 relid)
 {
+	if (vmbus_connection.channels == NULL) {
+		pr_warn_once("relid2channel: relid=%d: No channels mapped!\n", relid);
+		return NULL;
+	}
 	if (WARN_ON(relid >= MAX_CHANNEL_RELIDS))
 		return NULL;
 	return READ_ONCE(vmbus_connection.channels[relid]);
-- 
2.39.2



