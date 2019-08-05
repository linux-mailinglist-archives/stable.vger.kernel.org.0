Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1441381AD7
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730259AbfHENJx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:09:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:48534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729035AbfHENJx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:09:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7226F2075B;
        Mon,  5 Aug 2019 13:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565010593;
        bh=4Oveecdha/pb64ZWvVOdcWAJv5q/swTY08yW+2J80r8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZYs4bL+2+rgbMn2Xh+tdSEMknodjPJCyhSqNh+q30gaAlbYCrm8q69q8Y6XEgIgSk
         OaaPwtruWQw5iPe2HERaulGmqZltBIx8D/dCNPylPbY4S4wL1lX0VTU/Z1V/h0Qe5T
         zoRCwpmHwxvjpJ5MvFoxl9dN1GIH21HOEmyIwb+U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Rosin <peda@axentia.se>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 30/74] lib/test_string.c: avoid masking memset16/32/64 failures
Date:   Mon,  5 Aug 2019 15:02:43 +0200
Message-Id: <20190805124938.186161074@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124935.819068648@linuxfoundation.org>
References: <20190805124935.819068648@linuxfoundation.org>
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
index 0fcdb82dca866..98a787e7a1fd6 100644
--- a/lib/test_string.c
+++ b/lib/test_string.c
@@ -35,7 +35,7 @@ static __init int memset16_selftest(void)
 fail:
 	kfree(p);
 	if (i < 256)
-		return (i << 24) | (j << 16) | k;
+		return (i << 24) | (j << 16) | k | 0x8000;
 	return 0;
 }
 
@@ -71,7 +71,7 @@ static __init int memset32_selftest(void)
 fail:
 	kfree(p);
 	if (i < 256)
-		return (i << 24) | (j << 16) | k;
+		return (i << 24) | (j << 16) | k | 0x8000;
 	return 0;
 }
 
@@ -107,7 +107,7 @@ static __init int memset64_selftest(void)
 fail:
 	kfree(p);
 	if (i < 256)
-		return (i << 24) | (j << 16) | k;
+		return (i << 24) | (j << 16) | k | 0x8000;
 	return 0;
 }
 
-- 
2.20.1



