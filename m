Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6C159852E
	for <lists+stable@lfdr.de>; Thu, 18 Aug 2022 16:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245467AbiHRODn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Aug 2022 10:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245404AbiHRODl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Aug 2022 10:03:41 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6582C491E0;
        Thu, 18 Aug 2022 07:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660831421; x=1692367421;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=N8Exyabhbam3MkofX1Yeu2yKsFSXBX5cY+mvOiY0qhk=;
  b=jCCtxU63iLuwUlBXoj5q6AdIYir7k007+0A/iJ0rCqXhCfT+4EnZB5Pi
   Zn82CUKsttmZRzQVVBS2wm5mltS90iYDAaynUIvXLv4ZYoEqS8f2f31dv
   B8a3jNkqzUHqNUUng1m8Zc1O2Mpj8ZvnT14MGo3knl9BlLqJ3vnjfctzq
   1GCiB6B6x9l4wBLQY7jp2QsEGdVDt+QU2C4KCXTsaIUfRoEdp9+/9fElO
   HQgLaBGCdetkZHa6okWv3UGwHhWEq0e97R1xJofbEE77a6aCOwqvi+bCv
   WWgDfGzRn4GPn59Fobz1ru/I/WvArRYsNjcjvAfYAC9fsTvAF/PXGlJCN
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="290329980"
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="290329980"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 07:03:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="607834993"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga002.jf.intel.com with ESMTP; 18 Aug 2022 07:03:32 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 27IE3PC8018169;
        Thu, 18 Aug 2022 15:03:26 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        linux-kernel@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
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
        lkp@intel.com, stable@vger.kernel.org
Subject: Re: [RFC PATCH 1/3] modpost: fix TO_NATIVE() with expressions and consts
Date:   Thu, 18 Aug 2022 16:01:53 +0200
Message-Id: <20220818140153.1113308-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <Yv4v5vwXDER3GA2y@kroah.com>
References: <20220818115306.1109642-1-alexandr.lobakin@intel.com> <20220818115306.1109642-2-alexandr.lobakin@intel.com> <Yv4v5vwXDER3GA2y@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>
Date: Thu, 18 Aug 2022 14:26:14 +0200

> On Thu, Aug 18, 2022 at 01:53:04PM +0200, Alexander Lobakin wrote:
> > Macro TO_NATIVE() directly takes a reference to its argument @x
> > without making an intermediate variable. This makes compilers
> > emit build warnings and errors if @x is an expression or a deref
> > of a const pointer (when target Endianness != host Endianness):
> > 
> > >> scripts/mod/modpost.h:87:18: error: lvalue required as unary '&' operand
> >       87 |         __endian(&(x), &(__x), sizeof(__x));                    \
> >          |                  ^
> >    scripts/mod/sympath.c:19:25: note: in expansion of macro 'TO_NATIVE'
> >       19 | #define t(x)            TO_NATIVE(x)
> >          |                         ^~~~~~~~~
> >    scripts/mod/sympath.c:100:31: note: in expansion of macro 't'
> >      100 |                 eh->e_shoff = t(h(eh->e_shoff) + off);
> > 
> > >> scripts/mod/modpost.h:87:24: warning: passing argument 2 of '__endian'
> > discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
> >       87 |         __endian(&(x), &(__x), sizeof(__x));                    \
> >          |                        ^~~~~~
> >    scripts/mod/sympath.c:18:25: note: in expansion of macro 'TO_NATIVE'
> >       18 | #define h(x)            TO_NATIVE(x)
> >          |                         ^~~~~~~~~
> >    scripts/mod/sympath.c:178:48: note: in expansion of macro 'h'
> >      178 |              iter < end; iter = (void *)iter + h(eh->e_shentsize)) {
> 
> How come this hasn't shown up in cross-builds today?

It doesn't happen with the current code.

> 
> 
> > 
> > Create a temporary variable, assign @x to it and don't use @x after
> > that. This makes it possible to pass expressions as an argument.
> > Also, do a cast-away for the second argument when calling __endian()
> > to avoid 'discarded qualifiers' warning, as typeof() preserves
> > qualifiers and makes compilers think that we're passing pointer
> > to a const.
> > 
> > Reported-by: kernel test robot <lkp@intel.com>
> > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > Cc: stable@vger.kernel.org # 4.9+
> 
> Where are these build warnings showing up at that we don't see them
> today, yet this is needed to go back to all stable trees?

I thought all fixes should go to the applicable stable trees, am I
wrong? If so, I'll drop the tag in the next spin.

I remember we had such discussion already regarding fixing stuff in
modpost, which can happen only with never mainlained GCC LTO or with
the in-dev code. At the end that fix made it into the stables IIRC.

> 
> still confused,
> 
> greg k-h

Thanks,
Olek
