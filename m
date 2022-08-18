Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA4A459855A
	for <lists+stable@lfdr.de>; Thu, 18 Aug 2022 16:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244976AbiHROLQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Aug 2022 10:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245435AbiHROLP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Aug 2022 10:11:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC9518E0ED;
        Thu, 18 Aug 2022 07:11:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C2D261731;
        Thu, 18 Aug 2022 14:11:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46BD6C433C1;
        Thu, 18 Aug 2022 14:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660831873;
        bh=ErNEXMZ2tqQy05KLZyQRPH+trN2WhmiApeAwyvPwl7w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bmgtldMqQVo1FNOQ5u42ZqsT09yDPWxD2xgNeLwFyfDjsg0J6S0cgKeZsO3mY9jwR
         3E5ymbhHDujfNeLIz/GMe2fZusdGXpZnWgTNqEFqRKs4CWIFQb0iSimzFUU38SMhmL
         Iy3OchhWvwz1DVHShWCV5Dgkm0J/DuGwyUIQpbpE=
Date:   Thu, 18 Aug 2022 16:11:10 +0200
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
Subject: Re: [RFC PATCH 3/3] kallsyms: add option to include relative
 filepaths into kallsyms
Message-ID: <Yv5IfiwqGumJwVGT@kroah.com>
References: <20220818115306.1109642-1-alexandr.lobakin@intel.com>
 <20220818115306.1109642-4-alexandr.lobakin@intel.com>
 <Yv4vT6s6UHYvXOlX@kroah.com>
 <20220818135629.1113036-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220818135629.1113036-1-alexandr.lobakin@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 18, 2022 at 03:56:29PM +0200, Alexander Lobakin wrote:
> From: Greg KH <gregkh@linuxfoundation.org>
> Date: Thu, 18 Aug 2022 14:23:43 +0200
> 
> > On Thu, Aug 18, 2022 at 01:53:06PM +0200, Alexander Lobakin wrote:
> > > Currently, kallsyms kernel code copes with symbols with the same
> > > name by indexing them according to their position in vmlinux and
> > > requiring to provide an index of the desired symbol. This is not
> > > really quite reliable and is fragile to any features performing
> > > symbol or section manipulations such as FG-KASLR.
> > 
> > Ah, here's the reasoning, stuff like this should go into the 0/X message
> > too, right?
> > 
> > Anyway, what is currently broken that requires this?  What will this
> > make easier in the future?  What in the future will depend on this?
> 
> 2) FG-KASLR will depend and probably some more crazy hardening
>    stuff. And/or perf-based function/symbol placement, which is
>    in the "discuss and dream sometimes" stage.

I have no idea what "FG-KASLR" is.  Why not submit these changes when
whatever that is is ready for submission?

thanks,

greg k-h
