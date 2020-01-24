Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA291147E6A
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 11:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389023AbgAXKIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 05:08:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:45708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388054AbgAXKIx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 05:08:53 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0DF420709;
        Fri, 24 Jan 2020 10:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579860533;
        bh=2BOKliKYONPM7G3oQGicFAME9v7YSWM/c/y81Ych7cE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N2zEbWGJfpaMEQut3vuPMeWJuN68ugpiAd9NzD/L+FxBneZPcFzY+GvmeMUeCCt8E
         7a+KHDqB0YynkNLDuzWLRuLk4nqGgK8CqXCQ/SL5NTf+JaFw6ASs8TraTrhAM2ur4W
         HUmsnOA8HRA4tkF5w21F1zsRZpkmSEi4g6sHh9s4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.19 008/639] powerpc/archrandom: fix arch_get_random_seed_int()
Date:   Fri, 24 Jan 2020 10:22:58 +0100
Message-Id: <20200124093048.115159582@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

commit b6afd1234cf93aa0d71b4be4788c47534905f0be upstream.

Commit 01c9348c7620ec65

  powerpc: Use hardware RNG for arch_get_random_seed_* not arch_get_random_*

updated arch_get_random_[int|long]() to be NOPs, and moved the hardware
RNG backing to arch_get_random_seed_[int|long]() instead. However, it
failed to take into account that arch_get_random_int() was implemented
in terms of arch_get_random_long(), and so we ended up with a version
of the former that is essentially a NOP as well.

Fix this by calling arch_get_random_seed_long() from
arch_get_random_seed_int() instead.

Fixes: 01c9348c7620ec65 ("powerpc: Use hardware RNG for arch_get_random_seed_* not arch_get_random_*")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20191204115015.18015-1-ardb@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/archrandom.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/include/asm/archrandom.h
+++ b/arch/powerpc/include/asm/archrandom.h
@@ -28,7 +28,7 @@ static inline int arch_get_random_seed_i
 	unsigned long val;
 	int rc;
 
-	rc = arch_get_random_long(&val);
+	rc = arch_get_random_seed_long(&val);
 	if (rc)
 		*v = val;
 


