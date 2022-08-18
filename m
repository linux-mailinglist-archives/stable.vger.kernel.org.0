Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE39598479
	for <lists+stable@lfdr.de>; Thu, 18 Aug 2022 15:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245251AbiHRNmm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Aug 2022 09:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244804AbiHRNmR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Aug 2022 09:42:17 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 245E1B81C0;
        Thu, 18 Aug 2022 06:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660830068; x=1692366068;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VY0sbb/RXNUU157VT44IttsuY4LjKgmphFRvohq9bwI=;
  b=X3MIfQ8bFiTrygrL3X+IeA9Nc8ILWcJafDCVuqaV27M7ndbLPmG83OHi
   Z5Fv62F4l7q+xudGNaY7RQCLEKttB08cN9OQhycEc2BKxTTVibr4LnNWO
   E6AcidB0Ib/j8d4WpmgfQbQ/UFeloaoRXS6v7NdUwqGxrGzlYLu+64Gy+
   Ae+s9hRUPx8X02M4AMvLG5ya2G1pYsVlPmw9OZV1ZcfuHYYFrwsoUSkz5
   ao25o5UaX+gk4LIbM9xtMiiqkHb6dixQT7GTvwAaa9O/eSs7+45PVqoYu
   7OS6gYO/IW+/k3ZPxuq78aNx0alBJCAyV8leaq9K32JWf884xdGU7KSQ8
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10442"; a="379051431"
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="379051431"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 06:41:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="853418276"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga006.fm.intel.com with ESMTP; 18 Aug 2022 06:41:02 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 27IDf0GP012032;
        Thu, 18 Aug 2022 14:41:00 +0100
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
Subject: Re: [RFC PATCH 0/3] kallsyms: add option to include relative filepaths into kallsyms
Date:   Thu, 18 Aug 2022 15:39:18 +0200
Message-Id: <20220818133918.1112657-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <Yv4udm0QKVA1ku++@kroah.com>
References: <20220818115306.1109642-1-alexandr.lobakin@intel.com> <Yv4udm0QKVA1ku++@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
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

From: Greg KH <gregkh@linuxfoundation.org>
Date: Thu, 18 Aug 2022 14:20:06 +0200

> On Thu, Aug 18, 2022 at 01:53:03PM +0200, Alexander Lobakin wrote:
> > This is an early RFC to not rewrite stuff one more time later on if
> > the implementation is not acceptable or any major design changes are
> > required. For the TODO list, please scroll to the end.
> > 
> > Make kallsyms independent of symbols positions in vmlinux (or module)
> > by including relative filepath in each symbol's kallsyms value. I.e.
> > 
> > dev_gro_receive -> net/core/gro.c:dev_gro_receive
> > 
> > For the implementation details, please look at the patch 3/3.
> > Patch 2/3 is just a stub, I plan to reuse kallsyms enhancement from
> > the Rust series for it.
> > Patch 1/3 is a fix of one modpost macro straight from 2.6.12-rc2.
> > 
> > A nice side effect is that it's now easier to debug the kernel, as
> > stacktraces will now tell every call's place in the file tree:
> 
> That's a side effect, but that does not explain _why_ you want this
> change.
> 
> What is this good for?  Who can use it?  Why is it worth added build
> times?

I think I wrote that we need to get rid of this positioned-based
search for kallsyms, at least for livepatching and probes, didn't
I?
OTOH I didn't write that originally that was a prereq for FG-KASLR,
but then I decided it deserves a separate series =\ Thanks for
mentioning this, so I wrote it here now and will not forget this
time to mention it in the cover letter for v2.

> 
> You don't tell us anything except what this does :(
> 
> thanks,
> 
> greg k-h

Thanks,
Olek
