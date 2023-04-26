Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6B676EF476
	for <lists+stable@lfdr.de>; Wed, 26 Apr 2023 14:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240839AbjDZMkZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Apr 2023 08:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240990AbjDZMkO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Apr 2023 08:40:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CF163AA2;
        Wed, 26 Apr 2023 05:39:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DAB24616F9;
        Wed, 26 Apr 2023 12:39:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3620FC433D2;
        Wed, 26 Apr 2023 12:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682512784;
        bh=jEvnqj/ObqlU+xcn36KkZDvixZP74/08rK+ZAU2j1cg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m8kBc7vL4GlCzaQXvx/qsAEHOcIh6Yj/AOmOptlexyuS/XpWO9qJrCL2xCtdSXEjc
         E7uWG25WA+fT8tSF7Dkqt/3PV6wVDLctemqVCDF3hBcbIanYWBHfsPvSwegihtG6bJ
         BMF1rA6cWL0izdtqYS0iawujU+LJldOIZehy6nCI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.10.179
Date:   Wed, 26 Apr 2023 14:39:29 +0200
Message-Id: <2023042629-ambiance-deck-af49@gregkh>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <2023042629-ferocity-silver-5f1c@gregkh>
References: <2023042629-ferocity-silver-5f1c@gregkh>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/kernel-hacking/locking.rst b/Documentation/kernel-hacking/locking.rst
index 6ed806e6061b..a6d89efede79 100644
--- a/Documentation/kernel-hacking/locking.rst
+++ b/Documentation/kernel-hacking/locking.rst
@@ -1358,7 +1358,7 @@ Mutex API reference
 Futex API reference
 ===================
 
-.. kernel-doc:: kernel/futex.c
+.. kernel-doc:: kernel/futex/core.c
    :internal:
 
 Further reading
diff --git a/Documentation/powerpc/associativity.rst b/Documentation/powerpc/associativity.rst
index 07e7dd3d6c87..4d01c7368561 100644
--- a/Documentation/powerpc/associativity.rst
+++ b/Documentation/powerpc/associativity.rst
@@ -1,6 +1,6 @@
 ============================
 NUMA resource associativity
-=============================
+============================
 
 Associativity represents the groupings of the various platform resources into
 domains of substantially similar mean performance relative to resources outside
@@ -20,11 +20,11 @@ A value of 1 indicates the usage of Form 1 associativity. For Form 2 associativi
 bit 2 of byte 5 in the "ibm,architecture-vec-5" property is used.
 
 Form 0
------
+------
 Form 0 associativity supports only two NUMA distances (LOCAL and REMOTE).
 
 Form 1
------
+------
 With Form 1 a combination of ibm,associativity-reference-points, and ibm,associativity
 device tree properties are used to determine the NUMA distance between resource groups/domains.
 
@@ -78,17 +78,18 @@ numa-lookup-index-table.
 
 For ex:
 ibm,numa-lookup-index-table = <3 0 8 40>;
-ibm,numa-distace-table = <9>, /bits/ 8 < 10  20  80
-					 20  10 160
-					 80 160  10>;
-  | 0    8   40
---|------------
-  |
-0 | 10   20  80
-  |
-8 | 20   10  160
-  |
-40| 80   160  10
+ibm,numa-distace-table = <9>, /bits/ 8 < 10  20  80 20  10 160 80 160  10>;
+
+::
+
+	  | 0    8   40
+	--|------------
+	  |
+	0 | 10   20  80
+	  |
+	8 | 20   10  160
+	  |
+	40| 80   160  10
 
 A possible "ibm,associativity" property for resources in node 0, 8 and 40
 
diff --git a/Documentation/powerpc/index.rst b/Documentation/powerpc/index.rst
index 6ec64b0d5257..4663b72caab8 100644
--- a/Documentation/powerpc/index.rst
+++ b/Documentation/powerpc/index.rst
@@ -7,6 +7,7 @@ powerpc
 .. toctree::
     :maxdepth: 1
 
+    associativity
     booting
     bootwrapper
     cpu_families
diff --git a/Documentation/translations/it_IT/kernel-hacking/locking.rst b/Documentation/translations/it_IT/kernel-hacking/locking.rst
index bf1acd6204ef..192ab8e28125 100644
--- a/Documentation/translations/it_IT/kernel-hacking/locking.rst
+++ b/Documentation/translations/it_IT/kernel-hacking/locking.rst
@@ -1400,7 +1400,7 @@ Riferimento per l'API dei Mutex
 Riferimento per l'API dei Futex
 ===============================
 
-.. kernel-doc:: kernel/futex.c
+.. kernel-doc:: kernel/futex/core.c
    :internal:
 
 Approfondimenti
diff --git a/Makefile b/Makefile
index 3bde04cc7f04..3ddcade4be8f 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 10
-SUBLEVEL = 178
+SUBLEVEL = 179
 EXTRAVERSION =
 NAME = Dare mighty things
 
diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index aab28161b9ae..250a03a066a1 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -959,7 +959,7 @@ wdt: watchdog@ff800000 {
 		status = "disabled";
 	};
 
-	spdif: sound@ff88b0000 {
+	spdif: sound@ff8b0000 {
 		compatible = "rockchip,rk3288-spdif", "rockchip,rk3066-spdif";
 		reg = <0x0 0xff8b0000 0x0 0x10000>;
 		#sound-dai-cells = <0>;
diff --git a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
index c0defb36592d..9dd9f7715fbe 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
@@ -1604,10 +1604,9 @@ usb2_phy0: phy@36000 {
 
 			dmc: bus@38000 {
 				compatible = "simple-bus";
-				reg = <0x0 0x38000 0x0 0x400>;
 				#address-cells = <2>;
 				#size-cells = <2>;
-				ranges = <0x0 0x0 0x0 0x38000 0x0 0x400>;
+				ranges = <0x0 0x0 0x0 0x38000 0x0 0x2000>;
 
 				canvas: video-lut@48 {
 					compatible = "amlogic,canvas";
diff --git a/arch/arm64/boot/dts/freescale/imx8mm-evk.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-evk.dtsi
index 521eb3a5a12e..ed6d296bd664 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-evk.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-evk.dtsi
@@ -128,7 +128,7 @@ pmic@4b {
 		rohm,reset-snvs-powered;
 
 		#clock-cells = <0>;
-		clocks = <&osc_32k 0>;
+		clocks = <&osc_32k>;
 		clock-output-names = "clk-32k-out";
 
 		regulators {
diff --git a/arch/arm64/boot/dts/qcom/ipq8074-hk01.dts b/arch/arm64/boot/dts/qcom/ipq8074-hk01.dts
index cc08dc4eb56a..68698cdf56c4 100644
--- a/arch/arm64/boot/dts/qcom/ipq8074-hk01.dts
+++ b/arch/arm64/boot/dts/qcom/ipq8074-hk01.dts
@@ -60,11 +60,11 @@ &pcie1 {
 	perst-gpio = <&tlmm 58 0x1>;
 };
 
-&pcie_phy0 {
+&pcie_qmp0 {
 	status = "okay";
 };
 
-&pcie_phy1 {
+&pcie_qmp1 {
 	status = "okay";
 };
 
diff --git a/arch/mips/kernel/vmlinux.lds.S b/arch/mips/kernel/vmlinux.lds.S
index 09fa4705ce8e..64afe075df08 100644
--- a/arch/mips/kernel/vmlinux.lds.S
+++ b/arch/mips/kernel/vmlinux.lds.S
@@ -15,6 +15,8 @@
 #define EMITS_PT_NOTE
 #endif
 
+#define RUNTIME_DISCARD_EXIT
+
 #include <asm-generic/vmlinux.lds.h>
 
 #undef mips
diff --git a/arch/s390/kernel/ptrace.c b/arch/s390/kernel/ptrace.c
index a76dd27fb2e8..3009bb527252 100644
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -500,9 +500,7 @@ long arch_ptrace(struct task_struct *child, long request,
 		}
 		return 0;
 	case PTRACE_GET_LAST_BREAK:
-		put_user(child->thread.last_break,
-			 (unsigned long __user *) data);
-		return 0;
+		return put_user(child->thread.last_break, (unsigned long __user *)data);
 	case PTRACE_ENABLE_TE:
 		if (!MACHINE_HAS_TE)
 			return -EIO;
@@ -854,9 +852,7 @@ long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
 		}
 		return 0;
 	case PTRACE_GET_LAST_BREAK:
-		put_user(child->thread.last_break,
-			 (unsigned int __user *) data);
-		return 0;
+		return put_user(child->thread.last_break, (unsigned int __user *)data);
 	}
 	return compat_ptrace_request(child, request, addr, data);
 }
diff --git a/arch/x86/purgatory/Makefile b/arch/x86/purgatory/Makefile
index 95ea17a9d20c..ebaf329a2368 100644
--- a/arch/x86/purgatory/Makefile
+++ b/arch/x86/purgatory/Makefile
@@ -64,8 +64,7 @@ CFLAGS_sha256.o			+= $(PURGATORY_CFLAGS)
 CFLAGS_REMOVE_string.o		+= $(PURGATORY_CFLAGS_REMOVE)
 CFLAGS_string.o			+= $(PURGATORY_CFLAGS)
 
-AFLAGS_REMOVE_setup-x86_$(BITS).o	+= -Wa,-gdwarf-2
-AFLAGS_REMOVE_entry64.o			+= -Wa,-gdwarf-2
+asflags-remove-y		+= -g -Wa,-gdwarf-2
 
 $(obj)/purgatory.ro: $(PURGATORY_OBJS) FORCE
 		$(call if_changed,ld)
diff --git a/drivers/iio/adc/at91-sama5d2_adc.c b/drivers/iio/adc/at91-sama5d2_adc.c
index 250b78ee1625..b806c1ab9b61 100644
--- a/drivers/iio/adc/at91-sama5d2_adc.c
+++ b/drivers/iio/adc/at91-sama5d2_adc.c
@@ -1002,7 +1002,7 @@ static struct iio_trigger *at91_adc_allocate_trigger(struct iio_dev *indio,
 	trig = devm_iio_trigger_alloc(&indio->dev, "%s-dev%d-%s", indio->name,
 				      indio->id, trigger_name);
 	if (!trig)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	trig->dev.parent = indio->dev.parent;
 	iio_trigger_set_drvdata(trig, indio);
diff --git a/drivers/iio/light/tsl2772.c b/drivers/iio/light/tsl2772.c
index d79205361dfa..ff33ad371420 100644
--- a/drivers/iio/light/tsl2772.c
+++ b/drivers/iio/light/tsl2772.c
@@ -606,6 +606,7 @@ static int tsl2772_read_prox_diodes(struct tsl2772_chip *chip)
 			return -EINVAL;
 		}
 	}
+	chip->settings.prox_diode = prox_diode_mask;
 
 	return 0;
 }
diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index 65c0081838e3..9dcdf21c50bd 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -601,6 +601,14 @@ static const struct dmi_system_id i8042_dmi_quirk_table[] __initconst = {
 		},
 		.driver_data = (void *)(SERIO_QUIRK_NOMUX)
 	},
+	{
+		/* Fujitsu Lifebook A574/H */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "FMVA0501PZ"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX)
+	},
 	{
 		/* Gigabyte M912 */
 		.matches = {
diff --git a/drivers/memstick/core/memstick.c b/drivers/memstick/core/memstick.c
index 12bc3f5a6cbb..1c7a9dcfed65 100644
--- a/drivers/memstick/core/memstick.c
+++ b/drivers/memstick/core/memstick.c
@@ -412,6 +412,7 @@ static struct memstick_dev *memstick_alloc_card(struct memstick_host *host)
 	return card;
 err_out:
 	host->card = old_card;
+	kfree_const(card->dev.kobj.name);
 	kfree(card);
 	return NULL;
 }
@@ -470,8 +471,10 @@ static void memstick_check(struct work_struct *work)
 				put_device(&card->dev);
 				host->card = NULL;
 			}
-		} else
+		} else {
+			kfree_const(card->dev.kobj.name);
 			kfree(card);
+		}
 	}
 
 out_power_off:
diff --git a/drivers/mmc/host/sdhci_am654.c b/drivers/mmc/host/sdhci_am654.c
index bf2592774165..8e52905458f9 100644
--- a/drivers/mmc/host/sdhci_am654.c
+++ b/drivers/mmc/host/sdhci_am654.c
@@ -351,8 +351,6 @@ static void sdhci_am654_write_b(struct sdhci_host *host, u8 val, int reg)
 		 */
 		case MMC_TIMING_SD_HS:
 		case MMC_TIMING_MMC_HS:
-		case MMC_TIMING_UHS_SDR12:
-		case MMC_TIMING_UHS_SDR25:
 			val &= ~SDHCI_CTRL_HISPD;
 		}
 	}
diff --git a/drivers/net/dsa/b53/b53_mmap.c b/drivers/net/dsa/b53/b53_mmap.c
index c628d0980c0b..1d52cb3e46d5 100644
--- a/drivers/net/dsa/b53/b53_mmap.c
+++ b/drivers/net/dsa/b53/b53_mmap.c
@@ -215,6 +215,18 @@ static int b53_mmap_write64(struct b53_device *dev, u8 page, u8 reg,
 	return 0;
 }
 
+static int b53_mmap_phy_read16(struct b53_device *dev, int addr, int reg,
+			       u16 *value)
+{
+	return -EIO;
+}
+
+static int b53_mmap_phy_write16(struct b53_device *dev, int addr, int reg,
+				u16 value)
+{
+	return -EIO;
+}
+
 static const struct b53_io_ops b53_mmap_ops = {
 	.read8 = b53_mmap_read8,
 	.read16 = b53_mmap_read16,
@@ -226,6 +238,8 @@ static const struct b53_io_ops b53_mmap_ops = {
 	.write32 = b53_mmap_write32,
 	.write48 = b53_mmap_write48,
 	.write64 = b53_mmap_write64,
+	.phy_read16 = b53_mmap_phy_read16,
+	.phy_write16 = b53_mmap_phy_write16,
 };
 
 static int b53_mmap_probe(struct platform_device *pdev)
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index ae0c9aaab48d..b700663a634d 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -5294,31 +5294,6 @@ static void e1000_watchdog_task(struct work_struct *work)
 				ew32(TARC(0), tarc0);
 			}
 
-			/* disable TSO for pcie and 10/100 speeds, to avoid
-			 * some hardware issues
-			 */
-			if (!(adapter->flags & FLAG_TSO_FORCE)) {
-				switch (adapter->link_speed) {
-				case SPEED_10:
-				case SPEED_100:
-					e_info("10/100 speed: disabling TSO\n");
-					netdev->features &= ~NETIF_F_TSO;
-					netdev->features &= ~NETIF_F_TSO6;
-					break;
-				case SPEED_1000:
-					netdev->features |= NETIF_F_TSO;
-					netdev->features |= NETIF_F_TSO6;
-					break;
-				default:
-					/* oops */
-					break;
-				}
-				if (hw->mac.type == e1000_pch_spt) {
-					netdev->features &= ~NETIF_F_TSO;
-					netdev->features &= ~NETIF_F_TSO6;
-				}
-			}
-
 			/* enable transmits in the hardware, need to do this
 			 * after setting TARC(0)
 			 */
