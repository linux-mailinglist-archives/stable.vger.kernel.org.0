Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC794A4AFC
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 16:51:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235351AbiAaPvj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 10:51:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379903AbiAaPvj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 10:51:39 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F87C061714;
        Mon, 31 Jan 2022 07:51:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jhKpcZkEDowSCd8hPiP4aOrjjBOOXWKUBDEZ4Umsnng=; b=ovC3C4cA6GsB7Jcp5zm/3ubOKO
        Wa9/sp7MaghHHz+SSng/nlpGk9Mc4DQkHSxMjKH3ajQr43FNVnP5btg07SOmzREk31vrplC2ltroF
        QtXnImYdOc3Q9mjAmuSSNOblBwKyqArsoLD8aI0nJ7Q08DEwSOMyPssK2+9fPQqbIRbPAaY1rcLEl
        eImwHgLXjz6VYbMjMQLCRrDR+3e7q4MTfuM/KjufxXHShHBHHbOcb/WwfdD+mQv+KDTSNorSsRdyz
        fqJlR7ssST58P/CvJnJJcs5D6woDyHLJO6ik3KwmCieDBOcRTg58vG3ysBmdZDaqu0ZbVKXKBe3j9
        qp84V1Fg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nEYxd-00A506-QH; Mon, 31 Jan 2022 15:51:21 +0000
Date:   Mon, 31 Jan 2022 15:51:21 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Christian Brauner <brauner@kernel.org>
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
Message-ID: <YfgFeWbZPl+gAUYE@casper.infradead.org>
References: <20220127000724.15106-1-ariadne@dereferenced.org>
 <20220131144352.GE16385@xsang-OptiPlex-9020>
 <20220131150819.iuqlz3rz6q7cheap@wittgenstein>
 <Yff9+tIDAvYM5EO/@casper.infradead.org>
 <20220131153707.oe45h7tuci2cbfuv@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220131153707.oe45h7tuci2cbfuv@wittgenstein>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 31, 2022 at 04:37:07PM +0100, Christian Brauner wrote:
> On Mon, Jan 31, 2022 at 03:19:22PM +0000, Matthew Wilcox wrote:
> > On Mon, Jan 31, 2022 at 04:08:19PM +0100, Christian Brauner wrote:
> > > On Mon, Jan 31, 2022 at 10:43:52PM +0800, kernel test robot wrote:
> > > I can fix this rather simply in our upstream fstests with:
> > > 
> > > static char *argv[] = {
> > > 	"",
> > > };
> > > 
> > > I guess.
> > > 
> > > But doesn't
> > > 
> > > static char *argv[] = {
> > > 	NULL,
> > > };
> > > 
> > > seem something that should work especially with execveat()?
> > 
> > The problem is that the exec'ed program sees an argc of 0, which is the
> > problem we're trying to work around in the kernel (instead of leaving
> > it to ld.so to fix for suid programs).
> 
> Ok, just seems a bit more intuitive for path-based exec than for
> fd-based execveat().
> 
> What's argv[0] supposed to contain in these cases?
> 
> 1. execveat(fd, NULL, ..., AT_EMPTY_PATH)
> 2. execveat(fd, "my-file", ..., )
> 
> "" in both 1. and 2.?
> "" in 1. and "my-file" in 2.?

You didn't specify argv for either of those, so I have no idea.
Programs shouldn't be assuming anything about argv[0]; it's purely
advisory.  Unfortunately, some of them do.  And some of them are suid.

