Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E905349EA1B
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 19:12:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245686AbiA0SMP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 13:12:15 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48922 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245562AbiA0SLb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 13:11:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58CC961D3E;
        Thu, 27 Jan 2022 18:11:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18D76C340E4;
        Thu, 27 Jan 2022 18:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643307090;
        bh=tcXjQpRst+uWK/M3IP+k2s99TDBAVKrpyS8hD1PUpzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UF95eJaeWiHSEjrHCLSF0JWAvD1EB3SAvrUEIFk1m3QonTErMyVE6Rj1x2lqg8/xF
         9DTD0eoUUQm3g1J7HT39n4JJNNCkYe6MZATijhAm9RQnSmnUVlQgnia8iLbfrrosDj
         qzv/q/1bF+jDzb/GrVEdiacChjPD26yPA48FWBhU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Manish Chopra <manishc@marvell.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>,
        Alok Prasad <palok@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.16 4/9] bnx2x: Utilize firmware 7.13.21.0
Date:   Thu, 27 Jan 2022 19:09:39 +0100
Message-Id: <20220127180259.035272056@linuxfoundation.org>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20220127180258.892788582@linuxfoundation.org>
References: <20220127180258.892788582@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manish Chopra <manishc@marvell.com>

commit b7a49f73059fe6147b6b78e8f674ce0d21237432 upstream

This new firmware addresses few important issues and enhancements
as mentioned below -

- Support direct invalidation of FP HSI Ver per function ID, required for
  invalidating FP HSI Ver prior to each VF start, as there is no VF start
- BRB hardware block parity error detection support for the driver
- Fix the FCOE underrun flow
- Fix PSOD during FCoE BFS over the NIC ports after preboot driver
- Maintains backward compatibility

This patch incorporates this new firmware 7.13.21.0 in bnx2x driver.

Signed-off-by: Manish Chopra <manishc@marvell.com>
Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
Signed-off-by: Alok Prasad <palok@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h         |   11 ++
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c     |    6 -
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_fw_defs.h |    2 
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_hsi.h     |    3 
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c    |   75 ++++++++++++++------
 5 files changed, 69 insertions(+), 28 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
@@ -1850,6 +1850,14 @@ struct bnx2x {
 
 	/* Vxlan/Geneve related information */
 	u16 udp_tunnel_ports[BNX2X_UDP_PORT_MAX];
+
+#define FW_CAP_INVALIDATE_VF_FP_HSI	BIT(0)
+	u32 fw_cap;
+
+	u32 fw_major;
+	u32 fw_minor;
+	u32 fw_rev;
+	u32 fw_eng;
 };
 
 /* Tx queues may be less or equal to Rx queues */
