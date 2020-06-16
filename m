Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8951FAAF3
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 10:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgFPITJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 04:19:09 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2311 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726064AbgFPITJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 04:19:09 -0400
Received: from lhreml710-chm.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id 8494228CB8606B535B20;
        Tue, 16 Jun 2020 09:19:05 +0100 (IST)
Received: from localhost (10.52.122.153) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Tue, 16 Jun
 2020 09:19:05 +0100
Date:   Tue, 16 Jun 2020 09:18:16 +0100
From:   Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To:     Pavel Machek <pavel@denx.de>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Mathieu Othacehe <m.othacehe@gmail.com>
Subject: Re: [PATCH 4.19 11/25] iio: vcnl4000: Fix i2c swapped word reading.
Message-ID: <20200616091816.00004ac9@Huawei.com>
In-Reply-To: <20200615133018.GA18126@duo.ucw.cz>
References: <20200609174048.576094775@linuxfoundation.org>
        <20200609174049.916148213@linuxfoundation.org>
        <20200615133018.GA18126@duo.ucw.cz>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.52.122.153]
X-ClientProxiedBy: lhreml711-chm.china.huawei.com (10.201.108.62) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 15 Jun 2020 15:30:18 +0200
Pavel Machek <pavel@denx.de> wrote:

> Hi!
> 
> > From: Mathieu Othacehe <m.othacehe@gmail.com>
> > 
> > commit 18dfb5326370991c81a6d1ed6d1aeee055cb8c05 upstream.
> > 
> > The bytes returned by the i2c reading need to be swapped
> > unconditionally. Otherwise, on be16 platforms, an incorrect value will be
> > returned.
> > 
> > Taking the slow path via next merge window as its been around a while
> > and we have a patch set dependent on this which would be held up.  
> 
> Is there some explanation how this is correct Somewhere? I assume i2c
> hardware has fixed endianity (not depending on CPU), so unconditional
> swapping will cause problems either on le or on be machines...?
> 

Hmm, this isn't introducing a bug, but looking again, it appears
that the original code was fine as well..

smbus/I2C has a fixed ordering on the wire (when people actually obey the spec).
So when an i2c_smbus_read_word_data call is made, the drivers / subsystem
assume that ordering an provide the data in CPU endian order.

Unfortunately a reasonable set of devices provide data in the opposite
order from that required by the i2c spec.  Thus it needs to be unconditionally
swapped to put it back into the correct order.
i2c_smbus_read_word_data_swapped does that for us.

Now the reason it worked before was this was previously doing a
block read rather than a word read. i2c_smbus_read_i2c_block_data
which is just reading a bunch of bytes rather than doing a word read.

So this is a false positive as a fix.  Sorry about that.
Conversely it shouldn't break anything.

Looking back at the history, what happened was that up to v5 of this patchset
factored out the reads, but whilst doing that converted them to
i2c_smbus_read_word_data with a be16_to_cpu call which was buggy and
picked up in review.  Hence confusion occurred and I guess my eyes saw
what they expected to see once the fix was pulled to the front of the series.

Thanks,

Jonathan



> Best regards,
> 								Pavel


