Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31D976A5FE4
	for <lists+stable@lfdr.de>; Tue, 28 Feb 2023 20:45:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbjB1TpV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Feb 2023 14:45:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbjB1TpV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Feb 2023 14:45:21 -0500
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB8DE1B56F;
        Tue, 28 Feb 2023 11:45:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1677613520; x=1709149520;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VFI/B5VF9lRQpPbKXQuU8MbJ+ZWjTxcz40DChLMwRUc=;
  b=O6rXeavmpqFjNxe+wgouz9qhA6B3ZWsNlNhvE2eHnzhIROnhC1yLNPFS
   KazlCQpk16W51Za0iCq5pYqIyf3EEqgcPnoJNbo9oiO78qcxvN5kM7GKQ
   lZjqKnms2CEMFeF7adDN9YQNsSON+crjUH/xB2Zv1nLTjSX3blLWbA4NM
   Y=;
X-IronPort-AV: E=Sophos;i="5.98,222,1673913600"; 
   d="scan'208";a="187784959"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-cadc3fbd.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2023 19:43:40 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-cadc3fbd.us-west-2.amazon.com (Postfix) with ESMTPS id 56D1CA2B84;
        Tue, 28 Feb 2023 19:43:39 +0000 (UTC)
Received: from EX19D010UWA004.ant.amazon.com (10.13.138.204) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Tue, 28 Feb 2023 19:43:39 +0000
Received: from u9aa42af9e4c55a.ant.amazon.com (10.106.100.8) by
 EX19D010UWA004.ant.amazon.com (10.13.138.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Tue, 28 Feb 2023 19:43:38 +0000
From:   Munehisa Kamata <kamatam@amazon.com>
To:     <u.kleine-koenig@pengutronix.de>
CC:     <kamatam@amazon.com>, <kernel@pengutronix.de>,
        <linux-kernel@vger.kernel.org>, <linux-pwm@vger.kernel.org>,
        <stable@vger.kernel.org>, <thierry.reding@gmail.com>,
        <tobetter@gmail.com>
Subject: Re: [PATCH] pwm: Zero-initialize the pwm_state passed to driver's .get_state()
Date:   Tue, 28 Feb 2023 11:43:27 -0800
Message-ID: <20230228194327.1237008-1-kamatam@amazon.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230228101558.b4dosk54jojfqkgi@pengutronix.de>
References: <20230228101558.b4dosk54jojfqkgi@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.106.100.8]
X-ClientProxiedBy: EX19D038UWC001.ant.amazon.com (10.13.139.213) To
 EX19D010UWA004.ant.amazon.com (10.13.138.204)
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2023-02-28 10:15:58 +0000, Uwe Kleine-König wrote:
>
> This is just to ensure that .usage_power is properly initialized and
> doesn't contain random stack data. The other members of struct pwm_state
> should get a value assigned in a successful call to .get_state(). So in
> the absence of bugs in driver implementations, this is only a safe-guard
> and no fix.
> 
> Reported-by: Munehisa Kamata <kamatam@amazon.com>
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
>  drivers/pwm/core.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> Hello,
> 
> On Sat, Feb 25, 2023 at 05:37:21PM -0800, Munehisa Kamata wrote:
> > Zero-initialize the on-stack structure to avoid unexpected behaviors. Some
> > drivers may not set or initialize all the values in pwm_state through their
> > .get_state() callback and therefore some random values may remain there and
> > be set into pwm->state eventually.
> > 
> > This actually caused regression on ODROID-N2+ as reported in [1]; kernel
> > fails to boot due to random panic or hang-up.
> > 
> > [1] https://forum.odroid.com/viewtopic.php?f=177&t=46360
> > 
> > Fixes: c73a3107624d ("pwm: Handle .get_state() failures")
> > Cc: stable@vger.kernel.org # 6.2
> > Signed-off-by: Munehisa Kamata <kamatam@amazon.com>
> 
> My patch is essentially the same as Munehisa's, just written a bit
> differently (to maybe make it easier for the compiler to optimize it?)
> and with an explaining comment. The actual motivation is different so
> the commit log is considerably different, too.
> 
> I was unsure how to honor Munehisa's effort, I went with a
> "Reported-by". Please tell me if you want this to be different.

I'm okay with that, thank you.

Perhaps, you should also add Cc tag for the stable tree? I did that in my
patch and we're actually CCing to the stable list, but I'm not sure if it
can pick up your patch without the tag. This should be fixed in linux-6.2.y.


Regards,
Munehisa

> Best regards
> Uwe
> 
> diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
> index e01147f66e15..533ef5bd3add 100644
> --- a/drivers/pwm/core.c
> +++ b/drivers/pwm/core.c
> @@ -115,7 +115,14 @@ static int pwm_device_request(struct pwm_device *pwm, const char *label)
>  	}
>  
>  	if (pwm->chip->ops->get_state) {
> -		struct pwm_state state;
> +		/*
> +		 * Zero-initialize state because most drivers are unaware of
> +		 * .usage_power. The other members of state are supposed to be
> +		 * set by lowlevel drivers. We still initialize the whole
> +		 * structure for simplicity even though this might paper over
> +		 * faulty implementations of .get_state().
> +		 */
> +		struct pwm_state state = { 0, };
>  
>  		err = pwm->chip->ops->get_state(pwm->chip, pwm, &state);
>  		trace_pwm_get(pwm, &state, err);
> -- 
> 2.39.1
> 
> 
> -- 
> Pengutronix e.K.                           | Uwe Kleine-König            |
> Industrial Linux Solutions                 | https://www.pengutronix.de/ |
> 
