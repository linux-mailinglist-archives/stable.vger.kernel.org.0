Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52AF14E293D
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 15:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348940AbiCUOEO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 10:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349241AbiCUODd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 10:03:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 277FF42494;
        Mon, 21 Mar 2022 07:00:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 850ECB81598;
        Mon, 21 Mar 2022 14:00:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED9D3C340E8;
        Mon, 21 Mar 2022 14:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647871234;
        bh=9Axcd9R2DCSzFvbqYoUi2FJA67IbY09Sa34n5of3Uzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E9sAhxGDSyOzq99YfG/I3rnFpfLF8odzRLqd9jo1625jhqn3UW35fvztU1KsBs4Ef
         kKNwZac/DGp7GytfsIM8YkoOI12p8EyFJcKOoHiaBQw8AHvFkyg0vYlQ+ALKPeVtqf
         q0L6Y9Cpf6K9BP6uDaWEcC8/eacXB8PKIP6BkOos=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Menzel <pmenzel@molgen.mpg.de>,
        Manish Chopra <manishc@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 21/32] bnx2x: fix built-in kernel driver load failure
Date:   Mon, 21 Mar 2022 14:52:57 +0100
Message-Id: <20220321133221.177205614@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321133220.559554263@linuxfoundation.org>
References: <20220321133220.559554263@linuxfoundation.org>
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

From: Manish Chopra <manishc@marvell.com>

[ Upstream commit 424e7834e293936a54fcf05173f2884171adc5a3 ]

Commit b7a49f73059f ("bnx2x: Utilize firmware 7.13.21.0")
added request_firmware() logic in probe() which caused
load failure when firmware file is not present in initrd (below),
as access to firmware file is not feasible during probe.

  Direct firmware load for bnx2x/bnx2x-e2-7.13.15.0.fw failed with error -2
  Direct firmware load for bnx2x/bnx2x-e2-7.13.21.0.fw failed with error -2

This patch fixes this issue by -

1. Removing request_firmware() logic from the probe()
   such that .ndo_open() handle it as it used to handle
   it earlier

2. Given request_firmware() is removed from probe(), so
   driver has to relax FW version comparisons a bit against
   the already loaded FW version (by some other PFs of same
   adapter) to allow different compatible/close enough FWs with which
   multiple PFs may run with (in different environments), as the
   given PF who is in probe flow has no idea now with which firmware
   file version it is going to initialize the device in ndo_open()

Link: https://lore.kernel.org/all/46f2d9d9-ae7f-b332-ddeb-b59802be2bab@molgen.mpg.de/
Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
Tested-by: Paul Menzel <pmenzel@molgen.mpg.de>
Fixes: b7a49f73059f ("bnx2x: Utilize firmware 7.13.21.0")
Signed-off-by: Manish Chopra <manishc@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Link: https://lore.kernel.org/r/20220316214613.6884-1-manishc@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h   |  2 --
 .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.c   | 28 +++++++++++--------
 .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  | 15 ++--------
 3 files changed, 19 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
index 72bdbebf25ce..9e79bcfb365f 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
@@ -2533,6 +2533,4 @@ void bnx2x_register_phc(struct bnx2x *bp);
  * Meant for implicit re-load flows.
  */
 int bnx2x_vlan_reconfigure_vid(struct bnx2x *bp);
