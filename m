Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C20D395886
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 11:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231271AbhEaJ7c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 05:59:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:57624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231239AbhEaJ7b (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 05:59:31 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF500610A0;
        Mon, 31 May 2021 09:57:51 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1lnegA-004Z7v-3a; Mon, 31 May 2021 10:57:50 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kexec@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Bhupesh SHARMA <bhupesh.sharma@linaro.org>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        Dave Young <dyoung@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Moritz Fischer <mdf@kernel.org>, kernel-team@android.com,
        stable@vger.kernel.org
Subject: [PATCH v2 1/5] arm64: kexec_file: Forbid non-crash kernels
Date:   Mon, 31 May 2021 10:57:16 +0100
Message-Id: <20210531095720.77469-2-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210531095720.77469-1-maz@kernel.org>
References: <20210531095720.77469-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kexec@lists.infradead.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org, ardb@kernel.org, mark.rutland@arm.com, james.morse@arm.com, lorenzo.pieralisi@arm.com, guohanjun@huawei.com, sudeep.holla@arm.com, ebiederm@xmission.com, bhupesh.sharma@linaro.org, takahiro.akashi@linaro.org, dyoung@redhat.com, akpm@linux-foundation.org, mdf@kernel.org, kernel-team@android.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It has been reported that kexec_file doesn't really work on arm64.
It completely ignores any of the existing reservations, which results
in the secondary kernel being loaded where the GICv3 LPI tables live,
or even corrupting the ACPI tables.

Since only crash kernels are imune to this as they use a reserved
memory region, disable the non-crash kernel use case. Further
patches will try and restore the functionality.

Reported-by: Moritz Fischer <mdf@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org # 5.10
---
 arch/arm64/kernel/kexec_image.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm64/kernel/kexec_image.c b/arch/arm64/kernel/kexec_image.c
index 9ec34690e255..acf9cd251307 100644
--- a/arch/arm64/kernel/kexec_image.c
+++ b/arch/arm64/kernel/kexec_image.c
@@ -145,3 +145,23 @@ const struct kexec_file_ops kexec_image_ops = {
 	.verify_sig = image_verify_sig,
 #endif
 };
+
+/**
+ * arch_kexec_locate_mem_hole - Find free memory to place the segments.
+ * @kbuf:                       Parameters for the memory search.
+ *
+ * On success, kbuf->mem will have the start address of the memory region found.
+ *
+ * Return: 0 on success, negative errno on error.
+ */
+int arch_kexec_locate_mem_hole(struct kexec_buf *kbuf)
+{
+	/*
+	 * For the time being, kexec_file_load isn't reliable except
+	 * for crash kernel. Say sorry to the user.
+	 */
+	if (kbuf->image->type != KEXEC_TYPE_CRASH)
+		return -EADDRNOTAVAIL;
+
+	return kexec_locate_mem_hole(kbuf);
+}
-- 
2.30.2

