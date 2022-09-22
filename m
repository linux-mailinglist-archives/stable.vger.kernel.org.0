Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A766A5E605C
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 13:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbiIVLEN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 07:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbiIVLEM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 07:04:12 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A4123B56CB;
        Thu, 22 Sep 2022 04:04:10 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EDD85ED1;
        Thu, 22 Sep 2022 04:04:16 -0700 (PDT)
Received: from bogus (e103737-lin.cambridge.arm.com [10.1.197.49])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 148303F73B;
        Thu, 22 Sep 2022 04:04:08 -0700 (PDT)
Date:   Thu, 22 Sep 2022 12:04:06 +0100
From:   Sudeep Holla <sudeep.holla@arm.com>
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     Dien Pham <dien.pham.ry@renesas.com>,
        Gaku Inami <gaku.inami.xh@renesas.com>,
        Cristian Marussi <cristian.marussi@arm.com>,
        linux-arm-kernel@lists.infradead.org, Peng Fan <peng.fan@nxp.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Nicolas Pitre <npitre@baylibre.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] Revert "firmware: arm_scmi: Add clock management to the
 SCMI power domain"
Message-ID: <20220922110406.cuovmxtw2jkn4f4h@bogus>
References: <20220919122033.86126-1-ulf.hansson@linaro.org>
 <20220921155634.owr5lncydsfpo7ua@bogus>
 <CAPDyKFpgHDzc5Rv+0Tn4zegDTrc_wuymez02XLEdVUaEOornNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDyKFpgHDzc5Rv+0Tn4zegDTrc_wuymez02XLEdVUaEOornNw@mail.gmail.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 21, 2022 at 08:46:21PM +0200, Ulf Hansson wrote:
> On Wed, 21 Sept 2022 at 17:56, Sudeep Holla <sudeep.holla@arm.com> wrote:
> >
> > Hi Dien, Gaku,
> >
> > On Mon, Sep 19, 2022 at 02:20:33PM +0200, Ulf Hansson wrote:
> > > This reverts commit a3b884cef873 ("firmware: arm_scmi: Add clock management
> > > to the SCMI power domain").
> > >
> > > Using the GENPD_FLAG_PM_CLK tells genpd to gate/ungate the consumer
> > > device's clock(s) during runtime suspend/resume through the PM clock API.
> > > More precisely, in genpd_runtime_resume() the clock(s) for the consumer
> > > device would become ungated prior to the driver-level ->runtime_resume()
> > > callbacks gets invoked.
> > >
> > > This behaviour isn't a good fit for all platforms/drivers. For example, a
> > > driver may need to make some preparations of its device in its
> > > ->runtime_resume() callback, like calling clk_set_rate() before the
> > > clock(s) should be ungated. In these cases, it's easier to let the clock(s)
> > > to be managed solely by the driver, rather than at the PM domain level.
> > >
> > > For these reasons, let's drop the use GENPD_FLAG_PM_CLK for the SCMI PM
> > > domain, as to enable it to be more easily adopted across ARM platforms.
> > >
> > > Fixes: a3b884cef873 ("firmware: arm_scmi: Add clock management to the SCMI power domain")
> > > Cc: Nicolas Pitre <npitre@baylibre.com>
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> > > ---
> > >
> > > To get some more background to $subject patch, please have a look at the
> > > lore-link below.
> > >
> > > https://lore.kernel.org/all/DU0PR04MB94173B45A2CFEE3BF1BD313A88409@DU0PR04MB9417.eurprd04.prod.outlook.com/
> > >
> >
> > If you have any objections, this is your last chance to speak up before
> > the original change gets reverted in the mainline with this patch.
> >
> > Hi Ulf,
> >
> > I don't have any other SCMI changes for v6.0 fixes or v6.1
> > I am fine if you are happy to take this via your tree or I can send it
> > to SoC team. Let me know. I will give final one or 2 days for Renesas
> > to get back if they really care much.
> 
> I have a slew of fixes for mmc that I intend to send next week, I can
> funnel them through that pull request.
> 
> Assuming, Renesas folkz are okay, I consider that as an ack from you, right?
>

Yes for official reasons, here is the formal :)

Acked-by: Sudeep Holla <sudeep.holla@arm.com>

in case you manage to get this in via your tree.

--
Regards,
Sudeep
