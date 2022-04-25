Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 798F750DD0F
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 11:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238356AbiDYJsw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 25 Apr 2022 05:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235133AbiDYJsv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Apr 2022 05:48:51 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D46CE5598
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 02:45:46 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1nivHg-0006sC-Bl; Mon, 25 Apr 2022 11:45:32 +0200
Received: from [2a0a:edc0:0:900:1d::4e] (helo=lupine)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1nivHf-0057VX-Sy; Mon, 25 Apr 2022 11:45:30 +0200
Received: from pza by lupine with local (Exim 4.94.2)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1nivHd-0004pV-OZ; Mon, 25 Apr 2022 11:45:29 +0200
Message-ID: <59b135206b456fd8f8df30a4e474e385a922bf77.camel@pengutronix.de>
Subject: Re: [PATCH 2/2] phy: qcom-qmp: fix reset-controller leak on probe
 errors
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Johan Hovold <johan+linaro@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Vivek Gautam <vivek.gautam@codeaurora.org>
Date:   Mon, 25 Apr 2022 11:45:29 +0200
In-Reply-To: <20220422130941.2044-3-johan+linaro@kernel.org>
References: <20220422130941.2044-1-johan+linaro@kernel.org>
         <20220422130941.2044-3-johan+linaro@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Johan,

On Fr, 2022-04-22 at 15:09 +0200, Johan Hovold wrote:
> Make sure to release the lane reset controller in case of a late probe
> error (e.g. probe deferral).

Right. grepping for "of_reset_control_get", there seem to be are a few
other drivers that might share the same issue...

> Note that due to the reset controller being defined in devicetree in
> (questionable) "lane" child nodes, devm_reset_control_get_exclusive()
> cannot be used (and we shouldn't add devres helpers for the legacy reset
> controller API).

Do you mean of_reset_control_get()? Maybe you could switch to
of_reset_control_get_exclusive() while at it?

That one might warrant a devres helper if other drivers were to adopt
the same pattern.

The patch itself looks fine to me,

Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp
