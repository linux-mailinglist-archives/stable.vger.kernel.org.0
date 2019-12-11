Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 384E611BE7A
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 21:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727238AbfLKUsr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 15:48:47 -0500
Received: from mail-pl1-f201.google.com ([209.85.214.201]:48264 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727237AbfLKUsq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 15:48:46 -0500
Received: by mail-pl1-f201.google.com with SMTP id v12so35667plp.15
        for <stable@vger.kernel.org>; Wed, 11 Dec 2019 12:48:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=V8+gZI//oIJHuoz/ZeRsxsnZlGzWnWp3v3uXjbH3p+g=;
        b=WTNM2YjpCbOyYnBe9GT6fAZ1ArYu0wM3PiT+MJmFZGX6j+F8TohfOS2bKnExtHAhss
         Z0wWHPuiV3y0OHS+dzvFjIkhQBtl1jgYtgD+DMaDO64qu8xjHXWzYMz4u9laBgReuh1q
         6FiksdGos2cOH213T7Ezyyj/rlbw0DhKdpcWx+xlBMbrt4dvbrBiorj/i5uN+T2lyNe+
         YgNVLqGfUYzq9yAyJZGTVdfcAlLrxXJlQekcwwL1MiTS8UNXE3NTCW+DhItBkqUXhFkV
         U5RE/C/rX/Y87x45223li/KA2CtK5BJnjzm3QQ0yxHr6zlrue4tb4lQc0XP1sRmWZtNW
         nwfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=V8+gZI//oIJHuoz/ZeRsxsnZlGzWnWp3v3uXjbH3p+g=;
        b=WAoyRg1i0rzLpM8skQuQzqYmstlDpkVgGgXgi0nT9lK776S6jSElWaNH1W5VZY7OvW
         PEz5fgBJys7e2sCHliM0zni4IjuxF98ueI0kHhWJGqVP+V229UhS7kcRRA9XtWdH/j6c
         mp0UNW/Yze761GfnhJ+OAnI8dDOmBO2iOC+KZ9oJMTGbItlPt74pfSndzNJ9WudMhaVT
         gepzCyLnqkQGSP6jRZbZ0XWLKh47x0X1ien4y6sWmMiku1jY8sXE++1hJ6Qd569780eC
         M5ihl6JYyGcol+B/cLcs16wxp33MeJLmJjkkBwFTKpTg3X2+BQ/GJ9M299kKl1WtnAVR
         TYqQ==
X-Gm-Message-State: APjAAAUo2oDCAi9mb5v1xxZIKk/eYJ5SiU/OoEqKk6fbqzD66ZpzK38l
        mWdn9e7x9JC5oGK4hWl+urMey3knR2Wl
X-Google-Smtp-Source: APXvYqxM2bhaZfdgEAP320RojcgymxqaM2uW7VBYzwsTTen8mf2FPyZN6CH3k6mxVBkkuLCmC/7U7+ulQ3cX
X-Received: by 2002:a63:e608:: with SMTP id g8mr6182692pgh.448.1576097325332;
 Wed, 11 Dec 2019 12:48:45 -0800 (PST)
Date:   Wed, 11 Dec 2019 12:47:45 -0800
In-Reply-To: <20191211204753.242298-1-pomonis@google.com>
Message-Id: <20191211204753.242298-6-pomonis@google.com>
Mime-Version: 1.0
References: <20191211204753.242298-1-pomonis@google.com>
X-Mailer: git-send-email 2.24.0.525.g8f36a354ae-goog
Subject: [PATCH v2 05/13] KVM: x86: Protect ioapic_write_indirect() from
 Spectre-v1/L1TF attacks
From:   Marios Pomonis <pomonis@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, rkrcmar@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nick Finco <nifi@google.com>, Andrew Honig <ahonig@google.com>,
        Marios Pomonis <pomonis@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This fixes a Spectre-v1/L1TF vulnerability in ioapic_write_indirect().
This function contains index computations based on the
(attacker-controlled) IOREGSEL register.

This patch depends on patch
"KVM: x86: Protect ioapic_read_indirect() from Spectre-v1/L1TF attacks".

Fixes: commit 70f93dae32ac ("KVM: Use temporary variable to shorten lines.")

Signed-off-by: Nick Finco <nifi@google.com>
Signed-off-by: Marios Pomonis <pomonis@google.com>
Reviewed-by: Andrew Honig <ahonig@google.com>
Cc: stable@vger.kernel.org
---
 arch/x86/kvm/ioapic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index 0c672eefaabe..8aa58727045e 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -294,6 +294,7 @@ static void ioapic_write_indirect(struct kvm_ioapic *ioapic, u32 val)
 
 		if (index >= IOAPIC_NUM_PINS)
 			return;
+		index = array_index_nospec(index, IOAPIC_NUM_PINS);
 		e = &ioapic->redirtbl[index];
 		mask_before = e->fields.mask;
 		/* Preserve read-only fields */
-- 
2.24.0.525.g8f36a354ae-goog

