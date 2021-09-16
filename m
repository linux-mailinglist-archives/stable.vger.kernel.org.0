Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3761B40E521
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244777AbhIPRIK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:08:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:34075 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349565AbhIPRGD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:06:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4ABB461B26;
        Thu, 16 Sep 2021 16:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810153;
        bh=foSDhwIrzkZlMBDyR4FVkWyGMHp6xfz85SD8oFVaNa8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eoEwRIP768yNbBzBmgAMDd5bFTlUOt6sO9rceiaTVNBntBJZK304mjrSduGXvoyhI
         Ww2tp6+mPfCsa4gkCJwqlaqcz6gD81wuKmNuEy9eMjdkjydUGgberMJPe1f078uGrV
         IFIiPXRBUfpge34D/KdGPP8Po3aBJsrG43eyh0tE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.14 037/432] arm64: Move .hyp.rodata outside of the _sdata.._edata range
Date:   Thu, 16 Sep 2021 17:56:26 +0200
Message-Id: <20210916155812.069714470@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit eb48d154cd0dade56a0e244f0cfa198ea2925ed3 upstream.

The HYP rodata section is currently lumped together with the BSS,
which isn't exactly what is expected (it gets registered with
kmemleak, for example).

Move it away so that it is actually marked RO. As an added
benefit, it isn't registered with kmemleak anymore.

Fixes: 380e18ade4a5 ("KVM: arm64: Introduce a BSS section for use at Hyp")
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org #5.13
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Link: https://lore.kernel.org/r/20210802123830.2195174-2-maz@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/vmlinux.lds.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -181,6 +181,8 @@ SECTIONS
 	/* everything from this point to __init_begin will be marked RO NX */
 	RO_DATA(PAGE_SIZE)
 
+	HYPERVISOR_DATA_SECTIONS
+
 	idmap_pg_dir = .;
 	. += IDMAP_DIR_SIZE;
 	idmap_pg_end = .;
@@ -260,8 +262,6 @@ SECTIONS
 	_sdata = .;
 	RW_DATA(L1_CACHE_BYTES, PAGE_SIZE, THREAD_ALIGN)
 
-	HYPERVISOR_DATA_SECTIONS
-
 	/*
 	 * Data written with the MMU off but read with the MMU on requires
 	 * cache lines to be invalidated, discarding up to a Cache Writeback


