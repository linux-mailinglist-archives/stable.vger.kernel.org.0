Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA486371C5D
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231459AbhECQwG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:52:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:34748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234625AbhECQuh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:50:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BEFE61933;
        Mon,  3 May 2021 16:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060068;
        bh=zdyythD21HvJgoFCj/9ADYkiuDf0zulSgc++zqebsM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZKuThHXxp2hCsd3CNaCss2V08JFRvOoGYqLXpfpfvTDC8yj0pNIxGA2C72NFI3CWg
         h58s1yFOld4dSo+l5bhK9Qgfs7lyU/kL2EGiIcuknEuHiehL1EsljDP3Fm+F2G9Rya
         Qw/lCuuZBq7xOEfsbKvxdLlrqkB60KSABW6bKZbovPw/yHGNILhZC8S6DMRgHEy4A6
         XZx20hC2PM7GCTMFxZ3KnfOpsfOMuBwxuUOKWDaDqSFcefFFGtC0W9IsZ3324WoQmr
         P8Pd2vaaPnGGnMM9/70WOxXSi7gHtOotcHfFm4zr94cxnWwsxM/7uRwoKUZCim8W9w
         hv8RRDBMzVupA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Harald Freudenberger <freude@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 57/57] s390/archrandom: add parameter check for s390_arch_random_generate
Date:   Mon,  3 May 2021 12:39:41 -0400
Message-Id: <20210503163941.2853291-57-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163941.2853291-1-sashal@kernel.org>
References: <20210503163941.2853291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index dd95cdbd22ce..4cbb4b6d85a8 100644
--- a/arch/s390/crypto/arch_random.c
+++ b/arch/s390/crypto/arch_random.c
@@ -53,6 +53,10 @@ static DECLARE_DELAYED_WORK(arch_rng_work, arch_rng_refill_buffer);
 
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

