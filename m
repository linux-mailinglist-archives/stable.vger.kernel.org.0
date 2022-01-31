Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6BD4A4AB3
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 16:37:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378916AbiAaPhQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 10:37:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376980AbiAaPhP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 10:37:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A70E0C061714;
        Mon, 31 Jan 2022 07:37:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52F27B82B51;
        Mon, 31 Jan 2022 15:37:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 125E3C340E8;
        Mon, 31 Jan 2022 15:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643643433;
        bh=n4pF0WTD8mzI8jApP59+6mO09uKqNqOupqmX+4f7jRk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QO8bd6YwcVynrWLeUHJiup6FETqxBrt5l8FJYwCvJs/JayrA0saN0XoC2+Yi4iOeb
         DnE+nmh6kh0XRjoqhy7B/yMAkmIZRcODgKjW2wcsOluZkn0tPXFfMePt1lZAMke6NL
         Kp9NuRE7JWzvN9/n6wSEZAOTfXcfsUZrDmTqwJidpsWC4365LQzisynhfF2+0bjd9X
         wdGeyI5gtwiMDs+jRdPq/DBG4vRKcN1JSHQRalDJcmVshoYq0d1uKiZtnLC9RtJdXq
         CgTYbUbzZI1e677E4tEko0HGJHCR856BNRlgglATA6+ZBd4SC2GWyTchpzPy7W+30T
         SpEc1n09nuJTw==
Date:   Mon, 31 Jan 2022 16:37:07 +0100
From:   Christian Brauner <brauner@kernel.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     kernel test robot <oliver.sang@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Ariadne Conill <ariadne@dereferenced.org>,
        0day robot <lkp@intel.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Rich Felker <dalias@libc.org>,
        Eric Biederman <ebiederm@xmission.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, lkp@lists.01.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org
Subject: Re: [fs/exec]  80bd5afdd8: xfstests.generic.633.fail
Message-ID: <20220131153707.oe45h7tuci2cbfuv@wittgenstein>
References: <20220127000724.15106-1-ariadne@dereferenced.org>
 <20220131144352.GE16385@xsang-OptiPlex-9020>
 <20220131150819.iuqlz3rz6q7cheap@wittgenstein>
 <Yff9+tIDAvYM5EO/@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Yff9+tIDAvYM5EO/@casper.infradead.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 31, 2022 at 03:19:22PM +0000, Matthew Wilcox wrote:
> On Mon, Jan 31, 2022 at 04:08:19PM +0100, Christian Brauner wrote:
> > On Mon, Jan 31, 2022 at 10:43:52PM +0800, kernel test robot wrote:
> > I can fix this rather simply in our upstream fstests with:
> > 
> > static char *argv[] = {
> > 	"",
> > };
> > 
> > I guess.
> > 
> > But doesn't
> > 
> > static char *argv[] = {
> > 	NULL,
> > };
> > 
> > seem something that should work especially with execveat()?
> 
> The problem is that the exec'ed program sees an argc of 0, which is the
> problem we're trying to work around in the kernel (instead of leaving
> it to ld.so to fix for suid programs).

Ok, just seems a bit more intuitive for path-based exec than for
fd-based execveat().

What's argv[0] supposed to contain in these cases?

1. execveat(fd, NULL, ..., AT_EMPTY_PATH)
2. execveat(fd, "my-file", ..., )

"" in both 1. and 2.?
"" in 1. and "my-file" in 2.?
