Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 936E122AAAD
	for <lists+stable@lfdr.de>; Thu, 23 Jul 2020 10:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726025AbgGWIcl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jul 2020 04:32:41 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2512 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725846AbgGWIcl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jul 2020 04:32:41 -0400
Received: from lhreml710-chm.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id 55E98549604A8695FF83;
        Thu, 23 Jul 2020 09:32:39 +0100 (IST)
Received: from localhost (10.52.125.229) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Thu, 23 Jul
 2020 09:32:38 +0100
Date:   Thu, 23 Jul 2020 09:31:18 +0100
From:   Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To:     Pavel Machek <pavel@denx.de>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        "Lars-Peter Clausen" <lars@metafoo.de>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: Re: [PATCH 4.19 034/133] iio:humidity:hts221 Fix alignment and data
 leak issues
Message-ID: <20200723093118.00005572@Huawei.com>
In-Reply-To: <20200722112835.GB22052@duo.ucw.cz>
References: <20200720152803.732195882@linuxfoundation.org>
        <20200720152805.365344523@linuxfoundation.org>
        <20200722112835.GB22052@duo.ucw.cz>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.52.125.229]
X-ClientProxiedBy: lhreml725-chm.china.huawei.com (10.201.108.76) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 22 Jul 2020 13:28:35 +0200
Pavel Machek <pavel@denx.de> wrote:

> Hi!
> 
> > From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> > 
> > commit 5c49056ad9f3c786f7716da2dd47e4488fc6bd25 upstream.
> > 
> > One of a class of bugs pointed out by Lars in a recent review.
> > iio_push_to_buffers_with_timestamp assumes the buffer used is aligned
> > to the size of the timestamp (8 bytes).  This is not guaranteed in
> > this driver which uses an array of smaller elements on the stack.  
> 
> I don't see documentation explaining alignment issues with
> iio_push_to_buffers_with_timestamp(). Perhaps comment near that
> function should explain that?

Hi Pavel,

Agreed.  It's a subtle corner case (hence we missed it for years)
so absolutely needs documenting.  The nasty part is that we don't
control the expectations of the consumers who get the data from
that interface.  They may make the reasonable assumption
that they aren't getting unaligned data,  particularly given the
effort we go to in ensuring natural alignment of elements within
the buffer.  It's a moderately fast path so any tricks with realigning
the data aren't sensible either.

> 
> And as it seems to be common problem, perhaps
> iio_push_to_buffers_with_timestamp should check alignment of its
> arguments?

It should indeed check this.  But... The reality is that lots
of platforms are fine with the alignment not being enforced.
So far we have precisely one confirmed report of the issue.

Until we have fixed all the users I'm not keen to add a check
that will be seen to 'break' existing working systems.
It's taking a while to get all these reviewed so I'm picking them
up as they get sufficient eyes on them.  A few drivers are more
fiddly to do so we don't yet have patches on the list.

I was thinking to do the documentation update and a check enforcing
it in one go, but perhaps given the slow nature of getting all the
users fixed we should look to document now and enforce later?

Jonathan


> 
> Thanks,
> 								Pavel


