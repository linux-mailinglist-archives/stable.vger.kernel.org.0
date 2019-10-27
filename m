Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96DE5E684E
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732191AbfJ0VWh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:22:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:43634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732187AbfJ0VWh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:22:37 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 745462070B;
        Sun, 27 Oct 2019 21:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211355;
        bh=Z1mSKNhrMoyrMS+tmwaZw2RnmYml3GNn6tH2/hzajKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hy4aprQPdYSRxfwkoVVLtmtjra/xYRfE4CucJv+6OVLUL9e5z2L4rrqtuqfBLo7ky
         6sp37QWOjL4TMYLRn9lBuZxF3ZnhsUpxweRcfaOABvUy9WerSFkBLHp+3dpB2izvwY
         DsZ5U6rubF9Uw5Apihamw3nC85uRTLfV5oG5VXwE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luca Coelho <luciano.coelho@intel.com>
Subject: [PATCH 5.3 121/197] iwlwifi: pcie: change qu with jf devices to use qu configuration
Date:   Sun, 27 Oct 2019 22:00:39 +0100
Message-Id: <20191027203358.271940739@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

commit aa0cc7dde17bb6b8cc533bbcfe3f53d70e0dd269 upstream.

There were a bunch of devices with qu and jf that were loading the
configuration with pu and jf, which is wrong.  Fix them all
accordingly.  Additionally, remove 0x1010 and 0x1210 subsytem IDs from
the list, since they are obviously wrong, and 0x0044 and 0x0244, which
were duplicate.

Cc: stable@vger.kernel.org # 5.1+
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c |  274 +++++++++++++-------------
 1 file changed, 137 insertions(+), 137 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -513,31 +513,33 @@ static const struct pci_device_id iwl_hw
 	{IWL_PCI_DEVICE(0x24FD, 0x9074, iwl8265_2ac_cfg)},
 
 /* 9000 Series */
