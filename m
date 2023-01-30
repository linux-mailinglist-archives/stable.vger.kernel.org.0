Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4BEC681105
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:09:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237152AbjA3OJm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:09:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237151AbjA3OJl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:09:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9437C3B3C4
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:09:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 262CCB8117E
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:09:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 662B7C433D2;
        Mon, 30 Jan 2023 14:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087776;
        bh=A7MJluvKKOehiUS411hZoOYBuRaj6ZQreaW7u51AjV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ir0aZ5JiNCycOEbkRdBWk2EDZONY1VNlQreoPt7uxhx+Vaq0Y4NFd2pFkjsCM/NfY
         Pg/2wk64S3N0iELUlkJ4eTcsYlPk4ppFayUgTTG1F5zzTVv7u+KCC94IVlqQzxislE
         V4aH0dHRbrte0x+pNiAapUHxSvF0Y+Ftwnz+Gq9E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nikunj A Dadhania <nikunj@amd.com>,
        "Borislav Petkov (AMD)" <bp@alien8.de>,
        Tom Lendacky <thomas.lendacky@amd.com>, stable@kernel.org
Subject: [PATCH 6.1 306/313] x86/sev: Add SEV-SNP guest feature negotiation support
Date:   Mon, 30 Jan 2023 14:52:21 +0100
Message-Id: <20230130134350.991852519@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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

From: Nikunj A Dadhania <nikunj@amd.com>

commit 8c29f016540532582721cec1dbf6d144873433ba upstream.

The hypervisor can enable various new features (SEV_FEATURES[1:63]) and start a
SNP guest. Some of these features need guest side implementation. If any of
these features are enabled without it, the behavior of the SNP guest will be
undefined.  It may fail booting in a non-obvious way making it difficult to
debug.

Instead of allowing the guest to continue and have it fail randomly later,
detect this early and fail gracefully.

