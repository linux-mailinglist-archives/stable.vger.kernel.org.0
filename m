Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF55C28A0B
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731736AbfEWTIa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:08:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:41256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731464AbfEWTIa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:08:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FDD9217D7;
        Thu, 23 May 2019 19:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558638509;
        bh=Pmc3z1L86Cevr7eX4dPYJmCdKqbcycR3yMf88zhOwFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KzGMkYBcpBpscVqc1m186lSMWQ/mEEzrMgMi3C9ZPqgWadYwL8+1vyDhj0oJexD+R
         cCmvWzSNcIFdjdOoFHhBcm2489FLJ65CpNMba06cZ46XeXdNzk7GQ5ZX91L1pJAMfO
         Dm0aSQ8Xi5ThMgH4cB+rEH4TNU6XdRHgJcBd58VE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phong Tran <tranmanphong@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        David Laight <David.Laight@ACULAB.COM>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 4.9 15/53] of: fix clang -Wunsequenced for be32_to_cpu()
Date:   Thu, 23 May 2019 21:05:39 +0200
Message-Id: <20190523181713.300765233@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181710.981455400@linuxfoundation.org>
References: <20190523181710.981455400@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phong Tran <tranmanphong@gmail.com>

commit 440868661f36071886ed360d91de83bd67c73b4f upstream.

Now, make the loop explicit to avoid clang warning.

./include/linux/of.h:238:37: warning: multiple unsequenced modifications
to 'cell' [-Wunsequenced]
                r = (r << 32) | be32_to_cpu(*(cell++));
                                                  ^~
./include/linux/byteorder/generic.h:95:21: note: expanded from macro
'be32_to_cpu'
                    ^
./include/uapi/linux/byteorder/little_endian.h:40:59: note: expanded
from macro '__be32_to_cpu'
                                                          ^
./include/uapi/linux/swab.h:118:21: note: expanded from macro '__swab32'
        ___constant_swab32(x) :                 \
                           ^
./include/uapi/linux/swab.h:18:12: note: expanded from macro
'___constant_swab32'
        (((__u32)(x) & (__u32)0x000000ffUL) << 24) |            \
                  ^

Signed-off-by: Phong Tran <tranmanphong@gmail.com>
Reported-by: Nick Desaulniers <ndesaulniers@google.com>
Link: https://github.com/ClangBuiltLinux/linux/issues/460
Suggested-by: David Laight <David.Laight@ACULAB.COM>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Cc: stable@vger.kernel.org
[robh: fix up whitespace]
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/of.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -220,8 +220,8 @@ extern struct device_node *of_find_all_n
 static inline u64 of_read_number(const __be32 *cell, int size)
 {
 	u64 r = 0;
-	while (size--)
-		r = (r << 32) | be32_to_cpu(*(cell++));
+	for (; size--; cell++)
+		r = (r << 32) | be32_to_cpu(*cell);
 	return r;
 }
 