-	{IWL_PCI_DEVICE(0x02F0, 0x0030, iwl9560_2ac_160_cfg_quz_a0_jf_b0_soc)},
-	{IWL_PCI_DEVICE(0x02F0, 0x0034, iwl9560_2ac_cfg_quz_a0_jf_b0_soc)},
-	{IWL_PCI_DEVICE(0x02F0, 0x0038, iwl9560_2ac_160_cfg_quz_a0_jf_b0_soc)},
-	{IWL_PCI_DEVICE(0x02F0, 0x003C, iwl9560_2ac_160_cfg_quz_a0_jf_b0_soc)},
-	{IWL_PCI_DEVICE(0x02F0, 0x0060, iwl9461_2ac_cfg_quz_a0_jf_b0_soc)},
-	{IWL_PCI_DEVICE(0x02F0, 0x0064, iwl9461_2ac_cfg_quz_a0_jf_b0_soc)},
-	{IWL_PCI_DEVICE(0x02F0, 0x00A0, iwl9462_2ac_cfg_quz_a0_jf_b0_soc)},
-	{IWL_PCI_DEVICE(0x02F0, 0x00A4, iwl9462_2ac_cfg_quz_a0_jf_b0_soc)},
-	{IWL_PCI_DEVICE(0x02F0, 0x0230, iwl9560_2ac_cfg_quz_a0_jf_b0_soc)},
-	{IWL_PCI_DEVICE(0x02F0, 0x0234, iwl9560_2ac_cfg_quz_a0_jf_b0_soc)},
-	{IWL_PCI_DEVICE(0x02F0, 0x0238, iwl9560_2ac_cfg_quz_a0_jf_b0_soc)},
-	{IWL_PCI_DEVICE(0x02F0, 0x023C, iwl9560_2ac_cfg_quz_a0_jf_b0_soc)},
-	{IWL_PCI_DEVICE(0x02F0, 0x0260, iwl9461_2ac_cfg_quz_a0_jf_b0_soc)},
-	{IWL_PCI_DEVICE(0x02F0, 0x0264, iwl9461_2ac_cfg_quz_a0_jf_b0_soc)},
-	{IWL_PCI_DEVICE(0x02F0, 0x02A0, iwl9462_2ac_cfg_quz_a0_jf_b0_soc)},
-	{IWL_PCI_DEVICE(0x02F0, 0x02A4, iwl9462_2ac_cfg_quz_a0_jf_b0_soc)},
-	{IWL_PCI_DEVICE(0x02F0, 0x1551, iwl9560_killer_s_2ac_cfg_quz_a0_jf_b0_soc)},
-	{IWL_PCI_DEVICE(0x02F0, 0x1552, iwl9560_killer_i_2ac_cfg_quz_a0_jf_b0_soc)},
-	{IWL_PCI_DEVICE(0x02F0, 0x2030, iwl9560_2ac_160_cfg_quz_a0_jf_b0_soc)},
-	{IWL_PCI_DEVICE(0x02F0, 0x2034, iwl9560_2ac_160_cfg_quz_a0_jf_b0_soc)},
-	{IWL_PCI_DEVICE(0x02F0, 0x4030, iwl9560_2ac_160_cfg_quz_a0_jf_b0_soc)},
-	{IWL_PCI_DEVICE(0x02F0, 0x4034, iwl9560_2ac_160_cfg_quz_a0_jf_b0_soc)},
-	{IWL_PCI_DEVICE(0x02F0, 0x40A4, iwl9462_2ac_cfg_quz_a0_jf_b0_soc)},
-	{IWL_PCI_DEVICE(0x02F0, 0x4234, iwl9560_2ac_cfg_quz_a0_jf_b0_soc)},
-	{IWL_PCI_DEVICE(0x02F0, 0x42A4, iwl9462_2ac_cfg_quz_a0_jf_b0_soc)},
+	{IWL_PCI_DEVICE(0x02F0, 0x0030, iwl9560_2ac_160_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x02F0, 0x0034, iwl9560_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x02F0, 0x0038, iwl9560_2ac_160_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x02F0, 0x003C, iwl9560_2ac_160_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x02F0, 0x0060, iwl9461_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x02F0, 0x0064, iwl9461_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x02F0, 0x00A0, iwl9462_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x02F0, 0x00A4, iwl9462_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x02F0, 0x0230, iwl9560_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x02F0, 0x0234, iwl9560_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x02F0, 0x0238, iwl9560_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x02F0, 0x023C, iwl9560_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x02F0, 0x0260, iwl9461_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x02F0, 0x0264, iwl9461_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x02F0, 0x02A0, iwl9462_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x02F0, 0x02A4, iwl9462_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x02F0, 0x1030, iwl9560_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x02F0, 0x1551, killer1550s_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x02F0, 0x1552, killer1550i_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x02F0, 0x2030, iwl9560_2ac_160_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x02F0, 0x2034, iwl9560_2ac_160_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x02F0, 0x4030, iwl9560_2ac_160_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x02F0, 0x4034, iwl9560_2ac_160_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x02F0, 0x40A4, iwl9462_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x02F0, 0x4234, iwl9560_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x02F0, 0x42A4, iwl9462_2ac_cfg_qu_b0_jf_b0)},
+
 	{IWL_PCI_DEVICE(0x06F0, 0x0030, iwl9560_2ac_160_cfg_quz_a0_jf_b0_soc)},
 	{IWL_PCI_DEVICE(0x06F0, 0x0034, iwl9560_2ac_cfg_quz_a0_jf_b0_soc)},
 	{IWL_PCI_DEVICE(0x06F0, 0x0038, iwl9560_2ac_160_cfg_quz_a0_jf_b0_soc)},
@@ -643,34 +645,34 @@ static const struct pci_device_id iwl_hw
 	{IWL_PCI_DEVICE(0x2720, 0x40A4, iwl9462_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x2720, 0x4234, iwl9560_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x2720, 0x42A4, iwl9462_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x30DC, 0x0030, iwl9560_2ac_160_cfg_soc)},
