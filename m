Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE4FD4AA8D6
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 13:48:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379859AbiBEMsl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 07:48:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233550AbiBEMsl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 07:48:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6E31C061346;
        Sat,  5 Feb 2022 04:48:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4205160E0B;
        Sat,  5 Feb 2022 12:48:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05748C340E8;
        Sat,  5 Feb 2022 12:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644065319;
        bh=EbzIvH3DHALdK99fPQJAohdRconWYIor1ltDGqBnVRw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W+49/S2/5xhBwjD6PUDX09s9GcXW04tsBQMAcwbIsujWRXLGA9KgeUZoYLBXlmmRP
         1Y7fYgPHuJj/ROUva7BhlgekQtl1SsS9D2QOEH/WoE49V4eUm9+mfG3XYVdLRqi4Qu
         EtR9gucwKYZPCer7jog6GohjOkKZV3TwpMJj6HhI=
Date:   Sat, 5 Feb 2022 13:48:36 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     Siarhei Volkau <lis8215@gmail.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>, linux-mips@vger.kernel.org,
        linux-clk@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 1/1] clk: jz4725b: fix mmc0 clock gating
Message-ID: <Yf5yJKWAfxfQUVHU@kroah.com>
References: <4FSS6R.0A48V2ZMZD7X1@crapouillou.net>
 <20220205094531.676371-1-lis8215@gmail.com>
 <20220205094531.676371-2-lis8215@gmail.com>
 <Yf5KlvxlRwM9JsZr@kroah.com>
 <FDZT6R.4ATV1Z4FNCP21@crapouillou.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <FDZT6R.4ATV1Z4FNCP21@crapouillou.net>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 05, 2022 at 12:15:15PM +0000, Paul Cercueil wrote:
> Hi Greg,
> 
> Le sam., févr. 5 2022 at 10:59:50 +0100, Greg KH
> <gregkh@linuxfoundation.org> a écrit :
> > On Sat, Feb 05, 2022 at 12:45:31PM +0300, Siarhei Volkau wrote:
> > >  The mmc0 clock gate bit was mistakenly assigned to "i2s" clock.
> > >  You can find that the same bit is assigned to "mmc0" too.
> > >  It leads to mmc0 hang for a long time after any sound activity
> > >  also it  prevented PM_SLEEP to work properly.
> > >  I guess it was introduced by copy-paste from jz4740 driver
> > >  where it is really controls I2S clock gate.
> > > 
> > >  Fixes: 226dfa4726eb ("clk: Add Ingenic jz4725b CGU driver")
> > >  Signed-off-by: Siarhei Volkau <lis8215@gmail.com>
> > >  Tested-by: Siarhei Volkau <lis8215@gmail.com>
> > >  Reviewed-by: Paul Cercueil <paul@crapouillou.net>
> > >  ---
> > >   drivers/clk/ingenic/jz4725b-cgu.c | 3 +--
> > >   1 file changed, 1 insertion(+), 2 deletions(-)
> > > 
> > >  diff --git a/drivers/clk/ingenic/jz4725b-cgu.c
> > > b/drivers/clk/ingenic/jz4725b-cgu.c
> > >  index 744d136..15d6179 100644
> > >  --- a/drivers/clk/ingenic/jz4725b-cgu.c
> > >  +++ b/drivers/clk/ingenic/jz4725b-cgu.c
> > >  @@ -139,11 +139,10 @@ static const struct ingenic_cgu_clk_info
> > > jz4725b_cgu_clocks[] = {
> > >   	},
> > > 
> > >   	[JZ4725B_CLK_I2S] = {
> > >  -		"i2s", CGU_CLK_MUX | CGU_CLK_DIV | CGU_CLK_GATE,
> > >  +		"i2s", CGU_CLK_MUX | CGU_CLK_DIV,
> > >   		.parents = { JZ4725B_CLK_EXT, JZ4725B_CLK_PLL_HALF, -1, -1 },
> > >   		.mux = { CGU_REG_CPCCR, 31, 1 },
> > >   		.div = { CGU_REG_I2SCDR, 0, 1, 9, -1, -1, -1 },
> > >  -		.gate = { CGU_REG_CLKGR, 6 },
> > >   	},
> > > 
> > >   	[JZ4725B_CLK_SPI] = {
> > >  --
> > >  2.35.1
> > > 
> > 
> > <formletter>
> > 
> > This is not the correct way to submit patches for inclusion in the
> > stable kernel tree.  Please read:
> > https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> > for how to do this properly.
> > 
> > </formletter>
> 
> What's wrong with this patch exactly? It looks good to me.

No "Cc: stable@..." in the signed-off-by area.