@@ -7477,6 +7452,32 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			    NETIF_F_RXCSUM |
 			    NETIF_F_HW_CSUM);
 
+	/* disable TSO for pcie and 10/100 speeds to avoid
+	 * some hardware issues and for i219 to fix transfer
+	 * speed being capped at 60%
+	 */
+	if (!(adapter->flags & FLAG_TSO_FORCE)) {
+		switch (adapter->link_speed) {
+		case SPEED_10:
+		case SPEED_100:
+			e_info("10/100 speed: disabling TSO\n");
+			netdev->features &= ~NETIF_F_TSO;
+			netdev->features &= ~NETIF_F_TSO6;
+			break;
+		case SPEED_1000:
+			netdev->features |= NETIF_F_TSO;
+			netdev->features |= NETIF_F_TSO6;
+			break;
+		default:
+			/* oops */
+			break;
+		}
+		if (hw->mac.type == e1000_pch_spt) {
+			netdev->features &= ~NETIF_F_TSO;
+			netdev->features &= ~NETIF_F_TSO6;
+		}
+	}
+
 	/* Set user-changeable features (subset of all device features) */
 	netdev->hw_features = netdev->features;
 	netdev->hw_features |= NETIF_F_RXFCS;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 76481ff7074b..d23a467d0d20 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -10448,8 +10448,11 @@ static void i40e_rebuild(struct i40e_pf *pf, bool reinit, bool lock_acquired)
 					     pf->hw.aq.asq_last_status));
 	}
 	/* reinit the misc interrupt */
-	if (pf->flags & I40E_FLAG_MSIX_ENABLED)
+	if (pf->flags & I40E_FLAG_MSIX_ENABLED) {
 		ret = i40e_setup_misc_vector(pf);
+		if (ret)
+			goto end_unlock;
+	}
 
 	/* Add a filter to drop all Flow control frames from any VSI from being
 	 * transmitted. By doing so we stop a malicious VF from sending out
@@ -13458,15 +13461,15 @@ static int i40e_add_vsi(struct i40e_vsi *vsi)
 		vsi->id = ctxt.vsi_number;
 	}
 
-	vsi->active_filters = 0;
-	clear_bit(__I40E_VSI_OVERFLOW_PROMISC, vsi->state);
 	spin_lock_bh(&vsi->mac_filter_hash_lock);
+	vsi->active_filters = 0;
 	/* If macvlan filters already exist, force them to get loaded */
 	hash_for_each_safe(vsi->mac_filter_hash, bkt, h, f, hlist) {
 		f->state = I40E_FILTER_NEW;
 		f_count++;
 	}
 	spin_unlock_bh(&vsi->mac_filter_hash_lock);
+	clear_bit(__I40E_VSI_OVERFLOW_PROMISC, vsi->state);
 
 	if (f_count) {
 		vsi->flags |= I40E_VSI_FLAG_FILTER_CHANGED;
diff --git a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_mfa2_tlv_multi.c b/drivers/net/ethernet/mellanox/mlxfw/mlxfw_mfa2_tlv_multi.c
index 017d68f1e123..972c571b4158 100644
--- a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_mfa2_tlv_multi.c
+++ b/drivers/net/ethernet/mellanox/mlxfw/mlxfw_mfa2_tlv_multi.c
@@ -31,6 +31,8 @@ mlxfw_mfa2_tlv_next(const struct mlxfw_mfa2_file *mfa2_file,
 
 	if (tlv->type == MLXFW_MFA2_TLV_MULTI_PART) {
 		multi = mlxfw_mfa2_tlv_multi_get(mfa2_file, tlv);
+		if (!multi)
+			return NULL;
 		tlv_len = NLA_ALIGN(tlv_len + be16_to_cpu(multi->total_len));
 	}
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h b/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h
index a2c1fbd3e0d1..0225c8f1e5ea 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h
@@ -26,7 +26,7 @@
 #define MLXSW_PCI_CIR_TIMEOUT_MSECS		1000
 
 #define MLXSW_PCI_SW_RESET_TIMEOUT_MSECS	900000
-#define MLXSW_PCI_SW_RESET_WAIT_MSECS		200
+#define MLXSW_PCI_SW_RESET_WAIT_MSECS		400
 #define MLXSW_PCI_FW_READY			0xA1844
 #define MLXSW_PCI_FW_READY_MASK			0xFFFF
 #define MLXSW_PCI_FW_READY_MAGIC		0x5E
diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
index 63a44ee763be..b9429e8faba1 100644
--- a/drivers/net/ethernet/sfc/ef100_netdev.c
+++ b/drivers/net/ethernet/sfc/ef100_netdev.c
@@ -96,6 +96,8 @@ static int ef100_net_stop(struct net_device *net_dev)
 	efx_mcdi_free_vis(efx);
 	efx_remove_interrupts(efx);
 
+	efx->state = STATE_NET_DOWN;
+
 	return 0;
 }
 
@@ -172,6 +174,8 @@ static int ef100_net_open(struct net_device *net_dev)
 		efx_link_status_changed(efx);
 	mutex_unlock(&efx->mac_lock);
 
+	efx->state = STATE_NET_UP;
+
 	return 0;
 
 fail:
@@ -272,7 +276,7 @@ int ef100_register_netdev(struct efx_nic *efx)
 	/* Always start with carrier off; PHY events will detect the link */
 	netif_carrier_off(net_dev);
 
-	efx->state = STATE_READY;
+	efx->state = STATE_NET_DOWN;
 	rtnl_unlock();
 	efx_init_mcdi_logging(efx);
 
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index c069659c9e2d..7cf52fcdb307 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -105,14 +105,6 @@ static int efx_xdp(struct net_device *dev, struct netdev_bpf *xdp);
 static int efx_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **xdpfs,
 			u32 flags);
 
-#define EFX_ASSERT_RESET_SERIALISED(efx)		\
-	do {						\
-		if ((efx->state == STATE_READY) ||	\
-		    (efx->state == STATE_RECOVERY) ||	\
-		    (efx->state == STATE_DISABLED))	\
-			ASSERT_RTNL();			\
-	} while (0)
-
 /**************************************************************************
  *
  * Port handling
@@ -377,6 +369,8 @@ static int efx_probe_all(struct efx_nic *efx)
 	if (rc)
 		goto fail5;
 
+	efx->state = STATE_NET_DOWN;
+
 	return 0;
 
  fail5:
@@ -543,7 +537,9 @@ int efx_net_open(struct net_device *net_dev)
 	efx_start_all(efx);
 	if (efx->state == STATE_DISABLED || efx->reset_pending)
 		netif_device_detach(efx->net_dev);
-	efx_selftest_async_start(efx);
+	else
+		efx->state = STATE_NET_UP;
+
 	return 0;
 }
 
@@ -721,8 +717,6 @@ static int efx_register_netdev(struct efx_nic *efx)
 	 * already requested.  If so, the NIC is probably hosed so we
 	 * abort.
 	 */
