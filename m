Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93F23409605
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346931AbhIMOrR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:47:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:60444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344647AbhIMOpQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:45:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0BB7663225;
        Mon, 13 Sep 2021 13:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541486;
        bh=LutDRff0aD9e1FFhOZ0SBAGlxCTHiB/d0aPEr85B8jk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uK+izeUq45NhgbBTAVgaoxM2TyZ5lSsVKH/eet5Ztp5Hom4rJ0LuPGOaiyHp+0oxE
         LqKqJ9fxmjSozB1SaCkNJPggpOjjIPwS93nXdtaR8DpYkzaDz4Rktwp7jwoGxXWlEh
         c2rIOtxFlfij/UH77JmjNVMK2Tusuz9cn550C2o4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quentin Perret <qperret@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.14 317/334] KVM: arm64: Unregister HYP sections from kmemleak in protected mode
Date:   Mon, 13 Sep 2021 15:16:11 +0200
Message-Id: <20210913131124.149730853@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit 47e6223c841e029bfc23c3ce594dac5525cebaf8 upstream.

Booting a KVM host in protected mode with kmemleak quickly results
in a pretty bad crash, as kmemleak doesn't know that the HYP sections
have been taken away. This is specially true for the BSS section,
which is part of the kernel BSS section and registered at boot time
by kmemleak itself.

Unregister the HYP part of the BSS before making that section
HYP-private. The rest of the HYP-specific data is obtained via
the page allocator or lives in other sections, none of which is
subjected to kmemleak.

Fixes: 90134ac9cabb ("KVM: arm64: Protect the .hyp sections from the host")
Reviewed-by: Quentin Perret <qperret@google.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org # 5.13
Link: https://lore.kernel.org/r/20210802123830.2195174-3-maz@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/arm.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -15,6 +15,7 @@
 #include <linux/fs.h>
 #include <linux/mman.h>
 #include <linux/sched.h>
+#include <linux/kmemleak.h>
 #include <linux/kvm.h>
 #include <linux/kvm_irqfd.h>
 #include <linux/irqbypass.h>
@@ -1986,6 +1987,12 @@ static int finalize_hyp_mode(void)
 	if (ret)
 		return ret;
 
+	/*
+	 * Exclude HYP BSS from kmemleak so that it doesn't get peeked
+	 * at, which would end badly once the section is inaccessible.
+	 * None of other sections should ever be introspected.
+	 */
+	kmemleak_free_part(__hyp_bss_start, __hyp_bss_end - __hyp_bss_start);
 	ret = pkvm_mark_hyp_section(__hyp_bss);
 	if (ret)
 		return ret;


