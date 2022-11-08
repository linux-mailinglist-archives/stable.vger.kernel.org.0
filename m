Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF26A621435
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:58:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234784AbiKHN6d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:58:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234859AbiKHN6c (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:58:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B40471115B
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:58:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FF9D61515
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:58:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33245C433D7;
        Tue,  8 Nov 2022 13:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915910;
        bh=P2RwJZNzdOepzjyY1A3nXZOethpKiJKsj6HM+3tGZfk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f078sg8RVPNq69lfDBvNl4rYdKMns7vr8p5JI1ToOthX5MqqtwJmlpJ+rRrd1FyDs
         bfqw2s8k3SejkTRbaym2usDJk2k2pXq0t/Fnf+n9OzyzHbjpRG1lh4Kv+3kjwS12Pq
         tp3xNC82nEDShSbXv7xQjU+ymMD3NXFipgYww5rs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Justin Tee <justin.tee@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 001/144] scsi: lpfc: Adjust bytes received vales during cmf timer interval
Date:   Tue,  8 Nov 2022 14:37:58 +0100
Message-Id: <20221108133345.404940753@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit d5ac69b332d8859d1f8bd5d4dee31f3267f6b0d2 ]

The newly added congestion mgmt framework is seeing unexpected congestion
FPINs and signals.  In analysis, time values given to the adapter are not
at hard time intervals. Thus the drift vs the transfer count seen is
affecting how the framework manages things.

Adjust counters to cover the drift.

Link: https://lore.kernel.org/r/20210910233159.115896-11-jsmart2021@gmail.com
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: bd269188ea94 ("scsi: lpfc: Rework MIB Rx Monitor debug info logic")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_init.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index fe8b4258cdc0..38bd58fb2044 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -5870,7 +5870,7 @@ lpfc_cmf_timer(struct hrtimer *timer)
 	uint32_t io_cnt;
 	uint32_t head, tail;
 	uint32_t busy, max_read;
-	uint64_t total, rcv, lat, mbpi;
+	uint64_t total, rcv, lat, mbpi, extra;
 	int timer_interval = LPFC_CMF_INTERVAL;
 	uint32_t ms;
 	struct lpfc_cgn_stat *cgs;
@@ -5937,7 +5937,19 @@ lpfc_cmf_timer(struct hrtimer *timer)
 	    phba->hba_flag & HBA_SETUP) {
 		mbpi = phba->cmf_last_sync_bw;
 		phba->cmf_last_sync_bw = 0;
-		lpfc_issue_cmf_sync_wqe(phba, LPFC_CMF_INTERVAL, total);
+		extra = 0;
+
+		/* Calculate any extra bytes needed to account for the
+		 * timer accuracy. If we are less than LPFC_CMF_INTERVAL
+		 * add an extra 3% slop factor, equal to LPFC_CMF_INTERVAL
+		 * add an extra 2%. The goal is to equalize total with a
+		 * time > LPFC_CMF_INTERVAL or <= LPFC_CMF_INTERVAL + 1
+		 */
+		if (ms == LPFC_CMF_INTERVAL)
+			extra = div_u64(total, 50);
+		else if (ms < LPFC_CMF_INTERVAL)
+			extra = div_u64(total, 33);
+		lpfc_issue_cmf_sync_wqe(phba, LPFC_CMF_INTERVAL, total + extra);
 	} else {
 		/* For Monitor mode or link down we want mbpi
 		 * to be the full link speed
-- 
2.35.1



