Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03B006EF47D
	for <lists+stable@lfdr.de>; Wed, 26 Apr 2023 14:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241010AbjDZMkq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Apr 2023 08:40:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240963AbjDZMkZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Apr 2023 08:40:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FDB85BBE;
        Wed, 26 Apr 2023 05:39:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 811E66363D;
        Wed, 26 Apr 2023 12:39:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15707C433D2;
        Wed, 26 Apr 2023 12:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682512790;
        bh=3x8V5DXzc9CD1k6nQbKdkCwV55gdNdVmwaTWTso198s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qbkY7bGgBTQowDkI24eo2/pIfuh6Y2PdaMqBMtX7ZnSRr532abovSywntzccVN4Bm
         Rfc5KzCEEXQQpHN+JAqxMdpybfyVyi/gr3BJaMkIZnhgVF7DswixqzkpGXZ5d3DACO
         2Y96NJQxk2V6z3Kp0HxLtiUkTvpPVboTEVauqPzc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.109
Date:   Wed, 26 Apr 2023 14:39:37 +0200
Message-Id: <2023042636-sulfide-cornball-6e4b@gregkh>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <2023042636-deserving-seltzer-f959@gregkh>
References: <2023042636-deserving-seltzer-f959@gregkh>
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
index 90bc3f51eda9..d431718921b7 100644
--- a/Documentation/kernel-hacking/locking.rst
+++ b/Documentation/kernel-hacking/locking.rst
@@ -1352,7 +1352,7 @@ Mutex API reference
 Futex API reference
 ===================
 
-.. kernel-doc:: kernel/futex.c
+.. kernel-doc:: kernel/futex/core.c
    :internal:
 
 Further reading
diff --git a/Documentation/translations/it_IT/kernel-hacking/locking.rst b/Documentation/translations/it_IT/kernel-hacking/locking.rst
index 1efb8293bf1f..9d6387e7b083 100644
--- a/Documentation/translations/it_IT/kernel-hacking/locking.rst
+++ b/Documentation/translations/it_IT/kernel-hacking/locking.rst
@@ -1396,7 +1396,7 @@ Riferimento per l'API dei Mutex
 Riferimento per l'API dei Futex
 ===============================
 
-.. kernel-doc:: kernel/futex.c
+.. kernel-doc:: kernel/futex/core.c
    :internal:
 
 Approfondimenti
diff --git a/Makefile b/Makefile
index 49ae089784a6..610991822c20 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 108
+SUBLEVEL = 109
 EXTRAVERSION =
 NAME = Trick or Treat
 
diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index 8670c948ca8d..2e6138eeacd1 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -940,7 +940,7 @@ wdt: watchdog@ff800000 {
 		status = "disabled";
 	};
 
