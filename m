Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 330DC157755
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728289AbgBJM7W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:59:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:42856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729614AbgBJMlL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:41:11 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB3AC2051A;
        Mon, 10 Feb 2020 12:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338470;
        bh=A/2U5VX3ZwwTAy8Oy69vmzKMOlRkiaXXOgPpFnlDUzc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N9umN6acj3jFz+7M0WpyL+uB3PoV5nuqUuyMmzcv0l8FGs8P3GdiIWT46+iOg5uQR
         wfbokN1BNXZz7KD9AFYXXs5/B8EIj86stImg8e4VzzwiI7vYhwupskRcA6IIH4ZztN
         K1JN9O9KF4+1a2W9QG884wbbtB4FFNtj5MRnASEk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Finco <nifi@google.com>,
        Marios Pomonis <pomonis@google.com>,
        Andrew Honig <ahonig@google.com>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.5 235/367] KVM: x86: Protect ioapic_read_indirect() from Spectre-v1/L1TF attacks
Date:   Mon, 10 Feb 2020 04:32:28 -0800
Message-Id: <20200210122445.883199754@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marios Pomonis <pomonis@google.com>

commit 8c86405f606ca8508b8d9280680166ca26723695 upstream.

This fixes a Spectre-v1/L1TF vulnerability in ioapic_read_indirect().
This function contains index computations based on the
(attacker-controlled) IOREGSEL register.

Fixes: a2c118bfab8b ("KVM: Fix bounds checking in ioapic indirect register reads (CVE-2013-1798)")

Signed-off-by: Nick Finco <nifi@google.com>
Signed-off-by: Marios Pomonis <pomonis@google.com>
Reviewed-by: Andrew Honig <ahonig@google.com>
Cc: stable@vger.kernel.org
Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/ioapic.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

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
@@ -68,13 +69,14 @@ static unsigned long ioapic_read_indirec
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


