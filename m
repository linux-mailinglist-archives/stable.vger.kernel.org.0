Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0AD4A5D6E
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 14:28:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238654AbiBAN2y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 08:28:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238612AbiBAN2x (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 08:28:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BC5FC061714;
        Tue,  1 Feb 2022 05:28:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 244D86154A;
        Tue,  1 Feb 2022 13:28:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 252C4C340EB;
        Tue,  1 Feb 2022 13:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643722132;
        bh=cXcPTewqmwfdy6WLzBYTm7mmiY7gQapV5gLUnxXuBJM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X8GRn9j/6VclNn2LaMi7ILPvNbU/WrXIIlXxEKwimOnwbWX9YeOOUylmsw61ESpXu
         pEVDMCNaVgxh1uZbW3sYgofCcZ2zIcSuq2GCl7lrU4fM65WJSONbV1PrFBn+L+eA3i
         fpXLXbrc0mbqhQfGIEW6Srqrnm8jYUtziPsBBRzZyMGCA90aFlUuQapvjqOvy2NT0k
         9zYOwH6mwPO0EmOoUshgBFDcbaFg1mzurh6+EbcVw9lebGwFoakXr9DhdhRlZVvz4q
         x5MdzJGoCrl6HODSKJy9w0vrWhV8dk4ID11sxcfecfX2Xweb/rjQFiStiIfBD7ly0X
         yg9DwCidSsRIw==
Date:   Tue, 1 Feb 2022 14:28:46 +0100
From:   Christian Brauner <brauner@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        kernel test robot <oliver.sang@intel.com>,
        Ariadne Conill <ariadne@dereferenced.org>,
        0day robot <lkp@intel.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Rich Felker <dalias@libc.org>,
        Eric Biederman <ebiederm@xmission.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, lkp@lists.01.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org
Subject: Re: [fs/exec]  80bd5afdd8: xfstests.generic.633.fail
Message-ID: <20220201132846.7rrkosqyeidij47w@wittgenstein>
References: <20220127000724.15106-1-ariadne@dereferenced.org>
 <20220131144352.GE16385@xsang-OptiPlex-9020>
 <20220131150819.iuqlz3rz6q7cheap@wittgenstein>
 <Yff9+tIDAvYM5EO/@casper.infradead.org>
 <20220131153707.oe45h7tuci2cbfuv@wittgenstein>
 <YfgFeWbZPl+gAUYE@casper.infradead.org>
 <20220131161415.wlvtsd4ecehyg3x5@wittgenstein>
 <20220131171344.77iifun5wdilbqdz@wittgenstein>
 <20220131135940.20790cff1747e79dd855aaf4@linux-foundation.org>
 <202201311447.4A1CCAF@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <202201311447.4A1CCAF@keescook>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 31, 2022 at 02:49:36PM -0800, Kees Cook wrote:
> On Mon, Jan 31, 2022 at 01:59:40PM -0800, Andrew Morton wrote:
> > On Mon, 31 Jan 2022 18:13:44 +0100 Christian Brauner <brauner@kernel.org> wrote:
> > 
> > > > in other words, the changes that you see CMD_ARGS[0] == NULL for
> > > > execveat() seem higher than for path-based exec.
> > > > 
> > > > To counter that we should probably at least update the execveat()
> > > > manpage with a recommendation what CMD_ARGS[0] should be set to if it
> > > > isn't allowed to be set to NULL anymore. This is why was asking what
> > > > argv[0] is supposed to be if the binary doesn't take any arguments.
> > > 
> > > Sent a fix to our fstests now replacing the argv[0] as NULL with "".
> > 
> > As we hit this check so quickly, I'm thinking that Ariadne's patch
> > "fs/exec: require argv[0] presence in do_execveat_common()" (which
> > added the check) isn't something we'll be able to merge into mainline?
> 
> I think the next best would be to mutate an NULL argv into { "", NULL }.
> However, I still think we should do the pr_warn().
> 
> Thoughts?

+1
