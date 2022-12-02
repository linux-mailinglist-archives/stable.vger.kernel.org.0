Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F23E4640706
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 13:43:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233496AbiLBMnf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 07:43:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233354AbiLBMne (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 07:43:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20194CBA52
        for <stable@vger.kernel.org>; Fri,  2 Dec 2022 04:43:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BA309B8214F
        for <stable@vger.kernel.org>; Fri,  2 Dec 2022 12:43:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEBE1C433D6;
        Fri,  2 Dec 2022 12:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669985011;
        bh=SlPWDsDwwQu2Oj8FLpJROoW39Zgawt2f5E5M5aku0BE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Jpy1DcdVemi6pmnKy8RCnvkm0is357EOivfdWR/gvZ6euYHvyFpUKK/umSAULfr4C
         Bhz15gdd9jivBlfjFlpoThRIpXN+W780s8/J08nb+hzyHNPu9TE/MXHUK0MpCrljCC
         +7HOSP9STmSd9NKyNMD2oTSFOrtipyBHVR23+HLc=
Date:   Fri, 2 Dec 2022 13:43:26 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Francesco Dolcini <francesco@dolcini.it>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-mtd@lists.infradead.org, Marek Vasut <marex@denx.de>,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH v1] mtd: parsers: ofpart: Fix parsing when size-cells is 0
Message-ID: <Y4ny7h5Q7pIpo8ZP@kroah.com>
References: <20221202071900.1143950-1-francesco@dolcini.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221202071900.1143950-1-francesco@dolcini.it>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 02, 2022 at 08:19:00AM +0100, Francesco Dolcini wrote:
> From: Francesco Dolcini <francesco.dolcini@toradex.com>
> 
> Add a fallback mechanism to handle the case in which #size-cells is set
> to <0>. According to the DT binding the nand controller node should have
> set it to 0 and this is not compatible with the legacy way of
> specifying partitions directly as child nodes of the nand-controller node.
> 
> This fixes a boot failure on colibri-imx7 and potentially other boards.
> 
> Cc: stable@vger.kernel.org
> Fixes: 753395ea1e45 ("ARM: dts: imx7: Fix NAND controller size-cells")
> Link: https://lore.kernel.org/all/Y4dgBTGNWpM6SQXI@francesco-nb.int.toradex.com/
> Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
> ---
>  drivers/mtd/parsers/ofpart_core.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
