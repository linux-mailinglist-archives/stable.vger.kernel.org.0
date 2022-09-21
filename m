Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64FCC5C03F7
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 18:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbiIUQVy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 12:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbiIUQVj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 12:21:39 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C7B5598CB4;
        Wed, 21 Sep 2022 09:04:59 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4279013D5;
        Wed, 21 Sep 2022 08:56:45 -0700 (PDT)
Received: from bogus (e103737-lin.cambridge.arm.com [10.1.197.49])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 635593F5A1;
        Wed, 21 Sep 2022 08:56:37 -0700 (PDT)
Date:   Wed, 21 Sep 2022 16:56:34 +0100
From:   Sudeep Holla <sudeep.holla@arm.com>
To:     Ulf Hansson <ulf.hansson@linaro.org>,
        Dien Pham <dien.pham.ry@renesas.com>,
        Gaku Inami <gaku.inami.xh@renesas.com>
Cc:     Cristian Marussi <cristian.marussi@arm.com>,
        linux-arm-kernel@lists.infradead.org, Peng Fan <peng.fan@nxp.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Nicolas Pitre <npitre@baylibre.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] Revert "firmware: arm_scmi: Add clock management to the
 SCMI power domain"
Message-ID: <20220921155634.owr5lncydsfpo7ua@bogus>
References: <20220919122033.86126-1-ulf.hansson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220919122033.86126-1-ulf.hansson@linaro.org>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Dien, Gaku,

On Mon, Sep 19, 2022 at 02:20:33PM +0200, Ulf Hansson wrote:
> This reverts commit a3b884cef873 ("firmware: arm_scmi: Add clock management
> to the SCMI power domain").
> 
> Using the GENPD_FLAG_PM_CLK tells genpd to gate/ungate the consumer
> device's clock(s) during runtime suspend/resume through the PM clock API.
> More precisely, in genpd_runtime_resume() the clock(s) for the consumer
> device would become ungated prior to the driver-level ->runtime_resume()
> callbacks gets invoked.
> 
> This behaviour isn't a good fit for all platforms/drivers. For example, a
> driver may need to make some preparations of its device in its
> ->runtime_resume() callback, like calling clk_set_rate() before the
> clock(s) should be ungated. In these cases, it's easier to let the clock(s)
> to be managed solely by the driver, rather than at the PM domain level.
> 
> For these reasons, let's drop the use GENPD_FLAG_PM_CLK for the SCMI PM
> domain, as to enable it to be more easily adopted across ARM platforms.
> 
> Fixes: a3b884cef873 ("firmware: arm_scmi: Add clock management to the SCMI power domain")
> Cc: Nicolas Pitre <npitre@baylibre.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> ---
> 
> To get some more background to $subject patch, please have a look at the
> lore-link below.
> 
> https://lore.kernel.org/all/DU0PR04MB94173B45A2CFEE3BF1BD313A88409@DU0PR04MB9417.eurprd04.prod.outlook.com/
>

If you have any objections, this is your last chance to speak up before
the original change gets reverted in the mainline with this patch.

Hi Ulf,

I don't have any other SCMI changes for v6.0 fixes or v6.1
I am fine if you are happy to take this via your tree or I can send it
to SoC team. Let me know. I will give final one or 2 days for Renesas
to get back if they really care much.

--
Regards,
Sudeep
