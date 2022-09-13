Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB7A45B77D9
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 19:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233001AbiIMR06 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 13:26:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232935AbiIMR0Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 13:26:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4162BA3;
        Tue, 13 Sep 2022 09:14:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89D61614D6;
        Tue, 13 Sep 2022 16:14:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49678C433D6;
        Tue, 13 Sep 2022 16:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663085666;
        bh=O5FWm/fvscnNLel7Mxgy0y53/BSpvwI0+/0lt0IpNGk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zwDjLcTwKTimfwUklR7yj7HLTLXYgQQODOED5FFq4mjxQaE6RnqiN7jATzzoQ3lf8
         JP5TdPU+6lkGNCjrdqy6E4E+6OrWArhummy01XhM4P8J1JuoKaCYJqokn43+lN6ZFM
         tn797B72IBM5sBWboffhF0YvicO9EVu+iKSH1vRo=
Date:   Tue, 13 Sep 2022 18:14:49 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Conor.Dooley@microchip.com
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        geert@linux-m68k.org, krzysztof.kozlowski@canonical.com,
        palmer@rivosinc.com, sashal@kernel.org
Subject: Re: [PATCH 5.15 048/121] riscv: dts: microchip: mpfs: Fix reference
 clock node
Message-ID: <YyCseQzaLJBY6Hu5@kroah.com>
References: <20220913140357.323297659@linuxfoundation.org>
 <20220913140359.425823284@linuxfoundation.org>
 <f9be96f9-77fa-10fc-44cb-65d3a7fce57c@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f9be96f9-77fa-10fc-44cb-65d3a7fce57c@microchip.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 13, 2022 at 04:09:09PM +0000, Conor.Dooley@microchip.com wrote:
> On 13/09/2022 15:03, Greg Kroah-Hartman wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> > 
> > From: Geert Uytterhoeven <geert@linux-m68k.org>
> > 
> > [ Upstream commit 9d7b3078628f591e4007210c0d5d3f94805cff55 ]
> > 
> > "make dtbs_check" reports:
> > 
> >      arch/riscv/boot/dts/microchip/microchip-mpfs-icicle-kit.dt.yaml: soc: refclk: {'compatible': ['fixed-clock'], '#clock-cells': [[0]], 'clock-frequency': [[600000000]], 'clock-output-names': ['msspllclk'], 'phandle': [[7]]} should not be valid under {'type': 'object'}
> >          From schema: dtschema/schemas/simple-bus.yaml
> > 
> > Fix this by moving the node out of the "soc" subnode.
> > While at it, rename it to "msspllclk", and drop the now superfluous
> > "clock-output-names" property.
> > Move the actual clock-frequency value to the board DTS, since it is not
> > set until bitstream programming time.
> > 
> > Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> > Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> > Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
> > Tested-by: Conor Dooley <conor.dooley@microchip.com>
> > Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> Hey,
> I only got this patch and nothing else in my inbox related to the dts
> that depends on the patch. Has this been autoselected? I don't really
> think there's much benefit to backporting this one to 5.15 as the
> board itself didn't even boot for another three kernel releases.

Thanks for letting us know, now dropped from the 5.15 queue.

greg k-h
