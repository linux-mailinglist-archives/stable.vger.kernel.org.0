Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34AF151A702
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354125AbiEDRB0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354597AbiEDQ6y (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 12:58:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC1C71EECF;
        Wed,  4 May 2022 09:50:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53DD0617BD;
        Wed,  4 May 2022 16:50:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A17CC385AA;
        Wed,  4 May 2022 16:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683043;
        bh=+J6mkW7g7FZT8T1bJ9fP3KdetTDCgArgqcBdHrc4ShY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dpxJGPDje5iDDKJQJvdzneBXOHIkLJRksauD7x82UYx8q8n2QZ3i/WaazynUP6Xyl
         +QvexhRAocqftmWzXna4oGdgWvwqaJ6P+YechbPvdGPd0DflG2onHHlkNbBc4iDEaU
         SRUgTLUt31iRGbuyckN1mGo8dq7EtsdNMyEB4bS0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 034/129] hex2bin: fix access beyond string end
Date:   Wed,  4 May 2022 18:43:46 +0200
Message-Id: <20220504153023.967318541@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153021.299025455@linuxfoundation.org>
References: <20220504153021.299025455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
@@ -63,10 +63,13 @@ EXPORT_SYMBOL(hex_to_bin);
 int hex2bin(u8 *dst, const char *src, size_t count)
 {
 	while (count--) {
-		int hi = hex_to_bin(*src++);
-		int lo = hex_to_bin(*src++);
+		int hi, lo;
 
-		if ((hi < 0) || (lo < 0))
+		hi = hex_to_bin(*src++);
+		if (unlikely(hi < 0))
+			return -EINVAL;
+		lo = hex_to_bin(*src++);
+		if (unlikely(lo < 0))
 			return -EINVAL;
 
 		*dst++ = (hi << 4) | lo;


