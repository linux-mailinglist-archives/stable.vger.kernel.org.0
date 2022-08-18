Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7F559830C
	for <lists+stable@lfdr.de>; Thu, 18 Aug 2022 14:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244611AbiHRMUP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Aug 2022 08:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240115AbiHRMUN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Aug 2022 08:20:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEA4F785A0;
        Thu, 18 Aug 2022 05:20:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6985CB82169;
        Thu, 18 Aug 2022 12:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E693C433C1;
        Thu, 18 Aug 2022 12:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660825210;
        bh=A8X6yOAN55DeT7y1lXoV7LB/mMlc6LxkN/2ibfEG/vo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ykIH2RuIpzR9hQRiJywvXsQ6Tpmec5QgBHL3z4Md56D8yaRAF9CCgGCCee1Fw7nh/
         L1/spztbKhY289FfYJnGvOgzbn1aLep1bMU4EOTimPDLRlXyfJ4PJ46lV92Ztxinth
         iqfKUTB4pVN3ApJT6Kd76A5M2mfNiPF0sob2ljS8=
Date:   Thu, 18 Aug 2022 14:20:06 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     linux-kernel@vger.kernel.org,
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
Subject: Re: [RFC PATCH 0/3] kallsyms: add option to include relative
 filepaths into kallsyms
Message-ID: <Yv4udm0QKVA1ku++@kroah.com>
References: <20220818115306.1109642-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220818115306.1109642-1-alexandr.lobakin@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 18, 2022 at 01:53:03PM +0200, Alexander Lobakin wrote:
> This is an early RFC to not rewrite stuff one more time later on if
> the implementation is not acceptable or any major design changes are
> required. For the TODO list, please scroll to the end.
> 
> Make kallsyms independent of symbols positions in vmlinux (or module)
> by including relative filepath in each symbol's kallsyms value. I.e.
> 
> dev_gro_receive -> net/core/gro.c:dev_gro_receive
> 
> For the implementation details, please look at the patch 3/3.
> Patch 2/3 is just a stub, I plan to reuse kallsyms enhancement from
> the Rust series for it.
> Patch 1/3 is a fix of one modpost macro straight from 2.6.12-rc2.
> 
> A nice side effect is that it's now easier to debug the kernel, as
> stacktraces will now tell every call's place in the file tree:

That's a side effect, but that does not explain _why_ you want this
change.

What is this good for?  Who can use it?  Why is it worth added build
times?

You don't tell us anything except what this does :(

thanks,

greg k-h
