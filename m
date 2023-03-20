Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 238116C19A6
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233161AbjCTPg3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233171AbjCTPgB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:36:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12FAE1B333
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:28:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB9086158F
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:28:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6FC8C433D2;
        Mon, 20 Mar 2023 15:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679326085;
        bh=SVDwlxeWMEPclTR6lDXapNjdWJA/MP8bT13JdjnxGDU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lBoE7NAF6GVBUm8AEor+B57OxPSkkY9cwXZ14cWe5iYySmghrdbDA6KZU4Qxq+dYK
         +evkXJYhHk2XSXrNXmRty+le6i9jbo6sFPF+HOD4h8UnEXX991sHzqGOo2zgm4tzXA
         kWk7uEEEMblPlrkZ4D3D3Dvbx4IjMnivTRJK5P+s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dionna Glaze <dionnaglaze@google.com>,
        "Borislav Petkov (AMD)" <bp@alien8.de>,
        Tom Lendacky <thomas.lendacky@amd.com>, stable@kernel.org
Subject: [PATCH 6.1 197/198] virt/coco/sev-guest: Add throttling awareness
Date:   Mon, 20 Mar 2023 15:55:35 +0100
Message-Id: <20230320145515.720561444@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dionna Glaze <dionnaglaze@google.com>

commit 72f7754dcf31c87c92c0c353dcf747814cc5ce10 upstream.

A potentially malicious SEV guest can constantly hammer the hypervisor
using this driver to send down requests and thus prevent or at least
considerably hinder other guests from issuing requests to the secure
processor which is a shared platform resource.

Therefore, the host is permitted and encouraged to throttle such guest
requests.

Add the capability to handle the case when the hypervisor throttles
excessive numbers of requests issued by the guest. Otherwise, the VM
platform communication key will be disabled, preventing the guest from
attesting itself.

Realistically speaking, a well-behaved guest should not even care about
throttling. During its lifetime, it would end up issuing a handful of
requests which the hardware can easily handle.

This is more to address the case of a malicious guest. Such guest should
get throttled and if its VMPCK gets disabled, then that's its own
wrongdoing and perhaps that guest even deserves it.

To the implementation: the hypervisor signals with SNP_GUEST_REQ_ERR_BUSY
that the guest requests should be throttled. That error code is returned
in the upper 32-bit half of exitinfo2 and this is part of the GHCB spec
v2.

So the guest is given a throttling period of 1 minute in which it
retries the request every 2 seconds. This is a good default but if it
turns out to not pan out in practice, it can be tweaked later.

For safety, since the encryption algorithm in GHCBv2 is AES_GCM, control
must remain in the kernel to complete the request with the current
sequence number. Returning without finishing the request allows the
guest to make another request but with different message contents. This
is IV reuse, and breaks cryptographic protections.

  [ bp:
    - Rewrite commit message and do a simplified version.
    - The stable tags are supposed to denote that a cleanup should go
      upfront before backporting this so that any future fixes to this
      can preserve the sanity of the backporter(s). ]

Fixes: d5af44dde546 ("x86/sev: Provide support for SNP guest request NAEs")
Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
Co-developed-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Cc: <stable@kernel.org> # d6fd48eff750 ("virt/coco/sev-guest: Check SEV_SNP attribute at probe time")
Cc: <stable@kernel.org> # 970ab823743f (" virt/coco/sev-guest: Simplify extended guest request handling")
Cc: <stable@kernel.org> # c5a338274bdb ("virt/coco/sev-guest: Remove the disable_vmpck label in handle_guest_request()")
Cc: <stable@kernel.org> # 0fdb6cc7c89c ("virt/coco/sev-guest: Carve out the request issuing logic into a helper")
Cc: <stable@kernel.org> # d25bae7dc7b0 ("virt/coco/sev-guest: Do some code style cleanups")
Cc: <stable@kernel.org> # fa4ae42cc60a ("virt/coco/sev-guest: Convert the sw_exit_info_2 checking to a switch-case")
Link: https://lore.kernel.org/r/20230214164638.1189804-2-dionnaglaze@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/sev-common.h       |    3 ++-
 arch/x86/kernel/sev.c                   |    4 ++++
 drivers/virt/coco/sev-guest/sev-guest.c |   19 ++++++++++++++++++-
 3 files changed, 24 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -128,8 +128,9 @@ struct snp_psc_desc {
 	struct psc_entry entries[VMGEXIT_PSC_MAX_ENTRY];
 } __packed;
 
-/* Guest message request error code */
+/* Guest message request error codes */
 #define SNP_GUEST_REQ_INVALID_LEN	BIT_ULL(32)
+#define SNP_GUEST_REQ_ERR_BUSY		BIT_ULL(33)
 
 #define GHCB_MSR_TERM_REQ		0x100
 #define GHCB_MSR_TERM_REASON_SET_POS	12
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -2214,6 +2214,10 @@ int snp_issue_guest_request(u64 exit_cod
 	case 0:
 		break;
 
+	case SNP_GUEST_REQ_ERR_BUSY:
+		ret = -EAGAIN;
+		break;
+
 	case SNP_GUEST_REQ_INVALID_LEN:
 		/* Number of expected pages are returned in RBX */
 		if (exit_code == SVM_VMGEXIT_EXT_GUEST_REQUEST) {
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -31,6 +31,9 @@
 #define AAD_LEN		48
 #define MSG_HDR_VER	1
 
+#define SNP_REQ_MAX_RETRY_DURATION	(60*HZ)
+#define SNP_REQ_RETRY_DELAY		(2*HZ)
+
 struct snp_guest_crypto {
 	struct crypto_aead *tfm;
 	u8 *iv, *authtag;
@@ -322,7 +325,8 @@ static int enc_payload(struct snp_guest_
 
 static int __handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code, __u64 *fw_err)
 {
-	unsigned long err, override_err = 0;
+	unsigned long err = 0xff, override_err = 0;
+	unsigned long req_start = jiffies;
 	unsigned int override_npages = 0;
 	int rc;
 
@@ -362,6 +366,19 @@ retry_request:
 		 * user as an ioctl() return code.
 		 */
 		goto retry_request;
+
+	/*
+	 * The host may return SNP_GUEST_REQ_ERR_EBUSY if the request has been
+	 * throttled. Retry in the driver to avoid returning and reusing the
+	 * message sequence number on a different message.
+	 */
+	case -EAGAIN:
+		if (jiffies - req_start > SNP_REQ_MAX_RETRY_DURATION) {
+			rc = -ETIMEDOUT;
+			break;
+		}
+		schedule_timeout_killable(SNP_REQ_RETRY_DELAY);
+		goto retry_request;
 	}
 
 	/*


