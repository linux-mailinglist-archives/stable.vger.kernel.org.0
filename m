Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A10B66E905D
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 12:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234716AbjDTKgP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 06:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234718AbjDTKfv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 06:35:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A14A919AC;
        Thu, 20 Apr 2023 03:33:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B2F5361384;
        Thu, 20 Apr 2023 10:33:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F08C3C433EF;
        Thu, 20 Apr 2023 10:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681986785;
        bh=y9q6xD9X9gbTZU2vmFKUYp/qEaJJOzj7bJkwM+Q+Tc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HAwv1kj8fStW/67akEQpEqOMWsNj79KrAIXeoCPtsoOBztnLDl3qmDxMNyVM7tR2X
         bw2fvks+7LsVsxORAPVac416lk2aTXemUZFlVTZ1av+8qvaPVhqLFtkgQzOScLTHRl
         ydHG9JJHx1rq5EfNYHg27W3wS9JKTuk3J2LEIZ5Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.108
Date:   Thu, 20 Apr 2023 12:32:53 +0200
Message-Id: <2023042053-dayroom-dried-c4c2@gregkh>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <2023042053-cataract-encounter-ff50@gregkh>
References: <2023042053-cataract-encounter-ff50@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/driver-api/generic-counter.rst b/Documentation/driver-api/generic-counter.rst
index 64fe7db080e5..252aeb639bc4 100644
--- a/Documentation/driver-api/generic-counter.rst
+++ b/Documentation/driver-api/generic-counter.rst
@@ -247,7 +247,7 @@ for defining a counter device.
 .. kernel-doc:: include/linux/counter.h
    :internal:
 
-.. kernel-doc:: drivers/counter/counter.c
+.. kernel-doc:: drivers/counter/counter-core.c
    :export:
 
 Implementation
diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index ba0e8e6337c0..7890b395e629 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -322,6 +322,8 @@ tcp_app_win - INTEGER
 	Reserve max(window/2^tcp_app_win, mss) of window for application
 	buffer. Value 0 is special, it means that nothing is reserved.
 
+	Possible values are [0, 31], inclusive.
+
 	Default: 31
 
 tcp_autocorking - BOOLEAN
diff --git a/Documentation/sound/hd-audio/models.rst b/Documentation/sound/hd-audio/models.rst
index 9b52f50a6854..120430450014 100644
--- a/Documentation/sound/hd-audio/models.rst
+++ b/Documentation/sound/hd-audio/models.rst
@@ -704,7 +704,7 @@ ref
 no-jd
     BIOS setup but without jack-detection
 intel
-    Intel DG45* mobos
+    Intel D*45* mobos
 dell-m6-amic
     Dell desktops/laptops with analog mics
 dell-m6-dmic
diff --git a/MAINTAINERS b/MAINTAINERS
index d0884a5d49b9..2d3d2155c744 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4813,7 +4813,6 @@ F:	Documentation/ABI/testing/sysfs-bus-counter
 F:	Documentation/driver-api/generic-counter.rst
 F:	drivers/counter/
 F:	include/linux/counter.h
-F:	include/linux/counter_enum.h
 
 CP2615 I2C DRIVER
 M:	Bence Csókás <bence98@sch.bme.hu>
diff --git a/Makefile b/Makefile
index b06324521d28..49ae089784a6 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 107
+SUBLEVEL = 108
 EXTRAVERSION =
 NAME = Trick or Treat
 
diff --git a/arch/arm/lib/uaccess_with_memcpy.c b/arch/arm/lib/uaccess_with_memcpy.c
index 106f83a5ea6d..35e03f6a6212 100644
--- a/arch/arm/lib/uaccess_with_memcpy.c
+++ b/arch/arm/lib/uaccess_with_memcpy.c
@@ -121,7 +121,7 @@ __copy_to_user_memcpy(void __user *to, const void *from, unsigned long n)
 			tocopy = n;
 
 		ua_flags = uaccess_save_and_enable();
-		memcpy((void *)to, from, tocopy);
+		__memcpy((void *)to, from, tocopy);
 		uaccess_restore(ua_flags);
 		to += tocopy;
 		from += tocopy;
@@ -188,7 +188,7 @@ __clear_user_memset(void __user *addr, unsigned long n)
 			tocopy = n;
 
 		ua_flags = uaccess_save_and_enable();
-		memset((void *)addr, 0, tocopy);
+		__memset((void *)addr, 0, tocopy);
 		uaccess_restore(ua_flags);
 		addr += tocopy;
 		n -= tocopy;
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 2af3c37445e0..886048c08363 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -554,6 +554,7 @@ void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val)
 			__vcpu_sys_reg(vcpu, PMOVSSET_EL0) |= BIT(i);
 		}
 	}
+	kvm_vcpu_pmu_restore_guest(vcpu);
 }
 
 /**
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c11612db4a37..d00170d7ddf5 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -702,7 +702,6 @@ static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			val |= ARMV8_PMU_PMCR_LC;
 		__vcpu_sys_reg(vcpu, PMCR_EL0) = val;
 		kvm_pmu_handle_pmcr(vcpu, val);
-		kvm_vcpu_pmu_restore_guest(vcpu);
 	} else {
 		/* PMCR.P & PMCR.C are RAZ */
 		val = __vcpu_sys_reg(vcpu, PMCR_EL0)
diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index 5fb829256b59..9c038c8cebeb 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -367,6 +367,7 @@ void update_numa_distance(struct device_node *node)
 	WARN(numa_distance_table[nid][nid] == -1,
 	     "NUMA distance details for node %d not provided\n", nid);
 }
+EXPORT_SYMBOL_GPL(update_numa_distance);
 
 /*
  * ibm,numa-lookup-index-table= {N, domainid1, domainid2, ..... domainidN}
diff --git a/arch/powerpc/platforms/pseries/papr_scm.c b/arch/powerpc/platforms/pseries/papr_scm.c
index f48e87ac89c9..3cfcc748052e 100644
--- a/arch/powerpc/platforms/pseries/papr_scm.c
+++ b/arch/powerpc/platforms/pseries/papr_scm.c
@@ -1159,6 +1159,13 @@ static int papr_scm_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
+	/*
+	 * open firmware platform device create won't update the NUMA 
+	 * distance table. For PAPR SCM devices we use numa_map_to_online_node()
+	 * to find the nearest online NUMA node and that requires correct
+	 * distance table information.
+	 */
+	update_numa_distance(dn);
 
 	p = kzalloc(sizeof(*p), GFP_KERNEL);
 	if (!p)
diff --git a/arch/riscv/kernel/signal.c b/arch/riscv/kernel/signal.c
index f8fb85dc94b7..8892569aad23 100644
--- a/arch/riscv/kernel/signal.c
+++ b/arch/riscv/kernel/signal.c
@@ -16,6 +16,7 @@
 #include <asm/vdso.h>
 #include <asm/switch_to.h>
 #include <asm/csr.h>
+#include <asm/cacheflush.h>
 
 extern u32 __user_rt_sigreturn[2];
 
@@ -178,6 +179,7 @@ static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
 {
 	struct rt_sigframe __user *frame;
 	long err = 0;
+	unsigned long __maybe_unused addr;
 
 	frame = get_sigframe(ksig, regs, sizeof(*frame));
 	if (!access_ok(frame, sizeof(*frame)))
@@ -206,7 +208,12 @@ static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
 	if (copy_to_user(&frame->sigreturn_code, __user_rt_sigreturn,
 			 sizeof(frame->sigreturn_code)))
 		return -EFAULT;
-	regs->ra = (unsigned long)&frame->sigreturn_code;
+
+	addr = (unsigned long)&frame->sigreturn_code;
+	/* Make sure the two instructions are pushed to icache. */
+	flush_icache_range(addr, addr + sizeof(frame->sigreturn_code));
+
+	regs->ra = addr;
 #endif /* CONFIG_MMU */
 
 	/*
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index 8b395821cb8d..d3e3b16ea9cf 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -32,8 +32,8 @@ static int __init iommu_init_noop(void) { return 0; }
 static void iommu_shutdown_noop(void) { }
 bool __init bool_x86_init_noop(void) { return false; }
 void x86_op_int_noop(int cpu) { }
-static __init int set_rtc_noop(const struct timespec64 *now) { return -EINVAL; }
-static __init void get_rtc_noop(struct timespec64 *now) { }
+static int set_rtc_noop(const struct timespec64 *now) { return -EINVAL; }
+static void get_rtc_noop(struct timespec64 *now) { }
 
 static __initconst const struct of_device_id of_cmos_match[] = {
 	{ .compatible = "motorola,mc146818" },
diff --git a/arch/x86/pci/fixup.c b/arch/x86/pci/fixup.c
index 615a76d70019..bf5161dcf89e 100644
--- a/arch/x86/pci/fixup.c
+++ b/arch/x86/pci/fixup.c
@@ -7,6 +7,7 @@
 #include <linux/dmi.h>
 #include <linux/pci.h>
 #include <linux/vgaarb.h>
+#include <asm/amd_nb.h>
 #include <asm/hpet.h>
 #include <asm/pci_x86.h>
 
@@ -824,3 +825,23 @@ static void rs690_fix_64bit_dma(struct pci_dev *pdev)
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x7910, rs690_fix_64bit_dma);
 
 #endif
+
+#ifdef CONFIG_AMD_NB
+
+#define AMD_15B8_RCC_DEV2_EPF0_STRAP2                                  0x10136008
+#define AMD_15B8_RCC_DEV2_EPF0_STRAP2_NO_SOFT_RESET_DEV2_F0_MASK       0x00000080L
+
+static void quirk_clear_strap_no_soft_reset_dev2_f0(struct pci_dev *dev)
+{
+	u32 data;
+
+	if (!amd_smn_read(0, AMD_15B8_RCC_DEV2_EPF0_STRAP2, &data)) {
+		data &= ~AMD_15B8_RCC_DEV2_EPF0_STRAP2_NO_SOFT_RESET_DEV2_F0_MASK;
+		if (amd_smn_write(0, AMD_15B8_RCC_DEV2_EPF0_STRAP2, data))
+			pci_err(dev, "Failed to write data 0x%x\n", data);
+	} else {
+		pci_err(dev, "Failed to read data\n");
+	}
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, 0x15b8, quirk_clear_strap_no_soft_reset_dev2_f0);
+#endif
diff --git a/crypto/asymmetric_keys/pkcs7_verify.c b/crypto/asymmetric_keys/pkcs7_verify.c
index f94a1d1ad3a6..df279538cead 100644
--- a/crypto/asymmetric_keys/pkcs7_verify.c
+++ b/crypto/asymmetric_keys/pkcs7_verify.c
@@ -79,16 +79,16 @@ static int pkcs7_digest(struct pkcs7_message *pkcs7,
 		}
 
 		if (sinfo->msgdigest_len != sig->digest_size) {
-			pr_debug("Sig %u: Invalid digest size (%u)\n",
-				 sinfo->index, sinfo->msgdigest_len);
+			pr_warn("Sig %u: Invalid digest size (%u)\n",
+				sinfo->index, sinfo->msgdigest_len);
 			ret = -EBADMSG;
 			goto error;
 		}
 
 		if (memcmp(sig->digest, sinfo->msgdigest,
 			   sinfo->msgdigest_len) != 0) {
-			pr_debug("Sig %u: Message digest doesn't match\n",
-				 sinfo->index);
+			pr_warn("Sig %u: Message digest doesn't match\n",
+				sinfo->index);
 			ret = -EKEYREJECTED;
 			goto error;
 		}
@@ -481,7 +481,7 @@ int pkcs7_supply_detached_data(struct pkcs7_message *pkcs7,
 			       const void *data, size_t datalen)
 {
 	if (pkcs7->data) {
-		pr_debug("Data already supplied\n");
+		pr_warn("Data already supplied\n");
 		return -EINVAL;
 	}
 	pkcs7->data = data;
diff --git a/crypto/asymmetric_keys/verify_pefile.c b/crypto/asymmetric_keys/verify_pefile.c
index 7553ab18db89..22beaf2213a2 100644
--- a/crypto/asymmetric_keys/verify_pefile.c
+++ b/crypto/asymmetric_keys/verify_pefile.c
@@ -74,7 +74,7 @@ static int pefile_parse_binary(const void *pebuf, unsigned int pelen,
 		break;
 
 	default:
-		pr_debug("Unknown PEOPT magic = %04hx\n", pe32->magic);
+		pr_warn("Unknown PEOPT magic = %04hx\n", pe32->magic);
 		return -ELIBBAD;
 	}
 
@@ -95,7 +95,7 @@ static int pefile_parse_binary(const void *pebuf, unsigned int pelen,
 	ctx->certs_size = ddir->certs.size;
 
 	if (!ddir->certs.virtual_address || !ddir->certs.size) {
-		pr_debug("Unsigned PE binary\n");
+		pr_warn("Unsigned PE binary\n");
 		return -ENODATA;
 	}
 
@@ -127,7 +127,7 @@ static int pefile_strip_sig_wrapper(const void *pebuf,
 	unsigned len;
 
 	if (ctx->sig_len < sizeof(wrapper)) {
-		pr_debug("Signature wrapper too short\n");
+		pr_warn("Signature wrapper too short\n");
 		return -ELIBBAD;
 	}
 
@@ -135,19 +135,23 @@ static int pefile_strip_sig_wrapper(const void *pebuf,
 	pr_debug("sig wrapper = { %x, %x, %x }\n",
 		 wrapper.length, wrapper.revision, wrapper.cert_type);
 
-	/* Both pesign and sbsign round up the length of certificate table
-	 * (in optional header data directories) to 8 byte alignment.
+	/* sbsign rounds up the length of certificate table (in optional
+	 * header data directories) to 8 byte alignment.  However, the PE
+	 * specification states that while entries are 8-byte aligned, this is
+	 * not included in their length, and as a result, pesign has not
+	 * rounded up since 0.110.
 	 */
-	if (round_up(wrapper.length, 8) != ctx->sig_len) {
-		pr_debug("Signature wrapper len wrong\n");
+	if (wrapper.length > ctx->sig_len) {
+		pr_warn("Signature wrapper bigger than sig len (%x > %x)\n",
+			ctx->sig_len, wrapper.length);
 		return -ELIBBAD;
 	}
 	if (wrapper.revision != WIN_CERT_REVISION_2_0) {
-		pr_debug("Signature is not revision 2.0\n");
+		pr_warn("Signature is not revision 2.0\n");
 		return -ENOTSUPP;
 	}
 	if (wrapper.cert_type != WIN_CERT_TYPE_PKCS_SIGNED_DATA) {
-		pr_debug("Signature certificate type is not PKCS\n");
+		pr_warn("Signature certificate type is not PKCS\n");
 		return -ENOTSUPP;
 	}
 
@@ -160,7 +164,7 @@ static int pefile_strip_sig_wrapper(const void *pebuf,
 	ctx->sig_offset += sizeof(wrapper);
 	ctx->sig_len -= sizeof(wrapper);
 	if (ctx->sig_len < 4) {
-		pr_debug("Signature data missing\n");
+		pr_warn("Signature data missing\n");
 		return -EKEYREJECTED;
 	}
 
@@ -194,7 +198,7 @@ static int pefile_strip_sig_wrapper(const void *pebuf,
 		return 0;
 	}
 not_pkcs7:
-	pr_debug("Signature data not PKCS#7\n");
+	pr_warn("Signature data not PKCS#7\n");
 	return -ELIBBAD;
 }
 
@@ -337,8 +341,8 @@ static int pefile_digest_pe(const void *pebuf, unsigned int pelen,
 	digest_size = crypto_shash_digestsize(tfm);
 
 	if (digest_size != ctx->digest_len) {
-		pr_debug("Digest size mismatch (%zx != %x)\n",
-			 digest_size, ctx->digest_len);
+		pr_warn("Digest size mismatch (%zx != %x)\n",
+			digest_size, ctx->digest_len);
 		ret = -EBADMSG;
 		goto error_no_desc;
 	}
@@ -369,7 +373,7 @@ static int pefile_digest_pe(const void *pebuf, unsigned int pelen,
 	 * PKCS#7 certificate.
 	 */
 	if (memcmp(digest, ctx->digest, ctx->digest_len) != 0) {
-		pr_debug("Digest mismatch\n");
+		pr_warn("Digest mismatch\n");
 		ret = -EKEYREJECTED;
 	} else {
 		pr_debug("The digests match!\n");
diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index 3b9f89487336..803dc6afa6d6 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -396,6 +396,13 @@ static const struct dmi_system_id medion_laptop[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "M17T"),
 		},
 	},
+	{
+		.ident = "MEDION S17413",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "MEDION"),
+			DMI_MATCH(DMI_BOARD_NAME, "M1xA"),
+		},
+	},
 	{ }
 };
 
diff --git a/drivers/clk/sprd/common.c b/drivers/clk/sprd/common.c
index ce81e4087a8f..2bfbab8db94b 100644
--- a/drivers/clk/sprd/common.c
+++ b/drivers/clk/sprd/common.c
@@ -17,7 +17,6 @@ static const struct regmap_config sprdclk_regmap_config = {
 	.reg_bits	= 32,
 	.reg_stride	= 4,
 	.val_bits	= 32,
-	.max_register	= 0xffff,
 	.fast_io	= true,
 };
 
@@ -43,6 +42,8 @@ int sprd_clk_regmap_init(struct platform_device *pdev,
 	struct device *dev = &pdev->dev;
 	struct device_node *node = dev->of_node, *np;
 	struct regmap *regmap;
+	struct resource *res;
+	struct regmap_config reg_config = sprdclk_regmap_config;
 
 	if (of_find_property(node, "sprd,syscon", NULL)) {
 		regmap = syscon_regmap_lookup_by_phandle(node, "sprd,syscon");
@@ -59,12 +60,14 @@ int sprd_clk_regmap_init(struct platform_device *pdev,
 			return PTR_ERR(regmap);
 		}
 	} else {
-		base = devm_platform_ioremap_resource(pdev, 0);
+		base = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
 		if (IS_ERR(base))
 			return PTR_ERR(base);
 
+		reg_config.max_register = resource_size(res) - reg_config.reg_stride;
+
 		regmap = devm_regmap_init_mmio(&pdev->dev, base,
-					       &sprdclk_regmap_config);
+					       &reg_config);
 		if (IS_ERR(regmap)) {
 			pr_err("failed to init regmap\n");
 			return PTR_ERR(regmap);
diff --git a/drivers/counter/104-quad-8.c b/drivers/counter/104-quad-8.c
index 0caa60537b14..e00cf156c6e9 100644
--- a/drivers/counter/104-quad-8.c
+++ b/drivers/counter/104-quad-8.c
@@ -117,7 +117,7 @@ static int quad8_signal_read(struct counter_device *counter,
 }
 
 static int quad8_count_read(struct counter_device *counter,
-	struct counter_count *count, unsigned long *val)
+			    struct counter_count *count, u64 *val)
 {
 	struct quad8 *const priv = counter->priv;
 	const int base_offset = priv->base + 2 * count->id;
@@ -148,7 +148,7 @@ static int quad8_count_read(struct counter_device *counter,
 }
 
 static int quad8_count_write(struct counter_device *counter,
-	struct counter_count *count, unsigned long val)
+			     struct counter_count *count, u64 val)
 {
 	struct quad8 *const priv = counter->priv;
 	const int base_offset = priv->base + 2 * count->id;
@@ -188,22 +188,16 @@ static int quad8_count_write(struct counter_device *counter,
 	return 0;
 }
 
-enum quad8_count_function {
-	QUAD8_COUNT_FUNCTION_PULSE_DIRECTION = 0,
-	QUAD8_COUNT_FUNCTION_QUADRATURE_X1,
-	QUAD8_COUNT_FUNCTION_QUADRATURE_X2,
-	QUAD8_COUNT_FUNCTION_QUADRATURE_X4
-};
-
 static const enum counter_function quad8_count_functions_list[] = {
-	[QUAD8_COUNT_FUNCTION_PULSE_DIRECTION] = COUNTER_FUNCTION_PULSE_DIRECTION,
-	[QUAD8_COUNT_FUNCTION_QUADRATURE_X1] = COUNTER_FUNCTION_QUADRATURE_X1_A,
-	[QUAD8_COUNT_FUNCTION_QUADRATURE_X2] = COUNTER_FUNCTION_QUADRATURE_X2_A,
-	[QUAD8_COUNT_FUNCTION_QUADRATURE_X4] = COUNTER_FUNCTION_QUADRATURE_X4
+	COUNTER_FUNCTION_PULSE_DIRECTION,
+	COUNTER_FUNCTION_QUADRATURE_X1_A,
+	COUNTER_FUNCTION_QUADRATURE_X2_A,
+	COUNTER_FUNCTION_QUADRATURE_X4,
 };
 
-static int quad8_function_get(struct counter_device *counter,
-	struct counter_count *count, size_t *function)
+static int quad8_function_read(struct counter_device *counter,
+			       struct counter_count *count,
+			       enum counter_function *function)
 {
 	struct quad8 *const priv = counter->priv;
 	const int id = count->id;
@@ -213,25 +207,26 @@ static int quad8_function_get(struct counter_device *counter,
 	if (priv->quadrature_mode[id])
 		switch (priv->quadrature_scale[id]) {
 		case 0:
-			*function = QUAD8_COUNT_FUNCTION_QUADRATURE_X1;
+			*function = COUNTER_FUNCTION_QUADRATURE_X1_A;
 			break;
 		case 1:
-			*function = QUAD8_COUNT_FUNCTION_QUADRATURE_X2;
+			*function = COUNTER_FUNCTION_QUADRATURE_X2_A;
 			break;
 		case 2:
-			*function = QUAD8_COUNT_FUNCTION_QUADRATURE_X4;
+			*function = COUNTER_FUNCTION_QUADRATURE_X4;
 			break;
 		}
 	else
-		*function = QUAD8_COUNT_FUNCTION_PULSE_DIRECTION;
+		*function = COUNTER_FUNCTION_PULSE_DIRECTION;
 
 	mutex_unlock(&priv->lock);
 
 	return 0;
 }
 
-static int quad8_function_set(struct counter_device *counter,
-	struct counter_count *count, size_t function)
+static int quad8_function_write(struct counter_device *counter,
+				struct counter_count *count,
+				enum counter_function function)
 {
 	struct quad8 *const priv = counter->priv;
 	const int id = count->id;
@@ -247,7 +242,7 @@ static int quad8_function_set(struct counter_device *counter,
 	mode_cfg = priv->count_mode[id] << 1;
 	idr_cfg = priv->index_polarity[id] << 1;
 
-	if (function == QUAD8_COUNT_FUNCTION_PULSE_DIRECTION) {
+	if (function == COUNTER_FUNCTION_PULSE_DIRECTION) {
 		*quadrature_mode = 0;
 
 		/* Quadrature scaling only available in quadrature mode */
@@ -263,15 +258,15 @@ static int quad8_function_set(struct counter_device *counter,
 		*quadrature_mode = 1;
 
 		switch (function) {
-		case QUAD8_COUNT_FUNCTION_QUADRATURE_X1:
+		case COUNTER_FUNCTION_QUADRATURE_X1_A:
 			*scale = 0;
 			mode_cfg |= QUAD8_CMR_QUADRATURE_X1;
 			break;
-		case QUAD8_COUNT_FUNCTION_QUADRATURE_X2:
+		case COUNTER_FUNCTION_QUADRATURE_X2_A:
 			*scale = 1;
 			mode_cfg |= QUAD8_CMR_QUADRATURE_X2;
 			break;
-		case QUAD8_COUNT_FUNCTION_QUADRATURE_X4:
+		case COUNTER_FUNCTION_QUADRATURE_X4:
 			*scale = 2;
 			mode_cfg |= QUAD8_CMR_QUADRATURE_X4;
 			break;
@@ -290,8 +285,9 @@ static int quad8_function_set(struct counter_device *counter,
 	return 0;
 }
 
-static void quad8_direction_get(struct counter_device *counter,
-	struct counter_count *count, enum counter_count_direction *direction)
+static int quad8_direction_read(struct counter_device *counter,
+				struct counter_count *count,
+				enum counter_count_direction *direction)
 {
 	const struct quad8 *const priv = counter->priv;
 	unsigned int ud_flag;
@@ -302,76 +298,74 @@ static void quad8_direction_get(struct counter_device *counter,
 
 	*direction = (ud_flag) ? COUNTER_COUNT_DIRECTION_FORWARD :
 		COUNTER_COUNT_DIRECTION_BACKWARD;
-}
 
-enum quad8_synapse_action {
-	QUAD8_SYNAPSE_ACTION_NONE = 0,
-	QUAD8_SYNAPSE_ACTION_RISING_EDGE,
-	QUAD8_SYNAPSE_ACTION_FALLING_EDGE,
-	QUAD8_SYNAPSE_ACTION_BOTH_EDGES
-};
+	return 0;
+}
 
 static const enum counter_synapse_action quad8_index_actions_list[] = {
-	[QUAD8_SYNAPSE_ACTION_NONE] = COUNTER_SYNAPSE_ACTION_NONE,
-	[QUAD8_SYNAPSE_ACTION_RISING_EDGE] = COUNTER_SYNAPSE_ACTION_RISING_EDGE
+	COUNTER_SYNAPSE_ACTION_NONE,
+	COUNTER_SYNAPSE_ACTION_RISING_EDGE,
 };
 
 static const enum counter_synapse_action quad8_synapse_actions_list[] = {
-	[QUAD8_SYNAPSE_ACTION_NONE] = COUNTER_SYNAPSE_ACTION_NONE,
-	[QUAD8_SYNAPSE_ACTION_RISING_EDGE] = COUNTER_SYNAPSE_ACTION_RISING_EDGE,
-	[QUAD8_SYNAPSE_ACTION_FALLING_EDGE] = COUNTER_SYNAPSE_ACTION_FALLING_EDGE,
-	[QUAD8_SYNAPSE_ACTION_BOTH_EDGES] = COUNTER_SYNAPSE_ACTION_BOTH_EDGES
+	COUNTER_SYNAPSE_ACTION_NONE,
+	COUNTER_SYNAPSE_ACTION_RISING_EDGE,
+	COUNTER_SYNAPSE_ACTION_FALLING_EDGE,
+	COUNTER_SYNAPSE_ACTION_BOTH_EDGES,
 };
 
-static int quad8_action_get(struct counter_device *counter,
-	struct counter_count *count, struct counter_synapse *synapse,
-	size_t *action)
+static int quad8_action_read(struct counter_device *counter,
+			     struct counter_count *count,
+			     struct counter_synapse *synapse,
+			     enum counter_synapse_action *action)
 {
 	struct quad8 *const priv = counter->priv;
 	int err;
-	size_t function = 0;
+	enum counter_function function;
 	const size_t signal_a_id = count->synapses[0].signal->id;
 	enum counter_count_direction direction;
 
 	/* Handle Index signals */
 	if (synapse->signal->id >= 16) {
-		if (priv->preset_enable[count->id])
-			*action = QUAD8_SYNAPSE_ACTION_RISING_EDGE;
+		if (!priv->preset_enable[count->id])
+			*action = COUNTER_SYNAPSE_ACTION_RISING_EDGE;
 		else
-			*action = QUAD8_SYNAPSE_ACTION_NONE;
+			*action = COUNTER_SYNAPSE_ACTION_NONE;
 
 		return 0;
 	}
 
-	err = quad8_function_get(counter, count, &function);
+	err = quad8_function_read(counter, count, &function);
 	if (err)
 		return err;
 
 	/* Default action mode */
-	*action = QUAD8_SYNAPSE_ACTION_NONE;
+	*action = COUNTER_SYNAPSE_ACTION_NONE;
 
 	/* Determine action mode based on current count function mode */
 	switch (function) {
-	case QUAD8_COUNT_FUNCTION_PULSE_DIRECTION:
+	case COUNTER_FUNCTION_PULSE_DIRECTION:
 		if (synapse->signal->id == signal_a_id)
-			*action = QUAD8_SYNAPSE_ACTION_RISING_EDGE;
+			*action = COUNTER_SYNAPSE_ACTION_RISING_EDGE;
 		return 0;
-	case QUAD8_COUNT_FUNCTION_QUADRATURE_X1:
+	case COUNTER_FUNCTION_QUADRATURE_X1_A:
 		if (synapse->signal->id == signal_a_id) {
-			quad8_direction_get(counter, count, &direction);
+			err = quad8_direction_read(counter, count, &direction);
+			if (err)
+				return err;
 
 			if (direction == COUNTER_COUNT_DIRECTION_FORWARD)
-				*action = QUAD8_SYNAPSE_ACTION_RISING_EDGE;
+				*action = COUNTER_SYNAPSE_ACTION_RISING_EDGE;
 			else
-				*action = QUAD8_SYNAPSE_ACTION_FALLING_EDGE;
+				*action = COUNTER_SYNAPSE_ACTION_FALLING_EDGE;
 		}
 		return 0;
-	case QUAD8_COUNT_FUNCTION_QUADRATURE_X2:
+	case COUNTER_FUNCTION_QUADRATURE_X2_A:
 		if (synapse->signal->id == signal_a_id)
-			*action = QUAD8_SYNAPSE_ACTION_BOTH_EDGES;
+			*action = COUNTER_SYNAPSE_ACTION_BOTH_EDGES;
 		return 0;
-	case QUAD8_COUNT_FUNCTION_QUADRATURE_X4:
-		*action = QUAD8_SYNAPSE_ACTION_BOTH_EDGES;
+	case COUNTER_FUNCTION_QUADRATURE_X4:
+		*action = COUNTER_SYNAPSE_ACTION_BOTH_EDGES;
 		return 0;
 	default:
 		/* should never reach this path */
@@ -383,9 +377,9 @@ static const struct counter_ops quad8_ops = {
 	.signal_read = quad8_signal_read,
 	.count_read = quad8_count_read,
 	.count_write = quad8_count_write,
-	.function_get = quad8_function_get,
-	.function_set = quad8_function_set,
-	.action_get = quad8_action_get
+	.function_read = quad8_function_read,
+	.function_write = quad8_function_write,
+	.action_read = quad8_action_read
 };
 
 static const char *const quad8_index_polarity_modes[] = {
@@ -394,7 +388,8 @@ static const char *const quad8_index_polarity_modes[] = {
 };
 
 static int quad8_index_polarity_get(struct counter_device *counter,
-	struct counter_signal *signal, size_t *index_polarity)
+				    struct counter_signal *signal,
+				    u32 *index_polarity)
 {
 	const struct quad8 *const priv = counter->priv;
 	const size_t channel_id = signal->id - 16;
@@ -405,7 +400,8 @@ static int quad8_index_polarity_get(struct counter_device *counter,
 }
 
 static int quad8_index_polarity_set(struct counter_device *counter,
-	struct counter_signal *signal, size_t index_polarity)
+				    struct counter_signal *signal,
+				    u32 index_polarity)
 {
 	struct quad8 *const priv = counter->priv;
 	const size_t channel_id = signal->id - 16;
@@ -426,20 +422,14 @@ static int quad8_index_polarity_set(struct counter_device *counter,
 	return 0;
 }
 
-static struct counter_signal_enum_ext quad8_index_pol_enum = {
-	.items = quad8_index_polarity_modes,
-	.num_items = ARRAY_SIZE(quad8_index_polarity_modes),
-	.get = quad8_index_polarity_get,
-	.set = quad8_index_polarity_set
-};
-
 static const char *const quad8_synchronous_modes[] = {
 	"non-synchronous",
 	"synchronous"
 };
 
 static int quad8_synchronous_mode_get(struct counter_device *counter,
-	struct counter_signal *signal, size_t *synchronous_mode)
+				      struct counter_signal *signal,
+				      u32 *synchronous_mode)
 {
 	const struct quad8 *const priv = counter->priv;
 	const size_t channel_id = signal->id - 16;
@@ -450,7 +440,8 @@ static int quad8_synchronous_mode_get(struct counter_device *counter,
 }
 
 static int quad8_synchronous_mode_set(struct counter_device *counter,
-	struct counter_signal *signal, size_t synchronous_mode)
+				      struct counter_signal *signal,
+				      u32 synchronous_mode)
 {
 	struct quad8 *const priv = counter->priv;
 	const size_t channel_id = signal->id - 16;
@@ -477,22 +468,18 @@ static int quad8_synchronous_mode_set(struct counter_device *counter,
 	return 0;
 }
 
-static struct counter_signal_enum_ext quad8_syn_mode_enum = {
-	.items = quad8_synchronous_modes,
-	.num_items = ARRAY_SIZE(quad8_synchronous_modes),
-	.get = quad8_synchronous_mode_get,
-	.set = quad8_synchronous_mode_set
-};
-
-static ssize_t quad8_count_floor_read(struct counter_device *counter,
-	struct counter_count *count, void *private, char *buf)
+static int quad8_count_floor_read(struct counter_device *counter,
+				  struct counter_count *count, u64 *floor)
 {
 	/* Only a floor of 0 is supported */
-	return sprintf(buf, "0\n");
+	*floor = 0;
+
+	return 0;
 }
 
-static int quad8_count_mode_get(struct counter_device *counter,
-	struct counter_count *count, size_t *cnt_mode)
+static int quad8_count_mode_read(struct counter_device *counter,
+				 struct counter_count *count,
+				 enum counter_count_mode *cnt_mode)
 {
 	const struct quad8 *const priv = counter->priv;
 
@@ -515,26 +502,28 @@ static int quad8_count_mode_get(struct counter_device *counter,
 	return 0;
 }
 
-static int quad8_count_mode_set(struct counter_device *counter,
-	struct counter_count *count, size_t cnt_mode)
+static int quad8_count_mode_write(struct counter_device *counter,
+				  struct counter_count *count,
+				  enum counter_count_mode cnt_mode)
 {
 	struct quad8 *const priv = counter->priv;
+	unsigned int count_mode;
 	unsigned int mode_cfg;
 	const int base_offset = priv->base + 2 * count->id + 1;
 
 	/* Map Generic Counter count mode to 104-QUAD-8 count mode */
 	switch (cnt_mode) {
 	case COUNTER_COUNT_MODE_NORMAL:
-		cnt_mode = 0;
+		count_mode = 0;
 		break;
 	case COUNTER_COUNT_MODE_RANGE_LIMIT:
-		cnt_mode = 1;
+		count_mode = 1;
 		break;
 	case COUNTER_COUNT_MODE_NON_RECYCLE:
-		cnt_mode = 2;
+		count_mode = 2;
 		break;
 	case COUNTER_COUNT_MODE_MODULO_N:
-		cnt_mode = 3;
+		count_mode = 3;
 		break;
 	default:
 		/* should never reach this path */
@@ -543,10 +532,10 @@ static int quad8_count_mode_set(struct counter_device *counter,
 
 	mutex_lock(&priv->lock);
 
-	priv->count_mode[count->id] = cnt_mode;
+	priv->count_mode[count->id] = count_mode;
 
 	/* Set count mode configuration value */
-	mode_cfg = cnt_mode << 1;
+	mode_cfg = count_mode << 1;
 
 	/* Add quadrature mode configuration */
 	if (priv->quadrature_mode[count->id])
@@ -560,56 +549,35 @@ static int quad8_count_mode_set(struct counter_device *counter,
 	return 0;
 }
 
-static struct counter_count_enum_ext quad8_cnt_mode_enum = {
-	.items = counter_count_mode_str,
-	.num_items = ARRAY_SIZE(counter_count_mode_str),
-	.get = quad8_count_mode_get,
-	.set = quad8_count_mode_set
-};
-
-static ssize_t quad8_count_direction_read(struct counter_device *counter,
-	struct counter_count *count, void *priv, char *buf)
-{
-	enum counter_count_direction dir;
-
-	quad8_direction_get(counter, count, &dir);
-
-	return sprintf(buf, "%s\n", counter_count_direction_str[dir]);
-}
-
-static ssize_t quad8_count_enable_read(struct counter_device *counter,
-	struct counter_count *count, void *private, char *buf)
+static int quad8_count_enable_read(struct counter_device *counter,
+				   struct counter_count *count, u8 *enable)
 {
 	const struct quad8 *const priv = counter->priv;
 
-	return sprintf(buf, "%u\n", priv->ab_enable[count->id]);
+	*enable = priv->ab_enable[count->id];
+
+	return 0;
 }
 
-static ssize_t quad8_count_enable_write(struct counter_device *counter,
-	struct counter_count *count, void *private, const char *buf, size_t len)
+static int quad8_count_enable_write(struct counter_device *counter,
+				    struct counter_count *count, u8 enable)
 {
 	struct quad8 *const priv = counter->priv;
 	const int base_offset = priv->base + 2 * count->id;
-	int err;
-	bool ab_enable;
 	unsigned int ior_cfg;
 
-	err = kstrtobool(buf, &ab_enable);
-	if (err)
-		return err;
-
 	mutex_lock(&priv->lock);
 
-	priv->ab_enable[count->id] = ab_enable;
+	priv->ab_enable[count->id] = enable;
 
-	ior_cfg = ab_enable | priv->preset_enable[count->id] << 1;
+	ior_cfg = enable | priv->preset_enable[count->id] << 1;
 
 	/* Load I/O control configuration */
 	outb(QUAD8_CTR_IOR | ior_cfg, base_offset + 1);
 
 	mutex_unlock(&priv->lock);
 
-	return len;
+	return 0;
 }
 
 static const char *const quad8_noise_error_states[] = {
@@ -618,7 +586,7 @@ static const char *const quad8_noise_error_states[] = {
 };
 
 static int quad8_error_noise_get(struct counter_device *counter,
-	struct counter_count *count, size_t *noise_error)
+				 struct counter_count *count, u32 *noise_error)
 {
 	const struct quad8 *const priv = counter->priv;
 	const int base_offset = priv->base + 2 * count->id + 1;
@@ -628,18 +596,14 @@ static int quad8_error_noise_get(struct counter_device *counter,
 	return 0;
 }
 
-static struct counter_count_enum_ext quad8_error_noise_enum = {
-	.items = quad8_noise_error_states,
-	.num_items = ARRAY_SIZE(quad8_noise_error_states),
-	.get = quad8_error_noise_get
-};
-
-static ssize_t quad8_count_preset_read(struct counter_device *counter,
-	struct counter_count *count, void *private, char *buf)
+static int quad8_count_preset_read(struct counter_device *counter,
+				   struct counter_count *count, u64 *preset)
 {
 	const struct quad8 *const priv = counter->priv;
 
-	return sprintf(buf, "%u\n", priv->preset[count->id]);
+	*preset = priv->preset[count->id];
+
+	return 0;
 }
 
 static void quad8_preset_register_set(struct quad8 *const priv, const int id,
@@ -658,16 +622,10 @@ static void quad8_preset_register_set(struct quad8 *const priv, const int id,
 		outb(preset >> (8 * i), base_offset);
 }
 
-static ssize_t quad8_count_preset_write(struct counter_device *counter,
-	struct counter_count *count, void *private, const char *buf, size_t len)
+static int quad8_count_preset_write(struct counter_device *counter,
+				    struct counter_count *count, u64 preset)
 {
 	struct quad8 *const priv = counter->priv;
-	unsigned int preset;
-	int ret;
-
-	ret = kstrtouint(buf, 0, &preset);
-	if (ret)
-		return ret;
 
 	/* Only 24-bit values are supported */
 	if (preset > 0xFFFFFF)
@@ -679,11 +637,11 @@ static ssize_t quad8_count_preset_write(struct counter_device *counter,
 
 	mutex_unlock(&priv->lock);
 
-	return len;
+	return 0;
 }
 
-static ssize_t quad8_count_ceiling_read(struct counter_device *counter,
-	struct counter_count *count, void *private, char *buf)
+static int quad8_count_ceiling_read(struct counter_device *counter,
+				    struct counter_count *count, u64 *ceiling)
 {
 	struct quad8 *const priv = counter->priv;
 
@@ -693,26 +651,23 @@ static ssize_t quad8_count_ceiling_read(struct counter_device *counter,
 	switch (priv->count_mode[count->id]) {
 	case 1:
 	case 3:
-		mutex_unlock(&priv->lock);
-		return sprintf(buf, "%u\n", priv->preset[count->id]);
+		*ceiling = priv->preset[count->id];
+		break;
+	default:
+		/* By default 0x1FFFFFF (25 bits unsigned) is maximum count */
+		*ceiling = 0x1FFFFFF;
+		break;
 	}
 
 	mutex_unlock(&priv->lock);
 
-	/* By default 0x1FFFFFF (25 bits unsigned) is maximum count */
-	return sprintf(buf, "33554431\n");
+	return 0;
 }
 
-static ssize_t quad8_count_ceiling_write(struct counter_device *counter,
-	struct counter_count *count, void *private, const char *buf, size_t len)
+static int quad8_count_ceiling_write(struct counter_device *counter,
+				     struct counter_count *count, u64 ceiling)
 {
 	struct quad8 *const priv = counter->priv;
-	unsigned int ceiling;
-	int ret;
-
-	ret = kstrtouint(buf, 0, &ceiling);
-	if (ret)
-		return ret;
 
 	/* Only 24-bit values are supported */
 	if (ceiling > 0xFFFFFF)
@@ -726,7 +681,7 @@ static ssize_t quad8_count_ceiling_write(struct counter_device *counter,
 	case 3:
 		quad8_preset_register_set(priv, count->id, ceiling);
 		mutex_unlock(&priv->lock);
-		return len;
+		return 0;
 	}
 
 	mutex_unlock(&priv->lock);
@@ -734,27 +689,25 @@ static ssize_t quad8_count_ceiling_write(struct counter_device *counter,
 	return -EINVAL;
 }
 
-static ssize_t quad8_count_preset_enable_read(struct counter_device *counter,
-	struct counter_count *count, void *private, char *buf)
+static int quad8_count_preset_enable_read(struct counter_device *counter,
+					  struct counter_count *count,
+					  u8 *preset_enable)
 {
 	const struct quad8 *const priv = counter->priv;
 
-	return sprintf(buf, "%u\n", !priv->preset_enable[count->id]);
+	*preset_enable = !priv->preset_enable[count->id];
+
+	return 0;
 }
 
-static ssize_t quad8_count_preset_enable_write(struct counter_device *counter,
-	struct counter_count *count, void *private, const char *buf, size_t len)
+static int quad8_count_preset_enable_write(struct counter_device *counter,
+					   struct counter_count *count,
+					   u8 preset_enable)
 {
 	struct quad8 *const priv = counter->priv;
 	const int base_offset = priv->base + 2 * count->id + 1;
-	bool preset_enable;
-	int ret;
 	unsigned int ior_cfg;
 
-	ret = kstrtobool(buf, &preset_enable);
-	if (ret)
-		return ret;
-
 	/* Preset enable is active low in Input/Output Control register */
 	preset_enable = !preset_enable;
 
@@ -762,25 +715,24 @@ static ssize_t quad8_count_preset_enable_write(struct counter_device *counter,
 
 	priv->preset_enable[count->id] = preset_enable;
 
-	ior_cfg = priv->ab_enable[count->id] | (unsigned int)preset_enable << 1;
+	ior_cfg = priv->ab_enable[count->id] | preset_enable << 1;
 
 	/* Load I/O control configuration to Input / Output Control Register */
 	outb(QUAD8_CTR_IOR | ior_cfg, base_offset);
 
 	mutex_unlock(&priv->lock);
 
-	return len;
+	return 0;
 }
 
-static ssize_t quad8_signal_cable_fault_read(struct counter_device *counter,
-					     struct counter_signal *signal,
-					     void *private, char *buf)
+static int quad8_signal_cable_fault_read(struct counter_device *counter,
+					 struct counter_signal *signal,
+					 u8 *cable_fault)
 {
 	struct quad8 *const priv = counter->priv;
 	const size_t channel_id = signal->id / 2;
 	bool disabled;
 	unsigned int status;
-	unsigned int fault;
 
 	mutex_lock(&priv->lock);
 
@@ -797,36 +749,31 @@ static ssize_t quad8_signal_cable_fault_read(struct counter_device *counter,
 	mutex_unlock(&priv->lock);
 
 	/* Mask respective channel and invert logic */
-	fault = !(status & BIT(channel_id));
+	*cable_fault = !(status & BIT(channel_id));
 
-	return sprintf(buf, "%u\n", fault);
+	return 0;
 }
 
-static ssize_t quad8_signal_cable_fault_enable_read(
-	struct counter_device *counter, struct counter_signal *signal,
-	void *private, char *buf)
+static int quad8_signal_cable_fault_enable_read(struct counter_device *counter,
+						struct counter_signal *signal,
+						u8 *enable)
 {
 	const struct quad8 *const priv = counter->priv;
 	const size_t channel_id = signal->id / 2;
-	const unsigned int enb = !!(priv->cable_fault_enable & BIT(channel_id));
 
-	return sprintf(buf, "%u\n", enb);
+	*enable = !!(priv->cable_fault_enable & BIT(channel_id));
+
+	return 0;
 }
 
-static ssize_t quad8_signal_cable_fault_enable_write(
-	struct counter_device *counter, struct counter_signal *signal,
-	void *private, const char *buf, size_t len)
+static int quad8_signal_cable_fault_enable_write(struct counter_device *counter,
+						 struct counter_signal *signal,
+						 u8 enable)
 {
 	struct quad8 *const priv = counter->priv;
 	const size_t channel_id = signal->id / 2;
-	bool enable;
-	int ret;
 	unsigned int cable_fault_enable;
 
-	ret = kstrtobool(buf, &enable);
-	if (ret)
-		return ret;
-
 	mutex_lock(&priv->lock);
 
 	if (enable)
@@ -841,31 +788,27 @@ static ssize_t quad8_signal_cable_fault_enable_write(
 
 	mutex_unlock(&priv->lock);
 
-	return len;
+	return 0;
 }
 
-static ssize_t quad8_signal_fck_prescaler_read(struct counter_device *counter,
-	struct counter_signal *signal, void *private, char *buf)
+static int quad8_signal_fck_prescaler_read(struct counter_device *counter,
+					   struct counter_signal *signal,
+					   u8 *prescaler)
 {
 	const struct quad8 *const priv = counter->priv;
-	const size_t channel_id = signal->id / 2;
 
-	return sprintf(buf, "%u\n", priv->fck_prescaler[channel_id]);
+	*prescaler = priv->fck_prescaler[signal->id / 2];
+
+	return 0;
 }
 
-static ssize_t quad8_signal_fck_prescaler_write(struct counter_device *counter,
-	struct counter_signal *signal, void *private, const char *buf,
-	size_t len)
+static int quad8_signal_fck_prescaler_write(struct counter_device *counter,
+					    struct counter_signal *signal,
+					    u8 prescaler)
 {
 	struct quad8 *const priv = counter->priv;
 	const size_t channel_id = signal->id / 2;
 	const int base_offset = priv->base + 2 * channel_id;
-	u8 prescaler;
-	int ret;
-
-	ret = kstrtou8(buf, 0, &prescaler);
-	if (ret)
-		return ret;
 
 	mutex_lock(&priv->lock);
 
@@ -881,31 +824,30 @@ static ssize_t quad8_signal_fck_prescaler_write(struct counter_device *counter,
 
 	mutex_unlock(&priv->lock);
 
-	return len;
+	return 0;
 }
 
-static const struct counter_signal_ext quad8_signal_ext[] = {
-	{
-		.name = "cable_fault",
-		.read = quad8_signal_cable_fault_read
-	},
-	{
-		.name = "cable_fault_enable",
-		.read = quad8_signal_cable_fault_enable_read,
-		.write = quad8_signal_cable_fault_enable_write
-	},
-	{
-		.name = "filter_clock_prescaler",
-		.read = quad8_signal_fck_prescaler_read,
-		.write = quad8_signal_fck_prescaler_write
-	}
+static struct counter_comp quad8_signal_ext[] = {
+	COUNTER_COMP_SIGNAL_BOOL("cable_fault", quad8_signal_cable_fault_read,
+				 NULL),
+	COUNTER_COMP_SIGNAL_BOOL("cable_fault_enable",
+				 quad8_signal_cable_fault_enable_read,
+				 quad8_signal_cable_fault_enable_write),
+	COUNTER_COMP_SIGNAL_U8("filter_clock_prescaler",
+			       quad8_signal_fck_prescaler_read,
+			       quad8_signal_fck_prescaler_write)
 };
 
-static const struct counter_signal_ext quad8_index_ext[] = {
-	COUNTER_SIGNAL_ENUM("index_polarity", &quad8_index_pol_enum),
-	COUNTER_SIGNAL_ENUM_AVAILABLE("index_polarity",	&quad8_index_pol_enum),
-	COUNTER_SIGNAL_ENUM("synchronous_mode", &quad8_syn_mode_enum),
-	COUNTER_SIGNAL_ENUM_AVAILABLE("synchronous_mode", &quad8_syn_mode_enum)
+static DEFINE_COUNTER_ENUM(quad8_index_pol_enum, quad8_index_polarity_modes);
+static DEFINE_COUNTER_ENUM(quad8_synch_mode_enum, quad8_synchronous_modes);
+
+static struct counter_comp quad8_index_ext[] = {
+	COUNTER_COMP_SIGNAL_ENUM("index_polarity", quad8_index_polarity_get,
+				 quad8_index_polarity_set,
+				 quad8_index_pol_enum),
+	COUNTER_COMP_SIGNAL_ENUM("synchronous_mode", quad8_synchronous_mode_get,
+				 quad8_synchronous_mode_set,
+				 quad8_synch_mode_enum),
 };
 
 #define QUAD8_QUAD_SIGNAL(_id, _name) {		\
@@ -974,39 +916,30 @@ static struct counter_synapse quad8_count_synapses[][3] = {
 	QUAD8_COUNT_SYNAPSES(6), QUAD8_COUNT_SYNAPSES(7)
 };
 
-static const struct counter_count_ext quad8_count_ext[] = {
-	{
-		.name = "ceiling",
-		.read = quad8_count_ceiling_read,
-		.write = quad8_count_ceiling_write
-	},
-	{
-		.name = "floor",
-		.read = quad8_count_floor_read
-	},
-	COUNTER_COUNT_ENUM("count_mode", &quad8_cnt_mode_enum),
-	COUNTER_COUNT_ENUM_AVAILABLE("count_mode", &quad8_cnt_mode_enum),
-	{
-		.name = "direction",
-		.read = quad8_count_direction_read
-	},
-	{
-		.name = "enable",
-		.read = quad8_count_enable_read,
-		.write = quad8_count_enable_write
-	},
-	COUNTER_COUNT_ENUM("error_noise", &quad8_error_noise_enum),
-	COUNTER_COUNT_ENUM_AVAILABLE("error_noise", &quad8_error_noise_enum),
-	{
-		.name = "preset",
-		.read = quad8_count_preset_read,
-		.write = quad8_count_preset_write
-	},
-	{
-		.name = "preset_enable",
-		.read = quad8_count_preset_enable_read,
-		.write = quad8_count_preset_enable_write
-	}
+static const enum counter_count_mode quad8_cnt_modes[] = {
+	COUNTER_COUNT_MODE_NORMAL,
+	COUNTER_COUNT_MODE_RANGE_LIMIT,
+	COUNTER_COUNT_MODE_NON_RECYCLE,
+	COUNTER_COUNT_MODE_MODULO_N,
+};
+
+static DEFINE_COUNTER_AVAILABLE(quad8_count_mode_available, quad8_cnt_modes);
+
+static DEFINE_COUNTER_ENUM(quad8_error_noise_enum, quad8_noise_error_states);
+
+static struct counter_comp quad8_count_ext[] = {
+	COUNTER_COMP_CEILING(quad8_count_ceiling_read,
+			     quad8_count_ceiling_write),
+	COUNTER_COMP_FLOOR(quad8_count_floor_read, NULL),
+	COUNTER_COMP_COUNT_MODE(quad8_count_mode_read, quad8_count_mode_write,
+				quad8_count_mode_available),
+	COUNTER_COMP_DIRECTION(quad8_direction_read),
+	COUNTER_COMP_ENABLE(quad8_count_enable_read, quad8_count_enable_write),
+	COUNTER_COMP_COUNT_ENUM("error_noise", quad8_error_noise_get, NULL,
+				quad8_error_noise_enum),
+	COUNTER_COMP_PRESET(quad8_count_preset_read, quad8_count_preset_write),
+	COUNTER_COMP_PRESET_ENABLE(quad8_count_preset_enable_read,
+				   quad8_count_preset_enable_write),
 };
 
 #define QUAD8_COUNT(_id, _cntname) {					\
diff --git a/drivers/counter/Makefile b/drivers/counter/Makefile
index 19742e6f5e3e..1ab7e087fdc2 100644
--- a/drivers/counter/Makefile
+++ b/drivers/counter/Makefile
@@ -4,6 +4,7 @@
 #
 
 obj-$(CONFIG_COUNTER) += counter.o
+counter-y := counter-core.o counter-sysfs.o
 
 obj-$(CONFIG_104_QUAD_8)	+= 104-quad-8.o
 obj-$(CONFIG_INTERRUPT_CNT)		+= interrupt-cnt.o
diff --git a/drivers/counter/counter-core.c b/drivers/counter/counter-core.c
new file mode 100644
index 000000000000..c533a6ff12cf
--- /dev/null
+++ b/drivers/counter/counter-core.c
@@ -0,0 +1,142 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Generic Counter interface
+ * Copyright (C) 2020 William Breathitt Gray
+ */
+#include <linux/counter.h>
+#include <linux/device.h>
+#include <linux/export.h>
+#include <linux/gfp.h>
+#include <linux/idr.h>
+#include <linux/init.h>
+#include <linux/module.h>
+
+#include "counter-sysfs.h"
+
+/* Provides a unique ID for each counter device */
+static DEFINE_IDA(counter_ida);
+
+static void counter_device_release(struct device *dev)
+{
+	ida_free(&counter_ida, dev->id);
+}
+
+static struct device_type counter_device_type = {
+	.name = "counter_device",
+	.release = counter_device_release,
+};
+
+static struct bus_type counter_bus_type = {
+	.name = "counter",
+	.dev_name = "counter",
+};
+
+/**
+ * counter_register - register Counter to the system
+ * @counter:	pointer to Counter to register
+ *
+ * This function registers a Counter to the system. A sysfs "counter" directory
+ * will be created and populated with sysfs attributes correlating with the
+ * Counter Signals, Synapses, and Counts respectively.
+ */
+int counter_register(struct counter_device *const counter)
+{
+	struct device *const dev = &counter->dev;
+	int id;
+	int err;
+
+	/* Acquire unique ID */
+	id = ida_alloc(&counter_ida, GFP_KERNEL);
+	if (id < 0)
+		return id;
+
+	/* Configure device structure for Counter */
+	dev->id = id;
+	dev->type = &counter_device_type;
+	dev->bus = &counter_bus_type;
+	if (counter->parent) {
+		dev->parent = counter->parent;
+		dev->of_node = counter->parent->of_node;
+	}
+	device_initialize(dev);
+	dev_set_drvdata(dev, counter);
+
+	/* Add Counter sysfs attributes */
+	err = counter_sysfs_add(counter);
+	if (err < 0)
+		goto err_free_id;
+
+	/* Add device to system */
+	err = device_add(dev);
+	if (err < 0)
+		goto err_free_id;
+
+	return 0;
+
+err_free_id:
+	put_device(dev);
+	return err;
+}
+EXPORT_SYMBOL_GPL(counter_register);
+
+/**
+ * counter_unregister - unregister Counter from the system
+ * @counter:	pointer to Counter to unregister
+ *
+ * The Counter is unregistered from the system.
+ */
+void counter_unregister(struct counter_device *const counter)
+{
+	if (!counter)
+		return;
+
+	device_unregister(&counter->dev);
+}
+EXPORT_SYMBOL_GPL(counter_unregister);
+
+static void devm_counter_release(void *counter)
+{
+	counter_unregister(counter);
+}
+
+/**
+ * devm_counter_register - Resource-managed counter_register
+ * @dev:	device to allocate counter_device for
+ * @counter:	pointer to Counter to register
+ *
+ * Managed counter_register. The Counter registered with this function is
+ * automatically unregistered on driver detach. This function calls
+ * counter_register internally. Refer to that function for more information.
+ *
+ * RETURNS:
+ * 0 on success, negative error number on failure.
+ */
+int devm_counter_register(struct device *dev,
+			  struct counter_device *const counter)
+{
+	int err;
+
+	err = counter_register(counter);
+	if (err < 0)
+		return err;
+
+	return devm_add_action_or_reset(dev, devm_counter_release, counter);
+}
+EXPORT_SYMBOL_GPL(devm_counter_register);
+
+static int __init counter_init(void)
+{
+	return bus_register(&counter_bus_type);
+}
+
+static void __exit counter_exit(void)
+{
+	bus_unregister(&counter_bus_type);
+}
+
+subsys_initcall(counter_init);
+module_exit(counter_exit);
+
+MODULE_AUTHOR("William Breathitt Gray <vilhelm.gray@gmail.com>");
+MODULE_DESCRIPTION("Generic Counter interface");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/counter/counter-sysfs.c b/drivers/counter/counter-sysfs.c
new file mode 100644
index 000000000000..108cbd838eb9
--- /dev/null
+++ b/drivers/counter/counter-sysfs.c
@@ -0,0 +1,849 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Generic Counter sysfs interface
+ * Copyright (C) 2020 William Breathitt Gray
+ */
+#include <linux/counter.h>
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/gfp.h>
+#include <linux/kernel.h>
+#include <linux/kstrtox.h>
+#include <linux/list.h>
+#include <linux/string.h>
+#include <linux/sysfs.h>
+#include <linux/types.h>
+
+#include "counter-sysfs.h"
+
+/**
+ * struct counter_attribute - Counter sysfs attribute
+ * @dev_attr:	device attribute for sysfs
+ * @l:		node to add Counter attribute to attribute group list
+ * @comp:	Counter component callbacks and data
+ * @scope:	Counter scope of the attribute
+ * @parent:	pointer to the parent component
+ */
+struct counter_attribute {
+	struct device_attribute dev_attr;
+	struct list_head l;
+
+	struct counter_comp comp;
+	enum counter_scope scope;
+	void *parent;
+};
+
+#define to_counter_attribute(_dev_attr) \
+	container_of(_dev_attr, struct counter_attribute, dev_attr)
+
+/**
+ * struct counter_attribute_group - container for attribute group
+ * @name:	name of the attribute group
+ * @attr_list:	list to keep track of created attributes
+ * @num_attr:	number of attributes
+ */
+struct counter_attribute_group {
+	const char *name;
+	struct list_head attr_list;
+	size_t num_attr;
+};
+
+static const char *const counter_function_str[] = {
+	[COUNTER_FUNCTION_INCREASE] = "increase",
+	[COUNTER_FUNCTION_DECREASE] = "decrease",
+	[COUNTER_FUNCTION_PULSE_DIRECTION] = "pulse-direction",
+	[COUNTER_FUNCTION_QUADRATURE_X1_A] = "quadrature x1 a",
+	[COUNTER_FUNCTION_QUADRATURE_X1_B] = "quadrature x1 b",
+	[COUNTER_FUNCTION_QUADRATURE_X2_A] = "quadrature x2 a",
+	[COUNTER_FUNCTION_QUADRATURE_X2_B] = "quadrature x2 b",
+	[COUNTER_FUNCTION_QUADRATURE_X4] = "quadrature x4"
+};
+
+static const char *const counter_signal_value_str[] = {
+	[COUNTER_SIGNAL_LEVEL_LOW] = "low",
+	[COUNTER_SIGNAL_LEVEL_HIGH] = "high"
+};
+
+static const char *const counter_synapse_action_str[] = {
+	[COUNTER_SYNAPSE_ACTION_NONE] = "none",
+	[COUNTER_SYNAPSE_ACTION_RISING_EDGE] = "rising edge",
+	[COUNTER_SYNAPSE_ACTION_FALLING_EDGE] = "falling edge",
+	[COUNTER_SYNAPSE_ACTION_BOTH_EDGES] = "both edges"
+};
+
+static const char *const counter_count_direction_str[] = {
+	[COUNTER_COUNT_DIRECTION_FORWARD] = "forward",
+	[COUNTER_COUNT_DIRECTION_BACKWARD] = "backward"
+};
+
+static const char *const counter_count_mode_str[] = {
+	[COUNTER_COUNT_MODE_NORMAL] = "normal",
+	[COUNTER_COUNT_MODE_RANGE_LIMIT] = "range limit",
+	[COUNTER_COUNT_MODE_NON_RECYCLE] = "non-recycle",
+	[COUNTER_COUNT_MODE_MODULO_N] = "modulo-n"
+};
+
+static ssize_t counter_comp_u8_show(struct device *dev,
+				    struct device_attribute *attr, char *buf)
+{
+	const struct counter_attribute *const a = to_counter_attribute(attr);
+	struct counter_device *const counter = dev_get_drvdata(dev);
+	int err;
+	u8 data = 0;
+
+	switch (a->scope) {
+	case COUNTER_SCOPE_DEVICE:
+		err = a->comp.device_u8_read(counter, &data);
+		break;
+	case COUNTER_SCOPE_SIGNAL:
+		err = a->comp.signal_u8_read(counter, a->parent, &data);
+		break;
+	case COUNTER_SCOPE_COUNT:
+		err = a->comp.count_u8_read(counter, a->parent, &data);
+		break;
+	default:
+		return -EINVAL;
+	}
+	if (err < 0)
+		return err;
+
+	if (a->comp.type == COUNTER_COMP_BOOL)
+		/* data should already be boolean but ensure just to be safe */
+		data = !!data;
+
+	return sprintf(buf, "%u\n", (unsigned int)data);
+}
+
+static ssize_t counter_comp_u8_store(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t len)
+{
+	const struct counter_attribute *const a = to_counter_attribute(attr);
+	struct counter_device *const counter = dev_get_drvdata(dev);
+	int err;
+	bool bool_data = 0;
+	u8 data = 0;
+
+	if (a->comp.type == COUNTER_COMP_BOOL) {
+		err = kstrtobool(buf, &bool_data);
+		data = bool_data;
+	} else
+		err = kstrtou8(buf, 0, &data);
+	if (err < 0)
+		return err;
+
+	switch (a->scope) {
+	case COUNTER_SCOPE_DEVICE:
+		err = a->comp.device_u8_write(counter, data);
+		break;
+	case COUNTER_SCOPE_SIGNAL:
+		err = a->comp.signal_u8_write(counter, a->parent, data);
+		break;
+	case COUNTER_SCOPE_COUNT:
+		err = a->comp.count_u8_write(counter, a->parent, data);
+		break;
+	default:
+		return -EINVAL;
+	}
+	if (err < 0)
+		return err;
+
+	return len;
+}
+
+static ssize_t counter_comp_u32_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	const struct counter_attribute *const a = to_counter_attribute(attr);
+	struct counter_device *const counter = dev_get_drvdata(dev);
+	const struct counter_available *const avail = a->comp.priv;
+	int err;
+	u32 data = 0;
+
+	switch (a->scope) {
+	case COUNTER_SCOPE_DEVICE:
+		err = a->comp.device_u32_read(counter, &data);
+		break;
+	case COUNTER_SCOPE_SIGNAL:
+		err = a->comp.signal_u32_read(counter, a->parent, &data);
+		break;
+	case COUNTER_SCOPE_COUNT:
+		if (a->comp.type == COUNTER_COMP_SYNAPSE_ACTION)
+			err = a->comp.action_read(counter, a->parent,
+						  a->comp.priv, &data);
+		else
+			err = a->comp.count_u32_read(counter, a->parent, &data);
+		break;
+	default:
+		return -EINVAL;
+	}
+	if (err < 0)
+		return err;
+
+	switch (a->comp.type) {
+	case COUNTER_COMP_FUNCTION:
+		return sysfs_emit(buf, "%s\n", counter_function_str[data]);
+	case COUNTER_COMP_SIGNAL_LEVEL:
+		return sysfs_emit(buf, "%s\n", counter_signal_value_str[data]);
+	case COUNTER_COMP_SYNAPSE_ACTION:
+		return sysfs_emit(buf, "%s\n", counter_synapse_action_str[data]);
+	case COUNTER_COMP_ENUM:
+		return sysfs_emit(buf, "%s\n", avail->strs[data]);
+	case COUNTER_COMP_COUNT_DIRECTION:
+		return sysfs_emit(buf, "%s\n", counter_count_direction_str[data]);
+	case COUNTER_COMP_COUNT_MODE:
+		return sysfs_emit(buf, "%s\n", counter_count_mode_str[data]);
+	default:
+		return sprintf(buf, "%u\n", (unsigned int)data);
+	}
+}
+
+static int counter_find_enum(u32 *const enum_item, const u32 *const enums,
+			     const size_t num_enums, const char *const buf,
+			     const char *const string_array[])
+{
+	size_t index;
+
+	for (index = 0; index < num_enums; index++) {
+		*enum_item = enums[index];
+		if (sysfs_streq(buf, string_array[*enum_item]))
+			return 0;
+	}
+
+	return -EINVAL;
+}
+
+static ssize_t counter_comp_u32_store(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t len)
+{
+	const struct counter_attribute *const a = to_counter_attribute(attr);
+	struct counter_device *const counter = dev_get_drvdata(dev);
+	struct counter_count *const count = a->parent;
+	struct counter_synapse *const synapse = a->comp.priv;
+	const struct counter_available *const avail = a->comp.priv;
+	int err;
+	u32 data = 0;
+
+	switch (a->comp.type) {
+	case COUNTER_COMP_FUNCTION:
+		err = counter_find_enum(&data, count->functions_list,
+					count->num_functions, buf,
+					counter_function_str);
+		break;
+	case COUNTER_COMP_SYNAPSE_ACTION:
+		err = counter_find_enum(&data, synapse->actions_list,
+					synapse->num_actions, buf,
+					counter_synapse_action_str);
+		break;
+	case COUNTER_COMP_ENUM:
+		err = __sysfs_match_string(avail->strs, avail->num_items, buf);
+		data = err;
+		break;
+	case COUNTER_COMP_COUNT_MODE:
+		err = counter_find_enum(&data, avail->enums, avail->num_items,
+					buf, counter_count_mode_str);
+		break;
+	default:
+		err = kstrtou32(buf, 0, &data);
+		break;
+	}
+	if (err < 0)
+		return err;
+
+	switch (a->scope) {
+	case COUNTER_SCOPE_DEVICE:
+		err = a->comp.device_u32_write(counter, data);
+		break;
+	case COUNTER_SCOPE_SIGNAL:
+		err = a->comp.signal_u32_write(counter, a->parent, data);
+		break;
+	case COUNTER_SCOPE_COUNT:
+		if (a->comp.type == COUNTER_COMP_SYNAPSE_ACTION)
+			err = a->comp.action_write(counter, count, synapse,
+						   data);
+		else
+			err = a->comp.count_u32_write(counter, count, data);
+		break;
+	default:
+		return -EINVAL;
+	}
+	if (err < 0)
+		return err;
+
+	return len;
+}
+
+static ssize_t counter_comp_u64_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	const struct counter_attribute *const a = to_counter_attribute(attr);
+	struct counter_device *const counter = dev_get_drvdata(dev);
+	int err;
+	u64 data = 0;
+
+	switch (a->scope) {
+	case COUNTER_SCOPE_DEVICE:
+		err = a->comp.device_u64_read(counter, &data);
+		break;
+	case COUNTER_SCOPE_SIGNAL:
+		err = a->comp.signal_u64_read(counter, a->parent, &data);
+		break;
+	case COUNTER_SCOPE_COUNT:
+		err = a->comp.count_u64_read(counter, a->parent, &data);
+		break;
+	default:
+		return -EINVAL;
+	}
+	if (err < 0)
+		return err;
+
+	return sprintf(buf, "%llu\n", (unsigned long long)data);
+}
+
+static ssize_t counter_comp_u64_store(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t len)
+{
+	const struct counter_attribute *const a = to_counter_attribute(attr);
+	struct counter_device *const counter = dev_get_drvdata(dev);
+	int err;
+	u64 data = 0;
+
+	err = kstrtou64(buf, 0, &data);
+	if (err < 0)
+		return err;
+
+	switch (a->scope) {
+	case COUNTER_SCOPE_DEVICE:
+		err = a->comp.device_u64_write(counter, data);
+		break;
+	case COUNTER_SCOPE_SIGNAL:
+		err = a->comp.signal_u64_write(counter, a->parent, data);
+		break;
+	case COUNTER_SCOPE_COUNT:
+		err = a->comp.count_u64_write(counter, a->parent, data);
+		break;
+	default:
+		return -EINVAL;
+	}
+	if (err < 0)
+		return err;
+
+	return len;
+}
+
+static ssize_t enums_available_show(const u32 *const enums,
+				    const size_t num_enums,
+				    const char *const strs[], char *buf)
+{
+	size_t len = 0;
+	size_t index;
+
+	for (index = 0; index < num_enums; index++)
+		len += sysfs_emit_at(buf, len, "%s\n", strs[enums[index]]);
+
+	return len;
+}
+
+static ssize_t strs_available_show(const struct counter_available *const avail,
+				   char *buf)
+{
+	size_t len = 0;
+	size_t index;
+
+	for (index = 0; index < avail->num_items; index++)
+		len += sysfs_emit_at(buf, len, "%s\n", avail->strs[index]);
+
+	return len;
+}
+
+static ssize_t counter_comp_available_show(struct device *dev,
+					   struct device_attribute *attr,
+					   char *buf)
+{
+	const struct counter_attribute *const a = to_counter_attribute(attr);
+	const struct counter_count *const count = a->parent;
+	const struct counter_synapse *const synapse = a->comp.priv;
+	const struct counter_available *const avail = a->comp.priv;
+
+	switch (a->comp.type) {
+	case COUNTER_COMP_FUNCTION:
+		return enums_available_show(count->functions_list,
+					    count->num_functions,
+					    counter_function_str, buf);
+	case COUNTER_COMP_SYNAPSE_ACTION:
+		return enums_available_show(synapse->actions_list,
+					    synapse->num_actions,
+					    counter_synapse_action_str, buf);
+	case COUNTER_COMP_ENUM:
+		return strs_available_show(avail, buf);
+	case COUNTER_COMP_COUNT_MODE:
+		return enums_available_show(avail->enums, avail->num_items,
+					    counter_count_mode_str, buf);
+	default:
+		return -EINVAL;
+	}
+}
+
+static int counter_avail_attr_create(struct device *const dev,
+	struct counter_attribute_group *const group,
+	const struct counter_comp *const comp, void *const parent)
+{
+	struct counter_attribute *counter_attr;
+	struct device_attribute *dev_attr;
+
+	counter_attr = devm_kzalloc(dev, sizeof(*counter_attr), GFP_KERNEL);
+	if (!counter_attr)
+		return -ENOMEM;
+
+	/* Configure Counter attribute */
+	counter_attr->comp.type = comp->type;
+	counter_attr->comp.priv = comp->priv;
+	counter_attr->parent = parent;
+
+	/* Initialize sysfs attribute */
+	dev_attr = &counter_attr->dev_attr;
+	sysfs_attr_init(&dev_attr->attr);
+
+	/* Configure device attribute */
+	dev_attr->attr.name = devm_kasprintf(dev, GFP_KERNEL, "%s_available",
+					     comp->name);
+	if (!dev_attr->attr.name)
+		return -ENOMEM;
+	dev_attr->attr.mode = 0444;
+	dev_attr->show = counter_comp_available_show;
+
+	/* Store list node */
+	list_add(&counter_attr->l, &group->attr_list);
+	group->num_attr++;
+
+	return 0;
+}
+
+static int counter_attr_create(struct device *const dev,
+			       struct counter_attribute_group *const group,
+			       const struct counter_comp *const comp,
+			       const enum counter_scope scope,
+			       void *const parent)
+{
+	struct counter_attribute *counter_attr;
+	struct device_attribute *dev_attr;
+
+	counter_attr = devm_kzalloc(dev, sizeof(*counter_attr), GFP_KERNEL);
+	if (!counter_attr)
+		return -ENOMEM;
+
+	/* Configure Counter attribute */
+	counter_attr->comp = *comp;
+	counter_attr->scope = scope;
+	counter_attr->parent = parent;
+
+	/* Configure device attribute */
+	dev_attr = &counter_attr->dev_attr;
+	sysfs_attr_init(&dev_attr->attr);
+	dev_attr->attr.name = comp->name;
+	switch (comp->type) {
+	case COUNTER_COMP_U8:
+	case COUNTER_COMP_BOOL:
+		if (comp->device_u8_read) {
+			dev_attr->attr.mode |= 0444;
+			dev_attr->show = counter_comp_u8_show;
+		}
+		if (comp->device_u8_write) {
+			dev_attr->attr.mode |= 0200;
+			dev_attr->store = counter_comp_u8_store;
+		}
+		break;
+	case COUNTER_COMP_SIGNAL_LEVEL:
+	case COUNTER_COMP_FUNCTION:
+	case COUNTER_COMP_SYNAPSE_ACTION:
+	case COUNTER_COMP_ENUM:
+	case COUNTER_COMP_COUNT_DIRECTION:
+	case COUNTER_COMP_COUNT_MODE:
+		if (comp->device_u32_read) {
+			dev_attr->attr.mode |= 0444;
+			dev_attr->show = counter_comp_u32_show;
+		}
+		if (comp->device_u32_write) {
+			dev_attr->attr.mode |= 0200;
+			dev_attr->store = counter_comp_u32_store;
+		}
+		break;
+	case COUNTER_COMP_U64:
+		if (comp->device_u64_read) {
+			dev_attr->attr.mode |= 0444;
+			dev_attr->show = counter_comp_u64_show;
+		}
+		if (comp->device_u64_write) {
+			dev_attr->attr.mode |= 0200;
+			dev_attr->store = counter_comp_u64_store;
+		}
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/* Store list node */
+	list_add(&counter_attr->l, &group->attr_list);
+	group->num_attr++;
+
+	/* Create "*_available" attribute if needed */
+	switch (comp->type) {
+	case COUNTER_COMP_FUNCTION:
+	case COUNTER_COMP_SYNAPSE_ACTION:
+	case COUNTER_COMP_ENUM:
+	case COUNTER_COMP_COUNT_MODE:
+		return counter_avail_attr_create(dev, group, comp, parent);
+	default:
+		return 0;
+	}
+}
+
+static ssize_t counter_comp_name_show(struct device *dev,
+				      struct device_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%s\n", to_counter_attribute(attr)->comp.name);
+}
+
+static int counter_name_attr_create(struct device *const dev,
+				    struct counter_attribute_group *const group,
+				    const char *const name)
+{
+	struct counter_attribute *counter_attr;
+
+	counter_attr = devm_kzalloc(dev, sizeof(*counter_attr), GFP_KERNEL);
+	if (!counter_attr)
+		return -ENOMEM;
+
+	/* Configure Counter attribute */
+	counter_attr->comp.name = name;
+
+	/* Configure device attribute */
+	sysfs_attr_init(&counter_attr->dev_attr.attr);
+	counter_attr->dev_attr.attr.name = "name";
+	counter_attr->dev_attr.attr.mode = 0444;
+	counter_attr->dev_attr.show = counter_comp_name_show;
+
+	/* Store list node */
+	list_add(&counter_attr->l, &group->attr_list);
+	group->num_attr++;
+
+	return 0;
+}
+
+static struct counter_comp counter_signal_comp = {
+	.type = COUNTER_COMP_SIGNAL_LEVEL,
+	.name = "signal",
+};
+
+static int counter_signal_attrs_create(struct counter_device *const counter,
+	struct counter_attribute_group *const cattr_group,
+	struct counter_signal *const signal)
+{
+	const enum counter_scope scope = COUNTER_SCOPE_SIGNAL;
+	struct device *const dev = &counter->dev;
+	int err;
+	struct counter_comp comp;
+	size_t i;
+
+	/* Create main Signal attribute */
+	comp = counter_signal_comp;
+	comp.signal_u32_read = counter->ops->signal_read;
+	err = counter_attr_create(dev, cattr_group, &comp, scope, signal);
+	if (err < 0)
+		return err;
+
+	/* Create Signal name attribute */
+	err = counter_name_attr_create(dev, cattr_group, signal->name);
+	if (err < 0)
+		return err;
+
+	/* Create an attribute for each extension */
+	for (i = 0; i < signal->num_ext; i++) {
+		err = counter_attr_create(dev, cattr_group, signal->ext + i,
+					  scope, signal);
+		if (err < 0)
+			return err;
+	}
+
+	return 0;
+}
+
+static int counter_sysfs_signals_add(struct counter_device *const counter,
+	struct counter_attribute_group *const groups)
+{
+	size_t i;
+	int err;
+
+	/* Add each Signal */
+	for (i = 0; i < counter->num_signals; i++) {
+		/* Generate Signal attribute directory name */
+		groups[i].name = devm_kasprintf(&counter->dev, GFP_KERNEL,
+						"signal%zu", i);
+		if (!groups[i].name)
+			return -ENOMEM;
+
+		/* Create all attributes associated with Signal */
+		err = counter_signal_attrs_create(counter, groups + i,
+						  counter->signals + i);
+		if (err < 0)
+			return err;
+	}
+
+	return 0;
+}
+
+static int counter_sysfs_synapses_add(struct counter_device *const counter,
+	struct counter_attribute_group *const group,
+	struct counter_count *const count)
+{
+	size_t i;
+
+	/* Add each Synapse */
+	for (i = 0; i < count->num_synapses; i++) {
+		struct device *const dev = &counter->dev;
+		struct counter_synapse *synapse;
+		size_t id;
+		struct counter_comp comp;
+		int err;
+
+		synapse = count->synapses + i;
+
+		/* Generate Synapse action name */
+		id = synapse->signal - counter->signals;
+		comp.name = devm_kasprintf(dev, GFP_KERNEL, "signal%zu_action",
+					   id);
+		if (!comp.name)
+			return -ENOMEM;
+
+		/* Create action attribute */
+		comp.type = COUNTER_COMP_SYNAPSE_ACTION;
+		comp.action_read = counter->ops->action_read;
+		comp.action_write = counter->ops->action_write;
+		comp.priv = synapse;
+		err = counter_attr_create(dev, group, &comp,
+					  COUNTER_SCOPE_COUNT, count);
+		if (err < 0)
+			return err;
+	}
+
+	return 0;
+}
+
+static struct counter_comp counter_count_comp =
+	COUNTER_COMP_COUNT_U64("count", NULL, NULL);
+
+static struct counter_comp counter_function_comp = {
+	.type = COUNTER_COMP_FUNCTION,
+	.name = "function",
+};
+
+static int counter_count_attrs_create(struct counter_device *const counter,
+	struct counter_attribute_group *const cattr_group,
+	struct counter_count *const count)
+{
+	const enum counter_scope scope = COUNTER_SCOPE_COUNT;
+	struct device *const dev = &counter->dev;
+	int err;
+	struct counter_comp comp;
+	size_t i;
+
+	/* Create main Count attribute */
+	comp = counter_count_comp;
+	comp.count_u64_read = counter->ops->count_read;
+	comp.count_u64_write = counter->ops->count_write;
+	err = counter_attr_create(dev, cattr_group, &comp, scope, count);
+	if (err < 0)
+		return err;
+
+	/* Create Count name attribute */
+	err = counter_name_attr_create(dev, cattr_group, count->name);
+	if (err < 0)
+		return err;
+
+	/* Create Count function attribute */
+	comp = counter_function_comp;
+	comp.count_u32_read = counter->ops->function_read;
+	comp.count_u32_write = counter->ops->function_write;
+	err = counter_attr_create(dev, cattr_group, &comp, scope, count);
+	if (err < 0)
+		return err;
+
+	/* Create an attribute for each extension */
+	for (i = 0; i < count->num_ext; i++) {
+		err = counter_attr_create(dev, cattr_group, count->ext + i,
+					  scope, count);
+		if (err < 0)
+			return err;
+	}
+
+	return 0;
+}
+
+static int counter_sysfs_counts_add(struct counter_device *const counter,
+	struct counter_attribute_group *const groups)
+{
+	size_t i;
+	struct counter_count *count;
+	int err;
+
+	/* Add each Count */
+	for (i = 0; i < counter->num_counts; i++) {
+		count = counter->counts + i;
+
+		/* Generate Count attribute directory name */
+		groups[i].name = devm_kasprintf(&counter->dev, GFP_KERNEL,
+						"count%zu", i);
+		if (!groups[i].name)
+			return -ENOMEM;
+
+		/* Add sysfs attributes of the Synapses */
+		err = counter_sysfs_synapses_add(counter, groups + i, count);
+		if (err < 0)
+			return err;
+
+		/* Create all attributes associated with Count */
+		err = counter_count_attrs_create(counter, groups + i, count);
+		if (err < 0)
+			return err;
+	}
+
+	return 0;
+}
+
+static int counter_num_signals_read(struct counter_device *counter, u8 *val)
+{
+	*val = counter->num_signals;
+	return 0;
+}
+
+static int counter_num_counts_read(struct counter_device *counter, u8 *val)
+{
+	*val = counter->num_counts;
+	return 0;
+}
+
+static struct counter_comp counter_num_signals_comp =
+	COUNTER_COMP_DEVICE_U8("num_signals", counter_num_signals_read, NULL);
+
+static struct counter_comp counter_num_counts_comp =
+	COUNTER_COMP_DEVICE_U8("num_counts", counter_num_counts_read, NULL);
+
+static int counter_sysfs_attr_add(struct counter_device *const counter,
+				  struct counter_attribute_group *cattr_group)
+{
+	const enum counter_scope scope = COUNTER_SCOPE_DEVICE;
+	struct device *const dev = &counter->dev;
+	int err;
+	size_t i;
+
+	/* Add Signals sysfs attributes */
+	err = counter_sysfs_signals_add(counter, cattr_group);
+	if (err < 0)
+		return err;
+	cattr_group += counter->num_signals;
+
+	/* Add Counts sysfs attributes */
+	err = counter_sysfs_counts_add(counter, cattr_group);
+	if (err < 0)
+		return err;
+	cattr_group += counter->num_counts;
+
+	/* Create name attribute */
+	err = counter_name_attr_create(dev, cattr_group, counter->name);
+	if (err < 0)
+		return err;
+
+	/* Create num_signals attribute */
+	err = counter_attr_create(dev, cattr_group, &counter_num_signals_comp,
+				  scope, NULL);
+	if (err < 0)
+		return err;
+
+	/* Create num_counts attribute */
+	err = counter_attr_create(dev, cattr_group, &counter_num_counts_comp,
+				  scope, NULL);
+	if (err < 0)
+		return err;
+
+	/* Create an attribute for each extension */
+	for (i = 0; i < counter->num_ext; i++) {
+		err = counter_attr_create(dev, cattr_group, counter->ext + i,
+					  scope, NULL);
+		if (err < 0)
+			return err;
+	}
+
+	return 0;
+}
+
+/**
+ * counter_sysfs_add - Adds Counter sysfs attributes to the device structure
+ * @counter:	Pointer to the Counter device structure
+ *
+ * Counter sysfs attributes are created and added to the respective device
+ * structure for later registration to the system. Resource-managed memory
+ * allocation is performed by this function, and this memory should be freed
+ * when no longer needed (automatically by a device_unregister call, or
+ * manually by a devres_release_all call).
+ */
+int counter_sysfs_add(struct counter_device *const counter)
+{
+	struct device *const dev = &counter->dev;
+	const size_t num_groups = counter->num_signals + counter->num_counts + 1;
+	struct counter_attribute_group *cattr_groups;
+	size_t i, j;
+	int err;
+	struct attribute_group *groups;
+	struct counter_attribute *p;
+
+	/* Allocate space for attribute groups (signals, counts, and ext) */
+	cattr_groups = devm_kcalloc(dev, num_groups, sizeof(*cattr_groups),
+				    GFP_KERNEL);
+	if (!cattr_groups)
+		return -ENOMEM;
+
+	/* Initialize attribute lists */
+	for (i = 0; i < num_groups; i++)
+		INIT_LIST_HEAD(&cattr_groups[i].attr_list);
+
+	/* Add Counter device sysfs attributes */
+	err = counter_sysfs_attr_add(counter, cattr_groups);
+	if (err < 0)
+		return err;
+
+	/* Allocate attribute group pointers for association with device */
+	dev->groups = devm_kcalloc(dev, num_groups + 1, sizeof(*dev->groups),
+				   GFP_KERNEL);
+	if (!dev->groups)
+		return -ENOMEM;
+
+	/* Allocate space for attribute groups */
+	groups = devm_kcalloc(dev, num_groups, sizeof(*groups), GFP_KERNEL);
+	if (!groups)
+		return -ENOMEM;
+
+	/* Prepare each group of attributes for association */
+	for (i = 0; i < num_groups; i++) {
+		groups[i].name = cattr_groups[i].name;
+
+		/* Allocate space for attribute pointers */
+		groups[i].attrs = devm_kcalloc(dev,
+					       cattr_groups[i].num_attr + 1,
+					       sizeof(*groups[i].attrs),
+					       GFP_KERNEL);
+		if (!groups[i].attrs)
+			return -ENOMEM;
+
+		/* Add attribute pointers to attribute group */
+		j = 0;
+		list_for_each_entry(p, &cattr_groups[i].attr_list, l)
+			groups[i].attrs[j++] = &p->dev_attr.attr;
+
+		/* Associate attribute group */
+		dev->groups[i] = &groups[i];
+	}
+
+	return 0;
+}
diff --git a/drivers/counter/counter-sysfs.h b/drivers/counter/counter-sysfs.h
new file mode 100644
index 000000000000..14fe566aca0e
--- /dev/null
+++ b/drivers/counter/counter-sysfs.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Counter sysfs interface
+ * Copyright (C) 2020 William Breathitt Gray
+ */
+#ifndef _COUNTER_SYSFS_H_
+#define _COUNTER_SYSFS_H_
+
+#include <linux/counter.h>
+
+int counter_sysfs_add(struct counter_device *const counter);
+
+#endif /* _COUNTER_SYSFS_H_ */
diff --git a/drivers/counter/counter.c b/drivers/counter/counter.c
deleted file mode 100644
index de921e8a3f72..000000000000
--- a/drivers/counter/counter.c
+++ /dev/null
@@ -1,1496 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Generic Counter interface
- * Copyright (C) 2018 William Breathitt Gray
- */
-#include <linux/counter.h>
-#include <linux/device.h>
-#include <linux/err.h>
-#include <linux/export.h>
-#include <linux/fs.h>
-#include <linux/gfp.h>
-#include <linux/idr.h>
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/list.h>
-#include <linux/module.h>
-#include <linux/printk.h>
-#include <linux/slab.h>
-#include <linux/string.h>
-#include <linux/sysfs.h>
-#include <linux/types.h>
-
-const char *const counter_count_direction_str[2] = {
-	[COUNTER_COUNT_DIRECTION_FORWARD] = "forward",
-	[COUNTER_COUNT_DIRECTION_BACKWARD] = "backward"
-};
-EXPORT_SYMBOL_GPL(counter_count_direction_str);
-
-const char *const counter_count_mode_str[4] = {
-	[COUNTER_COUNT_MODE_NORMAL] = "normal",
-	[COUNTER_COUNT_MODE_RANGE_LIMIT] = "range limit",
-	[COUNTER_COUNT_MODE_NON_RECYCLE] = "non-recycle",
-	[COUNTER_COUNT_MODE_MODULO_N] = "modulo-n"
-};
-EXPORT_SYMBOL_GPL(counter_count_mode_str);
-
-ssize_t counter_signal_enum_read(struct counter_device *counter,
-				 struct counter_signal *signal, void *priv,
-				 char *buf)
-{
-	const struct counter_signal_enum_ext *const e = priv;
-	int err;
-	size_t index;
-
-	if (!e->get)
-		return -EINVAL;
-
-	err = e->get(counter, signal, &index);
-	if (err)
-		return err;
-
-	if (index >= e->num_items)
-		return -EINVAL;
-
-	return sprintf(buf, "%s\n", e->items[index]);
-}
-EXPORT_SYMBOL_GPL(counter_signal_enum_read);
-
-ssize_t counter_signal_enum_write(struct counter_device *counter,
-				  struct counter_signal *signal, void *priv,
-				  const char *buf, size_t len)
-{
-	const struct counter_signal_enum_ext *const e = priv;
-	ssize_t index;
-	int err;
-
-	if (!e->set)
-		return -EINVAL;
-
-	index = __sysfs_match_string(e->items, e->num_items, buf);
-	if (index < 0)
-		return index;
-
-	err = e->set(counter, signal, index);
-	if (err)
-		return err;
-
-	return len;
-}
-EXPORT_SYMBOL_GPL(counter_signal_enum_write);
-
-ssize_t counter_signal_enum_available_read(struct counter_device *counter,
-					   struct counter_signal *signal,
-					   void *priv, char *buf)
-{
-	const struct counter_signal_enum_ext *const e = priv;
-	size_t i;
-	size_t len = 0;
-
-	if (!e->num_items)
-		return 0;
-
-	for (i = 0; i < e->num_items; i++)
-		len += sprintf(buf + len, "%s\n", e->items[i]);
-
-	return len;
-}
-EXPORT_SYMBOL_GPL(counter_signal_enum_available_read);
-
-ssize_t counter_count_enum_read(struct counter_device *counter,
-				struct counter_count *count, void *priv,
-				char *buf)
-{
-	const struct counter_count_enum_ext *const e = priv;
-	int err;
-	size_t index;
-
-	if (!e->get)
-		return -EINVAL;
-
-	err = e->get(counter, count, &index);
-	if (err)
-		return err;
-
-	if (index >= e->num_items)
-		return -EINVAL;
-
-	return sprintf(buf, "%s\n", e->items[index]);
-}
-EXPORT_SYMBOL_GPL(counter_count_enum_read);
-
-ssize_t counter_count_enum_write(struct counter_device *counter,
-				 struct counter_count *count, void *priv,
-				 const char *buf, size_t len)
-{
-	const struct counter_count_enum_ext *const e = priv;
-	ssize_t index;
-	int err;
-
-	if (!e->set)
-		return -EINVAL;
-
-	index = __sysfs_match_string(e->items, e->num_items, buf);
-	if (index < 0)
-		return index;
-
-	err = e->set(counter, count, index);
-	if (err)
-		return err;
-
-	return len;
-}
-EXPORT_SYMBOL_GPL(counter_count_enum_write);
-
-ssize_t counter_count_enum_available_read(struct counter_device *counter,
-					  struct counter_count *count,
-					  void *priv, char *buf)
-{
-	const struct counter_count_enum_ext *const e = priv;
-	size_t i;
-	size_t len = 0;
-
-	if (!e->num_items)
-		return 0;
-
-	for (i = 0; i < e->num_items; i++)
-		len += sprintf(buf + len, "%s\n", e->items[i]);
-
-	return len;
-}
-EXPORT_SYMBOL_GPL(counter_count_enum_available_read);
-
-ssize_t counter_device_enum_read(struct counter_device *counter, void *priv,
-				 char *buf)
-{
-	const struct counter_device_enum_ext *const e = priv;
-	int err;
-	size_t index;
-
-	if (!e->get)
-		return -EINVAL;
-
-	err = e->get(counter, &index);
-	if (err)
-		return err;
-
-	if (index >= e->num_items)
-		return -EINVAL;
-
-	return sprintf(buf, "%s\n", e->items[index]);
-}
-EXPORT_SYMBOL_GPL(counter_device_enum_read);
-
-ssize_t counter_device_enum_write(struct counter_device *counter, void *priv,
-				  const char *buf, size_t len)
-{
-	const struct counter_device_enum_ext *const e = priv;
-	ssize_t index;
-	int err;
-
-	if (!e->set)
-		return -EINVAL;
-
-	index = __sysfs_match_string(e->items, e->num_items, buf);
-	if (index < 0)
-		return index;
-
-	err = e->set(counter, index);
-	if (err)
-		return err;
-
-	return len;
-}
-EXPORT_SYMBOL_GPL(counter_device_enum_write);
-
-ssize_t counter_device_enum_available_read(struct counter_device *counter,
-					   void *priv, char *buf)
-{
-	const struct counter_device_enum_ext *const e = priv;
-	size_t i;
-	size_t len = 0;
-
-	if (!e->num_items)
-		return 0;
-
-	for (i = 0; i < e->num_items; i++)
-		len += sprintf(buf + len, "%s\n", e->items[i]);
-
-	return len;
-}
-EXPORT_SYMBOL_GPL(counter_device_enum_available_read);
-
-struct counter_attr_parm {
-	struct counter_device_attr_group *group;
-	const char *prefix;
-	const char *name;
-	ssize_t (*show)(struct device *dev, struct device_attribute *attr,
-			char *buf);
-	ssize_t (*store)(struct device *dev, struct device_attribute *attr,
-			 const char *buf, size_t len);
-	void *component;
-};
-
-struct counter_device_attr {
-	struct device_attribute dev_attr;
-	struct list_head l;
-	void *component;
-};
-
-static int counter_attribute_create(const struct counter_attr_parm *const parm)
-{
-	struct counter_device_attr *counter_attr;
-	struct device_attribute *dev_attr;
-	int err;
-	struct list_head *const attr_list = &parm->group->attr_list;
-
-	/* Allocate a Counter device attribute */
-	counter_attr = kzalloc(sizeof(*counter_attr), GFP_KERNEL);
-	if (!counter_attr)
-		return -ENOMEM;
-	dev_attr = &counter_attr->dev_attr;
-
-	sysfs_attr_init(&dev_attr->attr);
-
-	/* Configure device attribute */
-	dev_attr->attr.name = kasprintf(GFP_KERNEL, "%s%s", parm->prefix,
-					parm->name);
-	if (!dev_attr->attr.name) {
-		err = -ENOMEM;
-		goto err_free_counter_attr;
-	}
-	if (parm->show) {
-		dev_attr->attr.mode |= 0444;
-		dev_attr->show = parm->show;
-	}
-	if (parm->store) {
-		dev_attr->attr.mode |= 0200;
-		dev_attr->store = parm->store;
-	}
-
-	/* Store associated Counter component with attribute */
-	counter_attr->component = parm->component;
-
-	/* Keep track of the attribute for later cleanup */
-	list_add(&counter_attr->l, attr_list);
-	parm->group->num_attr++;
-
-	return 0;
-
-err_free_counter_attr:
-	kfree(counter_attr);
-	return err;
-}
-
-#define to_counter_attr(_dev_attr) \
-	container_of(_dev_attr, struct counter_device_attr, dev_attr)
-
-struct counter_signal_unit {
-	struct counter_signal *signal;
-};
-
-static const char *const counter_signal_level_str[] = {
-	[COUNTER_SIGNAL_LEVEL_LOW] = "low",
-	[COUNTER_SIGNAL_LEVEL_HIGH] = "high"
-};
-
-static ssize_t counter_signal_show(struct device *dev,
-				   struct device_attribute *attr, char *buf)
-{
-	struct counter_device *const counter = dev_get_drvdata(dev);
-	const struct counter_device_attr *const devattr = to_counter_attr(attr);
-	const struct counter_signal_unit *const component = devattr->component;
-	struct counter_signal *const signal = component->signal;
-	int err;
-	enum counter_signal_level level;
-
-	err = counter->ops->signal_read(counter, signal, &level);
-	if (err)
-		return err;
-
-	return sprintf(buf, "%s\n", counter_signal_level_str[level]);
-}
-
-struct counter_name_unit {
-	const char *name;
-};
-
-static ssize_t counter_device_attr_name_show(struct device *dev,
-					     struct device_attribute *attr,
-					     char *buf)
-{
-	const struct counter_name_unit *const comp = to_counter_attr(attr)->component;
-
-	return sprintf(buf, "%s\n", comp->name);
-}
-
-static int counter_name_attribute_create(
-	struct counter_device_attr_group *const group,
-	const char *const name)
-{
-	struct counter_name_unit *name_comp;
-	struct counter_attr_parm parm;
-	int err;
-
-	/* Skip if no name */
-	if (!name)
-		return 0;
-
-	/* Allocate name attribute component */
-	name_comp = kmalloc(sizeof(*name_comp), GFP_KERNEL);
-	if (!name_comp)
-		return -ENOMEM;
-	name_comp->name = name;
-
-	/* Allocate Signal name attribute */
-	parm.group = group;
-	parm.prefix = "";
-	parm.name = "name";
-	parm.show = counter_device_attr_name_show;
-	parm.store = NULL;
-	parm.component = name_comp;
-	err = counter_attribute_create(&parm);
-	if (err)
-		goto err_free_name_comp;
-
-	return 0;
-
-err_free_name_comp:
-	kfree(name_comp);
-	return err;
-}
-
-struct counter_signal_ext_unit {
-	struct counter_signal *signal;
-	const struct counter_signal_ext *ext;
-};
-
-static ssize_t counter_signal_ext_show(struct device *dev,
-				       struct device_attribute *attr, char *buf)
-{
-	const struct counter_device_attr *const devattr = to_counter_attr(attr);
-	const struct counter_signal_ext_unit *const comp = devattr->component;
-	const struct counter_signal_ext *const ext = comp->ext;
-
-	return ext->read(dev_get_drvdata(dev), comp->signal, ext->priv, buf);
-}
-
-static ssize_t counter_signal_ext_store(struct device *dev,
-					struct device_attribute *attr,
-					const char *buf, size_t len)
-{
-	const struct counter_device_attr *const devattr = to_counter_attr(attr);
-	const struct counter_signal_ext_unit *const comp = devattr->component;
-	const struct counter_signal_ext *const ext = comp->ext;
-
-	return ext->write(dev_get_drvdata(dev), comp->signal, ext->priv, buf,
-		len);
-}
-
-static void counter_device_attr_list_free(struct list_head *attr_list)
-{
-	struct counter_device_attr *p, *n;
-
-	list_for_each_entry_safe(p, n, attr_list, l) {
-		/* free attribute name and associated component memory */
-		kfree(p->dev_attr.attr.name);
-		kfree(p->component);
-		list_del(&p->l);
-		kfree(p);
-	}
-}
-
-static int counter_signal_ext_register(
-	struct counter_device_attr_group *const group,
-	struct counter_signal *const signal)
-{
-	const size_t num_ext = signal->num_ext;
-	size_t i;
-	const struct counter_signal_ext *ext;
-	struct counter_signal_ext_unit *signal_ext_comp;
-	struct counter_attr_parm parm;
-	int err;
-
-	/* Create an attribute for each extension */
-	for (i = 0 ; i < num_ext; i++) {
-		ext = signal->ext + i;
-
-		/* Allocate signal_ext attribute component */
-		signal_ext_comp = kmalloc(sizeof(*signal_ext_comp), GFP_KERNEL);
-		if (!signal_ext_comp) {
-			err = -ENOMEM;
-			goto err_free_attr_list;
-		}
-		signal_ext_comp->signal = signal;
-		signal_ext_comp->ext = ext;
-
-		/* Allocate a Counter device attribute */
-		parm.group = group;
-		parm.prefix = "";
-		parm.name = ext->name;
-		parm.show = (ext->read) ? counter_signal_ext_show : NULL;
-		parm.store = (ext->write) ? counter_signal_ext_store : NULL;
-		parm.component = signal_ext_comp;
-		err = counter_attribute_create(&parm);
-		if (err) {
-			kfree(signal_ext_comp);
-			goto err_free_attr_list;
-		}
-	}
-
-	return 0;
-
-err_free_attr_list:
-	counter_device_attr_list_free(&group->attr_list);
-	return err;
-}
-
-static int counter_signal_attributes_create(
-	struct counter_device_attr_group *const group,
-	const struct counter_device *const counter,
-	struct counter_signal *const signal)
-{
-	struct counter_signal_unit *signal_comp;
-	struct counter_attr_parm parm;
-	int err;
-
-	/* Allocate Signal attribute component */
-	signal_comp = kmalloc(sizeof(*signal_comp), GFP_KERNEL);
-	if (!signal_comp)
-		return -ENOMEM;
-	signal_comp->signal = signal;
-
-	/* Create main Signal attribute */
-	parm.group = group;
-	parm.prefix = "";
-	parm.name = "signal";
-	parm.show = (counter->ops->signal_read) ? counter_signal_show : NULL;
-	parm.store = NULL;
-	parm.component = signal_comp;
-	err = counter_attribute_create(&parm);
-	if (err) {
-		kfree(signal_comp);
-		return err;
-	}
-
-	/* Create Signal name attribute */
-	err = counter_name_attribute_create(group, signal->name);
-	if (err)
-		goto err_free_attr_list;
-
-	/* Register Signal extension attributes */
-	err = counter_signal_ext_register(group, signal);
-	if (err)
-		goto err_free_attr_list;
-
-	return 0;
-
-err_free_attr_list:
-	counter_device_attr_list_free(&group->attr_list);
-	return err;
-}
-
-static int counter_signals_register(
-	struct counter_device_attr_group *const groups_list,
-	const struct counter_device *const counter)
-{
-	const size_t num_signals = counter->num_signals;
-	size_t i;
-	struct counter_signal *signal;
-	const char *name;
-	int err;
-
-	/* Register each Signal */
-	for (i = 0; i < num_signals; i++) {
-		signal = counter->signals + i;
-
-		/* Generate Signal attribute directory name */
-		name = kasprintf(GFP_KERNEL, "signal%d", signal->id);
-		if (!name) {
-			err = -ENOMEM;
-			goto err_free_attr_groups;
-		}
-		groups_list[i].attr_group.name = name;
-
-		/* Create all attributes associated with Signal */
-		err = counter_signal_attributes_create(groups_list + i, counter,
-						       signal);
-		if (err)
-			goto err_free_attr_groups;
-	}
-
-	return 0;
-
-err_free_attr_groups:
-	do {
-		kfree(groups_list[i].attr_group.name);
-		counter_device_attr_list_free(&groups_list[i].attr_list);
-	} while (i--);
-	return err;
-}
-
-static const char *const counter_synapse_action_str[] = {
-	[COUNTER_SYNAPSE_ACTION_NONE] = "none",
-	[COUNTER_SYNAPSE_ACTION_RISING_EDGE] = "rising edge",
-	[COUNTER_SYNAPSE_ACTION_FALLING_EDGE] = "falling edge",
-	[COUNTER_SYNAPSE_ACTION_BOTH_EDGES] = "both edges"
-};
-
-struct counter_action_unit {
-	struct counter_synapse *synapse;
-	struct counter_count *count;
-};
-
-static ssize_t counter_action_show(struct device *dev,
-				   struct device_attribute *attr, char *buf)
-{
-	const struct counter_device_attr *const devattr = to_counter_attr(attr);
-	int err;
-	struct counter_device *const counter = dev_get_drvdata(dev);
-	const struct counter_action_unit *const component = devattr->component;
-	struct counter_count *const count = component->count;
-	struct counter_synapse *const synapse = component->synapse;
-	size_t action_index;
-	enum counter_synapse_action action;
-
-	err = counter->ops->action_get(counter, count, synapse, &action_index);
-	if (err)
-		return err;
-
-	synapse->action = action_index;
-
-	action = synapse->actions_list[action_index];
-	return sprintf(buf, "%s\n", counter_synapse_action_str[action]);
-}
-
-static ssize_t counter_action_store(struct device *dev,
-				    struct device_attribute *attr,
-				    const char *buf, size_t len)
-{
-	const struct counter_device_attr *const devattr = to_counter_attr(attr);
-	const struct counter_action_unit *const component = devattr->component;
-	struct counter_synapse *const synapse = component->synapse;
-	size_t action_index;
-	const size_t num_actions = synapse->num_actions;
-	enum counter_synapse_action action;
-	int err;
-	struct counter_device *const counter = dev_get_drvdata(dev);
-	struct counter_count *const count = component->count;
-
-	/* Find requested action mode */
-	for (action_index = 0; action_index < num_actions; action_index++) {
-		action = synapse->actions_list[action_index];
-		if (sysfs_streq(buf, counter_synapse_action_str[action]))
-			break;
-	}
-	/* If requested action mode not found */
-	if (action_index >= num_actions)
-		return -EINVAL;
-
-	err = counter->ops->action_set(counter, count, synapse, action_index);
-	if (err)
-		return err;
-
-	synapse->action = action_index;
-
-	return len;
-}
-
-struct counter_action_avail_unit {
-	const enum counter_synapse_action *actions_list;
-	size_t num_actions;
-};
-
-static ssize_t counter_synapse_action_available_show(struct device *dev,
-	struct device_attribute *attr, char *buf)
-{
-	const struct counter_device_attr *const devattr = to_counter_attr(attr);
-	const struct counter_action_avail_unit *const component = devattr->component;
-	size_t i;
-	enum counter_synapse_action action;
-	ssize_t len = 0;
-
-	for (i = 0; i < component->num_actions; i++) {
-		action = component->actions_list[i];
-		len += sprintf(buf + len, "%s\n",
-			       counter_synapse_action_str[action]);
-	}
-
-	return len;
-}
-
-static int counter_synapses_register(
-	struct counter_device_attr_group *const group,
-	const struct counter_device *const counter,
-	struct counter_count *const count, const char *const count_attr_name)
-{
-	size_t i;
-	struct counter_synapse *synapse;
-	const char *prefix;
-	struct counter_action_unit *action_comp;
-	struct counter_attr_parm parm;
-	int err;
-	struct counter_action_avail_unit *avail_comp;
-
-	/* Register each Synapse */
-	for (i = 0; i < count->num_synapses; i++) {
-		synapse = count->synapses + i;
-
-		/* Generate attribute prefix */
-		prefix = kasprintf(GFP_KERNEL, "signal%d_",
-				   synapse->signal->id);
-		if (!prefix) {
-			err = -ENOMEM;
-			goto err_free_attr_list;
-		}
-
-		/* Allocate action attribute component */
-		action_comp = kmalloc(sizeof(*action_comp), GFP_KERNEL);
-		if (!action_comp) {
-			err = -ENOMEM;
-			goto err_free_prefix;
-		}
-		action_comp->synapse = synapse;
-		action_comp->count = count;
-
-		/* Create action attribute */
-		parm.group = group;
-		parm.prefix = prefix;
-		parm.name = "action";
-		parm.show = (counter->ops->action_get) ? counter_action_show : NULL;
-		parm.store = (counter->ops->action_set) ? counter_action_store : NULL;
-		parm.component = action_comp;
-		err = counter_attribute_create(&parm);
-		if (err) {
-			kfree(action_comp);
-			goto err_free_prefix;
-		}
-
-		/* Allocate action available attribute component */
-		avail_comp = kmalloc(sizeof(*avail_comp), GFP_KERNEL);
-		if (!avail_comp) {
-			err = -ENOMEM;
-			goto err_free_prefix;
-		}
-		avail_comp->actions_list = synapse->actions_list;
-		avail_comp->num_actions = synapse->num_actions;
-
-		/* Create action_available attribute */
-		parm.group = group;
-		parm.prefix = prefix;
-		parm.name = "action_available";
-		parm.show = counter_synapse_action_available_show;
-		parm.store = NULL;
-		parm.component = avail_comp;
-		err = counter_attribute_create(&parm);
-		if (err) {
-			kfree(avail_comp);
-			goto err_free_prefix;
-		}
-
-		kfree(prefix);
-	}
-
-	return 0;
-
-err_free_prefix:
-	kfree(prefix);
-err_free_attr_list:
-	counter_device_attr_list_free(&group->attr_list);
-	return err;
-}
-
-struct counter_count_unit {
-	struct counter_count *count;
-};
-
-static ssize_t counter_count_show(struct device *dev,
-				  struct device_attribute *attr,
-				  char *buf)
-{
-	struct counter_device *const counter = dev_get_drvdata(dev);
-	const struct counter_device_attr *const devattr = to_counter_attr(attr);
-	const struct counter_count_unit *const component = devattr->component;
-	struct counter_count *const count = component->count;
-	int err;
-	unsigned long val;
-
-	err = counter->ops->count_read(counter, count, &val);
-	if (err)
-		return err;
-
-	return sprintf(buf, "%lu\n", val);
-}
-
-static ssize_t counter_count_store(struct device *dev,
-				   struct device_attribute *attr,
-				   const char *buf, size_t len)
-{
-	struct counter_device *const counter = dev_get_drvdata(dev);
-	const struct counter_device_attr *const devattr = to_counter_attr(attr);
-	const struct counter_count_unit *const component = devattr->component;
-	struct counter_count *const count = component->count;
-	int err;
-	unsigned long val;
-
-	err = kstrtoul(buf, 0, &val);
-	if (err)
-		return err;
-
-	err = counter->ops->count_write(counter, count, val);
-	if (err)
-		return err;
-
-	return len;
-}
-
-static const char *const counter_function_str[] = {
-	[COUNTER_FUNCTION_INCREASE] = "increase",
-	[COUNTER_FUNCTION_DECREASE] = "decrease",
-	[COUNTER_FUNCTION_PULSE_DIRECTION] = "pulse-direction",
-	[COUNTER_FUNCTION_QUADRATURE_X1_A] = "quadrature x1 a",
-	[COUNTER_FUNCTION_QUADRATURE_X1_B] = "quadrature x1 b",
-	[COUNTER_FUNCTION_QUADRATURE_X2_A] = "quadrature x2 a",
-	[COUNTER_FUNCTION_QUADRATURE_X2_B] = "quadrature x2 b",
-	[COUNTER_FUNCTION_QUADRATURE_X4] = "quadrature x4"
-};
-
-static ssize_t counter_function_show(struct device *dev,
-				     struct device_attribute *attr, char *buf)
-{
-	int err;
-	struct counter_device *const counter = dev_get_drvdata(dev);
-	const struct counter_device_attr *const devattr = to_counter_attr(attr);
-	const struct counter_count_unit *const component = devattr->component;
-	struct counter_count *const count = component->count;
-	size_t func_index;
-	enum counter_function function;
-
-	err = counter->ops->function_get(counter, count, &func_index);
-	if (err)
-		return err;
-
-	count->function = func_index;
-
-	function = count->functions_list[func_index];
-	return sprintf(buf, "%s\n", counter_function_str[function]);
-}
-
-static ssize_t counter_function_store(struct device *dev,
-				      struct device_attribute *attr,
-				      const char *buf, size_t len)
-{
-	const struct counter_device_attr *const devattr = to_counter_attr(attr);
-	const struct counter_count_unit *const component = devattr->component;
-	struct counter_count *const count = component->count;
-	const size_t num_functions = count->num_functions;
-	size_t func_index;
-	enum counter_function function;
-	int err;
-	struct counter_device *const counter = dev_get_drvdata(dev);
-
-	/* Find requested Count function mode */
-	for (func_index = 0; func_index < num_functions; func_index++) {
-		function = count->functions_list[func_index];
-		if (sysfs_streq(buf, counter_function_str[function]))
-			break;
-	}
-	/* Return error if requested Count function mode not found */
-	if (func_index >= num_functions)
-		return -EINVAL;
-
-	err = counter->ops->function_set(counter, count, func_index);
-	if (err)
-		return err;
-
-	count->function = func_index;
-
-	return len;
-}
-
-struct counter_count_ext_unit {
-	struct counter_count *count;
-	const struct counter_count_ext *ext;
-};
-
-static ssize_t counter_count_ext_show(struct device *dev,
-				      struct device_attribute *attr, char *buf)
-{
-	const struct counter_device_attr *const devattr = to_counter_attr(attr);
-	const struct counter_count_ext_unit *const comp = devattr->component;
-	const struct counter_count_ext *const ext = comp->ext;
-
-	return ext->read(dev_get_drvdata(dev), comp->count, ext->priv, buf);
-}
-
-static ssize_t counter_count_ext_store(struct device *dev,
-				       struct device_attribute *attr,
-				       const char *buf, size_t len)
-{
-	const struct counter_device_attr *const devattr = to_counter_attr(attr);
-	const struct counter_count_ext_unit *const comp = devattr->component;
-	const struct counter_count_ext *const ext = comp->ext;
-
-	return ext->write(dev_get_drvdata(dev), comp->count, ext->priv, buf,
-		len);
-}
-
-static int counter_count_ext_register(
-	struct counter_device_attr_group *const group,
-	struct counter_count *const count)
-{
-	size_t i;
-	const struct counter_count_ext *ext;
-	struct counter_count_ext_unit *count_ext_comp;
-	struct counter_attr_parm parm;
-	int err;
-
-	/* Create an attribute for each extension */
-	for (i = 0 ; i < count->num_ext; i++) {
-		ext = count->ext + i;
-
-		/* Allocate count_ext attribute component */
-		count_ext_comp = kmalloc(sizeof(*count_ext_comp), GFP_KERNEL);
-		if (!count_ext_comp) {
-			err = -ENOMEM;
-			goto err_free_attr_list;
-		}
-		count_ext_comp->count = count;
-		count_ext_comp->ext = ext;
-
-		/* Allocate count_ext attribute */
-		parm.group = group;
-		parm.prefix = "";
-		parm.name = ext->name;
-		parm.show = (ext->read) ? counter_count_ext_show : NULL;
-		parm.store = (ext->write) ? counter_count_ext_store : NULL;
-		parm.component = count_ext_comp;
-		err = counter_attribute_create(&parm);
-		if (err) {
-			kfree(count_ext_comp);
-			goto err_free_attr_list;
-		}
-	}
-
-	return 0;
-
-err_free_attr_list:
-	counter_device_attr_list_free(&group->attr_list);
-	return err;
-}
-
-struct counter_func_avail_unit {
-	const enum counter_function *functions_list;
-	size_t num_functions;
-};
-
-static ssize_t counter_function_available_show(struct device *dev,
-	struct device_attribute *attr, char *buf)
-{
-	const struct counter_device_attr *const devattr = to_counter_attr(attr);
-	const struct counter_func_avail_unit *const component = devattr->component;
-	const enum counter_function *const func_list = component->functions_list;
-	const size_t num_functions = component->num_functions;
-	size_t i;
-	enum counter_function function;
-	ssize_t len = 0;
-
-	for (i = 0; i < num_functions; i++) {
-		function = func_list[i];
-		len += sprintf(buf + len, "%s\n",
-			       counter_function_str[function]);
-	}
-
-	return len;
-}
-
-static int counter_count_attributes_create(
-	struct counter_device_attr_group *const group,
-	const struct counter_device *const counter,
-	struct counter_count *const count)
-{
-	struct counter_count_unit *count_comp;
-	struct counter_attr_parm parm;
-	int err;
-	struct counter_count_unit *func_comp;
-	struct counter_func_avail_unit *avail_comp;
-
-	/* Allocate count attribute component */
-	count_comp = kmalloc(sizeof(*count_comp), GFP_KERNEL);
-	if (!count_comp)
-		return -ENOMEM;
-	count_comp->count = count;
-
-	/* Create main Count attribute */
-	parm.group = group;
-	parm.prefix = "";
-	parm.name = "count";
-	parm.show = (counter->ops->count_read) ? counter_count_show : NULL;
-	parm.store = (counter->ops->count_write) ? counter_count_store : NULL;
-	parm.component = count_comp;
-	err = counter_attribute_create(&parm);
-	if (err) {
-		kfree(count_comp);
-		return err;
-	}
-
-	/* Allocate function attribute component */
-	func_comp = kmalloc(sizeof(*func_comp), GFP_KERNEL);
-	if (!func_comp) {
-		err = -ENOMEM;
-		goto err_free_attr_list;
-	}
-	func_comp->count = count;
-
-	/* Create Count function attribute */
-	parm.group = group;
-	parm.prefix = "";
-	parm.name = "function";
-	parm.show = (counter->ops->function_get) ? counter_function_show : NULL;
-	parm.store = (counter->ops->function_set) ? counter_function_store : NULL;
-	parm.component = func_comp;
-	err = counter_attribute_create(&parm);
-	if (err) {
-		kfree(func_comp);
-		goto err_free_attr_list;
-	}
-
-	/* Allocate function available attribute component */
-	avail_comp = kmalloc(sizeof(*avail_comp), GFP_KERNEL);
-	if (!avail_comp) {
-		err = -ENOMEM;
-		goto err_free_attr_list;
-	}
-	avail_comp->functions_list = count->functions_list;
-	avail_comp->num_functions = count->num_functions;
-
-	/* Create Count function_available attribute */
-	parm.group = group;
-	parm.prefix = "";
-	parm.name = "function_available";
-	parm.show = counter_function_available_show;
-	parm.store = NULL;
-	parm.component = avail_comp;
-	err = counter_attribute_create(&parm);
-	if (err) {
-		kfree(avail_comp);
-		goto err_free_attr_list;
-	}
-
-	/* Create Count name attribute */
-	err = counter_name_attribute_create(group, count->name);
-	if (err)
-		goto err_free_attr_list;
-
-	/* Register Count extension attributes */
-	err = counter_count_ext_register(group, count);
-	if (err)
-		goto err_free_attr_list;
-
-	return 0;
-
-err_free_attr_list:
-	counter_device_attr_list_free(&group->attr_list);
-	return err;
-}
-
-static int counter_counts_register(
-	struct counter_device_attr_group *const groups_list,
-	const struct counter_device *const counter)
-{
-	size_t i;
-	struct counter_count *count;
-	const char *name;
-	int err;
-
-	/* Register each Count */
-	for (i = 0; i < counter->num_counts; i++) {
-		count = counter->counts + i;
-
-		/* Generate Count attribute directory name */
-		name = kasprintf(GFP_KERNEL, "count%d", count->id);
-		if (!name) {
-			err = -ENOMEM;
-			goto err_free_attr_groups;
-		}
-		groups_list[i].attr_group.name = name;
-
-		/* Register the Synapses associated with each Count */
-		err = counter_synapses_register(groups_list + i, counter, count,
-						name);
-		if (err)
-			goto err_free_attr_groups;
-
-		/* Create all attributes associated with Count */
-		err = counter_count_attributes_create(groups_list + i, counter,
-						      count);
-		if (err)
-			goto err_free_attr_groups;
-	}
-
-	return 0;
-
-err_free_attr_groups:
-	do {
-		kfree(groups_list[i].attr_group.name);
-		counter_device_attr_list_free(&groups_list[i].attr_list);
-	} while (i--);
-	return err;
-}
-
-struct counter_size_unit {
-	size_t size;
-};
-
-static ssize_t counter_device_attr_size_show(struct device *dev,
-					     struct device_attribute *attr,
-					     char *buf)
-{
-	const struct counter_size_unit *const comp = to_counter_attr(attr)->component;
-
-	return sprintf(buf, "%zu\n", comp->size);
-}
-
-static int counter_size_attribute_create(
-	struct counter_device_attr_group *const group,
-	const size_t size, const char *const name)
-{
-	struct counter_size_unit *size_comp;
-	struct counter_attr_parm parm;
-	int err;
-
-	/* Allocate size attribute component */
-	size_comp = kmalloc(sizeof(*size_comp), GFP_KERNEL);
-	if (!size_comp)
-		return -ENOMEM;
-	size_comp->size = size;
-
-	parm.group = group;
-	parm.prefix = "";
-	parm.name = name;
-	parm.show = counter_device_attr_size_show;
-	parm.store = NULL;
-	parm.component = size_comp;
-	err = counter_attribute_create(&parm);
-	if (err)
-		goto err_free_size_comp;
-
-	return 0;
-
-err_free_size_comp:
-	kfree(size_comp);
-	return err;
-}
-
-struct counter_ext_unit {
-	const struct counter_device_ext *ext;
-};
-
-static ssize_t counter_device_ext_show(struct device *dev,
-				       struct device_attribute *attr, char *buf)
-{
-	const struct counter_device_attr *const devattr = to_counter_attr(attr);
-	const struct counter_ext_unit *const component = devattr->component;
-	const struct counter_device_ext *const ext = component->ext;
-
-	return ext->read(dev_get_drvdata(dev), ext->priv, buf);
-}
-
-static ssize_t counter_device_ext_store(struct device *dev,
-					struct device_attribute *attr,
-					const char *buf, size_t len)
-{
-	const struct counter_device_attr *const devattr = to_counter_attr(attr);
-	const struct counter_ext_unit *const component = devattr->component;
-	const struct counter_device_ext *const ext = component->ext;
-
-	return ext->write(dev_get_drvdata(dev), ext->priv, buf, len);
-}
-
-static int counter_device_ext_register(
-	struct counter_device_attr_group *const group,
-	struct counter_device *const counter)
-{
-	size_t i;
-	struct counter_ext_unit *ext_comp;
-	struct counter_attr_parm parm;
-	int err;
-
-	/* Create an attribute for each extension */
-	for (i = 0 ; i < counter->num_ext; i++) {
-		/* Allocate extension attribute component */
-		ext_comp = kmalloc(sizeof(*ext_comp), GFP_KERNEL);
-		if (!ext_comp) {
-			err = -ENOMEM;
-			goto err_free_attr_list;
-		}
-
-		ext_comp->ext = counter->ext + i;
-
-		/* Allocate extension attribute */
-		parm.group = group;
-		parm.prefix = "";
-		parm.name = counter->ext[i].name;
-		parm.show = (counter->ext[i].read) ? counter_device_ext_show : NULL;
-		parm.store = (counter->ext[i].write) ? counter_device_ext_store : NULL;
-		parm.component = ext_comp;
-		err = counter_attribute_create(&parm);
-		if (err) {
-			kfree(ext_comp);
-			goto err_free_attr_list;
-		}
-	}
-
-	return 0;
-
-err_free_attr_list:
-	counter_device_attr_list_free(&group->attr_list);
-	return err;
-}
-
-static int counter_global_attr_register(
-	struct counter_device_attr_group *const group,
-	struct counter_device *const counter)
-{
-	int err;
-
-	/* Create name attribute */
-	err = counter_name_attribute_create(group, counter->name);
-	if (err)
-		return err;
-
-	/* Create num_counts attribute */
-	err = counter_size_attribute_create(group, counter->num_counts,
-					    "num_counts");
-	if (err)
-		goto err_free_attr_list;
-
-	/* Create num_signals attribute */
-	err = counter_size_attribute_create(group, counter->num_signals,
-					    "num_signals");
-	if (err)
-		goto err_free_attr_list;
-
-	/* Register Counter device extension attributes */
-	err = counter_device_ext_register(group, counter);
-	if (err)
-		goto err_free_attr_list;
-
-	return 0;
-
-err_free_attr_list:
-	counter_device_attr_list_free(&group->attr_list);
-	return err;
-}
-
-static void counter_device_groups_list_free(
-	struct counter_device_attr_group *const groups_list,
-	const size_t num_groups)
-{
-	struct counter_device_attr_group *group;
-	size_t i;
-
-	/* loop through all attribute groups (signals, counts, global, etc.) */
-	for (i = 0; i < num_groups; i++) {
-		group = groups_list + i;
-
-		/* free all attribute group and associated attributes memory */
-		kfree(group->attr_group.name);
-		kfree(group->attr_group.attrs);
-		counter_device_attr_list_free(&group->attr_list);
-	}
-
-	kfree(groups_list);
-}
-
-static int counter_device_groups_list_prepare(
-	struct counter_device *const counter)
-{
-	const size_t total_num_groups =
-		counter->num_signals + counter->num_counts + 1;
-	struct counter_device_attr_group *groups_list;
-	size_t i;
-	int err;
-	size_t num_groups = 0;
-
-	/* Allocate space for attribute groups (signals, counts, and ext) */
-	groups_list = kcalloc(total_num_groups, sizeof(*groups_list),
-			      GFP_KERNEL);
-	if (!groups_list)
-		return -ENOMEM;
-
-	/* Initialize attribute lists */
-	for (i = 0; i < total_num_groups; i++)
-		INIT_LIST_HEAD(&groups_list[i].attr_list);
-
-	/* Register Signals */
-	err = counter_signals_register(groups_list, counter);
-	if (err)
-		goto err_free_groups_list;
-	num_groups += counter->num_signals;
-
-	/* Register Counts and respective Synapses */
-	err = counter_counts_register(groups_list + num_groups, counter);
-	if (err)
-		goto err_free_groups_list;
-	num_groups += counter->num_counts;
-
-	/* Register Counter global attributes */
-	err = counter_global_attr_register(groups_list + num_groups, counter);
-	if (err)
-		goto err_free_groups_list;
-	num_groups++;
-
-	/* Store groups_list in device_state */
-	counter->device_state->groups_list = groups_list;
-	counter->device_state->num_groups = num_groups;
-
-	return 0;
-
-err_free_groups_list:
-	counter_device_groups_list_free(groups_list, num_groups);
-	return err;
-}
-
-static int counter_device_groups_prepare(
-	struct counter_device_state *const device_state)
-{
-	size_t i, j;
-	struct counter_device_attr_group *group;
-	int err;
-	struct counter_device_attr *p;
-
-	/* Allocate attribute groups for association with device */
-	device_state->groups = kcalloc(device_state->num_groups + 1,
-				       sizeof(*device_state->groups),
-				       GFP_KERNEL);
-	if (!device_state->groups)
-		return -ENOMEM;
-
-	/* Prepare each group of attributes for association */
-	for (i = 0; i < device_state->num_groups; i++) {
-		group = device_state->groups_list + i;
-
-		/* Allocate space for attribute pointers in attribute group */
-		group->attr_group.attrs = kcalloc(group->num_attr + 1,
-			sizeof(*group->attr_group.attrs), GFP_KERNEL);
-		if (!group->attr_group.attrs) {
-			err = -ENOMEM;
-			goto err_free_groups;
-		}
-
-		/* Add attribute pointers to attribute group */
-		j = 0;
-		list_for_each_entry(p, &group->attr_list, l)
-			group->attr_group.attrs[j++] = &p->dev_attr.attr;
-
-		/* Group attributes in attribute group */
-		device_state->groups[i] = &group->attr_group;
-	}
-	/* Associate attributes with device */
-	device_state->dev.groups = device_state->groups;
-
-	return 0;
-
-err_free_groups:
-	do {
-		group = device_state->groups_list + i;
-		kfree(group->attr_group.attrs);
-		group->attr_group.attrs = NULL;
-	} while (i--);
-	kfree(device_state->groups);
-	return err;
-}
-
-/* Provides a unique ID for each counter device */
-static DEFINE_IDA(counter_ida);
-
-static void counter_device_release(struct device *dev)
-{
-	struct counter_device *const counter = dev_get_drvdata(dev);
-	struct counter_device_state *const device_state = counter->device_state;
-
-	kfree(device_state->groups);
-	counter_device_groups_list_free(device_state->groups_list,
-					device_state->num_groups);
-	ida_simple_remove(&counter_ida, device_state->id);
-	kfree(device_state);
-}
-
-static struct device_type counter_device_type = {
-	.name = "counter_device",
-	.release = counter_device_release
-};
-
-static struct bus_type counter_bus_type = {
-	.name = "counter"
-};
-
-/**
- * counter_register - register Counter to the system
- * @counter:	pointer to Counter to register
- *
- * This function registers a Counter to the system. A sysfs "counter" directory
- * will be created and populated with sysfs attributes correlating with the
- * Counter Signals, Synapses, and Counts respectively.
- */
-int counter_register(struct counter_device *const counter)
-{
-	struct counter_device_state *device_state;
-	int err;
-
-	/* Allocate internal state container for Counter device */
-	device_state = kzalloc(sizeof(*device_state), GFP_KERNEL);
-	if (!device_state)
-		return -ENOMEM;
-	counter->device_state = device_state;
-
-	/* Acquire unique ID */
-	device_state->id = ida_simple_get(&counter_ida, 0, 0, GFP_KERNEL);
-	if (device_state->id < 0) {
-		err = device_state->id;
-		goto err_free_device_state;
-	}
-
-	/* Configure device structure for Counter */
-	device_state->dev.type = &counter_device_type;
-	device_state->dev.bus = &counter_bus_type;
-	if (counter->parent) {
-		device_state->dev.parent = counter->parent;
-		device_state->dev.of_node = counter->parent->of_node;
-	}
-	dev_set_name(&device_state->dev, "counter%d", device_state->id);
-	device_initialize(&device_state->dev);
-	dev_set_drvdata(&device_state->dev, counter);
-
-	/* Prepare device attributes */
-	err = counter_device_groups_list_prepare(counter);
-	if (err)
-		goto err_free_id;
-
-	/* Organize device attributes to groups and match to device */
-	err = counter_device_groups_prepare(device_state);
-	if (err)
-		goto err_free_groups_list;
-
-	/* Add device to system */
-	err = device_add(&device_state->dev);
-	if (err)
-		goto err_free_groups;
-
-	return 0;
-
-err_free_groups:
-	kfree(device_state->groups);
-err_free_groups_list:
-	counter_device_groups_list_free(device_state->groups_list,
-					device_state->num_groups);
-err_free_id:
-	ida_simple_remove(&counter_ida, device_state->id);
-err_free_device_state:
-	kfree(device_state);
-	return err;
-}
-EXPORT_SYMBOL_GPL(counter_register);
-
-/**
- * counter_unregister - unregister Counter from the system
- * @counter:	pointer to Counter to unregister
- *
- * The Counter is unregistered from the system; all allocated memory is freed.
- */
-void counter_unregister(struct counter_device *const counter)
-{
-	if (counter)
-		device_del(&counter->device_state->dev);
-}
-EXPORT_SYMBOL_GPL(counter_unregister);
-
-static void devm_counter_unreg(struct device *dev, void *res)
-{
-	counter_unregister(*(struct counter_device **)res);
-}
-
-/**
- * devm_counter_register - Resource-managed counter_register
- * @dev:	device to allocate counter_device for
- * @counter:	pointer to Counter to register
- *
- * Managed counter_register. The Counter registered with this function is
- * automatically unregistered on driver detach. This function calls
- * counter_register internally. Refer to that function for more information.
- *
- * If an Counter registered with this function needs to be unregistered
- * separately, devm_counter_unregister must be used.
- *
- * RETURNS:
- * 0 on success, negative error number on failure.
- */
-int devm_counter_register(struct device *dev,
-			  struct counter_device *const counter)
-{
-	struct counter_device **ptr;
-	int ret;
-
-	ptr = devres_alloc(devm_counter_unreg, sizeof(*ptr), GFP_KERNEL);
-	if (!ptr)
-		return -ENOMEM;
-
-	ret = counter_register(counter);
-	if (!ret) {
-		*ptr = counter;
-		devres_add(dev, ptr);
-	} else {
-		devres_free(ptr);
-	}
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(devm_counter_register);
-
-static int devm_counter_match(struct device *dev, void *res, void *data)
-{
-	struct counter_device **r = res;
-
-	if (!r || !*r) {
-		WARN_ON(!r || !*r);
-		return 0;
-	}
-
-	return *r == data;
-}
-
-/**
- * devm_counter_unregister - Resource-managed counter_unregister
- * @dev:	device this counter_device belongs to
- * @counter:	pointer to Counter associated with the device
- *
- * Unregister Counter registered with devm_counter_register.
- */
-void devm_counter_unregister(struct device *dev,
-			     struct counter_device *const counter)
-{
-	int rc;
-
-	rc = devres_release(dev, devm_counter_unreg, devm_counter_match,
-			    counter);
-	WARN_ON(rc);
-}
-EXPORT_SYMBOL_GPL(devm_counter_unregister);
-
-static int __init counter_init(void)
-{
-	return bus_register(&counter_bus_type);
-}
-
-static void __exit counter_exit(void)
-{
-	bus_unregister(&counter_bus_type);
-}
-
-subsys_initcall(counter_init);
-module_exit(counter_exit);
-
-MODULE_AUTHOR("William Breathitt Gray <vilhelm.gray@gmail.com>");
-MODULE_DESCRIPTION("Generic Counter interface");
-MODULE_LICENSE("GPL v2");
diff --git a/drivers/counter/ftm-quaddec.c b/drivers/counter/ftm-quaddec.c
index 53c15f84909b..5ef0478709cd 100644
--- a/drivers/counter/ftm-quaddec.c
+++ b/drivers/counter/ftm-quaddec.c
@@ -14,6 +14,7 @@
 #include <linux/mutex.h>
 #include <linux/counter.h>
 #include <linux/bitfield.h>
+#include <linux/types.h>
 
 #define FTM_FIELD_UPDATE(ftm, offset, mask, val)			\
 	({								\
@@ -115,8 +116,7 @@ static void ftm_quaddec_disable(void *ftm)
 }
 
 static int ftm_quaddec_get_prescaler(struct counter_device *counter,
-				     struct counter_count *count,
-				     size_t *cnt_mode)
+				     struct counter_count *count, u32 *cnt_mode)
 {
 	struct ftm_quaddec *ftm = counter->priv;
 	uint32_t scflags;
@@ -129,8 +129,7 @@ static int ftm_quaddec_get_prescaler(struct counter_device *counter,
 }
 
 static int ftm_quaddec_set_prescaler(struct counter_device *counter,
-				     struct counter_count *count,
-				     size_t cnt_mode)
+				     struct counter_count *count, u32 cnt_mode)
 {
 	struct ftm_quaddec *ftm = counter->priv;
 
@@ -151,33 +150,17 @@ static const char * const ftm_quaddec_prescaler[] = {
 	"1", "2", "4", "8", "16", "32", "64", "128"
 };
 
-static struct counter_count_enum_ext ftm_quaddec_prescaler_enum = {
-	.items = ftm_quaddec_prescaler,
-	.num_items = ARRAY_SIZE(ftm_quaddec_prescaler),
-	.get = ftm_quaddec_get_prescaler,
-	.set = ftm_quaddec_set_prescaler
-};
-
-enum ftm_quaddec_synapse_action {
-	FTM_QUADDEC_SYNAPSE_ACTION_BOTH_EDGES,
-};
-
 static const enum counter_synapse_action ftm_quaddec_synapse_actions[] = {
-	[FTM_QUADDEC_SYNAPSE_ACTION_BOTH_EDGES] =
 	COUNTER_SYNAPSE_ACTION_BOTH_EDGES
 };
 
-enum ftm_quaddec_count_function {
-	FTM_QUADDEC_COUNT_ENCODER_MODE_1,
-};
-
 static const enum counter_function ftm_quaddec_count_functions[] = {
-	[FTM_QUADDEC_COUNT_ENCODER_MODE_1] = COUNTER_FUNCTION_QUADRATURE_X4
+	COUNTER_FUNCTION_QUADRATURE_X4
 };
 
 static int ftm_quaddec_count_read(struct counter_device *counter,
 				  struct counter_count *count,
-				  unsigned long *val)
+				  u64 *val)
 {
 	struct ftm_quaddec *const ftm = counter->priv;
 	uint32_t cntval;
@@ -191,7 +174,7 @@ static int ftm_quaddec_count_read(struct counter_device *counter,
 
 static int ftm_quaddec_count_write(struct counter_device *counter,
 				   struct counter_count *count,
-				   const unsigned long val)
+				   const u64 val)
 {
 	struct ftm_quaddec *const ftm = counter->priv;
 
@@ -205,21 +188,21 @@ static int ftm_quaddec_count_write(struct counter_device *counter,
 	return 0;
 }
 
-static int ftm_quaddec_count_function_get(struct counter_device *counter,
-					  struct counter_count *count,
-					  size_t *function)
+static int ftm_quaddec_count_function_read(struct counter_device *counter,
+					   struct counter_count *count,
+					   enum counter_function *function)
 {
-	*function = FTM_QUADDEC_COUNT_ENCODER_MODE_1;
+	*function = COUNTER_FUNCTION_QUADRATURE_X4;
 
 	return 0;
 }
 
-static int ftm_quaddec_action_get(struct counter_device *counter,
-				  struct counter_count *count,
-				  struct counter_synapse *synapse,
-				  size_t *action)
+static int ftm_quaddec_action_read(struct counter_device *counter,
+				   struct counter_count *count,
+				   struct counter_synapse *synapse,
+				   enum counter_synapse_action *action)
 {
-	*action = FTM_QUADDEC_SYNAPSE_ACTION_BOTH_EDGES;
+	*action = COUNTER_SYNAPSE_ACTION_BOTH_EDGES;
 
 	return 0;
 }
@@ -227,8 +210,8 @@ static int ftm_quaddec_action_get(struct counter_device *counter,
 static const struct counter_ops ftm_quaddec_cnt_ops = {
 	.count_read = ftm_quaddec_count_read,
 	.count_write = ftm_quaddec_count_write,
-	.function_get = ftm_quaddec_count_function_get,
-	.action_get = ftm_quaddec_action_get,
+	.function_read = ftm_quaddec_count_function_read,
+	.action_read = ftm_quaddec_action_read,
 };
 
 static struct counter_signal ftm_quaddec_signals[] = {
@@ -255,9 +238,12 @@ static struct counter_synapse ftm_quaddec_count_synapses[] = {
 	}
 };
 
-static const struct counter_count_ext ftm_quaddec_count_ext[] = {
-	COUNTER_COUNT_ENUM("prescaler", &ftm_quaddec_prescaler_enum),
-	COUNTER_COUNT_ENUM_AVAILABLE("prescaler", &ftm_quaddec_prescaler_enum),
+static DEFINE_COUNTER_ENUM(ftm_quaddec_prescaler_enum, ftm_quaddec_prescaler);
+
+static struct counter_comp ftm_quaddec_count_ext[] = {
+	COUNTER_COMP_COUNT_ENUM("prescaler", ftm_quaddec_get_prescaler,
+				ftm_quaddec_set_prescaler,
+				ftm_quaddec_prescaler_enum),
 };
 
 static struct counter_count ftm_quaddec_counts = {
diff --git a/drivers/counter/intel-qep.c b/drivers/counter/intel-qep.c
index 8a6847d5fb2b..0924d16de6e2 100644
--- a/drivers/counter/intel-qep.c
+++ b/drivers/counter/intel-qep.c
@@ -62,13 +62,6 @@
 
 #define INTEL_QEP_CLK_PERIOD_NS		10
 
-#define INTEL_QEP_COUNTER_EXT_RW(_name)				\
-{								\
-	.name = #_name,						\
-	.read = _name##_read,					\
-	.write = _name##_write,					\
-}
-
 struct intel_qep {
 	struct counter_device counter;
 	struct mutex lock;
@@ -114,8 +107,7 @@ static void intel_qep_init(struct intel_qep *qep)
 }
 
 static int intel_qep_count_read(struct counter_device *counter,
-				struct counter_count *count,
-				unsigned long *val)
+				struct counter_count *count, u64 *val)
 {
 	struct intel_qep *const qep = counter->priv;
 
@@ -130,11 +122,11 @@ static const enum counter_function intel_qep_count_functions[] = {
 	COUNTER_FUNCTION_QUADRATURE_X4,
 };
 
-static int intel_qep_function_get(struct counter_device *counter,
-				  struct counter_count *count,
-				  size_t *function)
+static int intel_qep_function_read(struct counter_device *counter,
+				   struct counter_count *count,
+				   enum counter_function *function)
 {
-	*function = 0;
+	*function = COUNTER_FUNCTION_QUADRATURE_X4;
 
 	return 0;
 }
@@ -143,19 +135,19 @@ static const enum counter_synapse_action intel_qep_synapse_actions[] = {
 	COUNTER_SYNAPSE_ACTION_BOTH_EDGES,
 };
 
-static int intel_qep_action_get(struct counter_device *counter,
-				struct counter_count *count,
-				struct counter_synapse *synapse,
-				size_t *action)
+static int intel_qep_action_read(struct counter_device *counter,
+				 struct counter_count *count,
+				 struct counter_synapse *synapse,
+				 enum counter_synapse_action *action)
 {
-	*action = 0;
+	*action = COUNTER_SYNAPSE_ACTION_BOTH_EDGES;
 	return 0;
 }
 
 static const struct counter_ops intel_qep_counter_ops = {
 	.count_read = intel_qep_count_read,
-	.function_get = intel_qep_function_get,
-	.action_get = intel_qep_action_get,
+	.function_read = intel_qep_function_read,
+	.action_read = intel_qep_action_read,
 };
 
 #define INTEL_QEP_SIGNAL(_id, _name) {				\
@@ -181,31 +173,27 @@ static struct counter_synapse intel_qep_count_synapses[] = {
 	INTEL_QEP_SYNAPSE(2),
 };
 
-static ssize_t ceiling_read(struct counter_device *counter,
-			    struct counter_count *count,
-			    void *priv, char *buf)
+static int intel_qep_ceiling_read(struct counter_device *counter,
+				  struct counter_count *count, u64 *ceiling)
 {
 	struct intel_qep *qep = counter->priv;
-	u32 reg;
 
 	pm_runtime_get_sync(qep->dev);
-	reg = intel_qep_readl(qep, INTEL_QEPMAX);
+	*ceiling = intel_qep_readl(qep, INTEL_QEPMAX);
 	pm_runtime_put(qep->dev);
 
-	return sysfs_emit(buf, "%u\n", reg);
+	return 0;
 }
 
-static ssize_t ceiling_write(struct counter_device *counter,
-			     struct counter_count *count,
-			     void *priv, const char *buf, size_t len)
+static int intel_qep_ceiling_write(struct counter_device *counter,
+				   struct counter_count *count, u64 max)
 {
 	struct intel_qep *qep = counter->priv;
-	u32 max;
-	int ret;
+	int ret = 0;
 
-	ret = kstrtou32(buf, 0, &max);
-	if (ret < 0)
-		return ret;
+	/* Intel QEP ceiling configuration only supports 32-bit values */
+	if (max != (u32)max)
+		return -ERANGE;
 
 	mutex_lock(&qep->lock);
 	if (qep->enabled) {
@@ -216,34 +204,28 @@ static ssize_t ceiling_write(struct counter_device *counter,
 	pm_runtime_get_sync(qep->dev);
 	intel_qep_writel(qep, INTEL_QEPMAX, max);
 	pm_runtime_put(qep->dev);
-	ret = len;
 
 out:
 	mutex_unlock(&qep->lock);
 	return ret;
 }
 
-static ssize_t enable_read(struct counter_device *counter,
-			   struct counter_count *count,
-			   void *priv, char *buf)
+static int intel_qep_enable_read(struct counter_device *counter,
+				 struct counter_count *count, u8 *enable)
 {
 	struct intel_qep *qep = counter->priv;
 
-	return sysfs_emit(buf, "%u\n", qep->enabled);
+	*enable = qep->enabled;
+
+	return 0;
 }
 
-static ssize_t enable_write(struct counter_device *counter,
-			    struct counter_count *count,
-			    void *priv, const char *buf, size_t len)
+static int intel_qep_enable_write(struct counter_device *counter,
+				  struct counter_count *count, u8 val)
 {
 	struct intel_qep *qep = counter->priv;
 	u32 reg;
-	bool val, changed;
-	int ret;
-
-	ret = kstrtobool(buf, &val);
-	if (ret)
-		return ret;
+	bool changed;
 
 	mutex_lock(&qep->lock);
 	changed = val ^ qep->enabled;
@@ -267,12 +249,12 @@ static ssize_t enable_write(struct counter_device *counter,
 
 out:
 	mutex_unlock(&qep->lock);
-	return len;
+	return 0;
 }
 
-static ssize_t spike_filter_ns_read(struct counter_device *counter,
-				    struct counter_count *count,
-				    void *priv, char *buf)
+static int intel_qep_spike_filter_ns_read(struct counter_device *counter,
+					  struct counter_count *count,
+					  u64 *length)
 {
 	struct intel_qep *qep = counter->priv;
 	u32 reg;
@@ -281,33 +263,31 @@ static ssize_t spike_filter_ns_read(struct counter_device *counter,
 	reg = intel_qep_readl(qep, INTEL_QEPCON);
 	if (!(reg & INTEL_QEPCON_FLT_EN)) {
 		pm_runtime_put(qep->dev);
-		return sysfs_emit(buf, "0\n");
+		return 0;
 	}
 	reg = INTEL_QEPFLT_MAX_COUNT(intel_qep_readl(qep, INTEL_QEPFLT));
 	pm_runtime_put(qep->dev);
 
-	return sysfs_emit(buf, "%u\n", (reg + 2) * INTEL_QEP_CLK_PERIOD_NS);
+	*length = (reg + 2) * INTEL_QEP_CLK_PERIOD_NS;
+
+	return 0;
 }
 
-static ssize_t spike_filter_ns_write(struct counter_device *counter,
-				     struct counter_count *count,
-				     void *priv, const char *buf, size_t len)
+static int intel_qep_spike_filter_ns_write(struct counter_device *counter,
+					   struct counter_count *count,
+					   u64 length)
 {
 	struct intel_qep *qep = counter->priv;
-	u32 reg, length;
+	u32 reg;
 	bool enable;
-	int ret;
-
-	ret = kstrtou32(buf, 0, &length);
-	if (ret < 0)
-		return ret;
+	int ret = 0;
 
 	/*
 	 * Spike filter length is (MAX_COUNT + 2) clock periods.
 	 * Disable filter when userspace writes 0, enable for valid
 	 * nanoseconds values and error out otherwise.
 	 */
-	length /= INTEL_QEP_CLK_PERIOD_NS;
+	do_div(length, INTEL_QEP_CLK_PERIOD_NS);
 	if (length == 0) {
 		enable = false;
 		length = 0;
@@ -336,16 +316,15 @@ static ssize_t spike_filter_ns_write(struct counter_device *counter,
 	intel_qep_writel(qep, INTEL_QEPFLT, length);
 	intel_qep_writel(qep, INTEL_QEPCON, reg);
 	pm_runtime_put(qep->dev);
-	ret = len;
 
 out:
 	mutex_unlock(&qep->lock);
 	return ret;
 }
 
-static ssize_t preset_enable_read(struct counter_device *counter,
-				  struct counter_count *count,
-				  void *priv, char *buf)
+static int intel_qep_preset_enable_read(struct counter_device *counter,
+					struct counter_count *count,
+					u8 *preset_enable)
 {
 	struct intel_qep *qep = counter->priv;
 	u32 reg;
@@ -353,21 +332,18 @@ static ssize_t preset_enable_read(struct counter_device *counter,
 	pm_runtime_get_sync(qep->dev);
 	reg = intel_qep_readl(qep, INTEL_QEPCON);
 	pm_runtime_put(qep->dev);
-	return sysfs_emit(buf, "%u\n", !(reg & INTEL_QEPCON_COUNT_RST_MODE));
+
+	*preset_enable = !(reg & INTEL_QEPCON_COUNT_RST_MODE);
+
+	return 0;
 }
 
-static ssize_t preset_enable_write(struct counter_device *counter,
-				   struct counter_count *count,
-				   void *priv, const char *buf, size_t len)
+static int intel_qep_preset_enable_write(struct counter_device *counter,
+					 struct counter_count *count, u8 val)
 {
 	struct intel_qep *qep = counter->priv;
 	u32 reg;
-	bool val;
-	int ret;
-
-	ret = kstrtobool(buf, &val);
-	if (ret)
-		return ret;
+	int ret = 0;
 
 	mutex_lock(&qep->lock);
 	if (qep->enabled) {
@@ -384,7 +360,6 @@ static ssize_t preset_enable_write(struct counter_device *counter,
 
 	intel_qep_writel(qep, INTEL_QEPCON, reg);
 	pm_runtime_put(qep->dev);
-	ret = len;
 
 out:
 	mutex_unlock(&qep->lock);
@@ -392,11 +367,14 @@ static ssize_t preset_enable_write(struct counter_device *counter,
 	return ret;
 }
 
-static const struct counter_count_ext intel_qep_count_ext[] = {
-	INTEL_QEP_COUNTER_EXT_RW(ceiling),
-	INTEL_QEP_COUNTER_EXT_RW(enable),
-	INTEL_QEP_COUNTER_EXT_RW(spike_filter_ns),
-	INTEL_QEP_COUNTER_EXT_RW(preset_enable)
+static struct counter_comp intel_qep_count_ext[] = {
+	COUNTER_COMP_ENABLE(intel_qep_enable_read, intel_qep_enable_write),
+	COUNTER_COMP_CEILING(intel_qep_ceiling_read, intel_qep_ceiling_write),
+	COUNTER_COMP_PRESET_ENABLE(intel_qep_preset_enable_read,
+				   intel_qep_preset_enable_write),
+	COUNTER_COMP_COUNT_U64("spike_filter_ns",
+			       intel_qep_spike_filter_ns_read,
+			       intel_qep_spike_filter_ns_write),
 };
 
 static struct counter_count intel_qep_counter_count[] = {
diff --git a/drivers/counter/interrupt-cnt.c b/drivers/counter/interrupt-cnt.c
index 1de4243db488..8514a87fcbee 100644
--- a/drivers/counter/interrupt-cnt.c
+++ b/drivers/counter/interrupt-cnt.c
@@ -10,6 +10,7 @@
 #include <linux/mod_devicetable.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
+#include <linux/types.h>
 
 #define INTERRUPT_CNT_NAME "interrupt-cnt"
 
@@ -33,30 +34,23 @@ static irqreturn_t interrupt_cnt_isr(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static ssize_t interrupt_cnt_enable_read(struct counter_device *counter,
-					 struct counter_count *count,
-					 void *private, char *buf)
+static int interrupt_cnt_enable_read(struct counter_device *counter,
+				     struct counter_count *count, u8 *enable)
 {
 	struct interrupt_cnt_priv *priv = counter->priv;
 
-	return sysfs_emit(buf, "%d\n", priv->enabled);
+	*enable = priv->enabled;
+
+	return 0;
 }
 
-static ssize_t interrupt_cnt_enable_write(struct counter_device *counter,
-					  struct counter_count *count,
-					  void *private, const char *buf,
-					  size_t len)
+static int interrupt_cnt_enable_write(struct counter_device *counter,
+				      struct counter_count *count, u8 enable)
 {
 	struct interrupt_cnt_priv *priv = counter->priv;
-	bool enable;
-	ssize_t ret;
-
-	ret = kstrtobool(buf, &enable);
-	if (ret)
-		return ret;
 
 	if (priv->enabled == enable)
-		return len;
+		return 0;
 
 	if (enable) {
 		priv->enabled = true;
@@ -66,33 +60,30 @@ static ssize_t interrupt_cnt_enable_write(struct counter_device *counter,
 		priv->enabled = false;
 	}
 
-	return len;
+	return 0;
 }
 
-static const struct counter_count_ext interrupt_cnt_ext[] = {
-	{
-		.name = "enable",
-		.read = interrupt_cnt_enable_read,
-		.write = interrupt_cnt_enable_write,
-	},
+static struct counter_comp interrupt_cnt_ext[] = {
+	COUNTER_COMP_ENABLE(interrupt_cnt_enable_read,
+			    interrupt_cnt_enable_write),
 };
 
 static const enum counter_synapse_action interrupt_cnt_synapse_actions[] = {
 	COUNTER_SYNAPSE_ACTION_RISING_EDGE,
 };
 
-static int interrupt_cnt_action_get(struct counter_device *counter,
-				    struct counter_count *count,
-				    struct counter_synapse *synapse,
-				    size_t *action)
+static int interrupt_cnt_action_read(struct counter_device *counter,
+				     struct counter_count *count,
+				     struct counter_synapse *synapse,
+				     enum counter_synapse_action *action)
 {
-	*action = 0;
+	*action = COUNTER_SYNAPSE_ACTION_RISING_EDGE;
 
 	return 0;
 }
 
 static int interrupt_cnt_read(struct counter_device *counter,
-			      struct counter_count *count, unsigned long *val)
+			      struct counter_count *count, u64 *val)
 {
 	struct interrupt_cnt_priv *priv = counter->priv;
 
@@ -102,8 +93,7 @@ static int interrupt_cnt_read(struct counter_device *counter,
 }
 
 static int interrupt_cnt_write(struct counter_device *counter,
-			       struct counter_count *count,
-			       const unsigned long val)
+			       struct counter_count *count, const u64 val)
 {
 	struct interrupt_cnt_priv *priv = counter->priv;
 
@@ -119,11 +109,11 @@ static const enum counter_function interrupt_cnt_functions[] = {
 	COUNTER_FUNCTION_INCREASE,
 };
 
-static int interrupt_cnt_function_get(struct counter_device *counter,
-				      struct counter_count *count,
-				      size_t *function)
+static int interrupt_cnt_function_read(struct counter_device *counter,
+				       struct counter_count *count,
+				       enum counter_function *function)
 {
-	*function = 0;
+	*function = COUNTER_FUNCTION_INCREASE;
 
 	return 0;
 }
@@ -148,10 +138,10 @@ static int interrupt_cnt_signal_read(struct counter_device *counter,
 }
 
 static const struct counter_ops interrupt_cnt_ops = {
-	.action_get = interrupt_cnt_action_get,
+	.action_read = interrupt_cnt_action_read,
 	.count_read = interrupt_cnt_read,
 	.count_write = interrupt_cnt_write,
-	.function_get = interrupt_cnt_function_get,
+	.function_read = interrupt_cnt_function_read,
 	.signal_read  = interrupt_cnt_signal_read,
 };
 
diff --git a/drivers/counter/microchip-tcb-capture.c b/drivers/counter/microchip-tcb-capture.c
index 22563dcded75..4edfe1f8fff7 100644
--- a/drivers/counter/microchip-tcb-capture.c
+++ b/drivers/counter/microchip-tcb-capture.c
@@ -31,28 +31,16 @@ struct mchp_tc_data {
 	int channel[2];
 };
 
-enum mchp_tc_count_function {
-	MCHP_TC_FUNCTION_INCREASE,
-	MCHP_TC_FUNCTION_QUADRATURE,
-};
-
 static const enum counter_function mchp_tc_count_functions[] = {
-	[MCHP_TC_FUNCTION_INCREASE] = COUNTER_FUNCTION_INCREASE,
-	[MCHP_TC_FUNCTION_QUADRATURE] = COUNTER_FUNCTION_QUADRATURE_X4,
-};
-
-enum mchp_tc_synapse_action {
-	MCHP_TC_SYNAPSE_ACTION_NONE = 0,
-	MCHP_TC_SYNAPSE_ACTION_RISING_EDGE,
-	MCHP_TC_SYNAPSE_ACTION_FALLING_EDGE,
-	MCHP_TC_SYNAPSE_ACTION_BOTH_EDGE
+	COUNTER_FUNCTION_INCREASE,
+	COUNTER_FUNCTION_QUADRATURE_X4,
 };
 
 static const enum counter_synapse_action mchp_tc_synapse_actions[] = {
-	[MCHP_TC_SYNAPSE_ACTION_NONE] = COUNTER_SYNAPSE_ACTION_NONE,
-	[MCHP_TC_SYNAPSE_ACTION_RISING_EDGE] = COUNTER_SYNAPSE_ACTION_RISING_EDGE,
-	[MCHP_TC_SYNAPSE_ACTION_FALLING_EDGE] = COUNTER_SYNAPSE_ACTION_FALLING_EDGE,
-	[MCHP_TC_SYNAPSE_ACTION_BOTH_EDGE] = COUNTER_SYNAPSE_ACTION_BOTH_EDGES,
+	COUNTER_SYNAPSE_ACTION_NONE,
+	COUNTER_SYNAPSE_ACTION_RISING_EDGE,
+	COUNTER_SYNAPSE_ACTION_FALLING_EDGE,
+	COUNTER_SYNAPSE_ACTION_BOTH_EDGES,
 };
 
 static struct counter_signal mchp_tc_count_signals[] = {
@@ -79,23 +67,23 @@ static struct counter_synapse mchp_tc_count_synapses[] = {
 	}
 };
 
-static int mchp_tc_count_function_get(struct counter_device *counter,
-				      struct counter_count *count,
-				      size_t *function)
+static int mchp_tc_count_function_read(struct counter_device *counter,
+				       struct counter_count *count,
+				       enum counter_function *function)
 {
 	struct mchp_tc_data *const priv = counter->priv;
 
 	if (priv->qdec_mode)
-		*function = MCHP_TC_FUNCTION_QUADRATURE;
+		*function = COUNTER_FUNCTION_QUADRATURE_X4;
 	else
-		*function = MCHP_TC_FUNCTION_INCREASE;
+		*function = COUNTER_FUNCTION_INCREASE;
 
 	return 0;
 }
 
-static int mchp_tc_count_function_set(struct counter_device *counter,
-				      struct counter_count *count,
-				      size_t function)
+static int mchp_tc_count_function_write(struct counter_device *counter,
+					struct counter_count *count,
+					enum counter_function function)
 {
 	struct mchp_tc_data *const priv = counter->priv;
 	u32 bmr, cmr;
@@ -107,7 +95,7 @@ static int mchp_tc_count_function_set(struct counter_device *counter,
 	cmr &= ~ATMEL_TC_WAVE;
 
 	switch (function) {
-	case MCHP_TC_FUNCTION_INCREASE:
+	case COUNTER_FUNCTION_INCREASE:
 		priv->qdec_mode = 0;
 		/* Set highest rate based on whether soc has gclk or not */
 		bmr &= ~(ATMEL_TC_QDEN | ATMEL_TC_POSEN);
@@ -119,7 +107,7 @@ static int mchp_tc_count_function_set(struct counter_device *counter,
 		cmr |=  ATMEL_TC_CMR_MASK;
 		cmr &= ~(ATMEL_TC_ABETRG | ATMEL_TC_XC0);
 		break;
-	case MCHP_TC_FUNCTION_QUADRATURE:
+	case COUNTER_FUNCTION_QUADRATURE_X4:
 		if (!priv->tc_cfg->has_qdec)
 			return -EINVAL;
 		/* In QDEC mode settings both channels 0 and 1 are required */
@@ -175,10 +163,10 @@ static int mchp_tc_count_signal_read(struct counter_device *counter,
 	return 0;
 }
 
-static int mchp_tc_count_action_get(struct counter_device *counter,
-				    struct counter_count *count,
-				    struct counter_synapse *synapse,
-				    size_t *action)
+static int mchp_tc_count_action_read(struct counter_device *counter,
+				     struct counter_count *count,
+				     struct counter_synapse *synapse,
+				     enum counter_synapse_action *action)
 {
 	struct mchp_tc_data *const priv = counter->priv;
 	u32 cmr;
@@ -198,26 +186,26 @@ static int mchp_tc_count_action_get(struct counter_device *counter,
 
 	switch (cmr & ATMEL_TC_ETRGEDG) {
 	default:
-		*action = MCHP_TC_SYNAPSE_ACTION_NONE;
+		*action = COUNTER_SYNAPSE_ACTION_NONE;
 		break;
 	case ATMEL_TC_ETRGEDG_RISING:
-		*action = MCHP_TC_SYNAPSE_ACTION_RISING_EDGE;
+		*action = COUNTER_SYNAPSE_ACTION_RISING_EDGE;
 		break;
 	case ATMEL_TC_ETRGEDG_FALLING:
-		*action = MCHP_TC_SYNAPSE_ACTION_FALLING_EDGE;
+		*action = COUNTER_SYNAPSE_ACTION_FALLING_EDGE;
 		break;
 	case ATMEL_TC_ETRGEDG_BOTH:
-		*action = MCHP_TC_SYNAPSE_ACTION_BOTH_EDGE;
+		*action = COUNTER_SYNAPSE_ACTION_BOTH_EDGES;
 		break;
 	}
 
 	return 0;
 }
 
-static int mchp_tc_count_action_set(struct counter_device *counter,
-				    struct counter_count *count,
-				    struct counter_synapse *synapse,
-				    size_t action)
+static int mchp_tc_count_action_write(struct counter_device *counter,
+				      struct counter_count *count,
+				      struct counter_synapse *synapse,
+				      enum counter_synapse_action action)
 {
 	struct mchp_tc_data *const priv = counter->priv;
 	u32 edge = ATMEL_TC_ETRGEDG_NONE;
@@ -227,16 +215,16 @@ static int mchp_tc_count_action_set(struct counter_device *counter,
 		return -EINVAL;
 
 	switch (action) {
-	case MCHP_TC_SYNAPSE_ACTION_NONE:
+	case COUNTER_SYNAPSE_ACTION_NONE:
 		edge = ATMEL_TC_ETRGEDG_NONE;
 		break;
-	case MCHP_TC_SYNAPSE_ACTION_RISING_EDGE:
+	case COUNTER_SYNAPSE_ACTION_RISING_EDGE:
 		edge = ATMEL_TC_ETRGEDG_RISING;
 		break;
-	case MCHP_TC_SYNAPSE_ACTION_FALLING_EDGE:
+	case COUNTER_SYNAPSE_ACTION_FALLING_EDGE:
 		edge = ATMEL_TC_ETRGEDG_FALLING;
 		break;
-	case MCHP_TC_SYNAPSE_ACTION_BOTH_EDGE:
+	case COUNTER_SYNAPSE_ACTION_BOTH_EDGES:
 		edge = ATMEL_TC_ETRGEDG_BOTH;
 		break;
 	default:
@@ -250,8 +238,7 @@ static int mchp_tc_count_action_set(struct counter_device *counter,
 }
 
 static int mchp_tc_count_read(struct counter_device *counter,
-			      struct counter_count *count,
-			      unsigned long *val)
+			      struct counter_count *count, u64 *val)
 {
 	struct mchp_tc_data *const priv = counter->priv;
 	u32 cnt;
@@ -274,12 +261,12 @@ static struct counter_count mchp_tc_counts[] = {
 };
 
 static const struct counter_ops mchp_tc_ops = {
-	.signal_read  = mchp_tc_count_signal_read,
-	.count_read   = mchp_tc_count_read,
-	.function_get = mchp_tc_count_function_get,
-	.function_set = mchp_tc_count_function_set,
-	.action_get   = mchp_tc_count_action_get,
-	.action_set   = mchp_tc_count_action_set
+	.signal_read    = mchp_tc_count_signal_read,
+	.count_read     = mchp_tc_count_read,
+	.function_read  = mchp_tc_count_function_read,
+	.function_write = mchp_tc_count_function_write,
+	.action_read    = mchp_tc_count_action_read,
+	.action_write   = mchp_tc_count_action_write
 };
 
 static const struct atmel_tcb_config tcb_rm9200_config = {
diff --git a/drivers/counter/stm32-lptimer-cnt.c b/drivers/counter/stm32-lptimer-cnt.c
index fa7f86cf0ea3..637b3f0b4fa3 100644
--- a/drivers/counter/stm32-lptimer-cnt.c
+++ b/drivers/counter/stm32-lptimer-cnt.c
@@ -17,6 +17,7 @@
 #include <linux/module.h>
 #include <linux/pinctrl/consumer.h>
 #include <linux/platform_device.h>
+#include <linux/types.h>
 
 struct stm32_lptim_cnt {
 	struct counter_device counter;
@@ -107,11 +108,7 @@ static int stm32_lptim_setup(struct stm32_lptim_cnt *priv, int enable)
 	return regmap_update_bits(priv->regmap, STM32_LPTIM_CFGR, mask, val);
 }
 
-/**
- * enum stm32_lptim_cnt_function - enumerates LPTimer counter & encoder modes
- * @STM32_LPTIM_COUNTER_INCREASE: up count on IN1 rising, falling or both edges
- * @STM32_LPTIM_ENCODER_BOTH_EDGE: count on both edges (IN1 & IN2 quadrature)
- *
+/*
  * In non-quadrature mode, device counts up on active edge.
  * In quadrature mode, encoder counting scenarios are as follows:
  * +---------+----------+--------------------+--------------------+
@@ -129,33 +126,20 @@ static int stm32_lptim_setup(struct stm32_lptim_cnt *priv, int enable)
  * | edges   | Low  ->  |   Up     |   Down  |   Down   |   Up    |
  * +---------+----------+----------+---------+----------+---------+
  */
-enum stm32_lptim_cnt_function {
-	STM32_LPTIM_COUNTER_INCREASE,
-	STM32_LPTIM_ENCODER_BOTH_EDGE,
-};
-
 static const enum counter_function stm32_lptim_cnt_functions[] = {
-	[STM32_LPTIM_COUNTER_INCREASE] = COUNTER_FUNCTION_INCREASE,
-	[STM32_LPTIM_ENCODER_BOTH_EDGE] = COUNTER_FUNCTION_QUADRATURE_X4,
-};
-
-enum stm32_lptim_synapse_action {
-	STM32_LPTIM_SYNAPSE_ACTION_RISING_EDGE,
-	STM32_LPTIM_SYNAPSE_ACTION_FALLING_EDGE,
-	STM32_LPTIM_SYNAPSE_ACTION_BOTH_EDGES,
-	STM32_LPTIM_SYNAPSE_ACTION_NONE,
+	COUNTER_FUNCTION_INCREASE,
+	COUNTER_FUNCTION_QUADRATURE_X4,
 };
 
 static const enum counter_synapse_action stm32_lptim_cnt_synapse_actions[] = {
-	/* Index must match with stm32_lptim_cnt_polarity[] (priv->polarity) */
-	[STM32_LPTIM_SYNAPSE_ACTION_RISING_EDGE] = COUNTER_SYNAPSE_ACTION_RISING_EDGE,
-	[STM32_LPTIM_SYNAPSE_ACTION_FALLING_EDGE] = COUNTER_SYNAPSE_ACTION_FALLING_EDGE,
-	[STM32_LPTIM_SYNAPSE_ACTION_BOTH_EDGES] = COUNTER_SYNAPSE_ACTION_BOTH_EDGES,
-	[STM32_LPTIM_SYNAPSE_ACTION_NONE] = COUNTER_SYNAPSE_ACTION_NONE,
+	COUNTER_SYNAPSE_ACTION_RISING_EDGE,
+	COUNTER_SYNAPSE_ACTION_FALLING_EDGE,
+	COUNTER_SYNAPSE_ACTION_BOTH_EDGES,
+	COUNTER_SYNAPSE_ACTION_NONE,
 };
 
 static int stm32_lptim_cnt_read(struct counter_device *counter,
-				struct counter_count *count, unsigned long *val)
+				struct counter_count *count, u64 *val)
 {
 	struct stm32_lptim_cnt *const priv = counter->priv;
 	u32 cnt;
@@ -170,28 +154,28 @@ static int stm32_lptim_cnt_read(struct counter_device *counter,
 	return 0;
 }
 
-static int stm32_lptim_cnt_function_get(struct counter_device *counter,
-					struct counter_count *count,
-					size_t *function)
+static int stm32_lptim_cnt_function_read(struct counter_device *counter,
+					 struct counter_count *count,
+					 enum counter_function *function)
 {
 	struct stm32_lptim_cnt *const priv = counter->priv;
 
 	if (!priv->quadrature_mode) {
-		*function = STM32_LPTIM_COUNTER_INCREASE;
+		*function = COUNTER_FUNCTION_INCREASE;
 		return 0;
 	}
 
-	if (priv->polarity == STM32_LPTIM_SYNAPSE_ACTION_BOTH_EDGES) {
-		*function = STM32_LPTIM_ENCODER_BOTH_EDGE;
+	if (priv->polarity == STM32_LPTIM_CKPOL_BOTH_EDGES) {
+		*function = COUNTER_FUNCTION_QUADRATURE_X4;
 		return 0;
 	}
 
 	return -EINVAL;
 }
 
-static int stm32_lptim_cnt_function_set(struct counter_device *counter,
-					struct counter_count *count,
-					size_t function)
+static int stm32_lptim_cnt_function_write(struct counter_device *counter,
+					  struct counter_count *count,
+					  enum counter_function function)
 {
 	struct stm32_lptim_cnt *const priv = counter->priv;
 
@@ -199,12 +183,12 @@ static int stm32_lptim_cnt_function_set(struct counter_device *counter,
 		return -EBUSY;
 
 	switch (function) {
-	case STM32_LPTIM_COUNTER_INCREASE:
+	case COUNTER_FUNCTION_INCREASE:
 		priv->quadrature_mode = 0;
 		return 0;
-	case STM32_LPTIM_ENCODER_BOTH_EDGE:
+	case COUNTER_FUNCTION_QUADRATURE_X4:
 		priv->quadrature_mode = 1;
-		priv->polarity = STM32_LPTIM_SYNAPSE_ACTION_BOTH_EDGES;
+		priv->polarity = STM32_LPTIM_CKPOL_BOTH_EDGES;
 		return 0;
 	default:
 		/* should never reach this path */
@@ -212,9 +196,9 @@ static int stm32_lptim_cnt_function_set(struct counter_device *counter,
 	}
 }
 
-static ssize_t stm32_lptim_cnt_enable_read(struct counter_device *counter,
-					   struct counter_count *count,
-					   void *private, char *buf)
+static int stm32_lptim_cnt_enable_read(struct counter_device *counter,
+				       struct counter_count *count,
+				       u8 *enable)
 {
 	struct stm32_lptim_cnt *const priv = counter->priv;
 	int ret;
@@ -223,22 +207,18 @@ static ssize_t stm32_lptim_cnt_enable_read(struct counter_device *counter,
 	if (ret < 0)
 		return ret;
 
-	return scnprintf(buf, PAGE_SIZE, "%u\n", ret);
+	*enable = ret;
+
+	return 0;
 }
 
-static ssize_t stm32_lptim_cnt_enable_write(struct counter_device *counter,
-					    struct counter_count *count,
-					    void *private,
-					    const char *buf, size_t len)
+static int stm32_lptim_cnt_enable_write(struct counter_device *counter,
+					struct counter_count *count,
+					u8 enable)
 {
 	struct stm32_lptim_cnt *const priv = counter->priv;
-	bool enable;
 	int ret;
 
-	ret = kstrtobool(buf, &enable);
-	if (ret)
-		return ret;
-
 	/* Check nobody uses the timer, or already disabled/enabled */
 	ret = stm32_lptim_is_enabled(priv);
 	if ((ret < 0) || (!ret && !enable))
@@ -254,78 +234,81 @@ static ssize_t stm32_lptim_cnt_enable_write(struct counter_device *counter,
 	if (ret)
 		return ret;
 
-	return len;
+	return 0;
 }
 
-static ssize_t stm32_lptim_cnt_ceiling_read(struct counter_device *counter,
-					    struct counter_count *count,
-					    void *private, char *buf)
+static int stm32_lptim_cnt_ceiling_read(struct counter_device *counter,
+					struct counter_count *count,
+					u64 *ceiling)
 {
 	struct stm32_lptim_cnt *const priv = counter->priv;
 
-	return snprintf(buf, PAGE_SIZE, "%u\n", priv->ceiling);
+	*ceiling = priv->ceiling;
+
+	return 0;
 }
 
-static ssize_t stm32_lptim_cnt_ceiling_write(struct counter_device *counter,
-					     struct counter_count *count,
-					     void *private,
-					     const char *buf, size_t len)
+static int stm32_lptim_cnt_ceiling_write(struct counter_device *counter,
+					 struct counter_count *count,
+					 u64 ceiling)
 {
 	struct stm32_lptim_cnt *const priv = counter->priv;
-	unsigned int ceiling;
-	int ret;
 
 	if (stm32_lptim_is_enabled(priv))
 		return -EBUSY;
 
-	ret = kstrtouint(buf, 0, &ceiling);
-	if (ret)
-		return ret;
-
 	if (ceiling > STM32_LPTIM_MAX_ARR)
 		return -ERANGE;
 
 	priv->ceiling = ceiling;
 
-	return len;
+	return 0;
 }
 
-static const struct counter_count_ext stm32_lptim_cnt_ext[] = {
-	{
-		.name = "enable",
-		.read = stm32_lptim_cnt_enable_read,
-		.write = stm32_lptim_cnt_enable_write
-	},
-	{
-		.name = "ceiling",
-		.read = stm32_lptim_cnt_ceiling_read,
-		.write = stm32_lptim_cnt_ceiling_write
-	},
+static struct counter_comp stm32_lptim_cnt_ext[] = {
+	COUNTER_COMP_ENABLE(stm32_lptim_cnt_enable_read,
+			    stm32_lptim_cnt_enable_write),
+	COUNTER_COMP_CEILING(stm32_lptim_cnt_ceiling_read,
+			     stm32_lptim_cnt_ceiling_write),
 };
 
-static int stm32_lptim_cnt_action_get(struct counter_device *counter,
-				      struct counter_count *count,
-				      struct counter_synapse *synapse,
-				      size_t *action)
+static int stm32_lptim_cnt_action_read(struct counter_device *counter,
+				       struct counter_count *count,
+				       struct counter_synapse *synapse,
+				       enum counter_synapse_action *action)
 {
 	struct stm32_lptim_cnt *const priv = counter->priv;
-	size_t function;
+	enum counter_function function;
 	int err;
 
-	err = stm32_lptim_cnt_function_get(counter, count, &function);
+	err = stm32_lptim_cnt_function_read(counter, count, &function);
 	if (err)
 		return err;
 
 	switch (function) {
-	case STM32_LPTIM_COUNTER_INCREASE:
+	case COUNTER_FUNCTION_INCREASE:
 		/* LP Timer acts as up-counter on input 1 */
-		if (synapse->signal->id == count->synapses[0].signal->id)
-			*action = priv->polarity;
-		else
-			*action = STM32_LPTIM_SYNAPSE_ACTION_NONE;
-		return 0;
-	case STM32_LPTIM_ENCODER_BOTH_EDGE:
-		*action = priv->polarity;
+		if (synapse->signal->id != count->synapses[0].signal->id) {
+			*action = COUNTER_SYNAPSE_ACTION_NONE;
+			return 0;
+		}
+
+		switch (priv->polarity) {
+		case STM32_LPTIM_CKPOL_RISING_EDGE:
+			*action = COUNTER_SYNAPSE_ACTION_RISING_EDGE;
+			return 0;
+		case STM32_LPTIM_CKPOL_FALLING_EDGE:
+			*action = COUNTER_SYNAPSE_ACTION_FALLING_EDGE;
+			return 0;
+		case STM32_LPTIM_CKPOL_BOTH_EDGES:
+			*action = COUNTER_SYNAPSE_ACTION_BOTH_EDGES;
+			return 0;
+		default:
+			/* should never reach this path */
+			return -EINVAL;
+		}
+	case COUNTER_FUNCTION_QUADRATURE_X4:
+		*action = COUNTER_SYNAPSE_ACTION_BOTH_EDGES;
 		return 0;
 	default:
 		/* should never reach this path */
@@ -333,43 +316,48 @@ static int stm32_lptim_cnt_action_get(struct counter_device *counter,
 	}
 }
 
-static int stm32_lptim_cnt_action_set(struct counter_device *counter,
-				      struct counter_count *count,
-				      struct counter_synapse *synapse,
-				      size_t action)
+static int stm32_lptim_cnt_action_write(struct counter_device *counter,
+					struct counter_count *count,
+					struct counter_synapse *synapse,
+					enum counter_synapse_action action)
 {
 	struct stm32_lptim_cnt *const priv = counter->priv;
-	size_t function;
+	enum counter_function function;
 	int err;
 
 	if (stm32_lptim_is_enabled(priv))
 		return -EBUSY;
 
-	err = stm32_lptim_cnt_function_get(counter, count, &function);
+	err = stm32_lptim_cnt_function_read(counter, count, &function);
 	if (err)
 		return err;
 
 	/* only set polarity when in counter mode (on input 1) */
-	if (function == STM32_LPTIM_COUNTER_INCREASE
-	    && synapse->signal->id == count->synapses[0].signal->id) {
-		switch (action) {
-		case STM32_LPTIM_SYNAPSE_ACTION_RISING_EDGE:
-		case STM32_LPTIM_SYNAPSE_ACTION_FALLING_EDGE:
-		case STM32_LPTIM_SYNAPSE_ACTION_BOTH_EDGES:
-			priv->polarity = action;
-			return 0;
-		}
-	}
+	if (function != COUNTER_FUNCTION_INCREASE
+	    || synapse->signal->id != count->synapses[0].signal->id)
+		return -EINVAL;
 
-	return -EINVAL;
+	switch (action) {
+	case COUNTER_SYNAPSE_ACTION_RISING_EDGE:
+		priv->polarity = STM32_LPTIM_CKPOL_RISING_EDGE;
+		return 0;
+	case COUNTER_SYNAPSE_ACTION_FALLING_EDGE:
+		priv->polarity = STM32_LPTIM_CKPOL_FALLING_EDGE;
+		return 0;
+	case COUNTER_SYNAPSE_ACTION_BOTH_EDGES:
+		priv->polarity = STM32_LPTIM_CKPOL_BOTH_EDGES;
+		return 0;
+	default:
+		return -EINVAL;
+	}
 }
 
 static const struct counter_ops stm32_lptim_cnt_ops = {
 	.count_read = stm32_lptim_cnt_read,
-	.function_get = stm32_lptim_cnt_function_get,
-	.function_set = stm32_lptim_cnt_function_set,
-	.action_get = stm32_lptim_cnt_action_get,
-	.action_set = stm32_lptim_cnt_action_set,
+	.function_read = stm32_lptim_cnt_function_read,
+	.function_write = stm32_lptim_cnt_function_write,
+	.action_read = stm32_lptim_cnt_action_read,
+	.action_write = stm32_lptim_cnt_action_write,
 };
 
 static struct counter_signal stm32_lptim_cnt_signals[] = {
diff --git a/drivers/counter/stm32-timer-cnt.c b/drivers/counter/stm32-timer-cnt.c
index 3fb0debd7425..0546e932db0c 100644
--- a/drivers/counter/stm32-timer-cnt.c
+++ b/drivers/counter/stm32-timer-cnt.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/pinctrl/consumer.h>
 #include <linux/platform_device.h>
+#include <linux/types.h>
 
 #define TIM_CCMR_CCXS	(BIT(8) | BIT(0))
 #define TIM_CCMR_MASK	(TIM_CCMR_CC1S | TIM_CCMR_CC2S | \
@@ -36,29 +37,15 @@ struct stm32_timer_cnt {
 	struct stm32_timer_regs bak;
 };
 
-/**
- * enum stm32_count_function - enumerates stm32 timer counter encoder modes
- * @STM32_COUNT_SLAVE_MODE_DISABLED: counts on internal clock when CEN=1
- * @STM32_COUNT_ENCODER_MODE_1: counts TI1FP1 edges, depending on TI2FP2 level
- * @STM32_COUNT_ENCODER_MODE_2: counts TI2FP2 edges, depending on TI1FP1 level
- * @STM32_COUNT_ENCODER_MODE_3: counts on both TI1FP1 and TI2FP2 edges
- */
-enum stm32_count_function {
-	STM32_COUNT_SLAVE_MODE_DISABLED,
-	STM32_COUNT_ENCODER_MODE_1,
-	STM32_COUNT_ENCODER_MODE_2,
-	STM32_COUNT_ENCODER_MODE_3,
-};
-
 static const enum counter_function stm32_count_functions[] = {
-	[STM32_COUNT_SLAVE_MODE_DISABLED] = COUNTER_FUNCTION_INCREASE,
-	[STM32_COUNT_ENCODER_MODE_1] = COUNTER_FUNCTION_QUADRATURE_X2_A,
-	[STM32_COUNT_ENCODER_MODE_2] = COUNTER_FUNCTION_QUADRATURE_X2_B,
-	[STM32_COUNT_ENCODER_MODE_3] = COUNTER_FUNCTION_QUADRATURE_X4,
+	COUNTER_FUNCTION_INCREASE,
+	COUNTER_FUNCTION_QUADRATURE_X2_A,
+	COUNTER_FUNCTION_QUADRATURE_X2_B,
+	COUNTER_FUNCTION_QUADRATURE_X4,
 };
 
 static int stm32_count_read(struct counter_device *counter,
-			    struct counter_count *count, unsigned long *val)
+			    struct counter_count *count, u64 *val)
 {
 	struct stm32_timer_cnt *const priv = counter->priv;
 	u32 cnt;
@@ -70,8 +57,7 @@ static int stm32_count_read(struct counter_device *counter,
 }
 
 static int stm32_count_write(struct counter_device *counter,
-			     struct counter_count *count,
-			     const unsigned long val)
+			     struct counter_count *count, const u64 val)
 {
 	struct stm32_timer_cnt *const priv = counter->priv;
 	u32 ceiling;
@@ -83,9 +69,9 @@ static int stm32_count_write(struct counter_device *counter,
 	return regmap_write(priv->regmap, TIM_CNT, val);
 }
 
-static int stm32_count_function_get(struct counter_device *counter,
-				    struct counter_count *count,
-				    size_t *function)
+static int stm32_count_function_read(struct counter_device *counter,
+				     struct counter_count *count,
+				     enum counter_function *function)
 {
 	struct stm32_timer_cnt *const priv = counter->priv;
 	u32 smcr;
@@ -93,42 +79,42 @@ static int stm32_count_function_get(struct counter_device *counter,
 	regmap_read(priv->regmap, TIM_SMCR, &smcr);
 
 	switch (smcr & TIM_SMCR_SMS) {
-	case 0:
-		*function = STM32_COUNT_SLAVE_MODE_DISABLED;
+	case TIM_SMCR_SMS_SLAVE_MODE_DISABLED:
+		*function = COUNTER_FUNCTION_INCREASE;
 		return 0;
-	case 1:
-		*function = STM32_COUNT_ENCODER_MODE_1;
+	case TIM_SMCR_SMS_ENCODER_MODE_1:
+		*function = COUNTER_FUNCTION_QUADRATURE_X2_A;
 		return 0;
-	case 2:
-		*function = STM32_COUNT_ENCODER_MODE_2;
+	case TIM_SMCR_SMS_ENCODER_MODE_2:
+		*function = COUNTER_FUNCTION_QUADRATURE_X2_B;
 		return 0;
-	case 3:
-		*function = STM32_COUNT_ENCODER_MODE_3;
+	case TIM_SMCR_SMS_ENCODER_MODE_3:
+		*function = COUNTER_FUNCTION_QUADRATURE_X4;
 		return 0;
 	default:
 		return -EINVAL;
 	}
 }
 
-static int stm32_count_function_set(struct counter_device *counter,
-				    struct counter_count *count,
-				    size_t function)
+static int stm32_count_function_write(struct counter_device *counter,
+				      struct counter_count *count,
+				      enum counter_function function)
 {
 	struct stm32_timer_cnt *const priv = counter->priv;
 	u32 cr1, sms;
 
 	switch (function) {
-	case STM32_COUNT_SLAVE_MODE_DISABLED:
-		sms = 0;
+	case COUNTER_FUNCTION_INCREASE:
+		sms = TIM_SMCR_SMS_SLAVE_MODE_DISABLED;
 		break;
-	case STM32_COUNT_ENCODER_MODE_1:
-		sms = 1;
+	case COUNTER_FUNCTION_QUADRATURE_X2_A:
+		sms = TIM_SMCR_SMS_ENCODER_MODE_1;
 		break;
-	case STM32_COUNT_ENCODER_MODE_2:
-		sms = 2;
+	case COUNTER_FUNCTION_QUADRATURE_X2_B:
+		sms = TIM_SMCR_SMS_ENCODER_MODE_2;
 		break;
-	case STM32_COUNT_ENCODER_MODE_3:
-		sms = 3;
+	case COUNTER_FUNCTION_QUADRATURE_X4:
+		sms = TIM_SMCR_SMS_ENCODER_MODE_3;
 		break;
 	default:
 		return -EINVAL;
@@ -150,44 +136,37 @@ static int stm32_count_function_set(struct counter_device *counter,
 	return 0;
 }
 
-static ssize_t stm32_count_direction_read(struct counter_device *counter,
+static int stm32_count_direction_read(struct counter_device *counter,
 				      struct counter_count *count,
-				      void *private, char *buf)
+				      enum counter_count_direction *direction)
 {
 	struct stm32_timer_cnt *const priv = counter->priv;
-	const char *direction;
 	u32 cr1;
 
 	regmap_read(priv->regmap, TIM_CR1, &cr1);
-	direction = (cr1 & TIM_CR1_DIR) ? "backward" : "forward";
+	*direction = (cr1 & TIM_CR1_DIR) ? COUNTER_COUNT_DIRECTION_BACKWARD :
+		COUNTER_COUNT_DIRECTION_FORWARD;
 
-	return scnprintf(buf, PAGE_SIZE, "%s\n", direction);
+	return 0;
 }
 
-static ssize_t stm32_count_ceiling_read(struct counter_device *counter,
-					struct counter_count *count,
-					void *private, char *buf)
+static int stm32_count_ceiling_read(struct counter_device *counter,
+				    struct counter_count *count, u64 *ceiling)
 {
 	struct stm32_timer_cnt *const priv = counter->priv;
 	u32 arr;
 
 	regmap_read(priv->regmap, TIM_ARR, &arr);
 
-	return snprintf(buf, PAGE_SIZE, "%u\n", arr);
+	*ceiling = arr;
+
+	return 0;
 }
 
-static ssize_t stm32_count_ceiling_write(struct counter_device *counter,
-					 struct counter_count *count,
-					 void *private,
-					 const char *buf, size_t len)
+static int stm32_count_ceiling_write(struct counter_device *counter,
+				     struct counter_count *count, u64 ceiling)
 {
 	struct stm32_timer_cnt *const priv = counter->priv;
-	unsigned int ceiling;
-	int ret;
-
-	ret = kstrtouint(buf, 0, &ceiling);
-	if (ret)
-		return ret;
 
 	if (ceiling > priv->max_arr)
 		return -ERANGE;
@@ -196,34 +175,27 @@ static ssize_t stm32_count_ceiling_write(struct counter_device *counter,
 	regmap_update_bits(priv->regmap, TIM_CR1, TIM_CR1_ARPE, 0);
 	regmap_write(priv->regmap, TIM_ARR, ceiling);
 
-	return len;
+	return 0;
 }
 
-static ssize_t stm32_count_enable_read(struct counter_device *counter,
-				       struct counter_count *count,
-				       void *private, char *buf)
+static int stm32_count_enable_read(struct counter_device *counter,
+				   struct counter_count *count, u8 *enable)
 {
 	struct stm32_timer_cnt *const priv = counter->priv;
 	u32 cr1;
 
 	regmap_read(priv->regmap, TIM_CR1, &cr1);
 
-	return scnprintf(buf, PAGE_SIZE, "%d\n", (bool)(cr1 & TIM_CR1_CEN));
+	*enable = cr1 & TIM_CR1_CEN;
+
+	return 0;
 }
 
-static ssize_t stm32_count_enable_write(struct counter_device *counter,
-					struct counter_count *count,
-					void *private,
-					const char *buf, size_t len)
+static int stm32_count_enable_write(struct counter_device *counter,
+				    struct counter_count *count, u8 enable)
 {
 	struct stm32_timer_cnt *const priv = counter->priv;
-	int err;
 	u32 cr1;
-	bool enable;
-
-	err = kstrtobool(buf, &enable);
-	if (err)
-		return err;
 
 	if (enable) {
 		regmap_read(priv->regmap, TIM_CR1, &cr1);
@@ -242,70 +214,55 @@ static ssize_t stm32_count_enable_write(struct counter_device *counter,
 	/* Keep enabled state to properly handle low power states */
 	priv->enabled = enable;
 
-	return len;
+	return 0;
 }
 
-static const struct counter_count_ext stm32_count_ext[] = {
-	{
-		.name = "direction",
-		.read = stm32_count_direction_read,
-	},
-	{
-		.name = "enable",
-		.read = stm32_count_enable_read,
-		.write = stm32_count_enable_write
-	},
-	{
-		.name = "ceiling",
-		.read = stm32_count_ceiling_read,
-		.write = stm32_count_ceiling_write
-	},
-};
-
-enum stm32_synapse_action {
-	STM32_SYNAPSE_ACTION_NONE,
-	STM32_SYNAPSE_ACTION_BOTH_EDGES
+static struct counter_comp stm32_count_ext[] = {
+	COUNTER_COMP_DIRECTION(stm32_count_direction_read),
+	COUNTER_COMP_ENABLE(stm32_count_enable_read, stm32_count_enable_write),
+	COUNTER_COMP_CEILING(stm32_count_ceiling_read,
+			     stm32_count_ceiling_write),
 };
 
 static const enum counter_synapse_action stm32_synapse_actions[] = {
-	[STM32_SYNAPSE_ACTION_NONE] = COUNTER_SYNAPSE_ACTION_NONE,
-	[STM32_SYNAPSE_ACTION_BOTH_EDGES] = COUNTER_SYNAPSE_ACTION_BOTH_EDGES
+	COUNTER_SYNAPSE_ACTION_NONE,
+	COUNTER_SYNAPSE_ACTION_BOTH_EDGES
 };
 
-static int stm32_action_get(struct counter_device *counter,
-			    struct counter_count *count,
-			    struct counter_synapse *synapse,
-			    size_t *action)
+static int stm32_action_read(struct counter_device *counter,
+			     struct counter_count *count,
+			     struct counter_synapse *synapse,
+			     enum counter_synapse_action *action)
 {
-	size_t function;
+	enum counter_function function;
 	int err;
 
-	err = stm32_count_function_get(counter, count, &function);
+	err = stm32_count_function_read(counter, count, &function);
 	if (err)
 		return err;
 
 	switch (function) {
-	case STM32_COUNT_SLAVE_MODE_DISABLED:
+	case COUNTER_FUNCTION_INCREASE:
 		/* counts on internal clock when CEN=1 */
-		*action = STM32_SYNAPSE_ACTION_NONE;
+		*action = COUNTER_SYNAPSE_ACTION_NONE;
 		return 0;
-	case STM32_COUNT_ENCODER_MODE_1:
+	case COUNTER_FUNCTION_QUADRATURE_X2_A:
 		/* counts up/down on TI1FP1 edge depending on TI2FP2 level */
 		if (synapse->signal->id == count->synapses[0].signal->id)
-			*action = STM32_SYNAPSE_ACTION_BOTH_EDGES;
+			*action = COUNTER_SYNAPSE_ACTION_BOTH_EDGES;
 		else
-			*action = STM32_SYNAPSE_ACTION_NONE;
+			*action = COUNTER_SYNAPSE_ACTION_NONE;
 		return 0;
-	case STM32_COUNT_ENCODER_MODE_2:
+	case COUNTER_FUNCTION_QUADRATURE_X2_B:
 		/* counts up/down on TI2FP2 edge depending on TI1FP1 level */
 		if (synapse->signal->id == count->synapses[1].signal->id)
-			*action = STM32_SYNAPSE_ACTION_BOTH_EDGES;
+			*action = COUNTER_SYNAPSE_ACTION_BOTH_EDGES;
 		else
-			*action = STM32_SYNAPSE_ACTION_NONE;
+			*action = COUNTER_SYNAPSE_ACTION_NONE;
 		return 0;
-	case STM32_COUNT_ENCODER_MODE_3:
+	case COUNTER_FUNCTION_QUADRATURE_X4:
 		/* counts up/down on both TI1FP1 and TI2FP2 edges */
-		*action = STM32_SYNAPSE_ACTION_BOTH_EDGES;
+		*action = COUNTER_SYNAPSE_ACTION_BOTH_EDGES;
 		return 0;
 	default:
 		return -EINVAL;
@@ -315,9 +272,9 @@ static int stm32_action_get(struct counter_device *counter,
 static const struct counter_ops stm32_timer_cnt_ops = {
 	.count_read = stm32_count_read,
 	.count_write = stm32_count_write,
-	.function_get = stm32_count_function_get,
-	.function_set = stm32_count_function_set,
-	.action_get = stm32_action_get,
+	.function_read = stm32_count_function_read,
+	.function_write = stm32_count_function_write,
+	.action_read = stm32_action_read,
 };
 
 static struct counter_signal stm32_signals[] = {
diff --git a/drivers/counter/ti-eqep.c b/drivers/counter/ti-eqep.c
index 94fe58bb3eab..09817c953f9a 100644
--- a/drivers/counter/ti-eqep.c
+++ b/drivers/counter/ti-eqep.c
@@ -13,6 +13,7 @@
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/regmap.h>
+#include <linux/types.h>
 
 /* 32-bit registers */
 #define QPOSCNT		0x0
@@ -73,19 +74,13 @@ enum {
 };
 
 /* Position Counter Input Modes */
-enum {
+enum ti_eqep_count_func {
 	TI_EQEP_COUNT_FUNC_QUAD_COUNT,
 	TI_EQEP_COUNT_FUNC_DIR_COUNT,
 	TI_EQEP_COUNT_FUNC_UP_COUNT,
 	TI_EQEP_COUNT_FUNC_DOWN_COUNT,
 };
 
-enum {
-	TI_EQEP_SYNAPSE_ACTION_BOTH_EDGES,
-	TI_EQEP_SYNAPSE_ACTION_RISING_EDGE,
-	TI_EQEP_SYNAPSE_ACTION_NONE,
-};
-
 struct ti_eqep_cnt {
 	struct counter_device counter;
 	struct regmap *regmap32;
@@ -93,7 +88,7 @@ struct ti_eqep_cnt {
 };
 
 static int ti_eqep_count_read(struct counter_device *counter,
-			      struct counter_count *count, unsigned long *val)
+			      struct counter_count *count, u64 *val)
 {
 	struct ti_eqep_cnt *priv = counter->priv;
 	u32 cnt;
@@ -105,7 +100,7 @@ static int ti_eqep_count_read(struct counter_device *counter,
 }
 
 static int ti_eqep_count_write(struct counter_device *counter,
-			       struct counter_count *count, unsigned long val)
+			       struct counter_count *count, u64 val)
 {
 	struct ti_eqep_cnt *priv = counter->priv;
 	u32 max;
@@ -117,64 +112,100 @@ static int ti_eqep_count_write(struct counter_device *counter,
 	return regmap_write(priv->regmap32, QPOSCNT, val);
 }
 
-static int ti_eqep_function_get(struct counter_device *counter,
-				struct counter_count *count, size_t *function)
+static int ti_eqep_function_read(struct counter_device *counter,
+				 struct counter_count *count,
+				 enum counter_function *function)
 {
 	struct ti_eqep_cnt *priv = counter->priv;
 	u32 qdecctl;
 
 	regmap_read(priv->regmap16, QDECCTL, &qdecctl);
-	*function = (qdecctl & QDECCTL_QSRC) >> QDECCTL_QSRC_SHIFT;
+
+	switch ((qdecctl & QDECCTL_QSRC) >> QDECCTL_QSRC_SHIFT) {
+	case TI_EQEP_COUNT_FUNC_QUAD_COUNT:
+		*function = COUNTER_FUNCTION_QUADRATURE_X4;
+		break;
+	case TI_EQEP_COUNT_FUNC_DIR_COUNT:
+		*function = COUNTER_FUNCTION_PULSE_DIRECTION;
+		break;
+	case TI_EQEP_COUNT_FUNC_UP_COUNT:
+		*function = COUNTER_FUNCTION_INCREASE;
+		break;
+	case TI_EQEP_COUNT_FUNC_DOWN_COUNT:
+		*function = COUNTER_FUNCTION_DECREASE;
+		break;
+	}
 
 	return 0;
 }
 
-static int ti_eqep_function_set(struct counter_device *counter,
-				struct counter_count *count, size_t function)
+static int ti_eqep_function_write(struct counter_device *counter,
+				  struct counter_count *count,
+				  enum counter_function function)
 {
 	struct ti_eqep_cnt *priv = counter->priv;
+	enum ti_eqep_count_func qsrc;
+
+	switch (function) {
+	case COUNTER_FUNCTION_QUADRATURE_X4:
+		qsrc = TI_EQEP_COUNT_FUNC_QUAD_COUNT;
+		break;
+	case COUNTER_FUNCTION_PULSE_DIRECTION:
+		qsrc = TI_EQEP_COUNT_FUNC_DIR_COUNT;
+		break;
+	case COUNTER_FUNCTION_INCREASE:
+		qsrc = TI_EQEP_COUNT_FUNC_UP_COUNT;
+		break;
+	case COUNTER_FUNCTION_DECREASE:
+		qsrc = TI_EQEP_COUNT_FUNC_DOWN_COUNT;
+		break;
+	default:
+		/* should never reach this path */
+		return -EINVAL;
+	}
 
 	return regmap_write_bits(priv->regmap16, QDECCTL, QDECCTL_QSRC,
-				 function << QDECCTL_QSRC_SHIFT);
+				 qsrc << QDECCTL_QSRC_SHIFT);
 }
 
-static int ti_eqep_action_get(struct counter_device *counter,
-			      struct counter_count *count,
-			      struct counter_synapse *synapse, size_t *action)
+static int ti_eqep_action_read(struct counter_device *counter,
+			       struct counter_count *count,
+			       struct counter_synapse *synapse,
+			       enum counter_synapse_action *action)
 {
 	struct ti_eqep_cnt *priv = counter->priv;
-	size_t function;
+	enum counter_function function;
 	u32 qdecctl;
 	int err;
 
-	err = ti_eqep_function_get(counter, count, &function);
+	err = ti_eqep_function_read(counter, count, &function);
 	if (err)
 		return err;
 
 	switch (function) {
-	case TI_EQEP_COUNT_FUNC_QUAD_COUNT:
+	case COUNTER_FUNCTION_QUADRATURE_X4:
 		/* In quadrature mode, the rising and falling edge of both
 		 * QEPA and QEPB trigger QCLK.
 		 */
-		*action = TI_EQEP_SYNAPSE_ACTION_BOTH_EDGES;
+		*action = COUNTER_SYNAPSE_ACTION_BOTH_EDGES;
 		return 0;
-	case TI_EQEP_COUNT_FUNC_DIR_COUNT:
+	case COUNTER_FUNCTION_PULSE_DIRECTION:
 		/* In direction-count mode only rising edge of QEPA is counted
 		 * and QEPB gives direction.
 		 */
 		switch (synapse->signal->id) {
 		case TI_EQEP_SIGNAL_QEPA:
-			*action = TI_EQEP_SYNAPSE_ACTION_RISING_EDGE;
+			*action = COUNTER_SYNAPSE_ACTION_RISING_EDGE;
 			return 0;
 		case TI_EQEP_SIGNAL_QEPB:
-			*action = TI_EQEP_SYNAPSE_ACTION_NONE;
+			*action = COUNTER_SYNAPSE_ACTION_NONE;
 			return 0;
 		default:
 			/* should never reach this path */
 			return -EINVAL;
 		}
-	case TI_EQEP_COUNT_FUNC_UP_COUNT:
-	case TI_EQEP_COUNT_FUNC_DOWN_COUNT:
+	case COUNTER_FUNCTION_INCREASE:
+	case COUNTER_FUNCTION_DECREASE:
 		/* In up/down-count modes only QEPA is counted and QEPB is not
 		 * used.
 		 */
@@ -185,12 +216,12 @@ static int ti_eqep_action_get(struct counter_device *counter,
 				return err;
 
 			if (qdecctl & QDECCTL_XCR)
-				*action = TI_EQEP_SYNAPSE_ACTION_BOTH_EDGES;
+				*action = COUNTER_SYNAPSE_ACTION_BOTH_EDGES;
 			else
-				*action = TI_EQEP_SYNAPSE_ACTION_RISING_EDGE;
+				*action = COUNTER_SYNAPSE_ACTION_RISING_EDGE;
 			return 0;
 		case TI_EQEP_SIGNAL_QEPB:
-			*action = TI_EQEP_SYNAPSE_ACTION_NONE;
+			*action = COUNTER_SYNAPSE_ACTION_NONE;
 			return 0;
 		default:
 			/* should never reach this path */
@@ -205,82 +236,67 @@ static int ti_eqep_action_get(struct counter_device *counter,
 static const struct counter_ops ti_eqep_counter_ops = {
 	.count_read	= ti_eqep_count_read,
 	.count_write	= ti_eqep_count_write,
-	.function_get	= ti_eqep_function_get,
-	.function_set	= ti_eqep_function_set,
-	.action_get	= ti_eqep_action_get,
+	.function_read	= ti_eqep_function_read,
+	.function_write	= ti_eqep_function_write,
+	.action_read	= ti_eqep_action_read,
 };
 
-static ssize_t ti_eqep_position_ceiling_read(struct counter_device *counter,
-					     struct counter_count *count,
-					     void *ext_priv, char *buf)
+static int ti_eqep_position_ceiling_read(struct counter_device *counter,
+					 struct counter_count *count,
+					 u64 *ceiling)
 {
 	struct ti_eqep_cnt *priv = counter->priv;
 	u32 qposmax;
 
 	regmap_read(priv->regmap32, QPOSMAX, &qposmax);
 
-	return sprintf(buf, "%u\n", qposmax);
+	*ceiling = qposmax;
+
+	return 0;
 }
 
-static ssize_t ti_eqep_position_ceiling_write(struct counter_device *counter,
-					      struct counter_count *count,
-					      void *ext_priv, const char *buf,
-					      size_t len)
+static int ti_eqep_position_ceiling_write(struct counter_device *counter,
+					  struct counter_count *count,
+					  u64 ceiling)
 {
 	struct ti_eqep_cnt *priv = counter->priv;
-	int err;
-	u32 res;
 
-	err = kstrtouint(buf, 0, &res);
-	if (err < 0)
-		return err;
+	if (ceiling != (u32)ceiling)
+		return -ERANGE;
 
-	regmap_write(priv->regmap32, QPOSMAX, res);
+	regmap_write(priv->regmap32, QPOSMAX, ceiling);
 
-	return len;
+	return 0;
 }
 
-static ssize_t ti_eqep_position_enable_read(struct counter_device *counter,
-					    struct counter_count *count,
-					    void *ext_priv, char *buf)
+static int ti_eqep_position_enable_read(struct counter_device *counter,
+					struct counter_count *count, u8 *enable)
 {
 	struct ti_eqep_cnt *priv = counter->priv;
 	u32 qepctl;
 
 	regmap_read(priv->regmap16, QEPCTL, &qepctl);
 
-	return sprintf(buf, "%u\n", !!(qepctl & QEPCTL_PHEN));
+	*enable = !!(qepctl & QEPCTL_PHEN);
+
+	return 0;
 }
 
-static ssize_t ti_eqep_position_enable_write(struct counter_device *counter,
-					     struct counter_count *count,
-					     void *ext_priv, const char *buf,
-					     size_t len)
+static int ti_eqep_position_enable_write(struct counter_device *counter,
+					 struct counter_count *count, u8 enable)
 {
 	struct ti_eqep_cnt *priv = counter->priv;
-	int err;
-	bool res;
-
-	err = kstrtobool(buf, &res);
-	if (err < 0)
-		return err;
 
-	regmap_write_bits(priv->regmap16, QEPCTL, QEPCTL_PHEN, res ? -1 : 0);
+	regmap_write_bits(priv->regmap16, QEPCTL, QEPCTL_PHEN, enable ? -1 : 0);
 
-	return len;
+	return 0;
 }
 
-static struct counter_count_ext ti_eqep_position_ext[] = {
-	{
-		.name	= "ceiling",
-		.read	= ti_eqep_position_ceiling_read,
-		.write	= ti_eqep_position_ceiling_write,
-	},
-	{
-		.name	= "enable",
-		.read	= ti_eqep_position_enable_read,
-		.write	= ti_eqep_position_enable_write,
-	},
+static struct counter_comp ti_eqep_position_ext[] = {
+	COUNTER_COMP_CEILING(ti_eqep_position_ceiling_read,
+			     ti_eqep_position_ceiling_write),
+	COUNTER_COMP_ENABLE(ti_eqep_position_enable_read,
+			    ti_eqep_position_enable_write),
 };
 
 static struct counter_signal ti_eqep_signals[] = {
@@ -295,16 +311,16 @@ static struct counter_signal ti_eqep_signals[] = {
 };
 
 static const enum counter_function ti_eqep_position_functions[] = {
-	[TI_EQEP_COUNT_FUNC_QUAD_COUNT]	= COUNTER_FUNCTION_QUADRATURE_X4,
-	[TI_EQEP_COUNT_FUNC_DIR_COUNT]	= COUNTER_FUNCTION_PULSE_DIRECTION,
-	[TI_EQEP_COUNT_FUNC_UP_COUNT]	= COUNTER_FUNCTION_INCREASE,
-	[TI_EQEP_COUNT_FUNC_DOWN_COUNT]	= COUNTER_FUNCTION_DECREASE,
+	COUNTER_FUNCTION_QUADRATURE_X4,
+	COUNTER_FUNCTION_PULSE_DIRECTION,
+	COUNTER_FUNCTION_INCREASE,
+	COUNTER_FUNCTION_DECREASE,
 };
 
 static const enum counter_synapse_action ti_eqep_position_synapse_actions[] = {
-	[TI_EQEP_SYNAPSE_ACTION_BOTH_EDGES]	= COUNTER_SYNAPSE_ACTION_BOTH_EDGES,
-	[TI_EQEP_SYNAPSE_ACTION_RISING_EDGE]	= COUNTER_SYNAPSE_ACTION_RISING_EDGE,
-	[TI_EQEP_SYNAPSE_ACTION_NONE]		= COUNTER_SYNAPSE_ACTION_NONE,
+	COUNTER_SYNAPSE_ACTION_BOTH_EDGES,
+	COUNTER_SYNAPSE_ACTION_RISING_EDGE,
+	COUNTER_SYNAPSE_ACTION_NONE,
 };
 
 static struct counter_synapse ti_eqep_position_synapses[] = {
diff --git a/drivers/firmware/efi/sysfb_efi.c b/drivers/firmware/efi/sysfb_efi.c
index 7ac757843dcf..24d6f6e08df8 100644
--- a/drivers/firmware/efi/sysfb_efi.c
+++ b/drivers/firmware/efi/sysfb_efi.c
@@ -274,6 +274,14 @@ static const struct dmi_system_id efifb_dmi_swap_width_height[] __initconst = {
 					"IdeaPad Duet 3 10IGL5"),
 		},
 	},
+	{
+		/* Lenovo Yoga Book X91F / X91L */
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			/* Non exact match to match F + L versions */
+			DMI_MATCH(DMI_PRODUCT_NAME, "Lenovo YB1-X91"),
+		},
+	},
 	{},
 };
 
diff --git a/drivers/gpu/drm/armada/armada_drv.c b/drivers/gpu/drm/armada/armada_drv.c
index 8e3e98f13db4..54168134d9b9 100644
--- a/drivers/gpu/drm/armada/armada_drv.c
+++ b/drivers/gpu/drm/armada/armada_drv.c
@@ -99,7 +99,6 @@ static int armada_drm_bind(struct device *dev)
 	if (ret) {
 		dev_err(dev, "[" DRM_NAME ":%s] can't kick out simple-fb: %d\n",
 			__func__, ret);
-		kfree(priv);
 		return ret;
 	}
 
diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index 8768073794fb..6106fa7c4302 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -284,10 +284,17 @@ static const struct dmi_system_id orientation_data[] = {
 		  DMI_EXACT_MATCH(DMI_PRODUCT_VERSION, "IdeaPad Duet 3 10IGL5"),
 		},
 		.driver_data = (void *)&lcd1200x1920_rightside_up,
-	}, {	/* Lenovo Yoga Book X90F / X91F / X91L */
+	}, {	/* Lenovo Yoga Book X90F / X90L */
 		.matches = {
-		  /* Non exact match to match all versions */
-		  DMI_MATCH(DMI_PRODUCT_NAME, "Lenovo YB1-X9"),
+		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Intel Corporation"),
+		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "CHERRYVIEW D1 PLATFORM"),
+		  DMI_EXACT_MATCH(DMI_PRODUCT_VERSION, "YETI-11"),
+		},
+		.driver_data = (void *)&lcd1200x1920_rightside_up,
+	}, {	/* Lenovo Yoga Book X91F / X91L */
+		.matches = {
+		  /* Non exact match to match F + L versions */
+		  DMI_MATCH(DMI_PRODUCT_NAME, "Lenovo YB1-X91"),
 		},
 		.driver_data = (void *)&lcd1200x1920_rightside_up,
 	}, {	/* OneGX1 Pro */
diff --git a/drivers/gpu/drm/i915/display/icl_dsi.c b/drivers/gpu/drm/i915/display/icl_dsi.c
index 2601873e1546..26dd5a2bd502 100644
--- a/drivers/gpu/drm/i915/display/icl_dsi.c
+++ b/drivers/gpu/drm/i915/display/icl_dsi.c
@@ -307,9 +307,21 @@ static void configure_dual_link_mode(struct intel_encoder *encoder,
 {
 	struct drm_i915_private *dev_priv = to_i915(encoder->base.dev);
 	struct intel_dsi *intel_dsi = enc_to_intel_dsi(encoder);
+	i915_reg_t dss_ctl1_reg, dss_ctl2_reg;
 	u32 dss_ctl1;
 
-	dss_ctl1 = intel_de_read(dev_priv, DSS_CTL1);
+	/* FIXME: Move all DSS handling to intel_vdsc.c */
+	if (DISPLAY_VER(dev_priv) >= 12) {
+		struct intel_crtc *crtc = to_intel_crtc(pipe_config->uapi.crtc);
+
+		dss_ctl1_reg = ICL_PIPE_DSS_CTL1(crtc->pipe);
+		dss_ctl2_reg = ICL_PIPE_DSS_CTL2(crtc->pipe);
+	} else {
+		dss_ctl1_reg = DSS_CTL1;
+		dss_ctl2_reg = DSS_CTL2;
+	}
+
+	dss_ctl1 = intel_de_read(dev_priv, dss_ctl1_reg);
 	dss_ctl1 |= SPLITTER_ENABLE;
 	dss_ctl1 &= ~OVERLAP_PIXELS_MASK;
 	dss_ctl1 |= OVERLAP_PIXELS(intel_dsi->pixel_overlap);
@@ -330,16 +342,16 @@ static void configure_dual_link_mode(struct intel_encoder *encoder,
 
 		dss_ctl1 &= ~LEFT_DL_BUF_TARGET_DEPTH_MASK;
 		dss_ctl1 |= LEFT_DL_BUF_TARGET_DEPTH(dl_buffer_depth);
-		dss_ctl2 = intel_de_read(dev_priv, DSS_CTL2);
+		dss_ctl2 = intel_de_read(dev_priv, dss_ctl2_reg);
 		dss_ctl2 &= ~RIGHT_DL_BUF_TARGET_DEPTH_MASK;
 		dss_ctl2 |= RIGHT_DL_BUF_TARGET_DEPTH(dl_buffer_depth);
-		intel_de_write(dev_priv, DSS_CTL2, dss_ctl2);
+		intel_de_write(dev_priv, dss_ctl2_reg, dss_ctl2);
 	} else {
 		/* Interleave */
 		dss_ctl1 |= DUAL_LINK_MODE_INTERLEAVE;
 	}
 
-	intel_de_write(dev_priv, DSS_CTL1, dss_ctl1);
+	intel_de_write(dev_priv, dss_ctl1_reg, dss_ctl1);
 }
 
 /* aka DSI 8X clock */
diff --git a/drivers/gpu/drm/i915/i915_perf.c b/drivers/gpu/drm/i915/i915_perf.c
index f3c8f87d25ae..774d45142091 100644
--- a/drivers/gpu/drm/i915/i915_perf.c
+++ b/drivers/gpu/drm/i915/i915_perf.c
@@ -879,8 +879,9 @@ static int gen8_oa_read(struct i915_perf_stream *stream,
 		if (ret)
 			return ret;
 
-		DRM_DEBUG("OA buffer overflow (exponent = %d): force restart\n",
-			  stream->period_exponent);
+		drm_dbg(&stream->perf->i915->drm,
+			"OA buffer overflow (exponent = %d): force restart\n",
+			stream->period_exponent);
 
 		stream->perf->ops.oa_disable(stream);
 		stream->perf->ops.oa_enable(stream);
@@ -1102,8 +1103,9 @@ static int gen7_oa_read(struct i915_perf_stream *stream,
 		if (ret)
 			return ret;
 
-		DRM_DEBUG("OA buffer overflow (exponent = %d): force restart\n",
-			  stream->period_exponent);
+		drm_dbg(&stream->perf->i915->drm,
+			"OA buffer overflow (exponent = %d): force restart\n",
+			stream->period_exponent);
 
 		stream->perf->ops.oa_disable(stream);
 		stream->perf->ops.oa_enable(stream);
@@ -2857,7 +2859,8 @@ static int i915_oa_stream_init(struct i915_perf_stream *stream,
 	int ret;
 
 	if (!props->engine) {
-		DRM_DEBUG("OA engine not specified\n");
+		drm_dbg(&stream->perf->i915->drm,
+			"OA engine not specified\n");
 		return -EINVAL;
 	}
 
@@ -2867,18 +2870,21 @@ static int i915_oa_stream_init(struct i915_perf_stream *stream,
 	 * IDs
 	 */
 	if (!perf->metrics_kobj) {
-		DRM_DEBUG("OA metrics weren't advertised via sysfs\n");
+		drm_dbg(&stream->perf->i915->drm,
+			"OA metrics weren't advertised via sysfs\n");
 		return -EINVAL;
 	}
 
 	if (!(props->sample_flags & SAMPLE_OA_REPORT) &&
 	    (GRAPHICS_VER(perf->i915) < 12 || !stream->ctx)) {
-		DRM_DEBUG("Only OA report sampling supported\n");
+		drm_dbg(&stream->perf->i915->drm,
+			"Only OA report sampling supported\n");
 		return -EINVAL;
 	}
 
 	if (!perf->ops.enable_metric_set) {
-		DRM_DEBUG("OA unit not supported\n");
+		drm_dbg(&stream->perf->i915->drm,
+			"OA unit not supported\n");
 		return -ENODEV;
 	}
 
@@ -2888,12 +2894,14 @@ static int i915_oa_stream_init(struct i915_perf_stream *stream,
 	 * we currently only allow exclusive access
 	 */
 	if (perf->exclusive_stream) {
-		DRM_DEBUG("OA unit already in use\n");
+		drm_dbg(&stream->perf->i915->drm,
+			"OA unit already in use\n");
 		return -EBUSY;
 	}
 
 	if (!props->oa_format) {
-		DRM_DEBUG("OA report format not specified\n");
+		drm_dbg(&stream->perf->i915->drm,
+			"OA report format not specified\n");
 		return -EINVAL;
 	}
 
@@ -2923,20 +2931,23 @@ static int i915_oa_stream_init(struct i915_perf_stream *stream,
 	if (stream->ctx) {
 		ret = oa_get_render_ctx_id(stream);
 		if (ret) {
-			DRM_DEBUG("Invalid context id to filter with\n");
+			drm_dbg(&stream->perf->i915->drm,
+				"Invalid context id to filter with\n");
 			return ret;
 		}
 	}
 
 	ret = alloc_noa_wait(stream);
 	if (ret) {
-		DRM_DEBUG("Unable to allocate NOA wait batch buffer\n");
+		drm_dbg(&stream->perf->i915->drm,
+			"Unable to allocate NOA wait batch buffer\n");
 		goto err_noa_wait_alloc;
 	}
 
 	stream->oa_config = i915_perf_get_oa_config(perf, props->metrics_set);
 	if (!stream->oa_config) {
-		DRM_DEBUG("Invalid OA config id=%i\n", props->metrics_set);
+		drm_dbg(&stream->perf->i915->drm,
+			"Invalid OA config id=%i\n", props->metrics_set);
 		ret = -EINVAL;
 		goto err_config;
 	}
@@ -2967,11 +2978,13 @@ static int i915_oa_stream_init(struct i915_perf_stream *stream,
 
 	ret = i915_perf_stream_enable_sync(stream);
 	if (ret) {
-		DRM_DEBUG("Unable to enable metric set\n");
+		drm_dbg(&stream->perf->i915->drm,
+			"Unable to enable metric set\n");
 		goto err_enable;
 	}
 
-	DRM_DEBUG("opening stream oa config uuid=%s\n",
+	drm_dbg(&stream->perf->i915->drm,
+		"opening stream oa config uuid=%s\n",
 		  stream->oa_config->uuid);
 
 	hrtimer_init(&stream->poll_check_timer,
@@ -3423,7 +3436,8 @@ i915_perf_open_ioctl_locked(struct i915_perf *perf,
 
 		specific_ctx = i915_gem_context_lookup(file_priv, ctx_handle);
 		if (IS_ERR(specific_ctx)) {
-			DRM_DEBUG("Failed to look up context with ID %u for opening perf stream\n",
+			drm_dbg(&perf->i915->drm,
+				"Failed to look up context with ID %u for opening perf stream\n",
 				  ctx_handle);
 			ret = PTR_ERR(specific_ctx);
 			goto err;
@@ -3457,7 +3471,8 @@ i915_perf_open_ioctl_locked(struct i915_perf *perf,
 
 	if (props->hold_preemption) {
 		if (!props->single_context) {
-			DRM_DEBUG("preemption disable with no context\n");
+			drm_dbg(&perf->i915->drm,
+				"preemption disable with no context\n");
 			ret = -EINVAL;
 			goto err;
 		}
@@ -3479,7 +3494,8 @@ i915_perf_open_ioctl_locked(struct i915_perf *perf,
 	 */
 	if (privileged_op &&
 	    i915_perf_stream_paranoid && !perfmon_capable()) {
-		DRM_DEBUG("Insufficient privileges to open i915 perf stream\n");
+		drm_dbg(&perf->i915->drm,
+			"Insufficient privileges to open i915 perf stream\n");
 		ret = -EACCES;
 		goto err_ctx;
 	}
@@ -3586,7 +3602,8 @@ static int read_properties_unlocked(struct i915_perf *perf,
 	props->poll_oa_period = DEFAULT_POLL_PERIOD_NS;
 
 	if (!n_props) {
-		DRM_DEBUG("No i915 perf properties given\n");
+		drm_dbg(&perf->i915->drm,
+			"No i915 perf properties given\n");
 		return -EINVAL;
 	}
 
@@ -3595,7 +3612,8 @@ static int read_properties_unlocked(struct i915_perf *perf,
 						 I915_ENGINE_CLASS_RENDER,
 						 0);
 	if (!props->engine) {
-		DRM_DEBUG("No RENDER-capable engines\n");
+		drm_dbg(&perf->i915->drm,
+			"No RENDER-capable engines\n");
 		return -EINVAL;
 	}
 
@@ -3606,7 +3624,8 @@ static int read_properties_unlocked(struct i915_perf *perf,
 	 * from userspace.
 	 */
 	if (n_props >= DRM_I915_PERF_PROP_MAX) {
-		DRM_DEBUG("More i915 perf properties specified than exist\n");
+		drm_dbg(&perf->i915->drm,
+			"More i915 perf properties specified than exist\n");
 		return -EINVAL;
 	}
 
@@ -3623,7 +3642,8 @@ static int read_properties_unlocked(struct i915_perf *perf,
 			return ret;
 
 		if (id == 0 || id >= DRM_I915_PERF_PROP_MAX) {
-			DRM_DEBUG("Unknown i915 perf property ID\n");
+			drm_dbg(&perf->i915->drm,
+				"Unknown i915 perf property ID\n");
 			return -EINVAL;
 		}
 
@@ -3638,19 +3658,22 @@ static int read_properties_unlocked(struct i915_perf *perf,
 			break;
 		case DRM_I915_PERF_PROP_OA_METRICS_SET:
 			if (value == 0) {
-				DRM_DEBUG("Unknown OA metric set ID\n");
+				drm_dbg(&perf->i915->drm,
+					"Unknown OA metric set ID\n");
 				return -EINVAL;
 			}
 			props->metrics_set = value;
 			break;
 		case DRM_I915_PERF_PROP_OA_FORMAT:
 			if (value == 0 || value >= I915_OA_FORMAT_MAX) {
-				DRM_DEBUG("Out-of-range OA report format %llu\n",
+				drm_dbg(&perf->i915->drm,
+					"Out-of-range OA report format %llu\n",
 					  value);
 				return -EINVAL;
 			}
 			if (!oa_format_valid(perf, value)) {
-				DRM_DEBUG("Unsupported OA report format %llu\n",
+				drm_dbg(&perf->i915->drm,
+					"Unsupported OA report format %llu\n",
 					  value);
 				return -EINVAL;
 			}
@@ -3658,7 +3681,8 @@ static int read_properties_unlocked(struct i915_perf *perf,
 			break;
 		case DRM_I915_PERF_PROP_OA_EXPONENT:
 			if (value > OA_EXPONENT_MAX) {
-				DRM_DEBUG("OA timer exponent too high (> %u)\n",
+				drm_dbg(&perf->i915->drm,
+					"OA timer exponent too high (> %u)\n",
 					 OA_EXPONENT_MAX);
 				return -EINVAL;
 			}
@@ -3686,7 +3710,8 @@ static int read_properties_unlocked(struct i915_perf *perf,
 				oa_freq_hz = 0;
 
 			if (oa_freq_hz > i915_oa_max_sample_rate && !perfmon_capable()) {
-				DRM_DEBUG("OA exponent would exceed the max sampling frequency (sysctl dev.i915.oa_max_sample_rate) %uHz without CAP_PERFMON or CAP_SYS_ADMIN privileges\n",
+				drm_dbg(&perf->i915->drm,
+					"OA exponent would exceed the max sampling frequency (sysctl dev.i915.oa_max_sample_rate) %uHz without CAP_PERFMON or CAP_SYS_ADMIN privileges\n",
 					  i915_oa_max_sample_rate);
 				return -EACCES;
 			}
@@ -3703,13 +3728,15 @@ static int read_properties_unlocked(struct i915_perf *perf,
 			if (copy_from_user(&user_sseu,
 					   u64_to_user_ptr(value),
 					   sizeof(user_sseu))) {
-				DRM_DEBUG("Unable to copy global sseu parameter\n");
+				drm_dbg(&perf->i915->drm,
+					"Unable to copy global sseu parameter\n");
 				return -EFAULT;
 			}
 
 			ret = get_sseu_config(&props->sseu, props->engine, &user_sseu);
 			if (ret) {
-				DRM_DEBUG("Invalid SSEU configuration\n");
+				drm_dbg(&perf->i915->drm,
+					"Invalid SSEU configuration\n");
 				return ret;
 			}
 			props->has_sseu = true;
@@ -3717,7 +3744,8 @@ static int read_properties_unlocked(struct i915_perf *perf,
 		}
 		case DRM_I915_PERF_PROP_POLL_OA_PERIOD:
 			if (value < 100000 /* 100us */) {
-				DRM_DEBUG("OA availability timer too small (%lluns < 100us)\n",
+				drm_dbg(&perf->i915->drm,
+					"OA availability timer too small (%lluns < 100us)\n",
 					  value);
 				return -EINVAL;
 			}
@@ -3768,7 +3796,8 @@ int i915_perf_open_ioctl(struct drm_device *dev, void *data,
 	int ret;
 
 	if (!perf->i915) {
-		DRM_DEBUG("i915 perf interface not available for this system\n");
+		drm_dbg(&perf->i915->drm,
+			"i915 perf interface not available for this system\n");
 		return -ENOTSUPP;
 	}
 
@@ -3776,7 +3805,8 @@ int i915_perf_open_ioctl(struct drm_device *dev, void *data,
 			   I915_PERF_FLAG_FD_NONBLOCK |
 			   I915_PERF_FLAG_DISABLED;
 	if (param->flags & ~known_open_flags) {
-		DRM_DEBUG("Unknown drm_i915_perf_open_param flag\n");
+		drm_dbg(&perf->i915->drm,
+			"Unknown drm_i915_perf_open_param flag\n");
 		return -EINVAL;
 	}
 
@@ -3986,7 +4016,8 @@ static struct i915_oa_reg *alloc_oa_regs(struct i915_perf *perf,
 			goto addr_err;
 
 		if (!is_valid(perf, addr)) {
-			DRM_DEBUG("Invalid oa_reg address: %X\n", addr);
+			drm_dbg(&perf->i915->drm,
+				"Invalid oa_reg address: %X\n", addr);
 			err = -EINVAL;
 			goto addr_err;
 		}
@@ -4060,30 +4091,35 @@ int i915_perf_add_config_ioctl(struct drm_device *dev, void *data,
 	int err, id;
 
 	if (!perf->i915) {
-		DRM_DEBUG("i915 perf interface not available for this system\n");
+		drm_dbg(&perf->i915->drm,
+			"i915 perf interface not available for this system\n");
 		return -ENOTSUPP;
 	}
 
 	if (!perf->metrics_kobj) {
-		DRM_DEBUG("OA metrics weren't advertised via sysfs\n");
+		drm_dbg(&perf->i915->drm,
+			"OA metrics weren't advertised via sysfs\n");
 		return -EINVAL;
 	}
 
 	if (i915_perf_stream_paranoid && !perfmon_capable()) {
-		DRM_DEBUG("Insufficient privileges to add i915 OA config\n");
+		drm_dbg(&perf->i915->drm,
+			"Insufficient privileges to add i915 OA config\n");
 		return -EACCES;
 	}
 
 	if ((!args->mux_regs_ptr || !args->n_mux_regs) &&
 	    (!args->boolean_regs_ptr || !args->n_boolean_regs) &&
 	    (!args->flex_regs_ptr || !args->n_flex_regs)) {
-		DRM_DEBUG("No OA registers given\n");
+		drm_dbg(&perf->i915->drm,
+			"No OA registers given\n");
 		return -EINVAL;
 	}
 
 	oa_config = kzalloc(sizeof(*oa_config), GFP_KERNEL);
 	if (!oa_config) {
-		DRM_DEBUG("Failed to allocate memory for the OA config\n");
+		drm_dbg(&perf->i915->drm,
+			"Failed to allocate memory for the OA config\n");
 		return -ENOMEM;
 	}
 
@@ -4091,7 +4127,8 @@ int i915_perf_add_config_ioctl(struct drm_device *dev, void *data,
 	kref_init(&oa_config->ref);
 
 	if (!uuid_is_valid(args->uuid)) {
-		DRM_DEBUG("Invalid uuid format for OA config\n");
+		drm_dbg(&perf->i915->drm,
+			"Invalid uuid format for OA config\n");
 		err = -EINVAL;
 		goto reg_err;
 	}
@@ -4108,7 +4145,8 @@ int i915_perf_add_config_ioctl(struct drm_device *dev, void *data,
 			     args->n_mux_regs);
 
 	if (IS_ERR(regs)) {
-		DRM_DEBUG("Failed to create OA config for mux_regs\n");
+		drm_dbg(&perf->i915->drm,
+			"Failed to create OA config for mux_regs\n");
 		err = PTR_ERR(regs);
 		goto reg_err;
 	}
@@ -4121,7 +4159,8 @@ int i915_perf_add_config_ioctl(struct drm_device *dev, void *data,
 			     args->n_boolean_regs);
 
 	if (IS_ERR(regs)) {
-		DRM_DEBUG("Failed to create OA config for b_counter_regs\n");
+		drm_dbg(&perf->i915->drm,
+			"Failed to create OA config for b_counter_regs\n");
 		err = PTR_ERR(regs);
 		goto reg_err;
 	}
@@ -4140,7 +4179,8 @@ int i915_perf_add_config_ioctl(struct drm_device *dev, void *data,
 				     args->n_flex_regs);
 
 		if (IS_ERR(regs)) {
-			DRM_DEBUG("Failed to create OA config for flex_regs\n");
+			drm_dbg(&perf->i915->drm,
+				"Failed to create OA config for flex_regs\n");
 			err = PTR_ERR(regs);
 			goto reg_err;
 		}
@@ -4156,7 +4196,8 @@ int i915_perf_add_config_ioctl(struct drm_device *dev, void *data,
 	 */
 	idr_for_each_entry(&perf->metrics_idr, tmp, id) {
 		if (!strcmp(tmp->uuid, oa_config->uuid)) {
-			DRM_DEBUG("OA config already exists with this uuid\n");
+			drm_dbg(&perf->i915->drm,
+				"OA config already exists with this uuid\n");
 			err = -EADDRINUSE;
 			goto sysfs_err;
 		}
@@ -4164,7 +4205,8 @@ int i915_perf_add_config_ioctl(struct drm_device *dev, void *data,
 
 	err = create_dynamic_oa_sysfs_entry(perf, oa_config);
 	if (err) {
-		DRM_DEBUG("Failed to create sysfs entry for OA config\n");
+		drm_dbg(&perf->i915->drm,
+			"Failed to create sysfs entry for OA config\n");
 		goto sysfs_err;
 	}
 
@@ -4173,22 +4215,25 @@ int i915_perf_add_config_ioctl(struct drm_device *dev, void *data,
 				  oa_config, 2,
 				  0, GFP_KERNEL);
 	if (oa_config->id < 0) {
-		DRM_DEBUG("Failed to create sysfs entry for OA config\n");
+		drm_dbg(&perf->i915->drm,
+			"Failed to create sysfs entry for OA config\n");
 		err = oa_config->id;
 		goto sysfs_err;
 	}
+	id = oa_config->id;
 
+	drm_dbg(&perf->i915->drm,
+		"Added config %s id=%i\n", oa_config->uuid, oa_config->id);
 	mutex_unlock(&perf->metrics_lock);
 
-	DRM_DEBUG("Added config %s id=%i\n", oa_config->uuid, oa_config->id);
-
-	return oa_config->id;
+	return id;
 
 sysfs_err:
 	mutex_unlock(&perf->metrics_lock);
 reg_err:
 	i915_oa_config_put(oa_config);
-	DRM_DEBUG("Failed to add new OA config\n");
+	drm_dbg(&perf->i915->drm,
+		"Failed to add new OA config\n");
 	return err;
 }
 
@@ -4212,12 +4257,14 @@ int i915_perf_remove_config_ioctl(struct drm_device *dev, void *data,
 	int ret;
 
 	if (!perf->i915) {
-		DRM_DEBUG("i915 perf interface not available for this system\n");
+		drm_dbg(&perf->i915->drm,
+			"i915 perf interface not available for this system\n");
 		return -ENOTSUPP;
 	}
 
 	if (i915_perf_stream_paranoid && !perfmon_capable()) {
-		DRM_DEBUG("Insufficient privileges to remove i915 OA config\n");
+		drm_dbg(&perf->i915->drm,
+			"Insufficient privileges to remove i915 OA config\n");
 		return -EACCES;
 	}
 
@@ -4227,7 +4274,8 @@ int i915_perf_remove_config_ioctl(struct drm_device *dev, void *data,
 
 	oa_config = idr_find(&perf->metrics_idr, *arg);
 	if (!oa_config) {
-		DRM_DEBUG("Failed to remove unknown OA config\n");
+		drm_dbg(&perf->i915->drm,
+			"Failed to remove unknown OA config\n");
 		ret = -ENOENT;
 		goto err_unlock;
 	}
@@ -4240,7 +4288,8 @@ int i915_perf_remove_config_ioctl(struct drm_device *dev, void *data,
 
 	mutex_unlock(&perf->metrics_lock);
 
-	DRM_DEBUG("Removed config %s id=%i\n", oa_config->uuid, oa_config->id);
+	drm_dbg(&perf->i915->drm,
+		"Removed config %s id=%i\n", oa_config->uuid, oa_config->id);
 
 	i915_oa_config_put(oa_config);
 
diff --git a/drivers/i2c/busses/i2c-hisi.c b/drivers/i2c/busses/i2c-hisi.c
index 72e43ecaff13..1f406e6f4ece 100644
--- a/drivers/i2c/busses/i2c-hisi.c
+++ b/drivers/i2c/busses/i2c-hisi.c
@@ -315,6 +315,13 @@ static void hisi_i2c_xfer_msg(struct hisi_i2c_controller *ctlr)
 		    max_write == 0)
 			break;
 	}
+
+	/*
+	 * Disable the TX_EMPTY interrupt after finishing all the messages to
+	 * avoid overwhelming the CPU.
+	 */
+	if (ctlr->msg_tx_idx == ctlr->msg_num)
+		hisi_i2c_disable_int(ctlr, HISI_I2C_INT_TX_EMPTY);
 }
 
 static irqreturn_t hisi_i2c_irq(int irq, void *context)
diff --git a/drivers/i2c/busses/i2c-imx-lpi2c.c b/drivers/i2c/busses/i2c-imx-lpi2c.c
index 2018dbcf241e..d45ec26d51cb 100644
--- a/drivers/i2c/busses/i2c-imx-lpi2c.c
+++ b/drivers/i2c/busses/i2c-imx-lpi2c.c
@@ -462,6 +462,8 @@ static int lpi2c_imx_xfer(struct i2c_adapter *adapter,
 		if (num == 1 && msgs[0].len == 0)
 			goto stop;
 
+		lpi2c_imx->rx_buf = NULL;
+		lpi2c_imx->tx_buf = NULL;
 		lpi2c_imx->delivered = 0;
 		lpi2c_imx->msglen = msgs[i].len;
 		init_completion(&lpi2c_imx->complete);
diff --git a/drivers/i2c/busses/i2c-ocores.c b/drivers/i2c/busses/i2c-ocores.c
index a0af027db04c..2e575856c5cd 100644
--- a/drivers/i2c/busses/i2c-ocores.c
+++ b/drivers/i2c/busses/i2c-ocores.c
@@ -342,18 +342,18 @@ static int ocores_poll_wait(struct ocores_i2c *i2c)
  * ocores_isr(), we just add our polling code around it.
  *
  * It can run in atomic context
+ *
+ * Return: 0 on success, -ETIMEDOUT on timeout
  */
-static void ocores_process_polling(struct ocores_i2c *i2c)
+static int ocores_process_polling(struct ocores_i2c *i2c)
 {
-	while (1) {
-		irqreturn_t ret;
-		int err;
+	irqreturn_t ret;
+	int err = 0;
 
+	while (1) {
 		err = ocores_poll_wait(i2c);
-		if (err) {
-			i2c->state = STATE_ERROR;
+		if (err)
 			break; /* timeout */
-		}
 
 		ret = ocores_isr(-1, i2c);
 		if (ret == IRQ_NONE)
@@ -364,13 +364,15 @@ static void ocores_process_polling(struct ocores_i2c *i2c)
 					break;
 		}
 	}
+
+	return err;
 }
 
 static int ocores_xfer_core(struct ocores_i2c *i2c,
 			    struct i2c_msg *msgs, int num,
 			    bool polling)
 {
-	int ret;
+	int ret = 0;
 	u8 ctrl;
 
 	ctrl = oc_getreg(i2c, OCI2C_CONTROL);
@@ -388,15 +390,16 @@ static int ocores_xfer_core(struct ocores_i2c *i2c,
 	oc_setreg(i2c, OCI2C_CMD, OCI2C_CMD_START);
 
 	if (polling) {
-		ocores_process_polling(i2c);
+		ret = ocores_process_polling(i2c);
 	} else {
-		ret = wait_event_timeout(i2c->wait,
-					 (i2c->state == STATE_ERROR) ||
-					 (i2c->state == STATE_DONE), HZ);
-		if (ret == 0) {
-			ocores_process_timeout(i2c);
-			return -ETIMEDOUT;
-		}
+		if (wait_event_timeout(i2c->wait,
+				       (i2c->state == STATE_ERROR) ||
+				       (i2c->state == STATE_DONE), HZ) == 0)
+			ret = -ETIMEDOUT;
+	}
+	if (ret) {
+		ocores_process_timeout(i2c);
+		return ret;
 	}
 
 	return (i2c->state == STATE_DONE) ? num : -EIO;
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index fd192104fd8d..c66d8bf40585 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -496,22 +496,11 @@ static inline unsigned short cma_family(struct rdma_id_private *id_priv)
 	return id_priv->id.route.addr.src_addr.ss_family;
 }
 
-static int cma_set_qkey(struct rdma_id_private *id_priv, u32 qkey)
+static int cma_set_default_qkey(struct rdma_id_private *id_priv)
 {
 	struct ib_sa_mcmember_rec rec;
 	int ret = 0;
 
-	if (id_priv->qkey) {
-		if (qkey && id_priv->qkey != qkey)
-			return -EINVAL;
-		return 0;
-	}
-
-	if (qkey) {
-		id_priv->qkey = qkey;
-		return 0;
-	}
-
 	switch (id_priv->id.ps) {
 	case RDMA_PS_UDP:
 	case RDMA_PS_IB:
@@ -531,6 +520,16 @@ static int cma_set_qkey(struct rdma_id_private *id_priv, u32 qkey)
 	return ret;
 }
 
+static int cma_set_qkey(struct rdma_id_private *id_priv, u32 qkey)
+{
+	if (!qkey ||
+	    (id_priv->qkey && (id_priv->qkey != qkey)))
+		return -EINVAL;
+
+	id_priv->qkey = qkey;
+	return 0;
+}
+
 static void cma_translate_ib(struct sockaddr_ib *sib, struct rdma_dev_addr *dev_addr)
 {
 	dev_addr->dev_type = ARPHRD_INFINIBAND;
@@ -1099,7 +1098,7 @@ static int cma_ib_init_qp_attr(struct rdma_id_private *id_priv,
 	*qp_attr_mask = IB_QP_STATE | IB_QP_PKEY_INDEX | IB_QP_PORT;
 
 	if (id_priv->id.qp_type == IB_QPT_UD) {
-		ret = cma_set_qkey(id_priv, 0);
+		ret = cma_set_default_qkey(id_priv);
 		if (ret)
 			return ret;
 
@@ -4373,7 +4372,10 @@ static int cma_send_sidr_rep(struct rdma_id_private *id_priv,
 	memset(&rep, 0, sizeof rep);
 	rep.status = status;
 	if (status == IB_SIDR_SUCCESS) {
-		ret = cma_set_qkey(id_priv, qkey);
+		if (qkey)
+			ret = cma_set_qkey(id_priv, qkey);
+		else
+			ret = cma_set_default_qkey(id_priv);
 		if (ret)
 			return ret;
 		rep.qp_num = id_priv->qp_num;
@@ -4578,9 +4580,7 @@ static void cma_make_mc_event(int status, struct rdma_id_private *id_priv,
 	enum ib_gid_type gid_type;
 	struct net_device *ndev;
 
-	if (!status)
-		status = cma_set_qkey(id_priv, be32_to_cpu(multicast->rec.qkey));
-	else
+	if (status)
 		pr_debug_ratelimited("RDMA CM: MULTICAST_ERROR: failed to join multicast. status %d\n",
 				     status);
 
@@ -4608,7 +4608,7 @@ static void cma_make_mc_event(int status, struct rdma_id_private *id_priv,
 	}
 
 	event->param.ud.qp_num = 0xFFFFFF;
-	event->param.ud.qkey = be32_to_cpu(multicast->rec.qkey);
+	event->param.ud.qkey = id_priv->qkey;
 
 out:
 	if (ndev)
@@ -4627,8 +4627,11 @@ static int cma_ib_mc_handler(int status, struct ib_sa_multicast *multicast)
 	    READ_ONCE(id_priv->state) == RDMA_CM_DESTROYING)
 		goto out;
 
-	cma_make_mc_event(status, id_priv, multicast, &event, mc);
-	ret = cma_cm_event_handler(id_priv, &event);
+	ret = cma_set_qkey(id_priv, be32_to_cpu(multicast->rec.qkey));
+	if (!ret) {
+		cma_make_mc_event(status, id_priv, multicast, &event, mc);
+		ret = cma_cm_event_handler(id_priv, &event);
+	}
 	rdma_destroy_ah_attr(&event.param.ud.ah_attr);
 	WARN_ON(ret);
 
@@ -4681,9 +4684,11 @@ static int cma_join_ib_multicast(struct rdma_id_private *id_priv,
 	if (ret)
 		return ret;
 
-	ret = cma_set_qkey(id_priv, 0);
-	if (ret)
-		return ret;
+	if (!id_priv->qkey) {
+		ret = cma_set_default_qkey(id_priv);
+		if (ret)
+			return ret;
+	}
 
 	cma_set_mgid(id_priv, (struct sockaddr *) &mc->addr, &rec.mgid);
 	rec.qkey = cpu_to_be32(id_priv->qkey);
@@ -4760,9 +4765,6 @@ static int cma_iboe_join_multicast(struct rdma_id_private *id_priv,
 	cma_iboe_set_mgid(addr, &ib.rec.mgid, gid_type);
 
 	ib.rec.pkey = cpu_to_be16(0xffff);
-	if (id_priv->id.ps == RDMA_PS_UDP)
-		ib.rec.qkey = cpu_to_be32(RDMA_UDP_QKEY);
-
 	if (dev_addr->bound_dev_if)
 		ndev = dev_get_by_index(dev_addr->net, dev_addr->bound_dev_if);
 	if (!ndev)
@@ -4788,6 +4790,9 @@ static int cma_iboe_join_multicast(struct rdma_id_private *id_priv,
 	if (err || !ib.rec.mtu)
 		return err ?: -EINVAL;
 
+	if (!id_priv->qkey)
+		cma_set_default_qkey(id_priv);
+
 	rdma_ip2gid((struct sockaddr *)&id_priv->id.route.addr.src_addr,
 		    &ib.rec.port_gid);
 	INIT_WORK(&mc->iboe_join.work, cma_iboe_join_work_handler);
@@ -4813,6 +4818,9 @@ int rdma_join_multicast(struct rdma_cm_id *id, struct sockaddr *addr,
 			    READ_ONCE(id_priv->state) != RDMA_CM_ADDR_RESOLVED))
 		return -EINVAL;
 
+	if (id_priv->id.qp_type != IB_QPT_UD)
+		return -EINVAL;
+
 	mc = kzalloc(sizeof(*mc), GFP_KERNEL);
 	if (!mc)
 		return -ENOMEM;
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index f0c07e4ba438..cae013130eb1 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -540,6 +540,8 @@ static struct ib_ah *_rdma_create_ah(struct ib_pd *pd,
 	else
 		ret = device->ops.create_ah(ah, &init_attr, NULL);
 	if (ret) {
+		if (ah->sgid_attr)
+			rdma_put_gid_attr(ah->sgid_attr);
 		kfree(ah);
 		return ERR_PTR(ret);
 	}
diff --git a/drivers/infiniband/hw/irdma/cm.c b/drivers/infiniband/hw/irdma/cm.c
index a8ec3d8f6e46..64d4bb0e9a12 100644
--- a/drivers/infiniband/hw/irdma/cm.c
+++ b/drivers/infiniband/hw/irdma/cm.c
@@ -1458,13 +1458,15 @@ static int irdma_send_fin(struct irdma_cm_node *cm_node)
  * irdma_find_listener - find a cm node listening on this addr-port pair
  * @cm_core: cm's core
  * @dst_addr: listener ip addr
+ * @ipv4: flag indicating IPv4 when true
  * @dst_port: listener tcp port num
  * @vlan_id: virtual LAN ID
  * @listener_state: state to match with listen node's
  */
 static struct irdma_cm_listener *
-irdma_find_listener(struct irdma_cm_core *cm_core, u32 *dst_addr, u16 dst_port,
-		    u16 vlan_id, enum irdma_cm_listener_state listener_state)
+irdma_find_listener(struct irdma_cm_core *cm_core, u32 *dst_addr, bool ipv4,
+		    u16 dst_port, u16 vlan_id,
+		    enum irdma_cm_listener_state listener_state)
 {
 	struct irdma_cm_listener *listen_node;
 	static const u32 ip_zero[4] = { 0, 0, 0, 0 };
@@ -1477,7 +1479,7 @@ irdma_find_listener(struct irdma_cm_core *cm_core, u32 *dst_addr, u16 dst_port,
 	list_for_each_entry (listen_node, &cm_core->listen_list, list) {
 		memcpy(listen_addr, listen_node->loc_addr, sizeof(listen_addr));
 		listen_port = listen_node->loc_port;
-		if (listen_port != dst_port ||
+		if (listen_node->ipv4 != ipv4 || listen_port != dst_port ||
 		    !(listener_state & listen_node->listener_state))
 			continue;
 		/* compare node pair, return node handle if a match */
@@ -2899,9 +2901,10 @@ irdma_make_listen_node(struct irdma_cm_core *cm_core,
 	unsigned long flags;
 
 	/* cannot have multiple matching listeners */
-	listener = irdma_find_listener(cm_core, cm_info->loc_addr,
-				       cm_info->loc_port, cm_info->vlan_id,
-				       IRDMA_CM_LISTENER_EITHER_STATE);
+	listener =
+		irdma_find_listener(cm_core, cm_info->loc_addr, cm_info->ipv4,
+				    cm_info->loc_port, cm_info->vlan_id,
+				    IRDMA_CM_LISTENER_EITHER_STATE);
 	if (listener &&
 	    listener->listener_state == IRDMA_CM_LISTENER_ACTIVE_STATE) {
 		refcount_dec(&listener->refcnt);
@@ -3150,6 +3153,7 @@ void irdma_receive_ilq(struct irdma_sc_vsi *vsi, struct irdma_puda_buf *rbuf)
 
 		listener = irdma_find_listener(cm_core,
 					       cm_info.loc_addr,
+					       cm_info.ipv4,
 					       cm_info.loc_port,
 					       cm_info.vlan_id,
 					       IRDMA_CM_LISTENER_ACTIVE_STATE);
diff --git a/drivers/infiniband/hw/irdma/cm.h b/drivers/infiniband/hw/irdma/cm.h
index d03cd29333ea..2b0fb5a6b300 100644
--- a/drivers/infiniband/hw/irdma/cm.h
+++ b/drivers/infiniband/hw/irdma/cm.h
@@ -41,7 +41,7 @@
 #define TCP_OPTIONS_PADDING	3
 
 #define IRDMA_DEFAULT_RETRYS	64
-#define IRDMA_DEFAULT_RETRANS	8
+#define IRDMA_DEFAULT_RETRANS	32
 #define IRDMA_DEFAULT_TTL		0x40
 #define IRDMA_DEFAULT_RTT_VAR		6
 #define IRDMA_DEFAULT_SS_THRESH		0x3fffffff
diff --git a/drivers/infiniband/hw/irdma/hw.c b/drivers/infiniband/hw/irdma/hw.c
index b918f80d2e2c..3b070cb3c4da 100644
--- a/drivers/infiniband/hw/irdma/hw.c
+++ b/drivers/infiniband/hw/irdma/hw.c
@@ -41,6 +41,7 @@ static enum irdma_hmc_rsrc_type iw_hmc_obj_types[] = {
 	IRDMA_HMC_IW_XFFL,
 	IRDMA_HMC_IW_Q1,
 	IRDMA_HMC_IW_Q1FL,
+	IRDMA_HMC_IW_PBLE,
 	IRDMA_HMC_IW_TIMER,
 	IRDMA_HMC_IW_FSIMC,
 	IRDMA_HMC_IW_FSIAV,
@@ -829,6 +830,8 @@ irdma_create_hmc_objs(struct irdma_pci_f *rf, bool privileged, enum irdma_vers v
 	info.entry_type = rf->sd_type;
 
 	for (i = 0; i < IW_HMC_OBJ_TYPE_NUM; i++) {
+		if (iw_hmc_obj_types[i] == IRDMA_HMC_IW_PBLE)
+			continue;
 		if (dev->hmc_info->hmc_obj[iw_hmc_obj_types[i]].cnt) {
 			info.rsrc_type = iw_hmc_obj_types[i];
 			info.count = dev->hmc_info->hmc_obj[info.rsrc_type].cnt;
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 827ee3040bea..2361caa38547 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -443,6 +443,10 @@ static int translate_eth_ext_proto_oper(u32 eth_proto_oper, u16 *active_speed,
 		*active_width = IB_WIDTH_2X;
 		*active_speed = IB_SPEED_NDR;
 		break;
+	case MLX5E_PROT_MASK(MLX5E_400GAUI_8):
+		*active_width = IB_WIDTH_8X;
+		*active_speed = IB_SPEED_HDR;
+		break;
 	case MLX5E_PROT_MASK(MLX5E_400GAUI_4_400GBASE_CR4_KR4):
 		*active_width = IB_WIDTH_4X;
 		*active_speed = IB_SPEED_NDR;
diff --git a/drivers/mtd/mtdblock.c b/drivers/mtd/mtdblock.c
index 1e94e7d10b8b..a0a1194dc1d9 100644
--- a/drivers/mtd/mtdblock.c
+++ b/drivers/mtd/mtdblock.c
@@ -153,7 +153,7 @@ static int do_cached_write (struct mtdblk_dev *mtdblk, unsigned long pos,
 				mtdblk->cache_state = STATE_EMPTY;
 				ret = mtd_read(mtd, sect_start, sect_size,
 					       &retlen, mtdblk->cache_data);
-				if (ret)
+				if (ret && !mtd_is_bitflip(ret))
 					return ret;
 				if (retlen != sect_size)
 					return -EIO;
@@ -188,8 +188,12 @@ static int do_cached_read (struct mtdblk_dev *mtdblk, unsigned long pos,
 	pr_debug("mtdblock: read on \"%s\" at 0x%lx, size 0x%x\n",
 			mtd->name, pos, len);
 
-	if (!sect_size)
-		return mtd_read(mtd, pos, len, &retlen, buf);
+	if (!sect_size) {
+		ret = mtd_read(mtd, pos, len, &retlen, buf);
+		if (ret && !mtd_is_bitflip(ret))
+			return ret;
+		return 0;
+	}
 
 	while (len > 0) {
 		unsigned long sect_start = (pos/sect_size)*sect_size;
@@ -209,7 +213,7 @@ static int do_cached_read (struct mtdblk_dev *mtdblk, unsigned long pos,
 			memcpy (buf, mtdblk->cache_data + offset, size);
 		} else {
 			ret = mtd_read(mtd, pos, size, &retlen, buf);
-			if (ret)
+			if (ret && !mtd_is_bitflip(ret))
 				return ret;
 			if (retlen != size)
 				return -EIO;
diff --git a/drivers/mtd/nand/raw/meson_nand.c b/drivers/mtd/nand/raw/meson_nand.c
index 4fd20e70aabd..c66edabec9f1 100644
--- a/drivers/mtd/nand/raw/meson_nand.c
+++ b/drivers/mtd/nand/raw/meson_nand.c
@@ -276,7 +276,7 @@ static void meson_nfc_cmd_access(struct nand_chip *nand, int raw, bool dir,
 
 	if (raw) {
 		len = mtd->writesize + mtd->oobsize;
-		cmd = (len & GENMASK(5, 0)) | scrambler | DMA_DIR(dir);
+		cmd = (len & GENMASK(13, 0)) | scrambler | DMA_DIR(dir);
 		writel(cmd, nfc->reg_base + NFC_REG_CMD);
 		return;
 	}
@@ -540,7 +540,7 @@ static int meson_nfc_read_buf(struct nand_chip *nand, u8 *buf, int len)
 	if (ret)
 		goto out;
 
-	cmd = NFC_CMD_N2M | (len & GENMASK(5, 0));
+	cmd = NFC_CMD_N2M | (len & GENMASK(13, 0));
 	writel(cmd, nfc->reg_base + NFC_REG_CMD);
 
 	meson_nfc_drain_cmd(nfc);
@@ -564,7 +564,7 @@ static int meson_nfc_write_buf(struct nand_chip *nand, u8 *buf, int len)
 	if (ret)
 		return ret;
 
-	cmd = NFC_CMD_M2N | (len & GENMASK(5, 0));
+	cmd = NFC_CMD_M2N | (len & GENMASK(13, 0));
 	writel(cmd, nfc->reg_base + NFC_REG_CMD);
 
 	meson_nfc_drain_cmd(nfc);
diff --git a/drivers/mtd/nand/raw/stm32_fmc2_nand.c b/drivers/mtd/nand/raw/stm32_fmc2_nand.c
index 1c277fbb91f2..1ac8c4887ce0 100644
--- a/drivers/mtd/nand/raw/stm32_fmc2_nand.c
+++ b/drivers/mtd/nand/raw/stm32_fmc2_nand.c
@@ -1527,6 +1527,9 @@ static int stm32_fmc2_nfc_setup_interface(struct nand_chip *chip, int chipnr,
 	if (IS_ERR(sdrt))
 		return PTR_ERR(sdrt);
 
+	if (conf->timings.mode > 3)
+		return -EOPNOTSUPP;
+
 	if (chipnr == NAND_DATA_IFACE_CHECK_ONLY)
 		return 0;
 
diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index 3499ff2649d5..762dc14aef74 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -664,12 +664,6 @@ static int io_init(struct ubi_device *ubi, int max_beb_per1024)
 	ubi->ec_hdr_alsize = ALIGN(UBI_EC_HDR_SIZE, ubi->hdrs_min_io_size);
 	ubi->vid_hdr_alsize = ALIGN(UBI_VID_HDR_SIZE, ubi->hdrs_min_io_size);
 
-	if (ubi->vid_hdr_offset && ((ubi->vid_hdr_offset + UBI_VID_HDR_SIZE) >
-	    ubi->vid_hdr_alsize)) {
-		ubi_err(ubi, "VID header offset %d too large.", ubi->vid_hdr_offset);
-		return -EINVAL;
-	}
-
 	dbg_gen("min_io_size      %d", ubi->min_io_size);
 	dbg_gen("max_write_size   %d", ubi->max_write_size);
 	dbg_gen("hdrs_min_io_size %d", ubi->hdrs_min_io_size);
@@ -687,6 +681,21 @@ static int io_init(struct ubi_device *ubi, int max_beb_per1024)
 						ubi->vid_hdr_aloffset;
 	}
 
+	/*
+	 * Memory allocation for VID header is ubi->vid_hdr_alsize
+	 * which is described in comments in io.c.
+	 * Make sure VID header shift + UBI_VID_HDR_SIZE not exceeds
+	 * ubi->vid_hdr_alsize, so that all vid header operations
+	 * won't access memory out of bounds.
+	 */
+	if ((ubi->vid_hdr_shift + UBI_VID_HDR_SIZE) > ubi->vid_hdr_alsize) {
+		ubi_err(ubi, "Invalid VID header offset %d, VID header shift(%d)"
+			" + VID header size(%zu) > VID header aligned size(%d).",
+			ubi->vid_hdr_offset, ubi->vid_hdr_shift,
+			UBI_VID_HDR_SIZE, ubi->vid_hdr_alsize);
+		return -EINVAL;
+	}
+
 	/* Similar for the data offset */
 	ubi->leb_start = ubi->vid_hdr_offset + UBI_VID_HDR_SIZE;
 	ubi->leb_start = ALIGN(ubi->leb_start, ubi->min_io_size);
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 2ee0e60c43c2..4427018ad4d9 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -575,7 +575,7 @@ static int erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk,
  * @vol_id: the volume ID that last used this PEB
  * @lnum: the last used logical eraseblock number for the PEB
  * @torture: if the physical eraseblock has to be tortured
- * @nested: denotes whether the work_sem is already held in read mode
+ * @nested: denotes whether the work_sem is already held
  *
  * This function returns zero in case of success and a %-ENOMEM in case of
  * failure.
@@ -1121,7 +1121,7 @@ static int __erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk)
 		int err1;
 
 		/* Re-schedule the LEB for erasure */
-		err1 = schedule_erase(ubi, e, vol_id, lnum, 0, false);
+		err1 = schedule_erase(ubi, e, vol_id, lnum, 0, true);
 		if (err1) {
 			spin_lock(&ubi->wl_lock);
 			wl_entry_destroy(ubi, e);
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 906c5bbefaac..ddadb1822d89 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -1044,6 +1044,10 @@ static dma_addr_t macb_get_addr(struct macb *bp, struct macb_dma_desc *desc)
 	}
 #endif
 	addr |= MACB_BF(RX_WADDR, MACB_BFEXT(RX_WADDR, desc->addr));
+#ifdef CONFIG_MACB_USE_HWSTAMP
+	if (bp->hw_dma_cap & HW_DMA_CAP_PTP)
+		addr &= ~GEM_BIT(DMA_RXVALID);
+#endif
 	return addr;
 }
 
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c
index 87f76bac2e46..eb827b86ecae 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c
@@ -628,7 +628,13 @@ int qlcnic_fw_create_ctx(struct qlcnic_adapter *dev)
 	int i, err, ring;
 
 	if (dev->flags & QLCNIC_NEED_FLR) {
-		pci_reset_function(dev->pdev);
+		err = pci_reset_function(dev->pdev);
+		if (err) {
+			dev_err(&dev->pdev->dev,
+				"Adapter reset failed (%d). Please reboot\n",
+				err);
+			return err;
+		}
 		dev->flags &= ~QLCNIC_NEED_FLR;
 	}
 
diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/niu.c
index a68a01d1b2b1..3fdc7c9824a3 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -4503,7 +4503,7 @@ static int niu_alloc_channels(struct niu *np)
 
 		err = niu_rbr_fill(np, rp, GFP_KERNEL);
 		if (err)
-			return err;
+			goto out_err;
 	}
 
 	tx_rings = kcalloc(num_tx_rings, sizeof(struct tx_ring_info),
diff --git a/drivers/net/phy/nxp-c45-tja11xx.c b/drivers/net/phy/nxp-c45-tja11xx.c
index fbb64aa32404..a3196c04caf6 100644
--- a/drivers/net/phy/nxp-c45-tja11xx.c
+++ b/drivers/net/phy/nxp-c45-tja11xx.c
@@ -168,7 +168,7 @@
 #define MAX_ID_PS			2260U
 #define DEFAULT_ID_PS			2000U
 
-#define PPM_TO_SUBNS_INC(ppb)	div_u64(GENMASK(31, 0) * (ppb) * \
+#define PPM_TO_SUBNS_INC(ppb)	div_u64(GENMASK_ULL(31, 0) * (ppb) * \
 					PTP_CLK_PERIOD_100BT1, NSEC_PER_SEC)
 
 #define NXP_C45_SKB_CB(skb)	((struct nxp_c45_skb_cb *)(skb)->cb)
@@ -1117,6 +1117,17 @@ static int nxp_c45_probe(struct phy_device *phydev)
 	return ret;
 }
 
+static void nxp_c45_remove(struct phy_device *phydev)
+{
+	struct nxp_c45_phy *priv = phydev->priv;
+
+	if (priv->ptp_clock)
+		ptp_clock_unregister(priv->ptp_clock);
+
+	skb_queue_purge(&priv->tx_queue);
+	skb_queue_purge(&priv->rx_queue);
+}
+
 static struct phy_driver nxp_c45_driver[] = {
 	{
 		PHY_ID_MATCH_MODEL(PHY_ID_TJA_1103),
@@ -1139,6 +1150,7 @@ static struct phy_driver nxp_c45_driver[] = {
 		.set_loopback		= genphy_c45_loopback,
 		.get_sqi		= nxp_c45_get_sqi,
 		.get_sqi_max		= nxp_c45_get_sqi_max,
+		.remove			= nxp_c45_remove,
 	},
 };
 
diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 028a5df5c538..d5918605eae6 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -208,6 +208,12 @@ static const enum gpiod_flags gpio_flags[] = {
  */
 #define SFP_PHY_ADDR	22
 
+/* SFP_EEPROM_BLOCK_SIZE is the size of data chunk to read the EEPROM
+ * at a time. Some SFP modules and also some Linux I2C drivers do not like
+ * reads longer than 16 bytes.
+ */
+#define SFP_EEPROM_BLOCK_SIZE	16
+
 struct sff_data {
 	unsigned int gpios;
 	bool (*module_supported)(const struct sfp_eeprom_id *id);
@@ -1806,11 +1812,7 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 	u8 check;
 	int ret;
 
-	/* Some SFP modules and also some Linux I2C drivers do not like reads
-	 * longer than 16 bytes, so read the EEPROM in chunks of 16 bytes at
-	 * a time.
-	 */
-	sfp->i2c_block_size = 16;
+	sfp->i2c_block_size = SFP_EEPROM_BLOCK_SIZE;
 
 	ret = sfp_read(sfp, false, 0, &id.base, sizeof(id.base));
 	if (ret < 0) {
@@ -2462,6 +2464,7 @@ static struct sfp *sfp_alloc(struct device *dev)
 		return ERR_PTR(-ENOMEM);
 
 	sfp->dev = dev;
+	sfp->i2c_block_size = SFP_EEPROM_BLOCK_SIZE;
 
 	mutex_init(&sfp->sm_mutex);
 	mutex_init(&sfp->st_mutex);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 56c7a68a6491..fa7de3e47b8c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -820,7 +820,10 @@ void iwl_mvm_mac_itxq_xmit(struct ieee80211_hw *hw, struct ieee80211_txq *txq)
 
 	rcu_read_lock();
 	do {
-		while (likely(!mvmtxq->stopped &&
+		while (likely(!test_bit(IWL_MVM_TXQ_STATE_STOP_FULL,
+					&mvmtxq->state) &&
+			      !test_bit(IWL_MVM_TXQ_STATE_STOP_REDIRECT,
+					&mvmtxq->state) &&
 			      !test_bit(IWL_MVM_STATUS_IN_D3, &mvm->status))) {
 			skb = ieee80211_tx_dequeue(hw, txq);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 46af8dd2dc93..6b59425dbdb1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -727,7 +727,9 @@ struct iwl_mvm_txq {
 	struct list_head list;
 	u16 txq_id;
 	atomic_t tx_request;
-	bool stopped;
+#define IWL_MVM_TXQ_STATE_STOP_FULL	0
+#define IWL_MVM_TXQ_STATE_STOP_REDIRECT	1
+	unsigned long state;
 };
 
 static inline struct iwl_mvm_txq *
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index eeb81808db08..3ee4b3ecd0c8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -1304,7 +1304,10 @@ static void iwl_mvm_queue_state_change(struct iwl_op_mode *op_mode,
 
 		txq = sta->txq[tid];
 		mvmtxq = iwl_mvm_txq_from_mac80211(txq);
-		mvmtxq->stopped = !start;
+		if (start)
+			clear_bit(IWL_MVM_TXQ_STATE_STOP_FULL, &mvmtxq->state);
+		else
+			set_bit(IWL_MVM_TXQ_STATE_STOP_FULL, &mvmtxq->state);
 
 		if (start && mvmsta->sta_state != IEEE80211_STA_NOTEXIST)
 			iwl_mvm_mac_itxq_xmit(mvm->hw, txq);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 1bb456daff9e..45dfee3ad8c6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -640,7 +640,7 @@ static int iwl_mvm_redirect_queue(struct iwl_mvm *mvm, int queue, int tid,
 			    queue, iwl_mvm_ac_to_tx_fifo[ac]);
 
 	/* Stop the queue and wait for it to empty */
-	txq->stopped = true;
+	set_bit(IWL_MVM_TXQ_STATE_STOP_REDIRECT, &txq->state);
 
 	ret = iwl_trans_wait_tx_queues_empty(mvm->trans, BIT(queue));
 	if (ret) {
@@ -683,7 +683,7 @@ static int iwl_mvm_redirect_queue(struct iwl_mvm *mvm, int queue, int tid,
 
 out:
 	/* Continue using the queue */
-	txq->stopped = false;
+	clear_bit(IWL_MVM_TXQ_STATE_STOP_REDIRECT, &txq->state);
 
 	return ret;
 }
diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index d5fb29400bad..94a6bbcae2d3 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -184,7 +184,7 @@ static const struct mwifiex_pcie_device mwifiex_pcie8997 = {
 	.can_ext_scan = true,
 };
 
-static const struct of_device_id mwifiex_pcie_of_match_table[] = {
+static const struct of_device_id mwifiex_pcie_of_match_table[] __maybe_unused = {
 	{ .compatible = "pci11ab,2b42" },
 	{ .compatible = "pci1b4b,2b42" },
 	{ }
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index 7fb6eef40928..b09e60fedeb1 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -484,7 +484,7 @@ static struct memory_type_mapping mem_type_mapping_tbl[] = {
 	{"EXTLAST", NULL, 0, 0xFE},
 };
 
-static const struct of_device_id mwifiex_sdio_of_match_table[] = {
+static const struct of_device_id mwifiex_sdio_of_match_table[] __maybe_unused = {
 	{ .compatible = "marvell,sd8787" },
 	{ .compatible = "marvell,sd8897" },
 	{ .compatible = "marvell,sd8997" },
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 6539332b42b3..c3acef6c3291 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3388,6 +3388,21 @@ static const struct pci_device_id nvme_id_table[] = {
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1e4B, 0x1202),   /* MAXIO MAP1202 */
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
+	{ PCI_DEVICE(0x1cc1, 0x5350),   /* ADATA XPG GAMMIX S50 */
+		.driver_data = NVME_QUIRK_BOGUS_NID, },
+	{ PCI_DEVICE(0x1e49, 0x0021),   /* ZHITAI TiPro5000 NVMe SSD */
+		.driver_data = NVME_QUIRK_NO_DEEPEST_PS, },
+	{ PCI_DEVICE(0x1e49, 0x0041),   /* ZHITAI TiPro7000 NVMe SSD */
+		.driver_data = NVME_QUIRK_NO_DEEPEST_PS, },
+	{ PCI_DEVICE(0xc0a9, 0x540a),   /* Crucial P2 */
+		.driver_data = NVME_QUIRK_BOGUS_NID, },
+	{ PCI_DEVICE(0x1d97, 0x2263), /* Lexar NM610 */
+		.driver_data = NVME_QUIRK_BOGUS_NID, },
+	{ PCI_DEVICE(0x1d97, 0x2269), /* Lexar NM760 */
+		.driver_data = NVME_QUIRK_BOGUS_NID |
+				NVME_QUIRK_IGNORE_DEV_SUBNQN, },
+	{ PCI_DEVICE(0x10ec, 0x5763), /* TEAMGROUP T-FORCE CARDEA ZERO Z330 SSD */
+		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMAZON, 0x0061),
 		.driver_data = NVME_QUIRK_DMA_ADDRESS_BITS_48, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMAZON, 0x0065),
diff --git a/drivers/pinctrl/pinctrl-amd.c b/drivers/pinctrl/pinctrl-amd.c
index 0a77b8426817..52d1fe5ec3e7 100644
--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -863,34 +863,32 @@ static const struct pinconf_ops amd_pinconf_ops = {
 	.pin_config_group_set = amd_pinconf_group_set,
 };
 
-static void amd_gpio_irq_init_pin(struct amd_gpio *gpio_dev, int pin)
+static void amd_gpio_irq_init(struct amd_gpio *gpio_dev)
 {
-	const struct pin_desc *pd;
+	struct pinctrl_desc *desc = gpio_dev->pctrl->desc;
 	unsigned long flags;
 	u32 pin_reg, mask;
+	int i;
 
 	mask = BIT(WAKE_CNTRL_OFF_S0I3) | BIT(WAKE_CNTRL_OFF_S3) |
 		BIT(INTERRUPT_MASK_OFF) | BIT(INTERRUPT_ENABLE_OFF) |
 		BIT(WAKE_CNTRL_OFF_S4);
 
-	pd = pin_desc_get(gpio_dev->pctrl, pin);
-	if (!pd)
-		return;
+	for (i = 0; i < desc->npins; i++) {
+		int pin = desc->pins[i].number;
+		const struct pin_desc *pd = pin_desc_get(gpio_dev->pctrl, pin);
 
-	raw_spin_lock_irqsave(&gpio_dev->lock, flags);
-	pin_reg = readl(gpio_dev->base + pin * 4);
-	pin_reg &= ~mask;
-	writel(pin_reg, gpio_dev->base + pin * 4);
-	raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
-}
+		if (!pd)
+			continue;
 
-static void amd_gpio_irq_init(struct amd_gpio *gpio_dev)
-{
-	struct pinctrl_desc *desc = gpio_dev->pctrl->desc;
-	int i;
+		raw_spin_lock_irqsave(&gpio_dev->lock, flags);
 
-	for (i = 0; i < desc->npins; i++)
-		amd_gpio_irq_init_pin(gpio_dev, i);
+		pin_reg = readl(gpio_dev->base + i * 4);
+		pin_reg &= ~mask;
+		writel(pin_reg, gpio_dev->base + i * 4);
+
+		raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
+	}
 }
 
 #ifdef CONFIG_PM_SLEEP
@@ -943,10 +941,8 @@ static int amd_gpio_resume(struct device *dev)
 	for (i = 0; i < desc->npins; i++) {
 		int pin = desc->pins[i].number;
 
-		if (!amd_gpio_should_save(gpio_dev, pin)) {
-			amd_gpio_irq_init_pin(gpio_dev, pin);
+		if (!amd_gpio_should_save(gpio_dev, pin))
 			continue;
-		}
 
 		raw_spin_lock_irqsave(&gpio_dev->lock, flags);
 		gpio_dev->saved_regs[i] |= readl(gpio_dev->base + pin * 4) & PIN_IRQ_PENDING;
diff --git a/drivers/power/supply/cros_usbpd-charger.c b/drivers/power/supply/cros_usbpd-charger.c
index d89e08efd2ad..0a4f02e4ae7b 100644
--- a/drivers/power/supply/cros_usbpd-charger.c
+++ b/drivers/power/supply/cros_usbpd-charger.c
@@ -276,7 +276,7 @@ static int cros_usbpd_charger_get_power_info(struct port_data *port)
 		port->psy_current_max = 0;
 		break;
 	default:
-		dev_err(dev, "Port %d: default case!\n", port->port_number);
+		dev_dbg(dev, "Port %d: default case!\n", port->port_number);
 		port->psy_usb_type = POWER_SUPPLY_USB_TYPE_SDP;
 	}
 
diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 1707d6d144d2..6a1428d453f3 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -503,9 +503,6 @@ static int ses_enclosure_find_by_addr(struct enclosure_device *edev,
 	int i;
 	struct ses_component *scomp;
 
-	if (!edev->component[0].scratch)
-		return 0;
-
 	for (i = 0; i < edev->components; i++) {
 		scomp = edev->component[i].scratch;
 		if (scomp->addr != efd->addr)
@@ -596,8 +593,10 @@ static void ses_enclosure_data_process(struct enclosure_device *edev,
 						components++,
 						type_ptr[0],
 						name);
-				else
+				else if (components < edev->components)
 					ecomp = &edev->component[components++];
+				else
+					ecomp = ERR_PTR(-EINVAL);
 
 				if (!IS_ERR(ecomp)) {
 					if (addl_desc_ptr) {
@@ -728,11 +727,6 @@ static int ses_intf_add(struct device *cdev,
 			components += type_ptr[1];
 	}
 
-	if (components == 0) {
-		sdev_printk(KERN_WARNING, sdev, "enclosure has no enumerated components\n");
-		goto err_free;
-	}
-
 	ses_dev->page1 = buf;
 	ses_dev->page1_len = len;
 	buf = NULL;
@@ -774,9 +768,11 @@ static int ses_intf_add(struct device *cdev,
 		buf = NULL;
 	}
 page2_not_supported:
-	scomp = kcalloc(components, sizeof(struct ses_component), GFP_KERNEL);
-	if (!scomp)
-		goto err_free;
+	if (components > 0) {
+		scomp = kcalloc(components, sizeof(struct ses_component), GFP_KERNEL);
+		if (!scomp)
+			goto err_free;
+	}
 
 	edev = enclosure_register(cdev->parent, dev_name(&sdev->sdev_gendev),
 				  components, &ses_enclosure_callbacks);
diff --git a/drivers/video/fbdev/core/fbmem.c b/drivers/video/fbdev/core/fbmem.c
index 528c87ff14d8..1b288a613a6e 100644
--- a/drivers/video/fbdev/core/fbmem.c
+++ b/drivers/video/fbdev/core/fbmem.c
@@ -1119,6 +1119,8 @@ static long do_fb_ioctl(struct fb_info *info, unsigned int cmd,
 	case FBIOPUT_VSCREENINFO:
 		if (copy_from_user(&var, argp, sizeof(var)))
 			return -EFAULT;
+		/* only for kernel-internal use */
+		var.activate &= ~FB_ACTIVATE_KD_TEXT;
 		console_lock();
 		lock_fb_info(info);
 		ret = fbcon_modechange_possible(info, &var);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index ce2da06c9d7b..a4bfa5acaf9f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2318,6 +2318,23 @@ static int btrfs_init_csum_hash(struct btrfs_fs_info *fs_info, u16 csum_type)
 
 	fs_info->csum_shash = csum_shash;
 
+	/*
+	 * Check if the checksum implementation is a fast accelerated one.
+	 * As-is this is a bit of a hack and should be replaced once the csum
+	 * implementations provide that information themselves.
+	 */
+	switch (csum_type) {
+	case BTRFS_CSUM_TYPE_CRC32:
+		if (!strstr(crypto_shash_driver_name(csum_shash), "generic"))
+			set_bit(BTRFS_FS_CSUM_IMPL_FAST, &fs_info->flags);
+		break;
+	default:
+		break;
+	}
+
+	btrfs_info(fs_info, "using %s (%s) checksum algorithm",
+			btrfs_super_csum_name(csum_type),
+			crypto_shash_driver_name(csum_shash));
 	return 0;
 }
 
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 4ff55457f902..ea23b83fc96b 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1749,8 +1749,6 @@ static struct dentry *btrfs_mount_root(struct file_system_type *fs_type,
 	} else {
 		snprintf(s->s_id, sizeof(s->s_id), "%pg", bdev);
 		btrfs_sb(s)->bdev_holder = fs_type;
-		if (!strstr(crc32c_impl(), "generic"))
-			set_bit(BTRFS_FS_CSUM_IMPL_FAST, &fs_info->flags);
 		error = btrfs_fill_super(s, fs_devices, data);
 	}
 	if (!error)
diff --git a/include/linux/counter.h b/include/linux/counter.h
index d16ce2819b48..c72dda6d6af5 100644
--- a/include/linux/counter.h
+++ b/include/linux/counter.h
@@ -6,42 +6,184 @@
 #ifndef _COUNTER_H_
 #define _COUNTER_H_
 
-#include <linux/counter_enum.h>
 #include <linux/device.h>
+#include <linux/kernel.h>
 #include <linux/types.h>
 
+struct counter_device;
+struct counter_count;
+struct counter_synapse;
+struct counter_signal;
+
+enum counter_comp_type {
+	COUNTER_COMP_U8,
+	COUNTER_COMP_U64,
+	COUNTER_COMP_BOOL,
+	COUNTER_COMP_SIGNAL_LEVEL,
+	COUNTER_COMP_FUNCTION,
+	COUNTER_COMP_SYNAPSE_ACTION,
+	COUNTER_COMP_ENUM,
+	COUNTER_COMP_COUNT_DIRECTION,
+	COUNTER_COMP_COUNT_MODE,
+};
+
+enum counter_scope {
+	COUNTER_SCOPE_DEVICE,
+	COUNTER_SCOPE_SIGNAL,
+	COUNTER_SCOPE_COUNT,
+};
+
 enum counter_count_direction {
-	COUNTER_COUNT_DIRECTION_FORWARD = 0,
-	COUNTER_COUNT_DIRECTION_BACKWARD
+	COUNTER_COUNT_DIRECTION_FORWARD,
+	COUNTER_COUNT_DIRECTION_BACKWARD,
 };
-extern const char *const counter_count_direction_str[2];
 
 enum counter_count_mode {
-	COUNTER_COUNT_MODE_NORMAL = 0,
+	COUNTER_COUNT_MODE_NORMAL,
 	COUNTER_COUNT_MODE_RANGE_LIMIT,
 	COUNTER_COUNT_MODE_NON_RECYCLE,
-	COUNTER_COUNT_MODE_MODULO_N
+	COUNTER_COUNT_MODE_MODULO_N,
 };
-extern const char *const counter_count_mode_str[4];
 
-struct counter_device;
-struct counter_signal;
+enum counter_function {
+	COUNTER_FUNCTION_INCREASE,
+	COUNTER_FUNCTION_DECREASE,
+	COUNTER_FUNCTION_PULSE_DIRECTION,
+	COUNTER_FUNCTION_QUADRATURE_X1_A,
+	COUNTER_FUNCTION_QUADRATURE_X1_B,
+	COUNTER_FUNCTION_QUADRATURE_X2_A,
+	COUNTER_FUNCTION_QUADRATURE_X2_B,
+	COUNTER_FUNCTION_QUADRATURE_X4,
+};
+
+enum counter_signal_level {
+	COUNTER_SIGNAL_LEVEL_LOW,
+	COUNTER_SIGNAL_LEVEL_HIGH,
+};
+
+enum counter_synapse_action {
+	COUNTER_SYNAPSE_ACTION_NONE,
+	COUNTER_SYNAPSE_ACTION_RISING_EDGE,
+	COUNTER_SYNAPSE_ACTION_FALLING_EDGE,
+	COUNTER_SYNAPSE_ACTION_BOTH_EDGES,
+};
 
 /**
- * struct counter_signal_ext - Counter Signal extensions
- * @name:	attribute name
- * @read:	read callback for this attribute; may be NULL
- * @write:	write callback for this attribute; may be NULL
- * @priv:	data private to the driver
+ * struct counter_comp - Counter component node
+ * @type:		Counter component data type
+ * @name:		device-specific component name
+ * @priv:		component-relevant data
+ * @action_read:		Synapse action mode read callback. The read value of the
+ *			respective Synapse action mode should be passed back via
+ *			the action parameter.
+ * @device_u8_read:		Device u8 component read callback. The read value of the
+ *			respective Device u8 component should be passed back via
+ *			the val parameter.
+ * @count_u8_read:		Count u8 component read callback. The read value of the
+ *			respective Count u8 component should be passed back via
+ *			the val parameter.
+ * @signal_u8_read:		Signal u8 component read callback. The read value of the
+ *			respective Signal u8 component should be passed back via
+ *			the val parameter.
+ * @device_u32_read:		Device u32 component read callback. The read value of
+ *			the respective Device u32 component should be passed
+ *			back via the val parameter.
+ * @count_u32_read:		Count u32 component read callback. The read value of the
+ *			respective Count u32 component should be passed back via
+ *			the val parameter.
+ * @signal_u32_read:		Signal u32 component read callback. The read value of
+ *			the respective Signal u32 component should be passed
+ *			back via the val parameter.
+ * @device_u64_read:		Device u64 component read callback. The read value of
+ *			the respective Device u64 component should be passed
+ *			back via the val parameter.
+ * @count_u64_read:		Count u64 component read callback. The read value of the
+ *			respective Count u64 component should be passed back via
+ *			the val parameter.
+ * @signal_u64_read:		Signal u64 component read callback. The read value of
+ *			the respective Signal u64 component should be passed
+ *			back via the val parameter.
+ * @action_write:		Synapse action mode write callback. The write value of
+ *			the respective Synapse action mode is passed via the
+ *			action parameter.
+ * @device_u8_write:		Device u8 component write callback. The write value of
+ *			the respective Device u8 component is passed via the val
+ *			parameter.
+ * @count_u8_write:		Count u8 component write callback. The write value of
+ *			the respective Count u8 component is passed via the val
+ *			parameter.
+ * @signal_u8_write:		Signal u8 component write callback. The write value of
+ *			the respective Signal u8 component is passed via the val
+ *			parameter.
+ * @device_u32_write:		Device u32 component write callback. The write value of
+ *			the respective Device u32 component is passed via the
+ *			val parameter.
+ * @count_u32_write:		Count u32 component write callback. The write value of
+ *			the respective Count u32 component is passed via the val
+ *			parameter.
+ * @signal_u32_write:		Signal u32 component write callback. The write value of
+ *			the respective Signal u32 component is passed via the
+ *			val parameter.
+ * @device_u64_write:		Device u64 component write callback. The write value of
+ *			the respective Device u64 component is passed via the
+ *			val parameter.
+ * @count_u64_write:		Count u64 component write callback. The write value of
+ *			the respective Count u64 component is passed via the val
+ *			parameter.
+ * @signal_u64_write:		Signal u64 component write callback. The write value of
+ *			the respective Signal u64 component is passed via the
+ *			val parameter.
  */
-struct counter_signal_ext {
+struct counter_comp {
+	enum counter_comp_type type;
 	const char *name;
-	ssize_t (*read)(struct counter_device *counter,
-			struct counter_signal *signal, void *priv, char *buf);
-	ssize_t (*write)(struct counter_device *counter,
-			 struct counter_signal *signal, void *priv,
-			 const char *buf, size_t len);
 	void *priv;
+	union {
+		int (*action_read)(struct counter_device *counter,
+				   struct counter_count *count,
+				   struct counter_synapse *synapse,
+				   enum counter_synapse_action *action);
+		int (*device_u8_read)(struct counter_device *counter, u8 *val);
+		int (*count_u8_read)(struct counter_device *counter,
+				     struct counter_count *count, u8 *val);
+		int (*signal_u8_read)(struct counter_device *counter,
+				      struct counter_signal *signal, u8 *val);
+		int (*device_u32_read)(struct counter_device *counter,
+				       u32 *val);
+		int (*count_u32_read)(struct counter_device *counter,
+				      struct counter_count *count, u32 *val);
+		int (*signal_u32_read)(struct counter_device *counter,
+				       struct counter_signal *signal, u32 *val);
+		int (*device_u64_read)(struct counter_device *counter,
+				       u64 *val);
+		int (*count_u64_read)(struct counter_device *counter,
+				      struct counter_count *count, u64 *val);
+		int (*signal_u64_read)(struct counter_device *counter,
+				       struct counter_signal *signal, u64 *val);
+	};
+	union {
+		int (*action_write)(struct counter_device *counter,
+				    struct counter_count *count,
+				    struct counter_synapse *synapse,
+				    enum counter_synapse_action action);
+		int (*device_u8_write)(struct counter_device *counter, u8 val);
+		int (*count_u8_write)(struct counter_device *counter,
+				      struct counter_count *count, u8 val);
+		int (*signal_u8_write)(struct counter_device *counter,
+				       struct counter_signal *signal, u8 val);
+		int (*device_u32_write)(struct counter_device *counter,
+					u32 val);
+		int (*count_u32_write)(struct counter_device *counter,
+				       struct counter_count *count, u32 val);
+		int (*signal_u32_write)(struct counter_device *counter,
+					struct counter_signal *signal, u32 val);
+		int (*device_u64_write)(struct counter_device *counter,
+					u64 val);
+		int (*count_u64_write)(struct counter_device *counter,
+				       struct counter_count *count, u64 val);
+		int (*signal_u64_write)(struct counter_device *counter,
+					struct counter_signal *signal, u64 val);
+	};
 };
 
 /**
@@ -51,248 +193,52 @@ struct counter_signal_ext {
  *		as it appears in the datasheet documentation
  * @ext:	optional array of Counter Signal extensions
  * @num_ext:	number of Counter Signal extensions specified in @ext
- * @priv:	optional private data supplied by driver
  */
 struct counter_signal {
 	int id;
 	const char *name;
 
-	const struct counter_signal_ext *ext;
+	struct counter_comp *ext;
 	size_t num_ext;
-
-	void *priv;
-};
-
-/**
- * struct counter_signal_enum_ext - Signal enum extension attribute
- * @items:	Array of strings
- * @num_items:	Number of items specified in @items
- * @set:	Set callback function; may be NULL
- * @get:	Get callback function; may be NULL
- *
- * The counter_signal_enum_ext structure can be used to implement enum style
- * Signal extension attributes. Enum style attributes are those which have a set
- * of strings that map to unsigned integer values. The Generic Counter Signal
- * enum extension helper code takes care of mapping between value and string, as
- * well as generating a "_available" file which contains a list of all available
- * items. The get callback is used to query the currently active item; the index
- * of the item within the respective items array is returned via the 'item'
- * parameter. The set callback is called when the attribute is updated; the
- * 'item' parameter contains the index of the newly activated item within the
- * respective items array.
- */
-struct counter_signal_enum_ext {
-	const char * const *items;
-	size_t num_items;
-	int (*get)(struct counter_device *counter,
-		   struct counter_signal *signal, size_t *item);
-	int (*set)(struct counter_device *counter,
-		   struct counter_signal *signal, size_t item);
-};
-
-/**
- * COUNTER_SIGNAL_ENUM() - Initialize Signal enum extension
- * @_name:	Attribute name
- * @_e:		Pointer to a counter_signal_enum_ext structure
- *
- * This should usually be used together with COUNTER_SIGNAL_ENUM_AVAILABLE()
- */
-#define COUNTER_SIGNAL_ENUM(_name, _e) \
-{ \
-	.name = (_name), \
-	.read = counter_signal_enum_read, \
-	.write = counter_signal_enum_write, \
-	.priv = (_e) \
-}
-
-/**
- * COUNTER_SIGNAL_ENUM_AVAILABLE() - Initialize Signal enum available extension
- * @_name:	Attribute name ("_available" will be appended to the name)
- * @_e:		Pointer to a counter_signal_enum_ext structure
- *
- * Creates a read only attribute that lists all the available enum items in a
- * newline separated list. This should usually be used together with
- * COUNTER_SIGNAL_ENUM()
- */
-#define COUNTER_SIGNAL_ENUM_AVAILABLE(_name, _e) \
-{ \
-	.name = (_name "_available"), \
-	.read = counter_signal_enum_available_read, \
-	.priv = (_e) \
-}
-
-enum counter_synapse_action {
-	COUNTER_SYNAPSE_ACTION_NONE = 0,
-	COUNTER_SYNAPSE_ACTION_RISING_EDGE,
-	COUNTER_SYNAPSE_ACTION_FALLING_EDGE,
-	COUNTER_SYNAPSE_ACTION_BOTH_EDGES
 };
 
 /**
  * struct counter_synapse - Counter Synapse node
- * @action:		index of current action mode
  * @actions_list:	array of available action modes
  * @num_actions:	number of action modes specified in @actions_list
  * @signal:		pointer to associated signal
  */
 struct counter_synapse {
-	size_t action;
 	const enum counter_synapse_action *actions_list;
 	size_t num_actions;
 
 	struct counter_signal *signal;
 };
 
-struct counter_count;
-
-/**
- * struct counter_count_ext - Counter Count extension
- * @name:	attribute name
- * @read:	read callback for this attribute; may be NULL
- * @write:	write callback for this attribute; may be NULL
- * @priv:	data private to the driver
- */
-struct counter_count_ext {
-	const char *name;
-	ssize_t (*read)(struct counter_device *counter,
-			struct counter_count *count, void *priv, char *buf);
-	ssize_t (*write)(struct counter_device *counter,
-			 struct counter_count *count, void *priv,
-			 const char *buf, size_t len);
-	void *priv;
-};
-
-enum counter_function {
-	COUNTER_FUNCTION_INCREASE = 0,
-	COUNTER_FUNCTION_DECREASE,
-	COUNTER_FUNCTION_PULSE_DIRECTION,
-	COUNTER_FUNCTION_QUADRATURE_X1_A,
-	COUNTER_FUNCTION_QUADRATURE_X1_B,
-	COUNTER_FUNCTION_QUADRATURE_X2_A,
-	COUNTER_FUNCTION_QUADRATURE_X2_B,
-	COUNTER_FUNCTION_QUADRATURE_X4
-};
-
 /**
  * struct counter_count - Counter Count node
  * @id:			unique ID used to identify Count
  * @name:		device-specific Count name; ideally, this should match
  *			the name as it appears in the datasheet documentation
- * @function:		index of current function mode
  * @functions_list:	array available function modes
  * @num_functions:	number of function modes specified in @functions_list
  * @synapses:		array of synapses for initialization
  * @num_synapses:	number of synapses specified in @synapses
  * @ext:		optional array of Counter Count extensions
  * @num_ext:		number of Counter Count extensions specified in @ext
- * @priv:		optional private data supplied by driver
  */
 struct counter_count {
 	int id;
 	const char *name;
 
-	size_t function;
 	const enum counter_function *functions_list;
 	size_t num_functions;
 
 	struct counter_synapse *synapses;
 	size_t num_synapses;
 
-	const struct counter_count_ext *ext;
+	struct counter_comp *ext;
 	size_t num_ext;
-
-	void *priv;
-};
-
-/**
- * struct counter_count_enum_ext - Count enum extension attribute
- * @items:	Array of strings
- * @num_items:	Number of items specified in @items
- * @set:	Set callback function; may be NULL
- * @get:	Get callback function; may be NULL
- *
- * The counter_count_enum_ext structure can be used to implement enum style
- * Count extension attributes. Enum style attributes are those which have a set
- * of strings that map to unsigned integer values. The Generic Counter Count
- * enum extension helper code takes care of mapping between value and string, as
- * well as generating a "_available" file which contains a list of all available
- * items. The get callback is used to query the currently active item; the index
- * of the item within the respective items array is returned via the 'item'
- * parameter. The set callback is called when the attribute is updated; the
- * 'item' parameter contains the index of the newly activated item within the
- * respective items array.
- */
-struct counter_count_enum_ext {
-	const char * const *items;
-	size_t num_items;
-	int (*get)(struct counter_device *counter, struct counter_count *count,
-		   size_t *item);
-	int (*set)(struct counter_device *counter, struct counter_count *count,
-		   size_t item);
-};
-
-/**
- * COUNTER_COUNT_ENUM() - Initialize Count enum extension
- * @_name:	Attribute name
- * @_e:		Pointer to a counter_count_enum_ext structure
- *
- * This should usually be used together with COUNTER_COUNT_ENUM_AVAILABLE()
- */
-#define COUNTER_COUNT_ENUM(_name, _e) \
-{ \
-	.name = (_name), \
-	.read = counter_count_enum_read, \
-	.write = counter_count_enum_write, \
-	.priv = (_e) \
-}
-
-/**
- * COUNTER_COUNT_ENUM_AVAILABLE() - Initialize Count enum available extension
- * @_name:	Attribute name ("_available" will be appended to the name)
- * @_e:		Pointer to a counter_count_enum_ext structure
- *
- * Creates a read only attribute that lists all the available enum items in a
- * newline separated list. This should usually be used together with
- * COUNTER_COUNT_ENUM()
- */
-#define COUNTER_COUNT_ENUM_AVAILABLE(_name, _e) \
-{ \
-	.name = (_name "_available"), \
-	.read = counter_count_enum_available_read, \
-	.priv = (_e) \
-}
-
-/**
- * struct counter_device_attr_group - internal container for attribute group
- * @attr_group:	Counter sysfs attributes group
- * @attr_list:	list to keep track of created Counter sysfs attributes
- * @num_attr:	number of Counter sysfs attributes
- */
-struct counter_device_attr_group {
-	struct attribute_group attr_group;
-	struct list_head attr_list;
-	size_t num_attr;
-};
-
-/**
- * struct counter_device_state - internal state container for a Counter device
- * @id:			unique ID used to identify the Counter
- * @dev:		internal device structure
- * @groups_list:	attribute groups list (for Signals, Counts, and ext)
- * @num_groups:		number of attribute groups containers
- * @groups:		Counter sysfs attribute groups (to populate @dev.groups)
- */
-struct counter_device_state {
-	int id;
-	struct device dev;
-	struct counter_device_attr_group *groups_list;
-	size_t num_groups;
-	const struct attribute_group **groups;
-};
-
-enum counter_signal_level {
-	COUNTER_SIGNAL_LEVEL_LOW,
-	COUNTER_SIGNAL_LEVEL_HIGH,
 };
 
 /**
@@ -306,117 +252,47 @@ enum counter_signal_level {
  * @count_write:	optional write callback for Count attribute. The write
  *			value for the respective Count is passed in via the val
  *			parameter.
- * @function_get:	function to get the current count function mode. Returns
- *			0 on success and negative error code on error. The index
- *			of the respective Count's returned function mode should
- *			be passed back via the function parameter.
- * @function_set:	function to set the count function mode. function is the
- *			index of the requested function mode from the respective
- *			Count's functions_list array.
- * @action_get:		function to get the current action mode. Returns 0 on
- *			success and negative error code on error. The index of
- *			the respective Synapse's returned action mode should be
- *			passed back via the action parameter.
- * @action_set:		function to set the action mode. action is the index of
- *			the requested action mode from the respective Synapse's
- *			actions_list array.
+ * @function_read:	read callback the Count function modes. The read
+ *			function mode of the respective Count should be passed
+ *			back via the function parameter.
+ * @function_write:	write callback for Count function modes. The function
+ *			mode to write for the respective Count is passed in via
+ *			the function parameter.
+ * @action_read:	read callback the Synapse action modes. The read action
+ *			mode of the respective Synapse should be passed back via
+ *			the action parameter.
+ * @action_write:	write callback for Synapse action modes. The action mode
+ *			to write for the respective Synapse is passed in via the
+ *			action parameter.
  */
 struct counter_ops {
 	int (*signal_read)(struct counter_device *counter,
 			   struct counter_signal *signal,
 			   enum counter_signal_level *level);
 	int (*count_read)(struct counter_device *counter,
-			  struct counter_count *count, unsigned long *val);
+			  struct counter_count *count, u64 *value);
 	int (*count_write)(struct counter_device *counter,
-			   struct counter_count *count, unsigned long val);
-	int (*function_get)(struct counter_device *counter,
-			    struct counter_count *count, size_t *function);
-	int (*function_set)(struct counter_device *counter,
-			    struct counter_count *count, size_t function);
-	int (*action_get)(struct counter_device *counter,
-			  struct counter_count *count,
-			  struct counter_synapse *synapse, size_t *action);
-	int (*action_set)(struct counter_device *counter,
-			  struct counter_count *count,
-			  struct counter_synapse *synapse, size_t action);
-};
-
-/**
- * struct counter_device_ext - Counter device extension
- * @name:	attribute name
- * @read:	read callback for this attribute; may be NULL
- * @write:	write callback for this attribute; may be NULL
- * @priv:	data private to the driver
- */
-struct counter_device_ext {
-	const char *name;
-	ssize_t (*read)(struct counter_device *counter, void *priv, char *buf);
-	ssize_t (*write)(struct counter_device *counter, void *priv,
-			 const char *buf, size_t len);
-	void *priv;
+			   struct counter_count *count, u64 value);
+	int (*function_read)(struct counter_device *counter,
+			     struct counter_count *count,
+			     enum counter_function *function);
+	int (*function_write)(struct counter_device *counter,
+			      struct counter_count *count,
+			      enum counter_function function);
+	int (*action_read)(struct counter_device *counter,
+			   struct counter_count *count,
+			   struct counter_synapse *synapse,
+			   enum counter_synapse_action *action);
+	int (*action_write)(struct counter_device *counter,
+			    struct counter_count *count,
+			    struct counter_synapse *synapse,
+			    enum counter_synapse_action action);
 };
 
-/**
- * struct counter_device_enum_ext - Counter enum extension attribute
- * @items:	Array of strings
- * @num_items:	Number of items specified in @items
- * @set:	Set callback function; may be NULL
- * @get:	Get callback function; may be NULL
- *
- * The counter_device_enum_ext structure can be used to implement enum style
- * Counter extension attributes. Enum style attributes are those which have a
- * set of strings that map to unsigned integer values. The Generic Counter enum
- * extension helper code takes care of mapping between value and string, as well
- * as generating a "_available" file which contains a list of all available
- * items. The get callback is used to query the currently active item; the index
- * of the item within the respective items array is returned via the 'item'
- * parameter. The set callback is called when the attribute is updated; the
- * 'item' parameter contains the index of the newly activated item within the
- * respective items array.
- */
-struct counter_device_enum_ext {
-	const char * const *items;
-	size_t num_items;
-	int (*get)(struct counter_device *counter, size_t *item);
-	int (*set)(struct counter_device *counter, size_t item);
-};
-
-/**
- * COUNTER_DEVICE_ENUM() - Initialize Counter enum extension
- * @_name:	Attribute name
- * @_e:		Pointer to a counter_device_enum_ext structure
- *
- * This should usually be used together with COUNTER_DEVICE_ENUM_AVAILABLE()
- */
-#define COUNTER_DEVICE_ENUM(_name, _e) \
-{ \
-	.name = (_name), \
-	.read = counter_device_enum_read, \
-	.write = counter_device_enum_write, \
-	.priv = (_e) \
-}
-
-/**
- * COUNTER_DEVICE_ENUM_AVAILABLE() - Initialize Counter enum available extension
- * @_name:	Attribute name ("_available" will be appended to the name)
- * @_e:		Pointer to a counter_device_enum_ext structure
- *
- * Creates a read only attribute that lists all the available enum items in a
- * newline separated list. This should usually be used together with
- * COUNTER_DEVICE_ENUM()
- */
-#define COUNTER_DEVICE_ENUM_AVAILABLE(_name, _e) \
-{ \
-	.name = (_name "_available"), \
-	.read = counter_device_enum_available_read, \
-	.priv = (_e) \
-}
-
 /**
  * struct counter_device - Counter data structure
  * @name:		name of the device as it appears in the datasheet
  * @parent:		optional parent device providing the counters
- * @device_state:	internal device state container
  * @ops:		callbacks from driver
  * @signals:		array of Signals
  * @num_signals:	number of Signals specified in @signals
@@ -425,11 +301,11 @@ struct counter_device_enum_ext {
  * @ext:		optional array of Counter device extensions
  * @num_ext:		number of Counter device extensions specified in @ext
  * @priv:		optional private data supplied by driver
+ * @dev:		internal device structure
  */
 struct counter_device {
 	const char *name;
 	struct device *parent;
-	struct counter_device_state *device_state;
 
 	const struct counter_ops *ops;
 
@@ -438,17 +314,159 @@ struct counter_device {
 	struct counter_count *counts;
 	size_t num_counts;
 
-	const struct counter_device_ext *ext;
+	struct counter_comp *ext;
 	size_t num_ext;
 
 	void *priv;
+
+	struct device dev;
 };
 
 int counter_register(struct counter_device *const counter);
 void counter_unregister(struct counter_device *const counter);
 int devm_counter_register(struct device *dev,
 			  struct counter_device *const counter);
-void devm_counter_unregister(struct device *dev,
-			     struct counter_device *const counter);
+
+#define COUNTER_COMP_DEVICE_U8(_name, _read, _write) \
+{ \
+	.type = COUNTER_COMP_U8, \
+	.name = (_name), \
+	.device_u8_read = (_read), \
+	.device_u8_write = (_write), \
+}
+#define COUNTER_COMP_COUNT_U8(_name, _read, _write) \
+{ \
+	.type = COUNTER_COMP_U8, \
+	.name = (_name), \
+	.count_u8_read = (_read), \
+	.count_u8_write = (_write), \
+}
+#define COUNTER_COMP_SIGNAL_U8(_name, _read, _write) \
+{ \
+	.type = COUNTER_COMP_U8, \
+	.name = (_name), \
+	.signal_u8_read = (_read), \
+	.signal_u8_write = (_write), \
+}
+
+#define COUNTER_COMP_DEVICE_U64(_name, _read, _write) \
+{ \
+	.type = COUNTER_COMP_U64, \
+	.name = (_name), \
+	.device_u64_read = (_read), \
+	.device_u64_write = (_write), \
+}
+#define COUNTER_COMP_COUNT_U64(_name, _read, _write) \
+{ \
+	.type = COUNTER_COMP_U64, \
+	.name = (_name), \
+	.count_u64_read = (_read), \
+	.count_u64_write = (_write), \
+}
+#define COUNTER_COMP_SIGNAL_U64(_name, _read, _write) \
+{ \
+	.type = COUNTER_COMP_U64, \
+	.name = (_name), \
+	.signal_u64_read = (_read), \
+	.signal_u64_write = (_write), \
+}
+
+#define COUNTER_COMP_DEVICE_BOOL(_name, _read, _write) \
+{ \
+	.type = COUNTER_COMP_BOOL, \
+	.name = (_name), \
+	.device_u8_read = (_read), \
+	.device_u8_write = (_write), \
+}
+#define COUNTER_COMP_COUNT_BOOL(_name, _read, _write) \
+{ \
+	.type = COUNTER_COMP_BOOL, \
+	.name = (_name), \
+	.count_u8_read = (_read), \
+	.count_u8_write = (_write), \
+}
+#define COUNTER_COMP_SIGNAL_BOOL(_name, _read, _write) \
+{ \
+	.type = COUNTER_COMP_BOOL, \
+	.name = (_name), \
+	.signal_u8_read = (_read), \
+	.signal_u8_write = (_write), \
+}
+
+struct counter_available {
+	union {
+		const u32 *enums;
+		const char *const *strs;
+	};
+	size_t num_items;
+};
+
+#define DEFINE_COUNTER_AVAILABLE(_name, _enums) \
+	struct counter_available _name = { \
+		.enums = (_enums), \
+		.num_items = ARRAY_SIZE(_enums), \
+	}
+
+#define DEFINE_COUNTER_ENUM(_name, _strs) \
+	struct counter_available _name = { \
+		.strs = (_strs), \
+		.num_items = ARRAY_SIZE(_strs), \
+	}
+
+#define COUNTER_COMP_DEVICE_ENUM(_name, _get, _set, _available) \
+{ \
+	.type = COUNTER_COMP_ENUM, \
+	.name = (_name), \
+	.device_u32_read = (_get), \
+	.device_u32_write = (_set), \
+	.priv = &(_available), \
+}
+#define COUNTER_COMP_COUNT_ENUM(_name, _get, _set, _available) \
+{ \
+	.type = COUNTER_COMP_ENUM, \
+	.name = (_name), \
+	.count_u32_read = (_get), \
+	.count_u32_write = (_set), \
+	.priv = &(_available), \
+}
+#define COUNTER_COMP_SIGNAL_ENUM(_name, _get, _set, _available) \
+{ \
+	.type = COUNTER_COMP_ENUM, \
+	.name = (_name), \
+	.signal_u32_read = (_get), \
+	.signal_u32_write = (_set), \
+	.priv = &(_available), \
+}
+
+#define COUNTER_COMP_CEILING(_read, _write) \
+	COUNTER_COMP_COUNT_U64("ceiling", _read, _write)
+
+#define COUNTER_COMP_COUNT_MODE(_read, _write, _available) \
+{ \
+	.type = COUNTER_COMP_COUNT_MODE, \
+	.name = "count_mode", \
+	.count_u32_read = (_read), \
+	.count_u32_write = (_write), \
+	.priv = &(_available), \
+}
+
+#define COUNTER_COMP_DIRECTION(_read) \
+{ \
+	.type = COUNTER_COMP_COUNT_DIRECTION, \
+	.name = "direction", \
+	.count_u32_read = (_read), \
+}
+
+#define COUNTER_COMP_ENABLE(_read, _write) \
+	COUNTER_COMP_COUNT_BOOL("enable", _read, _write)
+
+#define COUNTER_COMP_FLOOR(_read, _write) \
+	COUNTER_COMP_COUNT_U64("floor", _read, _write)
+
+#define COUNTER_COMP_PRESET(_read, _write) \
+	COUNTER_COMP_COUNT_U64("preset", _read, _write)
+
+#define COUNTER_COMP_PRESET_ENABLE(_read, _write) \
+	COUNTER_COMP_COUNT_BOOL("preset_enable", _read, _write)
 
 #endif /* _COUNTER_H_ */
diff --git a/include/linux/counter_enum.h b/include/linux/counter_enum.h
deleted file mode 100644
index 9f917298a88f..000000000000
--- a/include/linux/counter_enum.h
+++ /dev/null
@@ -1,45 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/*
- * Counter interface enum functions
- * Copyright (C) 2018 William Breathitt Gray
- */
-#ifndef _COUNTER_ENUM_H_
-#define _COUNTER_ENUM_H_
-
-#include <linux/types.h>
-
-struct counter_device;
-struct counter_signal;
-struct counter_count;
-
-ssize_t counter_signal_enum_read(struct counter_device *counter,
-				 struct counter_signal *signal, void *priv,
-				 char *buf);
-ssize_t counter_signal_enum_write(struct counter_device *counter,
-				  struct counter_signal *signal, void *priv,
-				  const char *buf, size_t len);
-
-ssize_t counter_signal_enum_available_read(struct counter_device *counter,
-					   struct counter_signal *signal,
-					   void *priv, char *buf);
-
-ssize_t counter_count_enum_read(struct counter_device *counter,
-				struct counter_count *count, void *priv,
-				char *buf);
-ssize_t counter_count_enum_write(struct counter_device *counter,
-				 struct counter_count *count, void *priv,
-				 const char *buf, size_t len);
-
-ssize_t counter_count_enum_available_read(struct counter_device *counter,
-					  struct counter_count *count,
-					  void *priv, char *buf);
-
-ssize_t counter_device_enum_read(struct counter_device *counter, void *priv,
-				 char *buf);
-ssize_t counter_device_enum_write(struct counter_device *counter, void *priv,
-				  const char *buf, size_t len);
-
-ssize_t counter_device_enum_available_read(struct counter_device *counter,
-					   void *priv, char *buf);
-
-#endif /* _COUNTER_ENUM_H_ */
diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index cf042d41c87b..88c289ce3039 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -390,8 +390,8 @@ extern note_buf_t __percpu *crash_notes;
 extern bool kexec_in_progress;
 
 int crash_shrink_memory(unsigned long new_size);
-size_t crash_get_memory_size(void);
 void crash_free_reserved_phys_range(unsigned long begin, unsigned long end);
+ssize_t crash_get_memory_size(void);
 
 void arch_kexec_protect_crashkres(void);
 void arch_kexec_unprotect_crashkres(void);
diff --git a/include/linux/mfd/stm32-lptimer.h b/include/linux/mfd/stm32-lptimer.h
index 90b20550c1c8..06d3f11dc3c9 100644
--- a/include/linux/mfd/stm32-lptimer.h
+++ b/include/linux/mfd/stm32-lptimer.h
@@ -45,6 +45,11 @@
 #define STM32_LPTIM_PRESC	GENMASK(11, 9)
 #define STM32_LPTIM_CKPOL	GENMASK(2, 1)
 
+/* STM32_LPTIM_CKPOL */
+#define STM32_LPTIM_CKPOL_RISING_EDGE	0
+#define STM32_LPTIM_CKPOL_FALLING_EDGE	1
+#define STM32_LPTIM_CKPOL_BOTH_EDGES	2
+
 /* STM32_LPTIM_ARR */
 #define STM32_LPTIM_MAX_ARR	0xFFFF
 
diff --git a/include/linux/mfd/stm32-timers.h b/include/linux/mfd/stm32-timers.h
index f8db83aedb2b..5f5c43fd69dd 100644
--- a/include/linux/mfd/stm32-timers.h
+++ b/include/linux/mfd/stm32-timers.h
@@ -82,6 +82,10 @@
 #define MAX_TIM_ICPSC		0x3
 #define TIM_CR2_MMS_SHIFT	4
 #define TIM_CR2_MMS2_SHIFT	20
+#define TIM_SMCR_SMS_SLAVE_MODE_DISABLED	0 /* counts on internal clock when CEN=1 */
+#define TIM_SMCR_SMS_ENCODER_MODE_1		1 /* counts TI1FP1 edges, depending on TI2FP2 level */
+#define TIM_SMCR_SMS_ENCODER_MODE_2		2 /* counts TI2FP2 edges, depending on TI1FP1 level */
+#define TIM_SMCR_SMS_ENCODER_MODE_3		3 /* counts on both TI1FP1 and TI2FP2 edges */
 #define TIM_SMCR_TS_SHIFT	4
 #define TIM_BDTR_BKF_MASK	0xF
 #define TIM_BDTR_BKF_SHIFT(x)	(16 + (x) * 4)
diff --git a/include/linux/trace.h b/include/linux/trace.h
index 80ffda871749..2a70a447184c 100644
--- a/include/linux/trace.h
+++ b/include/linux/trace.h
@@ -33,6 +33,18 @@ struct trace_array;
 int register_ftrace_export(struct trace_export *export);
 int unregister_ftrace_export(struct trace_export *export);
 
+/**
+ * trace_array_puts - write a constant string into the trace buffer.
+ * @tr:    The trace array to write to
+ * @str:   The constant string to write
+ */
+#define trace_array_puts(tr, str)					\
+	({								\
+		str ? __trace_array_puts(tr, _THIS_IP_, str, strlen(str)) : -1;	\
+	})
+int __trace_array_puts(struct trace_array *tr, unsigned long ip,
+		       const char *str, int size);
+
 void trace_printk_init_buffers(void);
 __printf(3, 4)
 int trace_array_printk(struct trace_array *tr, unsigned long ip,
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 428820bf141d..fb895eaf3a7c 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2225,11 +2225,15 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
 static void cpuset_cancel_attach(struct cgroup_taskset *tset)
 {
 	struct cgroup_subsys_state *css;
+	struct cpuset *cs;
 
 	cgroup_taskset_first(tset, &css);
+	cs = css_cs(css);
 
 	percpu_down_write(&cpuset_rwsem);
-	css_cs(css)->attach_in_progress--;
+	cs->attach_in_progress--;
+	if (!cs->attach_in_progress)
+		wake_up(&cpuset_attach_wq);
 	percpu_up_write(&cpuset_rwsem);
 }
 
diff --git a/kernel/kexec.c b/kernel/kexec.c
index b5e40f069768..cb8e6e6f983c 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -93,13 +93,10 @@ static int do_kexec_load(unsigned long entry, unsigned long nr_segments,
 
 	/*
 	 * Because we write directly to the reserved memory region when loading
-	 * crash kernels we need a mutex here to prevent multiple crash kernels
-	 * from attempting to load simultaneously, and to prevent a crash kernel
-	 * from loading over the top of a in use crash kernel.
-	 *
-	 * KISS: always take the mutex.
+	 * crash kernels we need a serialization here to prevent multiple crash
+	 * kernels from attempting to load simultaneously.
 	 */
-	if (!mutex_trylock(&kexec_mutex))
+	if (!kexec_trylock())
 		return -EBUSY;
 
 	if (flags & KEXEC_ON_CRASH) {
@@ -165,7 +162,7 @@ static int do_kexec_load(unsigned long entry, unsigned long nr_segments,
 
 	kimage_free(image);
 out_unlock:
-	mutex_unlock(&kexec_mutex);
+	kexec_unlock();
 	return ret;
 }
 
diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
index 5a5d192a89ac..bdc2d952911c 100644
--- a/kernel/kexec_core.c
+++ b/kernel/kexec_core.c
@@ -46,7 +46,7 @@
 #include <crypto/hash.h>
 #include "kexec_internal.h"
 
-DEFINE_MUTEX(kexec_mutex);
+atomic_t __kexec_lock = ATOMIC_INIT(0);
 
 /* Per cpu memory for storing cpu states in case of system crash. */
 note_buf_t __percpu *crash_notes;
@@ -944,7 +944,7 @@ int kexec_load_disabled;
  */
 void __noclone __crash_kexec(struct pt_regs *regs)
 {
-	/* Take the kexec_mutex here to prevent sys_kexec_load
+	/* Take the kexec_lock here to prevent sys_kexec_load
 	 * running on one cpu from replacing the crash kernel
 	 * we are using after a panic on a different cpu.
 	 *
@@ -952,7 +952,7 @@ void __noclone __crash_kexec(struct pt_regs *regs)
 	 * of memory the xchg(&kexec_crash_image) would be
 	 * sufficient.  But since I reuse the memory...
 	 */
-	if (mutex_trylock(&kexec_mutex)) {
+	if (kexec_trylock()) {
 		if (kexec_crash_image) {
 			struct pt_regs fixed_regs;
 
@@ -961,7 +961,7 @@ void __noclone __crash_kexec(struct pt_regs *regs)
 			machine_crash_shutdown(&fixed_regs);
 			machine_kexec(kexec_crash_image);
 		}
-		mutex_unlock(&kexec_mutex);
+		kexec_unlock();
 	}
 }
 STACK_FRAME_NON_STANDARD(__crash_kexec);
@@ -989,14 +989,17 @@ void crash_kexec(struct pt_regs *regs)
 	}
 }
 
-size_t crash_get_memory_size(void)
+ssize_t crash_get_memory_size(void)
 {
-	size_t size = 0;
+	ssize_t size = 0;
+
+	if (!kexec_trylock())
+		return -EBUSY;
 
-	mutex_lock(&kexec_mutex);
 	if (crashk_res.end != crashk_res.start)
 		size = resource_size(&crashk_res);
-	mutex_unlock(&kexec_mutex);
+
+	kexec_unlock();
 	return size;
 }
 
@@ -1016,7 +1019,8 @@ int crash_shrink_memory(unsigned long new_size)
 	unsigned long old_size;
 	struct resource *ram_res;
 
-	mutex_lock(&kexec_mutex);
+	if (!kexec_trylock())
+		return -EBUSY;
 
 	if (kexec_crash_image) {
 		ret = -ENOENT;
@@ -1054,7 +1058,7 @@ int crash_shrink_memory(unsigned long new_size)
 	insert_resource(&iomem_resource, ram_res);
 
 unlock:
-	mutex_unlock(&kexec_mutex);
+	kexec_unlock();
 	return ret;
 }
 
@@ -1126,7 +1130,7 @@ int kernel_kexec(void)
 {
 	int error = 0;
 
-	if (!mutex_trylock(&kexec_mutex))
+	if (!kexec_trylock())
 		return -EBUSY;
 	if (!kexec_image) {
 		error = -EINVAL;
@@ -1202,7 +1206,7 @@ int kernel_kexec(void)
 #endif
 
  Unlock:
-	mutex_unlock(&kexec_mutex);
+	kexec_unlock();
 	return error;
 }
 
diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
index f7a4fd4d243f..1fb7ff690577 100644
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -343,7 +343,7 @@ SYSCALL_DEFINE5(kexec_file_load, int, kernel_fd, int, initrd_fd,
 
 	image = NULL;
 
-	if (!mutex_trylock(&kexec_mutex))
+	if (!kexec_trylock())
 		return -EBUSY;
 
 	dest_image = &kexec_image;
@@ -415,7 +415,7 @@ SYSCALL_DEFINE5(kexec_file_load, int, kernel_fd, int, initrd_fd,
 	if ((flags & KEXEC_FILE_ON_CRASH) && kexec_crash_image)
 		arch_kexec_protect_crashkres();
 
-	mutex_unlock(&kexec_mutex);
+	kexec_unlock();
 	kimage_free(image);
 	return ret;
 }
diff --git a/kernel/kexec_internal.h b/kernel/kexec_internal.h
index 48aaf2ac0d0d..74da1409cd14 100644
--- a/kernel/kexec_internal.h
+++ b/kernel/kexec_internal.h
@@ -13,7 +13,20 @@ void kimage_terminate(struct kimage *image);
 int kimage_is_destination_range(struct kimage *image,
 				unsigned long start, unsigned long end);
 
-extern struct mutex kexec_mutex;
+/*
+ * Whatever is used to serialize accesses to the kexec_crash_image needs to be
+ * NMI safe, as __crash_kexec() can happen during nmi_panic(), so here we use a
+ * "simple" atomic variable that is acquired with a cmpxchg().
+ */
+extern atomic_t __kexec_lock;
+static inline bool kexec_trylock(void)
+{
+	return atomic_cmpxchg_acquire(&__kexec_lock, 0, 1) == 0;
+}
+static inline void kexec_unlock(void)
+{
+	atomic_set_release(&__kexec_lock, 0);
+}
 
 #ifdef CONFIG_KEXEC_FILE
 #include <linux/purgatory.h>
diff --git a/kernel/ksysfs.c b/kernel/ksysfs.c
index 35859da8bd4f..e20c19e3ba49 100644
--- a/kernel/ksysfs.c
+++ b/kernel/ksysfs.c
@@ -106,7 +106,12 @@ KERNEL_ATTR_RO(kexec_crash_loaded);
 static ssize_t kexec_crash_size_show(struct kobject *kobj,
 				       struct kobj_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%zu\n", crash_get_memory_size());
+	ssize_t size = crash_get_memory_size();
+
+	if (size < 0)
+		return size;
+
+	return sprintf(buf, "%zd\n", size);
 }
 static ssize_t kexec_crash_size_store(struct kobject *kobj,
 				   struct kobj_attribute *attr,
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8f5a5e72bdb3..7ac00dede846 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -9636,8 +9636,6 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
 		local->avg_load = (local->group_load * SCHED_CAPACITY_SCALE) /
 				  local->group_capacity;
 
-		sds->avg_load = (sds->total_load * SCHED_CAPACITY_SCALE) /
-				sds->total_capacity;
 		/*
 		 * If the local group is more loaded than the selected
 		 * busiest group don't try to pull any tasks.
@@ -9646,6 +9644,19 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
 			env->imbalance = 0;
 			return;
 		}
+
+		sds->avg_load = (sds->total_load * SCHED_CAPACITY_SCALE) /
+				sds->total_capacity;
+
+		/*
+		 * If the local group is more loaded than the average system
+		 * load, don't try to pull any tasks.
+		 */
+		if (local->avg_load >= sds->avg_load) {
+			env->imbalance = 0;
+			return;
+		}
+
 	}
 
 	/*
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index dc097bd23dc3..e2277cba4817 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -990,13 +990,8 @@ __buffer_unlock_commit(struct trace_buffer *buffer, struct ring_buffer_event *ev
 		ring_buffer_unlock_commit(buffer, event);
 }
 
-/**
- * __trace_puts - write a constant string into the trace buffer.
- * @ip:	   The address of the caller
- * @str:   The constant string to write
- * @size:  The size of the string.
- */
-int __trace_puts(unsigned long ip, const char *str, int size)
+int __trace_array_puts(struct trace_array *tr, unsigned long ip,
+		       const char *str, int size)
 {
 	struct ring_buffer_event *event;
 	struct trace_buffer *buffer;
@@ -1004,7 +999,7 @@ int __trace_puts(unsigned long ip, const char *str, int size)
 	unsigned int trace_ctx;
 	int alloc;
 
-	if (!(global_trace.trace_flags & TRACE_ITER_PRINTK))
+	if (!(tr->trace_flags & TRACE_ITER_PRINTK))
 		return 0;
 
 	if (unlikely(tracing_selftest_running || tracing_disabled))
@@ -1013,7 +1008,7 @@ int __trace_puts(unsigned long ip, const char *str, int size)
 	alloc = sizeof(*entry) + size + 2; /* possible \n added */
 
 	trace_ctx = tracing_gen_ctx();
-	buffer = global_trace.array_buffer.buffer;
+	buffer = tr->array_buffer.buffer;
 	ring_buffer_nest_start(buffer);
 	event = __trace_buffer_lock_reserve(buffer, TRACE_PRINT, alloc,
 					    trace_ctx);
@@ -1035,11 +1030,23 @@ int __trace_puts(unsigned long ip, const char *str, int size)
 		entry->buf[size] = '\0';
 
 	__buffer_unlock_commit(buffer, event);
-	ftrace_trace_stack(&global_trace, buffer, trace_ctx, 4, NULL);
+	ftrace_trace_stack(tr, buffer, trace_ctx, 4, NULL);
  out:
 	ring_buffer_nest_end(buffer);
 	return size;
 }
+EXPORT_SYMBOL_GPL(__trace_array_puts);
+
+/**
+ * __trace_puts - write a constant string into the trace buffer.
+ * @ip:	   The address of the caller
+ * @str:   The constant string to write
+ * @size:  The size of the string.
+ */
+int __trace_puts(unsigned long ip, const char *str, int size)
+{
+	return __trace_array_puts(&global_trace, ip, str, size);
+}
 EXPORT_SYMBOL_GPL(__trace_puts);
 
 /**
@@ -1093,22 +1100,22 @@ static void tracing_snapshot_instance_cond(struct trace_array *tr,
 	unsigned long flags;
 
 	if (in_nmi()) {
-		internal_trace_puts("*** SNAPSHOT CALLED FROM NMI CONTEXT ***\n");
-		internal_trace_puts("*** snapshot is being ignored        ***\n");
+		trace_array_puts(tr, "*** SNAPSHOT CALLED FROM NMI CONTEXT ***\n");
+		trace_array_puts(tr, "*** snapshot is being ignored        ***\n");
 		return;
 	}
 
 	if (!tr->allocated_snapshot) {
-		internal_trace_puts("*** SNAPSHOT NOT ALLOCATED ***\n");
-		internal_trace_puts("*** stopping trace here!   ***\n");
-		tracing_off();
+		trace_array_puts(tr, "*** SNAPSHOT NOT ALLOCATED ***\n");
+		trace_array_puts(tr, "*** stopping trace here!   ***\n");
+		tracer_tracing_off(tr);
 		return;
 	}
 
 	/* Note, snapshot can not be used when the tracer uses it */
 	if (tracer->use_max_tr) {
-		internal_trace_puts("*** LATENCY TRACER ACTIVE ***\n");
-		internal_trace_puts("*** Can not use snapshot (sorry) ***\n");
+		trace_array_puts(tr, "*** LATENCY TRACER ACTIVE ***\n");
+		trace_array_puts(tr, "*** Can not use snapshot (sorry) ***\n");
 		return;
 	}
 
diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
index 9e4da8c1b907..99e6b2483311 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -300,6 +300,10 @@ static void xen_9pfs_front_free(struct xen_9pfs_front_priv *priv)
 	write_unlock(&xen_9pfs_lock);
 
 	for (i = 0; i < priv->num_rings; i++) {
+		struct xen_9pfs_dataring *ring = &priv->rings[i];
+
+		cancel_work_sync(&ring->work);
+
 		if (!priv->rings[i].intf)
 			break;
 		if (priv->rings[i].irq > 0)
diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
index 80848dfc01db..021ab957a5c4 100644
--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -433,7 +433,7 @@ static void hidp_set_timer(struct hidp_session *session)
 static void hidp_del_timer(struct hidp_session *session)
 {
 	if (session->idle_to > 0)
-		del_timer(&session->timer);
+		del_timer_sync(&session->timer);
 }
 
 static void hidp_process_report(struct hidp_session *session, int type,
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 0194c25b8dc5..446343348329 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4652,33 +4652,27 @@ static inline int l2cap_disconnect_req(struct l2cap_conn *conn,
 
 	BT_DBG("scid 0x%4.4x dcid 0x%4.4x", scid, dcid);
 
-	mutex_lock(&conn->chan_lock);
-
-	chan = __l2cap_get_chan_by_scid(conn, dcid);
+	chan = l2cap_get_chan_by_scid(conn, dcid);
 	if (!chan) {
-		mutex_unlock(&conn->chan_lock);
 		cmd_reject_invalid_cid(conn, cmd->ident, dcid, scid);
 		return 0;
 	}
 
-	l2cap_chan_hold(chan);
-	l2cap_chan_lock(chan);
-
 	rsp.dcid = cpu_to_le16(chan->scid);
 	rsp.scid = cpu_to_le16(chan->dcid);
 	l2cap_send_cmd(conn, cmd->ident, L2CAP_DISCONN_RSP, sizeof(rsp), &rsp);
 
 	chan->ops->set_shutdown(chan);
 
+	mutex_lock(&conn->chan_lock);
 	l2cap_chan_del(chan, ECONNRESET);
+	mutex_unlock(&conn->chan_lock);
 
 	chan->ops->close(chan);
 
 	l2cap_chan_unlock(chan);
 	l2cap_chan_put(chan);
 
-	mutex_unlock(&conn->chan_lock);
-
 	return 0;
 }
 
@@ -4698,33 +4692,27 @@ static inline int l2cap_disconnect_rsp(struct l2cap_conn *conn,
 
 	BT_DBG("dcid 0x%4.4x scid 0x%4.4x", dcid, scid);
 
-	mutex_lock(&conn->chan_lock);
-
-	chan = __l2cap_get_chan_by_scid(conn, scid);
+	chan = l2cap_get_chan_by_scid(conn, scid);
 	if (!chan) {
 		mutex_unlock(&conn->chan_lock);
 		return 0;
 	}
 
-	l2cap_chan_hold(chan);
-	l2cap_chan_lock(chan);
-
 	if (chan->state != BT_DISCONN) {
 		l2cap_chan_unlock(chan);
 		l2cap_chan_put(chan);
-		mutex_unlock(&conn->chan_lock);
 		return 0;
 	}
 
+	mutex_lock(&conn->chan_lock);
 	l2cap_chan_del(chan, 0);
+	mutex_unlock(&conn->chan_lock);
 
 	chan->ops->close(chan);
 
 	l2cap_chan_unlock(chan);
 	l2cap_chan_put(chan);
 
-	mutex_unlock(&conn->chan_lock);
-
 	return 0;
 }
 
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 2d3f82b62236..46cc3a7632f7 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5397,18 +5397,18 @@ bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
 	if (skb_cloned(to))
 		return false;
 
-	/* In general, avoid mixing slab allocated and page_pool allocated
-	 * pages within the same SKB. However when @to is not pp_recycle and
-	 * @from is cloned, we can transition frag pages from page_pool to
-	 * reference counted.
-	 *
-	 * On the other hand, don't allow coalescing two pp_recycle SKBs if
-	 * @from is cloned, in case the SKB is using page_pool fragment
+	/* In general, avoid mixing page_pool and non-page_pool allocated
+	 * pages within the same SKB. Additionally avoid dealing with clones
+	 * with page_pool pages, in case the SKB is using page_pool fragment
 	 * references (PP_FLAG_PAGE_FRAG). Since we only take full page
 	 * references for cloned SKBs at the moment that would result in
 	 * inconsistent reference counts.
+	 * In theory we could take full references if @from is cloned and
+	 * !@to->pp_recycle but its tricky (due to potential race with
+	 * the clone disappearing) and rare, so not worth dealing with.
 	 */
-	if (to->pp_recycle != (from->pp_recycle && !skb_cloned(from)))
+	if (to->pp_recycle != from->pp_recycle ||
+	    (from->pp_recycle && skb_cloned(from)))
 		return false;
 
 	if (len <= skb_tailroom(to)) {
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 495c58e442e2..1f22e72074fd 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -38,6 +38,7 @@ static int ip_local_port_range_min[] = { 1, 1 };
 static int ip_local_port_range_max[] = { 65535, 65535 };
 static int tcp_adv_win_scale_min = -31;
 static int tcp_adv_win_scale_max = 31;
+static int tcp_app_win_max = 31;
 static int tcp_min_snd_mss_min = TCP_MIN_SND_MSS;
 static int tcp_min_snd_mss_max = 65535;
 static int ip_privileged_port_min;
@@ -1168,6 +1169,8 @@ static struct ctl_table ipv4_net_table[] = {
 		.maxlen		= sizeof(u8),
 		.mode		= 0644,
 		.proc_handler	= proc_dou8vec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= &tcp_app_win_max,
 	},
 	{
 		.procname	= "tcp_adv_win_scale",
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 0e1fbad17dbe..63472c9b39ae 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2760,7 +2760,7 @@ static int tcp_prog_seq_show(struct bpf_prog *prog, struct bpf_iter_meta *meta,
 static void bpf_iter_tcp_put_batch(struct bpf_tcp_iter_state *iter)
 {
 	while (iter->cur_sk < iter->end_sk)
-		sock_put(iter->batch[iter->cur_sk++]);
+		sock_gen_put(iter->batch[iter->cur_sk++]);
 }
 
 static int bpf_iter_tcp_realloc_batch(struct bpf_tcp_iter_state *iter,
@@ -2919,7 +2919,7 @@ static void *bpf_iter_tcp_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 		 * st->bucket.  See tcp_seek_last_pos().
 		 */
 		st->offset++;
-		sock_put(iter->batch[iter->cur_sk++]);
+		sock_gen_put(iter->batch[iter->cur_sk++]);
 	}
 
 	if (iter->cur_sk < iter->end_sk)
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 9dfb4bb54344..921129c3df8a 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1359,9 +1359,11 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 			msg->msg_name = &sin;
 			msg->msg_namelen = sizeof(sin);
 do_udp_sendmsg:
-			if (__ipv6_only_sock(sk))
-				return -ENETUNREACH;
-			return udp_sendmsg(sk, msg, len);
+			err = __ipv6_only_sock(sk) ?
+				-ENETUNREACH : udp_sendmsg(sk, msg, len);
+			msg->msg_name = sin6;
+			msg->msg_namelen = addr_len;
+			return err;
 		}
 	}
 
diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 193f0fcce8d8..aa4b0cf7c638 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -1156,9 +1156,8 @@ bool mptcp_incoming_options(struct sock *sk, struct sk_buff *skb)
 	 */
 	if (TCP_SKB_CB(skb)->seq == TCP_SKB_CB(skb)->end_seq) {
 		if (mp_opt.data_fin && mp_opt.data_len == 1 &&
-		    mptcp_update_rcv_data_fin(msk, mp_opt.data_seq, mp_opt.dsn64) &&
-		    schedule_work(&msk->work))
-			sock_hold(subflow->conn);
+		    mptcp_update_rcv_data_fin(msk, mp_opt.data_seq, mp_opt.dsn64))
+			mptcp_schedule_work((struct sock *)msk);
 
 		return true;
 	}
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 5d05d85242bc..4c4577775c5d 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2448,7 +2448,7 @@ static void mptcp_worker(struct work_struct *work)
 
 	lock_sock(sk);
 	state = sk->sk_state;
-	if (unlikely(state == TCP_CLOSE))
+	if (unlikely((1 << state) & (TCPF_CLOSE | TCPF_LISTEN)))
 		goto unlock;
 
 	mptcp_check_data_fin_ack(sk);
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 232f437770a6..9b89999062c9 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -360,9 +360,8 @@ void mptcp_subflow_reset(struct sock *ssk)
 
 	tcp_send_active_reset(ssk, GFP_ATOMIC);
 	tcp_done(ssk);
-	if (!test_and_set_bit(MPTCP_WORK_CLOSE_SUBFLOW, &mptcp_sk(sk)->flags) &&
-	    schedule_work(&mptcp_sk(sk)->work))
-		return; /* worker will put sk for us */
+	if (!test_and_set_bit(MPTCP_WORK_CLOSE_SUBFLOW, &mptcp_sk(sk)->flags))
+		mptcp_schedule_work(sk);
 
 	sock_put(sk);
 }
@@ -1010,8 +1009,8 @@ static enum mapping_status get_mapping_status(struct sock *ssk,
 				skb_ext_del(skb, SKB_EXT_MPTCP);
 				return MAPPING_OK;
 			} else {
-				if (updated && schedule_work(&msk->work))
-					sock_hold((struct sock *)msk);
+				if (updated)
+					mptcp_schedule_work((struct sock *)msk);
 
 				return MAPPING_DATA_FIN;
 			}
@@ -1114,17 +1113,12 @@ static void mptcp_subflow_discard_data(struct sock *ssk, struct sk_buff *skb,
 /* sched mptcp worker to remove the subflow if no more data is pending */
 static void subflow_sched_work_if_closed(struct mptcp_sock *msk, struct sock *ssk)
 {
-	struct sock *sk = (struct sock *)msk;
-
 	if (likely(ssk->sk_state != TCP_CLOSE))
 		return;
 
 	if (skb_queue_empty(&ssk->sk_receive_queue) &&
-	    !test_and_set_bit(MPTCP_WORK_CLOSE_SUBFLOW, &msk->flags)) {
-		sock_hold(sk);
-		if (!schedule_work(&msk->work))
-			sock_put(sk);
-	}
+	    !test_and_set_bit(MPTCP_WORK_CLOSE_SUBFLOW, &msk->flags))
+		mptcp_schedule_work((struct sock *)msk);
 }
 
 static bool subflow_can_fallback(struct mptcp_subflow_context *subflow)
diff --git a/net/qrtr/af_qrtr.c b/net/qrtr/af_qrtr.c
index 6e88ba812d2a..e0a27a404404 100644
--- a/net/qrtr/af_qrtr.c
+++ b/net/qrtr/af_qrtr.c
@@ -498,6 +498,11 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
 	if (!size || len != ALIGN(size, 4) + hdrlen)
 		goto err;
 
+	if ((cb->type == QRTR_TYPE_NEW_SERVER ||
+	     cb->type == QRTR_TYPE_RESUME_TX) &&
+	    size < sizeof(struct qrtr_ctrl_pkt))
+		goto err;
+
 	if (cb->dst_port != QRTR_PORT_CTRL && cb->type != QRTR_TYPE_DATA &&
 	    cb->type != QRTR_TYPE_RESUME_TX)
 		goto err;
@@ -510,9 +515,6 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
 		/* Remote node endpoint can bridge other distant nodes */
 		const struct qrtr_ctrl_pkt *pkt;
 
-		if (size < sizeof(*pkt))
-			goto err;
-
 		pkt = data + hdrlen;
 		qrtr_node_assign(node, le32_to_cpu(pkt->server.node));
 	}
diff --git a/net/sctp/stream_interleave.c b/net/sctp/stream_interleave.c
index 6b13f737ebf2..e3aad75cb11d 100644
--- a/net/sctp/stream_interleave.c
+++ b/net/sctp/stream_interleave.c
@@ -1162,7 +1162,8 @@ static void sctp_generate_iftsn(struct sctp_outq *q, __u32 ctsn)
 
 #define _sctp_walk_ifwdtsn(pos, chunk, end) \
 	for (pos = chunk->subh.ifwdtsn_hdr->skip; \
-	     (void *)pos < (void *)chunk->subh.ifwdtsn_hdr->skip + (end); pos++)
+	     (void *)pos <= (void *)chunk->subh.ifwdtsn_hdr->skip + (end) - \
+			    sizeof(struct sctp_ifwdtsn_skip); pos++)
 
 #define sctp_walk_ifwdtsn(pos, ch) \
 	_sctp_walk_ifwdtsn((pos), (ch), ntohs((ch)->chunk_hdr->length) - \
diff --git a/sound/firewire/tascam/tascam-stream.c b/sound/firewire/tascam/tascam-stream.c
index 53e094cc411f..dfe783d01d7d 100644
--- a/sound/firewire/tascam/tascam-stream.c
+++ b/sound/firewire/tascam/tascam-stream.c
@@ -490,7 +490,7 @@ int snd_tscm_stream_start_duplex(struct snd_tscm *tscm, unsigned int rate)
 		// packet is important for media clock recovery.
 		err = amdtp_domain_start(&tscm->domain, tx_init_skip_cycles, true, true);
 		if (err < 0)
-			return err;
+			goto error;
 
 		if (!amdtp_domain_wait_ready(&tscm->domain, READY_TIMEOUT_MS)) {
 			err = -ETIMEDOUT;
diff --git a/sound/i2c/cs8427.c b/sound/i2c/cs8427.c
index 65012af6a36e..f58b14b49045 100644
--- a/sound/i2c/cs8427.c
+++ b/sound/i2c/cs8427.c
@@ -561,10 +561,13 @@ int snd_cs8427_iec958_active(struct snd_i2c_device *cs8427, int active)
 	if (snd_BUG_ON(!cs8427))
 		return -ENXIO;
 	chip = cs8427->private_data;
-	if (active)
+	if (active) {
 		memcpy(chip->playback.pcm_status,
 		       chip->playback.def_status, 24);
-	chip->playback.pcm_ctl->vd[0].access &= ~SNDRV_CTL_ELEM_ACCESS_INACTIVE;
+		chip->playback.pcm_ctl->vd[0].access &= ~SNDRV_CTL_ELEM_ACCESS_INACTIVE;
+	} else {
+		chip->playback.pcm_ctl->vd[0].access |= SNDRV_CTL_ELEM_ACCESS_INACTIVE;
+	}
 	snd_ctl_notify(cs8427->bus->card,
 		       SNDRV_CTL_EVENT_MASK_VALUE | SNDRV_CTL_EVENT_MASK_INFO,
 		       &chip->playback.pcm_ctl->id);
diff --git a/sound/pci/emu10k1/emupcm.c b/sound/pci/emu10k1/emupcm.c
index 48af77ae8020..6ec394fb1846 100644
--- a/sound/pci/emu10k1/emupcm.c
+++ b/sound/pci/emu10k1/emupcm.c
@@ -1236,7 +1236,7 @@ static int snd_emu10k1_capture_mic_close(struct snd_pcm_substream *substream)
 {
 	struct snd_emu10k1 *emu = snd_pcm_substream_chip(substream);
 
-	emu->capture_interrupt = NULL;
+	emu->capture_mic_interrupt = NULL;
 	emu->pcm_capture_mic_substream = NULL;
 	return 0;
 }
@@ -1344,7 +1344,7 @@ static int snd_emu10k1_capture_efx_close(struct snd_pcm_substream *substream)
 {
 	struct snd_emu10k1 *emu = snd_pcm_substream_chip(substream);
 
-	emu->capture_interrupt = NULL;
+	emu->capture_efx_interrupt = NULL;
 	emu->pcm_capture_efx_substream = NULL;
 	return 0;
 }
@@ -1781,17 +1781,21 @@ int snd_emu10k1_pcm_efx(struct snd_emu10k1 *emu, int device)
 	struct snd_kcontrol *kctl;
 	int err;
 
-	err = snd_pcm_new(emu->card, "emu10k1 efx", device, 8, 1, &pcm);
+	err = snd_pcm_new(emu->card, "emu10k1 efx", device, emu->audigy ? 0 : 8, 1, &pcm);
 	if (err < 0)
 		return err;
 
 	pcm->private_data = emu;
 
-	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_PLAYBACK, &snd_emu10k1_fx8010_playback_ops);
+	if (!emu->audigy)
+		snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_PLAYBACK, &snd_emu10k1_fx8010_playback_ops);
 	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_CAPTURE, &snd_emu10k1_capture_efx_ops);
 
 	pcm->info_flags = 0;
-	strcpy(pcm->name, "Multichannel Capture/PT Playback");
+	if (emu->audigy)
+		strcpy(pcm->name, "Multichannel Capture");
+	else
+		strcpy(pcm->name, "Multichannel Capture/PT Playback");
 	emu->pcm_efx = pcm;
 
 	/* EFX capture - record the "FXBUS2" channels, by default we connect the EXTINs 
diff --git a/sound/pci/hda/patch_sigmatel.c b/sound/pci/hda/patch_sigmatel.c
index a794a01a68ca..61258b0aac8d 100644
--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -1707,6 +1707,7 @@ static const struct snd_pci_quirk stac925x_fixup_tbl[] = {
 };
 
 static const struct hda_pintbl ref92hd73xx_pin_configs[] = {
+	// Port A-H
 	{ 0x0a, 0x02214030 },
 	{ 0x0b, 0x02a19040 },
 	{ 0x0c, 0x01a19020 },
@@ -1715,9 +1716,12 @@ static const struct hda_pintbl ref92hd73xx_pin_configs[] = {
 	{ 0x0f, 0x01014010 },
 	{ 0x10, 0x01014020 },
 	{ 0x11, 0x01014030 },
+	// CD in
 	{ 0x12, 0x02319040 },
+	// Digial Mic ins
 	{ 0x13, 0x90a000f0 },
 	{ 0x14, 0x90a000f0 },
+	// Digital outs
 	{ 0x22, 0x01452050 },
 	{ 0x23, 0x01452050 },
 	{}
@@ -1758,6 +1762,7 @@ static const struct hda_pintbl alienware_m17x_pin_configs[] = {
 };
 
 static const struct hda_pintbl intel_dg45id_pin_configs[] = {
+	// Analog outputs
 	{ 0x0a, 0x02214230 },
 	{ 0x0b, 0x02A19240 },
 	{ 0x0c, 0x01013214 },
@@ -1765,6 +1770,9 @@ static const struct hda_pintbl intel_dg45id_pin_configs[] = {
 	{ 0x0e, 0x01A19250 },
 	{ 0x0f, 0x01011212 },
 	{ 0x10, 0x01016211 },
+	// Digital output
+	{ 0x22, 0x01451380 },
+	{ 0x23, 0x40f000f0 },
 	{}
 };
 
@@ -1955,6 +1963,8 @@ static const struct snd_pci_quirk stac92hd73xx_fixup_tbl[] = {
 				"DFI LanParty", STAC_92HD73XX_REF),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_DFI, 0x3101,
 				"DFI LanParty", STAC_92HD73XX_REF),
+	SND_PCI_QUIRK(PCI_VENDOR_ID_INTEL, 0x5001,
+				"Intel DP45SG", STAC_92HD73XX_INTEL),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_INTEL, 0x5002,
 				"Intel DG45ID", STAC_92HD73XX_INTEL),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_INTEL, 0x5003,
diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index a9f974e5fb85..98cb3831aa18 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -1003,9 +1003,12 @@ static void btf_dump_emit_struct_def(struct btf_dump *d,
 	 * Keep `struct empty {}` on a single line,
 	 * only print newline when there are regular or padding fields.
 	 */
-	if (vlen || t->size)
+	if (vlen || t->size) {
 		btf_dump_printf(d, "\n");
-	btf_dump_printf(d, "%s}", pfx(lvl));
+		btf_dump_printf(d, "%s}", pfx(lvl));
+	} else {
+		btf_dump_printf(d, "}");
+	}
 	if (packed)
 		btf_dump_printf(d, " __attribute__((packed))");
 }
