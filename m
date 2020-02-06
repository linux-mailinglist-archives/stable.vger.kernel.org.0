Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D450F154B73
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 19:49:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbgBFSto (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 13:49:44 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:36952 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727703AbgBFStn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Feb 2020 13:49:43 -0500
Received: by mail-il1-f194.google.com with SMTP id v13so6100445iln.4
        for <stable@vger.kernel.org>; Thu, 06 Feb 2020 10:49:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/+yr6ZnUGHz18RBcRdXwTrFaudiLP7yFxeU/1OOsEwE=;
        b=BDQMrvey+Ap7N6vFBhNYmxjWc54GyYmzVHvVCsboz81dC2Zr9XfUsgTnYRPMtlM3e0
         8WcWH4hPnX7tA0vFmHKvhpIIW9rIIWmQC9FSQpIhhUzILZE6FOIlHsRhZPqVbwai3n45
         Dh2A8Jc2wZGBA1HDm9D7U81zfYdJBgsJE3tShYWXgRlOFrijUVkMXIJWGPsOaEzGEDB7
         B4Ua94T5fnWjUPS9HVJOZ2xoLcCp8mQTX0pJnht5tAcx9qKyPEN5u5FfjXd36ttFQaHA
         yqh2NCJW97vpqMmNoA5XFEK0bGIaXnkYEWpbD+TrShuhwAS7cKA3UO+0D9KKMrnGxbof
         6U/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/+yr6ZnUGHz18RBcRdXwTrFaudiLP7yFxeU/1OOsEwE=;
        b=YIDc2HJZth1L/n42MPVj0MiBw8f06R3xOz6HGYmjaxAHuN8whpzYlsR2hMGCCR9z6L
         JUtbyQIs1sNReiWFh3AiTOlgDwXVt4BYcO5u7crC2n9xQCBScOUM+K35QKAQX1QVKfBw
         scO0s1jL83JbpMoqBnNZo8Y8sBoEGr6UUqi0F0ZNxldxMOHTAfAjfq2lmZjYnEbnPMJg
         SSgZm9YeRS4pTq9fp+HWP9SqwqXy/uEUEIpP+M28+0BIi/yhKj1b2eloy2MQ+ura9RJj
         3+zkDl+UfeCA6ElpX5E3hCL+1tikLH7owJtOI9CSE5wGXN9KfV7SWcpmaZy9iabr9q6g
         GwsQ==
X-Gm-Message-State: APjAAAVfMsLzYzwpxHkgDFmrp6OAq6S6YdVpcgc1i6Zuf0rM2DfOQiry
        LV1JI+4BcUYzTWH/nLN2Hec1lw==
X-Google-Smtp-Source: APXvYqyLS/L1otM4xOsx0/hycCgKncr6mUEukiNOTR4XI5s8Q2vZDonQRRXSoHv+vQA0wyRISZzp9g==
X-Received: by 2002:a92:9603:: with SMTP id g3mr5418246ilh.231.1581014981691;
        Thu, 06 Feb 2020 10:49:41 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id d12sm195559iln.63.2020.02.06.10.49.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Feb 2020 10:49:41 -0800 (PST)
Subject: Re: [PATCH] blktrace: Protect q->blk_trace with RCU
To:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        Jan Kara <jack@suse.cz>
Cc:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "tristmd@gmail.com" <tristmd@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
References: <20200206142812.25989-1-jack@suse.cz>
 <BYAPR04MB5749BAE3D6813845E16D92E2861D0@BYAPR04MB5749.namprd04.prod.outlook.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ddc358fb-8189-fbe9-619d-e3c943a05053@kernel.dk>
Date:   Thu, 6 Feb 2020 11:49:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <BYAPR04MB5749BAE3D6813845E16D92E2861D0@BYAPR04MB5749.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/6/20 11:46 AM, Chaitanya Kulkarni wrote:
> Hi Jan,
> 
> What do you think about following patch on the top of yours ?
> 
> The new helper that I've added on the top of your patch will also
> future uses of the rcu_dereference_protected(). e.g. blktrace
> extension [1] support that I'm working on.
> 
> P.S. it is compile only if your okay I'll send a separate patch.
> 
> +
> +/* Dereference q->blk_trace with q->blk_trace_mutex check only. */
> +static inline struct blk_trace *blk_trace_rcu_deref(struct 
> request_queue *q)
> +{
> +       return rcu_dereference_protected(q->blk_trace,
> + 
> lockdep_is_held(&q->blk_trace_mutex));
> +}

Let's please not do that, it serves no real purpose and it just
obfuscates what's really going on.

-- 
Jens Axboe