-	spdif: sound@ff88b0000 {
+	spdif: sound@ff8b0000 {
 		compatible = "rockchip,rk3288-spdif", "rockchip,rk3066-spdif";
 		reg = <0x0 0xff8b0000 0x0 0x10000>;
 		#sound-dai-cells = <0>;
diff --git a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
index 899cfe416aef..369334076467 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
@@ -1610,10 +1610,9 @@ usb2_phy0: phy@36000 {
 
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
index e033d0257b5a..ff5324e94ee8 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-evk.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-evk.dtsi
@@ -136,7 +136,7 @@ pmic@4b {
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
index 1f98947fe715..91d6a5360bb9 100644
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
index 0ea3d02b378d..516c21baf3ad 100644
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -481,9 +481,7 @@ long arch_ptrace(struct task_struct *child, long request,
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
@@ -837,9 +835,7 @@ long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
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
diff --git a/drivers/counter/104-quad-8.c b/drivers/counter/104-quad-8.c
index e00cf156c6e9..ab2c49579b28 100644
--- a/drivers/counter/104-quad-8.c
+++ b/drivers/counter/104-quad-8.c
@@ -61,10 +61,6 @@ struct quad8 {
 #define QUAD8_REG_CHAN_OP 0x11
 #define QUAD8_REG_INDEX_INPUT_LEVELS 0x16
 #define QUAD8_DIFF_ENCODER_CABLE_STATUS 0x17
-/* Borrow Toggle flip-flop */
-#define QUAD8_FLAG_BT BIT(0)
-/* Carry Toggle flip-flop */
-#define QUAD8_FLAG_CT BIT(1)
 /* Error flag */
 #define QUAD8_FLAG_E BIT(4)
 /* Up/Down flag */
@@ -97,6 +93,9 @@ struct quad8 {
 #define QUAD8_CMR_QUADRATURE_X2 0x10
 #define QUAD8_CMR_QUADRATURE_X4 0x18
 
+/* Each Counter is 24 bits wide */
+#define LS7267_CNTR_MAX GENMASK(23, 0)
+
 static int quad8_signal_read(struct counter_device *counter,
 			     struct counter_signal *signal,
 			     enum counter_signal_level *level)
@@ -121,17 +120,9 @@ static int quad8_count_read(struct counter_device *counter,
 {
 	struct quad8 *const priv = counter->priv;
 	const int base_offset = priv->base + 2 * count->id;
-	unsigned int flags;
-	unsigned int borrow;
-	unsigned int carry;
 	int i;
 
-	flags = inb(base_offset + 1);
-	borrow = flags & QUAD8_FLAG_BT;
-	carry = !!(flags & QUAD8_FLAG_CT);
-
-	/* Borrow XOR Carry effectively doubles count range */
-	*val = (unsigned long)(borrow ^ carry) << 24;
+	*val = 0;
 
 	mutex_lock(&priv->lock);
 
@@ -154,8 +145,7 @@ static int quad8_count_write(struct counter_device *counter,
 	const int base_offset = priv->base + 2 * count->id;
 	int i;
 
-	/* Only 24-bit values are supported */
-	if (val > 0xFFFFFF)
+	if (val > LS7267_CNTR_MAX)
 		return -ERANGE;
 
 	mutex_lock(&priv->lock);
@@ -627,8 +617,7 @@ static int quad8_count_preset_write(struct counter_device *counter,
 {
 	struct quad8 *const priv = counter->priv;
 
-	/* Only 24-bit values are supported */
-	if (preset > 0xFFFFFF)
+	if (preset > LS7267_CNTR_MAX)
 		return -ERANGE;
 
 	mutex_lock(&priv->lock);
@@ -654,8 +643,7 @@ static int quad8_count_ceiling_read(struct counter_device *counter,
 		*ceiling = priv->preset[count->id];
 		break;
 	default:
-		/* By default 0x1FFFFFF (25 bits unsigned) is maximum count */
-		*ceiling = 0x1FFFFFF;
+		*ceiling = LS7267_CNTR_MAX;
 		break;
 	}
 
@@ -669,8 +657,7 @@ static int quad8_count_ceiling_write(struct counter_device *counter,
 {
 	struct quad8 *const priv = counter->priv;
 
-	/* Only 24-bit values are supported */
-	if (ceiling > 0xFFFFFF)
+	if (ceiling > LS7267_CNTR_MAX)
 		return -ERANGE;
 
 	mutex_lock(&priv->lock);
diff --git a/drivers/gpu/drm/i915/display/intel_dp_aux.c b/drivers/gpu/drm/i915/display/intel_dp_aux.c
index f483f479dd0b..fd7527a3087f 100644
--- a/drivers/gpu/drm/i915/display/intel_dp_aux.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_aux.c
@@ -167,7 +167,7 @@ static u32 skl_get_aux_send_ctl(struct intel_dp *intel_dp,
 	      DP_AUX_CH_CTL_TIME_OUT_MAX |
 	      DP_AUX_CH_CTL_RECEIVE_ERROR |
 	      (send_bytes << DP_AUX_CH_CTL_MESSAGE_SIZE_SHIFT) |
-	      DP_AUX_CH_CTL_FW_SYNC_PULSE_SKL(32) |
+	      DP_AUX_CH_CTL_FW_SYNC_PULSE_SKL(24) |
 	      DP_AUX_CH_CTL_SYNC_PULSE_SKL(32);
 
 	if (intel_phy_is_tc(i915, phy) &&
diff --git a/drivers/iio/adc/at91-sama5d2_adc.c b/drivers/iio/adc/at91-sama5d2_adc.c
index 403a29e4dc3e..ecb49bc452ae 100644
--- a/drivers/iio/adc/at91-sama5d2_adc.c
+++ b/drivers/iio/adc/at91-sama5d2_adc.c
@@ -1000,7 +1000,7 @@ static struct iio_trigger *at91_adc_allocate_trigger(struct iio_dev *indio,
 	trig = devm_iio_trigger_alloc(&indio->dev, "%s-dev%d-%s", indio->name,
 				iio_device_id(indio), trigger_name);
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
index 239c777f8271..339e765bcf5a 100644
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
index 660df7d269fa..d410e2e78a3d 100644
--- a/drivers/memstick/core/memstick.c
+++ b/drivers/memstick/core/memstick.c
@@ -410,6 +410,7 @@ static struct memstick_dev *memstick_alloc_card(struct memstick_host *host)
 	return card;
 err_out:
 	host->card = old_card;
+	kfree_const(card->dev.kobj.name);
 	kfree(card);
 	return NULL;
 }
@@ -468,8 +469,10 @@ static void memstick_check(struct work_struct *work)
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
index b3d3cb6ac656..0158b2b1507d 100644
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
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index e1dc94f01cb5..2816b6fc1739 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1746,14 +1746,15 @@ void bond_lower_state_changed(struct slave *slave)
 
 /* The bonding driver uses ether_setup() to convert a master bond device
  * to ARPHRD_ETHER, that resets the target netdevice's flags so we always
- * have to restore the IFF_MASTER flag, and only restore IFF_SLAVE if it was set
+ * have to restore the IFF_MASTER flag, and only restore IFF_SLAVE and IFF_UP
+ * if they were set
  */
 static void bond_ether_setup(struct net_device *bond_dev)
 {
-	unsigned int slave_flag = bond_dev->flags & IFF_SLAVE;
+	unsigned int flags = bond_dev->flags & (IFF_SLAVE | IFF_UP);
 
 	ether_setup(bond_dev);
-	bond_dev->flags |= IFF_MASTER | slave_flag;
+	bond_dev->flags |= IFF_MASTER | flags;
 	bond_dev->priv_flags &= ~IFF_TX_SKB_SHARING;
 }
 
diff --git a/drivers/net/dsa/b53/b53_mmap.c b/drivers/net/dsa/b53/b53_mmap.c
index 3388f620fac9..ca6f53c63067 100644
--- a/drivers/net/dsa/b53/b53_mmap.c
+++ b/drivers/net/dsa/b53/b53_mmap.c
@@ -216,6 +216,18 @@ static int b53_mmap_write64(struct b53_device *dev, u8 page, u8 reg,
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
@@ -227,6 +239,8 @@ static const struct b53_io_ops b53_mmap_ops = {
 	.write32 = b53_mmap_write32,
 	.write48 = b53_mmap_write48,
 	.write64 = b53_mmap_write64,
+	.phy_read16 = b53_mmap_phy_read16,
+	.phy_write16 = b53_mmap_phy_write16,
 };
 
 static int b53_mmap_probe_of(struct platform_device *pdev,
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 4ef90e0cb8f8..38fc2286f7cb 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -7437,7 +7437,7 @@ static int __bnxt_hwrm_ptp_qcfg(struct bnxt *bp)
 	u8 flags;
 	int rc;
 
-	if (bp->hwrm_spec_code < 0x10801) {
+	if (bp->hwrm_spec_code < 0x10801 || !BNXT_CHIP_P5_THOR(bp)) {
 		rc = -ENODEV;
 		goto no_ptp;
 	}
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 7e41ce188cc6..6b7d162af3e5 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -5298,31 +5298,6 @@ static void e1000_watchdog_task(struct work_struct *work)
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
@@ -7543,6 +7518,32 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
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
index 85d48efce1d0..3ebd589e56b5 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -10923,8 +10923,11 @@ static void i40e_rebuild(struct i40e_pf *pf, bool reinit, bool lock_acquired)
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
@@ -13945,15 +13948,15 @@ static int i40e_add_vsi(struct i40e_vsi *vsi)
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
index 7b531228d6c0..25e9f47db2a6 100644
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
index 16a896360f3f..41eb6f9f5596 100644
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
 
@@ -719,8 +715,6 @@ static int efx_register_netdev(struct efx_nic *efx)
 	 * already requested.  If so, the NIC is probably hosed so we
 	 * abort.
 	 */
-	efx->state = STATE_READY;
-	smp_mb(); /* ensure we change state before checking reset_pending */
 	if (efx->reset_pending) {
 		pci_err(efx->pci_dev, "aborting probe due to scheduled reset\n");
 		rc = -EIO;
@@ -747,6 +741,8 @@ static int efx_register_netdev(struct efx_nic *efx)
 
 	efx_associate(efx);
 
+	efx->state = STATE_NET_DOWN;
+
 	rtnl_unlock();
 
 	rc = device_create_file(&efx->pci_dev->dev, &dev_attr_phy_type);
@@ -848,7 +844,7 @@ static void efx_pci_remove_main(struct efx_nic *efx)
 	/* Flush reset_work. It can no longer be scheduled since we
 	 * are not READY.
 	 */
-	BUG_ON(efx->state == STATE_READY);
+	WARN_ON(efx_net_active(efx->state));
 	efx_flush_reset_workqueue(efx);
 
 	efx_disable_interrupts(efx);
@@ -1153,13 +1149,13 @@ static int efx_pm_freeze(struct device *dev)
 
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
@@ -1174,7 +1170,7 @@ static int efx_pm_thaw(struct device *dev)
 
 	rtnl_lock();
 
-	if (efx->state != STATE_DISABLED) {
+	if (efx_frozen(efx->state)) {
 		rc = efx_enable_interrupts(efx);
 		if (rc)
 			goto fail;
@@ -1187,7 +1183,7 @@ static int efx_pm_thaw(struct device *dev)
 
 		efx_device_attach_if_not_resetting(efx);
 
-		efx->state = STATE_READY;
+		efx->state = efx_thaw(efx->state);
 
 		efx->type->resume_wol(efx);
 	}
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index 896b59253197..6038b7e3e823 100644
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
@@ -1216,7 +1218,7 @@ static pci_ers_result_t efx_io_error_detected(struct pci_dev *pdev,
 	rtnl_lock();
 
 	if (efx->state != STATE_DISABLED) {
-		efx->state = STATE_RECOVERY;
+		efx->state = efx_recover(efx->state);
 		efx->reset_pending = 0;
 
 		efx_device_detach_sync(efx);
@@ -1270,7 +1272,7 @@ static void efx_io_resume(struct pci_dev *pdev)
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
index bf097264d8fb..6df500dbb6b7 100644
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
index 66ca2ea19ba6..8a380086ac25 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -679,8 +679,13 @@ static struct page *xdp_linearize_page(struct receive_queue *rq,
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
 
@@ -688,7 +693,6 @@ static struct page *xdp_linearize_page(struct receive_queue *rq,
 	page_off += *len;
 
 	while (--*num_buf) {
-		int tailroom = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 		unsigned int buflen;
 		void *buf;
 		int off;
diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 303d8ebbaafc..63118b56c528 100644
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
index 96d8d7844e84..fb47d0603e05 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1563,22 +1563,7 @@ static int nvme_tcp_alloc_queue(struct nvme_ctrl *nctrl,
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
 
@@ -1598,7 +1583,7 @@ static int nvme_tcp_alloc_queue(struct nvme_ctrl *nctrl,
 	return ret;
 }
 
-static void nvme_tcp_restore_sock_calls(struct nvme_tcp_queue *queue)
+static void nvme_tcp_restore_sock_ops(struct nvme_tcp_queue *queue)
 {
 	struct socket *sock = queue->sock;
 
@@ -1613,7 +1598,7 @@ static void nvme_tcp_restore_sock_calls(struct nvme_tcp_queue *queue)
 static void __nvme_tcp_stop_queue(struct nvme_tcp_queue *queue)
 {
 	kernel_sock_shutdown(queue->sock, SHUT_RDWR);
-	nvme_tcp_restore_sock_calls(queue);
+	nvme_tcp_restore_sock_ops(queue);
 	cancel_work_sync(&queue->io_work);
 }
 
@@ -1628,21 +1613,42 @@ static void nvme_tcp_stop_queue(struct nvme_ctrl *nctrl, int qid)
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
 		ret = nvmf_connect_io_queue(nctrl, idx);
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
diff --git a/drivers/platform/x86/gigabyte-wmi.c b/drivers/platform/x86/gigabyte-wmi.c
index 0163e912fafe..bf1b98dd00b9 100644
--- a/drivers/platform/x86/gigabyte-wmi.c
+++ b/drivers/platform/x86/gigabyte-wmi.c
@@ -140,6 +140,7 @@ static u8 gigabyte_wmi_detect_sensor_usability(struct wmi_device *wdev)
 	}}
 
 static const struct dmi_system_id gigabyte_wmi_known_working_platforms[] = {
+	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("A320M-S2H V2-CF"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B450M DS3H-CF"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B450M DS3H WIFI-CF"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B450M S2H V2"),
@@ -155,6 +156,7 @@ static const struct dmi_system_id gigabyte_wmi_known_working_platforms[] = {
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("X570 GAMING X"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("X570 I AORUS PRO WIFI"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("X570 UD"),
+	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("X570S AORUS ELITE"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("Z690M AORUS ELITE AX DDR4"),
 	{ }
 };
diff --git a/drivers/pwm/pwm-hibvt.c b/drivers/pwm/pwm-hibvt.c
index 333f1b18ff4e..54035563fc0e 100644
--- a/drivers/pwm/pwm-hibvt.c
+++ b/drivers/pwm/pwm-hibvt.c
@@ -146,6 +146,7 @@ static void hibvt_pwm_get_state(struct pwm_chip *chip, struct pwm_device *pwm,
 
 	value = readl(base + PWM_CTRL_ADDR(pwm->hwpwm));
 	state->enabled = (PWM_ENABLE_MASK & value);
+	state->polarity = (PWM_POLARITY_MASK & value) ? PWM_POLARITY_INVERSED : PWM_POLARITY_NORMAL;
 }
 
 static int hibvt_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
diff --git a/drivers/pwm/pwm-iqs620a.c b/drivers/pwm/pwm-iqs620a.c
index 54bd95a5cab0..8cee8f626d4e 100644
--- a/drivers/pwm/pwm-iqs620a.c
+++ b/drivers/pwm/pwm-iqs620a.c
@@ -126,6 +126,7 @@ static void iqs620_pwm_get_state(struct pwm_chip *chip, struct pwm_device *pwm,
 	mutex_unlock(&iqs620_pwm->lock);
 
 	state->period = IQS620_PWM_PERIOD_NS;
+	state->polarity = PWM_POLARITY_NORMAL;
 }
 
 static int iqs620_pwm_notifier(struct notifier_block *notifier,
diff --git a/drivers/pwm/pwm-meson.c b/drivers/pwm/pwm-meson.c
index 3cf3bcf5ddfc..b2e6d00066d7 100644
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
index dac1fb584fa3..ecd5a50c6166 100644
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
@@ -60,7 +61,7 @@
 #define TCS_VSEL1_MODE		(1 << 6)
 
 #define TCS_SLEW_SHIFT		3
-#define TCS_SLEW_MASK		(0x3 < 3)
+#define TCS_SLEW_MASK		GENMASK(4, 3)
 
 enum fan53555_vendor {
 	FAN53526_VENDOR_FAIRCHILD = 0,
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 88e164e3d2ea..f7da1876e7a3 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3302,7 +3302,7 @@ fw_crash_buffer_show(struct device *cdev,
 
 	spin_lock_irqsave(&instance->crashdump_lock, flags);
 	buff_offset = instance->fw_crash_buffer_offset;
-	if (!instance->crash_dump_buf &&
+	if (!instance->crash_dump_buf ||
 		!((instance->fw_crash_state == AVAILABLE) ||
 		(instance->fw_crash_state == COPYING))) {
 		dev_err(&instance->pdev->dev,
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 4fc9466d820a..a499a5715072 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -323,11 +323,18 @@ static int scsi_vpd_inquiry(struct scsi_device *sdev, unsigned char *buffer,
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
diff --git a/drivers/soc/sifive/sifive_l2_cache.c b/drivers/soc/sifive/sifive_l2_cache.c
index 59640a1d0b28..783158070490 100644
--- a/drivers/soc/sifive/sifive_l2_cache.c
+++ b/drivers/soc/sifive/sifive_l2_cache.c
@@ -202,17 +202,22 @@ static int __init sifive_l2_init(void)
 	if (!np)
 		return -ENODEV;
 
-	if (of_address_to_resource(np, 0, &res))
-		return -ENODEV;
+	if (of_address_to_resource(np, 0, &res)) {
+		rc = -ENODEV;
+		goto err_node_put;
+	}
 
 	l2_base = ioremap(res.start, resource_size(&res));
-	if (!l2_base)
-		return -ENOMEM;
+	if (!l2_base) {
+		rc = -ENOMEM;
+		goto err_node_put;
+	}
 
 	intr_num = of_property_count_u32_elems(np, "interrupts");
 	if (!intr_num) {
 		pr_err("L2CACHE: no interrupts property\n");
-		return -ENODEV;
+		rc = -ENODEV;
+		goto err_unmap;
 	}
 
 	for (i = 0; i < intr_num; i++) {
@@ -220,9 +225,10 @@ static int __init sifive_l2_init(void)
 		rc = request_irq(g_irq[i], l2_int_handler, 0, "l2_ecc", NULL);
 		if (rc) {
 			pr_err("L2CACHE: Could not request IRQ %d\n", g_irq[i]);
-			return rc;
+			goto err_free_irq;
 		}
 	}
+	of_node_put(np);
 
 	l2_config_read();
 
@@ -233,5 +239,14 @@ static int __init sifive_l2_init(void)
 	setup_sifive_debug();
 #endif
 	return 0;
+
+err_free_irq:
+	while (--i >= 0)
+		free_irq(g_irq[i], NULL);
+err_unmap:
+	iounmap(l2_base);
+err_node_put:
+	of_node_put(np);
+	return rc;
 }
 device_initcall(sifive_l2_init);
diff --git a/drivers/spi/spi-rockchip-sfc.c b/drivers/spi/spi-rockchip-sfc.c
index a46b38544027..014106f8f978 100644
--- a/drivers/spi/spi-rockchip-sfc.c
+++ b/drivers/spi/spi-rockchip-sfc.c
@@ -634,7 +634,7 @@ static int rockchip_sfc_probe(struct platform_device *pdev)
 	if (ret) {
 		dev_err(dev, "Failed to request irq\n");
 
-		return ret;
+		goto err_irq;
 	}
 
 	ret = rockchip_sfc_init(sfc);
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 80a2181b402b..1abbdd78389a 100644
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
@@ -476,6 +476,7 @@ static int fuse_create_open(struct inode *dir, struct dentry *entry,
 	struct fuse_entry_out outentry;
 	struct fuse_inode *fi;
 	struct fuse_file *ff;
+	bool trunc = flags & O_TRUNC;
 
 	/* Userspace expects S_IFREG in create mode */
 	BUG_ON((mode & S_IFMT) != S_IFREG);
@@ -500,7 +501,7 @@ static int fuse_create_open(struct inode *dir, struct dentry *entry,
 	inarg.mode = mode;
 	inarg.umask = current_umask();
 
-	if (fm->fc->handle_killpriv_v2 && (flags & O_TRUNC) &&
+	if (fm->fc->handle_killpriv_v2 && trunc &&
 	    !(flags & O_EXCL) && !capable(CAP_FSETID)) {
 		inarg.open_flags |= FUSE_OPEN_KILL_SUIDGID;
 	}
@@ -549,6 +550,10 @@ static int fuse_create_open(struct inode *dir, struct dentry *entry,
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
index 2b19d281351e..2c4cac6104c9 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -210,12 +210,9 @@ void fuse_finish_open(struct inode *inode, struct file *file)
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
 
 	if ((file->f_mode & FMODE_WRITE) && fc->writeback_cache)
@@ -240,30 +237,38 @@ int fuse_open_common(struct inode *inode, struct file *file, bool isdir)
 	if (err)
 		return err;
 
-	if (is_wb_truncate || dax_truncate) {
+	if (is_wb_truncate || dax_truncate)
 		inode_lock(inode);
-		fuse_set_nowrite(inode);
-	}
 
 	if (dax_truncate) {
 		filemap_invalidate_lock(inode->i_mapping);
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
 		filemap_invalidate_unlock(inode->i_mapping);
-
-	if (is_wb_truncate | dax_truncate) {
-		fuse_release_nowrite(inode);
+out_inode_unlock:
+	if (is_wb_truncate || dax_truncate)
 		inode_unlock(inode);
-	}
 
 	return err;
 }
@@ -793,7 +798,7 @@ static void fuse_read_update_size(struct inode *inode, loff_t size,
 	struct fuse_inode *fi = get_fuse_inode(inode);
 
 	spin_lock(&fi->lock);
-	if (attr_ver == fi->attr_version && size < inode->i_size &&
+	if (attr_ver >= fi->attr_version && size < inode->i_size &&
 	    !test_bit(FUSE_I_SIZE_UNSTABLE, &fi->state)) {
 		fi->attr_version = atomic64_inc_return(&fc->attr_version);
 		i_size_write(inode, size);
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index a276a2d236ed..da233ab435ce 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -430,6 +430,23 @@ static int nilfs_segctor_reset_segment_buffer(struct nilfs_sc_info *sci)
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
@@ -438,6 +455,7 @@ static int nilfs_segctor_feed_segment(struct nilfs_sc_info *sci)
 				* The current segment is filled up
 				* (internal code)
 				*/
+	nilfs_segctor_zeropad_segsum(sci);
 	sci->sc_curseg = NILFS_NEXT_SEGBUF(sci->sc_curseg);
 	return nilfs_segctor_reset_segment_buffer(sci);
 }
@@ -542,6 +560,7 @@ static int nilfs_segctor_add_file_block(struct nilfs_sc_info *sci,
 		goto retry;
 	}
 	if (unlikely(required)) {
+		nilfs_segctor_zeropad_segsum(sci);
 		err = nilfs_segbuf_extend_segsum(segbuf);
 		if (unlikely(err))
 			goto failed;
@@ -1531,6 +1550,7 @@ static int nilfs_segctor_collect(struct nilfs_sc_info *sci,
 		nadd = min_t(int, nadd << 1, SC_MAX_SEGDELTA);
 		sci->sc_stage = prev_stage;
 	}
+	nilfs_segctor_zeropad_segsum(sci);
 	nilfs_segctor_truncate_segments(sci, sci->sc_curseg, nilfs->ns_sufile);
 	return 0;
 
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 19e595cab23a..7ed1d4472c0c 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -259,6 +259,7 @@ struct nf_bridge_info {
 	u8			pkt_otherhost:1;
 	u8			in_prerouting:1;
 	u8			bridged_dnat:1;
+	u8			sabotage_in_done:1;
 	__u16			frag_max_size;
 	struct net_device	*physindev;
 
@@ -4461,7 +4462,7 @@ static inline void nf_reset_ct(struct sk_buff *skb)
 
 static inline void nf_reset_trace(struct sk_buff *skb)
 {
-#if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TRACE) || defined(CONFIG_NF_TABLES)
+#if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TRACE) || IS_ENABLED(CONFIG_NF_TABLES)
 	skb->nf_trace = 0;
 #endif
 }
@@ -4481,7 +4482,7 @@ static inline void __nf_copy(struct sk_buff *dst, const struct sk_buff *src,
 	dst->_nfct = src->_nfct;
 	nf_conntrack_get(skb_nfct(src));
 #endif
-#if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TRACE) || defined(CONFIG_NF_TABLES)
+#if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TRACE) || IS_ENABLED(CONFIG_NF_TABLES)
 	if (copy)
 		dst->nf_trace = src->nf_trace;
 #endif
diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index a5e18d65c82d..e3ab99f4edab 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -1118,6 +1118,8 @@ void ipv6_icmp_error(struct sock *sk, struct sk_buff *skb, int err, __be16 port,
 void ipv6_local_error(struct sock *sk, int err, struct flowi6 *fl6, u32 info);
 void ipv6_local_rxpmtu(struct sock *sk, struct flowi6 *fl6, u32 mtu);
 
+void inet6_cleanup_sock(struct sock *sk);
+void inet6_sock_destruct(struct sock *sk);
 int inet6_release(struct socket *sock);
 int inet6_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len);
 int inet6_getname(struct socket *sock, struct sockaddr *uaddr,
diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 80df8ff5e675..8def00a04541 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1030,6 +1030,10 @@ struct nft_chain {
 };
 
 int nft_chain_validate(const struct nft_ctx *ctx, const struct nft_chain *chain);
+int nft_setelem_validate(const struct nft_ctx *ctx, struct nft_set *set,
+			 const struct nft_set_iter *iter,
+			 struct nft_set_elem *elem);
+int nft_set_catchall_validate(const struct nft_ctx *ctx, struct nft_set *set);
 
 enum nft_chain_types {
 	NFT_CHAIN_T_DEFAULT = 0,
diff --git a/include/net/udp.h b/include/net/udp.h
index 930666c0b6e5..10508c66e7a1 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -270,7 +270,7 @@ static inline bool udp_sk_bound_dev_eq(struct net *net, int bound_dev_if,
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
index 4cb055af1ec0..f5dcf7c9b707 100644
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
index 1c95d97e7aa5..37d4b5f5ec0c 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2279,6 +2279,21 @@ static int backtrack_insn(struct bpf_verifier_env *env, int idx,
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
diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index fcd9ad3f7f2e..b7fa3ee3aa1d 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -87,15 +87,31 @@ static inline int __ww_mutex_check_kill(struct rt_mutex *lock,
  * set this bit before looking at the lock.
  */
 
-static __always_inline void
-rt_mutex_set_owner(struct rt_mutex_base *lock, struct task_struct *owner)
+static __always_inline struct task_struct *
+rt_mutex_owner_encode(struct rt_mutex_base *lock, struct task_struct *owner)
 {
 	unsigned long val = (unsigned long)owner;
 
 	if (rt_mutex_has_waiters(lock))
 		val |= RT_MUTEX_HAS_WAITERS;
 
-	WRITE_ONCE(lock->owner, (struct task_struct *)val);
+	return (struct task_struct *)val;
+}
+
+static __always_inline void
+rt_mutex_set_owner(struct rt_mutex_base *lock, struct task_struct *owner)
+{
+	/*
+	 * lock->wait_lock is held but explicit acquire semantics are needed
+	 * for a new lock owner so WRITE_ONCE is insufficient.
+	 */
+	xchg_acquire(&lock->owner, rt_mutex_owner_encode(lock, owner));
+}
+
+static __always_inline void rt_mutex_clear_owner(struct rt_mutex_base *lock)
+{
+	/* lock->wait_lock is held so the unlock provides release semantics. */
+	WRITE_ONCE(lock->owner, rt_mutex_owner_encode(lock, NULL));
 }
 
 static __always_inline void clear_rt_mutex_waiters(struct rt_mutex_base *lock)
@@ -104,7 +120,8 @@ static __always_inline void clear_rt_mutex_waiters(struct rt_mutex_base *lock)
 			((unsigned long)lock->owner & ~RT_MUTEX_HAS_WAITERS);
 }
 
-static __always_inline void fixup_rt_mutex_waiters(struct rt_mutex_base *lock)
+static __always_inline void
+fixup_rt_mutex_waiters(struct rt_mutex_base *lock, bool acquire_lock)
 {
 	unsigned long owner, *p = (unsigned long *) &lock->owner;
 
@@ -170,8 +187,21 @@ static __always_inline void fixup_rt_mutex_waiters(struct rt_mutex_base *lock)
 	 * still set.
 	 */
 	owner = READ_ONCE(*p);
-	if (owner & RT_MUTEX_HAS_WAITERS)
-		WRITE_ONCE(*p, owner & ~RT_MUTEX_HAS_WAITERS);
+	if (owner & RT_MUTEX_HAS_WAITERS) {
+		/*
+		 * See rt_mutex_set_owner() and rt_mutex_clear_owner() on
+		 * why xchg_acquire() is used for updating owner for
+		 * locking and WRITE_ONCE() for unlocking.
+		 *
+		 * WRITE_ONCE() would work for the acquire case too, but
+		 * in case that the lock acquisition failed it might
+		 * force other lockers into the slow path unnecessarily.
+		 */
+		if (acquire_lock)
+			xchg_acquire(p, owner & ~RT_MUTEX_HAS_WAITERS);
+		else
+			WRITE_ONCE(*p, owner & ~RT_MUTEX_HAS_WAITERS);
+	}
 }
 
 /*
@@ -206,6 +236,13 @@ static __always_inline void mark_rt_mutex_waiters(struct rt_mutex_base *lock)
 		owner = *p;
 	} while (cmpxchg_relaxed(p, owner,
 				 owner | RT_MUTEX_HAS_WAITERS) != owner);
+
+	/*
+	 * The cmpxchg loop above is relaxed to avoid back-to-back ACQUIRE
+	 * operations in the event of contention. Ensure the successful
+	 * cmpxchg is visible.
+	 */
+	smp_mb__after_atomic();
 }
 
 /*
@@ -1232,7 +1269,7 @@ static int __sched __rt_mutex_slowtrylock(struct rt_mutex_base *lock)
 	 * try_to_take_rt_mutex() sets the lock waiters bit
 	 * unconditionally. Clean this up.
 	 */
-	fixup_rt_mutex_waiters(lock);
+	fixup_rt_mutex_waiters(lock, true);
 
 	return ret;
 }
@@ -1592,7 +1629,7 @@ static int __sched __rt_mutex_slowlock(struct rt_mutex_base *lock,
 	 * try_to_take_rt_mutex() sets the waiter bit
 	 * unconditionally. We might have to fix that up.
 	 */
-	fixup_rt_mutex_waiters(lock);
+	fixup_rt_mutex_waiters(lock, true);
 	return ret;
 }
 
@@ -1702,7 +1739,7 @@ static void __sched rtlock_slowlock_locked(struct rt_mutex_base *lock)
 	 * try_to_take_rt_mutex() sets the waiter bit unconditionally.
 	 * We might have to fix that up:
 	 */
-	fixup_rt_mutex_waiters(lock);
+	fixup_rt_mutex_waiters(lock, true);
 	debug_rt_mutex_free_waiter(&waiter);
 }
 
diff --git a/kernel/locking/rtmutex_api.c b/kernel/locking/rtmutex_api.c
index 5c9299aaabae..a461be2f873d 100644
--- a/kernel/locking/rtmutex_api.c
+++ b/kernel/locking/rtmutex_api.c
@@ -245,7 +245,7 @@ void __sched rt_mutex_init_proxy_locked(struct rt_mutex_base *lock,
 void __sched rt_mutex_proxy_unlock(struct rt_mutex_base *lock)
 {
 	debug_rt_mutex_proxy_unlock(lock);
-	rt_mutex_set_owner(lock, NULL);
+	rt_mutex_clear_owner(lock);
 }
 
 /**
@@ -360,7 +360,7 @@ int __sched rt_mutex_wait_proxy_lock(struct rt_mutex_base *lock,
 	 * try_to_take_rt_mutex() sets the waiter bit unconditionally. We might
 	 * have to fix that up.
 	 */
-	fixup_rt_mutex_waiters(lock);
+	fixup_rt_mutex_waiters(lock, true);
 	raw_spin_unlock_irq(&lock->wait_lock);
 
 	return ret;
@@ -416,7 +416,7 @@ bool __sched rt_mutex_cleanup_proxy_lock(struct rt_mutex_base *lock,
 	 * try_to_take_rt_mutex() sets the waiter bit unconditionally. We might
 	 * have to fix that up.
 	 */
-	fixup_rt_mutex_waiters(lock);
+	fixup_rt_mutex_waiters(lock, false);
 
 	raw_spin_unlock_irq(&lock->wait_lock);
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index acf7c09c9152..ed57d8358f24 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1335,7 +1335,7 @@ static inline void uclamp_idle_reset(struct rq *rq, enum uclamp_id clamp_id,
 	if (!(rq->uclamp_flags & UCLAMP_FLAG_IDLE))
 		return;
 
-	WRITE_ONCE(rq->uclamp[clamp_id].value, clamp_value);
+	uclamp_rq_set(rq, clamp_id, clamp_value);
 }
 
 static inline
@@ -1513,8 +1513,8 @@ static inline void uclamp_rq_inc_id(struct rq *rq, struct task_struct *p,
 	if (bucket->tasks == 1 || uc_se->value > bucket->value)
 		bucket->value = uc_se->value;
 
-	if (uc_se->value > READ_ONCE(uc_rq->value))
-		WRITE_ONCE(uc_rq->value, uc_se->value);
+	if (uc_se->value > uclamp_rq_get(rq, clamp_id))
+		uclamp_rq_set(rq, clamp_id, uc_se->value);
 }
 
 /*
@@ -1580,7 +1580,7 @@ static inline void uclamp_rq_dec_id(struct rq *rq, struct task_struct *p,
 	if (likely(bucket->tasks))
 		return;
 
-	rq_clamp = READ_ONCE(uc_rq->value);
+	rq_clamp = uclamp_rq_get(rq, clamp_id);
 	/*
 	 * Defensive programming: this should never happen. If it happens,
 	 * e.g. due to future modification, warn and fixup the expected value.
@@ -1588,7 +1588,7 @@ static inline void uclamp_rq_dec_id(struct rq *rq, struct task_struct *p,
 	SCHED_WARN_ON(bucket->value > rq_clamp);
 	if (bucket->value >= rq_clamp) {
 		bkt_clamp = uclamp_rq_max_value(rq, clamp_id, uc_se->value);
-		WRITE_ONCE(uc_rq->value, bkt_clamp);
+		uclamp_rq_set(rq, clamp_id, bkt_clamp);
 	}
 }
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7ac00dede846..591fdc81378e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3974,14 +3974,16 @@ static inline unsigned long task_util_est(struct task_struct *p)
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
@@ -4157,12 +4159,16 @@ static inline int util_fits_cpu(unsigned long util,
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
@@ -5739,7 +5745,10 @@ static inline unsigned long cpu_util(int cpu);
 
 static inline bool cpu_overutilized(int cpu)
 {
-	return !fits_capacity(cpu_util(cpu), capacity_of(cpu));
+	unsigned long rq_util_min = uclamp_rq_get(cpu_rq(cpu), UCLAMP_MIN);
+	unsigned long rq_util_max = uclamp_rq_get(cpu_rq(cpu), UCLAMP_MAX);
+
+	return !util_fits_cpu(cpu_util(cpu), rq_util_min, rq_util_max, cpu);
 }
 
 static inline void update_overutilized_status(struct rq *rq)
@@ -6985,6 +6994,8 @@ compute_energy(struct task_struct *p, int dst_cpu, struct perf_domain *pd)
 static int find_energy_efficient_cpu(struct task_struct *p, int prev_cpu)
 {
 	unsigned long prev_delta = ULONG_MAX, best_delta = ULONG_MAX;
+	unsigned long p_util_min = uclamp_is_used() ? uclamp_eff_value(p, UCLAMP_MIN) : 0;
+	unsigned long p_util_max = uclamp_is_used() ? uclamp_eff_value(p, UCLAMP_MAX) : 1024;
 	struct root_domain *rd = cpu_rq(smp_processor_id())->rd;
 	int cpu, best_energy_cpu = prev_cpu, target = -1;
 	unsigned long cpu_cap, util, base_energy = 0;
@@ -7009,16 +7020,20 @@ static int find_energy_efficient_cpu(struct task_struct *p, int prev_cpu)
 	target = prev_cpu;
 
 	sync_entity_load_avg(&p->se);
-	if (!task_util_est(p))
+	if (!uclamp_task_util(p, p_util_min, p_util_max))
 		goto unlock;
 
 	for (; pd; pd = pd->next) {
+		unsigned long util_min = p_util_min, util_max = p_util_max;
 		unsigned long cur_delta, spare_cap, max_spare_cap = 0;
+		unsigned long rq_util_min, rq_util_max;
 		bool compute_prev_delta = false;
 		unsigned long base_energy_pd;
 		int max_spare_cap_cpu = -1;
 
 		for_each_cpu_and(cpu, perf_domain_span(pd), sched_domain_span(sd)) {
+			struct rq *rq = cpu_rq(cpu);
+
 			if (!cpumask_test_cpu(cpu, p->cpus_ptr))
 				continue;
 
@@ -7034,8 +7049,21 @@ static int find_energy_efficient_cpu(struct task_struct *p, int prev_cpu)
 			 * much capacity we can get out of the CPU; this is
 			 * aligned with sched_cpu_util().
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
 
 			if (cpu == prev_cpu) {
@@ -8591,16 +8619,82 @@ static unsigned long scale_rt_capacity(int cpu)
 
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
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index e1f46ed412bc..6312f1904825 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1003,6 +1003,7 @@ struct rq {
 
 	unsigned long		cpu_capacity;
 	unsigned long		cpu_capacity_orig;
+	unsigned long		cpu_capacity_inverted;
 
 	struct callback_head	*balance_callback;
 
@@ -2855,6 +2856,23 @@ static inline void cpufreq_update_util(struct rq *rq, unsigned int flags) {}
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
@@ -2890,12 +2908,12 @@ unsigned long uclamp_rq_util_with(struct rq *rq, unsigned long util,
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
@@ -2941,6 +2959,25 @@ static inline bool uclamp_is_used(void)
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
@@ -2957,6 +2994,24 @@ static inline unsigned long capacity_orig_of(int cpu)
 	return cpu_rq(cpu)->cpu_capacity_orig;
 }
 
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
+
 /**
  * enum cpu_util_type - CPU utilization type
  * @FREQUENCY_UTIL:	Utilization used to select frequency
diff --git a/kernel/sys.c b/kernel/sys.c
index 2d2bc6396515..2efab4474635 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -656,6 +656,7 @@ long __sys_setresuid(uid_t ruid, uid_t euid, uid_t suid)
 	struct cred *new;
 	int retval;
 	kuid_t kruid, keuid, ksuid;
+	bool ruid_new, euid_new, suid_new;
 
 	kruid = make_kuid(ns, ruid);
 	keuid = make_kuid(ns, euid);
@@ -670,25 +671,29 @@ long __sys_setresuid(uid_t ruid, uid_t euid, uid_t suid)
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
@@ -753,6 +758,7 @@ long __sys_setresgid(gid_t rgid, gid_t egid, gid_t sgid)
 	struct cred *new;
 	int retval;
 	kgid_t krgid, kegid, ksgid;
+	bool rgid_new, egid_new, sgid_new;
 
 	krgid = make_kgid(ns, rgid);
 	kegid = make_kgid(ns, egid);
@@ -765,23 +771,28 @@ long __sys_setresgid(gid_t rgid, gid_t egid, gid_t sgid)
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
index 3afcb1466ec5..203792e70ac1 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -625,6 +625,10 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
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
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c929357fbefe..f320ee2bd34a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6416,7 +6416,21 @@ static void __build_all_zonelists(void *data)
 	int nid;
 	int __maybe_unused cpu;
 	pg_data_t *self = data;
+	unsigned long flags;
 
+	/*
+	 * Explicitly disable this CPU's interrupts before taking seqlock
+	 * to prevent any IRQ handler from calling into the page allocator
+	 * (e.g. GFP_ATOMIC) that could hit zonelist_iter_begin and livelock.
+	 */
+	local_irq_save(flags);
+	/*
+	 * Explicitly disable this CPU's synchronous printk() before taking
+	 * seqlock to prevent any printk() from trying to hold port->lock, for
+	 * tty_insert_flip_string_and_push_buffer() on other CPU might be
+	 * calling kmalloc(GFP_ATOMIC | __GFP_NOWARN) with port->lock held.
+	 */
+	printk_deferred_enter();
 	write_seqlock(&zonelist_update_seq);
 
 #ifdef CONFIG_NUMA
@@ -6451,6 +6465,8 @@ static void __build_all_zonelists(void *data)
 	}
 
 	write_sequnlock(&zonelist_update_seq);
+	printk_deferred_exit();
+	local_irq_restore(flags);
 }
 
 static noinline void __init
@@ -9239,6 +9255,9 @@ static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
 
 		if (PageReserved(page))
 			return false;
+
+		if (PageHuge(page))
+			return false;
 	}
 	return true;
 }
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
index a28536ad765b..b1fa335e0b52 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -1002,6 +1002,12 @@ static const struct inet_connection_sock_af_ops dccp_ipv6_mapped = {
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
@@ -1014,17 +1020,12 @@ static int dccp_v6_init_sock(struct sock *sk)
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
@@ -1047,7 +1048,7 @@ static struct proto dccp_v6_prot = {
 	.accept		   = inet_csk_accept,
 	.get_port	   = inet_csk_get_port,
 	.shutdown	   = dccp_shutdown,
-	.destroy	   = dccp_v6_destroy_sock,
+	.destroy	   = dccp_destroy_sock,
 	.orphan_count	   = &dccp_orphan_count,
 	.max_header	   = MAX_DCCP_HEADER,
 	.obj_size	   = sizeof(struct dccp6_sock),
diff --git a/net/dccp/proto.c b/net/dccp/proto.c
index c4de716f4994..a23b19663601 100644
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
index 79d5425bed07..73bf63d719f8 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1596,7 +1596,7 @@ int __udp_enqueue_schedule_skb(struct sock *sk, struct sk_buff *skb)
 }
 EXPORT_SYMBOL_GPL(__udp_enqueue_schedule_skb);
 
-void udp_destruct_sock(struct sock *sk)
+void udp_destruct_common(struct sock *sk)
 {
 	/* reclaim completely the forward allocated memory */
 	struct udp_sock *up = udp_sk(sk);
@@ -1609,10 +1609,14 @@ void udp_destruct_sock(struct sock *sk)
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
@@ -1620,7 +1624,6 @@ int udp_init_sock(struct sock *sk)
 	sk->sk_destruct = udp_destruct_sock;
 	return 0;
 }
-EXPORT_SYMBOL_GPL(udp_init_sock);
 
 void skb_consume_udp(struct sock *sk, struct sk_buff *skb, int len)
 {
diff --git a/net/ipv4/udplite.c b/net/ipv4/udplite.c
index cd1cd68adeec..bf597acef8dc 100644
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
index 3a91d0d40aec..164b130203f1 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -108,6 +108,13 @@ static __inline__ struct ipv6_pinfo *inet6_sk_generic(struct sock *sk)
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
@@ -200,7 +207,7 @@ static int inet6_create(struct net *net, struct socket *sock, int protocol,
 			inet->hdrincl = 1;
 	}
 
-	sk->sk_destruct		= inet_sock_destruct;
+	sk->sk_destruct		= inet6_sock_destruct;
 	sk->sk_family		= PF_INET6;
 	sk->sk_protocol		= protocol;
 
@@ -507,6 +514,12 @@ void inet6_destroy_sock(struct sock *sk)
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
index b24e0e5d55f9..197e12d5607f 100644
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
index c68020b8de89..0c833f6b88bd 100644
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
index 488aec9e1a74..d1876f192225 100644
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
index 3f331455f020..b6f5a4474d8b 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1972,12 +1972,6 @@ static int tcp_v6_init_sock(struct sock *sk)
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
@@ -2170,7 +2164,7 @@ struct proto tcpv6_prot = {
 	.accept			= inet_csk_accept,
 	.ioctl			= tcp_ioctl,
 	.init			= tcp_v6_init_sock,
-	.destroy		= tcp_v6_destroy_sock,
+	.destroy		= tcp_v4_destroy_sock,
 	.shutdown		= tcp_shutdown,
 	.setsockopt		= tcp_setsockopt,
 	.getsockopt		= tcp_getsockopt,
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 921129c3df8a..5161e98f6fcf 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -55,6 +55,19 @@
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
@@ -1636,8 +1649,6 @@ void udpv6_destroy_sock(struct sock *sk)
 			udp_encap_disable();
 		}
 	}
-
-	inet6_destroy_sock(sk);
 }
 
 /*
@@ -1721,7 +1732,7 @@ struct proto udpv6_prot = {
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
index 4c4577775c5d..b6a38af72e1b 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3621,12 +3621,6 @@ static const struct proto_ops mptcp_v6_stream_ops = {
 
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
@@ -3642,7 +3636,6 @@ int __init mptcp_proto_v6_init(void)
 	mptcp_v6_prot = mptcp_prot;
 	strcpy(mptcp_v6_prot.name, "MPTCPv6");
 	mptcp_v6_prot.slab = NULL;
-	mptcp_v6_prot.destroy = mptcp_v6_destroy;
 	mptcp_v6_prot.obj_size = sizeof(struct mptcp6_sock);
 
 	err = proto_register(&mptcp_v6_prot, 1);
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index dc276b6802ca..d950041364d5 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3294,6 +3294,64 @@ static int nft_table_validate(struct net *net, const struct nft_table *table)
 	return 0;
 }
 
+int nft_setelem_validate(const struct nft_ctx *ctx, struct nft_set *set,
+			 const struct nft_set_iter *iter,
+			 struct nft_set_elem *elem)
+{
+	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
+	struct nft_ctx *pctx = (struct nft_ctx *)ctx;
+	const struct nft_data *data;
+	int err;
+
+	if (nft_set_ext_exists(ext, NFT_SET_EXT_FLAGS) &&
+	    *nft_set_ext_flags(ext) & NFT_SET_ELEM_INTERVAL_END)
+		return 0;
+
+	data = nft_set_ext_data(ext);
+	switch (data->verdict.code) {
+	case NFT_JUMP:
+	case NFT_GOTO:
+		pctx->level++;
+		err = nft_chain_validate(ctx, data->verdict.chain);
+		if (err < 0)
+			return err;
+		pctx->level--;
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+struct nft_set_elem_catchall {
+	struct list_head	list;
+	struct rcu_head		rcu;
+	void			*elem;
+};
+
+int nft_set_catchall_validate(const struct nft_ctx *ctx, struct nft_set *set)
+{
+	u8 genmask = nft_genmask_next(ctx->net);
+	struct nft_set_elem_catchall *catchall;
+	struct nft_set_elem elem;
+	struct nft_set_ext *ext;
+	int ret = 0;
+
+	list_for_each_entry_rcu(catchall, &set->catchall_list, list) {
+		ext = nft_set_elem_ext(set, catchall->elem);
+		if (!nft_set_elem_active(ext, genmask))
+			continue;
+
+		elem.priv = catchall->elem;
+		ret = nft_setelem_validate(ctx, set, NULL, &elem);
+		if (ret < 0)
+			return ret;
+	}
+
+	return ret;
+}
+
 static struct nft_rule *nft_rule_lookup_byid(const struct net *net,
 					     const struct nft_chain *chain,
 					     const struct nlattr *nla);
@@ -4598,12 +4656,6 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 	return err;
 }
 
-struct nft_set_elem_catchall {
-	struct list_head	list;
-	struct rcu_head		rcu;
-	void			*elem;
-};
-
 static void nft_set_catchall_destroy(const struct nft_ctx *ctx,
 				     struct nft_set *set)
 {
@@ -5843,7 +5895,8 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	if (err < 0)
 		return err;
 
-	if (!nla[NFTA_SET_ELEM_KEY] && !(flags & NFT_SET_ELEM_CATCHALL))
+	if (((flags & NFT_SET_ELEM_CATCHALL) && nla[NFTA_SET_ELEM_KEY]) ||
+	    (!(flags & NFT_SET_ELEM_CATCHALL) && !nla[NFTA_SET_ELEM_KEY]))
 		return -EINVAL;
 
 	if (flags != 0) {
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index 90becbf5bff3..bd3485dd930f 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -198,37 +198,6 @@ static int nft_lookup_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	return -1;
 }
 
-static int nft_lookup_validate_setelem(const struct nft_ctx *ctx,
-				       struct nft_set *set,
-				       const struct nft_set_iter *iter,
-				       struct nft_set_elem *elem)
-{
-	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
-	struct nft_ctx *pctx = (struct nft_ctx *)ctx;
-	const struct nft_data *data;
-	int err;
-
-	if (nft_set_ext_exists(ext, NFT_SET_EXT_FLAGS) &&
-	    *nft_set_ext_flags(ext) & NFT_SET_ELEM_INTERVAL_END)
-		return 0;
-
-	data = nft_set_ext_data(ext);
-	switch (data->verdict.code) {
-	case NFT_JUMP:
-	case NFT_GOTO:
-		pctx->level++;
-		err = nft_chain_validate(ctx, data->verdict.chain);
-		if (err < 0)
-			return err;
-		pctx->level--;
-		break;
-	default:
-		break;
-	}
-
-	return 0;
-}
-
 static int nft_lookup_validate(const struct nft_ctx *ctx,
 			       const struct nft_expr *expr,
 			       const struct nft_data **d)
@@ -244,9 +213,12 @@ static int nft_lookup_validate(const struct nft_ctx *ctx,
 	iter.skip	= 0;
 	iter.count	= 0;
 	iter.err	= 0;
-	iter.fn		= nft_lookup_validate_setelem;
+	iter.fn		= nft_setelem_validate;
 
 	priv->set->ops->walk(ctx, priv->set, &iter);
+	if (!iter.err)
+		iter.err = nft_set_catchall_validate(ctx, priv->set);
+
 	if (iter.err < 0)
 		return iter.err;
 
diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
index 50e51c1322fc..4c51aeb78f14 100644
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
index a5344fddddbb..2bbc81ddb9e0 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -5110,13 +5110,17 @@ static void sctp_destroy_sock(struct sock *sk)
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
 
@@ -9443,7 +9447,7 @@ void sctp_copy_sock(struct sock *newsk, struct sock *sk,
 	sctp_sk(newsk)->reuse = sp->reuse;
 
 	newsk->sk_shutdown = sk->sk_shutdown;
-	newsk->sk_destruct = sctp_destruct_sock;
+	newsk->sk_destruct = sk->sk_destruct;
 	newsk->sk_family = sk->sk_family;
 	newsk->sk_protocol = IPPROTO_SCTP;
 	newsk->sk_backlog_rcv = sk->sk_prot->backlog_rcv;
@@ -9675,11 +9679,20 @@ struct proto sctp_prot = {
 
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
@@ -9689,8 +9702,8 @@ struct proto sctpv6_prot = {
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
index cd9b36ec0ecb..79dd5a9b8f48 100644
--- a/sound/soc/fsl/fsl_asrc_dma.c
+++ b/sound/soc/fsl/fsl_asrc_dma.c
@@ -208,14 +208,19 @@ static int fsl_asrc_dma_hw_params(struct snd_soc_component *component,
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
index c53b070755b6..98d37cb744fb 100644
--- a/tools/testing/selftests/sigaltstack/sas.c
+++ b/tools/testing/selftests/sigaltstack/sas.c
@@ -20,6 +20,7 @@
 #include <sys/auxv.h>
 
 #include "../kselftest.h"
+#include "current_stack_pointer.h"
 
 #ifndef SS_AUTODISARM
 #define SS_AUTODISARM  (1U << 31)
@@ -46,12 +47,6 @@ void my_usr1(int sig, siginfo_t *si, void *u)
 	stack_t stk;
 	struct stk_data *p;
 
-#if __s390x__
-	register unsigned long sp asm("%15");
-#else
-	register unsigned long sp asm("sp");
-#endif
-
 	if (sp < (unsigned long)sstack ||
 			sp >= (unsigned long)sstack + stack_size) {
 		ksft_exit_fail_msg("SP is not on sigaltstack\n");
