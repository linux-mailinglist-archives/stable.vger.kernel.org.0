Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80B83435E3C
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 11:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231584AbhJUJuL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Oct 2021 05:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231510AbhJUJuJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Oct 2021 05:50:09 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 152A9C061753
        for <stable@vger.kernel.org>; Thu, 21 Oct 2021 02:47:54 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id i12so91810wrb.7
        for <stable@vger.kernel.org>; Thu, 21 Oct 2021 02:47:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XadkKCF+wV138kwTeCAUa71Wp+zjjghTUBD5n8qyJ3o=;
        b=vCnRk55XlrmoNag8L4eE4OP5pTxlQeKLyDStTyre+G/mZ015gh3RFKNllD2AM06iVK
         NecmpCp53+97rHRp/UeROCm6LOe85L7m7tcdnw4hxiUClC3JU4Wb1RRtuXMJ4cMYMv7F
         YXMWMXXDl2U8jO7l4nv37l2BolgMjiCNu85g9yXcWViVYqacuB1U3I62TSnMtWIkwjuW
         7MoxZes/idTP+9TrO1XSAsQC4jKVHNT9Wmy/OMgwo1s5nAF7iUf2594PS1yXNbylRqjK
         nzkV/rjKJO1Bq9gZ26Vi4f4JTMuLoVnsp5PpE7ItJ/a/nOZMHIihK29LczTioo5qCeOc
         IiwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XadkKCF+wV138kwTeCAUa71Wp+zjjghTUBD5n8qyJ3o=;
        b=QQ9CHPC3RwEbDX9Lh9T65TMXyI8HOPebPXehkP1PNa30/MD+EXpmK+TSojk5J6GMT9
         Lxe54t+ouvh+voPynmzFObAvGsd12NaQ4SguKxPKvBygJKtncClNEVR1pRagVRexgGxO
         bTLGZWjpCwNO0EUkg9vpegUCs+VuLOiVsUxY5t+DbITwWP69V+S6GGDQrx4QV0rPI8mf
         F+FhSSeYHxkBnOQWl8c/rNMbBraf/fCJy89XxswAu0rJVL6CA1OT4dLu+iWm/46gIALr
         n4OnxjVbiowhWVuE0JjtHvW+PlIOlDs6OQLyty3IDuTmiH5pydN7C1upoJO6bD2rNPjQ
         g6FQ==
X-Gm-Message-State: AOAM531YpfkaxpC+4rQrwL4AfrtfdCp/kv2m22kDlaoBmncwldp4YbrS
        2OYiI791D9jfk9viCht5zRshd/F40/Qo3Q==
X-Google-Smtp-Source: ABdhPJy85qKksNAHDgkEio4m0WEXhx6hopVAVLyvANcGd0dfC1rwFZ/VeyGaGNi6wVvXb0MgQMJ/RA==
X-Received: by 2002:adf:bb81:: with SMTP id q1mr6015252wrg.119.1634809672508;
        Thu, 21 Oct 2021 02:47:52 -0700 (PDT)
Received: from ?IPv6:2a01:e34:ed2f:f020:2a2c:7ed:66a0:d637? ([2a01:e34:ed2f:f020:2a2c:7ed:66a0:d637])
        by smtp.googlemail.com with ESMTPSA id d9sm4357338wrm.96.2021.10.21.02.47.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Oct 2021 02:47:51 -0700 (PDT)
Subject: Re: [PATCH v2 1/2] thermal: int340x: do not set a wrong tcc offset on
 resume
To:     Antoine Tenart <atenart@kernel.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        amitk@kernel.org, rui.zhang@intel.com
Cc:     linux-pm@vger.kernel.org, stable@vger.kernel.org
References: <20210909085613.5577-1-atenart@kernel.org>
 <20210909085613.5577-2-atenart@kernel.org>
 <46d6d30201e11422f57bd79691133dc0491bd4c5.camel@linux.intel.com>
 <03ba2e41-6ae6-d4ee-ace5-055ac40c1128@linaro.org>
 <163473710782.3319.6254396851923671939@kwain>
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
Message-ID: <d698f116-bb2d-e6ff-31a3-29cd0adf11d4@linaro.org>
Date:   Thu, 21 Oct 2021 11:47:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <163473710782.3319.6254396851923671939@kwain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 20/10/2021 15:38, Antoine Tenart wrote:
> Hello Daniel,
> 
> Quoting Daniel Lezcano (2021-09-24 19:40:13)
>>
>> I've applied the patch 1/2 to the fixes branch and the patch 2/2 will
>> land in the next branch as soon as the next -rc is released with the fix
>> and merged to the next branch.
> 
> I don't see it in thermal/next even though patch 1 has made it. Not sure
> if patch 2 has slipped through the cracks or wasn't pushed yet. If it's
> the later, please ignore this mail.

Indeed, I thougth I picked it but it wasn't.

Thanks for the head up, it is applied now.

  -- D.


-- 
<http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog
