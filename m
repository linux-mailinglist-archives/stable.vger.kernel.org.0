Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46C3B81C4A
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730624AbfHENWS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:22:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:58656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730649AbfHENWR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:22:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9842720651;
        Mon,  5 Aug 2019 13:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011337;
        bh=lPwyNVnIRzEaWGHLLwcdEhNRYl4mScGqRovi7S8MVyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cLVylhLb69hE6YfpfQ1dR5I2H/QnsC9mXKrwpmkaiRC1kfarMa/dWiIIkirtCGUpe
         YYBqCh0wtTk2QTmPAijk+DialGMipAjZqt11EiwWvqB4uchL7cajeD8PaUwyP90h3c
         WsXK5LFDbJ9/B4p+I+V2uh3KqupsHdN5vOgxw6MM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Rosin <peda@axentia.se>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 055/131] lib/test_string.c: avoid masking memset16/32/64 failures
Date:   Mon,  5 Aug 2019 15:02:22 +0200
Message-Id: <20190805124955.119100635@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124951.453337465@linuxfoundation.org>
References: <20190805124951.453337465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 33d6e0ff68af74be0c846c8e042e84a9a1a0561e ]

If a memsetXX implementation is completely broken and fails in the first
iteration, when i, j, and k are all zero, the failure is masked as zero
is returned.  Failing in the first iteration is perhaps the most likely
failure, so this makes the tests pretty much useless.  Avoid the
situation by always setting a random unused bit in the result on
failure.

Link: http://lkml.kernel.org/r/20190506124634.6807-3-peda@axentia.se
Fixes: 03270c13c5ff ("lib/string.c: add testcases for memset16/32/64")
Signed-off-by: Peter Rosin <peda@axentia.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/test_string.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/test_string.c b/lib/test_string.c
index bf8def01ed204..b5117ae596931 100644
--- a/lib/test_string.c
+++ b/lib/test_string.c
@@ -36,7 +36,7 @@ static __init int memset16_selftest(void)
 fail:
 	kfree(p);
 	if (i < 256)
-		return (i << 24) | (j << 16) | k;
+		return (i << 24) | (j << 16) | k | 0x8000;
 	return 0;
 }
 
@@ -72,7 +72,7 @@ static __init int memset32_selftest(void)
 fail:
 	kfree(p);
 	if (i < 256)
-		return (i << 24) | (j << 16) | k;
+		return (i << 24) | (j << 16) | k | 0x8000;
 	return 0;
 }
 
@@ -108,7 +108,7 @@ static __init int memset64_selftest(void)
 fail:
 	kfree(p);
 	if (i < 256)
-		return (i << 24) | (j << 16) | k;
+		return (i << 24) | (j << 16) | k | 0x8000;
 	return 0;
 }
 
-- 
2.20.1