-int bnx2x_init_firmware(struct bnx2x *bp);
-void bnx2x_release_firmware(struct bnx2x *bp);
 #endif /* bnx2x.h */
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index 41ebbb2c7d3a..198e041d8410 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -2363,24 +2363,30 @@ int bnx2x_compare_fw_ver(struct bnx2x *bp, u32 load_code, bool print_err)
 	/* is another pf loaded on this engine? */
 	if (load_code != FW_MSG_CODE_DRV_LOAD_COMMON_CHIP &&
 	    load_code != FW_MSG_CODE_DRV_LOAD_COMMON) {
-		/* build my FW version dword */
-		u32 my_fw = (bp->fw_major) + (bp->fw_minor << 8) +
-				(bp->fw_rev << 16) + (bp->fw_eng << 24);
+		u8 loaded_fw_major, loaded_fw_minor, loaded_fw_rev, loaded_fw_eng;
+		u32 loaded_fw;
 
 		/* read loaded FW from chip */
-		u32 loaded_fw = REG_RD(bp, XSEM_REG_PRAM);
+		loaded_fw = REG_RD(bp, XSEM_REG_PRAM);
 
-		DP(BNX2X_MSG_SP, "loaded fw %x, my fw %x\n",
-		   loaded_fw, my_fw);
+		loaded_fw_major = loaded_fw & 0xff;
+		loaded_fw_minor = (loaded_fw >> 8) & 0xff;
+		loaded_fw_rev = (loaded_fw >> 16) & 0xff;
+		loaded_fw_eng = (loaded_fw >> 24) & 0xff;
+
+		DP(BNX2X_MSG_SP, "loaded fw 0x%x major 0x%x minor 0x%x rev 0x%x eng 0x%x\n",
+		   loaded_fw, loaded_fw_major, loaded_fw_minor, loaded_fw_rev, loaded_fw_eng);
 
 		/* abort nic load if version mismatch */
-		if (my_fw != loaded_fw) {
+		if (loaded_fw_major != BCM_5710_FW_MAJOR_VERSION ||
+		    loaded_fw_minor != BCM_5710_FW_MINOR_VERSION ||
+		    loaded_fw_eng != BCM_5710_FW_ENGINEERING_VERSION ||
+		    loaded_fw_rev < BCM_5710_FW_REVISION_VERSION_V15) {
 			if (print_err)
-				BNX2X_ERR("bnx2x with FW %x was already loaded which mismatches my %x FW. Aborting\n",
-					  loaded_fw, my_fw);
+				BNX2X_ERR("loaded FW incompatible. Aborting\n");
 			else
-				BNX2X_DEV_INFO("bnx2x with FW %x was already loaded which mismatches my %x FW, possibly due to MF UNDI\n",
-					       loaded_fw, my_fw);
+				BNX2X_DEV_INFO("loaded FW incompatible, possibly due to MF UNDI\n");
+
 			return -EBUSY;
 		}
 	}
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index dc70f6f96d02..bdd4e420f869 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -12313,15 +12313,6 @@ static int bnx2x_init_bp(struct bnx2x *bp)
 
 	bnx2x_read_fwinfo(bp);
 
-	if (IS_PF(bp)) {
-		rc = bnx2x_init_firmware(bp);
-
-		if (rc) {
-			bnx2x_free_mem_bp(bp);
-			return rc;
-		}
-	}
-
 	func = BP_FUNC(bp);
 
 	/* need to reset chip if undi was active */
@@ -12334,7 +12325,6 @@ static int bnx2x_init_bp(struct bnx2x *bp)
 
 		rc = bnx2x_prev_unload(bp);
 		if (rc) {
-			bnx2x_release_firmware(bp);
 			bnx2x_free_mem_bp(bp);
 			return rc;
 		}
@@ -13414,7 +13404,7 @@ do {									\
 	     (u8 *)bp->arr, len);					\
 } while (0)
 
-int bnx2x_init_firmware(struct bnx2x *bp)
+static int bnx2x_init_firmware(struct bnx2x *bp)
 {
 	const char *fw_file_name, *fw_file_name_v15;
 	struct bnx2x_fw_file_hdr *fw_hdr;
@@ -13514,7 +13504,7 @@ int bnx2x_init_firmware(struct bnx2x *bp)
 	return rc;
 }
 
-void bnx2x_release_firmware(struct bnx2x *bp)
+static void bnx2x_release_firmware(struct bnx2x *bp)
 {
 	kfree(bp->init_ops_offsets);
 	kfree(bp->init_ops);
@@ -14031,7 +14021,6 @@ static int bnx2x_init_one(struct pci_dev *pdev,
 	return 0;
 
 init_one_freemem:
-	bnx2x_release_firmware(bp);
 	bnx2x_free_mem_bp(bp);
 
 init_one_exit:
-- 
2.34.1



