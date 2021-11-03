Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75F2F4443BE
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 15:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbhKCOna (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 10:43:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231572AbhKCOn3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Nov 2021 10:43:29 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C80AC061714
        for <stable@vger.kernel.org>; Wed,  3 Nov 2021 07:40:53 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id m14so2535966pfc.9
        for <stable@vger.kernel.org>; Wed, 03 Nov 2021 07:40:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=WXn/tck9I3dCSb6Sqxnz0FpL7sizj58Bae5H10F9O20=;
        b=WLcw+BX4CEBEwC5oxT61xEeODA46ZoNoaQq1Ki9IqYn8A4R8KLEqtrJAJagmlgla6Z
         O/rgOjq7fN87R5PedHVVHg8v0C8WP4EowdL2E780f6Aehp4LIvDHPgISJ3wE1omL5wfV
         5BVQ1PsWng8p5jSUQ3aa8zfQrfLORGL9w0tf5/cKSLjjIADE4az1jumM/HH4AjTR+ea/
         FPjbOers02FJtnn7jvz258mBdkVkZesCLAIyZuX47PJNTS80bb5PiJAtQHu7EXHak6ys
         hIh2LXUz3rveShzyCec0gYruXieX3mGz3bUKsAn4v8EyyYR/qFzYewRZ20Yjf+ziyzpN
         J7iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=WXn/tck9I3dCSb6Sqxnz0FpL7sizj58Bae5H10F9O20=;
        b=tXzUAxap3po6WY0ef+1zj+IjYmRKW8ZPXZWM5qS4kjJ9cFpexnH8H1EnMFme9bYcVl
         JwacAZHF1fTwaMAnwSmu0oVnov5uwlfYqk1EoajSVuqK+Mb3goA3qq760jwMxgNgjn7q
         InYu6m67RheUdZkfmp/p3DibO6nc2R+sHixuvR3wXsbfmdoX0XabdRkjNm6LKgKsfQiT
         jh83eEXuZpOkhHfuNq7wuEvXADyNj/hOJE4F9bzN+VDpjtf4giV1MSJ0rWKSpWVZTLcz
         qPmq/zb5kuAehgCtCqGIp4jzbzLtFnpxmpP/jE/x5LoHZ6OTnolwaZonrLk+O/QuKIt5
         lSIw==
X-Gm-Message-State: AOAM530i+J4T9b1e67wBBbEU3LFoYU99jQDh2mkn5m2PCOuWZR7GSofx
        DKlcGxoxr/bf0ylNniYOgjVvcg==
X-Google-Smtp-Source: ABdhPJxb1BGI7wiwVazryNyanP5gFZuzdtXbmEhWke+a/LIlM0549Gnd85lr7EzfpFeKlxD+/SIneQ==
X-Received: by 2002:a63:d00c:: with SMTP id z12mr32568626pgf.334.1635950451526;
        Wed, 03 Nov 2021 07:40:51 -0700 (PDT)
Received: from [192.168.254.36] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id g22sm292376pfj.82.2021.11.03.07.40.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Nov 2021 07:40:51 -0700 (PDT)
Message-ID: <9e820a6e-a42e-1098-4044-5b6786ad7b2e@linaro.org>
Date:   Wed, 3 Nov 2021 07:40:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 1/2] scsi: scsi_ioctl: Validate command size
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20211103003719.1041490-1-tadeusz.struk@linaro.org>
 <d1259a80-ac2f-a164-685a-4d1763653021@acm.org>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
In-Reply-To: <d1259a80-ac2f-a164-685a-4d1763653021@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/2/21 20:32, Bart Van Assche wrote:
>> +    if (hdr->cmd_len < 6 || hdr->cmd_len > sizeof(req->__cmd))
>> +        return -EMSGSIZE;
> 
> That doesn't look right to me since sg_io() allocates req->cmd if necessary:
> 
>      if (hdr->cmd_len > BLK_MAX_CDB) {
>          req->cmd = kzalloc(hdr->cmd_len, GFP_KERNEL);
>          if (!req->cmd)
>              goto out_put_request;
>      }

I missed that. I will send a v2 soon.

-- 
Thanks,
Tadeusz