-	{IWL_PCI_DEVICE(0x30DC, 0x0034, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x30DC, 0x0038, iwl9560_2ac_160_cfg_soc)},
-	{IWL_PCI_DEVICE(0x30DC, 0x003C, iwl9560_2ac_160_cfg_soc)},
-	{IWL_PCI_DEVICE(0x30DC, 0x0060, iwl9460_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x30DC, 0x0064, iwl9461_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x30DC, 0x00A0, iwl9462_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x30DC, 0x00A4, iwl9462_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x30DC, 0x0230, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x30DC, 0x0234, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x30DC, 0x0238, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x30DC, 0x023C, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x30DC, 0x0260, iwl9461_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x30DC, 0x0264, iwl9461_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x30DC, 0x02A0, iwl9462_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x30DC, 0x02A4, iwl9462_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x30DC, 0x1010, iwl9260_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x30DC, 0x1030, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x30DC, 0x1210, iwl9260_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x30DC, 0x1551, iwl9560_killer_s_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x30DC, 0x1552, iwl9560_killer_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x30DC, 0x2030, iwl9560_2ac_160_cfg_soc)},
-	{IWL_PCI_DEVICE(0x30DC, 0x2034, iwl9560_2ac_160_cfg_soc)},
-	{IWL_PCI_DEVICE(0x30DC, 0x4030, iwl9560_2ac_160_cfg_soc)},
-	{IWL_PCI_DEVICE(0x30DC, 0x4034, iwl9560_2ac_160_cfg_soc)},
-	{IWL_PCI_DEVICE(0x30DC, 0x40A4, iwl9462_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x30DC, 0x4234, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x30DC, 0x42A4, iwl9462_2ac_cfg_soc)},
+
+	{IWL_PCI_DEVICE(0x30DC, 0x0030, iwl9560_2ac_160_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x30DC, 0x0034, iwl9560_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x30DC, 0x0038, iwl9560_2ac_160_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x30DC, 0x003C, iwl9560_2ac_160_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x30DC, 0x0060, iwl9461_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x30DC, 0x0064, iwl9461_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x30DC, 0x00A0, iwl9462_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x30DC, 0x00A4, iwl9462_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x30DC, 0x0230, iwl9560_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x30DC, 0x0234, iwl9560_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x30DC, 0x0238, iwl9560_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x30DC, 0x023C, iwl9560_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x30DC, 0x0260, iwl9461_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x30DC, 0x0264, iwl9461_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x30DC, 0x02A0, iwl9462_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x30DC, 0x02A4, iwl9462_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x30DC, 0x1030, iwl9560_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x30DC, 0x1551, killer1550s_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x30DC, 0x1552, killer1550i_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x30DC, 0x2030, iwl9560_2ac_160_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x30DC, 0x2034, iwl9560_2ac_160_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x30DC, 0x4030, iwl9560_2ac_160_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x30DC, 0x4034, iwl9560_2ac_160_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x30DC, 0x40A4, iwl9462_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x30DC, 0x4234, iwl9560_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x30DC, 0x42A4, iwl9462_2ac_cfg_qu_b0_jf_b0)},
+
 	{IWL_PCI_DEVICE(0x31DC, 0x0030, iwl9560_2ac_160_cfg_shared_clk)},
 	{IWL_PCI_DEVICE(0x31DC, 0x0034, iwl9560_2ac_cfg_shared_clk)},
 	{IWL_PCI_DEVICE(0x31DC, 0x0038, iwl9560_2ac_160_cfg_shared_clk)},
@@ -726,62 +728,60 @@ static const struct pci_device_id iwl_hw
 	{IWL_PCI_DEVICE(0x34F0, 0x4234, iwl9560_2ac_cfg_qu_b0_jf_b0)},
 	{IWL_PCI_DEVICE(0x34F0, 0x42A4, iwl9462_2ac_cfg_qu_b0_jf_b0)},
 
