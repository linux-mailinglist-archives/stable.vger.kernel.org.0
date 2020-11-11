Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 227832AE52B
	for <lists+stable@lfdr.de>; Wed, 11 Nov 2020 01:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732023AbgKKA5k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 19:57:40 -0500
Received: from z5.mailgun.us ([104.130.96.5]:51851 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731746AbgKKA5k (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Nov 2020 19:57:40 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1605056259; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=a1WBMw0GkSFdOrfM/aKho1Ej9cF+u6GPm4QLN9sCOgk=;
 b=Ui4AkMvbjGI6UVnSuU/rLygNN7KxXebh5uuMn4v8SPAqJNKLZuDQh82dG63+F6BmSx/yDNL9
 65eNsLVKixmdjTJ4FYAJT5rjaoxuoykDfkAYIfqSv7J4IoEnKkycG4/KEuV6VxjEI47Rvz7p
 1X3N7h7/tVygc1qX2NL5UCdXMas=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n08.prod.us-west-2.postgun.com with SMTP id
 5fab37023825e013b5131b39 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 11 Nov 2020 00:57:38
 GMT
Sender: rishabhb=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 282BAC433CB; Wed, 11 Nov 2020 00:57:38 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: rishabhb)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 314ECC433C8;
        Wed, 11 Nov 2020 00:57:37 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 10 Nov 2020 16:57:37 -0800
From:   rishabhb@codeaurora.org
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Andy Gross <agross@kernel.org>, Ohad Ben-Cohen <ohad@wizery.com>,
        Siddharth Gupta <sidgup@codeaurora.org>,
        Sibi Sankar <sibis@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/4] remoteproc: sysmon: Ensure remote notification
 ordering
In-Reply-To: <20201105045051.1365780-2-bjorn.andersson@linaro.org>
References: <20201105045051.1365780-1-bjorn.andersson@linaro.org>
 <20201105045051.1365780-2-bjorn.andersson@linaro.org>
Message-ID: <fb182a63172af055be473247bc783bd6@codeaurora.org>
X-Sender: rishabhb@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-11-04 20:50, Bjorn Andersson wrote:
> The reliance on the remoteproc's state for determining when to send
> sysmon notifications to a remote processor is racy with regard to
> concurrent remoteproc operations.
> 
> Further more the advertisement of the state of other remote processor 
> to
> a newly started remote processor might not only send the wrong state,
> but might result in a stream of state changes that are out of order.
> 
> Address this by introducing state tracking within the sysmon instances
> themselves and extend the locking to ensure that the notifications are
> consistent with this state.
> 
> Fixes: 1f36ab3f6e3b ("remoteproc: sysmon: Inform current rproc about
> all active rprocs")
> Fixes: 1877f54f75ad ("remoteproc: sysmon: Add notifications for 
> events")
> Fixes: 1fb82ee806d1 ("remoteproc: qcom: Introduce sysmon")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> ---
> 
> Changes since v1:
> - Reduced the locking to be per sysmon instance
> - Dropped unused local "rproc" variable in sysmon_notify()
> 
>  drivers/remoteproc/qcom_sysmon.c | 27 +++++++++++++++++++++------
>  1 file changed, 21 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/remoteproc/qcom_sysmon.c 
> b/drivers/remoteproc/qcom_sysmon.c
> index 9eb2f6bccea6..38f63c968fa8 100644
> --- a/drivers/remoteproc/qcom_sysmon.c
> +++ b/drivers/remoteproc/qcom_sysmon.c
> @@ -22,6 +22,9 @@ struct qcom_sysmon {
>  	struct rproc_subdev subdev;
>  	struct rproc *rproc;
> 
> +	int state;
> +	struct mutex state_lock;
> +
>  	struct list_head node;
> 
>  	const char *name;
> @@ -448,7 +451,10 @@ static int sysmon_prepare(struct rproc_subdev 
> *subdev)
>  		.ssr_event = SSCTL_SSR_EVENT_BEFORE_POWERUP
>  	};
> 
> +	mutex_lock(&sysmon->state_lock);
> +	sysmon->state = SSCTL_SSR_EVENT_BEFORE_POWERUP;
>  	blocking_notifier_call_chain(&sysmon_notifiers, 0, (void *)&event);
> +	mutex_unlock(&sysmon->state_lock);
> 
>  	return 0;
>  }
> @@ -472,22 +478,25 @@ static int sysmon_start(struct rproc_subdev 
> *subdev)
>  		.ssr_event = SSCTL_SSR_EVENT_AFTER_POWERUP
>  	};
> 
> +	mutex_lock(&sysmon->state_lock);
> +	sysmon->state = SSCTL_SSR_EVENT_AFTER_POWERUP;
>  	blocking_notifier_call_chain(&sysmon_notifiers, 0, (void *)&event);
> +	mutex_unlock(&sysmon->state_lock);
> 
> -	mutex_lock(&sysmon_lock);

