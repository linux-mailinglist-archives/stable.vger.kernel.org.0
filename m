Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5CA14B98A
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730651AbgA1OZg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:25:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:52626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732959AbgA1OZf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:25:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03F4D24686;
        Tue, 28 Jan 2020 14:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221535;
        bh=WZKi91Qb+hIqQzuLMjQLrerJQVMOSj3EzXxFrKloU1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pQv9aVtKvqY9vDcTRwdJ1FUJhAggwrWD5FY0HK3V+OWO4k8ThWCnG4MvWhkW3Qkz5
         Ix1XojhJZcYi9SZD+N7TZbWg7Wi99RmuFIMmUz708pH1kcMQ6ALRrGdmFdBCE7TJSq
         r2/S2ay1MxCixamIF3azt85pisITHWclAVLWIcZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 4.9 262/271] arm64: kpti: Whitelist Cortex-A CPUs that dont implement the CSV3 field
Date:   Tue, 28 Jan 2020 15:06:51 +0100
Message-Id: <20200128135912.099755783@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
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
[florian: adjust whilelist location and table to stable-4.9.y]
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/cpufeature.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -789,6 +789,11 @@ static bool unmap_kernel_at_el0(const st
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
 


