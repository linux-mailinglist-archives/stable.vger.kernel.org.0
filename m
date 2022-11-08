Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE80621397
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234675AbiKHNwA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:52:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234745AbiKHNvg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:51:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7829623B1
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:51:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44707615AD
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:51:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F3F0C433C1;
        Tue,  8 Nov 2022 13:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915493;
        bh=/sB7xKj7T3vXXsjWW7Qq6aoAXcjhvWgXNGcrzwpYhWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nXORvCYcbmdF/ZY6Q3PVsNHg45+ck74sGLDSH6marEkjhojUb5f6rOd8Tg9DWQ55V
         Yzt1uMH2WVBWCSTH10Y55GWwXObJLd7YO8uXPP8E41R1UGM78IIHgxNwABiZodGg9y
         kt/X7ixxk8pXbMSmcseRg4Uj8rjr7xdrP8FM//jE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Willy Tarreau <w@1wt.eu>,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: [PATCH 5.4 51/74] tools/nolibc/string: Fix memcmp() implementation
Date:   Tue,  8 Nov 2022 14:39:19 +0100
Message-Id: <20221108133335.850656530@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133333.659601604@linuxfoundation.org>
References: <20221108133333.659601604@linuxfoundation.org>
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
 tools/include/nolibc/nolibc.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/include/nolibc/nolibc.h
+++ b/tools/include/nolibc/nolibc.h
@@ -2318,9 +2318,9 @@ static __attribute__((unused))
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


