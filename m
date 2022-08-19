Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC61D599A21
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 12:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348039AbiHSKvt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 06:51:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346527AbiHSKvt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 06:51:49 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD6D012D27;
        Fri, 19 Aug 2022 03:51:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660906307; x=1692442307;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Xg/Wu+E2dA7UBAkvJ0UOV8Vgqyso5h+bxyEw+kxytDA=;
  b=evbgrOx7JRtVBTNd1166m8L/k2LQTrnr+WPYlwKZvVEnKUeDvg9eh/RO
   1zLJXhy7nWPS8ODmI+SZrjxjG+pn2s8j6bmUDA7jtrKKCjVLnxGzG0rgP
   HlBmm5KgxnnNzBT7D3FUw52DHAoK0rBvvgeCjcgg0IfqRI9TWJL9iBqQ8
   x8XUCwRYf8/PpIxzw5a16WsleLYfQankLH31neVQ1XQU7LwlQFXogMXc5
   UaBU28m7X0d4jmDV+TLhx6H2H0WmXRxm0ihgSKOA/dq1G699lzNEhuLAW
   XaeCvMNRZyz066Iwu0+z6onJEb+/3vI5xmhSrFfRnffJsrl3uz0B3p4W2
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="290555766"
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="290555766"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2022 03:51:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="641215598"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga001.jf.intel.com with ESMTP; 19 Aug 2022 03:51:42 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 27JApf69026305;
        Fri, 19 Aug 2022 11:51:41 +0100
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
Date:   Fri, 19 Aug 2022 12:50:01 +0200
Message-Id: <20220819105001.1130876-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <Yv5IfiwqGumJwVGT@kroah.com>
References: <20220818115306.1109642-1-alexandr.lobakin@intel.com> <20220818115306.1109642-4-alexandr.lobakin@intel.com> <Yv4vT6s6UHYvXOlX@kroah.com> <20220818135629.1113036-1-alexandr.lobakin@intel.com> <Yv5IfiwqGumJwVGT@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>
Date: Thu, 18 Aug 2022 16:11:10 +0200

> On Thu, Aug 18, 2022 at 03:56:29PM +0200, Alexander Lobakin wrote:
> > From: Greg KH <gregkh@linuxfoundation.org>
> > Date: Thu, 18 Aug 2022 14:23:43 +0200
> > 
> > > On Thu, Aug 18, 2022 at 01:53:06PM +0200, Alexander Lobakin wrote:
> > > > Currently, kallsyms kernel code copes with symbols with the same
> > > > name by indexing them according to their position in vmlinux and
> > > > requiring to provide an index of the desired symbol. This is not
> > > > really quite reliable and is fragile to any features performing
> > > > symbol or section manipulations such as FG-KASLR.
> > > 
> > > Ah, here's the reasoning, stuff like this should go into the 0/X message
> > > too, right?
> > > 
> > > Anyway, what is currently broken that requires this?  What will this
> > > make easier in the future?  What in the future will depend on this?
> > 
> > 2) FG-KASLR will depend and probably some more crazy hardening
> >    stuff. And/or perf-based function/symbol placement, which is
> >    in the "discuss and dream sometimes" stage.
> 
> I have no idea what "FG-KASLR" is.  Why not submit these changes when
> whatever that is is ready for submission?

It doesn't matter much, the main idea is that the current approach
with relying on symbol positions in the vmlinux is broken when we
reorder symbols during the kernel initialization.
As I said, this is an early RFC do discuss the idea and the
implementation. I could submit it along with FG-KASLR, but then if
there would be major change requests, I'd need to redo lots of
stuff, which is not very efficient. It's better to settle down the
implementation details in advance.
Plus this kallsyms feature goes standalone as it gets bigger. It
will contain a pack of commits and touch several different
subsystems. Mixing all of this with FG-KASLR in one series doesn't
sound good to me.

> 
> thanks,
> 
> greg k-h

Thanks,
Olek
