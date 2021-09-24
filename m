Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0204179EE
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 19:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344469AbhIXRlu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 13:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241912AbhIXRlu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Sep 2021 13:41:50 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40655C061571
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 10:40:16 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id d21so29636327wra.12
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 10:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WXBiZ3lMd+Z19YrZpfewJmi1/8g+N72a9+ebtf2jcDg=;
        b=LvrnJcFSd9hDrLwHldZaicIeKrQtvXXEBr6QeH67LPmIeIAN4+hK/2DBybrTKrfDPJ
         KzuV7SSlASa8CPpbNbU2fAnkjCsfTtvebmIHhiwqWnyHHGh3s8mrSeCC66G93zLtp8N3
         T3u6SHf69JN2ciSx6CqIrWEoCq6IxqDszPrBY0Houqij28xPRiOxKpmMhFFcali13URz
         Woa7UuAIjwvL1S/OHuvzd5Q8oNk5t44jurI7oTepjMAkQpCYv6Qw5b4NPB4TISbPNuA+
         ZdTrcchShfRKivD/8IA9dAEjGoh/F/++8YDfA0SUmIKLWhKyuAys5wMZ3WfmWrKnP8dM
         3QLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WXBiZ3lMd+Z19YrZpfewJmi1/8g+N72a9+ebtf2jcDg=;
        b=5BPMD56ubCvZTR9r3EEpKMXEVClPF/Fg+oaLIW3gebuzZ8mjbQ0dkw8kOEbt4rqrIA
         1UzfSp2NF8qT49OuoLnNJuuH7KblzJwYmh0i6ywsX1i+RuiJNF2H97c/OM2ncz4HeCXH
         EyEJTOvHKUYsM/q5qqa8xdlxpS7w8f4Iv7+8mxN2hfvHJxXq9m7FeEQuQvwunQNZzFqY
         tWhKI0n3hNFXckFU959AkAw2fi9QOmJcrm3OwHyB9BK0PXGX3vE0wIk5I4rFRBy/anMQ
         AtJiNitR04/ysOBGYrfhEfdo1DX5HT7Z0F7tKrxvZY4eK7wmjQWoYWg5jETRLwgO9RxJ
         by0g==
X-Gm-Message-State: AOAM533Juz3IpIxVBvpF//P6dXU2pU4dt59DEoFo3b6upUVrEAa0dK08
        9+cg5wk0GLEnvqM7UHASZ65OWJ2oOJ9DnA==
X-Google-Smtp-Source: ABdhPJwvJ9hZyMAnm4LbVQbSMEuvCTVUCudQxClPjacvYBdlFGLm1xL/c8EyrseEits29Blc6bjYEA==
X-Received: by 2002:a1c:4c13:: with SMTP id z19mr3408702wmf.154.1632505214618;
        Fri, 24 Sep 2021 10:40:14 -0700 (PDT)
Received: from ?IPv6:2a01:e34:ed2f:f020:fc07:a338:ccc1:8b6? ([2a01:e34:ed2f:f020:fc07:a338:ccc1:8b6])
        by smtp.googlemail.com with ESMTPSA id z13sm9956503wrs.90.2021.09.24.10.40.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Sep 2021 10:40:13 -0700 (PDT)
Subject: Re: [PATCH v2 1/2] thermal: int340x: do not set a wrong tcc offset on
 resume
To:     Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Antoine Tenart <atenart@kernel.org>, rui.zhang@intel.com,
        amitk@kernel.org
Cc:     linux-pm@vger.kernel.org, stable@vger.kernel.org
References: <20210909085613.5577-1-atenart@kernel.org>
 <20210909085613.5577-2-atenart@kernel.org>
 <46d6d30201e11422f57bd79691133dc0491bd4c5.camel@linux.intel.com>
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
Message-ID: <03ba2e41-6ae6-d4ee-ace5-055ac40c1128@linaro.org>
Date:   Fri, 24 Sep 2021 19:40:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <46d6d30201e11422f57bd79691133dc0491bd4c5.camel@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 24/09/2021 18:27, Srinivas Pandruvada wrote:
> Hi Daniel,
> 
> This patch is important. Can we send for 5.15 rc release?
> 
> I see the previous version of this patch is applied to linux-next.
> But this series is better as it splits into two patches. The first one
> can be easily backported and will fix the problem. The second one is an
> improvement.

Yes, it is in the pipe.

I've applied the patch 1/2 to the fixes branch and the patch 2/2 will
land in the next branch as soon as the next -rc is released with the fix
and merged to the next branch.


-- 
<http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog
