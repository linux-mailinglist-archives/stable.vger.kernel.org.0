Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4A832B5F1A
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 13:30:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbgKQM36 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 17 Nov 2020 07:29:58 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2116 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgKQM36 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Nov 2020 07:29:58 -0500
Received: from fraeml702-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Cb4w04p1dz67F1g;
        Tue, 17 Nov 2020 20:27:44 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml702-chm.china.huawei.com (10.206.15.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Tue, 17 Nov 2020 13:29:55 +0100
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.1913.007;
 Tue, 17 Nov 2020 13:29:55 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC:     Mimi Zohar <zohar@linux.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Silviu Vlasceanu <Silviu.Vlasceanu@huawei.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: RE: [RESEND][PATCH] ima: Set and clear FMODE_CAN_READ in
 ima_calc_file_hash()
Thread-Topic: [RESEND][PATCH] ima: Set and clear FMODE_CAN_READ in
 ima_calc_file_hash()
Thread-Index: AQHWuZM+vbqfejrqe02000rC0h3xoqnHabyAgAMLzKCAAG/IAIAABvEAgAAOKACAAAjEgIABPphg
Date:   Tue, 17 Nov 2020 12:29:55 +0000
Message-ID: <945773097832444ca31847c830b0053c@huawei.com>
References: <20201113080132.16591-1-roberto.sassu@huawei.com>
 <20201114111057.GA16415@infradead.org>
 <0fd0fb3360194d909ba48f13220f9302@huawei.com>
 <20201116162202.GA15010@infradead.org>
 <c556508437ffc10d3873fe25cbbba3484ca574df.camel@linux.ibm.com>
 <CAHk-=wiso=-Fhe2m042CfBNUGhoVB1Pry14DF64uUgztHVOW0g@mail.gmail.com>
 <20201116180855.GX3576660@ZenIV.linux.org.uk>
In-Reply-To: <20201116180855.GX3576660@ZenIV.linux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.220.96.108]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> From: Al Viro [mailto:viro@ftp.linux.org.uk] On Behalf Of Al Viro
> Sent: Monday, November 16, 2020 7:09 PM
> On Mon, Nov 16, 2020 at 09:37:32AM -0800, Linus Torvalds wrote:
> > On Mon, Nov 16, 2020 at 8:47 AM Mimi Zohar <zohar@linux.ibm.com>
> wrote:
> > >
> > > This discussion seems to be going down the path of requiring an IMA
> > > filesystem hook for reading the file, again.  That solution was
> > > rejected, not by me.  What is new this time?
> >
> > You can't read a non-read-opened file. Not even IMA can.
> >
> > So don't do that then.
> >
> > IMA is doing something wrong. Why would you ever read a file that can't
> be read?
> >
> > Fix whatever "open" function instead of trying to work around the fact
> > that you opened it wrong.
> 
> IMA pulls that crap on _every_ open(2), including O_WRONLY.  As far as I'm
> concerned, the only sane answer is not enabling that thing on your builds;
> they are deeply special and I hadn't been able to reason with them no
> matter how much I tried ;-/

A file-based protection mechanism against offline attacks would require
to verify the current HMAC also before writing and to update the HMAC
after the write.

One of the reasons why dentry_open() cannot be used and IMA switches
to the old method of changing the mode of the current file descriptor is
that the current process does not have enough privileges to do the
operation.

If we find a way to read the file that always works, without reducing the
security, the old method can be removed.

Roberto

HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
Managing Director: Li Peng, Li Jian, Shi Yanli
