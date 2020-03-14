Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F54A18598F
	for <lists+stable@lfdr.de>; Sun, 15 Mar 2020 04:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbgCODFP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Mar 2020 23:05:15 -0400
Received: from cloudserver094114.home.pl ([79.96.170.134]:53683 "EHLO
        cloudserver094114.home.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbgCODFP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Mar 2020 23:05:15 -0400
Received: from 185.80.35.16 (185.80.35.16) (HELO kreacher.localnet)
 by serwer1319399.home.pl (79.96.170.134) with SMTP (IdeaSmtpServer 0.83.341)
 id 18c27b0219204e13; Sat, 14 Mar 2020 12:05:13 +0100
From:   "Rafael J. Wysocki" <rjw@rjwysocki.net>
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     Sudeep Holla <sudeep.holla@arm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        linux-pm@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Lina Iyer <ilina@codeaurora.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Benjamin Gaignard <benjamin.gaignard@st.com>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 1/2] PM / Domains: Allow no domain-idle-states DT property in genpd when parsing
Date:   Sat, 14 Mar 2020 12:05:13 +0100
Message-ID: <2266717.MI9MQu89M6@kreacher>
In-Reply-To: <20200310104023.4018-1-ulf.hansson@linaro.org>
References: <20200310104023.4018-1-ulf.hansson@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tuesday, March 10, 2020 11:40:23 AM CET Ulf Hansson wrote:
> Commit 2c361684803e ("PM / Domains: Don't treat zero found compatible idle
> states as an error"), moved of_genpd_parse_idle_states() towards allowing
> none compatible idle state to be found for the device node, rather than
> returning an error code.
> 
> However, it didn't consider that the "domain-idle-states" DT property may
> be missing as it's optional, which makes of_count_phandle_with_args() to
> return -ENOENT. Let's fix this to make the behaviour consistent.
> 
> Reported-by: Benjamin Gaignard <benjamin.gaignard@st.com>
> Fixes: 2c361684803e ("PM / Domains: Don't treat zero found compatible idle states as an error")
> Cc: <stable@vger.kernel.org>
> Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> ---
> 
> Changes in v3:
> 	- Resending with reviewed-tags added.
> 
> ---
>  drivers/base/power/domain.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
> index 959d6d5eb000..0a01df608849 100644
> --- a/drivers/base/power/domain.c
> +++ b/drivers/base/power/domain.c
> @@ -2653,7 +2653,7 @@ static int genpd_iterate_idle_states(struct device_node *dn,
>  
>  	ret = of_count_phandle_with_args(dn, "domain-idle-states", NULL);
>  	if (ret <= 0)
> -		return ret;
> +		return ret == -ENOENT ? 0 : ret;
>  
>  	/* Loop over the phandles until all the requested entry is found */
>  	of_for_each_phandle(&it, ret, dn, "domain-idle-states", NULL, 0) {
> 

Applied as 5.7 material along with the [2/2], thanks!



