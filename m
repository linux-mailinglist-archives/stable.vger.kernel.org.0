Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 661612944B4
	for <lists+stable@lfdr.de>; Tue, 20 Oct 2020 23:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438776AbgJTVps (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Oct 2020 17:45:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392145AbgJTVps (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Oct 2020 17:45:48 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70181C0613D4
        for <stable@vger.kernel.org>; Tue, 20 Oct 2020 14:45:48 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id bf6so94026plb.4
        for <stable@vger.kernel.org>; Tue, 20 Oct 2020 14:45:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HTvFqP0OKw46d5NTFeLwYbOhVPH1h7di/YxBF7zx6kw=;
        b=cMuGDNC81WjXBMwQZT0mrSYFI9GXZhGCIOf2+Djqd5ATV8Tsbc3epHC4WvyMymDcfx
         UsqeZPshP6s8qKBmcj8atxWvb4PDBuV2GDFtUqZDoOZa3rKatp6hzi+MK7aL03wzzGhc
         sNvbtzh4UT1BpdKOqtuppE+enLMZfA5BxckKE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HTvFqP0OKw46d5NTFeLwYbOhVPH1h7di/YxBF7zx6kw=;
        b=GkjNiJAuUL+TEvk0WZ4Ebo+i93AlbTFg5jIpvpqLbkqUZU18xIMgS2O7p3R/Vfwm/t
         WtO3oEwAyYarHF2Pu1yBl3C7PLPDiiL6si4buaLwJmidQCSJiE8LZJ8fmpmq0MJTBDO9
         ssIElhIQQb0fKfsplkh/E2bRdkA/nWY0awqbiarft4bVhadT5H2Th/HHpGw7mITLE+As
         fIIUulGFJTrcb4UaUVub32gac34NRCPOLZK1CfBmwwyyjh05IpOxoMbCT99Ooyv/SUDa
         sVfKT7EUJ2nBpXMB8+ZBPld0+iOhYOHJjV7UbG2DJsRI3XPBmKk+70Mf1czbRuhNTXW/
         6jUg==
X-Gm-Message-State: AOAM532s0qv8eMEc8R5XxIpaB0r0AtRQUGfIjS1ot/hG+yDjPigvGHtW
        kbeu3OL47nJCX/tXrIvTkVFjEA==
X-Google-Smtp-Source: ABdhPJx8uDqzuHW8DCZ0MEijfaTZs5muIAkd9Ybcod9OExm+FrcyxpCyD+FF+GPQJdCYNdLsNH6/1Q==
X-Received: by 2002:a17:902:c154:b029:d4:bb6f:6502 with SMTP id 20-20020a170902c154b02900d4bb6f6502mr4916999plj.23.1603230348039;
        Tue, 20 Oct 2020 14:45:48 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:3e52:82ff:fe6c:83ab])
        by smtp.gmail.com with ESMTPSA id j23sm130751pgh.31.2020.10.20.14.45.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2020 14:45:47 -0700 (PDT)
From:   Stephen Boyd <swboyd@chromium.org>
To:     Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Andre Przywara <andre.przywara@arm.com>,
        Steven Price <steven.price@arm.com>,
        Marc Zyngier <maz@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 1/2] arm64: ARM_SMCCC_ARCH_WORKAROUND_1 doesn't return SMCCC_RET_NOT_REQUIRED
Date:   Tue, 20 Oct 2020 14:45:43 -0700
Message-Id: <20201020214544.3206838-2-swboyd@chromium.org>
X-Mailer: git-send-email 2.29.0.rc1.297.gfa9743e501-goog
In-Reply-To: <20201020214544.3206838-1-swboyd@chromium.org>
References: <20201020214544.3206838-1-swboyd@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

According to the SMCCC spec (7.5.2 Discovery) the
ARM_SMCCC_ARCH_WORKAROUND_1 function id only returns 0, 1, and
SMCCC_RET_NOT_SUPPORTED corresponding to "workaround required",
"workaround not required but implemented", and "who knows, you're on
your own" respectively. For kvm hypercalls (hvc), we've implemented this
function id to return SMCCC_RET_NOT_SUPPORTED, 1, and
SMCCC_RET_NOT_REQUIRED. The SMCCC_RET_NOT_REQUIRED return value is not a
thing for this function id, and is probably copy/pasted from the
SMCCC_ARCH_WORKAROUND_2 function id that does support it.

Clean this up by returning 0, 1, and SMCCC_RET_NOT_SUPPORTED
appropriately. Changing this exposes the problem that
spectre_v2_get_cpu_fw_mitigation_state() assumes a
SMCCC_RET_NOT_SUPPORTED return value means we are vulnerable, but really
it means we have no idea and should assume we can't do anything about
mitigation. Put another way, it better be unaffected because it can't be
mitigated in the firmware (in this case kvm) as the call isn't
implemented!

Cc: Andre Przywara <andre.przywara@arm.com>
Cc: Steven Price <steven.price@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Fixes: c118bbb52743 ("arm64: KVM: Propagate full Spectre v2 workaround state to KVM guests")
Fixes: 73f381660959 ("arm64: Advertise mitigation of Spectre-v2, or lack thereof")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---

This will require a slightly different backport to stable kernels, but
at least it looks like this is a problem given that this return value
isn't valid per the spec and we've been going around it by returning
something invalid for some time.

 arch/arm64/kernel/proton-pack.c | 3 +--
 arch/arm64/kvm/hypercalls.c     | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/proton-pack.c b/arch/arm64/kernel/proton-pack.c
index 68b710f1b43f..00bd54f63f4f 100644
--- a/arch/arm64/kernel/proton-pack.c
+++ b/arch/arm64/kernel/proton-pack.c
@@ -149,10 +149,9 @@ static enum mitigation_state spectre_v2_get_cpu_fw_mitigation_state(void)
 	case SMCCC_RET_SUCCESS:
 		return SPECTRE_MITIGATED;
 	case SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED:
+	case SMCCC_RET_NOT_SUPPORTED: /* Good luck w/ the Gatekeeper of Gozer */
 		return SPECTRE_UNAFFECTED;
 	default:
-		fallthrough;
-	case SMCCC_RET_NOT_SUPPORTED:
 		return SPECTRE_VULNERABLE;
 	}
 }
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 9824025ccc5c..868486957808 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -31,7 +31,7 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 				val = SMCCC_RET_SUCCESS;
 				break;
 			case SPECTRE_UNAFFECTED:
-				val = SMCCC_RET_NOT_REQUIRED;
+				val = SMCCC_RET_NOT_SUPPORTED;
 				break;
 			}
 			break;
-- 
Sent by a computer, using git, on the internet