-	{IWL_PCI_DEVICE(0x3DF0, 0x0030, iwl9560_2ac_160_cfg_soc)},
-	{IWL_PCI_DEVICE(0x3DF0, 0x0034, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x3DF0, 0x0038, iwl9560_2ac_160_cfg_soc)},
-	{IWL_PCI_DEVICE(0x3DF0, 0x003C, iwl9560_2ac_160_cfg_soc)},
-	{IWL_PCI_DEVICE(0x3DF0, 0x0060, iwl9461_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x3DF0, 0x0064, iwl9461_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x3DF0, 0x00A0, iwl9462_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x3DF0, 0x00A4, iwl9462_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x3DF0, 0x0230, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x3DF0, 0x0234, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x3DF0, 0x0238, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x3DF0, 0x023C, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x3DF0, 0x0260, iwl9461_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x3DF0, 0x0264, iwl9461_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x3DF0, 0x02A0, iwl9462_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x3DF0, 0x02A4, iwl9462_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x3DF0, 0x1010, iwl9260_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x3DF0, 0x1030, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x3DF0, 0x1210, iwl9260_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x3DF0, 0x1551, iwl9560_killer_s_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x3DF0, 0x1552, iwl9560_killer_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x3DF0, 0x2030, iwl9560_2ac_160_cfg_soc)},
-	{IWL_PCI_DEVICE(0x3DF0, 0x2034, iwl9560_2ac_160_cfg_soc)},
-	{IWL_PCI_DEVICE(0x3DF0, 0x4030, iwl9560_2ac_160_cfg_soc)},
-	{IWL_PCI_DEVICE(0x3DF0, 0x4034, iwl9560_2ac_160_cfg_soc)},
-	{IWL_PCI_DEVICE(0x3DF0, 0x40A4, iwl9462_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x3DF0, 0x4234, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x3DF0, 0x42A4, iwl9462_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x43F0, 0x0030, iwl9560_2ac_160_cfg_soc)},
-	{IWL_PCI_DEVICE(0x43F0, 0x0034, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x43F0, 0x0038, iwl9560_2ac_160_cfg_soc)},
-	{IWL_PCI_DEVICE(0x43F0, 0x003C, iwl9560_2ac_160_cfg_soc)},
-	{IWL_PCI_DEVICE(0x43F0, 0x0060, iwl9461_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x43F0, 0x0064, iwl9461_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x43F0, 0x00A0, iwl9462_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x43F0, 0x00A4, iwl9462_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x43F0, 0x0230, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x43F0, 0x0234, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x43F0, 0x0238, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x43F0, 0x023C, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x43F0, 0x0260, iwl9461_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x43F0, 0x0264, iwl9461_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x43F0, 0x02A0, iwl9462_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x43F0, 0x02A4, iwl9462_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x43F0, 0x1010, iwl9260_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x43F0, 0x1030, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x43F0, 0x1210, iwl9260_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x43F0, 0x1551, iwl9560_killer_s_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x43F0, 0x1552, iwl9560_killer_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x43F0, 0x2030, iwl9560_2ac_160_cfg_soc)},
-	{IWL_PCI_DEVICE(0x43F0, 0x2034, iwl9560_2ac_160_cfg_soc)},
-	{IWL_PCI_DEVICE(0x43F0, 0x4030, iwl9560_2ac_160_cfg_soc)},
-	{IWL_PCI_DEVICE(0x43F0, 0x4034, iwl9560_2ac_160_cfg_soc)},
-	{IWL_PCI_DEVICE(0x43F0, 0x40A4, iwl9462_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x43F0, 0x4234, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x43F0, 0x42A4, iwl9462_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x3DF0, 0x0030, iwl9560_2ac_160_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x3DF0, 0x0034, iwl9560_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x3DF0, 0x0038, iwl9560_2ac_160_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x3DF0, 0x003C, iwl9560_2ac_160_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x3DF0, 0x0060, iwl9461_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x3DF0, 0x0064, iwl9461_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x3DF0, 0x00A0, iwl9462_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x3DF0, 0x00A4, iwl9462_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x3DF0, 0x0230, iwl9560_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x3DF0, 0x0234, iwl9560_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x3DF0, 0x0238, iwl9560_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x3DF0, 0x023C, iwl9560_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x3DF0, 0x0260, iwl9461_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x3DF0, 0x0264, iwl9461_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x3DF0, 0x02A0, iwl9462_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x3DF0, 0x02A4, iwl9462_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x3DF0, 0x1030, iwl9560_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x3DF0, 0x1551, killer1550s_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x3DF0, 0x1552, killer1550i_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x3DF0, 0x2030, iwl9560_2ac_160_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x3DF0, 0x2034, iwl9560_2ac_160_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x3DF0, 0x4030, iwl9560_2ac_160_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x3DF0, 0x4034, iwl9560_2ac_160_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x3DF0, 0x40A4, iwl9462_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x3DF0, 0x4234, iwl9560_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x3DF0, 0x42A4, iwl9462_2ac_cfg_qu_b0_jf_b0)},
+
+	{IWL_PCI_DEVICE(0x43F0, 0x0030, iwl9560_2ac_160_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x43F0, 0x0034, iwl9560_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x43F0, 0x0038, iwl9560_2ac_160_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x43F0, 0x003C, iwl9560_2ac_160_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x43F0, 0x0060, iwl9461_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x43F0, 0x0064, iwl9461_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x43F0, 0x00A0, iwl9462_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x43F0, 0x00A4, iwl9462_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x43F0, 0x0230, iwl9560_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x43F0, 0x0234, iwl9560_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x43F0, 0x0238, iwl9560_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x43F0, 0x023C, iwl9560_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x43F0, 0x0260, iwl9461_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x43F0, 0x0264, iwl9461_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x43F0, 0x02A0, iwl9462_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x43F0, 0x02A4, iwl9462_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x43F0, 0x1030, iwl9560_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x43F0, 0x1551, killer1550s_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x43F0, 0x1552, killer1550i_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x43F0, 0x2030, iwl9560_2ac_160_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x43F0, 0x2034, iwl9560_2ac_160_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x43F0, 0x4030, iwl9560_2ac_160_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x43F0, 0x4034, iwl9560_2ac_160_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x43F0, 0x40A4, iwl9462_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x43F0, 0x4234, iwl9560_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x43F0, 0x42A4, iwl9462_2ac_cfg_qu_b0_jf_b0)},
+
 	{IWL_PCI_DEVICE(0x9DF0, 0x0000, iwl9460_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x9DF0, 0x0010, iwl9460_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x9DF0, 0x0030, iwl9560_2ac_160_cfg_soc)},
