Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB5C5B9047
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 23:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbiINVuY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 17:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbiINVuA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 17:50:00 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4506886C3E;
        Wed, 14 Sep 2022 14:49:25 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id d1so12840071qvs.0;
        Wed, 14 Sep 2022 14:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=Mlq5OwfkX5sats/uQxVfRjfC54o1+5/BBTIbC7sExTw=;
        b=P3WGL6HCwe/FzqQsrWKuwfxcBDAlRww2qK0jhR+mku7xO5FefjqI3YV/S45RrCGYic
         zlp1QXwJQ3dkDyGXhUdaS/4XLlxPu8cByv2aTUjI8oBCLzTmVnMrQ4nZ73QRVkD/pgFe
         ftkNtBgIcmXghkDDZYtm+anbDLdL8vVUNl413qi0ZKaVboNAI+7dGZ6RqQdMjSY8m/dU
         hn9JNouatEN96CeASzDsvS8lFfI2spwl6dWYJmAqvrQpU8N8YZjy8HfnbBNxZMJWsguV
         O9nft+cNwareLKke28PWKR5jpG3zWQUpB1+4XY1wT/KjaizWCYiZiAwzv2VG/ud2N7Qp
         SxoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Mlq5OwfkX5sats/uQxVfRjfC54o1+5/BBTIbC7sExTw=;
        b=NOufOfckh3NQSs1Gs6WzKWVm6dzfwodJKGRAourUiArghoOtkrKeFkJ1T4H7S13PoS
         Tt4KIxFB+u+uw43DzDidEb3x6XhRPhToS9qoaDeE7a1OBOeKPezZgsjRe8Rv2k584zil
         hCk7bBnFSPieMDFcMPYPSFbGrqkUWGXe4vR34mbbCbNp0IIt0Z7dObMLj46yR6dFI7NJ
         Wr2lFdLP3u7S2VJ2ss5MZXbknzbowKYl6jK1AupwNGtl1g9kKg67IFHZTbs4EgaeButK
         XDsYG7dp3KfiUfAxCkHEY2AcnIuHhjlrE5RPa7gCvgPT3T+FJ1Te62k9m3EK1hlGQv6N
         MMqg==
X-Gm-Message-State: ACgBeo1o+k9fCLNRsejS/JdnqJS/jQUr2dme4OlwWJHMRDeu++NuYOoE
        s9+mPBPNm36HJctxUCPWK78=
X-Google-Smtp-Source: AA6agR6y47JUxStZNmYwod7Tq6rTP+tvukyIGB2+Dioe5mB7f+v7zD8s97UyJ8TO9u81hWK23L9qfA==
X-Received: by 2002:ad4:418b:0:b0:4aa:3b02:dba6 with SMTP id e11-20020ad4418b000000b004aa3b02dba6mr33169789qvp.7.1663192163932;
        Wed, 14 Sep 2022 14:49:23 -0700 (PDT)
Received: from [10.69.40.226] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id az31-20020a05620a171f00b006af0ce13499sm2811924qkb.115.2022.09.14.14.49.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Sep 2022 14:49:22 -0700 (PDT)
Message-ID: <efd8008a-6b81-ff4c-f0bd-4f957f00295e@gmail.com>
Date:   Wed, 14 Sep 2022 14:49:20 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH] mm/hugetlb: correct demote page offset logic
Content-Language: en-US
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Mike Kravetz <mike.kravetz@oracle.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Oscar Salvador <osalvador@suse.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20220914190917.3517663-1-opendmb@gmail.com>
 <20220914134927.16c229ccdc1a6b9da5d698c3@linux-foundation.org>
From:   Doug Berger <opendmb@gmail.com>
In-Reply-To: <20220914134927.16c229ccdc1a6b9da5d698c3@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/14/2022 1:49 PM, Andrew Morton wrote:
> On Wed, 14 Sep 2022 12:09:17 -0700 Doug Berger <opendmb@gmail.com> wrote:
> 
>> With gigantic pages it may not be true that struct page structures
>> are contiguous across the entire gigantic page. The nth_page macro
>> is used here in place of direct pointer arithmetic to correct for
>> this.
> 
> What were the user-visible runtime effects of this bug?
As Mike said this would only conceptually be a problem for systems with 
CONFIG_SPARSEMEM && !CONFIG_SPARSEMEM_VMEMMAP, and could cause kernel 
address exceptions or memory corruption with unpredictable side effects.

However, I am unaware of a system other than perhaps the PS3 that uses 
the classic sparse addressing, so the odds of such a system also using 
gigantic hugetlbfs pages that it wants to demote is likely quite small.

Thanks,
-Doug
