Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37EF8CA291
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731984AbfJCQGk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:06:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:54044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732795AbfJCQGj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:06:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95A61207FF;
        Thu,  3 Oct 2019 16:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118799;
        bh=Qr5EGmTQNR2o9tv56lUO1BpJvOjnhnOrG5GY8KDWsgs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ATwvV+HlCSUsS7q7ijz59TBANNbs/9zOj70LpwSyB6qbt5aXF4w+H4NKHm5LDKRpQ
         dgtMXjDXCbtCkS6lUytRstV3HrBK32dH1BwjyeJTk4MMaAZ11Uc+owrzKWRxH/NrIG
         lW/zE8K+IBYFVbQFZd7cM+O+q0H1cve3bcvRQDNY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Niklas Cassel <niklas.cassel@linaro.org>
Subject: [PATCH 4.14 014/185] arm64: kpti: Whitelist Cortex-A CPUs that dont implement the CSV3 field
Date:   Thu,  3 Oct 2019 17:51:32 +0200
Message-Id: <20191003154440.681273301@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154437.541662648@linuxfoundation.org>
References: <20191003154437.541662648@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

commit 2a355ec25729053bb9a1a89b6c1d1cdd6c3b3fb1 upstream.

While the CSV3 field of the ID_AA64_PFR0 CPU ID register can be checked
to see if a CPU is susceptible to Meltdown and therefore requires kpti
to be enabled, existing CPUs do not implement this field.

We therefore whitelist all unaffected Cortex-A CPUs that do not implement
the CSV3 field.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Niklas Cassel <niklas.cassel@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/cpufeature.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -838,6 +838,11 @@ static bool unmap_kernel_at_el0(const st
 	switch (read_cpuid_id() & MIDR_CPU_MODEL_MASK) {
 	case MIDR_CAVIUM_THUNDERX2:
 	case MIDR_BRCM_VULCAN:
+	case MIDR_CORTEX_A53:
+	case MIDR_CORTEX_A55:
+	case MIDR_CORTEX_A57:
+	case MIDR_CORTEX_A72:
+	case MIDR_CORTEX_A73:
 		return false;
 	}
 


