Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB2F282FAB
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 06:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725864AbgJEEjk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 00:39:40 -0400
Received: from m42-4.mailgun.net ([69.72.42.4]:42174 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725844AbgJEEjk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 00:39:40 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1601872779; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=n0KgKn/5gajY7HCxaeIkOKKATXMuFolbt/z+U2KsArA=; b=COQqBmkQ1rqHWjAWpYMqpDo2wUOo+K96nj0rjFTIkXpTxzu+DGDCVxbREp4kVvbpsR8Ejg6y
 3hxe1M10M0/8J8v4wtrWHhAZOeOZAN5c+x09CJ2wrsY5Lo1o4z9i2Vdat/2mbxKUcR8k/9Go
 FyIK9GkZjxxIbweGaM649plwvDQ=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 5f7aa38ba03b63d6732c5a92 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 05 Oct 2020 04:39:39
 GMT
Sender: gkohli=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 507F6C433F1; Mon,  5 Oct 2020 04:39:39 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
Received: from [192.168.1.4] (unknown [117.98.218.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: gkohli)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 988B9C433CA;
        Mon,  5 Oct 2020 04:39:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 988B9C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=gkohli@codeaurora.org
Subject: Re: [PATCH v1] trace: Fix race in trace_open and buffer resize call
To:     rostedt@goodmis.org, linux-kernel@vger.kernel.org
Cc:     linux-arm-msm@vger.kernel.org, stable@vger.kernel.org
References: <1600955705-27382-1-git-send-email-gkohli@codeaurora.org>
From:   Gaurav Kohli <gkohli@codeaurora.org>
Message-ID: <71b8fe4c-7be2-fe51-cd84-890320c98cda@codeaurora.org>
Date:   Mon, 5 Oct 2020 10:09:34 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <1600955705-27382-1-git-send-email-gkohli@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Steven,

please let us know, if below looks good to you or need modifications.

Thanks
Gaurav

On 9/24/2020 7:25 PM, Gaurav Kohli wrote:
> Below race can come, if trace_open and resize of
> cpu buffer is running parallely on different cpus
> CPUX                                CPUY
> 				    ring_buffer_resize
> 				    atomic_read(&buffer->resize_disabled)
> tracing_open
> tracing_reset_online_cpus
> ring_buffer_reset_cpu
> rb_reset_cpu
> 				    rb_update_pages
> 				    remove/insert pages
> resetting pointer
> This race can cause data abort or some times infinte loop in
> rb_remove_pages and rb_insert_pages while checking pages
> for sanity.
> 
> Signed-off-by: Gaurav Kohli <gkohli@codeaurora.org>
> Cc: stable@vger.kernel.org
> ---
> Changes since v0:
>    -Addressed Steven's review comments.
> 
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index 93ef0ab..15bf28b 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -4866,6 +4866,9 @@ void ring_buffer_reset_cpu(struct trace_buffer *buffer, int cpu)
>   	if (!cpumask_test_cpu(cpu, buffer->cpumask))
>   		return;
>   
> +	/* prevent another thread from changing buffer sizes */
> +	mutex_lock(&buffer->mutex);
> +
>   	atomic_inc(&cpu_buffer->resize_disabled);
>   	atomic_inc(&cpu_buffer->record_disabled);
>   
> @@ -4876,6 +4879,8 @@ void ring_buffer_reset_cpu(struct trace_buffer *buffer, int cpu)
>   
>   	atomic_dec(&cpu_buffer->record_disabled);
>   	atomic_dec(&cpu_buffer->resize_disabled);
> +
> +	mutex_unlock(&buffer->mutex);
>   }
>   EXPORT_SYMBOL_GPL(ring_buffer_reset_cpu);
>   
> @@ -4889,6 +4894,9 @@ void ring_buffer_reset_online_cpus(struct trace_buffer *buffer)
>   	struct ring_buffer_per_cpu *cpu_buffer;
>   	int cpu;
>   
> +	/* prevent another thread from changing buffer sizes */
> +	mutex_lock(&buffer->mutex);
> +
>   	for_each_online_buffer_cpu(buffer, cpu) {
>   		cpu_buffer = buffer->buffers[cpu];
>   
> @@ -4907,6 +4915,8 @@ void ring_buffer_reset_online_cpus(struct trace_buffer *buffer)
>   		atomic_dec(&cpu_buffer->record_disabled);
>   		atomic_dec(&cpu_buffer->resize_disabled);
>   	}
> +
> +	mutex_unlock(&buffer->mutex);
>   }
>   
>   /**
> 

-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation Center,
Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
