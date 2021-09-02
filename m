Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0888A3FF34C
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 20:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346986AbhIBSi0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Sep 2021 14:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbhIBSiY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Sep 2021 14:38:24 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69DA9C061575
        for <stable@vger.kernel.org>; Thu,  2 Sep 2021 11:37:15 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id u11-20020a17090adb4b00b00181668a56d6so2143572pjx.5
        for <stable@vger.kernel.org>; Thu, 02 Sep 2021 11:37:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=squareup.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aIWjYpBOUYzVzaVlUDHdrgyjE4CFE+gBvpcecdsULzo=;
        b=NV6f8kZoTYuzX/tEjhOIkZ4cpIS/VfQdeKinotKC8ZjhsAiCS16sCfz/4yzYlaqFQF
         RSPN7uJMPJxNdjDhFRR/hTOsQX8yJjYahr3+R0eLgd0uhiqDFnODPmNmVo0C5eHuuDqI
         S43I6WjyS7OB4O/Bo/iLeBKjd+PyN4mD2xfUI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aIWjYpBOUYzVzaVlUDHdrgyjE4CFE+gBvpcecdsULzo=;
        b=k+DtC2miq4n6wq0lXe4HIei015ewGqB3QzeulZZgvKGC4jgCvS7nrBw8Hs9mWwf+PN
         j27sdURC45z1lHmqyZfCUDRy8I0BRR/uTYXZriu45NQcz2rHN1NmTicnOJlBYvayCoga
         5OX5cm1tGOBIyD8go823EZrAz/VIraVAFrWMA6fP2uueUNla6ratzGQ1onpqI4BwjBJ/
         TQdND0A6hfjeLCE/Cj1/l643YNq/7x34nzFVH6Q/YkAPnom40GhSlUSi+yyPlFA+cQPR
         poXxGwJEZGtoUIiPDPuxd521k3+ek9r84pxvhJsbX+eBukkwa6KjdCpGb6fjcNCY0esQ
         trHw==
X-Gm-Message-State: AOAM533wJUcLOJV8nDp2EI7aHZV0inIolELFgG9PwI2na66bz2q9Anh4
        4EhKpDmkzaov6oAq5E98GJdiXtF8HxXWIQ==
X-Google-Smtp-Source: ABdhPJwkIh9FL7oKT+VZsNlyxhEYjWCIOxTFKVBxQ+EOwMADJ3K/P9pveiCVJlUMeAwnHQfsTZCapg==
X-Received: by 2002:a17:90a:6507:: with SMTP id i7mr5390673pjj.205.1630607834855;
        Thu, 02 Sep 2021 11:37:14 -0700 (PDT)
Received: from benl-m5lvdt.local ([2600:6c50:4d00:2376:7473:9ba9:f43f:3a4b])
        by smtp.gmail.com with ESMTPSA id j14sm2895983pjg.29.2021.09.02.11.37.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Sep 2021 11:37:14 -0700 (PDT)
Subject: Re: [PATCH v2] wcn36xx: handle connection loss indication
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Bryan O'Donoghue <bryan.odonoghue@linaro.org>,
        Loic Poulain <loic.poulain@linaro.org>, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210901180606.11686-1-benl@squareup.com>
 <8735qn2ats.fsf@codeaurora.org>
From:   Benjamin Li <benl@squareup.com>
Message-ID: <3a587de2-f605-fd17-4d70-878b13354b39@squareup.com>
Date:   Thu, 2 Sep 2021 11:37:12 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <8735qn2ats.fsf@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/2/21 9:37 AM, Kalle Valo wrote:
> Benjamin Li <benl@squareup.com> writes:
> 
>> Firmware sends delete_sta_context_ind when it detects the AP has gone
>> away in STA mode. Right now the handler for that indication only handles
>> AP mode; fix it to also handle STA mode.
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Benjamin Li <benl@squareup.com>
>> Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
>> Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
> 
> How well is this tested? I'm pondering should I queue this to v5.15 or
> v5.16, at the moment I'm leaning towards v5.16.
>
It was an issue reported during internal testing, and the patch has not
yet had soak time with our quality team/field devices. v5.16 sounds fine.

Ben
