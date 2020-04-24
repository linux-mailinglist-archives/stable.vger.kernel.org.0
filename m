Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 920151B73BB
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 14:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbgDXMSl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 08:18:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726667AbgDXMSk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Apr 2020 08:18:40 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61618C09B045
        for <stable@vger.kernel.org>; Fri, 24 Apr 2020 05:18:39 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id f13so10481009wrm.13
        for <stable@vger.kernel.org>; Fri, 24 Apr 2020 05:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ipnrAc+3cHuR7HETpLSOZ/5pb3ou/GVUIiWBM3QfP6g=;
        b=oXb1uRcV2TeRQZCyd2HB+GxacyKPmMxcmjkLte3Sr9bBviXfK0IoR739gYNHZ9Yxf7
         DNr0j345PtdEonwsua9UDFDZjp8vGhGAMP/PzLxaAzB0lnkjTqv1AjS+21a7nGBYTxGk
         o8SfE+AnlTC4o0q52FcxEkOFUFrlirhzEY4rs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ipnrAc+3cHuR7HETpLSOZ/5pb3ou/GVUIiWBM3QfP6g=;
        b=oycLVfVAHSpf5PIJqCPF2MUfXfj+AIppMAFVdc8iOI/cG5GT5bS7TQ4tnFoHL3KBss
         CQVWfO61oWgvFMGs0Xj+kbwyh/vm0wDa6dAssm/WUgl6OIDDXSRZHMqpKhQmXVJp64J0
         sf7KmnUZ2yIgnnY3hwN8APnDdrSS0BjsnEeE5X6bWAbOTR2Tr8vXg7tDTNcvTYcA3g61
         /3/0ShYCO0pEyKSunPdwxhnlT0VkgnkIz+f/KeexbDtBWHEcTGAUQZsFqq7xR45j6uWk
         uRmJ1Eo/DD+vWfF60ROml205JQaCV4buWE+umtQMQtFpLY/KUpP84/g6kf1aCxBsKfyU
         RVuw==
X-Gm-Message-State: AGi0Pubrw1UmH4EQjNpspBEsxPMVqWt/9abXP9FNM5skRxNKAiXj9Awh
        G7k4cFfn0mUl0iNLXOJAgT+KhQ==
X-Google-Smtp-Source: APiQypK3jlRPBnbzBDYDGr5uzrtczZ4y7sMSF3ZqM2froUtG5ZL3FCYUnhBNyfri73DaJTjbZ/jiHQ==
X-Received: by 2002:adf:e5c7:: with SMTP id a7mr11138306wrn.241.1587730718065;
        Fri, 24 Apr 2020 05:18:38 -0700 (PDT)
Received: from localhost ([2a01:4b00:8432:8a00:56e1:adff:fe3f:49ed])
        by smtp.gmail.com with ESMTPSA id p6sm8083667wrt.3.2020.04.24.05.18.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 05:18:37 -0700 (PDT)
Date:   Fri, 24 Apr 2020 13:18:36 +0100
From:   Chris Down <chris@chrisdown.name>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Linux MM <linux-mm@kvack.org>, Roman Gushchin <guro@fb.com>,
        stable@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm, memcg: fix wrong mem cgroup protection
Message-ID: <20200424121836.GA1379200@chrisdown.name>
References: <20200423061629.24185-1-laoar.shao@gmail.com>
 <20200423153323.GA1318256@chrisdown.name>
 <CALOAHbDpvRZWcaoKBs2ywJFSY0MXT-WEe6wZTR=ed4-85Ovcgg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CALOAHbDpvRZWcaoKBs2ywJFSY0MXT-WEe6wZTR=ed4-85Ovcgg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Yafang Shao writes:
>If the author can't understand deeply in the code worte by
>himself/herself, I think the author should do more test on his/her
>patches.
>Regarding the issue in this case, my understanding is you know the
>benefit of proportional reclaim, but I'm wondering that do you know
>the loss if the proportional is not correct ?
>I don't mean to affend you, while I just try to explain how the
>community should cooperate.

I'm pretty sure that since multiple people on mm list have already expressed 
confusion at this patch, this isn't a question of testing, but of lack of 
clarity in usage :-)

Promoting "testing" as a panacea for this issue misses a significant part of 
the real problem: that the intended semantics and room for allowed races is 
currently unclear, which is why there is a general sense of confusion around 
your proposed patch and what it solves. If more testing would help, then the 
benefit of your patch should be patently obvious -- but it isn't.
