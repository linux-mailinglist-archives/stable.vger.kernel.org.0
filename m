Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F54B29C405
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1813379AbgJ0RwC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:52:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:48656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758823AbgJ0OXm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:23:42 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74D802072D;
        Tue, 27 Oct 2020 14:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808622;
        bh=q4Hj7wsbYdE4qPvX+UxFwk7JHaL3FEkFgkT3zE0nNCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mHZpvxj0UZ8mhnrj+NmlYiK+r7uo2CFvg0yaJ9yhBhvmk6RnZ6C7HjrYGFJvQd1dF
         6yfEeH9qiB1kea7aCYMqbhDO3T+IL6kDj6QADRR709WQEqItgr1ZU/Sj8xwJI8tJNe
         QwGohi9JjENQpBZU1JIRBGQqU7E2WGsGnpRhy4h4=
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
Subject: [PATCH 4.19 162/264] lib/crc32.c: fix trivial typo in preprocessor condition
Date:   Tue, 27 Oct 2020 14:53:40 +0100
Message-Id: <20201027135438.289623714@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
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
index a6c9afafc8c85..1a5d08470044e 100644
--- a/lib/crc32.c
+++ b/lib/crc32.c
@@ -328,7 +328,7 @@ static inline u32 __pure crc32_be_generic(u32 crc, unsigned char const *p,
 	return crc;
 }
 
-#if CRC_LE_BITS == 1
+#if CRC_BE_BITS == 1
 u32 __pure crc32_be(u32 crc, unsigned char const *p, size_t len)
 {
 	return crc32_be_generic(crc, p, len, NULL, CRC32_POLY_BE);
-- 
2.25.1



