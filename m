Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C33F311BE62
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 21:49:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727223AbfLKUsm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 15:48:42 -0500
Received: from mail-qk1-f202.google.com ([209.85.222.202]:55942 "EHLO
        mail-qk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727221AbfLKUsl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 15:48:41 -0500
Received: by mail-qk1-f202.google.com with SMTP id l4so3606016qkb.22
        for <stable@vger.kernel.org>; Wed, 11 Dec 2019 12:48:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=xrwWZr7+yzERFLJE/Z3uSFj6cr0eIdhI9uswQFoegFk=;
        b=jxEdKEYtgfZbjl/vkHg9Kg0KK+voQHEZ6fX8otH6OE0Lwrd/nBAOBuJn5BCMqpY0T2
         uJV1WGHgri9bp47i8kJ9fmrOGDK/vAzeqD7TM11RD/UnLXEc30Qoe3dnOB2nJz20Bbhf
         33A8ZrId+JQRPAzKq9MgBEGpJOpu5GGdTLqSX1ZLDvlA+245HmH7zc0ZJ8OhhtgKZNTj
         JIeuxNUzbuMb5xNWkSnA4mqHF6SU1bpaW8rlyl4dZ3Z5ymSV7QB8Jc5OwClDBwV6LRbz
         4ERfYgNY3I7QMk6yJ3AkGovrZfBIU7X9n0PPx3tLpGXv7UtbYosNxyIFIn9uL7AZowwu
         UTeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=xrwWZr7+yzERFLJE/Z3uSFj6cr0eIdhI9uswQFoegFk=;
        b=U4VkayWE8Rh/TeDlkkupR3IVx2cSANur7yNO3SHrI50NJ3ANuV/lqchrCv9HKpylNO
         l85DQkuwOoTfQsXaldFTeOHHhJmYc6AOgISliFRrjbHCkEG2wOSJVsllAIvO//MEkq3m
         rhvB3u8AJX3IS4mq4yRLr1bHxwBYEjvrjbZrwWLfqYJOUjjHcQQseQ/ajcIJL5a1Kzqj
         6r4TTNmA0PxEdfzO+SnV/VkR2x+0p7jImPc11pzeQAQVcGMUku5zeLGO5molvllGSQbU
         d7FRKW8Y4zNP6LfsZSEVV+deO84NPQM41deZAZsVi8jBXFGWEeqS/iAzl6dESI/qe8ux
         WzAg==
X-Gm-Message-State: APjAAAUrOXZnnlQiiDRAvftYMU8wxxYKEkMknHrhKYgBDgQAQeGLXFi9
        rm11aV0Q86V8bwGUfns01ccVkvUoZtfM
X-Google-Smtp-Source: APXvYqx8uEo2IEqmN5Sh6hvDJC10bKAoPxZmbscTg7BYMNdwPv/+mGXNI+Ahl6O/HftZUPZhDUbBNq7vBOZ9
X-Received: by 2002:aed:3f32:: with SMTP id p47mr409813qtf.374.1576097320529;
 Wed, 11 Dec 2019 12:48:40 -0800 (PST)
Date:   Wed, 11 Dec 2019 12:47:44 -0800
In-Reply-To: <20191211204753.242298-1-pomonis@google.com>
Message-Id: <20191211204753.242298-5-pomonis@google.com>
Mime-Version: 1.0
References: <20191211204753.242298-1-pomonis@google.com>
X-Mailer: git-send-email 2.24.0.525.g8f36a354ae-goog
Subject: [PATCH v2 04/13] KVM: x86: Protect ioapic_read_indirect() from
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

This fixes a Spectre-v1/L1TF vulnerability in ioapic_read_indirect().
This function contains index computations based on the
(attacker-controlled) IOREGSEL register.

Fixes: commit a2c118bfab8b ("KVM: Fix bounds checking in ioapic indirect register reads (CVE-2013-1798)")

Signed-off-by: Nick Finco <nifi@google.com>
Signed-off-by: Marios Pomonis <pomonis@google.com>
Reviewed-by: Andrew Honig <ahonig@google.com>
Cc: stable@vger.kernel.org
---
 arch/x86/kvm/ioapic.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index 9fd2dd89a1c5..0c672eefaabe 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -36,6 +36,7 @@
 #include <linux/io.h>
 #include <linux/slab.h>
 #include <linux/export.h>
+#include <linux/nospec.h>
 #include <asm/processor.h>
 #include <asm/page.h>
 #include <asm/current.h>
@@ -68,13 +69,14 @@ static unsigned long ioapic_read_indirect(struct kvm_ioapic *ioapic,
 	default:
 		{
 			u32 redir_index = (ioapic->ioregsel - 0x10) >> 1;
-			u64 redir_content;
+			u64 redir_content = ~0ULL;
 
-			if (redir_index < IOAPIC_NUM_PINS)
-				redir_content =
-					ioapic->redirtbl[redir_index].bits;
-			else
-				redir_content = ~0ULL;
+			if (redir_index < IOAPIC_NUM_PINS) {
+				u32 index = array_index_nospec(
+					redir_index, IOAPIC_NUM_PINS);
+
+				redir_content = ioapic->redirtbl[index].bits;
+			}
 
 			result = (ioapic->ioregsel & 0x1) ?
 			    (redir_content >> 32) & 0xffffffff :
-- 
2.24.0.525.g8f36a354ae-goog

