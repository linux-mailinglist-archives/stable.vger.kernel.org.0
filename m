Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB4B2F14D0
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbhAKNPe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:15:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:33732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731823AbhAKNPd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:15:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0431521973;
        Mon, 11 Jan 2021 13:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370917;
        bh=G0HOX0nuJv1P8Dh+8TKWpgFh/t97RqxkK7ycDDfEzLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gOzBJhx/29uN+bNDIg17fW0mM3omEL+0+2gxDNGo2NyeAMpQCNPxHYjuKiEyNe2k2
         w0Akhtv4W1/rzZ/CkOk2l1KvDAJ8fLhsptSDLhTrvTtaEHVqgXO/9NBhLLb3CcKS/f
         IP+HE0+vNsfBiUi4//yQG9Lv9ku6y4eJkYa/pL+U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mario Limonciello <mario.limonciello@dell.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Yijun Shen <Yijun.shen@dell.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.10 030/145] e1000e: Export S0ix flags to ethtool
Date:   Mon, 11 Jan 2021 14:00:54 +0100
Message-Id: <20210111130049.959182146@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@dell.com>

[ Upstream commit 3c98cbf22a96c1b12f48c1b2a4680dfe5cb280f9 ]

This flag can be used by an end user to disable S0ix flows on a
buggy system or by an OEM for development purposes.

If you need this flag to be persisted across reboots, it's suggested
to use a udev rule to call adjust it until the kernel could have your
configuration in a disallow list.

Signed-off-by: Mario Limonciello <mario.limonciello@dell.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Tested-by: Yijun Shen <Yijun.shen@dell.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/e1000e/e1000.h   |    1 
 drivers/net/ethernet/intel/e1000e/ethtool.c |   46 ++++++++++++++++++++++++++++
 drivers/net/ethernet/intel/e1000e/netdev.c  |    9 +++--
 3 files changed, 52 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/intel/e1000e/e1000.h
+++ b/drivers/net/ethernet/intel/e1000e/e1000.h
@@ -436,6 +436,7 @@ s32 e1000e_get_base_timinca(struct e1000
 #define FLAG2_DFLT_CRC_STRIPPING          BIT(12)
 #define FLAG2_CHECK_RX_HWTSTAMP           BIT(13)
 #define FLAG2_CHECK_SYSTIM_OVERFLOW       BIT(14)
+#define FLAG2_ENABLE_S0IX_FLOWS           BIT(15)
 
 #define E1000_RX_DESC_PS(R, i)	    \
 	(&(((union e1000_rx_desc_packet_split *)((R).desc))[i]))
--- a/drivers/net/ethernet/intel/e1000e/ethtool.c
+++ b/drivers/net/ethernet/intel/e1000e/ethtool.c
@@ -23,6 +23,13 @@ struct e1000_stats {
 	int stat_offset;
 };
 
+static const char e1000e_priv_flags_strings[][ETH_GSTRING_LEN] = {
+#define E1000E_PRIV_FLAGS_S0IX_ENABLED	BIT(0)
+	"s0ix-enabled",
+};
+
+#define E1000E_PRIV_FLAGS_STR_LEN ARRAY_SIZE(e1000e_priv_flags_strings)
+
 #define E1000_STAT(str, m) { \
 		.stat_string = str, \
 		.type = E1000_STATS, \
@@ -1776,6 +1783,8 @@ static int e1000e_get_sset_count(struct
 		return E1000_TEST_LEN;
 	case ETH_SS_STATS:
 		return E1000_STATS_LEN;
+	case ETH_SS_PRIV_FLAGS:
+		return E1000E_PRIV_FLAGS_STR_LEN;
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -2097,6 +2106,10 @@ static void e1000_get_strings(struct net
 			p += ETH_GSTRING_LEN;
 		}
 		break;
+	case ETH_SS_PRIV_FLAGS:
+		memcpy(data, e1000e_priv_flags_strings,
+		       E1000E_PRIV_FLAGS_STR_LEN * ETH_GSTRING_LEN);
+		break;
 	}
 }
 
