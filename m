Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35D8D4C7361
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:34:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237609AbiB1Reo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:34:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237192AbiB1ReH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:34:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E4B939C1;
        Mon, 28 Feb 2022 09:30:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B66DAB815AE;
        Mon, 28 Feb 2022 17:30:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0933FC340F0;
        Mon, 28 Feb 2022 17:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069451;
        bh=2A8txO/37jTjRq7tu0H8N9qZCzHLsUbc41RmaV/i3Jo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bv5d2boPZriZEeeI/jPo1CdNqTRkbH30SFaQgEBynkr6stW2Hc/89rWxYvXbwcpjE
         NjHn7XWR772UBi+guH8yLOkps4mHiAE9ej2Tl9ubZ3b9hXitWtVeMrzV59pJyKqvrE
         LCN0f00WKtV6CQPQ0qIRvwsJ814VYGTtyMZix1sk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 24/53] net: Force inlining of checksum functions in net/checksum.h
Date:   Mon, 28 Feb 2022 18:24:22 +0100
Message-Id: <20220228172250.060108334@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172248.232273337@linuxfoundation.org>
References: <20220228172248.232273337@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit 5486f5bf790b5c664913076c3194b8f916a5c7ad upstream.

All functions defined as static inline in net/checksum.h are
meant to be inlined for performance reason.

