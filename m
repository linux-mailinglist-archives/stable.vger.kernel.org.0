Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B59ED6215A2
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:13:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235268AbiKHONr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:13:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235255AbiKHONp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:13:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D9585803F
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:13:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6F3CB81B08
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:13:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A4FFC433D6;
        Tue,  8 Nov 2022 14:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916822;
        bh=ZJ3QvUtV0Du3cnEfbF0Pte58m7r0ZGnh2CnXx0/LT28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ffBRGXH1X3o6hPjuAnh+rnhbuujO25pSa2SFeeyfgQq7gXpZqS3jFUvhg1/JNuA4J
         5UgxWJB0c/Z3Dl4ZdWShLVCBZFQZFgwHiaILd1csgI5I9JRptn3qVv0GKsRij3CZRl
         e+hI3NEVYxuDvXWWmdGpX95y+EViVfHtuIn80xcY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Willy Tarreau <w@1wt.eu>,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: [PATCH 6.0 144/197] tools/nolibc/string: Fix memcmp() implementation
Date:   Tue,  8 Nov 2022 14:39:42 +0100
Message-Id: <20221108133401.494919733@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>

commit b3f4f51ea68a495f8a5956064c33dce711a2df91 upstream.

The C standard says that memcmp() must treat the buffers as consisting
of "unsigned chars". If char happens to be unsigned, the casts are ok,
but then obviously the c1 variable can never contain a negative
value. And when char is signed, the casts are wrong, and there's still
a problem with using an 8-bit quantity to hold the difference, because
that can range from -255 to +255.

For example, assuming char is signed, comparing two 1-byte buffers,
one containing 0x00 and another 0x80, the current implementation would
return -128 for both memcmp(a, b, 1) and memcmp(b, a, 1), whereas one
of those should of course return something positive.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Fixes: 66b6f755ad45 ("rcutorture: Import a copy of nolibc")
Cc: stable@vger.kernel.org # v5.0+
Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/include/nolibc/string.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/include/nolibc/string.h
+++ b/tools/include/nolibc/string.h
@@ -19,9 +19,9 @@ static __attribute__((unused))
 int memcmp(const void *s1, const void *s2, size_t n)
 {
 	size_t ofs = 0;
-	char c1 = 0;
+	int c1 = 0;
 
-	while (ofs < n && !(c1 = ((char *)s1)[ofs] - ((char *)s2)[ofs])) {
+	while (ofs < n && !(c1 = ((unsigned char *)s1)[ofs] - ((unsigned char *)s2)[ofs])) {
 		ofs++;
 	}
 	return c1;


