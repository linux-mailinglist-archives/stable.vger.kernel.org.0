Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24E27640BFD
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 18:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232839AbiLBRUp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 12:20:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234344AbiLBRU3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 12:20:29 -0500
Received: from smtp-out-07.comm2000.it (smtp-out-07.comm2000.it [212.97.32.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B776DEC824
        for <stable@vger.kernel.org>; Fri,  2 Dec 2022 09:20:28 -0800 (PST)
Received: from francesco-nb.int.toradex.com (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: francesco@dolcini.it)
        by smtp-out-07.comm2000.it (Postfix) with ESMTPSA id C3F513C31E4;
        Fri,  2 Dec 2022 18:20:22 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mailserver.it;
        s=mailsrv; t=1670001627;
        bh=cH5MF3icabPo56tRMEaFmIjjcbufvHO2gDgZKmAPA40=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=WOXGC40yBg1RGHn0TkZukuO+oObGCeWvEZufmL/y1R9MkQVnSELBUvHi1GOkN1TTJ
         WHsnAnAPrHuGtnn73gg8267nxdrTl63oOX96rZgYp6VHy7ZF18fvorhleZO1anDONp
         vCcocUxN53If5kyWtS+pma3Jxu4Vn3QjEXdlXXuvimBwlmYpvZb3FaZiN6/6fG6oXS
         nNjWbASVZ5Zb1f+MvO0I7EEt8ndd/LxYvO1m+OiHwa/dwJdlyPo006b+OW2Wgzr13Y
         Ge93k29r56VwX4VjKDVibsB75025uvbOjwk6HxsHPi16w2VZikBoamXgaQNWpafMBo
         ZEzwwX106228w==
Date:   Fri, 2 Dec 2022 18:20:02 +0100
From:   Francesco Dolcini <francesco@dolcini.it>
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Marek Vasut <marex@denx.de>,
        Francesco Dolcini <francesco@dolcini.it>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-mtd@lists.infradead.org,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        u-boot@lists.denx.de
Subject: Re: [PATCH v1] mtd: parsers: ofpart: Fix parsing when size-cells is 0
Message-ID: <Y4ozwovVIVhQHHkn@francesco-nb.int.toradex.com>
References: <Y4nSXQirO2N5IRfu@francesco-nb.int.toradex.com>
 <20221202115327.4475d3a2@xps-13>
 <Y4ngOaKq224LIpQc@francesco-nb.int.toradex.com>
 <20221202150556.14c5ae43@xps-13>
 <2b6fc52d-60b9-d0f4-ab91-4cf7a8095999@denx.de>
 <20221202160030.1b8d0b8a@xps-13>
 <223b7a4e-3aff-8070-7387-c77d2ded1dd6@denx.de>
 <20221202164904.08d750df@xps-13>
 <0503c46d-c385-74f5-f762-51d87a5ebaff@denx.de>
 <20221202174255.2c1cb2ff@xps-13>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221202174255.2c1cb2ff@xps-13>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 02, 2022 at 05:42:55PM +0100, Miquel Raynal wrote:
> Please also do it with the NAND chip described. If, when the NAND chip
> is described U-Boot tries to create partitions in the controller node,
> then the situation is even worse than I thought. But I believe

It's like that for U-Boot older than v2022.04 ... and IMO we cannot
ignore it.

Said that from the code U-Boot looks into a `partition{}` node only as a
direct child of the nand-controller, if there is a nand-chip in between
the nand-controller{} and the partitions{} it will just ignore it.

I could try to see what it is doing exactly, but I would need a little
bit more time, I just tried changing the DTS as wrote I got a non
bootable system.

Francesco