But since commit ac7c3e4ff401 ("compiler: enable
CONFIG_OPTIMIZE_INLINING forcibly") the compiler is allowed to
uninline functions when it wants.

Fair enough in the general case, but for tiny performance critical
checksum helpers that's counter-productive.

The problem mainly arises when selecting CONFIG_CC_OPTIMISE_FOR_SIZE,
Those helpers being 'static inline' in header files you suddenly find
them duplicated many times in the resulting vmlinux.

Here is a typical exemple when building powerpc pmac32_defconfig
with CONFIG_CC_OPTIMISE_FOR_SIZE. csum_sub() appears 4 times:

	c04a23cc <csum_sub>:
	c04a23cc:	7c 84 20 f8 	not     r4,r4
	c04a23d0:	7c 63 20 14 	addc    r3,r3,r4
	c04a23d4:	7c 63 01 94 	addze   r3,r3
	c04a23d8:	4e 80 00 20 	blr
		...
	c04a2ce8:	4b ff f6 e5 	bl      c04a23cc <csum_sub>
		...
	c04a2d2c:	4b ff f6 a1 	bl      c04a23cc <csum_sub>
		...
	c04a2d54:	4b ff f6 79 	bl      c04a23cc <csum_sub>
		...
	c04a754c <csum_sub>:
	c04a754c:	7c 84 20 f8 	not     r4,r4
	c04a7550:	7c 63 20 14 	addc    r3,r3,r4
	c04a7554:	7c 63 01 94 	addze   r3,r3
	c04a7558:	4e 80 00 20 	blr
		...
	c04ac930:	4b ff ac 1d 	bl      c04a754c <csum_sub>
		...
	c04ad264:	4b ff a2 e9 	bl      c04a754c <csum_sub>
		...
	c04e3b08 <csum_sub>:
	c04e3b08:	7c 84 20 f8 	not     r4,r4
	c04e3b0c:	7c 63 20 14 	addc    r3,r3,r4
	c04e3b10:	7c 63 01 94 	addze   r3,r3
	c04e3b14:	4e 80 00 20 	blr
		...
	c04e5788:	4b ff e3 81 	bl      c04e3b08 <csum_sub>
		...
	c04e65c8:	4b ff d5 41 	bl      c04e3b08 <csum_sub>
		...
	c0512d34 <csum_sub>:
	c0512d34:	7c 84 20 f8 	not     r4,r4
	c0512d38:	7c 63 20 14 	addc    r3,r3,r4
	c0512d3c:	7c 63 01 94 	addze   r3,r3
	c0512d40:	4e 80 00 20 	blr
		...
	c0512dfc:	4b ff ff 39 	bl      c0512d34 <csum_sub>
		...
	c05138bc:	4b ff f4 79 	bl      c0512d34 <csum_sub>
		...

Restore the expected behaviour by using __always_inline for all
functions defined in net/checksum.h

vmlinux size is even reduced by 256 bytes with this patch:

	   text	   data	    bss	    dec	    hex	filename
	6980022	2515362	 194384	9689768	 93daa8	vmlinux.before
	6979862	2515266	 194384	9689512	 93d9a8	vmlinux.now

Fixes: ac7c3e4ff401 ("compiler: enable CONFIG_OPTIMIZE_INLINING forcibly")
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/checksum.h |   41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

--- a/include/net/checksum.h
+++ b/include/net/checksum.h
@@ -22,7 +22,7 @@
 #include <asm/checksum.h>
 
 #ifndef _HAVE_ARCH_COPY_AND_CSUM_FROM_USER
-static inline
+static __always_inline
 __wsum csum_and_copy_from_user (const void __user *src, void *dst,
 				      int len, __wsum sum, int *err_ptr)
 {
@@ -37,7 +37,7 @@ __wsum csum_and_copy_from_user (const vo
 #endif
 
 #ifndef HAVE_CSUM_COPY_USER
-static __inline__ __wsum csum_and_copy_to_user
+static __always_inline __wsum csum_and_copy_to_user
 (const void *src, void __user *dst, int len, __wsum sum, int *err_ptr)
 {
 	sum = csum_partial(src, len, sum);
@@ -54,7 +54,7 @@ static __inline__ __wsum csum_and_copy_t
 #endif
 
 #ifndef HAVE_ARCH_CSUM_ADD
-static inline __wsum csum_add(__wsum csum, __wsum addend)
+static __always_inline __wsum csum_add(__wsum csum, __wsum addend)
 {
 	u32 res = (__force u32)csum;
 	res += (__force u32)addend;
@@ -62,12 +62,12 @@ static inline __wsum csum_add(__wsum csu
 }
 #endif
 
-static inline __wsum csum_sub(__wsum csum, __wsum addend)
+static __always_inline __wsum csum_sub(__wsum csum, __wsum addend)
 {
 	return csum_add(csum, ~addend);
 }
 
-static inline __sum16 csum16_add(__sum16 csum, __be16 addend)
+static __always_inline __sum16 csum16_add(__sum16 csum, __be16 addend)
 {
 	u16 res = (__force u16)csum;
 
@@ -75,12 +75,12 @@ static inline __sum16 csum16_add(__sum16
 	return (__force __sum16)(res + (res < (__force u16)addend));
 }
 
-static inline __sum16 csum16_sub(__sum16 csum, __be16 addend)
+static __always_inline __sum16 csum16_sub(__sum16 csum, __be16 addend)
 {
 	return csum16_add(csum, ~addend);
 }
 
-static inline __wsum
+static __always_inline __wsum
 csum_block_add(__wsum csum, __wsum csum2, int offset)
 {
 	u32 sum = (__force u32)csum2;
@@ -92,36 +92,37 @@ csum_block_add(__wsum csum, __wsum csum2
 	return csum_add(csum, (__force __wsum)sum);
 }
 
-static inline __wsum
+static __always_inline __wsum
 csum_block_add_ext(__wsum csum, __wsum csum2, int offset, int len)
 {
 	return csum_block_add(csum, csum2, offset);
 }
 
-static inline __wsum
+static __always_inline __wsum
 csum_block_sub(__wsum csum, __wsum csum2, int offset)
 {
 	return csum_block_add(csum, ~csum2, offset);
 }
 
-static inline __wsum csum_unfold(__sum16 n)
+static __always_inline __wsum csum_unfold(__sum16 n)
 {
 	return (__force __wsum)n;
 }
 
-static inline __wsum csum_partial_ext(const void *buff, int len, __wsum sum)
+static __always_inline
+__wsum csum_partial_ext(const void *buff, int len, __wsum sum)
 {
 	return csum_partial(buff, len, sum);
 }
 
 #define CSUM_MANGLED_0 ((__force __sum16)0xffff)
 
-static inline void csum_replace_by_diff(__sum16 *sum, __wsum diff)
+static __always_inline void csum_replace_by_diff(__sum16 *sum, __wsum diff)
 {
 	*sum = csum_fold(csum_add(diff, ~csum_unfold(*sum)));
 }
 
-static inline void csum_replace4(__sum16 *sum, __be32 from, __be32 to)
+static __always_inline void csum_replace4(__sum16 *sum, __be32 from, __be32 to)
 {
 	__wsum tmp = csum_sub(~csum_unfold(*sum), (__force __wsum)from);
 
@@ -134,7 +135,7 @@ static inline void csum_replace4(__sum16
  *  m : old value of a 16bit field
  *  m' : new value of a 16bit field
  */
-static inline void csum_replace2(__sum16 *sum, __be16 old, __be16 new)
+static __always_inline void csum_replace2(__sum16 *sum, __be16 old, __be16 new)
 {
 	*sum = ~csum16_add(csum16_sub(~(*sum), old), new);
 }
@@ -153,16 +154,16 @@ void inet_proto_csum_replace16(__sum16 *
 void inet_proto_csum_replace_by_diff(__sum16 *sum, struct sk_buff *skb,
 				     __wsum diff, bool pseudohdr);
 
-static inline void inet_proto_csum_replace2(__sum16 *sum, struct sk_buff *skb,
-					    __be16 from, __be16 to,
-					    bool pseudohdr)
+static __always_inline
+void inet_proto_csum_replace2(__sum16 *sum, struct sk_buff *skb,
+			      __be16 from, __be16 to, bool pseudohdr)
 {
 	inet_proto_csum_replace4(sum, skb, (__force __be32)from,
 				 (__force __be32)to, pseudohdr);
 }
 
-static inline __wsum remcsum_adjust(void *ptr, __wsum csum,
-				    int start, int offset)
+static __always_inline __wsum remcsum_adjust(void *ptr, __wsum csum,
+					     int start, int offset)
 {
 	__sum16 *psum = (__sum16 *)(ptr + offset);
 	__wsum delta;
@@ -178,7 +179,7 @@ static inline __wsum remcsum_adjust(void
 	return delta;
 }
 
-static inline void remcsum_unadjust(__sum16 *psum, __wsum delta)
+static __always_inline void remcsum_unadjust(__sum16 *psum, __wsum delta)
 {
 	*psum = csum_fold(csum_sub(delta, (__force __wsum)*psum));
 }