@@ -2525,5 +2533,6 @@ void bnx2x_register_phc(struct bnx2x *bp
  * Meant for implicit re-load flows.
  */
 int bnx2x_vlan_reconfigure_vid(struct bnx2x *bp);
-
+int bnx2x_init_firmware(struct bnx2x *bp);
+void bnx2x_release_firmware(struct bnx2x *bp);
 #endif /* bnx2x.h */
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -2364,10 +2364,8 @@ int bnx2x_compare_fw_ver(struct bnx2x *b
 	if (load_code != FW_MSG_CODE_DRV_LOAD_COMMON_CHIP &&
 	    load_code != FW_MSG_CODE_DRV_LOAD_COMMON) {
 		/* build my FW version dword */
-		u32 my_fw = (BCM_5710_FW_MAJOR_VERSION) +
-			(BCM_5710_FW_MINOR_VERSION << 8) +
-			(BCM_5710_FW_REVISION_VERSION << 16) +
-			(BCM_5710_FW_ENGINEERING_VERSION << 24);
+		u32 my_fw = (bp->fw_major) + (bp->fw_minor << 8) +
+				(bp->fw_rev << 16) + (bp->fw_eng << 24);
 
 		/* read loaded FW from chip */
 		u32 loaded_fw = REG_RD(bp, XSEM_REG_PRAM);
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_fw_defs.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_fw_defs.h
@@ -241,6 +241,8 @@
 	IRO[221].m2))
 #define XSTORM_VF_TO_PF_OFFSET(funcId) \
 	(IRO[48].base + ((funcId) * IRO[48].m1))
+#define XSTORM_ETH_FUNCTION_INFO_FP_HSI_VALID_E2_OFFSET(fid)	\
+	(IRO[386].base + ((fid) * IRO[386].m1))
 #define COMMON_ASM_INVALID_ASSERT_OPCODE 0x0
 
 /* eth hsi version */
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_hsi.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_hsi.h
@@ -3024,7 +3024,8 @@ struct afex_stats {
 
 #define BCM_5710_FW_MAJOR_VERSION			7
 #define BCM_5710_FW_MINOR_VERSION			13
-#define BCM_5710_FW_REVISION_VERSION		15
+#define BCM_5710_FW_REVISION_VERSION		21
+#define BCM_5710_FW_REVISION_VERSION_V15	15
 #define BCM_5710_FW_ENGINEERING_VERSION		0
 #define BCM_5710_FW_COMPILE_FLAGS			1
 
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -74,9 +74,19 @@
 	__stringify(BCM_5710_FW_MINOR_VERSION) "."	\
 	__stringify(BCM_5710_FW_REVISION_VERSION) "."	\
 	__stringify(BCM_5710_FW_ENGINEERING_VERSION)
+
+#define FW_FILE_VERSION_V15				\
+	__stringify(BCM_5710_FW_MAJOR_VERSION) "."      \
+	__stringify(BCM_5710_FW_MINOR_VERSION) "."	\
+	__stringify(BCM_5710_FW_REVISION_VERSION_V15) "."	\
+	__stringify(BCM_5710_FW_ENGINEERING_VERSION)
+
 #define FW_FILE_NAME_E1		"bnx2x/bnx2x-e1-" FW_FILE_VERSION ".fw"
 #define FW_FILE_NAME_E1H	"bnx2x/bnx2x-e1h-" FW_FILE_VERSION ".fw"
 #define FW_FILE_NAME_E2		"bnx2x/bnx2x-e2-" FW_FILE_VERSION ".fw"
+#define FW_FILE_NAME_E1_V15	"bnx2x/bnx2x-e1-" FW_FILE_VERSION_V15 ".fw"
+#define FW_FILE_NAME_E1H_V15	"bnx2x/bnx2x-e1h-" FW_FILE_VERSION_V15 ".fw"
+#define FW_FILE_NAME_E2_V15	"bnx2x/bnx2x-e2-" FW_FILE_VERSION_V15 ".fw"
 
 /* Time in jiffies before concluding the transmitter is hung */
 #define TX_TIMEOUT		(5*HZ)
@@ -747,9 +757,7 @@ static int bnx2x_mc_assert(struct bnx2x
 		  CHIP_IS_E1(bp) ? "everest1" :
 		  CHIP_IS_E1H(bp) ? "everest1h" :
 		  CHIP_IS_E2(bp) ? "everest2" : "everest3",
-		  BCM_5710_FW_MAJOR_VERSION,
-		  BCM_5710_FW_MINOR_VERSION,
-		  BCM_5710_FW_REVISION_VERSION);
+		  bp->fw_major, bp->fw_minor, bp->fw_rev);
 
 	return rc;
 }