@@ -2305,6 +2318,37 @@ static int e1000e_get_ts_info(struct net
 	return 0;
 }
 
+static u32 e1000e_get_priv_flags(struct net_device *netdev)
+{
+	struct e1000_adapter *adapter = netdev_priv(netdev);
+	u32 priv_flags = 0;
+
+	if (adapter->flags2 & FLAG2_ENABLE_S0IX_FLOWS)
+		priv_flags |= E1000E_PRIV_FLAGS_S0IX_ENABLED;
+
+	return priv_flags;
+}
+
+static int e1000e_set_priv_flags(struct net_device *netdev, u32 priv_flags)
+{
+	struct e1000_adapter *adapter = netdev_priv(netdev);
+	unsigned int flags2 = adapter->flags2;
+
+	flags2 &= ~FLAG2_ENABLE_S0IX_FLOWS;
+	if (priv_flags & E1000E_PRIV_FLAGS_S0IX_ENABLED) {
+		struct e1000_hw *hw = &adapter->hw;
+
+		if (hw->mac.type < e1000_pch_cnp)
+			return -EINVAL;
+		flags2 |= FLAG2_ENABLE_S0IX_FLOWS;
+	}
+
+	if (flags2 != adapter->flags2)
+		adapter->flags2 = flags2;
+
+	return 0;
+}
+
 static const struct ethtool_ops e1000_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_RX_USECS,
 	.get_drvinfo		= e1000_get_drvinfo,
@@ -2336,6 +2380,8 @@ static const struct ethtool_ops e1000_et
 	.set_eee		= e1000e_set_eee,
 	.get_link_ksettings	= e1000_get_link_ksettings,
 	.set_link_ksettings	= e1000_set_link_ksettings,
+	.get_priv_flags		= e1000e_get_priv_flags,
+	.set_priv_flags		= e1000e_set_priv_flags,
 };
 
 void e1000e_set_ethtool_ops(struct net_device *netdev)
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -6923,7 +6923,6 @@ static __maybe_unused int e1000e_pm_susp
 	struct net_device *netdev = pci_get_drvdata(to_pci_dev(dev));
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 	struct pci_dev *pdev = to_pci_dev(dev);
-	struct e1000_hw *hw = &adapter->hw;
 	int rc;
 
 	e1000e_flush_lpic(pdev);
@@ -6935,7 +6934,7 @@ static __maybe_unused int e1000e_pm_susp
 		e1000e_pm_thaw(dev);
 	} else {
 		/* Introduce S0ix implementation */
-		if (hw->mac.type >= e1000_pch_cnp)
+		if (adapter->flags2 & FLAG2_ENABLE_S0IX_FLOWS)
 			e1000e_s0ix_entry_flow(adapter);
 	}
 
@@ -6947,11 +6946,10 @@ static __maybe_unused int e1000e_pm_resu
 	struct net_device *netdev = pci_get_drvdata(to_pci_dev(dev));
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 	struct pci_dev *pdev = to_pci_dev(dev);
-	struct e1000_hw *hw = &adapter->hw;
 	int rc;
 
 	/* Introduce S0ix implementation */
-	if (hw->mac.type >= e1000_pch_cnp)
+	if (adapter->flags2 & FLAG2_ENABLE_S0IX_FLOWS)
 		e1000e_s0ix_exit_flow(adapter);
 
 	rc = __e1000_resume(pdev);
@@ -7615,6 +7613,9 @@ static int e1000_probe(struct pci_dev *p
 	if (!(adapter->flags & FLAG_HAS_AMT))
 		e1000e_get_hw_control(adapter);
 
+	if (hw->mac.type >= e1000_pch_cnp)
+		adapter->flags2 |= FLAG2_ENABLE_S0IX_FLOWS;
+
 	strlcpy(netdev->name, "eth%d", sizeof(netdev->name));
 	err = register_netdev(netdev);
 	if (err)


