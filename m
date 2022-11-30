Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0A4A63D06A
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 09:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234714AbiK3IY1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 03:24:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234727AbiK3IYS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 03:24:18 -0500
Received: from mail-40138.protonmail.ch (mail-40138.protonmail.ch [185.70.40.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03A5E5EF87
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 00:23:54 -0800 (PST)
Date:   Wed, 30 Nov 2022 08:23:45 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail3; t=1669796632; x=1670055832;
        bh=I7m6wyzUo8clUZZYuPk8d/CuUvw5Xy7vdm3xjSe8t9A=;
        h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
         Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID:BIMI-Selector;
        b=J3KOjreEcuXtoq0+zqZJP6AShHJvyFutFl6n+2jiCNTDi9tkzOSqE27P+CsbV/211
         Rl3afCtUs0cxtvZxb9fu0QxDVGQaELEDLf54kNY2PcrfGcNJK63B8hvoJK+nQMT4Yp
         LNN/zQAqPRKngedEvL5kLRzzBoRdOQXz0vNnWFm8fkPf+qkS8ahtPip9rfZpMhF5en
         +Xi3b9Whb39x2369JbcYfeOz3294HMn45ZboROm3yi/d0HJ94yC4hvyBHjXoh8lv31
         KNkKeoqNTdul9OsWHbJZcvyIbr7Y4Wkjw8wQu4ABZhlV+jzjwsxWwiY5z4ZwYoqm3S
         fsRr/FlHCShaQ==
To:     Greg KH <gregkh@linuxfoundation.org>
From:   hinxx <hinxx@protonmail.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: sendfile(2) use with a char driver
Message-ID: <bmwBDL_gaUs_XSqmW_Mt6wo8aH1o9pZiuDSZVjAwNtrs8MMiEJobIQThsEVzynHtlSMepyYFOa06lKL_2tORLdZN31sWcld4Zmo-gpjhSy8=@protonmail.com>
In-Reply-To: <Y4cAn1foct0ItDzK@kroah.com>
References: <bb1-8NcxtVn8HSt49oYW5HaHrKdOa814M4_SnZAqAKxacGs9rbrHsadsdzZIDBaZ-w4Ki2H2InCY83bq0uBzOkj23YtHz3hYfqOFPKL87F0=@protonmail.com> <Y4cAn1foct0ItDzK@kroah.com>
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
On Wednesday, November 30th, 2022 at 8:05 AM, Greg KH <gregkh@linuxfoundati=
on.org> wrote:


> On Tue, Nov 29, 2022 at 09:15:24PM +0000, hinxx wrote:
>=20
> > I'm looking to use a sendfile(2) with a Xilinx XDMA kernel driver in or=
der to move data from a PCIe board with Xilinx FPGA to the network card wit=
h "zero-copy".
> >=20
> > Currently I'm getting EINVAL return status from sendfile(2) when provid=
ing opened XDMA device file descriptor as input fd.
> >=20
> > The device driver provides a character device that can be mmap'ed.
> >=20
> > There seem to be other restrictions. Can anyone provide insight on what=
 would be needed to make this work?
>=20
>=20
> Please contact the authors of your kernel driver, they can answer this
> best.
>=20

That would make sense, sadly they are MIA on their github repo engagement.

But in general, if I write a PCIe, DMA capable char device, what is the gen=
eral guidance on what it takes to support splice/sendfile from a char devic=
e driver? Maybe there is an existing one in the kernel I could look at?

Is it even something worth pursuing? This line make me think it might not w=
ork for char devices https://elixir.bootlin.com/linux/v5.19.17/source/fs/sp=
lice.c#L827. Is going for block device the only way that such device driver=
 can work with the sendfile?

Thanks! //hinko
