Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EDF538A2D2
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233687AbhETJqJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:46:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:47526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233704AbhETJoF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:44:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FC286144B;
        Thu, 20 May 2021 09:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503184;
        bh=zdyythD21HvJgoFCj/9ADYkiuDf0zulSgc++zqebsM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KqkhobQpQDyEtpu5kW0ER1/QoSJ+Yb+dTtI5IuHM4aVSPTV4yb3rbm08n1kgTxKVD
         axCSdVo0l9RTQwg4QgAjerC8lJZkIGSEYJkUWUYwm21TEsDSpnik5agj1Mt2ntx+RF
         ozwKJi3helgbU97E5AlwSeSJhdQihW8XrVk7lTM8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Schnelle <svens@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 073/425] s390/archrandom: add parameter check for s390_arch_random_generate
Date:   Thu, 20 May 2021 11:17:22 +0200
Message-Id: <20210520092133.851267903@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
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