@@ -821,34 +821,34 @@ static const struct pci_device_id iwl_hw
 	{IWL_PCI_DEVICE(0x9DF0, 0x40A4, iwl9462_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x9DF0, 0x4234, iwl9560_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x9DF0, 0x42A4, iwl9462_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x0030, iwl9560_2ac_160_cfg_soc)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x0034, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x0038, iwl9560_2ac_160_cfg_soc)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x003C, iwl9560_2ac_160_cfg_soc)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x0060, iwl9461_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x0064, iwl9461_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x00A0, iwl9462_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x00A4, iwl9462_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x0230, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x0234, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x0238, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x023C, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x0260, iwl9461_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x0264, iwl9461_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x02A0, iwl9462_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x02A4, iwl9462_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x1010, iwl9260_2ac_cfg)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x1030, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x1210, iwl9260_2ac_cfg)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x1551, iwl9560_killer_s_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x1552, iwl9560_killer_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x2030, iwl9560_2ac_160_cfg_soc)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x2034, iwl9560_2ac_160_cfg_soc)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x4030, iwl9560_2ac_160_cfg_soc)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x4034, iwl9560_2ac_160_cfg_soc)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x40A4, iwl9462_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x4234, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x42A4, iwl9462_2ac_cfg_soc)},
+
+	{IWL_PCI_DEVICE(0xA0F0, 0x0030, iwl9560_2ac_160_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x0034, iwl9560_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x0038, iwl9560_2ac_160_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x003C, iwl9560_2ac_160_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x0060, iwl9461_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x0064, iwl9461_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x00A0, iwl9462_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x00A4, iwl9462_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x0230, iwl9560_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x0234, iwl9560_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x0238, iwl9560_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x023C, iwl9560_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x0260, iwl9461_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x0264, iwl9461_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x02A0, iwl9462_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x02A4, iwl9462_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x1030, iwl9560_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x1551, killer1550s_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x1552, killer1550i_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x2030, iwl9560_2ac_160_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x2034, iwl9560_2ac_160_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x4030, iwl9560_2ac_160_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x4034, iwl9560_2ac_160_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x40A4, iwl9462_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x4234, iwl9560_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x42A4, iwl9462_2ac_cfg_qu_b0_jf_b0)},
+
 	{IWL_PCI_DEVICE(0xA370, 0x0030, iwl9560_2ac_160_cfg_soc)},
 	{IWL_PCI_DEVICE(0xA370, 0x0034, iwl9560_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0xA370, 0x0038, iwl9560_2ac_160_cfg_soc)},


