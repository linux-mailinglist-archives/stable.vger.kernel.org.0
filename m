Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF27521694
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242297AbiEJNQT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:16:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242308AbiEJNPf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:15:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A66F42EC6;
        Tue, 10 May 2022 06:11:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC5ABB81D7C;
        Tue, 10 May 2022 13:11:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D283C385C2;
        Tue, 10 May 2022 13:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652188279;
        bh=xnGMAVPnM6acoucr9QgmgxwJzzrZh7N4dF54mhzvUa8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e6jqdMiPSA0GZzSWerzulKYXcG6pFas96cI+jBQKWuPXXXB4zE1zpfJFSVxnSfbYg
         o5RL5yohdGfJkrFDFtQFuZ3iubuaf4gzYm5dRnn/smC9r/7a9lDQe5pDHsYZNPlv51
         E3VxAnPmVjyR0LXIGJTEA+98lesfUIUyDxiFaqps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.9 20/66] hex2bin: fix access beyond string end
Date:   Tue, 10 May 2022 15:07:10 +0200
Message-Id: <20220510130730.355650511@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130729.762341544@linuxfoundation.org>
References: <20220510130729.762341544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit e4d8a29997731b3bb14059024b24df9f784288d0 upstream.

If we pass too short string to "hex2bin" (and the string size without
the terminating NUL character is even), "hex2bin" reads one byte after
the terminating NUL character.  This patch fixes it.

Note that hex_to_bin returns -1 on error and hex2bin return -EINVAL on
error - so we can't just return the variable "hi" or "lo" on error.
This inconsistency may be fixed in the next merge window, but for the
purpose of fixing this bug, we just preserve the existing behavior and
return -1 and -EINVAL.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Fixes: b78049831ffe ("lib: add error checking to hex2bin")
Cc: stable@vger.kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/hexdump.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/lib/hexdump.c
+++ b/lib/hexdump.c
@@ -65,10 +65,13 @@ EXPORT_SYMBOL(hex_to_bin);
 int hex2bin(u8 *dst, const char *src, size_t count)
 {
 	while (count--) {
-		int hi = hex_to_bin(*src++);
-		int lo = hex_to_bin(*src++);
+		int hi, lo;
 
-		if ((hi < 0) || (lo < 0))
+		hi = hex_to_bin(*src++);
+		if (unlikely(hi < 0))
+			return -1;
+		lo = hex_to_bin(*src++);
+		if (unlikely(lo < 0))
 			return -1;
 
 		*dst++ = (hi << 4) | lo;


