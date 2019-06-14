Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 053064527D
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 05:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbfFNDNM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 23:13:12 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:39729 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbfFNDNM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 23:13:12 -0400
Received: by mail-pf1-f195.google.com with SMTP id j2so494033pfe.6
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 20:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hP63VKEYPHg3zKNj3xMaZwjK56Qq/K++eO//dDzRjvk=;
        b=XKzO/FoVC0F/C4cPzxh2/w9xDeu3OZ3640Q66sWIDaYrI4StlFuJ3ZBr1yFuUuBOeD
         lAPWHE6wpJixcIXHSeVdX7HYeAwZ1jk4l8IId6e2YoZyHBTw1Cbhs+1ZcCD7HmWfBg9Z
         Mg/z8WeXnPtbWv3DcJW9vguLf6NclZdtb2PHrhx7vP4hvspjwrd/UcpBOqakQ23I8YJj
         wKS5TakaT13Waa8g7uoG37UWjq8U6cOWr0o3yUbZXY9T7L8MuVXzIqFMxExia6clUbSu
         HApz5WTgOGxo7STDNUHSQuiqTJd4DXkW5nwubO7ta7JT7OFDH/B+bGerim8MwpmMSWzp
         9rRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hP63VKEYPHg3zKNj3xMaZwjK56Qq/K++eO//dDzRjvk=;
        b=k03OtpJM2jhqOvdgBQreux+IJvcnFYephu2AE5kjIV7Ic337jTt+AK9qGXvz+fzviU
         KRAnTg/ejYmjHn4R89r6vmOERl3IpMp8ZrytC+9UPCHcg5pH6xTq4u907ePlnRZUzdop
         dvO+pxbtyNYIuZu6kKBMpQzAJjvt8Cs6Yvg/FJojtUpn9VHKV2hSKkLuo3KnnEFlID31
         JvTHSPtudMYhMCsejNrIUKQmGjNySlBKA6Z7TjZmkPpC34t1NDsdqouXlJCMRfgF8vWm
         1tbI1QwcmeUn9XIymoNpnlQhsJkl/uOxXYE665Uw0T5FpWdmmqZDVp4cd5Je62uzW503
         T+aA==
X-Gm-Message-State: APjAAAWHIdvy63Bmp6PScQeMvxqziXOSmO8x4A2NvNnTJZUXvron4jSf
        G0euZLGzVEfPpZvRC1XiN13BVw==
X-Google-Smtp-Source: APXvYqz3iGB3sFLe1ujAa4CWxg87VdsLELINdehSRwwhAyr0qsSp+adC3/BhKcW2M+2In5oYCgZjeg==
X-Received: by 2002:a63:545a:: with SMTP id e26mr33192910pgm.162.1560481991000;
        Thu, 13 Jun 2019 20:13:11 -0700 (PDT)
Received: from localhost ([122.172.66.84])
        by smtp.gmail.com with ESMTPSA id b16sm1067054pfd.12.2019.06.13.20.13.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 20:13:10 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     linux-arm-kernel@lists.infradead.org,
        Julien Thierry <Julien.Thierry@arm.com>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: [PATCH v4.4 29/45] arm64: KVM: Increment PC after handling an SMC trap
Date:   Fri, 14 Jun 2019 08:38:12 +0530
Message-Id: <2798950c13d82c9e5b4c9a94afe8eeeef052283a.1560480942.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1560480942.git.viresh.kumar@linaro.org>
References: <cover.1560480942.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <marc.zyngier@arm.com>

commit f5115e8869e1dfafac0e414b4f1664f3a84a4683 upstream.

When handling an SMC trap, the "preferred return address" is set
to that of the SMC, and not the next PC (which is a departure from
the behaviour of an SMC that isn't trapped).

Increment PC in the handler, as the guest is otherwise forever
stuck...

Cc: stable@vger.kernel.org
Fixes: acfb3b883f6d ("arm64: KVM: Fix SMCCC handling of unimplemented SMC/HVC calls")
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Tested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm64/kvm/handle_exit.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 5295aef7c8f0..c43e0e100c11 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -51,7 +51,16 @@ static int handle_hvc(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
 static int handle_smc(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
+	/*
+	 * "If an SMC instruction executed at Non-secure EL1 is
+	 * trapped to EL2 because HCR_EL2.TSC is 1, the exception is a
+	 * Trap exception, not a Secure Monitor Call exception [...]"
+	 *
+	 * We need to advance the PC after the trap, as it would
+	 * otherwise return to the same address...
+	 */
 	vcpu_set_reg(vcpu, 0, ~0UL);
+	kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
 	return 1;
 }
 
-- 
2.21.0.rc0.269.g1a574e7a288b

