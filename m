Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 190BC2B4B85
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 17:45:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732273AbgKPQoA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 11:44:00 -0500
Received: from mail-40134.protonmail.ch ([185.70.40.134]:58082 "EHLO
        mail-40134.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732244AbgKPQoA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Nov 2020 11:44:00 -0500
Date:   Mon, 16 Nov 2020 16:43:49 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1605545037; bh=Qd/V7/auXUafl/mmu4wV/5UTH2jsCO9yUBd0yO33sBM=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=VlQUg8MWVCwoGEChmrB66g+17zZvHCemdWx/S3I3dZFwjlupgMZI3jfOCHeBcJ2fl
         dd4Fh90TmTDAWerIDzrDeHx+Jneyc124zM30lHxeixHJAN4MY35JfQTkX9FXZtm2tI
         Xgr+aNXYuNKTZ3q1u6PSPne2RTXMGVDtmZzDSN5PLhqFOqB1/xt3jsw0ApiRWTD7We
         QPMSv8e0GGQ0sApM1RHEblmUgPfOfftZ7RVvtm8y96lM7Pp9v9cbMQz6RVGIm3gu4+
         3YbIqss9xs/X0l06iiAL9uQKjrO9scMH86+shuElONyRLna8spU4YfHlJQdkdRMNBl
         Qkaz6MTQWfGcQ==
To:     Christoph Hellwig <hch@infradead.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Amit Shah <amit@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnaud Pouliquen <arnaud.pouliquen@st.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        linux-remoteproc@vger.kernel.org, Suman Anna <s-anna@ti.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH virtio] virtio: virtio_console: fix DMA memory allocation for rproc serial
Message-ID: <g6x4jAuAkaB51kwCXU4GlGyCGilkEvRhguvwfPkrA@cp3-web-024.plabs.ch>
In-Reply-To: <20201116162744.GA16619@infradead.org>
References: <AOKowLclCbOCKxyiJ71WeNyuAAj2q8EUtxrXbyky5E@cp7-web-042.plabs.ch> <20201116091950.GA30524@infradead.org> <20201116045127-mutt-send-email-mst@kernel.org> <20201116162744.GA16619@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@infradead.org>
Date: Mon, 16 Nov 2020 16:27:44 +0000

> On Mon, Nov 16, 2020 at 04:51:49AM -0500, Michael S. Tsirkin wrote:
>> On Mon, Nov 16, 2020 at 09:19:50AM +0000, Christoph Hellwig wrote:
>>> I just noticed this showing up in Linus' tree and I'm not happy.
>>>
>>> This whole model of the DMA subdevices in remoteproc is simply broken.
>>>
>>> We really need to change the virtio code pass an expicit DMA device (
>>> similar to what e.g. the USB and RDMA code does),
>>
>> Could you point me at an example or two please?
>
> Take a look at the ib_dma_* helper in include/rdma/ib_verbs.h and
> dma_device member in struct ib_device for the best example.

Oh, best example indeed. I did really love these helpers and kinda
wish there were such for Ethernet and wireless networking. They'd
allow to keep the code more readable and clean and prevent from
several sorts of silly mistakes.

This could be done in e.g. 4 steps:
 - introduce such helpers for netdev/mac80211;
 - add checkpatch warnings to discourage usage of old methods like
   SET_NETDEV_DEV() and direct dereferencing of netdev->dev.parent;
 - slowly convert existing drivers to the new model;
 - remove the old way entirely along with checkpatch remnants.

I could take this if there'll be enough votes :)

Al

