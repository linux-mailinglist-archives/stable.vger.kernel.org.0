Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7931D20635F
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389988AbgFWUXQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:23:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:41364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390274AbgFWUXO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:23:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16B8C2070E;
        Tue, 23 Jun 2020 20:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943794;
        bh=KkBMj9YRD+62VQ1A+vZUx6Bw2StxSTW354l2AhqQOsc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CVtUmx4AuPhhx9biYqs842q/qqZ29g7P1A6MCjI/eMCguKVBSeEaptOcAA6PnjAEM
         +Nyy6vyxT4ToBPV5tpMM9/BVTf0gLwKCjnYH2GMvnYYSGbajxok042JhZCZgquIYZO
         0GNAwgDAa8OGDZRgI2lqci8ntIyMYDMG4cctVuk4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 053/314] powerpc/ptdump: Add _PAGE_COHERENT flag
Date:   Tue, 23 Jun 2020 21:54:08 +0200
Message-Id: <20200623195341.353912059@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 3af4786eb429b2df76cbd7ce3bae21467ac3e4fb ]

For platforms using shared.c (4xx, Book3e, Book3s/32), also handle the
_PAGE_COHERENT flag which corresponds to the M bit of the WIMG flags.

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
[mpe: Make it more verbose, use "coherent" rather than "m"]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/324c3d860717e8e91fca3bb6c0f8b23e1644a404.1589866984.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/ptdump/shared.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/powerpc/mm/ptdump/shared.c b/arch/powerpc/mm/ptdump/shared.c
index f7ed2f187cb01..784f8df17f732 100644
--- a/arch/powerpc/mm/ptdump/shared.c
+++ b/arch/powerpc/mm/ptdump/shared.c
@@ -30,6 +30,11 @@ static const struct flag_info flag_array[] = {
 		.val	= _PAGE_PRESENT,
 		.set	= "present",
 		.clear	= "       ",
+	}, {
+		.mask	= _PAGE_COHERENT,
+		.val	= _PAGE_COHERENT,
+		.set	= "coherent",
+		.clear	= "        ",
 	}, {
 		.mask	= _PAGE_GUARDED,
 		.val	= _PAGE_GUARDED,
-- 
2.25.1



