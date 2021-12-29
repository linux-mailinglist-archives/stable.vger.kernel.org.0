Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41F34480E0F
	for <lists+stable@lfdr.de>; Wed, 29 Dec 2021 01:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231695AbhL2AIo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Dec 2021 19:08:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbhL2AIo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Dec 2021 19:08:44 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 115E5C061574;
        Tue, 28 Dec 2021 16:08:44 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id m15so17086255pgu.11;
        Tue, 28 Dec 2021 16:08:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=OzoIVwThuh1n1Hx4WIaQX8I/MtrnK06pzCT8x8o7dfE=;
        b=dWKrY89/NOPHDRSHrqKZE/fJamu/Sy8s8YVYDQImpL/MERSFfOXOxkiCIwr2JyslKE
         0OqCbOuEKkmbSuj3rI36zmDr/a+RALMwNHsgPVDREKHpb9A5+GQXQxOm3AEKNHCJMOs7
         8odNXKjZHP0vTgIHgI15FTa5+9EKmRgj7bl/H4tfQh4KhZa/7lmIhkY37uo+5kwHbyLd
         xZWHINUk60oZ5P1oL/p8GtR5vp3ebxwbNfg6i8tNqv//xcF2dECll5TfoZjECuvcVEh9
         DZSvI51qG4Rm8FTS50eSEbdAWLdZ3nfB1hAYuaMmBAtydVe87aikLLNHrXSLrKApk1lc
         DihQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OzoIVwThuh1n1Hx4WIaQX8I/MtrnK06pzCT8x8o7dfE=;
        b=IgO+ANVNrWty0qCuqBaIcFiGErJrEx0yu82XyvJHH8+g5CrWn+y+/HrFgtEfZGNwS+
         6RCR9SEDy8w8sfxfpSnLFu0HalwFROhTur3zpT7Gu1/Jro9vK/DRi8IMcr1SssYYVhp4
         ORfBFDvilnranIe32kbYGNgZYeIaZQllDCHnvPYmi7seiUk0wxRyUIlXYpeCs0YIXjkj
         gVTZ7R8NciS5cU7V0eVJSeV1vdJQ9obNSUQvGu7M5VkxD/wWX4lYx97vV0oOLHZu131r
         FAU29tgBUkLLmKuObsaOhdLQclqg2MEOdiPNT2rX0Ah+V8Ep569KrQFy1PD4oZx+gIPi
         kllg==
X-Gm-Message-State: AOAM530oj7deU9ksYpe6bt5LFpAPKwVv7wNX0SJQGvMIEqniO1OMVCwW
        wG67ei9p+DCvwBY/MSQv0qo=
X-Google-Smtp-Source: ABdhPJzjVhjQuCt55GKxZC+GpXs13bVo6kutzV+9Upsn/PHStciN3TFXvkJ2K495xkBP0fj4V1g2NQ==
X-Received: by 2002:a63:10a:: with SMTP id 10mr21363492pgb.170.1640736523383;
        Tue, 28 Dec 2021 16:08:43 -0800 (PST)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id om3sm23114497pjb.49.2021.12.28.16.08.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Dec 2021 16:08:42 -0800 (PST)
Message-ID: <3c835b05-b476-4ea9-929f-0131fa7a3446@gmail.com>
Date:   Tue, 28 Dec 2021 16:08:42 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 1/2] tpm: Fix error handling in async work
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, linux-integrity@vger.kernel.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211220211700.5772-1-tstruk@gmail.com> <YcuiIdorMLEjhJn6@iki.fi>
From:   Tadeusz Struk <tstruk@gmail.com>
In-Reply-To: <YcuiIdorMLEjhJn6@iki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/28/21 15:47, Jarkko Sakkinen wrote:
>> When an invalid (non existing) handle is used in a tpm command,
>> that uses the resource manager interface (/dev/tpmrm0) the resource
>> manager tries to load it from its internal cache, but fails and
>> returns an -EINVAL error to the caller. The existing async handler
>> doesn't handle these error cases currently and the condition in the
>> poll handler never returns mask with EPOLLIN set causing the userspace
>> code to get stack. Make sure that error conditions also contribute
>> to the poll mask so that a correct error code could passed back
>> to the caller.
> Can you instead describe a failure scenario? This is very cryptic.

The problem is that the poll call blocks and the application gets stuck
until the tpm_timeout_work() wakes it up after 120 sec (jiffies + (120 * HZ)).
I will update the description, fix all the typos, and resend it.

Thanks,
Tadeusz
