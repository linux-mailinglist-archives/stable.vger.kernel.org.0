Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58680463747
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:49:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242589AbhK3Owh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:52:37 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:56988 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242571AbhK3Ovu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:51:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2C384CE1A4B;
        Tue, 30 Nov 2021 14:48:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80D56C53FCF;
        Tue, 30 Nov 2021 14:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283708;
        bh=tp+xJSvo2YK2j5HDvCDLZjjBzh54BBuciRfWbjKgxvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pqMRYya8gG0FvradEgjxbuoQ395EBGKWW1aK4hTrsTtCfwCYwax3CE8Ebi20F8n15
         EtxU+VWW6Egd9XIV3ZCsF//pDUON87zYo/QtEl3m20F0VkrsvkMMGoEfuojWqX07Re
         VycdqFNS+lRVw4D0wEm17OOULKssw4vulkE9Dy425Bh3aBpMnsGw/2vd/NLqfojMtU
         mQq/28j16UzG/4a5rGy/IvjAmvbmbQaz/omyiQRa+ckNxkH+prsT5ahTa5rBxunHMU
         dfwajXpeRAZ6kJ2uAifsZQAzTeh/X+kZSd5Q5b/k4FcyBr1IPXUYhyCv46Y0ueYb+f
         E9OZaEiMvcBXg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John David Anglin <dave.anglin@bell.net>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>,
        James.Bottomley@HansenPartnership.com, svens@stackframe.org,
        masahiroy@kernel.org, linux-parisc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 28/68] parisc: Fix extraction of hash lock bits in syscall.S
Date:   Tue, 30 Nov 2021 09:46:24 -0500
Message-Id: <20211130144707.944580-28-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130144707.944580-1-sashal@kernel.org>
References: <20211130144707.944580-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John David Anglin <dave.anglin@bell.net>

[ Upstream commit df2ffeda6370a77011902e7c9d7a1eb1cbffed4f ]

The extru instruction leaves the most significant 32 bits of the target
register in an undefined state on PA 2.0 systems. If any of these bits
are nonzero, this will break the calculation of the lock pointer.

Fix by using extrd,u instruction via extru_safe macro on 64-bit kernels.

Signed-off-by: John David Anglin <dave.anglin@bell.net>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/parisc/kernel/syscall.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/parisc/kernel/syscall.S b/arch/parisc/kernel/syscall.S
index 3f24a0af1e047..06542f2598d50 100644
--- a/arch/parisc/kernel/syscall.S
+++ b/arch/parisc/kernel/syscall.S
@@ -572,7 +572,7 @@ lws_compare_and_swap:
 	ldo	R%lws_lock_start(%r20), %r28
 
 	/* Extract eight bits from r26 and hash lock (Bits 3-11) */
-	extru  %r26, 28, 8, %r20
+	extru_safe  %r26, 28, 8, %r20
 
 	/* Find lock to use, the hash is either one of 0 to
 	   15, multiplied by 16 (keep it 16-byte aligned)
@@ -762,7 +762,7 @@ cas2_lock_start:
 	ldo	R%lws_lock_start(%r20), %r28
 
 	/* Extract eight bits from r26 and hash lock (Bits 3-11) */
-	extru  %r26, 28, 8, %r20
+	extru_safe  %r26, 28, 8, %r20
 
 	/* Find lock to use, the hash is either one of 0 to
 	   15, multiplied by 16 (keep it 16-byte aligned)
-- 
2.33.0

