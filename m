Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5902B4EDF
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 19:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728858AbgKPSJS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 13:09:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728442AbgKPSJR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Nov 2020 13:09:17 -0500
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B73C0613CF;
        Mon, 16 Nov 2020 10:09:16 -0800 (PST)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1keivv-007Qye-IV; Mon, 16 Nov 2020 18:08:55 +0000
Date:   Mon, 16 Nov 2020 18:08:55 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
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
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [RESEND][PATCH] ima: Set and clear FMODE_CAN_READ in
 ima_calc_file_hash()
Message-ID: <20201116180855.GX3576660@ZenIV.linux.org.uk>
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
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 16, 2020 at 09:37:32AM -0800, Linus Torvalds wrote:
> On Mon, Nov 16, 2020 at 8:47 AM Mimi Zohar <zohar@linux.ibm.com> wrote:
> >
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

IMA pulls that crap on _every_ open(2), including O_WRONLY.  As far as I'm
concerned, the only sane answer is not enabling that thing on your builds;
they are deeply special and I hadn't been able to reason with them no
matter how much I tried ;-/
