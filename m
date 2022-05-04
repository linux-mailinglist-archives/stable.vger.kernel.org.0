Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3A2651A969
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235849AbiEDRRd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:17:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356331AbiEDRL6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:11:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF8124BB8F;
        Wed,  4 May 2022 09:57:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E42A61794;
        Wed,  4 May 2022 16:57:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A719C385AA;
        Wed,  4 May 2022 16:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683459;
        bh=IchFKXoZxi31RZsb3AoQmBrHUFpAC4EeXnEm2gI5ets=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EkqDNkCIhbTO4B7PnuuqRa3La03zUN4ATDLSzMogOTbGcv9+N0SMQOZ+FJcbc8Epq
         YL/epeCu1eL+/kQcAXa2/Ojp/qsHBUQ8Hxq+VqY/0PEcFqmRKrurBvVacCgMIademQ
         mBFo/n8S2XhecuZ6zoW5U6MnT8lEDMQ64QU7TGmg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Oros <poros@redhat.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH 5.17 134/225] ice: wait 5 s for EMP reset after firmware flash
Date:   Wed,  4 May 2022 18:46:12 +0200
Message-Id: <20220504153122.262348884@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Oros <poros@redhat.com>

[ Upstream commit b537752e6cbf0e4475c165178ca02241b53ff6ef ]

We need to wait 5 s for EMP reset after firmware flash. Code was extracted
from OOT driver (ice v1.8.3 downloaded from sourceforge). Without this
wait, fw_activate let card in inconsistent state and recoverable only
by second flash/activate. Flash was tested on these fw's:
>From -> To
 3.00 -> 3.10/3.20
 3.10 -> 3.00/3.20
 3.20 -> 3.00/3.10

Reproducer:
[root@host ~]# devlink dev flash pci/0000:ca:00.0 file E810_XXVDA4_FH_O_SEC_FW_1p6p1p9_NVM_3p10_PLDMoMCTP_0.11_8000AD7B.bin
Preparing to flash
[fw.mgmt] Erasing
[fw.mgmt] Erasing done
[fw.mgmt] Flashing 100%
[fw.mgmt] Flashing done 100%
[fw.undi] Erasing
[fw.undi] Erasing done
[fw.undi] Flashing 100%
[fw.undi] Flashing done 100%
[fw.netlist] Erasing
[fw.netlist] Erasing done
[fw.netlist] Flashing 100%
[fw.netlist] Flashing done 100%
Activate new firmware by devlink reload
[root@host ~]# devlink dev reload pci/0000:ca:00.0 action fw_activate
reload_actions_performed:
    fw_activate
[root@host ~]# ip link show ens7f0
71: ens7f0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state DOWN mode DEFAULT group default qlen 1000
    link/ether b4:96:91:dc:72:e0 brd ff:ff:ff:ff:ff:ff
    altname enp202s0f0

dmesg after flash:
[   55.120788] ice: Copyright (c) 2018, Intel Corporation.
[   55.274734] ice 0000:ca:00.0: Get PHY capabilities failed status = -5, continuing anyway
[   55.569797] ice 0000:ca:00.0: The DDP package was successfully loaded: ICE OS Default Package version 1.3.28.0
[   55.603629] ice 0000:ca:00.0: Get PHY capability failed.
[   55.608951] ice 0000:ca:00.0: ice_init_nvm_phy_type failed: -5
[   55.647348] ice 0000:ca:00.0: PTP init successful
[   55.675536] ice 0000:ca:00.0: DCB is enabled in the hardware, max number of TCs supported on this port are 8
[   55.685365] ice 0000:ca:00.0: FW LLDP is disabled, DCBx/LLDP in SW mode.
[   55.692179] ice 0000:ca:00.0: Commit DCB Configuration to the hardware
[   55.701382] ice 0000:ca:00.0: 126.024 Gb/s available PCIe bandwidth, limited by 16.0 GT/s PCIe x8 link at 0000:c9:02.0 (capable of 252.048 Gb/s with 16.0 GT/s PCIe x16 link)
Reboot doesn’t help, only second flash/activate with OOT or patched
driver put card back in consistent state.

After patch:
[root@host ~]# devlink dev flash pci/0000:ca:00.0 file E810_XXVDA4_FH_O_SEC_FW_1p6p1p9_NVM_3p10_PLDMoMCTP_0.11_8000AD7B.bin
Preparing to flash
[fw.mgmt] Erasing
[fw.mgmt] Erasing done
[fw.mgmt] Flashing 100%
[fw.mgmt] Flashing done 100%
[fw.undi] Erasing
[fw.undi] Erasing done
[fw.undi] Flashing 100%
[fw.undi] Flashing done 100%
[fw.netlist] Erasing
[fw.netlist] Erasing done
[fw.netlist] Flashing 100%
[fw.netlist] Flashing done 100%
Activate new firmware by devlink reload
[root@host ~]# devlink dev reload pci/0000:ca:00.0 action fw_activate
reload_actions_performed:
    fw_activate
[root@host ~]# ip link show ens7f0
19: ens7f0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
    link/ether b4:96:91:dc:72:e0 brd ff:ff:ff:ff:ff:ff
    altname enp202s0f0

Fixes: 399e27dbbd9e94 ("ice: support immediate firmware activation via devlink reload")
Signed-off-by: Petr Oros <poros@redhat.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 2de2bbbca1e9..e347030ee2e3 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -6662,12 +6662,15 @@ static void ice_rebuild(struct ice_pf *pf, enum ice_reset_req reset_type)
 
 	dev_dbg(dev, "rebuilding PF after reset_type=%d\n", reset_type);
 
+#define ICE_EMP_RESET_SLEEP_MS 5000
 	if (reset_type == ICE_RESET_EMPR) {
 		/* If an EMP reset has occurred, any previously pending flash
 		 * update will have completed. We no longer know whether or
 		 * not the NVM update EMP reset is restricted.
 		 */
 		pf->fw_emp_reset_disabled = false;
+
+		msleep(ICE_EMP_RESET_SLEEP_MS);
 	}
 
 	err = ice_init_all_ctrlq(hw);
-- 
2.35.1



