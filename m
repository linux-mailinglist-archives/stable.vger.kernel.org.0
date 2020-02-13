Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A61115C61D
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728238AbgBMP5W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:57:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:40532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728965AbgBMPZS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:25:18 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F0B924690;
        Thu, 13 Feb 2020 15:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607518;
        bh=mXZjmtU8ZBPx99jKMMldFF0RvJ/FI5u4/VQBKYH05oI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r9I9WbomZyBwPjM2vYqRJrvFxjzzGsCU7dRDkXexy7CdsBD4wk9fmwRLUsM8E49Ge
         Qbbiac16NuLiMz/dgQFDtWlA4RMkBH31hDvIx1vgTtEbe02d3/5Wo1fICnuo1vzPD1
         sQHhrapyAnSMzMhfSbSTNnrg8zqlZpnyy/Q+4TAw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Finco <nifi@google.com>,
        Marios Pomonis <pomonis@google.com>,
        Andrew Honig <ahonig@google.com>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.14 083/173] KVM: x86: Protect ioapic_write_indirect() from Spectre-v1/L1TF attacks
Date:   Thu, 13 Feb 2020 07:19:46 -0800
Message-Id: <20200213151954.297398404@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151931.677980430@linuxfoundation.org>
References: <20200213151931.677980430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marios Pomonis <pomonis@google.com>

commit 670564559ca35b439c8d8861fc399451ddf95137 upstream.

This fixes a Spectre-v1/L1TF vulnerability in ioapic_write_indirect().
This function contains index computations based on the
(attacker-controlled) IOREGSEL register.

This patch depends on patch
"KVM: x86: Protect ioapic_read_indirect() from Spectre-v1/L1TF attacks".

Fixes: 70f93dae32ac ("KVM: Use temporary variable to shorten lines.")

Signed-off-by: Nick Finco <nifi@google.com>
Signed-off-by: Marios Pomonis <pomonis@google.com>
Reviewed-by: Andrew Honig <ahonig@google.com>
Cc: stable@vger.kernel.org
Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/ioapic.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -297,6 +297,7 @@ static void ioapic_write_indirect(struct
 		ioapic_debug("change redir index %x val %x\n", index, val);
 		if (index >= IOAPIC_NUM_PINS)
 			return;
+		index = array_index_nospec(index, IOAPIC_NUM_PINS);
 		e = &ioapic->redirtbl[index];
 		mask_before = e->fields.mask;
 		/* Preserve read-only fields */


