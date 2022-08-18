Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEF3C59850B
	for <lists+stable@lfdr.de>; Thu, 18 Aug 2022 16:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245419AbiHRN6L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Aug 2022 09:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245447AbiHRN6G (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Aug 2022 09:58:06 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 113C1B8F04;
        Thu, 18 Aug 2022 06:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660831085; x=1692367085;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2uQ8ZqwhaKWZGyHK1hdjtqgV8mwfjZOfwxAYm1oawKM=;
  b=QvWNx/QK1ioH0VCwK1aHORXuNv2zXRhBff4MlNGXPtWMoV/N+JBS2kzg
   +U9wqaHyLL5zA3nJz1G1GcSk1pF8JvIkIVOjWK4bIgw/Z+aKdmpId+v/p
   ksV73Y8abMuSm2jRSlviEv+jkQRyjJtsOLNs6b+TG/ehv9i3TN7PfM2uX
   lzJXzKie6RMnJielAQhL6/Zpeq+DitK4cYFJYlr2l0MYGKqlG9np4Iqw6
   +ygrJFTilELehIEbTCtQfaLDFKtYLvW5NvBIsVkjPPRLr6W7eQWncEqWU
   OalsZzrVYM/CQV+Ucg5YRD6IGBJOdw28k//q0b1FfG5zll3O7bWVVJZ2v
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="318783417"
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="318783417"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 06:58:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="935815162"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga005.fm.intel.com with ESMTP; 18 Aug 2022 06:58:01 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 27IDvxBD016488;
        Thu, 18 Aug 2022 14:57:59 +0100
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
Subject: Re: [RFC PATCH 3/3] kallsyms: add option to include relative filepaths into kallsyms
Date:   Thu, 18 Aug 2022 15:56:29 +0200
Message-Id: <20220818135629.1113036-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <Yv4vT6s6UHYvXOlX@kroah.com>
References: <20220818115306.1109642-1-alexandr.lobakin@intel.com> <20220818115306.1109642-4-alexandr.lobakin@intel.com> <Yv4vT6s6UHYvXOlX@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>
Date: Thu, 18 Aug 2022 14:23:43 +0200

> On Thu, Aug 18, 2022 at 01:53:06PM +0200, Alexander Lobakin wrote:
> > Currently, kallsyms kernel code copes with symbols with the same
> > name by indexing them according to their position in vmlinux and
> > requiring to provide an index of the desired symbol. This is not
> > really quite reliable and is fragile to any features performing
> > symbol or section manipulations such as FG-KASLR.
> 
> Ah, here's the reasoning, stuff like this should go into the 0/X message
> too, right?
> 
> Anyway, what is currently broken that requires this?  What will this
> make easier in the future?  What in the future will depend on this?

2) FG-KASLR will depend and probably some more crazy hardening
   stuff. And/or perf-based function/symbol placement, which is
   in the "discuss and dream sometimes" stage.

> 
> > So, in order to make kallsyms immune to object code modification
> 
> What do you mean by "object code modification"?

Yeah, probably not a good term. Anything that can change symbol
order in the decompressed kernel in the memory. As for FG-KASLR,
it shuffles functions on each boot randomly, so

> 
> Can that happen now?  What causes it?  What happens if it does happen?

So then, if e.g. we have two functions with the same name:

ffffffff81133700 t func (func one)
ffffffff81733100 t func (func two)

and they got reordered by FG-KASLR

ffffffffdeadbeef t func (func two)
ffffffffe0fffeed t func (func one)

and kallsyms table got reordered too.
So, utilities that rely on vmlinux and kallsyms, like probes,
livepatch etc. will have mismatch in "symbol positions" with the
kernel, so wrong symbols will be patched. So the code will get
broken.

> 
> And why are any of these being cc:ed to the stable mailing list?

I Cced stable in 1/3 and I don't like when someone receives only
some parts of a series, and not only me. So I usually collect all
addresses and make one Tos and Ccs for the whole stuff.

> 
> confused,
> 
> greg k-h

Thanks,
Olek