We should keep the sysmon_lock to make sure sysmon_list is not modified
at the time we are doing this operation?
>  	list_for_each_entry(target, &sysmon_list, node) {
> -		if (target == sysmon ||
> -		    target->rproc->state != RPROC_RUNNING)
> +		if (target == sysmon)
>  			continue;
> 
> +		mutex_lock(&target->state_lock);
>  		event.subsys_name = target->name;
> +		event.ssr_event = target->state;

Is it better to only send this event when target->state is 
"SSCTL_SSR_EVENT_AFTER_POWERUP"?
> 
>  		if (sysmon->ssctl_version == 2)
>  			ssctl_send_event(sysmon, &event);
>  		else if (sysmon->ept)
>  			sysmon_send_event(sysmon, &event);
> +		mutex_unlock(&target->state_lock);
>  	}
> -	mutex_unlock(&sysmon_lock);
> 
>  	return 0;
>  }
> @@ -500,7 +509,10 @@ static void sysmon_stop(struct rproc_subdev
> *subdev, bool crashed)
>  		.ssr_event = SSCTL_SSR_EVENT_BEFORE_SHUTDOWN
>  	};
> 
> +	mutex_lock(&sysmon->state_lock);
> +	sysmon->state = SSCTL_SSR_EVENT_BEFORE_SHUTDOWN;
>  	blocking_notifier_call_chain(&sysmon_notifiers, 0, (void *)&event);
> +	mutex_unlock(&sysmon->state_lock);
> 
>  	/* Don't request graceful shutdown if we've crashed */
>  	if (crashed)
> @@ -521,7 +533,10 @@ static void sysmon_unprepare(struct rproc_subdev 
> *subdev)
>  		.ssr_event = SSCTL_SSR_EVENT_AFTER_SHUTDOWN
>  	};
> 
> +	mutex_lock(&sysmon->state_lock);
> +	sysmon->state = SSCTL_SSR_EVENT_AFTER_SHUTDOWN;
>  	blocking_notifier_call_chain(&sysmon_notifiers, 0, (void *)&event);
> +	mutex_unlock(&sysmon->state_lock);
>  }
> 
>  /**
> @@ -534,11 +549,10 @@ static int sysmon_notify(struct notifier_block
> *nb, unsigned long event,
>  			 void *data)
>  {
>  	struct qcom_sysmon *sysmon = container_of(nb, struct qcom_sysmon, 
> nb);
> -	struct rproc *rproc = sysmon->rproc;
>  	struct sysmon_event *sysmon_event = data;
> 
>  	/* Skip non-running rprocs and the originating instance */
> -	if (rproc->state != RPROC_RUNNING ||
> +	if (sysmon->state != SSCTL_SSR_EVENT_AFTER_POWERUP ||
>  	    !strcmp(sysmon_event->subsys_name, sysmon->name)) {
>  		dev_dbg(sysmon->dev, "not notifying %s\n", sysmon->name);
>  		return NOTIFY_DONE;
> @@ -591,6 +605,7 @@ struct qcom_sysmon *qcom_add_sysmon_subdev(struct
> rproc *rproc,
>  	init_completion(&sysmon->ind_comp);
>  	init_completion(&sysmon->shutdown_comp);
>  	mutex_init(&sysmon->lock);
> +	mutex_init(&sysmon->state_lock);
> 
>  	sysmon->shutdown_irq = of_irq_get_byname(sysmon->dev->of_node,
>  						 "shutdown-ack");
