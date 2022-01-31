Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 662794A51F3
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 22:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbiAaV7q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 16:59:46 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:54776 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiAaV7o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 16:59:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70E1961581;
        Mon, 31 Jan 2022 21:59:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55909C340E8;
        Mon, 31 Jan 2022 21:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643666381;
        bh=vNlLgrPBYYVLtyrSiMdjfL/qJCb4K3K6IhJIJV2Y96U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ddqgOcAOpEQDMmnkqDH9mzjGwcK0/itBNcvh7267A1cu82AEZgDp2XVFoUkWCSqJs
         22jOnS9lho9WOAKWSJ0xmydlBWAs9YjhMVXTneKGEWiP2NEMeqO05sZiir4V9mEdrW
         +oS4crPs0fdnLGL4EFqaUDEwmhclMXIqcKvly5vc=
Date:   Mon, 31 Jan 2022 13:59:40 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Christian Brauner <brauner@kernel.org>
Cc:     Matthew Wilcox <willy@infradead.org>,
        kernel test robot <oliver.sang@intel.com>,
        Kees Cook <keescook@chromium.org>,
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
Message-Id: <20220131135940.20790cff1747e79dd855aaf4@linux-foundation.org>
In-Reply-To: <20220131171344.77iifun5wdilbqdz@wittgenstein>
References: <20220127000724.15106-1-ariadne@dereferenced.org>
        <20220131144352.GE16385@xsang-OptiPlex-9020>
        <20220131150819.iuqlz3rz6q7cheap@wittgenstein>
        <Yff9+tIDAvYM5EO/@casper.infradead.org>
        <20220131153707.oe45h7tuci2cbfuv@wittgenstein>
        <YfgFeWbZPl+gAUYE@casper.infradead.org>
        <20220131161415.wlvtsd4ecehyg3x5@wittgenstein>
        <20220131171344.77iifun5wdilbqdz@wittgenstein>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 31 Jan 2022 18:13:44 +0100 Christian Brauner <brauner@kernel.org> wrote:

> > in other words, the changes that you see CMD_ARGS[0] == NULL for
> > execveat() seem higher than for path-based exec.
> > 
> > To counter that we should probably at least update the execveat()
> > manpage with a recommendation what CMD_ARGS[0] should be set to if it
> > isn't allowed to be set to NULL anymore. This is why was asking what
> > argv[0] is supposed to be if the binary doesn't take any arguments.
> 
> Sent a fix to our fstests now replacing the argv[0] as NULL with "".

As we hit this check so quickly, I'm thinking that Ariadne's patch
"fs/exec: require argv[0] presence in do_execveat_common()" (which
added the check) isn't something we'll be able to merge into mainline?