The SEV_STATUS MSR indicates features which the hypervisor has enabled.  While
booting, SNP guests should ascertain that all the enabled features have guest
side implementation. In case a feature is not implemented in the guest, the
guest terminates booting with GHCB protocol Non-Automatic Exit(NAE) termination
request event, see "SEV-ES Guest-Hypervisor Communication Block Standardization"
document (currently at https://developer.amd.com/wp-content/resources/56421.pdf),
section "Termination Request".

Populate SW_EXITINFO2 with mask of unsupported features that the hypervisor can
easily report to the user.

More details in the AMD64 APM Vol 2, Section "SEV_STATUS MSR".

  [ bp:
    - Massage.
    - Move snp_check_features() call to C code.
    Note: the CC:stable@ aspect here is to be able to protect older, stable
    kernels when running on newer hypervisors. Or not "running" but fail
    reliably and in a well-defined manner instead of randomly. ]

Fixes: cbd3d4f7c4e5 ("x86/sev: Check SEV-SNP features support")
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Cc: <stable@kernel.org>
Link: https://lore.kernel.org/r/20230118061943.534309-1-nikunj@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/x86/amd-memory-encryption.rst |   36 ++++++++++++++
 arch/x86/boot/compressed/ident_map_64.c     |    6 ++
 arch/x86/boot/compressed/misc.h             |    2 
 arch/x86/boot/compressed/sev.c              |   70 ++++++++++++++++++++++++++++
 arch/x86/include/asm/msr-index.h            |   20 ++++++++
 arch/x86/include/uapi/asm/svm.h             |    6 ++
 6 files changed, 140 insertions(+)

--- a/Documentation/x86/amd-memory-encryption.rst
+++ b/Documentation/x86/amd-memory-encryption.rst
@@ -95,3 +95,39 @@ by supplying mem_encrypt=on on the kerne
 not enable SME, then Linux will not be able to activate memory encryption, even
 if configured to do so by default or the mem_encrypt=on command line parameter
 is specified.
+
+Secure Nested Paging (SNP)
+==========================
+
+SEV-SNP introduces new features (SEV_FEATURES[1:63]) which can be enabled
+by the hypervisor for security enhancements. Some of these features need
+guest side implementation to function correctly. The below table lists the
+expected guest behavior with various possible scenarios of guest/hypervisor
+SNP feature support.
+
++-----------------+---------------+---------------+------------------+
+| Feature Enabled | Guest needs   | Guest has     | Guest boot       |
+| by the HV       | implementation| implementation| behaviour        |
++=================+===============+===============+==================+
+|      No         |      No       |      No       |     Boot         |
+|                 |               |               |                  |
++-----------------+---------------+---------------+------------------+
+|      No         |      Yes      |      No       |     Boot         |
+|                 |               |               |                  |
++-----------------+---------------+---------------+------------------+
+|      No         |      Yes      |      Yes      |     Boot         |
+|                 |               |               |                  |
++-----------------+---------------+---------------+------------------+
+|      Yes        |      No       |      No       | Boot with        |
+|                 |               |               | feature enabled  |
++-----------------+---------------+---------------+------------------+
+|      Yes        |      Yes      |      No       | Graceful boot    |
+|                 |               |               | failure          |
++-----------------+---------------+---------------+------------------+
+|      Yes        |      Yes      |      Yes      | Boot with        |
+|                 |               |               | feature enabled  |
++-----------------+---------------+---------------+------------------+
+
+More details in AMD64 APM[1] Vol 2: 15.34.10 SEV_STATUS MSR
+
+[1] https://www.amd.com/system/files/TechDocs/40332.pdf
--- a/arch/x86/boot/compressed/ident_map_64.c
+++ b/arch/x86/boot/compressed/ident_map_64.c
@@ -180,6 +180,12 @@ void initialize_identity_maps(void *rmod
 
 	/* Load the new page-table. */
 	write_cr3(top_level_pgt);
+
+	/*
+	 * Now that the required page table mappings are established and a
+	 * GHCB can be used, check for SNP guest/HV feature compatibility.
+	 */
+	snp_check_features();
 }
 
 static pte_t *split_large_pmd(struct x86_mapping_info *info,
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -126,6 +126,7 @@ static inline void console_init(void)
 
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 void sev_enable(struct boot_params *bp);
+void snp_check_features(void);
 void sev_es_shutdown_ghcb(void);
 extern bool sev_es_check_ghcb_fault(unsigned long address);
 void snp_set_page_private(unsigned long paddr);
@@ -143,6 +144,7 @@ static inline void sev_enable(struct boo
 	if (bp)
 		bp->cc_blob_address = 0;
 }
+static inline void snp_check_features(void) { }
 static inline void sev_es_shutdown_ghcb(void) { }
 static inline bool sev_es_check_ghcb_fault(unsigned long address)
 {
--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -208,6 +208,23 @@ void sev_es_shutdown_ghcb(void)
 		error("Can't unmap GHCB page");
 }
 
+static void __noreturn sev_es_ghcb_terminate(struct ghcb *ghcb, unsigned int set,
+					     unsigned int reason, u64 exit_info_2)
+{
+	u64 exit_info_1 = SVM_VMGEXIT_TERM_REASON(set, reason);
+
+	vc_ghcb_invalidate(ghcb);
+	ghcb_set_sw_exit_code(ghcb, SVM_VMGEXIT_TERM_REQUEST);
+	ghcb_set_sw_exit_info_1(ghcb, exit_info_1);
+	ghcb_set_sw_exit_info_2(ghcb, exit_info_2);
+
+	sev_es_wr_ghcb_msr(__pa(ghcb));
+	VMGEXIT();
+
+	while (true)
+		asm volatile("hlt\n" : : : "memory");
+}
+
 bool sev_es_check_ghcb_fault(unsigned long address)
 {
 	/* Check whether the fault was on the GHCB page */
@@ -270,6 +287,59 @@ static void enforce_vmpl0(void)
 		sev_es_terminate(SEV_TERM_SET_LINUX, GHCB_TERM_NOT_VMPL0);
 }
 
+/*
+ * SNP_FEATURES_IMPL_REQ is the mask of SNP features that will need
+ * guest side implementation for proper functioning of the guest. If any
+ * of these features are enabled in the hypervisor but are lacking guest
+ * side implementation, the behavior of the guest will be undefined. The
+ * guest could fail in non-obvious way making it difficult to debug.
+ *
+ * As the behavior of reserved feature bits is unknown to be on the
+ * safe side add them to the required features mask.
+ */
+#define SNP_FEATURES_IMPL_REQ	(MSR_AMD64_SNP_VTOM |			\
+				 MSR_AMD64_SNP_REFLECT_VC |		\
+				 MSR_AMD64_SNP_RESTRICTED_INJ |		\
+				 MSR_AMD64_SNP_ALT_INJ |		\
+				 MSR_AMD64_SNP_DEBUG_SWAP |		\
+				 MSR_AMD64_SNP_VMPL_SSS |		\
+				 MSR_AMD64_SNP_SECURE_TSC |		\
+				 MSR_AMD64_SNP_VMGEXIT_PARAM |		\
+				 MSR_AMD64_SNP_VMSA_REG_PROTECTION |	\
+				 MSR_AMD64_SNP_RESERVED_BIT13 |		\
+				 MSR_AMD64_SNP_RESERVED_BIT15 |		\
+				 MSR_AMD64_SNP_RESERVED_MASK)
+
+/*
+ * SNP_FEATURES_PRESENT is the mask of SNP features that are implemented
+ * by the guest kernel. As and when a new feature is implemented in the
+ * guest kernel, a corresponding bit should be added to the mask.
+ */
+#define SNP_FEATURES_PRESENT (0)
+
+void snp_check_features(void)
+{
+	u64 unsupported;
+
+	if (!(sev_status & MSR_AMD64_SEV_SNP_ENABLED))
+		return;
+
+	/*
+	 * Terminate the boot if hypervisor has enabled any feature lacking
+	 * guest side implementation. Pass on the unsupported features mask through
+	 * EXIT_INFO_2 of the GHCB protocol so that those features can be reported
+	 * as part of the guest boot failure.
+	 */
+	unsupported = sev_status & SNP_FEATURES_IMPL_REQ & ~SNP_FEATURES_PRESENT;
+	if (unsupported) {
+		if (ghcb_version < 2 || (!boot_ghcb && !early_setup_ghcb()))
+			sev_es_terminate(SEV_TERM_SET_GEN, GHCB_SNP_UNSUPPORTED);
+
+		sev_es_ghcb_terminate(boot_ghcb, SEV_TERM_SET_GEN,
+				      GHCB_SNP_UNSUPPORTED, unsupported);
+	}
+}
+
 void sev_enable(struct boot_params *bp)
 {
 	unsigned int eax, ebx, ecx, edx;
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -571,6 +571,26 @@
 #define MSR_AMD64_SEV_ES_ENABLED	BIT_ULL(MSR_AMD64_SEV_ES_ENABLED_BIT)
 #define MSR_AMD64_SEV_SNP_ENABLED	BIT_ULL(MSR_AMD64_SEV_SNP_ENABLED_BIT)
 
+/* SNP feature bits enabled by the hypervisor */
+#define MSR_AMD64_SNP_VTOM			BIT_ULL(3)
+#define MSR_AMD64_SNP_REFLECT_VC		BIT_ULL(4)
+#define MSR_AMD64_SNP_RESTRICTED_INJ		BIT_ULL(5)
+#define MSR_AMD64_SNP_ALT_INJ			BIT_ULL(6)
+#define MSR_AMD64_SNP_DEBUG_SWAP		BIT_ULL(7)
+#define MSR_AMD64_SNP_PREVENT_HOST_IBS		BIT_ULL(8)
+#define MSR_AMD64_SNP_BTB_ISOLATION		BIT_ULL(9)
+#define MSR_AMD64_SNP_VMPL_SSS			BIT_ULL(10)
+#define MSR_AMD64_SNP_SECURE_TSC		BIT_ULL(11)
+#define MSR_AMD64_SNP_VMGEXIT_PARAM		BIT_ULL(12)
+#define MSR_AMD64_SNP_IBS_VIRT			BIT_ULL(14)
+#define MSR_AMD64_SNP_VMSA_REG_PROTECTION	BIT_ULL(16)
+#define MSR_AMD64_SNP_SMT_PROTECTION		BIT_ULL(17)
+
+/* SNP feature bits reserved for future use. */
+#define MSR_AMD64_SNP_RESERVED_BIT13		BIT_ULL(13)
+#define MSR_AMD64_SNP_RESERVED_BIT15		BIT_ULL(15)
+#define MSR_AMD64_SNP_RESERVED_MASK		GENMASK_ULL(63, 18)
+
 #define MSR_AMD64_VIRT_SPEC_CTRL	0xc001011f
 
 /* AMD Collaborative Processor Performance Control MSRs */
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -116,6 +116,12 @@
 #define SVM_VMGEXIT_AP_CREATE			1
 #define SVM_VMGEXIT_AP_DESTROY			2
 #define SVM_VMGEXIT_HV_FEATURES			0x8000fffd
+#define SVM_VMGEXIT_TERM_REQUEST		0x8000fffe
+#define SVM_VMGEXIT_TERM_REASON(reason_set, reason_code)	\
+	/* SW_EXITINFO1[3:0] */					\
+	(((((u64)reason_set) & 0xf)) |				\
+	/* SW_EXITINFO1[11:4] */				\
+	((((u64)reason_code) & 0xff) << 4))
 #define SVM_VMGEXIT_UNSUPPORTED_EVENT		0x8000ffff
 
 /* Exit code reserved for hypervisor/software use */


