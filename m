Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3201F374
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728042AbfEOLC5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:02:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:60448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728002AbfEOLC5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:02:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D788216FD;
        Wed, 15 May 2019 11:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918176;
        bh=CmkATkjTIybT7qYVJXp3k9eIe/7DrljSKUx5jTjfP8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qTicBrPN0vCYnzGryb5mGBVlt+ersIy8TQ1Q0lHBwZHx/HG2AqQUiRZX9oEvKie/Z
         T7oMRUgqbqQtwSz0/79IT/2+68DKzU4F8MYhS/pvPQGlBNBytnq4PnHFbCBYrJBicJ
         F8XrDZ2RMitoA5TMXfj6dttmXR/NqP4xPBQ5a/UQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.4 035/266] powerpc/64s: Fix section mismatch warnings from setup_rfi_flush()
Date:   Wed, 15 May 2019 12:52:22 +0200
Message-Id: <20190515090723.708456057@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit 501a78cbc17c329fabf8e9750a1e9ab810c88a0e upstream.

The recent LPM changes to setup_rfi_flush() are causing some section
mismatch warnings because we removed the __init annotation on
setup_rfi_flush():

  The function setup_rfi_flush() references
  the function __init ppc64_bolted_size().
  the function __init memblock_alloc_base().

The references are actually in init_fallback_flush(), but that is
inlined into setup_rfi_flush().

These references are safe because:
 - only pseries calls setup_rfi_flush() at runtime
 - pseries always passes L1D_FLUSH_FALLBACK at boot
 - so the fallback flush area will always be allocated
 - so the check in init_fallback_flush() will always return early:
   /* Only allocate the fallback flush area once (at boot time). */
   if (l1d_flush_fallback_area)
   	return;

 - and therefore we won't actually call the freed init routines.

We should rework the code to make it safer by default rather than
relying on the above, but for now as a quick-fix just add a __ref
annotation to squash the warning.

Fixes: abf110f3e1ce ("powerpc/rfi-flush: Make it possible to call setup_rfi_flush() again")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/setup_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -882,7 +882,7 @@ void rfi_flush_enable(bool enable)
 	rfi_flush = enable;
 }
 
-static void init_fallback_flush(void)
+static void __ref init_fallback_flush(void)
 {
 	u64 l1d_size, limit;
 	int cpu;


