Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67D9D5110CD
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 08:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357953AbiD0GEy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 02:04:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357954AbiD0GEy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 02:04:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5979146163;
        Tue, 26 Apr 2022 23:01:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F37C2B823F1;
        Wed, 27 Apr 2022 06:01:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4BA5C385A7;
        Wed, 27 Apr 2022 06:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651039301;
        bh=vrSKVfzDuthRYBdUjrjFxhx98WWa/Du4tj2i28+8jhE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OEfFw5R30Zg7fXlsRxQJh/mLBRyQVwhu8NnsvUmUl7RvZ8MLkQdTxC+SynmyQGRAX
         SX8ommb4WBMGfD4UkluVFED3wsgNdbiL3E/Nyf1oSEjMrFcWxAykXoTGLCq2ahtLbg
         SKd7fLyCEi9dp0zkMuF+QUOu4m40sKBNHrYDL0a4vdYFLjvbgzZ+uzm4flH1rK/I1J
         OUNADI/y9fGtuHVkaDvo2uDEmGXeLqNgoDyyXYCclqF/ajSoxcP8Oe0ND3wMp9as5i
         Lw3aoun+ORwsIkLLXeZKWSG2tpCxcWD82ySLMxdH9M1XLYqStNUu1n6DeD8AzHkAdB
         OULQUiACm4BaQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1njakA-0000EW-Sx; Wed, 27 Apr 2022 08:01:42 +0200
Date:   Wed, 27 Apr 2022 08:01:42 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Philipp Zabel <p.zabel@pengutronix.de>
Cc:     Johan Hovold <johan+linaro@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>, Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Vivek Gautam <vivek.gautam@codeaurora.org>
Subject: Re: [PATCH 2/2] phy: qcom-qmp: fix reset-controller leak on probe
 errors
Message-ID: <YmjcRleHMaWKUcni@hovoldconsulting.com>
References: <20220422130941.2044-1-johan+linaro@kernel.org>
 <20220422130941.2044-3-johan+linaro@kernel.org>
 <59b135206b456fd8f8df30a4e474e385a922bf77.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59b135206b456fd8f8df30a4e474e385a922bf77.camel@pengutronix.de>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 25, 2022 at 11:45:29AM +0200, Philipp Zabel wrote:
> Hi Johan,
> 
> On Fr, 2022-04-22 at 15:09 +0200, Johan Hovold wrote:
> > Make sure to release the lane reset controller in case of a late probe
> > error (e.g. probe deferral).
> 
> Right. grepping for "of_reset_control_get", there seem to be are a few
> other drivers that might share the same issue...

Yeah, I'm sure there are more of these.
 
> > Note that due to the reset controller being defined in devicetree in
> > (questionable) "lane" child nodes, devm_reset_control_get_exclusive()
> > cannot be used (and we shouldn't add devres helpers for the legacy reset
> > controller API).
> 
> Do you mean of_reset_control_get()? Maybe you could switch to
> of_reset_control_get_exclusive() while at it?

Right, I was referring to of_reset_control_get() but obviously
of_reset_control_get_exclusive() could still get a devres version so
that sentence in parenthesis doesn't make much sense.

I must have mistakingly imagined that the latter also retrieved the
struct device_node from a struct device like the current devres helpers
do.

> That one might warrant a devres helper if other drivers were to adopt
> the same pattern.

Right.

> The patch itself looks fine to me,
> 
> Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>

Thanks for reviewing. I'll send a v2 with an updated commit message and
switch to the new API in a new follow-on patch.

Johan
