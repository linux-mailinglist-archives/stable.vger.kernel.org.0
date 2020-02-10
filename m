Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5B5A1574CC
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728194AbgBJMf6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:35:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:54258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728186AbgBJMf5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:35:57 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5EB020842;
        Mon, 10 Feb 2020 12:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338156;
        bh=giC4kPqCAkEv4uVEpJI14NzZauFjfN0qIk1iIX1ADu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dy8T1fmDe07osp+sn+3T4ZRLFy2RQOHpPOiHlvLzXWjJ+6Q7Uu5IkHLyhYeNw5q07
         ng2W/qWl5lqR8h+Pbrri0vpxpLKpUaqGyvTH8KuwNZpc9sTxINvTgPrU4nI+MVk5Ax
         BzOv5NFdw1Vh9T9svGDZGSHKFzd9w/tRADrrYzNw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.19 124/195] KVM: x86: Refactor prefix decoding to prevent Spectre-v1/L1TF attacks
Date:   Mon, 10 Feb 2020 04:33:02 -0800
Message-Id: <20200210122317.508860753@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122305.731206734@linuxfoundation.org>
References: <20200210122305.731206734@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marios Pomonis <pomonis@google.com>

commit 125ffc5e0a56a3eded608dc51e09d5ebf72cf652 upstream.

This fixes Spectre-v1/L1TF vulnerabilities in
vmx_read_guest_seg_selector(), vmx_read_guest_seg_base(),
vmx_read_guest_seg_limit() and vmx_read_guest_seg_ar().  When
invoked from emulation, these functions contain index computations
based on the (attacker-influenced) segment value.  Using constants
prevents the attack.

Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/emulate.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -5164,16 +5164,28 @@ int x86_decode_insn(struct x86_emulate_c
 				ctxt->ad_bytes = def_ad_bytes ^ 6;
 			break;
 		case 0x26:	/* ES override */
+			has_seg_override = true;
+			ctxt->seg_override = VCPU_SREG_ES;
+			break;
 		case 0x2e:	/* CS override */
+			has_seg_override = true;
+			ctxt->seg_override = VCPU_SREG_CS;
+			break;
 		case 0x36:	/* SS override */
+			has_seg_override = true;
+			ctxt->seg_override = VCPU_SREG_SS;
+			break;
 		case 0x3e:	/* DS override */
 			has_seg_override = true;
-			ctxt->seg_override = (ctxt->b >> 3) & 3;
+			ctxt->seg_override = VCPU_SREG_DS;
 			break;
 		case 0x64:	/* FS override */
+			has_seg_override = true;
+			ctxt->seg_override = VCPU_SREG_FS;
+			break;
 		case 0x65:	/* GS override */
 			has_seg_override = true;
-			ctxt->seg_override = ctxt->b & 7;
+			ctxt->seg_override = VCPU_SREG_GS;
 			break;
 		case 0x40 ... 0x4f: /* REX */
 			if (mode != X86EMUL_MODE_PROT64)


