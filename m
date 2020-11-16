Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B9A02B4E03
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 18:48:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387441AbgKPRlh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 12:41:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387673AbgKPRle (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Nov 2020 12:41:34 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE7FFC0613CF;
        Mon, 16 Nov 2020 09:41:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jXhYiraeCvEjgtp4Al1Jja9wRZjk54jdQVNIIz1mtNI=; b=DJ4JRqLbCnxL7oV46eew1i513o
        cuizmUxtJNSsbEo/J7T6unlPPjbVcPfPHf7PEy6C4HL42PdN2meHxNJqdVEh9o6Qd5c3kGMsCRZPY
        7DgN1CTRMw9CX90r4EprheOKWoTjCkfD8FGZ/NxD+4ghMRRkbOJM/AFS6IKNsybRVRGEGzy7aA+a5
        IKdlZCwL79FzxVE6bFdihZ05OG5Ph3WDVHIV0JmRn6s2T95xG3usEQE8da8xbEyzqPe0E4Se596fY
        hPSJ/dXtrulN/kouNf7LnzZHhkhqTVzBc7IEPlnbRKoVclBnuq1pjPMlp68L1LoJhR5F9AzO93B/o
        cZTocpbg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1keiVL-0001Fe-6A; Mon, 16 Nov 2020 17:41:27 +0000
Date:   Mon, 16 Nov 2020 17:41:27 +0000
From:   Christoph Hellwig <hch@infradead.org>
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
Message-ID: <20201116174127.GA4578@infradead.org>
References: <20201113080132.16591-1-roberto.sassu@huawei.com>
 <20201114111057.GA16415@infradead.org>
 <0fd0fb3360194d909ba48f13220f9302@huawei.com>
 <20201116162202.GA15010@infradead.org>
 <c556508437ffc10d3873fe25cbbba3484ca574df.camel@linux.ibm.com>
 <CAHk-=wiso=-Fhe2m042CfBNUGhoVB1Pry14DF64uUgztHVOW0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wiso=-Fhe2m042CfBNUGhoVB1Pry14DF64uUgztHVOW0g@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 16, 2020 at 09:37:32AM -0800, Linus Torvalds wrote:
> > This discussion seems to be going down the path of requiring an IMA
> > filesystem hook for reading the file, again.  That solution was
> > rejected, not by me.  What is new this time?
> 
> You can't read a non-read-opened file. Not even IMA can.
> 
> So don't do that then.
> 
> IMA is doing something wrong. Why would you ever read a file that can't be read?
> 
> Fix whatever "open" function instead of trying to work around the fact
> that you opened it wrong.

The "issue" with IMA is that it uses security hooks to hook into the
VFS and then wants to read every file that gets opened on a real file
system to "measure" the contents vs a hash stashed away somewhere.
Which has always been rather sketchy.
