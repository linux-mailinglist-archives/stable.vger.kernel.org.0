Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0168964277E
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 12:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbiLELaZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 06:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbiLELaY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 06:30:24 -0500
Received: from smtp-out-12.comm2000.it (smtp-out-12.comm2000.it [212.97.32.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BB8310569
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 03:30:20 -0800 (PST)
Received: from francesco-nb.int.toradex.com (31-10-206-125.static.upc.ch [31.10.206.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: francesco@dolcini.it)
        by smtp-out-12.comm2000.it (Postfix) with ESMTPSA id 523F6BA1E14;
        Mon,  5 Dec 2022 12:30:18 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mailserver.it;
        s=mailsrv; t=1670239818;
        bh=Kq+5kUwgPfTpYZtS89P4d7VkQaEGPlQnylqnIFbeT74=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=g/WRje8fj6jvfHuYkT8TUDWTt85/46AhNKmeCUp8nZyEtUvtKV5018Aumnm61Iv6F
         4ZdTgwqueynN39EvnMzDOaDU+UvhCd5ENg5dhJKSWysFf0/OrLZkoFcEoxzv6R4NKP
         /tJ9SA63VGqELBmJ3M8/mRF3pHKbtEQlgqK4RikgS+JvwuYZaUDx5sSmTtbLdZhKil
         bbUAUhg6SyKGDLkS81DNPpNQc52uzJE0otpXUjSdXf7vt04Y98Sd5RlMDu8wGXD1Yy
         +hRORK7IwWExhHGCbI2RrNIue/sQhH8i5GzS9BIJjthj1FkgeLqWKfBO+p/rCCEOSC
         hyfYTxSo49gaw==
Date:   Mon, 5 Dec 2022 12:30:16 +0100
From:   Francesco Dolcini <francesco@dolcini.it>
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Marek Vasut <marex@denx.de>
Cc:     Francesco Dolcini <francesco@dolcini.it>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-mtd@lists.infradead.org,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        u-boot@lists.denx.de
Subject: Re: [PATCH v1] mtd: parsers: ofpart: Fix parsing when size-cells is 0
Message-ID: <Y43WSCsvfnfbcMPQ@francesco-nb.int.toradex.com>
References: <20221202115327.4475d3a2@xps-13>
 <Y4ngOaKq224LIpQc@francesco-nb.int.toradex.com>
 <20221202150556.14c5ae43@xps-13>
 <2b6fc52d-60b9-d0f4-ab91-4cf7a8095999@denx.de>
 <20221202160030.1b8d0b8a@xps-13>
 <223b7a4e-3aff-8070-7387-c77d2ded1dd6@denx.de>
 <20221202164904.08d750df@xps-13>
 <0503c46d-c385-74f5-f762-51d87a5ebaff@denx.de>
 <20221202174255.2c1cb2ff@xps-13>
 <Y4ozwovVIVhQHHkn@francesco-nb.int.toradex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4ozwovVIVhQHHkn@francesco-nb.int.toradex.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Miquel

On Fri, Dec 02, 2022 at 06:20:02PM +0100, Francesco Dolcini wrote:
> On Fri, Dec 02, 2022 at 05:42:55PM +0100, Miquel Raynal wrote:
> > Please also do it with the NAND chip described. If, when the NAND chip
> > is described U-Boot tries to create partitions in the controller node,
> > then the situation is even worse than I thought. But I believe
> 
> It's like that for U-Boot older than v2022.04 ... and IMO we cannot
> ignore it.
> 
> Said that from the code U-Boot looks into a `partition{}` node only as a
> direct child of the nand-controller, if there is a nand-chip in between
> the nand-controller{} and the partitions{} it will just ignore it.
> 
> I could try to see what it is doing exactly, but I would need a little
> bit more time, I just tried changing the DTS as wrote I got a non
> bootable system.

If I have a nand-chip { partitions {} } described in the dts U-Boot
(even the latest one) ignores it and generates the partition as child of
the nand controller, the linux parser however see that partitions{}
exists, even if empty, and ignore the partition directly defined as
child of the nand controller.

TL;DR: parser fails and boot fails according to that.

Francesco

