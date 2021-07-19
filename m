Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A43E3CDB1D
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244804AbhGSOlT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:41:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:57588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343949AbhGSOjv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:39:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 09E716023D;
        Mon, 19 Jul 2021 15:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708004;
        bh=idndzP2FlNbrGtIgnGDJpKBsrQdORpSHSuJlHApEMu4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F6TUi0Ba//MxV0zO/S+wCKm9ep3tw5Z0UwsR9SVQ8soTYlEU7v2g4h+v9pt2Qu849
         E3JwMXGfL7iIeQoBNFRiueA+unmLMl1tEg/xLZ16BycOcEKofub59CRIJHcy46zsYy
         o+DcQxQ29rcRnTc8oNUCRnrcc/Gs3bQFtjcfVG/Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Hannes Reinecke <hare@suse.de>,
        Khalid Aziz <khalid.aziz@oracle.com>,
        Khalid Aziz <khalid@gonehiking.org>,
        kernel test robot <lkp@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 141/315] scsi: FlashPoint: Rename si_flags field
Date:   Mon, 19 Jul 2021 16:50:30 +0200
Message-Id: <20210719144947.530187126@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.861561397@linuxfoundation.org>
References: <20210719144942.861561397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 4d431153e751caa93f3b7e6f6313446974e92253 ]

