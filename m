Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAA53548F49
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348520AbiFMK53 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:57:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350487AbiFMKyz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:54:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE89621245;
        Mon, 13 Jun 2022 03:31:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BD0260B8B;
        Mon, 13 Jun 2022 10:31:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29549C34114;
        Mon, 13 Jun 2022 10:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116292;
        bh=n+aDPt6cam0itTEtEAUp2ZeB4F2tQKVGVhNwlwvBovI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SMC45NwW7fcMciz161ko/wz4DpDwtG5T8uyZQB534S4ZAPXRp1vTdNTQh9C4usIM7
         pt1G5JbqVDJaBxgiTVCBkvK03c/NEQXEZ8Sn1W+9M+6GFBwTAp+PJjIn+6k960tzn2
         SBJJVLpSR8ydI8WV3AwsqH80+s6wBkqzFn302vN4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 156/218] firmware: dmi-sysfs: Fix memory leak in dmi_sysfs_register_handle
Date:   Mon, 13 Jun 2022 12:10:14 +0200
Message-Id: <20220613094925.325758399@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094908.257446132@linuxfoundation.org>
References: <20220613094908.257446132@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 660ba678f9998aca6db74f2dd912fa5124f0fa31 ]

kobject_init_and_add() takes reference even when it fails.
According to the doc of kobject_init_and_add()

   If this function returns an error, kobject_put() must be called to
   properly clean up the memory associated with the object.

Fix this issue by calling kobject_put().

Fixes: 948af1f0bbc8 ("firmware: Basic dmi-sysfs support")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220511071421.9769-1-linmq006@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/dmi-sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/dmi-sysfs.c b/drivers/firmware/dmi-sysfs.c
index d5de6ee8466d..084948a31d2d 100644
--- a/drivers/firmware/dmi-sysfs.c
+++ b/drivers/firmware/dmi-sysfs.c
@@ -602,7 +602,7 @@ static void __init dmi_sysfs_register_handle(const struct dmi_header *dh,
 				    "%d-%d", dh->type, entry->instance);
 
 	if (*ret) {
-		kfree(entry);
+		kobject_put(&entry->kobj);
 		return;
 	}
 
-- 
2.35.1