@@ -12308,6 +12316,15 @@ static int bnx2x_init_bp(struct bnx2x *b
 
 	bnx2x_read_fwinfo(bp);
 
+	if (IS_PF(bp)) {
+		rc = bnx2x_init_firmware(bp);
+
+		if (rc) {
+			bnx2x_free_mem_bp(bp);
+			return rc;
+		}
+	}
+
 	func = BP_FUNC(bp);
 
 	/* need to reset chip if undi was active */
@@ -12320,6 +12337,7 @@ static int bnx2x_init_bp(struct bnx2x *b
 
 		rc = bnx2x_prev_unload(bp);
 		if (rc) {
+			bnx2x_release_firmware(bp);
 			bnx2x_free_mem_bp(bp);
 			return rc;
 		}
@@ -13317,16 +13335,11 @@ static int bnx2x_check_firmware(struct b
 	/* Check FW version */
 	offset = be32_to_cpu(fw_hdr->fw_version.offset);
 	fw_ver = firmware->data + offset;
-	if ((fw_ver[0] != BCM_5710_FW_MAJOR_VERSION) ||
-	    (fw_ver[1] != BCM_5710_FW_MINOR_VERSION) ||
-	    (fw_ver[2] != BCM_5710_FW_REVISION_VERSION) ||
-	    (fw_ver[3] != BCM_5710_FW_ENGINEERING_VERSION)) {
+	if (fw_ver[0] != bp->fw_major || fw_ver[1] != bp->fw_minor ||
+	    fw_ver[2] != bp->fw_rev || fw_ver[3] != bp->fw_eng) {
 		BNX2X_ERR("Bad FW version:%d.%d.%d.%d. Should be %d.%d.%d.%d\n",
-		       fw_ver[0], fw_ver[1], fw_ver[2], fw_ver[3],
-		       BCM_5710_FW_MAJOR_VERSION,
-		       BCM_5710_FW_MINOR_VERSION,
-		       BCM_5710_FW_REVISION_VERSION,
-		       BCM_5710_FW_ENGINEERING_VERSION);
+			  fw_ver[0], fw_ver[1], fw_ver[2], fw_ver[3],
+			  bp->fw_major, bp->fw_minor, bp->fw_rev, bp->fw_eng);
 		return -EINVAL;
 	}
 
@@ -13404,34 +13417,51 @@ do {									\
 	     (u8 *)bp->arr, len);					\
 } while (0)
 
-static int bnx2x_init_firmware(struct bnx2x *bp)
+int bnx2x_init_firmware(struct bnx2x *bp)
 {
-	const char *fw_file_name;
+	const char *fw_file_name, *fw_file_name_v15;
 	struct bnx2x_fw_file_hdr *fw_hdr;
 	int rc;
 
 	if (bp->firmware)
 		return 0;
 
-	if (CHIP_IS_E1(bp))
+	if (CHIP_IS_E1(bp)) {
 		fw_file_name = FW_FILE_NAME_E1;
-	else if (CHIP_IS_E1H(bp))
+		fw_file_name_v15 = FW_FILE_NAME_E1_V15;
+	} else if (CHIP_IS_E1H(bp)) {
 		fw_file_name = FW_FILE_NAME_E1H;
-	else if (!CHIP_IS_E1x(bp))
+		fw_file_name_v15 = FW_FILE_NAME_E1H_V15;
+	} else if (!CHIP_IS_E1x(bp)) {
 		fw_file_name = FW_FILE_NAME_E2;
-	else {
+		fw_file_name_v15 = FW_FILE_NAME_E2_V15;
+	} else {
 		BNX2X_ERR("Unsupported chip revision\n");
 		return -EINVAL;
 	}
+
 	BNX2X_DEV_INFO("Loading %s\n", fw_file_name);
 
 	rc = request_firmware(&bp->firmware, fw_file_name, &bp->pdev->dev);
 	if (rc) {
-		BNX2X_ERR("Can't load firmware file %s\n",
-			  fw_file_name);
-		goto request_firmware_exit;
+		BNX2X_DEV_INFO("Trying to load older fw %s\n", fw_file_name_v15);
+
+		/* try to load prev version */
+		rc = request_firmware(&bp->firmware, fw_file_name_v15, &bp->pdev->dev);
+
+		if (rc)
+			goto request_firmware_exit;
+
+		bp->fw_rev = BCM_5710_FW_REVISION_VERSION_V15;
+	} else {
+		bp->fw_cap |= FW_CAP_INVALIDATE_VF_FP_HSI;
+		bp->fw_rev = BCM_5710_FW_REVISION_VERSION;
 	}
 
+	bp->fw_major = BCM_5710_FW_MAJOR_VERSION;
+	bp->fw_minor = BCM_5710_FW_MINOR_VERSION;
+	bp->fw_eng = BCM_5710_FW_ENGINEERING_VERSION;
+
 	rc = bnx2x_check_firmware(bp);
 	if (rc) {
 		BNX2X_ERR("Corrupt firmware file %s\n", fw_file_name);
@@ -13487,7 +13517,7 @@ request_firmware_exit:
 	return rc;
 }
 
-static void bnx2x_release_firmware(struct bnx2x *bp)
+void bnx2x_release_firmware(struct bnx2x *bp)
 {
 	kfree(bp->init_ops_offsets);
 	kfree(bp->init_ops);
@@ -14004,6 +14034,7 @@ static int bnx2x_init_one(struct pci_dev
 	return 0;
 
 init_one_freemem:
+	bnx2x_release_firmware(bp);
 	bnx2x_free_mem_bp(bp);
 
 init_one_exit:


