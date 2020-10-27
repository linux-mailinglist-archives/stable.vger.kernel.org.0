Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60C6D29AEDE
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:06:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1754166AbgJ0OE7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:04:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:53280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754298AbgJ0OE7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:04:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E54352222C;
        Tue, 27 Oct 2020 14:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807498;
        bh=nRcfUxnUN9DlPYpmBb76VJsQC8z/205CpuoyTVw5puc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tKmjBW7FEyAlMFaIce8jEDbIWKTSs9drFZnTHg1aUMj4HFPHwD5XoddrKgmk6yVXR
         uaE3FOjm35x/lZDpWMqorxcyznvorq/EGWEdOrSDntaz064geaReSxmv0IqSGwYP2t
         BeijltAiPQaXGVzQbuygdbaX2SSQjTM3fFUTTyek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tobias Jordan <kernel@cdqe.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 075/139] lib/crc32.c: fix trivial typo in preprocessor condition
Date:   Tue, 27 Oct 2020 14:49:29 +0100
Message-Id: <20201027134905.687138813@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134902.130312227@linuxfoundation.org>
References: <20201027134902.130312227@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tobias Jordan <kernel@cdqe.de>

[ Upstream commit 904542dc56524f921a6bab0639ff6249c01e775f ]

Whether crc32_be needs a lookup table is chosen based on CRC_LE_BITS.
Obviously, the _be function should be governed by the _BE_ define.

This probably never pops up as it's hard to come up with a configuration
where CRC_BE_BITS isn't the same as CRC_LE_BITS and as nobody is using
bitwise CRC anyway.

Fixes: 46c5801eaf86 ("crc32: bolt on crc32c")
Signed-off-by: Tobias Jordan <kernel@cdqe.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Link: https://lkml.kernel.org/r/20200923182122.GA3338@agrajag.zerfleddert.de
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/crc32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/crc32.c b/lib/crc32.c
index 7fbd1a112b9d2..0d450462b0bd5 100644
--- a/lib/crc32.c
+++ b/lib/crc32.c
@@ -327,7 +327,7 @@ static inline u32 __pure crc32_be_generic(u32 crc, unsigned char const *p,
 	return crc;
 }
 
-#if CRC_LE_BITS == 1
+#if CRC_BE_BITS == 1
 u32 __pure crc32_be(u32 crc, unsigned char const *p, size_t len)
 {
 	return crc32_be_generic(crc, p, len, NULL, CRCPOLY_BE);
-- 
2.25.1



