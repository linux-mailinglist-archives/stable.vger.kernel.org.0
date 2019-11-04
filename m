Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28183EEF18
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:19:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388974AbfKDWTQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:19:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:59224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388981AbfKDWBM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:01:12 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0517520650;
        Mon,  4 Nov 2019 22:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904871;
        bh=9bqpOQ/HTpFfl9Zq2N2vZhaiabTgyqLrkdRiLClf/oc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WiU2jPtHFryGb3TFTpWck2z+wG9SxUM4faQ7AG30G3p52emMeIVaUI8iRnN2SpCXw
         MV47sep0PUggRgXfcq2Qe3maAD4y6y9o+/HwbuDJy5kBDR0EFy61dKpwH7HrjhYUib
         LT4SGDApReGTr4DF0YLj6WboeSKIpsEjc23LYfL0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thomas Bogendoerfer <tbogendoerfer@suse.de>,
        Paul Burton <paul.burton@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>, linux-mips@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 083/149] MIPS: include: Mark __cmpxchg as __always_inline
Date:   Mon,  4 Nov 2019 22:44:36 +0100
Message-Id: <20191104212142.397201328@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
References: <20191104212126.090054740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Bogendoerfer <tbogendoerfer@suse.de>

[ Upstream commit 88356d09904bc606182c625575237269aeece22e ]

Commit ac7c3e4ff401 ("compiler: enable CONFIG_OPTIMIZE_INLINING
forcibly") allows compiler to uninline functions marked as 'inline'.
In cace of cmpxchg this would cause to reference function
__cmpxchg_called_with_bad_pointer, which is a error case
for catching bugs and will not happen for correct code, if
__cmpxchg is inlined.

Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
[paul.burton@mips.com: s/__cmpxchd/__cmpxchg in subject]
Signed-off-by: Paul Burton <paul.burton@mips.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: James Hogan <jhogan@kernel.org>
Cc: linux-mips@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/cmpxchg.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/mips/include/asm/cmpxchg.h b/arch/mips/include/asm/cmpxchg.h
index 89e9fb7976fe6..895f91b9e89c3 100644
--- a/arch/mips/include/asm/cmpxchg.h
+++ b/arch/mips/include/asm/cmpxchg.h
@@ -146,8 +146,9 @@ static inline unsigned long __xchg(volatile void *ptr, unsigned long x,
 extern unsigned long __cmpxchg_small(volatile void *ptr, unsigned long old,
 				     unsigned long new, unsigned int size);
 
-static inline unsigned long __cmpxchg(volatile void *ptr, unsigned long old,
-				      unsigned long new, unsigned int size)
+static __always_inline
+unsigned long __cmpxchg(volatile void *ptr, unsigned long old,
+			unsigned long new, unsigned int size)
 {
 	switch (size) {
 	case 1:
-- 
2.20.1



