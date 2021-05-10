Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E860C37868F
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234156AbhEJLJG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:09:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:52164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233726AbhEJK7r (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:59:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43EE361876;
        Mon, 10 May 2021 10:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643976;
        bh=Ffa6ELVMUGV4itxSLyDqva7PAs6fN/3nhJDRmakNfq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pMXa+luC1/eW6P6DFBBZ5hfhaozNc+Z8Pm7IP/Cj6z6jhTvOPIIJ0hYd7n1kLFm3m
         BN5j2m0jtue36DRGAiim8CLGVfjVcLPc3cZJjOSTkKOvCsnNy4cZUaVRlewYLJV24j
         9oWYsSLpBibYD9VaHHpZBPOTb/LmmW/cQNZTwGfw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Schnelle <svens@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 237/342] s390/archrandom: add parameter check for s390_arch_random_generate
Date:   Mon, 10 May 2021 12:20:27 +0200
Message-Id: <20210510102017.908200270@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harald Freudenberger <freude@linux.ibm.com>

[ Upstream commit 28096067686c5a5cbd4c35b079749bd805df5010 ]

A review of the code showed, that this function which is exposed
within the whole kernel should do a parameter check for the
amount of bytes requested. If this requested bytes is too high
an unsigned int overflow could happen causing this function to
try to memcpy a really big memory chunk.

This is not a security issue as there are only two invocations
of this function from arch/s390/include/asm/archrandom.h and both
are not exposed to userland.

Reported-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/crypto/arch_random.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/s390/crypto/arch_random.c b/arch/s390/crypto/arch_random.c
index 7b947728d57e..56007c763902 100644
--- a/arch/s390/crypto/arch_random.c
+++ b/arch/s390/crypto/arch_random.c
@@ -54,6 +54,10 @@ static DECLARE_DELAYED_WORK(arch_rng_work, arch_rng_refill_buffer);
 
 bool s390_arch_random_generate(u8 *buf, unsigned int nbytes)
 {
+	/* max hunk is ARCH_RNG_BUF_SIZE */
+	if (nbytes > ARCH_RNG_BUF_SIZE)
+		return false;
+
 	/* lock rng buffer */
 	if (!spin_trylock(&arch_rng_lock))
 		return false;
-- 
2.30.2



