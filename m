Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31C1C4637C5
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:53:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242843AbhK3Oz7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:55:59 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48318 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243140AbhK3Oy3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:54:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9148DB81A40;
        Tue, 30 Nov 2021 14:51:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CD1DC53FC1;
        Tue, 30 Nov 2021 14:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283867;
        bh=giYy9fcZAje89Z0KZJVNMlN/GtHs66OgNrlwJKck6Vs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KOhwPbuae8jYhiEC49/mjncMSGbjq0UMtob3UYOIJhS2oaQVu8InU5aBY4vsOjTtg
         Yw/vlp+cQzeFIUCjv+lsrYU3XQJ4JPnOpZ7IUwqvDpTz4SWSzAtGg9Fb1WYjeFT0Uq
         PMtBMQ3p+abkiYfJRagAC4w1VhCxfF+n3+fL/neMyqx/i4Qtg9rMEenWonAaF/3kOP
         9mVKLJeEUm4wM8TgR0ZSZPB0CPq6mPVYijVPMLHw9s79xDWlf4/v3OglohTlPVHcQy
         59olpNxi16tZPxKmgOAya0LemPaswoaBnKwI1LaueYN1m8sqOjBZoyT2Ni6IVhNKO7
         NNTfrINzkAhiA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John David Anglin <dave.anglin@bell.net>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>,
        James.Bottomley@HansenPartnership.com, svens@stackframe.org,
        masahiroy@kernel.org, linux-parisc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 18/43] parisc: Fix extraction of hash lock bits in syscall.S
Date:   Tue, 30 Nov 2021 09:49:55 -0500
Message-Id: <20211130145022.945517-18-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130145022.945517-1-sashal@kernel.org>
References: <20211130145022.945517-1-sashal@kernel.org>
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
index 322503780db61..2667cd91f314b 100644
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

