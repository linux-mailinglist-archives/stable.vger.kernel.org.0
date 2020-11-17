Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFD682B6DEC
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 19:55:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727160AbgKQSys (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 13:54:48 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:42166 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726812AbgKQSyr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Nov 2020 13:54:47 -0500
Received: from callcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 0AHIsPvi031521
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 13:54:25 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 276FF420107; Tue, 17 Nov 2020 13:54:25 -0500 (EST)
Date:   Tue, 17 Nov 2020 13:54:25 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Mimi Zohar <zohar@linux.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Silviu Vlasceanu <Silviu.Vlasceanu@huawei.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [RESEND][PATCH] ima: Set and clear FMODE_CAN_READ in
 ima_calc_file_hash()
Message-ID: <20201117185425.GG445084@mit.edu>
References: <20201113080132.16591-1-roberto.sassu@huawei.com>
 <20201114111057.GA16415@infradead.org>
 <0fd0fb3360194d909ba48f13220f9302@huawei.com>
 <20201116162202.GA15010@infradead.org>
 <c556508437ffc10d3873fe25cbbba3484ca574df.camel@linux.ibm.com>
 <CAHk-=wiso=-Fhe2m042CfBNUGhoVB1Pry14DF64uUgztHVOW0g@mail.gmail.com>
 <20201116174127.GA4578@infradead.org>
 <CAHk-=wjd0RNthZQTLVsnK_d9SFYH0rug2tkezLLB0J-YZzVC+Q@mail.gmail.com>
 <3f8cc7c9462353ac2eef58e39beee079bdd9c7b4.camel@linux.ibm.com>
 <CAHk-=wih-ibNUxeiKpuKrw3Rd2=QEAZ8zgRWt_CORAjbZykRWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wih-ibNUxeiKpuKrw3Rd2=QEAZ8zgRWt_CORAjbZykRWQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 17, 2020 at 10:23:58AM -0800, Linus Torvalds wrote:
> On Mon, Nov 16, 2020 at 10:35 AM Mimi Zohar <zohar@linux.ibm.com> wrote:
> >
> > We need to differentiate between signed files, which by definition are
> > immutable, and those that are mutable.  Appending to a mutable file,
> > for example, would result in the file hash not being updated.
> > Subsequent reads would fail.
> 
> Why would that require any reading of the file at all AT WRITE TIME?
> 
> Don't do it. Really.
> 
> When opening the file write-only, you just invalidate the hash. It
> doesn't matter anyway - you're only writing.
> 
> Later on, when reading, only at that point does the hash matter, and
> then you can do the verification.
> 
> Although honestly, I don't even see the point. You know the hash won't
> match, if you wrote to the file.

I think the use case the IMA folks might be thinking about is where
they want to validate the file at open time, *before* the userspace
application starts writing to the file, since there might be some
subtle attacks where Boris changes the first part of the file before
Alice appends "I agree" to said file.

Of course, Boris will be able to modify the file after Alice has
modified it, so it's a bit of a moot point, but one could imagine a
scenario where the file is modified while the system is not running
(via an evil hotel maid) and then after Alice modifies the file, of
*course* the hash will be invalid, so no one would notice.  A sane
application would have read the file to make sure it contained the
proper contents before appending "I agree" to said file, so it's a bit
of an esoteric point.

The other case I could imagine is if the file is marked execute-only,
without read access, and IMA wanted to be able to read the file to
check the hash.  But we already make an execption for allowing the
file to be read during page faults, so that's probably less
controversial.

						- Ted

