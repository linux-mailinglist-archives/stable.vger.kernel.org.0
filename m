Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06D2A253AC9
	for <lists+stable@lfdr.de>; Thu, 27 Aug 2020 01:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbgHZX5v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 19:57:51 -0400
Received: from smtprelay0132.hostedemail.com ([216.40.44.132]:48980 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726238AbgHZX5u (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Aug 2020 19:57:50 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id 132A318000BE0;
        Wed, 26 Aug 2020 23:57:45 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:967:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2525:2553:2568:2628:2682:2685:2828:2859:2898:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3353:3622:3653:3865:3866:3867:3868:3871:3872:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:5007:6742:7903:9025:10004:10400:10848:11026:11232:11658:11914:12043:12296:12297:12438:12555:12740:12760:12895:13161:13229:13439:14096:14097:14181:14659:14721:21080:21451:21627:21990:30054:30060:30070:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: ocean54_1a016df27068
X-Filterd-Recvd-Size: 3604
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf15.hostedemail.com (Postfix) with ESMTPA;
        Wed, 26 Aug 2020 23:57:42 +0000 (UTC)
Message-ID: <77428f28620d4e5ecad1556396f2b0f8f0daef41.camel@perches.com>
Subject: Re: [PATCH v3] lib/string.c: implement stpcpy
From:   Joe Perches <joe@perches.com>
To:     Kees Cook <keescook@chromium.org>,
        Masahiro Yamada <masahiroy@kernel.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        stable <stable@vger.kernel.org>, Andy Lavr <andy.lavr@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sami Tolvanen <samitolvanen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Yury Norov <yury.norov@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date:   Wed, 26 Aug 2020 16:57:41 -0700
In-Reply-To: <202008261627.7B2B02A@keescook>
References: <20200825135838.2938771-1-ndesaulniers@google.com>
         <CAK7LNAQXo5-5W6hvNMEVPBPf3tRWaf-pQdSR-0OHyi4RCGhjsQ@mail.gmail.com>
         <d56bf7b93f7a28c4a90e4e16fd412e6934704346.camel@perches.com>
         <CAKwvOd=YrVtPsB7HYPO0N=K7QJm9KstayqqeYQERSaGtGy2Bjg@mail.gmail.com>
         <CAK7LNAQKwOo=Oas+7Du9+neSm=Ev6pxdPV7ges7eEEpW+jh8Ug@mail.gmail.com>
         <202008261627.7B2B02A@keescook>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2020-08-26 at 16:38 -0700, Kees Cook wrote:
> On Thu, Aug 27, 2020 at 07:59:45AM +0900, Masahiro Yamada wrote:
[]
> > OK, then stpcpy(), strcpy() and sprintf()
> > have the same level of unsafety.
> 
> Yes. And even snprintf() is dangerous because its return value is how
> much it WOULD have written, which when (commonly) used as an offset for
> further pointer writes, causes OOB writes too. :(
> https://github.com/KSPP/linux/issues/105
> 
> > strcpy() is used everywhere.
> 
> Yes. It's very frustrating, but it's not an excuse to continue
> using it nor introducing more bad APIs.
> 
> $ git grep '\bstrcpy\b' | wc -l
> 2212
> $ git grep '\bstrncpy\b' | wc -l
> 751
> $ git grep '\bstrlcpy\b' | wc -l
> 1712
> 
> $ git grep '\bstrscpy\b' | wc -l
> 1066
> 
> https://www.kernel.org/doc/html/latest/process/deprecated.html#strcpy
> https://github.com/KSPP/linux/issues/88
> 
> https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings
> https://github.com/KSPP/linux/issues/89
> 
> https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy
> https://github.com/KSPP/linux/issues/90
> 
> We have no way right now to block the addition of deprecated API usage,
> which makes ever catching up on this replacement very challenging.

These could be added to checkpatch's deprecated_api test.
---
 scripts/checkpatch.pl | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 149518d2a6a7..f9ccb2a63a95 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -605,6 +605,9 @@ foreach my $entry (@mode_permission_funcs) {
 $mode_perms_search = "(?:${mode_perms_search})";
 
 our %deprecated_apis = (
+	"strcpy"				=> "strscpy",
+	"strncpy"				=> "strscpy",
+	"strlcpy"				=> "strscpy",
 	"synchronize_rcu_bh"			=> "synchronize_rcu",
 	"synchronize_rcu_bh_expedited"		=> "synchronize_rcu_expedited",
 	"call_rcu_bh"				=> "call_rcu",


