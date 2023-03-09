Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E56FF6B1913
	for <lists+stable@lfdr.de>; Thu,  9 Mar 2023 03:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbjCICJo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 21:09:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbjCICJl (ORCPT
        <rfc822;Stable@vger.kernel.org>); Wed, 8 Mar 2023 21:09:41 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83088B7883
        for <Stable@vger.kernel.org>; Wed,  8 Mar 2023 18:09:14 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id q23so209044pgt.7
        for <Stable@vger.kernel.org>; Wed, 08 Mar 2023 18:09:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1678327754;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gfu/KwFVzc/Mhm/dGygFGmdSj7EneRyv1RVogBuDfAE=;
        b=dXMSkm5QFUg2hsGRa4whtQxI5kX2Yob0l1M6NHTCTBKyk2aDxjuGjsxDmsf/VsT3yt
         +vBaQBn4wAy2wTV2IJXgtXZiBox6aLuDUBb9j9YM/MrO3dCXownD0aFUkxxlUjxI/QfN
         N50mjt9fjA9WUydgKZQqk7JZYjVsm3bYr3KZOD+9pHN6rxqTA8pS5SfyLdfBN6XV0gQ2
         C0K5A8ib0AycdBrxr+2pVK008q4e4+7oWZazp9mA8kTIjvGt/efb84Ic4T0njNXzIHqX
         OH8bOX4H5UjfLBTC6pTO69QtOwIO/7N9nNPL9fcPBDBcIOzmk+Olb8oiKbghyJRZiLHQ
         Tpjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678327754;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=gfu/KwFVzc/Mhm/dGygFGmdSj7EneRyv1RVogBuDfAE=;
        b=yDOMnWpKWrPOMbIrJY/Pc+Dqk/M5+6ellExVHBpqM+2xYJuB4LfsLcwuKDVyRGjhC0
         6/7puXUTwXQcTE1yynqRZJ4m1Kyy5DbGRvvqqFfVjgNBplrddbAtCDzRwJjcyu50Ew/W
         Zpr784wlmvyhIH4sgXE13wfw9myIqLjt5QT2NjyvC8E/sN8cS2Y04k8mDAxGSZwQBsbZ
         U1zvppmfLtYlJ2qz/opzp1UNnlDMke0F7QbdkxpBEBHfCc1kTAp8SszSRTXvO10S/bdX
         OoMFBg4a8c+FksaAOGSLXK+efVWu9oUreAG+yL1YxircF2CCmEcuwIlNQ+k4ZHJ6+bgO
         JKFA==
X-Gm-Message-State: AO0yUKX1K0t4NMtqc6QKB2cUDU0hgcNnbrMn4rbh5EMhUuKf0Eh3DWEi
        7O1vKHD0jk1uHmD/cb998qoWng==
X-Google-Smtp-Source: AK7set+ABtdw3r8PqslQtAfmOu77yAOxg1w+6Hbo5FZcHMgjcM9JtbFcCj6g9bdZOqW8uRINlX9Z4A==
X-Received: by 2002:aa7:9ed1:0:b0:5e0:316a:1fef with SMTP id r17-20020aa79ed1000000b005e0316a1fefmr14444906pfq.15.1678327753983;
        Wed, 08 Mar 2023 18:09:13 -0800 (PST)
Received: from [10.200.11.19] ([139.177.225.234])
        by smtp.gmail.com with ESMTPSA id j19-20020a62e913000000b005ae02dc5b94sm9996356pfh.219.2023.03.08.18.09.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Mar 2023 18:09:13 -0800 (PST)
Message-ID: <0db9e2b9-e5ed-e817-bd3f-9812fd914c97@bytedance.com>
Date:   Thu, 9 Mar 2023 10:09:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH] maple_tree: Fix the error of mas->min/max in
 mas_skip_node()
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Liam.Howlett@oracle.com, snild@sony.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
        Stable@vger.kernel.org
References: <20230307160340.57074-1-zhangpeng.00@bytedance.com>
 <20230308175552.60b3f6a3efda2289dc6c5bc9@linux-foundation.org>
From:   Peng Zhang <zhangpeng.00@bytedance.com>
In-Reply-To: <20230308175552.60b3f6a3efda2289dc6c5bc9@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


在 2023/3/9 09:55, Andrew Morton 写道:
> On Wed,  8 Mar 2023 00:03:40 +0800 Peng Zhang <zhangpeng.00@bytedance.com> wrote:
>
>> The assignment of mas->min and mas->max is wrong. mas->min and mas->max
>> should represent the range of the current node. After mas_ascend()
>> returns, mas-min and mas->max already represent the range of the current
>> node, so we should delete these assignments of mas->min and mas->max.
>>
> Please fully describe the user-visible effects of the flaw, especially
> when proposing a -stable backport.
>
The fixes made by this patch have been included in 
https://lore.kernel.org/lkml/20230307180247.2220303-2-Liam.Howlett@oracle.com/, 
so please don't pay attention.