The BusLogic driver has build errors on ia64 due to a name collision (in
the #included FlashPoint.c file). Rename the struct field in struct
sccb_mgr_info from si_flags to si_mflags (manager flags) to mend the build.

This is the first problem. There are 50+ others after this one:

In file included from ../include/uapi/linux/signal.h:6,
                 from ../include/linux/signal_types.h:10,
                 from ../include/linux/sched.h:29,
                 from ../include/linux/hardirq.h:9,
                 from ../include/linux/interrupt.h:11,
                 from ../drivers/scsi/BusLogic.c:27:
../arch/ia64/include/uapi/asm/siginfo.h:15:27: error: expected ':', ',', ';', '}' or '__attribute__' before '.' token
   15 | #define si_flags _sifields._sigfault._flags
      |                           ^
../drivers/scsi/FlashPoint.c:43:6: note: in expansion of macro 'si_flags'
   43 |  u16 si_flags;
      |      ^~~~~~~~
In file included from ../drivers/scsi/BusLogic.c:51:
../drivers/scsi/FlashPoint.c: In function 'FlashPoint_ProbeHostAdapter':
../drivers/scsi/FlashPoint.c:1076:11: error: 'struct sccb_mgr_info' has no member named '_sifields'
 1076 |  pCardInfo->si_flags = 0x0000;
      |           ^~
../drivers/scsi/FlashPoint.c:1079:12: error: 'struct sccb_mgr_info' has no member named '_sifields'

Link: https://lore.kernel.org/r/20210529234857.6870-1-rdunlap@infradead.org
Fixes: 391e2f25601e ("[SCSI] BusLogic: Port driver to 64-bit.")
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Khalid Aziz <khalid.aziz@oracle.com>
Cc: Khalid Aziz <khalid@gonehiking.org>
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/FlashPoint.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/FlashPoint.c b/drivers/scsi/FlashPoint.c
index 867b864f5047..4bca37d52bad 100644
--- a/drivers/scsi/FlashPoint.c
+++ b/drivers/scsi/FlashPoint.c
@@ -40,7 +40,7 @@ struct sccb_mgr_info {
 	u16 si_per_targ_ultra_nego;
 	u16 si_per_targ_no_disc;
 	u16 si_per_targ_wide_nego;
-	u16 si_flags;
+	u16 si_mflags;
 	unsigned char si_card_family;
 	unsigned char si_bustype;
 	unsigned char si_card_model[3];
@@ -1070,22 +1070,22 @@ static int FlashPoint_ProbeHostAdapter(struct sccb_mgr_info *pCardInfo)
 		ScamFlg =
 		    (unsigned char)FPT_utilEERead(ioport, SCAM_CONFIG / 2);
 
-	pCardInfo->si_flags = 0x0000;
+	pCardInfo->si_mflags = 0x0000;
 
 	if (i & 0x01)
-		pCardInfo->si_flags |= SCSI_PARITY_ENA;
+		pCardInfo->si_mflags |= SCSI_PARITY_ENA;
 
 	if (!(i & 0x02))
-		pCardInfo->si_flags |= SOFT_RESET;
+		pCardInfo->si_mflags |= SOFT_RESET;
 
 	if (i & 0x10)
-		pCardInfo->si_flags |= EXTENDED_TRANSLATION;
+		pCardInfo->si_mflags |= EXTENDED_TRANSLATION;
 
 	if (ScamFlg & SCAM_ENABLED)
-		pCardInfo->si_flags |= FLAG_SCAM_ENABLED;
+		pCardInfo->si_mflags |= FLAG_SCAM_ENABLED;
 
 	if (ScamFlg & SCAM_LEVEL2)
-		pCardInfo->si_flags |= FLAG_SCAM_LEVEL2;
+		pCardInfo->si_mflags |= FLAG_SCAM_LEVEL2;
 
 	j = (RD_HARPOON(ioport + hp_bm_ctrl) & ~SCSI_TERM_ENA_L);
 	if (i & 0x04) {
@@ -1101,7 +1101,7 @@ static int FlashPoint_ProbeHostAdapter(struct sccb_mgr_info *pCardInfo)
 
 	if (!(RD_HARPOON(ioport + hp_page_ctrl) & NARROW_SCSI_CARD))
 
-		pCardInfo->si_flags |= SUPPORT_16TAR_32LUN;
+		pCardInfo->si_mflags |= SUPPORT_16TAR_32LUN;
 
 	pCardInfo->si_card_family = HARPOON_FAMILY;
 	pCardInfo->si_bustype = BUSTYPE_PCI;
@@ -1137,15 +1137,15 @@ static int FlashPoint_ProbeHostAdapter(struct sccb_mgr_info *pCardInfo)
 
 	if (pCardInfo->si_card_model[1] == '3') {
 		if (RD_HARPOON(ioport + hp_ee_ctrl) & BIT(7))
-			pCardInfo->si_flags |= LOW_BYTE_TERM;
+			pCardInfo->si_mflags |= LOW_BYTE_TERM;
 	} else if (pCardInfo->si_card_model[2] == '0') {
 		temp = RD_HARPOON(ioport + hp_xfer_pad);
 		WR_HARPOON(ioport + hp_xfer_pad, (temp & ~BIT(4)));
 		if (RD_HARPOON(ioport + hp_ee_ctrl) & BIT(7))
-			pCardInfo->si_flags |= LOW_BYTE_TERM;
+			pCardInfo->si_mflags |= LOW_BYTE_TERM;
 		WR_HARPOON(ioport + hp_xfer_pad, (temp | BIT(4)));
 		if (RD_HARPOON(ioport + hp_ee_ctrl) & BIT(7))
-			pCardInfo->si_flags |= HIGH_BYTE_TERM;
+			pCardInfo->si_mflags |= HIGH_BYTE_TERM;
 		WR_HARPOON(ioport + hp_xfer_pad, temp);
 	} else {
 		temp = RD_HARPOON(ioport + hp_ee_ctrl);
@@ -1163,9 +1163,9 @@ static int FlashPoint_ProbeHostAdapter(struct sccb_mgr_info *pCardInfo)
 		WR_HARPOON(ioport + hp_ee_ctrl, temp);
 		WR_HARPOON(ioport + hp_xfer_pad, temp2);
 		if (!(temp3 & BIT(7)))
-			pCardInfo->si_flags |= LOW_BYTE_TERM;
+			pCardInfo->si_mflags |= LOW_BYTE_TERM;
 		if (!(temp3 & BIT(6)))
-			pCardInfo->si_flags |= HIGH_BYTE_TERM;
+			pCardInfo->si_mflags |= HIGH_BYTE_TERM;
 	}
 
 	ARAM_ACCESS(ioport);
@@ -1272,7 +1272,7 @@ static void *FlashPoint_HardwareResetHostAdapter(struct sccb_mgr_info
 	WR_HARPOON(ioport + hp_arb_id, pCardInfo->si_id);
 	CurrCard->ourId = pCardInfo->si_id;
 
-	i = (unsigned char)pCardInfo->si_flags;
+	i = (unsigned char)pCardInfo->si_mflags;
 	if (i & SCSI_PARITY_ENA)
 		WR_HARPOON(ioport + hp_portctrl_1, (HOST_MODE8 | CHK_SCSI_P));
 
@@ -1286,14 +1286,14 @@ static void *FlashPoint_HardwareResetHostAdapter(struct sccb_mgr_info
 		j |= SCSI_TERM_ENA_H;
 	WR_HARPOON(ioport + hp_ee_ctrl, j);
 
-	if (!(pCardInfo->si_flags & SOFT_RESET)) {
+	if (!(pCardInfo->si_mflags & SOFT_RESET)) {
 
 		FPT_sresb(ioport, thisCard);
 
 		FPT_scini(thisCard, pCardInfo->si_id, 0);
 	}
 
-	if (pCardInfo->si_flags & POST_ALL_UNDERRRUNS)
+	if (pCardInfo->si_mflags & POST_ALL_UNDERRRUNS)
 		CurrCard->globalFlags |= F_NO_FILTER;
 
 	if (pCurrNvRam) {
-- 
2.30.2



