Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 569B461F2F4
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 13:24:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232186AbiKGMYV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 07:24:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232174AbiKGMYQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 07:24:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5CF2262D;
        Mon,  7 Nov 2022 04:24:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 646D26101C;
        Mon,  7 Nov 2022 12:24:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC3B1C433D7;
        Mon,  7 Nov 2022 12:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667823853;
        bh=iQ5ViS/Km14zaC7mgBP0y2BtAXFP1Zx2+Nc0cPz+2qA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Cjo/qXHYDinqnN1BP/cR4oeVGmag98le5Rk5ncBzR62I69Fw268at7QCX1YlMexDs
         cYsR6k3RHR3tfPbvEeOzkiaWT6N9rawd5MC1JTSWjOpi02oykFYTdnYSEEZrKRshkS
         lZRGonQGVwvMXfHpmxqhifkluwQLYdW2ric5Ig0eODnqS3Vp/5oU7aFwKcyW7IFeNb
         hjpmQDzp7CktfXP5ghOjSepmNfg2eTsoOo02ssHsmhDeojtrjRS900yNpfXGzJipJK
         XNKzSCLix4khBHtq05cl/AVx0RXjO9Zy27GtkoYKeaG7vTHok6UmjqZcANYTz1Ytj1
         OFPJ+xVgD9Hcw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1os1AL-0004DQ-56; Mon, 07 Nov 2022 13:23:49 +0100
Date:   Mon, 7 Nov 2022 13:23:49 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Brian Masney <bmasney@redhat.com>
Cc:     Johan Hovold <johan+linaro@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Shazad Hussain <quic_shazhuss@quicinc.com>,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] arm64: dts: qcom: sc8280xp: fix UFS reference clocks
Message-ID: <Y2j41epn0FTT2Asb@hovoldconsulting.com>
References: <20221104092045.17410-1-johan+linaro@kernel.org>
 <20221104092045.17410-2-johan+linaro@kernel.org>
 <Y2jnWJ0FI6Fmy8/O@x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2jnWJ0FI6Fmy8/O@x1>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 07, 2022 at 06:09:12AM -0500, Brian Masney wrote:
> On Fri, Nov 04, 2022 at 10:20:44AM +0100, Johan Hovold wrote:
> > There are three UFS reference clocks on SC8280XP which are used as
> > follows:
> > 
> >  - The GCC_UFS_REF_CLKREF_CLK clock is fed to any UFS device connected
> >    to either controller.
> > 
> >  - The GCC_UFS_1_CARD_CLKREF_CLK and GCC_UFS_CARD_CLKREF_CLK clocks
> >    provide reference clocks to the two PHYs.
> > 
> > Note that this depends on first updating the clock driver to reflect
> > that all three clocks are sourced from CXO. Specifically, the UFS
> > controller driver expects the device reference clock to have a valid
> > frequency:
> > 
> > 	ufshcd-qcom 1d84000.ufs: invalid ref_clk setting = 0
> > 
> > Fixes: 152d1faf1e2f ("arm64: dts: qcom: add SC8280XP platform")
> > Fixes: 8d6b458ce6e9 ("arm64: dts: qcom: sc8280xp: fix ufs_card_phy ref clock")
> > Fixes: f3aa975e230e ("arm64: dts: qcom: sc8280xp: correct ref clock for ufs_mem_phy")
> > Link: https://lore.kernel.org/lkml/Y2OEjNAPXg5BfOxH@hovoldconsulting.com/
> > Cc: stable@vger.kernel.org	# 5.20
> > Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> 
> Reviewed-by: Brian Masney <bmasney@redhat.com>
> 
> Note that there was no 5.20 kernel; that should be 6.0. Bjorn should be
> able to fix this up during merge.

Good catch. I based this on a tag created before 6.0 was released and
failed to notice.

Johan
