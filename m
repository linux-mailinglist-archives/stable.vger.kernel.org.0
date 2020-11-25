Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59B0F2C4742
	for <lists+stable@lfdr.de>; Wed, 25 Nov 2020 19:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732932AbgKYSJU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Nov 2020 13:09:20 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:26407 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732380AbgKYSJT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Nov 2020 13:09:19 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606327759; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=TxzY5+TastQJ0o5m73NMH0KhCIllUkTh0uuclpIl/n4=;
 b=dIbY+m+rlJmSlEBNU6XEgrhCH8zu4ZoIxTHANJl5ZCUFrPwxSAbSvGOVtWUCKoFG+aewLaA2
 JDX0PKdP0OwA0hJwsjgQXNTexIbp4dcab3DtWzg24gJibstcWZiw602PrZwROnTqTwpErtTL
 vgFCV6FqGtgPYRKQ1EzaGw6xGJ8=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 5fbe9dc91dba509aaefb68ea (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 25 Nov 2020 18:09:13
 GMT
Sender: rishabhb=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id C50ECC43461; Wed, 25 Nov 2020 18:09:12 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: rishabhb)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D76AFC433C6;
        Wed, 25 Nov 2020 18:09:11 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 25 Nov 2020 10:09:11 -0800
From:   rishabhb@codeaurora.org
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Andy Gross <agross@kernel.org>, Ohad Ben-Cohen <ohad@wizery.com>,
        Siddharth Gupta <sidgup@codeaurora.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        linux-arm-msm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 1/4] remoteproc: sysmon: Ensure remote notification
 ordering
In-Reply-To: <20201122054135.802935-2-bjorn.andersson@linaro.org>
References: <20201122054135.802935-1-bjorn.andersson@linaro.org>
 <20201122054135.802935-2-bjorn.andersson@linaro.org>
Message-ID: <4a5b9e45d7f763fe73b02ca543012b25@codeaurora.org>
X-Sender: rishabhb@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-11-21 21:41, Bjorn Andersson wrote:
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
> Changes since v2:
> - Hold sysmon_lock during traversal of sysmons in sysmon_start()
> 
>  drivers/remoteproc/qcom_sysmon.c | 25 +++++++++++++++++++++----
>  1 file changed, 21 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/remoteproc/qcom_sysmon.c 
> b/drivers/remoteproc/qcom_sysmon.c
> index 9eb2f6bccea6..b37b111b15b3 100644
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
> @@ -472,20 +478,25 @@ static int sysmon_start(struct rproc_subdev 
> *subdev)
>  		.ssr_event = SSCTL_SSR_EVENT_AFTER_POWERUP
>  	};
> 
> +	mutex_lock(&sysmon->state_lock);
> +	sysmon->state = SSCTL_SSR_EVENT_AFTER_POWERUP;
>  	blocking_notifier_call_chain(&sysmon_notifiers, 0, (void *)&event);
> +	mutex_unlock(&sysmon->state_lock);
> 
>  	mutex_lock(&sysmon_lock);
>  	list_for_each_entry(target, &sysmon_list, node) {
> -		if (target == sysmon ||
> -		    target->rproc->state != RPROC_RUNNING)
> +		if (target == sysmon)
>  			continue;
> 
> +		mutex_lock(&target->state_lock);
>  		event.subsys_name = target->name;
> +		event.ssr_event = target->state;
> 
>  		if (sysmon->ssctl_version == 2)
>  			ssctl_send_event(sysmon, &event);
>  		else if (sysmon->ept)
>  			sysmon_send_event(sysmon, &event);
> +		mutex_unlock(&target->state_lock);
>  	}
>  	mutex_unlock(&sysmon_lock);
> 
> @@ -500,7 +511,10 @@ static void sysmon_stop(struct rproc_subdev
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
> @@ -521,7 +535,10 @@ static void sysmon_unprepare(struct rproc_subdev 
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
> @@ -534,11 +551,10 @@ static int sysmon_notify(struct notifier_block
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
> @@ -591,6 +607,7 @@ struct qcom_sysmon *qcom_add_sysmon_subdev(struct
> rproc *rproc,
>  	init_completion(&sysmon->ind_comp);
>  	init_completion(&sysmon->shutdown_comp);
>  	mutex_init(&sysmon->lock);
> +	mutex_init(&sysmon->state_lock);
> 
>  	sysmon->shutdown_irq = of_irq_get_byname(sysmon->dev->of_node,
>  						 "shutdown-ack");

Reviewed-by: Rishabh Bhatnagar <rishabhb@codeaurora.org>
