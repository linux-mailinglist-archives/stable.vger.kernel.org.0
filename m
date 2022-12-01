Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F62163EC00
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 10:08:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbiLAJIi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 04:08:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiLAJIi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 04:08:38 -0500
Received: from mail-40132.protonmail.ch (mail-40132.protonmail.ch [185.70.40.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0337A5C0CE
        for <stable@vger.kernel.org>; Thu,  1 Dec 2022 01:08:36 -0800 (PST)
Date:   Thu, 01 Dec 2022 09:08:27 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail3; t=1669885714; x=1670144914;
        bh=iL5vmRtyChP0m8kkYMbuJOWuRRZYZLSWvS6t+Q6L9+Q=;
        h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
         Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID:BIMI-Selector;
        b=tZkMy6Zmar26XuHV7EpacjElUdulxkJt3nSN0IsoXI8D+HQTpNNV6YAB3zl1FeOS2
         uylxjzAniUR4THve+zR9k5y9QakDaDeL95eCFyqJ3PhIMjaJte+K6FqfHnyiaWDBfM
         caO3hTqGRxUtVbQV8MKem29RjVfiWYDgIJXTMYrWuV44AAuhCbeLsBS5m6NZOb8E+R
         +x7vjP09VELrMx5GHJpWbhbG5tNbtpJKDfU2886tDCG/W8KKGPMSx46/Hi86pPsCt+
         pWiHHz50HxjtRJSqAFad+SgicAmdQxqjeZoba87I06OSVDaktoRyNqQXKwoDC4x1Lh
         et1nvTQmOOPHw==
To:     Greg KH <gregkh@linuxfoundation.org>
From:   hinxx <hinxx@protonmail.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: sendfile(2) use with a char driver
Message-ID: <6ZmbsuZEj6y7IRkPIzEouIl5ZnBP6uAdlUpdODJRW-oxQYZvQFL8pDZmg8eKm2y3_3B28xk_ii34yUc9VbW0isBJVDgXf6klMqEs9uzj6ck=@protonmail.com>
In-Reply-To: <Y4c0/WBPL72Czwi+@kroah.com>
References: <bb1-8NcxtVn8HSt49oYW5HaHrKdOa814M4_SnZAqAKxacGs9rbrHsadsdzZIDBaZ-w4Ki2H2InCY83bq0uBzOkj23YtHz3hYfqOFPKL87F0=@protonmail.com> <Y4cAn1foct0ItDzK@kroah.com> <bmwBDL_gaUs_XSqmW_Mt6wo8aH1o9pZiuDSZVjAwNtrs8MMiEJobIQThsEVzynHtlSMepyYFOa06lKL_2tORLdZN31sWcld4Zmo-gpjhSy8=@protonmail.com> <Y4c0/WBPL72Czwi+@kroah.com>
Feedback-ID: 7622358:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org






Sent with Proton Mail secure email.

------- Original Message -------
On Wednesday, November 30th, 2022 at 11:48 AM, Greg KH <gregkh@linuxfoundat=
ion.org> wrote:


> On Wed, Nov 30, 2022 at 08:23:45AM +0000, hinxx wrote:
>=20
> > Sent with Proton Mail secure email.
> >=20
> > ------- Original Message -------
> > On Wednesday, November 30th, 2022 at 8:05 AM, Greg KH gregkh@linuxfound=
ation.org wrote:
> >=20
> > > On Tue, Nov 29, 2022 at 09:15:24PM +0000, hinxx wrote:
> > >=20
> > > > I'm looking to use a sendfile(2) with a Xilinx XDMA kernel driver i=
n order to move data from a PCIe board with Xilinx FPGA to the network card=
 with "zero-copy".
> > > >=20
> > > > Currently I'm getting EINVAL return status from sendfile(2) when pr=
oviding opened XDMA device file descriptor as input fd.
> > > >=20
> > > > The device driver provides a character device that can be mmap'ed.
> > > >=20
> > > > There seem to be other restrictions. Can anyone provide insight on =
what would be needed to make this work?
> > >=20
> > > Please contact the authors of your kernel driver, they can answer thi=
s
> > > best.
> >=20
> > That would make sense, sadly they are MIA on their github repo engageme=
nt.
>=20
>=20
> Have a link to that repo? Again, they are the only ones that can
> resolve this, or you can modify the code to support this.
>=20

Thank you for your time Greg!

I'm trying to understand the concepts behind the sendfile and modify the dr=
ivers myself.

Here is the Xilinx XDMA driver repo:

https://github.com/Xilinx/dma_ip_drivers/tree/master/XDMA/linux-kernel

A side note: As I noted earlier, I tested XDMA that has mmap()'ed PCIe regi=
ster space (16 MB size) that the driver provides, just to see if it works. =
I would need the actual data channel, currently read() based to support sen=
dfile.

I'm also looking to have the same sendfile support for this driver, too, wh=
ich is also targeting similar hardware:

https://github.com/icshwi/tsc/tree/master/driver

I'm working with hardware / FPGA firmware that utilizes one or the other ke=
rnel driver.


> > But in general, if I write a PCIe, DMA capable char device, what is the=
 general guidance on what it takes to support splice/sendfile from a char d=
evice driver? Maybe there is an existing one in the kernel I could look at?
> >=20
> > Is it even something worth pursuing? This line make me think it might n=
ot work for char devices https://elixir.bootlin.com/linux/v5.19.17/source/f=
s/splice.c#L827. Is going for block device the only way that such device dr=
iver can work with the sendfile?
>=20
>=20
> Step back and ask yourself why you want to try to do this first? Are
> you sure the slowdown of a char driver is the copying of the data?
> Usually the hardware is the bottleneck, not the kernel code.

The hardware that these drivers work with are usually able to deliver data =
at a very high rate. The hardware contains 2/4 GB of DDR3/4 memory where th=
e FPGA firmware stores the digitized analog signal as "samples". These samp=
les would then be transferred to the CPU for processing, or in case of offl=
ine processing, shipped out to the network as-is. The idea is to minimize t=
he CPU involvement in the latter case and my assumption is that would be ac=
hieved using sendfile/splice. I'm aware that network bandwidth is going to =
be the bottleneck later; it is about not using the CPU cycles for filling t=
he NIC buffers.

Here is a note from the README of XDMA:

=09=09Maximum data rate for x8 Gen3 is 8Gbytes/s, so for a x8Gen3
=09=09design value of 0.81 data rate is 0.81*8 =3D 6.48Gbytes/s.
=09=09Maximum data rate for x16 Gen3 is 16Gbytes/s, so for a x16Gen3
=09=09design value of 0.78 data rate is 0.78*16 =3D 12.48Gbytes/s.

I've seen x4 Gen3 link ~3.8GB/s rates in practice on the hardware I have at=
 hand.

>=20
> Anyway, this is way off-topic for the stable@vger.kernel.org mailing
> list, please work on this on a subsystem-specific list.

No problem. Is the PCI mailing list where this discussion should continue?

Thanks! //hinko

>=20
> good luck!
>=20
> greg k-h
