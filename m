Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E01A059828B
	for <lists+stable@lfdr.de>; Thu, 18 Aug 2022 13:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244323AbiHRLy4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Aug 2022 07:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244302AbiHRLyz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Aug 2022 07:54:55 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 058BE7FE57;
        Thu, 18 Aug 2022 04:54:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660823695; x=1692359695;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MWRk7nUAjLt1z6EXBpoxU3sL1zH91Ih2AFPCAtupsF4=;
  b=O0B6w8+hJZL+kNSo4mtW/Ij+eEP962iJvsVJnkmf9/BxZNjxUJgDzB1B
   BS8e1UJvBMNl0B1PZki73L/y88QCl8l1gnas97ut/C6nNc4pmamF+ZR20
   tu3E2hVdq4J8LOaHzpgo2wEUpncYwTxZujumj5OwZ8+zKJCqDfRLW9TIE
   mbMPemXaD3cuW/HBEb8eF2IgH1n3CQ+mdvU7V/FdbHV2tVSKFraci+frd
   MwBV/FKH3NKZP5QSoD65fwP12u63XxQI3qiIS2CNx4bq5pGRlufBJv9CB
   hgAhfPRQyqJnUqzvxDeWFA8AeUeQguPbHoKz5lOljTMLX7BWhalfNpRAo
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10442"; a="354477158"
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="354477158"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 04:54:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="636794029"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga008.jf.intel.com with ESMTP; 18 Aug 2022 04:54:50 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 27IBsmfs013911;
        Thu, 18 Aug 2022 12:54:49 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     linux-kernel@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        linux-kbuild@vger.kernel.org, live-patching@vger.kernel.org,
        lkp@intel.com, stable@vger.kernel.org,
        Alexander Lobakin <alexandr.lobakin@intel.com>
Subject: [RFC PATCH 1/3] modpost: fix TO_NATIVE() with expressions and consts
Date:   Thu, 18 Aug 2022 13:53:04 +0200
Message-Id: <20220818115306.1109642-2-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220818115306.1109642-1-alexandr.lobakin@intel.com>
References: <20220818115306.1109642-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Macro TO_NATIVE() directly takes a reference to its argument @x
without making an intermediate variable. This makes compilers
emit build warnings and errors if @x is an expression or a deref
of a const pointer (when target Endianness != host Endianness):

>> scripts/mod/modpost.h:87:18: error: lvalue required as unary '&' operand
      87 |         __endian(&(x), &(__x), sizeof(__x));                    \
         |                  ^
   scripts/mod/sympath.c:19:25: note: in expansion of macro 'TO_NATIVE'
      19 | #define t(x)            TO_NATIVE(x)
         |                         ^~~~~~~~~
   scripts/mod/sympath.c:100:31: note: in expansion of macro 't'
     100 |                 eh->e_shoff = t(h(eh->e_shoff) + off);

>> scripts/mod/modpost.h:87:24: warning: passing argument 2 of '__endian'
discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
      87 |         __endian(&(x), &(__x), sizeof(__x));                    \
         |                        ^~~~~~
   scripts/mod/sympath.c:18:25: note: in expansion of macro 'TO_NATIVE'
      18 | #define h(x)            TO_NATIVE(x)
         |                         ^~~~~~~~~
   scripts/mod/sympath.c:178:48: note: in expansion of macro 'h'
     178 |              iter < end; iter = (void *)iter + h(eh->e_shentsize)) {

Create a temporary variable, assign @x to it and don't use @x after
that. This makes it possible to pass expressions as an argument.
Also, do a cast-away for the second argument when calling __endian()
to avoid 'discarded qualifiers' warning, as typeof() preserves
qualifiers and makes compilers think that we're passing pointer
to a const.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org # 4.9+
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 scripts/mod/modpost.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/scripts/mod/modpost.h b/scripts/mod/modpost.h
index 1178f40a73f3..29f440f18414 100644
--- a/scripts/mod/modpost.h
+++ b/scripts/mod/modpost.h
@@ -83,9 +83,10 @@ static inline void __endian(const void *src, void *dest, unsigned int size)
 
 #define TO_NATIVE(x)						\
 ({								\
-	typeof(x) __x;						\
-	__endian(&(x), &(__x), sizeof(__x));			\
-	__x;							\
+	typeof(x) __src = (x);					\
+	typeof(__src) __dst;					\
+	__endian(&__src, (void *)&__dst, sizeof(__src));	\
+	__dst;							\
 })
 
 #else /* endianness matches */
-- 
2.37.2

