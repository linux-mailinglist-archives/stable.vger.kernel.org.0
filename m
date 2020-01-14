Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEAF613A057
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 05:57:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728680AbgANE5k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jan 2020 23:57:40 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:33430 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727331AbgANE5k (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jan 2020 23:57:40 -0500
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1irEGj-007m9W-2q; Tue, 14 Jan 2020 04:57:33 +0000
Date:   Tue, 14 Jan 2020 04:57:33 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Aleksa Sarai <cyphar@cyphar.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Eric Biederman <ebiederm@xmission.com>,
        stable <stable@vger.kernel.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Serge Hallyn <serge@hallyn.com>, dev@opencontainers.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ian Kent <raven@themaw.net>
Subject: Re: [PATCH RFC 0/1] mount: universally disallow mounting over
 symlinks
Message-ID: <20200114045733.GW8904@ZenIV.linux.org.uk>
References: <20200101004324.GA11269@ZenIV.linux.org.uk>
 <20200101005446.GH4203@ZenIV.linux.org.uk>
 <20200101030815.GA17593@ZenIV.linux.org.uk>
 <20200101144407.ugjwzk7zxrucaa6a@yavin.dot.cyphar.com>
 <20200101234009.GB8904@ZenIV.linux.org.uk>
 <20200102035920.dsycgxnb6ba2jhz2@yavin.dot.cyphar.com>
 <20200103014901.GC8904@ZenIV.linux.org.uk>
 <20200108031314.GE8904@ZenIV.linux.org.uk>
 <CAHk-=wgQ3yOBuK8mxpnntD8cfX-+10ba81f86BYg8MhvwpvOMg@mail.gmail.com>
 <20200110210719.ktg3l2kwjrdutlh6@yavin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200110210719.ktg3l2kwjrdutlh6@yavin>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 11, 2020 at 08:07:19AM +1100, Aleksa Sarai wrote:

> If I'm understanding this proposal correctly, this would be a problem
> for the libpathrs use-case -- if this is done then there's no way to
> avoid a TOCTOU with someone mounting and the userspace program checking
> whether something is a mountpoint (unless you have Linux >5.6 and
> RESOLVE_NO_XDEV). Today, you can (in theory) do it with MNT_EXPIRE:
> 
>   1. Open the candidate directory.
>   2. umount2(MNT_EXPIRE) the fd.
>     * -EINVAL means it wasn't a mountpoint when we got the fd, and the
> 	  fd is a stable handle to the underlying directory.
> 	* -EAGAIN or -EBUSY means that it was a mountpoint or became a
> 	  mountpoint after the fd was opened (we don't care about that, but
> 	  fail-safe is better here).
>   3. Use the fd from (1) for all operations.

... except that foo/../bar *WILL* cross into the covering mount, on any
kernel that supports ...at(2) at all, so I would be very cautious about
any kind "hardening" claims in that case.

I'm not sure about Linus' proposal - it looks rather convoluted and we
get a hard to describe twist of semantics in an area (procfs symlinks
vs. mount traversal) on top of everything else in there...

Anyway, a couple of questions:

1) do you see any problems on your testcases with the current #fixes?
That's commit 7a955b7363b8 as branch tip.

2) do you have any updates you would like to fold into stuff in
#work.openat2?  Right now I have a local variant of #work.namei (with
fairly cosmetical change compared to vfs.git one) that merges clean
with #work.openat2; I would like to do any updates/fold-ins/etc.
of #work.openat2 *before* doing a merge and continuing to work on
top of the merge results...
