Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3C99680F90
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 14:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236402AbjA3Nyp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 08:54:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236352AbjA3Nyn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 08:54:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A384936FE9
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 05:54:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41B3261022
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 13:54:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A190C433EF;
        Mon, 30 Jan 2023 13:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675086881;
        bh=UPu49fy2/Fbfx0ine44VlP6R9pFlPq8I7T8fk1lwpnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P3YxJdRUKhp4zN6lfoJQ6J73CA5NIV0ZRCAdG3ulLKM/VVCP1D0oDkQ+6KK67wo1n
         yHQ7Svbmkp2ON97cuJ6xrcFnCS4IB0sM7zQxgkfmrQRQRMr03/yV+T2S1Uh0/biV30
         wyBVdYV5mpCh63E8K7aeyMF60G/JTnzDya146Wl4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Cristian Marussi <cristian.marussi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 027/313] firmware: arm_scmi: Harden shared memory access in fetch_response
Date:   Mon, 30 Jan 2023 14:47:42 +0100
Message-Id: <20230130134337.932136867@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cristian Marussi <cristian.marussi@arm.com>

[ Upstream commit ad78b81a1077f7d956952cd8bdfe1e61504e3eb8 ]

A misbheaving SCMI platform firmware could reply with out-of-spec messages,
shorter than the mimimum size comprising a header and a status field.

Harden shmem_fetch_response to properly truncate such a bad messages.

Fixes: 5c8a47a5a91d ("firmware: arm_scmi: Make scmi core independent of the transport type")
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Link: https://lore.kernel.org/r/20221222183823.518856-3-cristian.marussi@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/shmem.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/arm_scmi/shmem.c b/drivers/firmware/arm_scmi/shmem.c
index 1dfe534b8518..135f8718000f 100644
--- a/drivers/firmware/arm_scmi/shmem.c
+++ b/drivers/firmware/arm_scmi/shmem.c
@@ -81,10 +81,11 @@ u32 shmem_read_header(struct scmi_shared_mem __iomem *shmem)
 void shmem_fetch_response(struct scmi_shared_mem __iomem *shmem,
 			  struct scmi_xfer *xfer)
 {
+	size_t len = ioread32(&shmem->length);
+
 	xfer->hdr.status = ioread32(shmem->msg_payload);
 	/* Skip the length of header and status in shmem area i.e 8 bytes */
-	xfer->rx.len = min_t(size_t, xfer->rx.len,
-			     ioread32(&shmem->length) - 8);
+	xfer->rx.len = min_t(size_t, xfer->rx.len, len > 8 ? len - 8 : 0);
 
 	/* Take a copy to the rx buffer.. */
 	memcpy_fromio(xfer->rx.buf, shmem->msg_payload + 4, xfer->rx.len);
-- 
2.39.0



