Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BED268D8BE
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:12:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232564AbjBGNMh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:12:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232503AbjBGNMP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:12:15 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE5813D903
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:11:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E2796CE1D84
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:10:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED7FC4339B;
        Tue,  7 Feb 2023 13:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775455;
        bh=lyaYmInNduHu7nmrhugQRNiQ+S6sOFPavBjxMp0q3h4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hd1OfptOjLXH9RysdaQJzMGUADpUh9lINza9aLpaazdRhnJXfyQ89UH2pk89rqa/0
         x87ttwjmxD9B0YzhBfnAMHAyXwYvDZeNoMddR4ae6B+i06uGGWJ+hFNadROUGULwcM
         Lv32IihJsBZkJYAboQahGCKcmNzx8PYZHyFd+voA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Bart Van Assche <bvanassche@acm.org>,
        Martin Wilck <mwilck@suse.com>, Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 016/120] scsi: Revert "scsi: core: map PQ=1, PDT=other values to SCSI_SCAN_TARGET_PRESENT"
Date:   Tue,  7 Feb 2023 13:56:27 +0100
Message-Id: <20230207125619.450910149@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
References: <20230207125618.699726054@linuxfoundation.org>
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

From: Martin K. Petersen <martin.petersen@oracle.com>

[ Upstream commit 15600159bcc6abbeae6b33a849bef90dca28b78f ]

This reverts commit 948e922fc44611ee2de0c89583ca958cb5307d36.

Not all targets that return PQ=1 and PDT=0 should be ignored. While
the SCSI spec is vague in this department, there appears to be a
critical mass of devices which rely on devices being accessible with
this combination of reported values.

Fixes: 948e922fc446 ("scsi: core: map PQ=1, PDT=other values to SCSI_SCAN_TARGET_PRESENT")
Link: https://lore.kernel.org/r/yq1lelrleqr.fsf@ca-mkp.ca.oracle.com
Acked-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Martin Wilck <mwilck@suse.com>
Acked-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_scan.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 9466474ff01b..86c10edbb5f1 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1206,8 +1206,7 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 	 * that no LUN is present, so don't add sdev in these cases.
 	 * Two specific examples are:
 	 * 1) NetApp targets: return PQ=1, PDT=0x1f
-	 * 2) IBM/2145 targets: return PQ=1, PDT=0
-	 * 3) USB UFI: returns PDT=0x1f, with the PQ bits being "reserved"
+	 * 2) USB UFI: returns PDT=0x1f, with the PQ bits being "reserved"
 	 *    in the UFI 1.0 spec (we cannot rely on reserved bits).
 	 *
 	 * References:
@@ -1221,8 +1220,8 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 	 * PDT=00h Direct-access device (floppy)
 	 * PDT=1Fh none (no FDD connected to the requested logical unit)
 	 */
-	if (((result[0] >> 5) == 1 ||
-	    (starget->pdt_1f_for_no_lun && (result[0] & 0x1f) == 0x1f)) &&
+	if (((result[0] >> 5) == 1 || starget->pdt_1f_for_no_lun) &&
+	    (result[0] & 0x1f) == 0x1f &&
 	    !scsi_is_wlun(lun)) {
 		SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
 					"scsi scan: peripheral device type"
-- 
2.39.0



