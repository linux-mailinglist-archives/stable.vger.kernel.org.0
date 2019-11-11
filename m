Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB556F7DFC
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:01:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730138AbfKKSwu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:52:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:47306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729325AbfKKSwr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:52:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70F0420818;
        Mon, 11 Nov 2019 18:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498367;
        bh=ayfuX91gx37T++DZ/DF4dGO8PJP51xbQu+nZsKOaIl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HHktI2Z7svSzL5+WRUKaw4VuNdoMF7K7CQl49uphUZETla7Svjb+AbM783ylnILxP
         o/F+0QBkD23BUo/AJ03YLtahlAJGFrsX4uuNtpP+WyG0h/ofpjcKFPGpvbNXn6b7UJ
         cD0zfQIQyTBnZB1nWAsnPOk+8wcFEWtoBNpqRqjE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christophe Leroy <christophe.leroy@c-s.fr>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 098/193] powerpc/32s: fix allow/prevent_user_access() when crossing segment boundaries.
Date:   Mon, 11 Nov 2019 19:28:00 +0100
Message-Id: <20191111181508.368745009@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

[ Upstream commit d10f60ae27d26d811e2a1bb39ded47df96d7499f ]

Make sure starting addr is aligned to segment boundary so that when
incrementing the segment, the starting address of the new segment is
below the end address. Otherwise the last segment might get  missed.

Fixes: a68c31fc01ef ("powerpc/32s: Implement Kernel Userspace Access Protection")
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/067a1b09f15f421d40797c2d04c22d4049a1cee8.1571071875.git.christophe.leroy@c-s.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/book3s/32/kup.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/include/asm/book3s/32/kup.h b/arch/powerpc/include/asm/book3s/32/kup.h
index 677e9babef801..f9dc597b0b868 100644
--- a/arch/powerpc/include/asm/book3s/32/kup.h
+++ b/arch/powerpc/include/asm/book3s/32/kup.h
@@ -91,6 +91,7 @@
 
 static inline void kuap_update_sr(u32 sr, u32 addr, u32 end)
 {
+	addr &= 0xf0000000;	/* align addr to start of segment */
 	barrier();	/* make sure thread.kuap is updated before playing with SRs */
 	while (addr < end) {
 		mtsrin(sr, addr);
-- 
2.20.1