-	efx->state = STATE_READY;
-	smp_mb(); /* ensure we change state before checking reset_pending */
 	if (efx->reset_pending) {
 		netif_err(efx, probe, efx->net_dev,
 			  "aborting probe due to scheduled reset\n");
@@ -750,6 +744,8 @@ static int efx_register_netdev(struct efx_nic *efx)
 
 	efx_associate(efx);
 
+	efx->state = STATE_NET_DOWN;
+
 	rtnl_unlock();
 
 	rc = device_create_file(&efx->pci_dev->dev, &dev_attr_phy_type);
@@ -851,7 +847,7 @@ static void efx_pci_remove_main(struct efx_nic *efx)
 	/* Flush reset_work. It can no longer be scheduled since we
 	 * are not READY.
 	 */
-	BUG_ON(efx->state == STATE_READY);
+	WARN_ON(efx_net_active(efx->state));
 	efx_flush_reset_workqueue(efx);
 
 	efx_disable_interrupts(efx);
@@ -1196,13 +1192,13 @@ static int efx_pm_freeze(struct device *dev)
 
 	rtnl_lock();
 
-	if (efx->state != STATE_DISABLED) {
-		efx->state = STATE_UNINIT;
-
+	if (efx_net_active(efx->state)) {
 		efx_device_detach_sync(efx);
 
 		efx_stop_all(efx);
 		efx_disable_interrupts(efx);
+
+		efx->state = efx_freeze(efx->state);
 	}
 
 	rtnl_unlock();
@@ -1217,7 +1213,7 @@ static int efx_pm_thaw(struct device *dev)
 
 	rtnl_lock();
 
-	if (efx->state != STATE_DISABLED) {
+	if (efx_frozen(efx->state)) {
 		rc = efx_enable_interrupts(efx);
 		if (rc)
 			goto fail;
@@ -1230,7 +1226,7 @@ static int efx_pm_thaw(struct device *dev)
 
 		efx_device_attach_if_not_resetting(efx);
 
-		efx->state = STATE_READY;
+		efx->state = efx_thaw(efx->state);
 
 		efx->type->resume_wol(efx);
 	}
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index de797e1ac5a9..476ef1c97637 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -542,6 +542,8 @@ void efx_start_all(struct efx_nic *efx)
 	/* Start the hardware monitor if there is one */
 	efx_start_monitor(efx);
 
+	efx_selftest_async_start(efx);
+
 	/* Link state detection is normally event-driven; we have
 	 * to poll now because we could have missed a change
 	 */
@@ -897,7 +899,7 @@ static void efx_reset_work(struct work_struct *data)
 	 * have changed by now.  Now that we have the RTNL lock,
 	 * it cannot change again.
 	 */
-	if (efx->state == STATE_READY)
+	if (efx_net_active(efx->state))
 		(void)efx_reset(efx, method);
 
 	rtnl_unlock();
@@ -907,7 +909,7 @@ void efx_schedule_reset(struct efx_nic *efx, enum reset_type type)
 {
 	enum reset_type method;
 
-	if (efx->state == STATE_RECOVERY) {
+	if (efx_recovering(efx->state)) {
 		netif_dbg(efx, drv, efx->net_dev,
 			  "recovering: skip scheduling %s reset\n",
 			  RESET_TYPE(type));
@@ -942,7 +944,7 @@ void efx_schedule_reset(struct efx_nic *efx, enum reset_type type)
 	/* If we're not READY then just leave the flags set as the cue
 	 * to abort probing or reschedule the reset later.
 	 */
-	if (READ_ONCE(efx->state) != STATE_READY)
+	if (!efx_net_active(READ_ONCE(efx->state)))
 		return;
 
 	/* efx_process_channel() will no longer read events once a
@@ -1214,7 +1216,7 @@ static pci_ers_result_t efx_io_error_detected(struct pci_dev *pdev,
 	rtnl_lock();
 
 	if (efx->state != STATE_DISABLED) {
-		efx->state = STATE_RECOVERY;
+		efx->state = efx_recover(efx->state);
 		efx->reset_pending = 0;
 
 		efx_device_detach_sync(efx);
@@ -1268,7 +1270,7 @@ static void efx_io_resume(struct pci_dev *pdev)
 		netif_err(efx, hw, efx->net_dev,
 			  "efx_reset failed after PCI error (%d)\n", rc);
 	} else {
-		efx->state = STATE_READY;
+		efx->state = efx_recovered(efx->state);
 		netif_dbg(efx, hw, efx->net_dev,
 			  "Done resetting and resuming IO after PCI error.\n");
 	}
diff --git a/drivers/net/ethernet/sfc/efx_common.h b/drivers/net/ethernet/sfc/efx_common.h
index 65513fd0cf6c..c72e819da8fd 100644
--- a/drivers/net/ethernet/sfc/efx_common.h
+++ b/drivers/net/ethernet/sfc/efx_common.h
@@ -45,9 +45,7 @@ int efx_reconfigure_port(struct efx_nic *efx);
 
 #define EFX_ASSERT_RESET_SERIALISED(efx)		\
 	do {						\
-		if ((efx->state == STATE_READY) ||	\
-		    (efx->state == STATE_RECOVERY) ||	\
-		    (efx->state == STATE_DISABLED))	\
+		if (efx->state != STATE_UNINIT)		\
 			ASSERT_RTNL();			\
 	} while (0)
 
@@ -64,7 +62,7 @@ void efx_port_dummy_op_void(struct efx_nic *efx);
 
 static inline int efx_check_disabled(struct efx_nic *efx)
 {
-	if (efx->state == STATE_DISABLED || efx->state == STATE_RECOVERY) {
+	if (efx->state == STATE_DISABLED || efx_recovering(efx->state)) {
 		netif_err(efx, drv, efx->net_dev,
 			  "device is disabled due to earlier errors\n");
 		return -EIO;
diff --git a/drivers/net/ethernet/sfc/ethtool_common.c b/drivers/net/ethernet/sfc/ethtool_common.c
index bd552c7dffcb..3846b76b8972 100644
--- a/drivers/net/ethernet/sfc/ethtool_common.c
+++ b/drivers/net/ethernet/sfc/ethtool_common.c
@@ -137,7 +137,7 @@ void efx_ethtool_self_test(struct net_device *net_dev,
 	if (!efx_tests)
 		goto fail;
 
-	if (efx->state != STATE_READY) {
+	if (!efx_net_active(efx->state)) {
 		rc = -EBUSY;
 		goto out;
 	}
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 8aecb4bd2c0d..39f97929b3ff 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -627,12 +627,54 @@ enum efx_int_mode {
 #define EFX_INT_MODE_USE_MSI(x) (((x)->interrupt_mode) <= EFX_INT_MODE_MSI)
 
 enum nic_state {
-	STATE_UNINIT = 0,	/* device being probed/removed or is frozen */
-	STATE_READY = 1,	/* hardware ready and netdev registered */
-	STATE_DISABLED = 2,	/* device disabled due to hardware errors */
-	STATE_RECOVERY = 3,	/* device recovering from PCI error */
+	STATE_UNINIT = 0,	/* device being probed/removed */
+	STATE_NET_DOWN,		/* hardware probed and netdev registered */
+	STATE_NET_UP,		/* ready for traffic */
+	STATE_DISABLED,		/* device disabled due to hardware errors */
+
+	STATE_RECOVERY = 0x100,/* recovering from PCI error */
+	STATE_FROZEN = 0x200,	/* frozen by power management */
 };
 
+static inline bool efx_net_active(enum nic_state state)
+{
+	return state == STATE_NET_DOWN || state == STATE_NET_UP;
+}
+
+static inline bool efx_frozen(enum nic_state state)
+{
+	return state & STATE_FROZEN;
+}
+
+static inline bool efx_recovering(enum nic_state state)
+{
+	return state & STATE_RECOVERY;
+}
+
+static inline enum nic_state efx_freeze(enum nic_state state)
+{
+	WARN_ON(!efx_net_active(state));
+	return state | STATE_FROZEN;
+}
+
+static inline enum nic_state efx_thaw(enum nic_state state)
+{
+	WARN_ON(!efx_frozen(state));
+	return state & ~STATE_FROZEN;
+}
+
+static inline enum nic_state efx_recover(enum nic_state state)
+{
+	WARN_ON(!efx_net_active(state));
+	return state | STATE_RECOVERY;
+}
+
+static inline enum nic_state efx_recovered(enum nic_state state)
+{
+	WARN_ON(!efx_recovering(state));
+	return state & ~STATE_RECOVERY;
+}
+
 /* Forward declaration */
 struct efx_nic;
 
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index d53321116136..47c9118cc92a 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -646,8 +646,13 @@ static struct page *xdp_linearize_page(struct receive_queue *rq,
 				       int page_off,
 				       unsigned int *len)
 {
-	struct page *page = alloc_page(GFP_ATOMIC);
+	int tailroom = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+	struct page *page;
 
+	if (page_off + *len + tailroom > PAGE_SIZE)
+		return NULL;
+
+	page = alloc_page(GFP_ATOMIC);
 	if (!page)
 		return NULL;
 
@@ -655,7 +660,6 @@ static struct page *xdp_linearize_page(struct receive_queue *rq,
 	page_off += *len;
 
 	while (--*num_buf) {
-		int tailroom = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 		unsigned int buflen;
 		void *buf;
 		int off;
diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 67614e7166ac..379ac9ca60b7 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -996,10 +996,8 @@ static void xenvif_tx_build_gops(struct xenvif_queue *queue,
 
 		/* No crossing a page as the payload mustn't fragment. */
 		if (unlikely((txreq.offset + txreq.size) > XEN_PAGE_SIZE)) {
-			netdev_err(queue->vif->dev,
-				   "txreq.offset: %u, size: %u, end: %lu\n",
-				   txreq.offset, txreq.size,
-				   (unsigned long)(txreq.offset&~XEN_PAGE_MASK) + txreq.size);
+			netdev_err(queue->vif->dev, "Cross page boundary, txreq.offset: %u, size: %u\n",
+				   txreq.offset, txreq.size);
 			xenvif_fatal_tx_err(queue->vif);
 			break;
 		}
diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 57df87def8c3..e6147a9220f9 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1535,22 +1535,7 @@ static int nvme_tcp_alloc_queue(struct nvme_ctrl *nctrl,
 	if (ret)
 		goto err_init_connect;
 
-	queue->rd_enabled = true;
 	set_bit(NVME_TCP_Q_ALLOCATED, &queue->flags);
-	nvme_tcp_init_recv_ctx(queue);
-
-	write_lock_bh(&queue->sock->sk->sk_callback_lock);
-	queue->sock->sk->sk_user_data = queue;
-	queue->state_change = queue->sock->sk->sk_state_change;
-	queue->data_ready = queue->sock->sk->sk_data_ready;
-	queue->write_space = queue->sock->sk->sk_write_space;
-	queue->sock->sk->sk_data_ready = nvme_tcp_data_ready;
-	queue->sock->sk->sk_state_change = nvme_tcp_state_change;
-	queue->sock->sk->sk_write_space = nvme_tcp_write_space;
-#ifdef CONFIG_NET_RX_BUSY_POLL
-	queue->sock->sk->sk_ll_usec = 1;
-#endif
-	write_unlock_bh(&queue->sock->sk->sk_callback_lock);
 
 	return 0;
 
@@ -1569,7 +1554,7 @@ static int nvme_tcp_alloc_queue(struct nvme_ctrl *nctrl,
 	return ret;
 }
 
-static void nvme_tcp_restore_sock_calls(struct nvme_tcp_queue *queue)
+static void nvme_tcp_restore_sock_ops(struct nvme_tcp_queue *queue)
 {
 	struct socket *sock = queue->sock;
 
@@ -1584,7 +1569,7 @@ static void nvme_tcp_restore_sock_calls(struct nvme_tcp_queue *queue)
 static void __nvme_tcp_stop_queue(struct nvme_tcp_queue *queue)
 {
 	kernel_sock_shutdown(queue->sock, SHUT_RDWR);
-	nvme_tcp_restore_sock_calls(queue);
+	nvme_tcp_restore_sock_ops(queue);
 	cancel_work_sync(&queue->io_work);
 }
 
@@ -1599,21 +1584,42 @@ static void nvme_tcp_stop_queue(struct nvme_ctrl *nctrl, int qid)
 	mutex_unlock(&queue->queue_lock);
 }
 
+static void nvme_tcp_setup_sock_ops(struct nvme_tcp_queue *queue)
+{
+	write_lock_bh(&queue->sock->sk->sk_callback_lock);
+	queue->sock->sk->sk_user_data = queue;
+	queue->state_change = queue->sock->sk->sk_state_change;
+	queue->data_ready = queue->sock->sk->sk_data_ready;
+	queue->write_space = queue->sock->sk->sk_write_space;
+	queue->sock->sk->sk_data_ready = nvme_tcp_data_ready;
+	queue->sock->sk->sk_state_change = nvme_tcp_state_change;
+	queue->sock->sk->sk_write_space = nvme_tcp_write_space;
+#ifdef CONFIG_NET_RX_BUSY_POLL
+	queue->sock->sk->sk_ll_usec = 1;
+#endif
+	write_unlock_bh(&queue->sock->sk->sk_callback_lock);
+}
+
 static int nvme_tcp_start_queue(struct nvme_ctrl *nctrl, int idx)
 {
 	struct nvme_tcp_ctrl *ctrl = to_tcp_ctrl(nctrl);
+	struct nvme_tcp_queue *queue = &ctrl->queues[idx];
 	int ret;
 
+	queue->rd_enabled = true;
+	nvme_tcp_init_recv_ctx(queue);
+	nvme_tcp_setup_sock_ops(queue);
+
 	if (idx)
 		ret = nvmf_connect_io_queue(nctrl, idx, false);
 	else
 		ret = nvmf_connect_admin_queue(nctrl);
 
 	if (!ret) {
-		set_bit(NVME_TCP_Q_LIVE, &ctrl->queues[idx].flags);
+		set_bit(NVME_TCP_Q_LIVE, &queue->flags);
 	} else {
-		if (test_bit(NVME_TCP_Q_ALLOCATED, &ctrl->queues[idx].flags))
-			__nvme_tcp_stop_queue(&ctrl->queues[idx]);
+		if (test_bit(NVME_TCP_Q_ALLOCATED, &queue->flags))
+			__nvme_tcp_stop_queue(queue);
 		dev_err(nctrl->device,
 			"failed to connect queue: %d ret=%d\n", idx, ret);
 	}
diff --git a/drivers/pwm/pwm-hibvt.c b/drivers/pwm/pwm-hibvt.c
index ad205fdad372..286e9b119ee5 100644
--- a/drivers/pwm/pwm-hibvt.c
+++ b/drivers/pwm/pwm-hibvt.c
@@ -146,6 +146,7 @@ static void hibvt_pwm_get_state(struct pwm_chip *chip, struct pwm_device *pwm,
 
 	value = readl(base + PWM_CTRL_ADDR(pwm->hwpwm));
 	state->enabled = (PWM_ENABLE_MASK & value);
+	state->polarity = (PWM_POLARITY_MASK & value) ? PWM_POLARITY_INVERSED : PWM_POLARITY_NORMAL;
 }
 
 static int hibvt_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
diff --git a/drivers/pwm/pwm-iqs620a.c b/drivers/pwm/pwm-iqs620a.c
index 3e967a12458c..a2aef006cb71 100644
--- a/drivers/pwm/pwm-iqs620a.c
+++ b/drivers/pwm/pwm-iqs620a.c
@@ -132,6 +132,7 @@ static void iqs620_pwm_get_state(struct pwm_chip *chip, struct pwm_device *pwm,
 	mutex_unlock(&iqs620_pwm->lock);
 
 	state->period = IQS620_PWM_PERIOD_NS;
+	state->polarity = PWM_POLARITY_NORMAL;
 }
 
 static int iqs620_pwm_notifier(struct notifier_block *notifier,
diff --git a/drivers/pwm/pwm-meson.c b/drivers/pwm/pwm-meson.c
index bd0d7336b898..237bb8e06593 100644
--- a/drivers/pwm/pwm-meson.c
+++ b/drivers/pwm/pwm-meson.c
@@ -168,6 +168,12 @@ static int meson_pwm_calc(struct meson_pwm *meson, struct pwm_device *pwm,
 	duty = state->duty_cycle;
 	period = state->period;
 
+	/*
+	 * Note this is wrong. The result is an output wave that isn't really
+	 * inverted and so is wrongly identified by .get_state as normal.
+	 * Fixing this needs some care however as some machines might rely on
+	 * this.
+	 */
 	if (state->polarity == PWM_POLARITY_INVERSED)
 		duty = period - duty;
 
@@ -366,6 +372,7 @@ static void meson_pwm_get_state(struct pwm_chip *chip, struct pwm_device *pwm,
 		state->period = 0;
 		state->duty_cycle = 0;
 	}
+	state->polarity = PWM_POLARITY_NORMAL;
 }
 
 static const struct pwm_ops meson_pwm_ops = {
diff --git a/drivers/regulator/fan53555.c b/drivers/regulator/fan53555.c
index aa426183b6a1..1af12074a75a 100644
--- a/drivers/regulator/fan53555.c
+++ b/drivers/regulator/fan53555.c
@@ -8,18 +8,19 @@
 // Copyright (c) 2012 Marvell Technology Ltd.
 // Yunfan Zhang <yfzhang@marvell.com>
 
+#include <linux/bits.h>
+#include <linux/err.h>
+#include <linux/i2c.h>
 #include <linux/module.h>
+#include <linux/of_device.h>
 #include <linux/param.h>
-#include <linux/err.h>
 #include <linux/platform_device.h>
+#include <linux/regmap.h>
 #include <linux/regulator/driver.h>
+#include <linux/regulator/fan53555.h>
 #include <linux/regulator/machine.h>
 #include <linux/regulator/of_regulator.h>
-#include <linux/of_device.h>
-#include <linux/i2c.h>
 #include <linux/slab.h>
-#include <linux/regmap.h>
-#include <linux/regulator/fan53555.h>
 
 /* Voltage setting */
 #define FAN53555_VSEL0		0x00
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 84a2e9292fd0..b5a74b237fd2 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3248,7 +3248,7 @@ fw_crash_buffer_show(struct device *cdev,
 
 	spin_lock_irqsave(&instance->crashdump_lock, flags);
 	buff_offset = instance->fw_crash_buffer_offset;
-	if (!instance->crash_dump_buf &&
+	if (!instance->crash_dump_buf ||
 		!((instance->fw_crash_state == AVAILABLE) ||
 		(instance->fw_crash_state == COPYING))) {
 		dev_err(&instance->pdev->dev,
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 6ad834d61d4c..d6c25a88cebc 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -317,11 +317,18 @@ static int scsi_vpd_inquiry(struct scsi_device *sdev, unsigned char *buffer,
 	if (result)
 		return -EIO;
 
-	/* Sanity check that we got the page back that we asked for */
+	/*
+	 * Sanity check that we got the page back that we asked for and that
+	 * the page size is not 0.
+	 */
 	if (buffer[1] != page)
 		return -EIO;
 
-	return get_unaligned_be16(&buffer[2]) + 4;
+	result = get_unaligned_be16(&buffer[2]);
+	if (!result)
+		return -EIO;
+
+	return result + 4;
 }
 
 /**
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 61cb50e8fcb7..0758f606f006 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -206,7 +206,7 @@ static int ext4_read_inline_data(struct inode *inode, void *buffer,
 /*
  * write the buffer to the inline inode.
  * If 'create' is set, we don't need to do the extra copy in the xattr
- * value since it is already handled by ext4_xattr_ibody_inline_set.
+ * value since it is already handled by ext4_xattr_ibody_set.
  * That saves us one memcpy.
  */
 static void ext4_write_inline_data(struct inode *inode, struct ext4_iloc *iloc,
@@ -288,7 +288,7 @@ static int ext4_create_inline_data(handle_t *handle,
 
 	BUG_ON(!is.s.not_found);
 
-	error = ext4_xattr_ibody_inline_set(handle, inode, &i, &is);
+	error = ext4_xattr_ibody_set(handle, inode, &i, &is);
 	if (error) {
 		if (error == -ENOSPC)
 			ext4_clear_inode_state(inode,
@@ -360,7 +360,7 @@ static int ext4_update_inline_data(handle_t *handle, struct inode *inode,
 	i.value = value;
 	i.value_len = len;
 
-	error = ext4_xattr_ibody_inline_set(handle, inode, &i, &is);
+	error = ext4_xattr_ibody_set(handle, inode, &i, &is);
 	if (error)
 		goto out;
 
@@ -433,7 +433,7 @@ static int ext4_destroy_inline_data_nolock(handle_t *handle,
 	if (error)
 		goto out;
 
-	error = ext4_xattr_ibody_inline_set(handle, inode, &i, &is);
+	error = ext4_xattr_ibody_set(handle, inode, &i, &is);
 	if (error)
 		goto out;
 
@@ -1930,8 +1930,7 @@ int ext4_inline_data_truncate(struct inode *inode, int *has_inline)
 			i.value = value;
 			i.value_len = i_size > EXT4_MIN_INLINE_DATA_SIZE ?
 					i_size - EXT4_MIN_INLINE_DATA_SIZE : 0;
-			err = ext4_xattr_ibody_inline_set(handle, inode,
-							  &i, &is);
+			err = ext4_xattr_ibody_set(handle, inode, &i, &is);
 			if (err)
 				goto out_error;
 		}
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index f3da1f2d4cb9..28fa9a64dc4b 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -2215,7 +2215,7 @@ int ext4_xattr_ibody_find(struct inode *inode, struct ext4_xattr_info *i,
 	return 0;
 }
 
-int ext4_xattr_ibody_inline_set(handle_t *handle, struct inode *inode,
+int ext4_xattr_ibody_set(handle_t *handle, struct inode *inode,
 				struct ext4_xattr_info *i,
 				struct ext4_xattr_ibody_find *is)
 {
@@ -2240,30 +2240,6 @@ int ext4_xattr_ibody_inline_set(handle_t *handle, struct inode *inode,
 	return 0;
 }
 
-static int ext4_xattr_ibody_set(handle_t *handle, struct inode *inode,
-				struct ext4_xattr_info *i,
-				struct ext4_xattr_ibody_find *is)
-{
-	struct ext4_xattr_ibody_header *header;
-	struct ext4_xattr_search *s = &is->s;
-	int error;
-
-	if (EXT4_I(inode)->i_extra_isize == 0)
-		return -ENOSPC;
-	error = ext4_xattr_set_entry(i, s, handle, inode, false /* is_block */);
-	if (error)
-		return error;
-	header = IHDR(inode, ext4_raw_inode(&is->iloc));
-	if (!IS_LAST_ENTRY(s->first)) {
-		header->h_magic = cpu_to_le32(EXT4_XATTR_MAGIC);
-		ext4_set_inode_state(inode, EXT4_STATE_XATTR);
-	} else {
-		header->h_magic = cpu_to_le32(0);
-		ext4_clear_inode_state(inode, EXT4_STATE_XATTR);
-	}
-	return 0;
-}
-
 static int ext4_xattr_value_same(struct ext4_xattr_search *s,
 				 struct ext4_xattr_info *i)
 {
diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
index b357872ab83b..e5e36bd11f05 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -200,9 +200,9 @@ extern int ext4_xattr_ibody_find(struct inode *inode, struct ext4_xattr_info *i,
 extern int ext4_xattr_ibody_get(struct inode *inode, int name_index,
 				const char *name,
 				void *buffer, size_t buffer_size);
-extern int ext4_xattr_ibody_inline_set(handle_t *handle, struct inode *inode,
-				       struct ext4_xattr_info *i,
-				       struct ext4_xattr_ibody_find *is);
+extern int ext4_xattr_ibody_set(handle_t *handle, struct inode *inode,
+				struct ext4_xattr_info *i,
+				struct ext4_xattr_ibody_find *is);
 
 extern struct mb_cache *ext4_xattr_create_cache(void);
 extern void ext4_xattr_destroy_cache(struct mb_cache *);
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 80a9e50392a0..e3b9b7d188e6 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -205,7 +205,7 @@ static int fuse_dentry_revalidate(struct dentry *entry, unsigned int flags)
 	if (inode && fuse_is_bad(inode))
 		goto invalid;
 	else if (time_before64(fuse_dentry_time(entry), get_jiffies_64()) ||
-		 (flags & (LOOKUP_EXCL | LOOKUP_REVAL))) {
+		 (flags & (LOOKUP_EXCL | LOOKUP_REVAL | LOOKUP_RENAME_TARGET))) {
 		struct fuse_entry_out outarg;
 		FUSE_ARGS(args);
 		struct fuse_forget_link *forget;
@@ -537,6 +537,7 @@ static int fuse_create_open(struct inode *dir, struct dentry *entry,
 	struct fuse_entry_out outentry;
 	struct fuse_inode *fi;
 	struct fuse_file *ff;
+	bool trunc = flags & O_TRUNC;
 
 	/* Userspace expects S_IFREG in create mode */
 	BUG_ON((mode & S_IFMT) != S_IFREG);
@@ -604,6 +605,10 @@ static int fuse_create_open(struct inode *dir, struct dentry *entry,
 	} else {
 		file->private_data = ff;
 		fuse_finish_open(inode, file);
+		if (fm->fc->atomic_o_trunc && trunc)
+			truncate_pagecache(inode, 0);
+		else if (!(ff->open_flags & FOPEN_KEEP_CACHE))
+			invalidate_inode_pages2(inode->i_mapping);
 	}
 	return err;
 
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 504389568dac..13d97547eaf6 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -206,14 +206,10 @@ void fuse_finish_open(struct inode *inode, struct file *file)
 		fi->attr_version = atomic64_inc_return(&fc->attr_version);
 		i_size_write(inode, 0);
 		spin_unlock(&fi->lock);
-		truncate_pagecache(inode, 0);
 		fuse_invalidate_attr(inode);
 		if (fc->writeback_cache)
 			file_update_time(file);
-	} else if (!(ff->open_flags & FOPEN_KEEP_CACHE)) {
-		invalidate_inode_pages2(inode->i_mapping);
 	}
-
 	if ((file->f_mode & FMODE_WRITE) && fc->writeback_cache)
 		fuse_link_write_file(file);
 }
@@ -236,30 +232,39 @@ int fuse_open_common(struct inode *inode, struct file *file, bool isdir)
 	if (err)
 		return err;
 
-	if (is_wb_truncate || dax_truncate) {
+	if (is_wb_truncate || dax_truncate)
 		inode_lock(inode);
-		fuse_set_nowrite(inode);
-	}
 
 	if (dax_truncate) {
 		down_write(&get_fuse_inode(inode)->i_mmap_sem);
 		err = fuse_dax_break_layouts(inode, 0, 0);
 		if (err)
-			goto out;
+			goto out_inode_unlock;
 	}
 
+	if (is_wb_truncate || dax_truncate)
+		fuse_set_nowrite(inode);
+
 	err = fuse_do_open(fm, get_node_id(inode), file, isdir);
 	if (!err)
 		fuse_finish_open(inode, file);
 
-out:
+	if (is_wb_truncate || dax_truncate)
+		fuse_release_nowrite(inode);
+	if (!err) {
+		struct fuse_file *ff = file->private_data;
+
+		if (fc->atomic_o_trunc && (file->f_flags & O_TRUNC))
+			truncate_pagecache(inode, 0);
+		else if (!(ff->open_flags & FOPEN_KEEP_CACHE))
+			invalidate_inode_pages2(inode->i_mapping);
+	}
 	if (dax_truncate)
 		up_write(&get_fuse_inode(inode)->i_mmap_sem);
 
-	if (is_wb_truncate | dax_truncate) {
-		fuse_release_nowrite(inode);
+out_inode_unlock:
+	if (is_wb_truncate || dax_truncate)
 		inode_unlock(inode);
-	}
 
 	return err;
 }
@@ -782,7 +787,7 @@ static void fuse_read_update_size(struct inode *inode, loff_t size,
 	struct fuse_inode *fi = get_fuse_inode(inode);
 
 	spin_lock(&fi->lock);
-	if (attr_ver == fi->attr_version && size < inode->i_size &&
+	if (attr_ver >= fi->attr_version && size < inode->i_size &&
 	    !test_bit(FUSE_I_SIZE_UNSTABLE, &fi->state)) {
 		fi->attr_version = atomic64_inc_return(&fc->attr_version);
 		i_size_write(inode, size);
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index b10cddd72355..ceaa6868386e 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -556,6 +556,9 @@ struct fuse_conn {
 	/** Maxmum number of pages that can be used in a single request */
 	unsigned int max_pages;
 
+	/** Constrain ->max_pages to this value during feature negotiation */
+	unsigned int max_pages_limit;
+
 	/** Input queue */
 	struct fuse_iqueue iq;
 
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 2ede05df7d06..9ea175ff9c8e 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -710,6 +710,7 @@ void fuse_conn_init(struct fuse_conn *fc, struct fuse_mount *fm,
 	fc->pid_ns = get_pid_ns(task_active_pid_ns(current));
 	fc->user_ns = get_user_ns(user_ns);
 	fc->max_pages = FUSE_DEFAULT_MAX_PAGES_PER_REQ;
+	fc->max_pages_limit = FUSE_MAX_MAX_PAGES;
 
 	INIT_LIST_HEAD(&fc->mounts);
 	list_add(&fm->fc_entry, &fc->mounts);
@@ -1056,7 +1057,7 @@ static void process_init_reply(struct fuse_mount *fm, struct fuse_args *args,
 				fc->abort_err = 1;
 			if (arg->flags & FUSE_MAX_PAGES) {
 				fc->max_pages =
-					min_t(unsigned int, FUSE_MAX_MAX_PAGES,
+					min_t(unsigned int, fc->max_pages_limit,
 					max_t(unsigned int, arg->max_pages, 1));
 			}
 			if (IS_ENABLED(CONFIG_FUSE_DAX) &&
@@ -1595,7 +1596,7 @@ static void fuse_kill_sb_blk(struct super_block *sb)
 	struct fuse_mount *fm = get_fuse_mount_super(sb);
 	bool last;
 
-	if (fm) {
+	if (sb->s_root) {
 		last = fuse_mount_remove(fm);
 		if (last)
 			fuse_conn_destroy(fm);
diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index b9cfb1165ff4..faadc80485e7 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -18,6 +18,12 @@
 #include <linux/uio.h>
 #include "fuse_i.h"
 
+/* Used to help calculate the FUSE connection's max_pages limit for a request's
+ * size. Parts of the struct fuse_req are sliced into scattergather lists in
+ * addition to the pages used, so this can help account for that overhead.
+ */
+#define FUSE_HEADER_OVERHEAD    4
+
 /* List of virtio-fs device instances and a lock for the list. Also provides
  * mutual exclusion in device removal and mounting path
  */
@@ -1393,7 +1399,7 @@ static void virtio_kill_sb(struct super_block *sb)
 	bool last;
 
 	/* If mount failed, we can still be called without any fc */
-	if (fm) {
+	if (sb->s_root) {
 		last = fuse_mount_remove(fm);
 		if (last)
 			virtio_fs_conn_destroy(fm);
@@ -1426,9 +1432,10 @@ static int virtio_fs_get_tree(struct fs_context *fsc)
 {
 	struct virtio_fs *fs;
 	struct super_block *sb;
-	struct fuse_conn *fc;
+	struct fuse_conn *fc = NULL;
 	struct fuse_mount *fm;
-	int err;
+	unsigned int virtqueue_size;
+	int err = -EIO;
 
 	/* This gets a reference on virtio_fs object. This ptr gets installed
 	 * in fc->iq->priv. Once fuse_conn is going away, it calls ->put()
@@ -1440,28 +1447,28 @@ static int virtio_fs_get_tree(struct fs_context *fsc)
 		return -EINVAL;
 	}
 
+	virtqueue_size = virtqueue_get_vring_size(fs->vqs[VQ_REQUEST].vq);
+	if (WARN_ON(virtqueue_size <= FUSE_HEADER_OVERHEAD))
+		goto out_err;
+
+	err = -ENOMEM;
 	fc = kzalloc(sizeof(struct fuse_conn), GFP_KERNEL);
-	if (!fc) {
-		mutex_lock(&virtio_fs_mutex);
-		virtio_fs_put(fs);
-		mutex_unlock(&virtio_fs_mutex);
-		return -ENOMEM;
-	}
+	if (!fc)
+		goto out_err;
 
 	fm = kzalloc(sizeof(struct fuse_mount), GFP_KERNEL);
-	if (!fm) {
-		mutex_lock(&virtio_fs_mutex);
-		virtio_fs_put(fs);
-		mutex_unlock(&virtio_fs_mutex);
-		kfree(fc);
-		return -ENOMEM;
-	}
+	if (!fm)
+		goto out_err;
 
 	fuse_conn_init(fc, fm, fsc->user_ns, &virtio_fs_fiq_ops, fs);
 	fc->release = fuse_free_conn;
 	fc->delete_stale = true;
 	fc->auto_submounts = true;
 
+	/* Tell FUSE to split requests that exceed the virtqueue's size */
+	fc->max_pages_limit = min_t(unsigned int, fc->max_pages_limit,
+				    virtqueue_size - FUSE_HEADER_OVERHEAD);
+
 	fsc->s_fs_info = fm;
 	sb = sget_fc(fsc, virtio_fs_test_super, virtio_fs_set_super);
 	fuse_mount_put(fm);
@@ -1483,6 +1490,13 @@ static int virtio_fs_get_tree(struct fs_context *fsc)
 	WARN_ON(fsc->root);
 	fsc->root = dget(sb->s_root);
 	return 0;
+
+out_err:
+	kfree(fc);
+	mutex_lock(&virtio_fs_mutex);
+	virtio_fs_put(fs);
+	mutex_unlock(&virtio_fs_mutex);
+	return err;
 }
 
 static const struct fs_context_operations virtio_fs_context_ops = {
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 5e835bbf1ffb..fff2cdc69e5e 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -435,6 +435,23 @@ static int nilfs_segctor_reset_segment_buffer(struct nilfs_sc_info *sci)
 	return 0;
 }
 
+/**
+ * nilfs_segctor_zeropad_segsum - zero pad the rest of the segment summary area
+ * @sci: segment constructor object
+ *
+ * nilfs_segctor_zeropad_segsum() zero-fills unallocated space at the end of
+ * the current segment summary block.
+ */
+static void nilfs_segctor_zeropad_segsum(struct nilfs_sc_info *sci)
+{
+	struct nilfs_segsum_pointer *ssp;
+
+	ssp = sci->sc_blk_cnt > 0 ? &sci->sc_binfo_ptr : &sci->sc_finfo_ptr;
+	if (ssp->offset < ssp->bh->b_size)
+		memset(ssp->bh->b_data + ssp->offset, 0,
+		       ssp->bh->b_size - ssp->offset);
+}
+
 static int nilfs_segctor_feed_segment(struct nilfs_sc_info *sci)
 {
 	sci->sc_nblk_this_inc += sci->sc_curseg->sb_sum.nblocks;
@@ -443,6 +460,7 @@ static int nilfs_segctor_feed_segment(struct nilfs_sc_info *sci)
 				* The current segment is filled up
 				* (internal code)
 				*/
+	nilfs_segctor_zeropad_segsum(sci);
 	sci->sc_curseg = NILFS_NEXT_SEGBUF(sci->sc_curseg);
 	return nilfs_segctor_reset_segment_buffer(sci);
 }
@@ -547,6 +565,7 @@ static int nilfs_segctor_add_file_block(struct nilfs_sc_info *sci,
 		goto retry;
 	}
 	if (unlikely(required)) {
+		nilfs_segctor_zeropad_segsum(sci);
 		err = nilfs_segbuf_extend_segsum(segbuf);
 		if (unlikely(err))
 			goto failed;
@@ -1536,6 +1555,7 @@ static int nilfs_segctor_collect(struct nilfs_sc_info *sci,
 		nadd = min_t(int, nadd << 1, SC_MAX_SEGDELTA);
 		sci->sc_stage = prev_stage;
 	}
+	nilfs_segctor_zeropad_segsum(sci);
 	nilfs_segctor_truncate_segments(sci, sci->sc_curseg, nilfs->ns_sufile);
 	return 0;
 
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 953de843d9c3..e341d6531e68 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -39,33 +39,6 @@ static inline bool xfs_ioend_is_append(struct iomap_ioend *ioend)
 		XFS_I(ioend->io_inode)->i_d.di_size;
 }
 
-STATIC int
-xfs_setfilesize_trans_alloc(
-	struct iomap_ioend	*ioend)
-{
-	struct xfs_mount	*mp = XFS_I(ioend->io_inode)->i_mount;
-	struct xfs_trans	*tp;
-	int			error;
-
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_fsyncts, 0, 0, 0, &tp);
-	if (error)
-		return error;
-
-	ioend->io_private = tp;
-
-	/*
-	 * We may pass freeze protection with a transaction.  So tell lockdep
-	 * we released it.
-	 */
-	__sb_writers_release(ioend->io_inode->i_sb, SB_FREEZE_FS);
-	/*
-	 * We hand off the transaction to the completion thread now, so
-	 * clear the flag here.
-	 */
-	xfs_trans_clear_context(tp);
-	return 0;
-}
-
 /*
  * Update on-disk file size now that data has been written to disk.
  */
@@ -191,12 +164,10 @@ xfs_end_ioend(
 		error = xfs_reflink_end_cow(ip, offset, size);
 	else if (ioend->io_type == IOMAP_UNWRITTEN)
 		error = xfs_iomap_write_unwritten(ip, offset, size, false);
-	else
-		ASSERT(!xfs_ioend_is_append(ioend) || ioend->io_private);
 
+	if (!error && xfs_ioend_is_append(ioend))
+		error = xfs_setfilesize(ip, ioend->io_offset, ioend->io_size);
 done:
-	if (ioend->io_private)
-		error = xfs_setfilesize_ioend(ioend, error);
 	iomap_finish_ioends(ioend, error);
 	memalloc_nofs_restore(nofs_flag);
 }
@@ -246,7 +217,7 @@ xfs_end_io(
 
 static inline bool xfs_ioend_needs_workqueue(struct iomap_ioend *ioend)
 {
-	return ioend->io_private ||
+	return xfs_ioend_is_append(ioend) ||
 		ioend->io_type == IOMAP_UNWRITTEN ||
 		(ioend->io_flags & IOMAP_F_SHARED);
 }
@@ -259,8 +230,6 @@ xfs_end_bio(
 	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
 	unsigned long		flags;
 
-	ASSERT(xfs_ioend_needs_workqueue(ioend));
-
 	spin_lock_irqsave(&ip->i_ioend_lock, flags);
 	if (list_empty(&ip->i_ioend_list))
 		WARN_ON_ONCE(!queue_work(ip->i_mount->m_unwritten_workqueue,
@@ -510,14 +479,6 @@ xfs_prepare_ioend(
 				ioend->io_offset, ioend->io_size);
 	}
 
-	/* Reserve log space if we might write beyond the on-disk inode size. */
-	if (!status &&
-	    ((ioend->io_flags & IOMAP_F_SHARED) ||
-	     ioend->io_type != IOMAP_UNWRITTEN) &&
-	    xfs_ioend_is_append(ioend) &&
-	    !ioend->io_private)
-		status = xfs_setfilesize_trans_alloc(ioend);
-
 	memalloc_nofs_restore(nofs_flag);
 
 	if (xfs_ioend_needs_workqueue(ioend))
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 39636fe7e8f0..a210f1995862 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -258,6 +258,7 @@ struct nf_bridge_info {
 	u8			pkt_otherhost:1;
 	u8			in_prerouting:1;
 	u8			bridged_dnat:1;
+	u8			sabotage_in_done:1;
 	__u16			frag_max_size;
 	struct net_device	*physindev;
 
@@ -4276,7 +4277,7 @@ static inline void nf_reset_ct(struct sk_buff *skb)
 
 static inline void nf_reset_trace(struct sk_buff *skb)
 {
-#if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TRACE) || defined(CONFIG_NF_TABLES)
+#if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TRACE) || IS_ENABLED(CONFIG_NF_TABLES)
 	skb->nf_trace = 0;
 #endif
 }
@@ -4296,7 +4297,7 @@ static inline void __nf_copy(struct sk_buff *dst, const struct sk_buff *src,
 	dst->_nfct = src->_nfct;
 	nf_conntrack_get(skb_nfct(src));
 #endif
-#if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TRACE) || defined(CONFIG_NF_TABLES)
+#if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TRACE) || IS_ENABLED(CONFIG_NF_TABLES)
 	if (copy)
 		dst->nf_trace = src->nf_trace;
 #endif
diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 89ce8a50f236..8879c0ab0b89 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -1109,6 +1109,8 @@ void ipv6_icmp_error(struct sock *sk, struct sk_buff *skb, int err, __be16 port,
 void ipv6_local_error(struct sock *sk, int err, struct flowi6 *fl6, u32 info);
 void ipv6_local_rxpmtu(struct sock *sk, struct flowi6 *fl6, u32 mtu);
 
+void inet6_cleanup_sock(struct sock *sk);
+void inet6_sock_destruct(struct sock *sk);
 int inet6_release(struct socket *sock);
 int inet6_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len);
 int inet6_getname(struct socket *sock, struct sockaddr *uaddr,
diff --git a/include/net/udp.h b/include/net/udp.h
index 388e68c7bca0..e2550a4547a7 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -268,7 +268,7 @@ static inline bool udp_sk_bound_dev_eq(struct net *net, int bound_dev_if,
 }
 
 /* net/ipv4/udp.c */
-void udp_destruct_sock(struct sock *sk);
+void udp_destruct_common(struct sock *sk);
 void skb_consume_udp(struct sock *sk, struct sk_buff *skb, int len);
 int __udp_enqueue_schedule_skb(struct sock *sk, struct sk_buff *skb);
 void udp_skb_destructor(struct sock *sk, struct sk_buff *skb);
diff --git a/include/net/udplite.h b/include/net/udplite.h
index 9185e45b997f..c59ba86668af 100644
--- a/include/net/udplite.h
+++ b/include/net/udplite.h
@@ -24,14 +24,6 @@ static __inline__ int udplite_getfrag(void *from, char *to, int  offset,
 	return copy_from_iter_full(to, len, &msg->msg_iter) ? 0 : -EFAULT;
 }
 
-/* Designate sk as UDP-Lite socket */
-static inline int udplite_sk_init(struct sock *sk)
-{
-	udp_init_sock(sk);
-	udp_sk(sk)->pcflag = UDPLITE_BIT;
-	return 0;
-}
-
 /*
  * 	Checksumming routines
  */
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index df293bc7f03b..e8cd19e91de1 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -513,7 +513,7 @@ TRACE_EVENT(f2fs_truncate_partial_nodes,
 	TP_STRUCT__entry(
 		__field(dev_t,	dev)
 		__field(ino_t,	ino)
-		__field(nid_t,	nid[3])
+		__array(nid_t,	nid, 3)
 		__field(int,	depth)
 		__field(int,	err)
 	),
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 9e5f1ebe67d7..5a96a9dd51e4 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1931,6 +1931,21 @@ static int backtrack_insn(struct bpf_verifier_env *env, int idx,
 			}
 		} else if (opcode == BPF_EXIT) {
 			return -ENOTSUPP;
+		} else if (BPF_SRC(insn->code) == BPF_X) {
+			if (!(*reg_mask & (dreg | sreg)))
+				return 0;
+			/* dreg <cond> sreg
+			 * Both dreg and sreg need precision before
+			 * this insn. If only sreg was marked precise
+			 * before it would be equally necessary to
+			 * propagate it to dreg.
+			 */
+			*reg_mask |= (sreg | dreg);
+			 /* else dreg <cond> K
+			  * Only dreg still needs precision before
+			  * this insn, so for the K-based conditional
+			  * there is nothing new to be marked.
+			  */
 		}
 	} else if (class == BPF_LD) {
 		if (!(*reg_mask & dreg))
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b4bd02d68185..9d6dd14cfd26 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -980,7 +980,7 @@ static inline void uclamp_idle_reset(struct rq *rq, enum uclamp_id clamp_id,
 	if (!(rq->uclamp_flags & UCLAMP_FLAG_IDLE))
 		return;
 
-	WRITE_ONCE(rq->uclamp[clamp_id].value, clamp_value);
+	uclamp_rq_set(rq, clamp_id, clamp_value);
 }
 
 static inline
@@ -1158,8 +1158,8 @@ static inline void uclamp_rq_inc_id(struct rq *rq, struct task_struct *p,
 	if (bucket->tasks == 1 || uc_se->value > bucket->value)
 		bucket->value = uc_se->value;
 
-	if (uc_se->value > READ_ONCE(uc_rq->value))
-		WRITE_ONCE(uc_rq->value, uc_se->value);
+	if (uc_se->value > uclamp_rq_get(rq, clamp_id))
+		uclamp_rq_set(rq, clamp_id, uc_se->value);
 }
 
 /*
@@ -1225,7 +1225,7 @@ static inline void uclamp_rq_dec_id(struct rq *rq, struct task_struct *p,
 	if (likely(bucket->tasks))
 		return;
 
-	rq_clamp = READ_ONCE(uc_rq->value);
+	rq_clamp = uclamp_rq_get(rq, clamp_id);
 	/*
 	 * Defensive programming: this should never happen. If it happens,
 	 * e.g. due to future modification, warn and fixup the expected value.
@@ -1233,7 +1233,7 @@ static inline void uclamp_rq_dec_id(struct rq *rq, struct task_struct *p,
 	SCHED_WARN_ON(bucket->value > rq_clamp);
 	if (bucket->value >= rq_clamp) {
 		bkt_clamp = uclamp_rq_max_value(rq, clamp_id, uc_se->value);
-		WRITE_ONCE(uc_rq->value, bkt_clamp);
+		uclamp_rq_set(rq, clamp_id, bkt_clamp);
 	}
 }
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 57a58bc48021..45c1d03aff73 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3928,14 +3928,16 @@ static inline unsigned long task_util_est(struct task_struct *p)
 }
 
 #ifdef CONFIG_UCLAMP_TASK
-static inline unsigned long uclamp_task_util(struct task_struct *p)
+static inline unsigned long uclamp_task_util(struct task_struct *p,
+					     unsigned long uclamp_min,
+					     unsigned long uclamp_max)
 {
-	return clamp(task_util_est(p),
-		     uclamp_eff_value(p, UCLAMP_MIN),
-		     uclamp_eff_value(p, UCLAMP_MAX));
+	return clamp(task_util_est(p), uclamp_min, uclamp_max);
 }
 #else
-static inline unsigned long uclamp_task_util(struct task_struct *p)
+static inline unsigned long uclamp_task_util(struct task_struct *p,
+					     unsigned long uclamp_min,
+					     unsigned long uclamp_max)
 {
 	return task_util_est(p);
 }
@@ -4111,12 +4113,16 @@ static inline int util_fits_cpu(unsigned long util,
 	 * For uclamp_max, we can tolerate a drop in performance level as the
 	 * goal is to cap the task. So it's okay if it's getting less.
 	 *
-	 * In case of capacity inversion, which is not handled yet, we should
-	 * honour the inverted capacity for both uclamp_min and uclamp_max all
-	 * the time.
+	 * In case of capacity inversion we should honour the inverted capacity
+	 * for both uclamp_min and uclamp_max all the time.
 	 */
-	capacity_orig = capacity_orig_of(cpu);
-	capacity_orig_thermal = capacity_orig - arch_scale_thermal_pressure(cpu);
+	capacity_orig = cpu_in_capacity_inversion(cpu);
+	if (capacity_orig) {
+		capacity_orig_thermal = capacity_orig;
+	} else {
+		capacity_orig = capacity_orig_of(cpu);
+		capacity_orig_thermal = capacity_orig - arch_scale_thermal_pressure(cpu);
+	}
 
 	/*
 	 * We want to force a task to fit a cpu as implied by uclamp_max.
@@ -4197,10 +4203,12 @@ static inline int util_fits_cpu(unsigned long util,
 	return fits;
 }
 
-static inline int task_fits_capacity(struct task_struct *p,
-				     unsigned long capacity)
+static inline int task_fits_cpu(struct task_struct *p, int cpu)
 {
-	return fits_capacity(uclamp_task_util(p), capacity);
+	unsigned long uclamp_min = uclamp_eff_value(p, UCLAMP_MIN);
+	unsigned long uclamp_max = uclamp_eff_value(p, UCLAMP_MAX);
+	unsigned long util = task_util_est(p);
+	return util_fits_cpu(util, uclamp_min, uclamp_max, cpu);
 }
 
 static inline void update_misfit_status(struct task_struct *p, struct rq *rq)
@@ -4213,7 +4221,7 @@ static inline void update_misfit_status(struct task_struct *p, struct rq *rq)
 		return;
 	}
 
-	if (task_fits_capacity(p, capacity_of(cpu_of(rq)))) {
+	if (task_fits_cpu(p, cpu_of(rq))) {
 		rq->misfit_task_load = 0;
 		return;
 	}
@@ -5655,7 +5663,10 @@ static inline unsigned long cpu_util(int cpu);
 
 static inline bool cpu_overutilized(int cpu)
 {
-	return !fits_capacity(cpu_util(cpu), capacity_of(cpu));
+	unsigned long rq_util_min = uclamp_rq_get(cpu_rq(cpu), UCLAMP_MIN);
+	unsigned long rq_util_max = uclamp_rq_get(cpu_rq(cpu), UCLAMP_MAX);
+
+	return !util_fits_cpu(cpu_util(cpu), rq_util_min, rq_util_max, cpu);
 }
 
 static inline void update_overutilized_status(struct rq *rq)
@@ -6392,21 +6403,23 @@ static int select_idle_cpu(struct task_struct *p, struct sched_domain *sd, int t
 static int
 select_idle_capacity(struct task_struct *p, struct sched_domain *sd, int target)
 {
-	unsigned long task_util, best_cap = 0;
+	unsigned long task_util, util_min, util_max, best_cap = 0;
 	int cpu, best_cpu = -1;
 	struct cpumask *cpus;
 
 	cpus = this_cpu_cpumask_var_ptr(select_idle_mask);
 	cpumask_and(cpus, sched_domain_span(sd), p->cpus_ptr);
 
-	task_util = uclamp_task_util(p);
+	task_util = task_util_est(p);
+	util_min = uclamp_eff_value(p, UCLAMP_MIN);
+	util_max = uclamp_eff_value(p, UCLAMP_MAX);
 
 	for_each_cpu_wrap(cpu, cpus, target) {
 		unsigned long cpu_cap = capacity_of(cpu);
 
 		if (!available_idle_cpu(cpu) && !sched_idle_cpu(cpu))
 			continue;
-		if (fits_capacity(task_util, cpu_cap))
+		if (util_fits_cpu(task_util, util_min, util_max, cpu))
 			return cpu;
 
 		if (cpu_cap > best_cap) {
@@ -6418,10 +6431,13 @@ select_idle_capacity(struct task_struct *p, struct sched_domain *sd, int target)
 	return best_cpu;
 }
 
-static inline bool asym_fits_capacity(unsigned long task_util, int cpu)
+static inline bool asym_fits_cpu(unsigned long util,
+				 unsigned long util_min,
+				 unsigned long util_max,
+				 int cpu)
 {
 	if (static_branch_unlikely(&sched_asym_cpucapacity))
-		return fits_capacity(task_util, capacity_of(cpu));
+		return util_fits_cpu(util, util_min, util_max, cpu);
 
 	return true;
 }
@@ -6432,7 +6448,7 @@ static inline bool asym_fits_capacity(unsigned long task_util, int cpu)
 static int select_idle_sibling(struct task_struct *p, int prev, int target)
 {
 	struct sched_domain *sd;
-	unsigned long task_util;
+	unsigned long task_util, util_min, util_max;
 	int i, recent_used_cpu;
 
 	/*
@@ -6441,11 +6457,13 @@ static int select_idle_sibling(struct task_struct *p, int prev, int target)
 	 */
 	if (static_branch_unlikely(&sched_asym_cpucapacity)) {
 		sync_entity_load_avg(&p->se);
-		task_util = uclamp_task_util(p);
+		task_util = task_util_est(p);
+		util_min = uclamp_eff_value(p, UCLAMP_MIN);
+		util_max = uclamp_eff_value(p, UCLAMP_MAX);
 	}
 
 	if ((available_idle_cpu(target) || sched_idle_cpu(target)) &&
-	    asym_fits_capacity(task_util, target))
+	    asym_fits_cpu(task_util, util_min, util_max, target))
 		return target;
 
 	/*
@@ -6453,7 +6471,7 @@ static int select_idle_sibling(struct task_struct *p, int prev, int target)
 	 */
 	if (prev != target && cpus_share_cache(prev, target) &&
 	    (available_idle_cpu(prev) || sched_idle_cpu(prev)) &&
-	    asym_fits_capacity(task_util, prev))
+	    asym_fits_cpu(task_util, util_min, util_max, prev))
 		return prev;
 
 	/*
@@ -6468,7 +6486,7 @@ static int select_idle_sibling(struct task_struct *p, int prev, int target)
 	    in_task() &&
 	    prev == smp_processor_id() &&
 	    this_rq()->nr_running <= 1 &&
-	    asym_fits_capacity(task_util, prev)) {
+	    asym_fits_cpu(task_util, util_min, util_max, prev)) {
 		return prev;
 	}
 
@@ -6479,7 +6497,7 @@ static int select_idle_sibling(struct task_struct *p, int prev, int target)
 	    cpus_share_cache(recent_used_cpu, target) &&
 	    (available_idle_cpu(recent_used_cpu) || sched_idle_cpu(recent_used_cpu)) &&
 	    cpumask_test_cpu(p->recent_used_cpu, p->cpus_ptr) &&
-	    asym_fits_capacity(task_util, recent_used_cpu)) {
+	    asym_fits_cpu(task_util, util_min, util_max, recent_used_cpu)) {
 		/*
 		 * Replace recent_used_cpu with prev as it is a potential
 		 * candidate for the next wake:
@@ -6800,6 +6818,8 @@ compute_energy(struct task_struct *p, int dst_cpu, struct perf_domain *pd)
 static int find_energy_efficient_cpu(struct task_struct *p, int prev_cpu)
 {
 	unsigned long prev_delta = ULONG_MAX, best_delta = ULONG_MAX;
+	unsigned long p_util_min = uclamp_is_used() ? uclamp_eff_value(p, UCLAMP_MIN) : 0;
+	unsigned long p_util_max = uclamp_is_used() ? uclamp_eff_value(p, UCLAMP_MAX) : 1024;
 	struct root_domain *rd = cpu_rq(smp_processor_id())->rd;
 	unsigned long cpu_cap, util, base_energy = 0;
 	int cpu, best_energy_cpu = prev_cpu;
@@ -6822,11 +6842,13 @@ static int find_energy_efficient_cpu(struct task_struct *p, int prev_cpu)
 		goto fail;
 
 	sync_entity_load_avg(&p->se);
-	if (!task_util_est(p))
+	if (!uclamp_task_util(p, p_util_min, p_util_max))
 		goto unlock;
 
 	for (; pd; pd = pd->next) {
+		unsigned long util_min = p_util_min, util_max = p_util_max;
 		unsigned long cur_delta, spare_cap, max_spare_cap = 0;
+		unsigned long rq_util_min, rq_util_max;
 		unsigned long base_energy_pd;
 		int max_spare_cap_cpu = -1;
 
@@ -6835,6 +6857,8 @@ static int find_energy_efficient_cpu(struct task_struct *p, int prev_cpu)
 		base_energy += base_energy_pd;
 
 		for_each_cpu_and(cpu, perf_domain_span(pd), sched_domain_span(sd)) {
+			struct rq *rq = cpu_rq(cpu);
+
 			if (!cpumask_test_cpu(cpu, p->cpus_ptr))
 				continue;
 
@@ -6850,8 +6874,21 @@ static int find_energy_efficient_cpu(struct task_struct *p, int prev_cpu)
 			 * much capacity we can get out of the CPU; this is
 			 * aligned with schedutil_cpu_util().
 			 */
-			util = uclamp_rq_util_with(cpu_rq(cpu), util, p);
-			if (!fits_capacity(util, cpu_cap))
+			if (uclamp_is_used() && !uclamp_rq_is_idle(rq)) {
+				/*
+				 * Open code uclamp_rq_util_with() except for
+				 * the clamp() part. Ie: apply max aggregation
+				 * only. util_fits_cpu() logic requires to
+				 * operate on non clamped util but must use the
+				 * max-aggregated uclamp_{min, max}.
+				 */
+				rq_util_min = uclamp_rq_get(rq, UCLAMP_MIN);
+				rq_util_max = uclamp_rq_get(rq, UCLAMP_MAX);
+
+				util_min = max(rq_util_min, p_util_min);
+				util_max = max(rq_util_max, p_util_max);
+			}
+			if (!util_fits_cpu(util, util_min, util_max, cpu))
 				continue;
 
 			/* Always use prev_cpu as a candidate. */
@@ -7942,7 +7979,7 @@ static int detach_tasks(struct lb_env *env)
 
 		case migrate_misfit:
 			/* This is not a misfit task */
-			if (task_fits_capacity(p, capacity_of(env->src_cpu)))
+			if (task_fits_cpu(p, env->src_cpu))
 				goto next;
 
 			env->imbalance = 0;
@@ -8340,16 +8377,82 @@ static unsigned long scale_rt_capacity(int cpu)
 
 static void update_cpu_capacity(struct sched_domain *sd, int cpu)
 {
+	unsigned long capacity_orig = arch_scale_cpu_capacity(cpu);
 	unsigned long capacity = scale_rt_capacity(cpu);
 	struct sched_group *sdg = sd->groups;
+	struct rq *rq = cpu_rq(cpu);
 
-	cpu_rq(cpu)->cpu_capacity_orig = arch_scale_cpu_capacity(cpu);
+	rq->cpu_capacity_orig = capacity_orig;
 
 	if (!capacity)
 		capacity = 1;
 
-	cpu_rq(cpu)->cpu_capacity = capacity;
-	trace_sched_cpu_capacity_tp(cpu_rq(cpu));
+	rq->cpu_capacity = capacity;
+
+	/*
+	 * Detect if the performance domain is in capacity inversion state.
+	 *
+	 * Capacity inversion happens when another perf domain with equal or
+	 * lower capacity_orig_of() ends up having higher capacity than this
+	 * domain after subtracting thermal pressure.
+	 *
+	 * We only take into account thermal pressure in this detection as it's
+	 * the only metric that actually results in *real* reduction of
+	 * capacity due to performance points (OPPs) being dropped/become
+	 * unreachable due to thermal throttling.
+	 *
+	 * We assume:
+	 *   * That all cpus in a perf domain have the same capacity_orig
+	 *     (same uArch).
+	 *   * Thermal pressure will impact all cpus in this perf domain
+	 *     equally.
+	 */
+	if (sched_energy_enabled()) {
+		unsigned long inv_cap = capacity_orig - thermal_load_avg(rq);
+		struct perf_domain *pd;
+
+		rcu_read_lock();
+
+		pd = rcu_dereference(rq->rd->pd);
+		rq->cpu_capacity_inverted = 0;
+
+		for (; pd; pd = pd->next) {
+			struct cpumask *pd_span = perf_domain_span(pd);
+			unsigned long pd_cap_orig, pd_cap;
+
+			/* We can't be inverted against our own pd */
+			if (cpumask_test_cpu(cpu_of(rq), pd_span))
+				continue;
+
+			cpu = cpumask_any(pd_span);
+			pd_cap_orig = arch_scale_cpu_capacity(cpu);
+
+			if (capacity_orig < pd_cap_orig)
+				continue;
+
+			/*
+			 * handle the case of multiple perf domains have the
+			 * same capacity_orig but one of them is under higher
+			 * thermal pressure. We record it as capacity
+			 * inversion.
+			 */
+			if (capacity_orig == pd_cap_orig) {
+				pd_cap = pd_cap_orig - thermal_load_avg(cpu_rq(cpu));
+
+				if (pd_cap > inv_cap) {
+					rq->cpu_capacity_inverted = inv_cap;
+					break;
+				}
+			} else if (pd_cap_orig > inv_cap) {
+				rq->cpu_capacity_inverted = inv_cap;
+				break;
+			}
+		}
+
+		rcu_read_unlock();
+	}
+
+	trace_sched_cpu_capacity_tp(rq);
 
 	sdg->sgc->capacity = capacity;
 	sdg->sgc->min_capacity = capacity;
@@ -8884,6 +8987,10 @@ static inline void update_sg_wakeup_stats(struct sched_domain *sd,
 
 	memset(sgs, 0, sizeof(*sgs));
 
+	/* Assume that task can't fit any CPU of the group */
+	if (sd->flags & SD_ASYM_CPUCAPACITY)
+		sgs->group_misfit_task_load = 1;
+
 	for_each_cpu(i, sched_group_span(group)) {
 		struct rq *rq = cpu_rq(i);
 		unsigned int local;
@@ -8903,12 +9010,12 @@ static inline void update_sg_wakeup_stats(struct sched_domain *sd,
 		if (!nr_running && idle_cpu_without(i, p))
 			sgs->idle_cpus++;
 
-	}
+		/* Check if task fits in the CPU */
+		if (sd->flags & SD_ASYM_CPUCAPACITY &&
+		    sgs->group_misfit_task_load &&
+		    task_fits_cpu(p, i))
+			sgs->group_misfit_task_load = 0;
 
-	/* Check if task fits in the group */
-	if (sd->flags & SD_ASYM_CPUCAPACITY &&
-	    !task_fits_capacity(p, group->sgc->max_capacity)) {
-		sgs->group_misfit_task_load = 1;
 	}
 
 	sgs->group_capacity = group->sgc->capacity;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 12c65628801c..852e856eed48 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -973,6 +973,7 @@ struct rq {
 
 	unsigned long		cpu_capacity;
 	unsigned long		cpu_capacity_orig;
+	unsigned long		cpu_capacity_inverted;
 
 	struct callback_head	*balance_callback;
 
@@ -2402,6 +2403,23 @@ static inline void cpufreq_update_util(struct rq *rq, unsigned int flags) {}
 #ifdef CONFIG_UCLAMP_TASK
 unsigned long uclamp_eff_value(struct task_struct *p, enum uclamp_id clamp_id);
 
+static inline unsigned long uclamp_rq_get(struct rq *rq,
+					  enum uclamp_id clamp_id)
+{
+	return READ_ONCE(rq->uclamp[clamp_id].value);
+}
+
+static inline void uclamp_rq_set(struct rq *rq, enum uclamp_id clamp_id,
+				 unsigned int value)
+{
+	WRITE_ONCE(rq->uclamp[clamp_id].value, value);
+}
+
+static inline bool uclamp_rq_is_idle(struct rq *rq)
+{
+	return rq->uclamp_flags & UCLAMP_FLAG_IDLE;
+}
+
 /**
  * uclamp_rq_util_with - clamp @util with @rq and @p effective uclamp values.
  * @rq:		The rq to clamp against. Must not be NULL.
@@ -2437,12 +2455,12 @@ unsigned long uclamp_rq_util_with(struct rq *rq, unsigned long util,
 		 * Ignore last runnable task's max clamp, as this task will
 		 * reset it. Similarly, no need to read the rq's min clamp.
 		 */
-		if (rq->uclamp_flags & UCLAMP_FLAG_IDLE)
+		if (uclamp_rq_is_idle(rq))
 			goto out;
 	}
 
-	min_util = max_t(unsigned long, min_util, READ_ONCE(rq->uclamp[UCLAMP_MIN].value));
-	max_util = max_t(unsigned long, max_util, READ_ONCE(rq->uclamp[UCLAMP_MAX].value));
+	min_util = max_t(unsigned long, min_util, uclamp_rq_get(rq, UCLAMP_MIN));
+	max_util = max_t(unsigned long, max_util, uclamp_rq_get(rq, UCLAMP_MAX));
 out:
 	/*
 	 * Since CPU's {min,max}_util clamps are MAX aggregated considering
@@ -2468,6 +2486,15 @@ static inline bool uclamp_is_used(void)
 	return static_branch_likely(&sched_uclamp_used);
 }
 #else /* CONFIG_UCLAMP_TASK */
+static inline unsigned long uclamp_eff_value(struct task_struct *p,
+					     enum uclamp_id clamp_id)
+{
+	if (clamp_id == UCLAMP_MIN)
+		return 0;
+
+	return SCHED_CAPACITY_SCALE;
+}
+
 static inline
 unsigned long uclamp_rq_util_with(struct rq *rq, unsigned long util,
 				  struct task_struct *p)
@@ -2479,6 +2506,25 @@ static inline bool uclamp_is_used(void)
 {
 	return false;
 }
+
+static inline unsigned long uclamp_rq_get(struct rq *rq,
+					  enum uclamp_id clamp_id)
+{
+	if (clamp_id == UCLAMP_MIN)
+		return 0;
+
+	return SCHED_CAPACITY_SCALE;
+}
+
+static inline void uclamp_rq_set(struct rq *rq, enum uclamp_id clamp_id,
+				 unsigned int value)
+{
+}
+
+static inline bool uclamp_rq_is_idle(struct rq *rq)
+{
+	return false;
+}
 #endif /* CONFIG_UCLAMP_TASK */
 
 #ifdef arch_scale_freq_capacity
@@ -2494,6 +2540,24 @@ static inline unsigned long capacity_orig_of(int cpu)
 {
 	return cpu_rq(cpu)->cpu_capacity_orig;
 }
+
+/*
+ * Returns inverted capacity if the CPU is in capacity inversion state.
+ * 0 otherwise.
+ *
+ * Capacity inversion detection only considers thermal impact where actual
+ * performance points (OPPs) gets dropped.
+ *
+ * Capacity inversion state happens when another performance domain that has
+ * equal or lower capacity_orig_of() becomes effectively larger than the perf
+ * domain this CPU belongs to due to thermal pressure throttling it hard.
+ *
+ * See comment in update_cpu_capacity().
+ */
+static inline unsigned long cpu_in_capacity_inversion(int cpu)
+{
+	return cpu_rq(cpu)->cpu_capacity_inverted;
+}
 #endif
 
 /**
diff --git a/kernel/sys.c b/kernel/sys.c
index 9f59cc8ab8f8..bff14910b926 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -634,6 +634,7 @@ long __sys_setresuid(uid_t ruid, uid_t euid, uid_t suid)
 	struct cred *new;
 	int retval;
 	kuid_t kruid, keuid, ksuid;
+	bool ruid_new, euid_new, suid_new;
 
 	kruid = make_kuid(ns, ruid);
 	keuid = make_kuid(ns, euid);
@@ -648,25 +649,29 @@ long __sys_setresuid(uid_t ruid, uid_t euid, uid_t suid)
 	if ((suid != (uid_t) -1) && !uid_valid(ksuid))
 		return -EINVAL;
 
+	old = current_cred();
+
+	/* check for no-op */
+	if ((ruid == (uid_t) -1 || uid_eq(kruid, old->uid)) &&
+	    (euid == (uid_t) -1 || (uid_eq(keuid, old->euid) &&
+				    uid_eq(keuid, old->fsuid))) &&
+	    (suid == (uid_t) -1 || uid_eq(ksuid, old->suid)))
+		return 0;
+
+	ruid_new = ruid != (uid_t) -1        && !uid_eq(kruid, old->uid) &&
+		   !uid_eq(kruid, old->euid) && !uid_eq(kruid, old->suid);
+	euid_new = euid != (uid_t) -1        && !uid_eq(keuid, old->uid) &&
+		   !uid_eq(keuid, old->euid) && !uid_eq(keuid, old->suid);
+	suid_new = suid != (uid_t) -1        && !uid_eq(ksuid, old->uid) &&
+		   !uid_eq(ksuid, old->euid) && !uid_eq(ksuid, old->suid);
+	if ((ruid_new || euid_new || suid_new) &&
+	    !ns_capable_setid(old->user_ns, CAP_SETUID))
+		return -EPERM;
+
 	new = prepare_creds();
 	if (!new)
 		return -ENOMEM;
 
-	old = current_cred();
-
-	retval = -EPERM;
-	if (!ns_capable_setid(old->user_ns, CAP_SETUID)) {
-		if (ruid != (uid_t) -1        && !uid_eq(kruid, old->uid) &&
-		    !uid_eq(kruid, old->euid) && !uid_eq(kruid, old->suid))
-			goto error;
-		if (euid != (uid_t) -1        && !uid_eq(keuid, old->uid) &&
-		    !uid_eq(keuid, old->euid) && !uid_eq(keuid, old->suid))
-			goto error;
-		if (suid != (uid_t) -1        && !uid_eq(ksuid, old->uid) &&
-		    !uid_eq(ksuid, old->euid) && !uid_eq(ksuid, old->suid))
-			goto error;
-	}
-
 	if (ruid != (uid_t) -1) {
 		new->uid = kruid;
 		if (!uid_eq(kruid, old->uid)) {
@@ -726,6 +731,7 @@ long __sys_setresgid(gid_t rgid, gid_t egid, gid_t sgid)
 	struct cred *new;
 	int retval;
 	kgid_t krgid, kegid, ksgid;
+	bool rgid_new, egid_new, sgid_new;
 
 	krgid = make_kgid(ns, rgid);
 	kegid = make_kgid(ns, egid);
@@ -738,23 +744,28 @@ long __sys_setresgid(gid_t rgid, gid_t egid, gid_t sgid)
 	if ((sgid != (gid_t) -1) && !gid_valid(ksgid))
 		return -EINVAL;
 
+	old = current_cred();
+
+	/* check for no-op */
+	if ((rgid == (gid_t) -1 || gid_eq(krgid, old->gid)) &&
+	    (egid == (gid_t) -1 || (gid_eq(kegid, old->egid) &&
+				    gid_eq(kegid, old->fsgid))) &&
+	    (sgid == (gid_t) -1 || gid_eq(ksgid, old->sgid)))
+		return 0;
+
+	rgid_new = rgid != (gid_t) -1        && !gid_eq(krgid, old->gid) &&
+		   !gid_eq(krgid, old->egid) && !gid_eq(krgid, old->sgid);
+	egid_new = egid != (gid_t) -1        && !gid_eq(kegid, old->gid) &&
+		   !gid_eq(kegid, old->egid) && !gid_eq(kegid, old->sgid);
+	sgid_new = sgid != (gid_t) -1        && !gid_eq(ksgid, old->gid) &&
+		   !gid_eq(ksgid, old->egid) && !gid_eq(ksgid, old->sgid);
+	if ((rgid_new || egid_new || sgid_new) &&
+	    !ns_capable_setid(old->user_ns, CAP_SETGID))
+		return -EPERM;
+
 	new = prepare_creds();
 	if (!new)
 		return -ENOMEM;
-	old = current_cred();
-
-	retval = -EPERM;
-	if (!ns_capable_setid(old->user_ns, CAP_SETGID)) {
-		if (rgid != (gid_t) -1        && !gid_eq(krgid, old->gid) &&
-		    !gid_eq(krgid, old->egid) && !gid_eq(krgid, old->sgid))
-			goto error;
-		if (egid != (gid_t) -1        && !gid_eq(kegid, old->gid) &&
-		    !gid_eq(kegid, old->egid) && !gid_eq(kegid, old->sgid))
-			goto error;
-		if (sgid != (gid_t) -1        && !gid_eq(ksgid, old->gid) &&
-		    !gid_eq(ksgid, old->egid) && !gid_eq(ksgid, old->sgid))
-			goto error;
-	}
 
 	if (rgid != (gid_t) -1)
 		new->gid = krgid;
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index b77186ec70e9..28e18777ec51 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -622,6 +622,10 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 			result = SCAN_PTE_NON_PRESENT;
 			goto out;
 		}
+		if (pte_uffd_wp(pteval)) {
+			result = SCAN_PTE_UFFD_WP;
+			goto out;
+		}
 		page = vm_normal_page(vma, address, pteval);
 		if (unlikely(!page)) {
 			result = SCAN_PAGE_NULL;
diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index f3c7cfba31e1..f14beb9a62ed 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -868,12 +868,17 @@ static unsigned int ip_sabotage_in(void *priv,
 {
 	struct nf_bridge_info *nf_bridge = nf_bridge_info_get(skb);
 
-	if (nf_bridge && !nf_bridge->in_prerouting &&
-	    !netif_is_l3_master(skb->dev) &&
-	    !netif_is_l3_slave(skb->dev)) {
-		nf_bridge_info_free(skb);
-		state->okfn(state->net, state->sk, skb);
-		return NF_STOLEN;
+	if (nf_bridge) {
+		if (nf_bridge->sabotage_in_done)
+			return NF_ACCEPT;
+
+		if (!nf_bridge->in_prerouting &&
+		    !netif_is_l3_master(skb->dev) &&
+		    !netif_is_l3_slave(skb->dev)) {
+			nf_bridge->sabotage_in_done = 1;
+			state->okfn(state->net, state->sk, skb);
+			return NF_STOLEN;
+		}
 	}
 
 	return NF_ACCEPT;
diff --git a/net/dccp/dccp.h b/net/dccp/dccp.h
index 5183e627468d..0218eb169891 100644
--- a/net/dccp/dccp.h
+++ b/net/dccp/dccp.h
@@ -283,6 +283,7 @@ int dccp_rcv_state_process(struct sock *sk, struct sk_buff *skb,
 int dccp_rcv_established(struct sock *sk, struct sk_buff *skb,
 			 const struct dccp_hdr *dh, const unsigned int len);
 
+void dccp_destruct_common(struct sock *sk);
 int dccp_init_sock(struct sock *sk, const __u8 ctl_sock_initialized);
 void dccp_destroy_sock(struct sock *sk);
 
diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index c563f9b325d0..64e91783860d 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -992,6 +992,12 @@ static const struct inet_connection_sock_af_ops dccp_ipv6_mapped = {
 	.sockaddr_len	   = sizeof(struct sockaddr_in6),
 };
 
+static void dccp_v6_sk_destruct(struct sock *sk)
+{
+	dccp_destruct_common(sk);
+	inet6_sock_destruct(sk);
+}
+
 /* NOTE: A lot of things set to zero explicitly by call to
  *       sk_alloc() so need not be done here.
  */
@@ -1004,17 +1010,12 @@ static int dccp_v6_init_sock(struct sock *sk)
 		if (unlikely(!dccp_v6_ctl_sock_initialized))
 			dccp_v6_ctl_sock_initialized = 1;
 		inet_csk(sk)->icsk_af_ops = &dccp_ipv6_af_ops;
+		sk->sk_destruct = dccp_v6_sk_destruct;
 	}
 
 	return err;
 }
 
-static void dccp_v6_destroy_sock(struct sock *sk)
-{
-	dccp_destroy_sock(sk);
-	inet6_destroy_sock(sk);
-}
-
 static struct timewait_sock_ops dccp6_timewait_sock_ops = {
 	.twsk_obj_size	= sizeof(struct dccp6_timewait_sock),
 };
@@ -1037,7 +1038,7 @@ static struct proto dccp_v6_prot = {
 	.accept		   = inet_csk_accept,
 	.get_port	   = inet_csk_get_port,
 	.shutdown	   = dccp_shutdown,
-	.destroy	   = dccp_v6_destroy_sock,
+	.destroy	   = dccp_destroy_sock,
 	.orphan_count	   = &dccp_orphan_count,
 	.max_header	   = MAX_DCCP_HEADER,
 	.obj_size	   = sizeof(struct dccp6_sock),
diff --git a/net/dccp/proto.c b/net/dccp/proto.c
index 65e81e0199b0..e946211758c0 100644
--- a/net/dccp/proto.c
+++ b/net/dccp/proto.c
@@ -171,12 +171,18 @@ const char *dccp_packet_name(const int type)
 
 EXPORT_SYMBOL_GPL(dccp_packet_name);
 
-static void dccp_sk_destruct(struct sock *sk)
+void dccp_destruct_common(struct sock *sk)
 {
 	struct dccp_sock *dp = dccp_sk(sk);
 
 	ccid_hc_tx_delete(dp->dccps_hc_tx_ccid, sk);
 	dp->dccps_hc_tx_ccid = NULL;
+}
+EXPORT_SYMBOL_GPL(dccp_destruct_common);
+
+static void dccp_sk_destruct(struct sock *sk)
+{
+	dccp_destruct_common(sk);
 	inet_sock_destruct(sk);
 }
 
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index b093daaa3deb..f0db66e415bd 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1582,7 +1582,7 @@ int __udp_enqueue_schedule_skb(struct sock *sk, struct sk_buff *skb)
 }
 EXPORT_SYMBOL_GPL(__udp_enqueue_schedule_skb);
 
-void udp_destruct_sock(struct sock *sk)
+void udp_destruct_common(struct sock *sk)
 {
 	/* reclaim completely the forward allocated memory */
 	struct udp_sock *up = udp_sk(sk);
@@ -1595,10 +1595,14 @@ void udp_destruct_sock(struct sock *sk)
 		kfree_skb(skb);
 	}
 	udp_rmem_release(sk, total, 0, true);
+}
+EXPORT_SYMBOL_GPL(udp_destruct_common);
 
+static void udp_destruct_sock(struct sock *sk)
+{
+	udp_destruct_common(sk);
 	inet_sock_destruct(sk);
 }
-EXPORT_SYMBOL_GPL(udp_destruct_sock);
 
 int udp_init_sock(struct sock *sk)
 {
@@ -1606,7 +1610,6 @@ int udp_init_sock(struct sock *sk)
 	sk->sk_destruct = udp_destruct_sock;
 	return 0;
 }
-EXPORT_SYMBOL_GPL(udp_init_sock);
 
 void skb_consume_udp(struct sock *sk, struct sk_buff *skb, int len)
 {
diff --git a/net/ipv4/udplite.c b/net/ipv4/udplite.c
index bd8773b49e72..cfb36655a5fd 100644
--- a/net/ipv4/udplite.c
+++ b/net/ipv4/udplite.c
@@ -17,6 +17,14 @@
 struct udp_table 	udplite_table __read_mostly;
 EXPORT_SYMBOL(udplite_table);
 
+/* Designate sk as UDP-Lite socket */
+static int udplite_sk_init(struct sock *sk)
+{
+	udp_init_sock(sk);
+	udp_sk(sk)->pcflag = UDPLITE_BIT;
+	return 0;
+}
+
 static int udplite_rcv(struct sk_buff *skb)
 {
 	return __udp4_lib_rcv(skb, &udplite_table, IPPROTO_UDPLITE);
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 4df9dc9375c8..4247997077bf 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -107,6 +107,13 @@ static __inline__ struct ipv6_pinfo *inet6_sk_generic(struct sock *sk)
 	return (struct ipv6_pinfo *)(((u8 *)sk) + offset);
 }
 
+void inet6_sock_destruct(struct sock *sk)
+{
+	inet6_cleanup_sock(sk);
+	inet_sock_destruct(sk);
+}
+EXPORT_SYMBOL_GPL(inet6_sock_destruct);
+
 static int inet6_create(struct net *net, struct socket *sock, int protocol,
 			int kern)
 {
@@ -199,7 +206,7 @@ static int inet6_create(struct net *net, struct socket *sock, int protocol,
 			inet->hdrincl = 1;
 	}
 
-	sk->sk_destruct		= inet_sock_destruct;
+	sk->sk_destruct		= inet6_sock_destruct;
 	sk->sk_family		= PF_INET6;
 	sk->sk_protocol		= protocol;
 
@@ -503,6 +510,12 @@ void inet6_destroy_sock(struct sock *sk)
 }
 EXPORT_SYMBOL_GPL(inet6_destroy_sock);
 
+void inet6_cleanup_sock(struct sock *sk)
+{
+	inet6_destroy_sock(sk);
+}
+EXPORT_SYMBOL_GPL(inet6_cleanup_sock);
+
 /*
  *	This does both peername and sockname.
  */
diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index 2017257cb278..7b4b457a8b87 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -429,9 +429,6 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 		if (optlen < sizeof(int))
 			goto e_inval;
 		if (val == PF_INET) {
-			struct ipv6_txoptions *opt;
-			struct sk_buff *pktopt;
-
 			if (sk->sk_type == SOCK_RAW)
 				break;
 
@@ -462,7 +459,6 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 				break;
 			}
 
-			fl6_free_socklist(sk);
 			__ipv6_sock_mc_close(sk);
 			__ipv6_sock_ac_close(sk);
 
@@ -497,14 +493,14 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 				sk->sk_socket->ops = &inet_dgram_ops;
 				sk->sk_family = PF_INET;
 			}
-			opt = xchg((__force struct ipv6_txoptions **)&np->opt,
-				   NULL);
-			if (opt) {
-				atomic_sub(opt->tot_len, &sk->sk_omem_alloc);
-				txopt_put(opt);
-			}
-			pktopt = xchg(&np->pktoptions, NULL);
-			kfree_skb(pktopt);
+
+			/* Disable all options not to allocate memory anymore,
+			 * but there is still a race.  See the lockless path
+			 * in udpv6_sendmsg() and ipv6_local_rxpmtu().
+			 */
+			np->rxopt.all = 0;
+
+			inet6_cleanup_sock(sk);
 
 			/*
 			 * ... and add it to the refcnt debug socks count
diff --git a/net/ipv6/ping.c b/net/ipv6/ping.c
index 135e3a060caa..6ac88fe24a8e 100644
--- a/net/ipv6/ping.c
+++ b/net/ipv6/ping.c
@@ -22,11 +22,6 @@
 #include <linux/proc_fs.h>
 #include <net/ping.h>
 
-static void ping_v6_destroy(struct sock *sk)
-{
-	inet6_destroy_sock(sk);
-}
-
 /* Compatibility glue so we can support IPv6 when it's compiled as a module */
 static int dummy_ipv6_recv_error(struct sock *sk, struct msghdr *msg, int len,
 				 int *addr_len)
@@ -171,7 +166,6 @@ struct proto pingv6_prot = {
 	.owner =	THIS_MODULE,
 	.init =		ping_init_sock,
 	.close =	ping_close,
-	.destroy =	ping_v6_destroy,
 	.connect =	ip6_datagram_connect_v6_only,
 	.disconnect =	__udp_disconnect,
 	.setsockopt =	ipv6_setsockopt,
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 110254f44a46..69f0f9c05d02 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -1211,8 +1211,6 @@ static void raw6_destroy(struct sock *sk)
 	lock_sock(sk);
 	ip6_flush_pending_frames(sk);
 	release_sock(sk);
-
-	inet6_destroy_sock(sk);
 }
 
 static int rawv6_init_sk(struct sock *sk)
diff --git a/net/ipv6/rpl.c b/net/ipv6/rpl.c
index 307f336b5353..3b0386437f69 100644
--- a/net/ipv6/rpl.c
+++ b/net/ipv6/rpl.c
@@ -32,7 +32,8 @@ static void *ipv6_rpl_segdata_pos(const struct ipv6_rpl_sr_hdr *hdr, int i)
 size_t ipv6_rpl_srh_size(unsigned char n, unsigned char cmpri,
 			 unsigned char cmpre)
 {
-	return (n * IPV6_PFXTAIL_LEN(cmpri)) + IPV6_PFXTAIL_LEN(cmpre);
+	return sizeof(struct ipv6_rpl_sr_hdr) + (n * IPV6_PFXTAIL_LEN(cmpri)) +
+		IPV6_PFXTAIL_LEN(cmpre);
 }
 
 void ipv6_rpl_srh_decompress(struct ipv6_rpl_sr_hdr *outhdr,
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index e4ae5362cb51..2347740d3cc7 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1936,12 +1936,6 @@ static int tcp_v6_init_sock(struct sock *sk)
 	return 0;
 }
 
-static void tcp_v6_destroy_sock(struct sock *sk)
-{
-	tcp_v4_destroy_sock(sk);
-	inet6_destroy_sock(sk);
-}
-
 #ifdef CONFIG_PROC_FS
 /* Proc filesystem TCPv6 sock list dumping. */
 static void get_openreq6(struct seq_file *seq,
@@ -2134,7 +2128,7 @@ struct proto tcpv6_prot = {
 	.accept			= inet_csk_accept,
 	.ioctl			= tcp_ioctl,
 	.init			= tcp_v6_init_sock,
-	.destroy		= tcp_v6_destroy_sock,
+	.destroy		= tcp_v4_destroy_sock,
 	.shutdown		= tcp_shutdown,
 	.setsockopt		= tcp_setsockopt,
 	.getsockopt		= tcp_getsockopt,
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 20cc08210c70..19c0721399d9 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -54,6 +54,19 @@
 #include <trace/events/skb.h>
 #include "udp_impl.h"
 
+static void udpv6_destruct_sock(struct sock *sk)
+{
+	udp_destruct_common(sk);
+	inet6_sock_destruct(sk);
+}
+
+int udpv6_init_sock(struct sock *sk)
+{
+	skb_queue_head_init(&udp_sk(sk)->reader_queue);
+	sk->sk_destruct = udpv6_destruct_sock;
+	return 0;
+}
+
 static u32 udp6_ehashfn(const struct net *net,
 			const struct in6_addr *laddr,
 			const u16 lport,
@@ -1617,8 +1630,6 @@ void udpv6_destroy_sock(struct sock *sk)
 			udp_encap_disable();
 		}
 	}
-
-	inet6_destroy_sock(sk);
 }
 
 /*
@@ -1702,7 +1713,7 @@ struct proto udpv6_prot = {
 	.connect		= ip6_datagram_connect,
 	.disconnect		= udp_disconnect,
 	.ioctl			= udp_ioctl,
-	.init			= udp_init_sock,
+	.init			= udpv6_init_sock,
 	.destroy		= udpv6_destroy_sock,
 	.setsockopt		= udpv6_setsockopt,
 	.getsockopt		= udpv6_getsockopt,
diff --git a/net/ipv6/udp_impl.h b/net/ipv6/udp_impl.h
index b2fcc46c1630..e49776819441 100644
--- a/net/ipv6/udp_impl.h
+++ b/net/ipv6/udp_impl.h
@@ -12,6 +12,7 @@ int __udp6_lib_rcv(struct sk_buff *, struct udp_table *, int);
 int __udp6_lib_err(struct sk_buff *, struct inet6_skb_parm *, u8, u8, int,
 		   __be32, struct udp_table *);
 
+int udpv6_init_sock(struct sock *sk);
 int udp_v6_get_port(struct sock *sk, unsigned short snum);
 void udp_v6_rehash(struct sock *sk);
 
diff --git a/net/ipv6/udplite.c b/net/ipv6/udplite.c
index fbb700d3f437..b6482e04dad0 100644
--- a/net/ipv6/udplite.c
+++ b/net/ipv6/udplite.c
@@ -12,6 +12,13 @@
 #include <linux/proc_fs.h>
 #include "udp_impl.h"
 
+static int udplitev6_sk_init(struct sock *sk)
+{
+	udpv6_init_sock(sk);
+	udp_sk(sk)->pcflag = UDPLITE_BIT;
+	return 0;
+}
+
 static int udplitev6_rcv(struct sk_buff *skb)
 {
 	return __udp6_lib_rcv(skb, &udplite_table, IPPROTO_UDPLITE);
@@ -38,7 +45,7 @@ struct proto udplitev6_prot = {
 	.connect	   = ip6_datagram_connect,
 	.disconnect	   = udp_disconnect,
 	.ioctl		   = udp_ioctl,
-	.init		   = udplite_sk_init,
+	.init		   = udplitev6_sk_init,
 	.destroy	   = udpv6_destroy_sock,
 	.setsockopt	   = udpv6_setsockopt,
 	.getsockopt	   = udpv6_getsockopt,
diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
index d54dbd01d86f..382124d6f764 100644
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -255,8 +255,6 @@ static void l2tp_ip6_destroy_sock(struct sock *sk)
 
 	if (tunnel)
 		l2tp_tunnel_delete(tunnel);
-
-	inet6_destroy_sock(sk);
 }
 
 static int l2tp_ip6_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len)
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index e61c85873ea2..72d944e6a641 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2863,12 +2863,6 @@ static const struct proto_ops mptcp_v6_stream_ops = {
 
 static struct proto mptcp_v6_prot;
 
-static void mptcp_v6_destroy(struct sock *sk)
-{
-	mptcp_destroy(sk);
-	inet6_destroy_sock(sk);
-}
-
 static struct inet_protosw mptcp_v6_protosw = {
 	.type		= SOCK_STREAM,
 	.protocol	= IPPROTO_MPTCP,
@@ -2884,7 +2878,6 @@ int __init mptcp_proto_v6_init(void)
 	mptcp_v6_prot = mptcp_prot;
 	strcpy(mptcp_v6_prot.name, "MPTCPv6");
 	mptcp_v6_prot.slab = NULL;
-	mptcp_v6_prot.destroy = mptcp_v6_destroy;
 	mptcp_v6_prot.obj_size = sizeof(struct mptcp6_sock);
 
 	err = proto_register(&mptcp_v6_prot, 1);
diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
index 1d1d81aeb389..cad7deacf60a 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -421,15 +421,16 @@ static int qfq_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
 	} else
 		weight = 1;
 
-	if (tb[TCA_QFQ_LMAX]) {
+	if (tb[TCA_QFQ_LMAX])
 		lmax = nla_get_u32(tb[TCA_QFQ_LMAX]);
-		if (lmax < QFQ_MIN_LMAX || lmax > (1UL << QFQ_MTU_SHIFT)) {
-			pr_notice("qfq: invalid max length %u\n", lmax);
-			return -EINVAL;
-		}
-	} else
+	else
 		lmax = psched_mtu(qdisc_dev(sch));
 
+	if (lmax < QFQ_MIN_LMAX || lmax > (1UL << QFQ_MTU_SHIFT)) {
+		pr_notice("qfq: invalid max length %u\n", lmax);
+		return -EINVAL;
+	}
+
 	inv_w = ONE_FP / weight;
 	weight = ONE_FP / inv_w;
 
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 3a68d65f7d15..35d3eee26ea5 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4995,13 +4995,17 @@ static void sctp_destroy_sock(struct sock *sk)
 }
 
 /* Triggered when there are no references on the socket anymore */
-static void sctp_destruct_sock(struct sock *sk)
+static void sctp_destruct_common(struct sock *sk)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
 
 	/* Free up the HMAC transform. */
 	crypto_free_shash(sp->hmac);
+}
 
+static void sctp_destruct_sock(struct sock *sk)
+{
+	sctp_destruct_common(sk);
 	inet_sock_destruct(sk);
 }
 
@@ -9195,7 +9199,7 @@ void sctp_copy_sock(struct sock *newsk, struct sock *sk,
 	sctp_sk(newsk)->reuse = sp->reuse;
 
 	newsk->sk_shutdown = sk->sk_shutdown;
-	newsk->sk_destruct = sctp_destruct_sock;
+	newsk->sk_destruct = sk->sk_destruct;
 	newsk->sk_family = sk->sk_family;
 	newsk->sk_protocol = IPPROTO_SCTP;
 	newsk->sk_backlog_rcv = sk->sk_prot->backlog_rcv;
@@ -9427,11 +9431,20 @@ struct proto sctp_prot = {
 
 #if IS_ENABLED(CONFIG_IPV6)
 
-#include <net/transp_v6.h>
-static void sctp_v6_destroy_sock(struct sock *sk)
+static void sctp_v6_destruct_sock(struct sock *sk)
+{
+	sctp_destruct_common(sk);
+	inet6_sock_destruct(sk);
+}
+
+static int sctp_v6_init_sock(struct sock *sk)
 {
-	sctp_destroy_sock(sk);
-	inet6_destroy_sock(sk);
+	int ret = sctp_init_sock(sk);
+
+	if (!ret)
+		sk->sk_destruct = sctp_v6_destruct_sock;
+
+	return ret;
 }
 
 struct proto sctpv6_prot = {
@@ -9441,8 +9454,8 @@ struct proto sctpv6_prot = {
 	.disconnect	= sctp_disconnect,
 	.accept		= sctp_accept,
 	.ioctl		= sctp_ioctl,
-	.init		= sctp_init_sock,
-	.destroy	= sctp_v6_destroy_sock,
+	.init		= sctp_v6_init_sock,
+	.destroy	= sctp_destroy_sock,
 	.shutdown	= sctp_shutdown,
 	.setsockopt	= sctp_setsockopt,
 	.getsockopt	= sctp_getsockopt,
diff --git a/scripts/asn1_compiler.c b/scripts/asn1_compiler.c
index adabd4145264..985fb81cae79 100644
--- a/scripts/asn1_compiler.c
+++ b/scripts/asn1_compiler.c
@@ -625,7 +625,7 @@ int main(int argc, char **argv)
 	p = strrchr(argv[1], '/');
 	p = p ? p + 1 : argv[1];
 	grammar_name = strdup(p);
-	if (!p) {
+	if (!grammar_name) {
 		perror(NULL);
 		exit(1);
 	}
diff --git a/sound/soc/fsl/fsl_asrc_dma.c b/sound/soc/fsl/fsl_asrc_dma.c
index 29f91cdecbc3..9b2a986ce415 100644
--- a/sound/soc/fsl/fsl_asrc_dma.c
+++ b/sound/soc/fsl/fsl_asrc_dma.c
@@ -207,14 +207,19 @@ static int fsl_asrc_dma_hw_params(struct snd_soc_component *component,
 		be_chan = soc_component_to_pcm(component_be)->chan[substream->stream];
 		tmp_chan = be_chan;
 	}
-	if (!tmp_chan)
-		tmp_chan = dma_request_slave_channel(dev_be, tx ? "tx" : "rx");
+	if (!tmp_chan) {
+		tmp_chan = dma_request_chan(dev_be, tx ? "tx" : "rx");
+		if (IS_ERR(tmp_chan)) {
+			dev_err(dev, "failed to request DMA channel for Back-End\n");
+			return -EINVAL;
+		}
+	}
 
 	/*
 	 * An EDMA DEV_TO_DEV channel is fixed and bound with DMA event of each
 	 * peripheral, unlike SDMA channel that is allocated dynamically. So no
 	 * need to configure dma_request and dma_request2, but get dma_chan of
-	 * Back-End device directly via dma_request_slave_channel.
+	 * Back-End device directly via dma_request_chan.
 	 */
 	if (!asrc->use_edma) {
 		/* Get DMA request of Back-End */
diff --git a/tools/testing/selftests/sigaltstack/current_stack_pointer.h b/tools/testing/selftests/sigaltstack/current_stack_pointer.h
new file mode 100644
index 000000000000..ea9bdf3a90b1
--- /dev/null
+++ b/tools/testing/selftests/sigaltstack/current_stack_pointer.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#if __alpha__
+register unsigned long sp asm("$30");
+#elif __arm__ || __aarch64__ || __csky__ || __m68k__ || __mips__ || __riscv
+register unsigned long sp asm("sp");
+#elif __i386__
+register unsigned long sp asm("esp");
+#elif __loongarch64
+register unsigned long sp asm("$sp");
+#elif __ppc__
+register unsigned long sp asm("r1");
+#elif __s390x__
+register unsigned long sp asm("%15");
+#elif __sh__
+register unsigned long sp asm("r15");
+#elif __x86_64__
+register unsigned long sp asm("rsp");
+#elif __XTENSA__
+register unsigned long sp asm("a1");
+#else
+#error "implement current_stack_pointer equivalent"
+#endif
diff --git a/tools/testing/selftests/sigaltstack/sas.c b/tools/testing/selftests/sigaltstack/sas.c
index 8934a3766d20..41646c22384a 100644
--- a/tools/testing/selftests/sigaltstack/sas.c
+++ b/tools/testing/selftests/sigaltstack/sas.c
@@ -19,6 +19,7 @@
 #include <errno.h>
 
 #include "../kselftest.h"
+#include "current_stack_pointer.h"
 
 #ifndef SS_AUTODISARM
 #define SS_AUTODISARM  (1U << 31)
@@ -40,12 +41,6 @@ void my_usr1(int sig, siginfo_t *si, void *u)
 	stack_t stk;
 	struct stk_data *p;
 
-#if __s390x__
-	register unsigned long sp asm("%15");
-#else
-	register unsigned long sp asm("sp");
-#endif
-
 	if (sp < (unsigned long)sstack ||
 			sp >= (unsigned long)sstack + SIGSTKSZ) {
 		ksft_exit_fail_msg("SP is not on sigaltstack\n");
