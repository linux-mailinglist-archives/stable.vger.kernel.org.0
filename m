Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD7B56FD14
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233840AbiGKJuo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:50:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233928AbiGKJtf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:49:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2738E4B0CB;
        Mon, 11 Jul 2022 02:24:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C710612B7;
        Mon, 11 Jul 2022 09:24:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B718C34115;
        Mon, 11 Jul 2022 09:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531457;
        bh=SHtzspCuhbnM1/YWBdJUS3Fsa20mVhf+ATOcOxMdMA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GPnwAFAchAtVt85Lu6VC32sb9xPwnzia/rg/u5uYNw0XSlTCjtrdKXKJcVrutsHLC
         ULihrM6CENp0zex0h2siDkuDqGFSMv5F2OM6xGGTmZux09J7xtgTq3FTjUDYDJQ1q/
         44C7zkpEwnsDxMAdTbsW4XdsrkDqYM/Fi4t6XsMM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 112/230] stddef: Introduce DECLARE_FLEX_ARRAY() helper
Date:   Mon, 11 Jul 2022 11:06:08 +0200
Message-Id: <20220711090607.243974627@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
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

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 3080ea5553cc909b000d1f1d964a9041962f2c5b ]

There are many places where kernel code wants to have several different
typed trailing flexible arrays. This would normally be done with multiple
flexible arrays in a union, but since GCC and Clang don't (on the surface)
allow this, there have been many open-coded workarounds, usually involving
neighboring 0-element arrays at the end of a structure. For example,
instead of something like this:

struct thing {
	...
	union {
		struct type1 foo[];
		struct type2 bar[];
	};
};

code works around the compiler with:

struct thing {
	...
	struct type1 foo[0];
	struct type2 bar[];
};

Another case is when a flexible array is wanted as the single member
within a struct (which itself is usually in a union). For example, this
would be worked around as:

union many {
	...
	struct {
		struct type3 baz[0];
	};
};

These kinds of work-arounds cause problems with size checks against such
zero-element arrays (for example when building with -Warray-bounds and
-Wzero-length-bounds, and with the coming FORTIFY_SOURCE improvements),
so they must all be converted to "real" flexible arrays, avoiding warnings
like this:

fs/hpfs/anode.c: In function 'hpfs_add_sector_to_btree':
fs/hpfs/anode.c:209:27: warning: array subscript 0 is outside the bounds of an interior zero-length array 'struct bplus_internal_node[0]' [-Wzero-length-bounds]
  209 |    anode->btree.u.internal[0].down = cpu_to_le32(a);
      |    ~~~~~~~~~~~~~~~~~~~~~~~^~~
In file included from fs/hpfs/hpfs_fn.h:26,
                 from fs/hpfs/anode.c:10:
fs/hpfs/hpfs.h:412:32: note: while referencing 'internal'
  412 |     struct bplus_internal_node internal[0]; /* (internal) 2-word entries giving
      |                                ^~~~~~~~

drivers/net/can/usb/etas_es58x/es58x_fd.c: In function 'es58x_fd_tx_can_msg':
drivers/net/can/usb/etas_es58x/es58x_fd.c:360:35: warning: array subscript 65535 is outside the bounds of an interior zero-length array 'u8[0]' {aka 'unsigned char[]'} [-Wzero-length-bounds]
  360 |  tx_can_msg = (typeof(tx_can_msg))&es58x_fd_urb_cmd->raw_msg[msg_len];
      |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from drivers/net/can/usb/etas_es58x/es58x_core.h:22,
                 from drivers/net/can/usb/etas_es58x/es58x_fd.c:17:
drivers/net/can/usb/etas_es58x/es58x_fd.h:231:6: note: while referencing 'raw_msg'
  231 |   u8 raw_msg[0];
      |      ^~~~~~~

However, it _is_ entirely possible to have one or more flexible arrays
in a struct or union: it just has to be in another struct. And since it
cannot be alone in a struct, such a struct must have at least 1 other
named member -- but that member can be zero sized. Wrap all this nonsense
into the new DECLARE_FLEX_ARRAY() in support of having flexible arrays
in unions (or alone in a struct).

As with struct_group(), since this is needed in UAPI headers as well,
implement the core there, with a non-UAPI wrapper.

Additionally update kernel-doc to understand its existence.

https://github.com/KSPP/linux/issues/137

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/stddef.h      | 13 +++++++++++++
 include/uapi/linux/stddef.h | 16 ++++++++++++++++
 scripts/kernel-doc          |  2 ++
 3 files changed, 31 insertions(+)

diff --git a/include/linux/stddef.h b/include/linux/stddef.h
index 938216f8ab7e..31fdbb784c24 100644
--- a/include/linux/stddef.h
+++ b/include/linux/stddef.h
@@ -84,4 +84,17 @@ enum {
 #define struct_group_tagged(TAG, NAME, MEMBERS...) \
 	__struct_group(TAG, NAME, /* no attrs */, MEMBERS)
 
+/**
+ * DECLARE_FLEX_ARRAY() - Declare a flexible array usable in a union
+ *
+ * @TYPE: The type of each flexible array element
+ * @NAME: The name of the flexible array member
+ *
+ * In order to have a flexible array member in a union or alone in a
+ * struct, it needs to be wrapped in an anonymous struct with at least 1
+ * named member, but that member can be empty.
+ */
+#define DECLARE_FLEX_ARRAY(TYPE, NAME) \
+	__DECLARE_FLEX_ARRAY(TYPE, NAME)
+
 #endif
diff --git a/include/uapi/linux/stddef.h b/include/uapi/linux/stddef.h
index 610204f7c275..3021ea25a284 100644
--- a/include/uapi/linux/stddef.h
+++ b/include/uapi/linux/stddef.h
@@ -25,3 +25,19 @@
 		struct { MEMBERS } ATTRS; \
 		struct TAG { MEMBERS } ATTRS NAME; \
 	}
+
+/**
+ * __DECLARE_FLEX_ARRAY() - Declare a flexible array usable in a union
+ *
+ * @TYPE: The type of each flexible array element
+ * @NAME: The name of the flexible array member
+ *
+ * In order to have a flexible array member in a union or alone in a
+ * struct, it needs to be wrapped in an anonymous struct with at least 1
+ * named member, but that member can be empty.
+ */
+#define __DECLARE_FLEX_ARRAY(TYPE, NAME)	\
+	struct { \
+		struct { } __empty_ ## NAME; \
+		TYPE NAME[]; \
+	}
diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index 38aa799a776c..5d54b57ff90c 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -1263,6 +1263,8 @@ sub dump_struct($$) {
 	$members =~ s/DECLARE_KFIFO\s*\($args,\s*$args,\s*$args\)/$2 \*$1/gos;
 	# replace DECLARE_KFIFO_PTR
 	$members =~ s/DECLARE_KFIFO_PTR\s*\($args,\s*$args\)/$2 \*$1/gos;
+	# replace DECLARE_FLEX_ARRAY
+	$members =~ s/(?:__)?DECLARE_FLEX_ARRAY\s*\($args,\s*$args\)/$1 $2\[\]/gos;
 	my $declaration = $members;
 
 	# Split nested struct/union elements as newer ones
-- 
2.35.1



