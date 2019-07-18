Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1DF16C73D
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389629AbfGRDG3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:06:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:37692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390218AbfGRDG2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:06:28 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 890252053B;
        Thu, 18 Jul 2019 03:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419187;
        bh=EVusKffBVu8ERw1y8wdsB9QLIF/vjsr8TRZpFxqs4+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LUZ7xPjSAa4lyLw2bmjfhTvK+SrtSn3HJV7g05ezYsTxruDrUB+5OQDRT56yfpM11
         P0PtAVadWcIknKzdLbJXh9kDr9+RMWngsViCHacXU9CjS64oozpA+4MZSYNRYH1rN1
         t3EV6Jq5lUNBvL5XQygnujrcD0FB1svOIdB21uto=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vinod Koul <vkoul@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 40/54] linux/kernel.h: fix overflow for DIV_ROUND_UP_ULL
Date:   Thu, 18 Jul 2019 12:01:35 +0900
Message-Id: <20190718030056.293165729@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030053.287374640@linuxfoundation.org>
References: <20190718030053.287374640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 8f9fab480c7a87b10bb5440b5555f370272a5d59 ]

DIV_ROUND_UP_ULL adds the two arguments and then invokes
DIV_ROUND_DOWN_ULL.  But on a 32bit system the addition of two 32 bit
values can overflow.  DIV_ROUND_DOWN_ULL does it correctly and stashes
the addition into a unsigned long long so cast the result to unsigned
long long here to avoid the overflow condition.

[akpm@linux-foundation.org: DIV_ROUND_UP_ULL must be an rval]
Link: http://lkml.kernel.org/r/20190625100518.30753-1-vkoul@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/kernel.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 2d14e21c16c0..4330cecd2237 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -92,7 +92,8 @@
 #define DIV_ROUND_DOWN_ULL(ll, d) \
 	({ unsigned long long _tmp = (ll); do_div(_tmp, d); _tmp; })
 
-#define DIV_ROUND_UP_ULL(ll, d)		DIV_ROUND_DOWN_ULL((ll) + (d) - 1, (d))
+#define DIV_ROUND_UP_ULL(ll, d) \
+	DIV_ROUND_DOWN_ULL((unsigned long long)(ll) + (d) - 1, (d))
 
 #if BITS_PER_LONG == 32
 # define DIV_ROUND_UP_SECTOR_T(ll,d) DIV_ROUND_UP_ULL(ll, d)
-- 
2.20.1



