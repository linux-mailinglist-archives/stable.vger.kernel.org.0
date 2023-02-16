Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 519A5698A5C
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 03:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbjBPCI5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 21:08:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjBPCI4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 21:08:56 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A033581;
        Wed, 15 Feb 2023 18:08:55 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id dz21so800115edb.13;
        Wed, 15 Feb 2023 18:08:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aaKShNdcWyXyeDSV5HBlqg0juORhWBEGTLU+Kq7Wvwg=;
        b=dZi8CT3QjpJnu+IscI3MxBQ/5/qL7nH0ZElRAlezkLSTC50TlcW1AzI0WdBtuck2Fk
         5Pxxd7P7gjeOx1IQf8cI61G1NvIC/dQ1jBWYx/159mHGt4i1aL0mjOV2YT6et6GQOOaJ
         PCnCipcrrlgXz86hsGj/7Ap4BeiGhFHXeKN/kxDmkU+vkww+6vBsrRq00Zi3jnV8dmXU
         F1qSu+xMN7/UTv56TEPgFpIaNbcrVhTp5DYFC+yQvPspbRkk90xwnn7L13ZuexIAJiMv
         JF6J+jTCqkC59mWAH3Rpyb+wRtmKp0eGj7WZjqfgpNDdeg/jNAeF2ZXdFXS+fQnGCriM
         wvQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aaKShNdcWyXyeDSV5HBlqg0juORhWBEGTLU+Kq7Wvwg=;
        b=txNCR6WU/bJhS33vLcEgE5pnntAcaE+yIFsSPKgLMAG0/PKaZtsgjegpidXo8yvAGK
         eRRgMl7mdK7divswa+1xRhJeTGRYsXdK2FsGEwbpyerMoskGegjdjr4igwxHWO3q0Kch
         clu0u+OyvYyqCmrjR7tNej6s5M4ugQ0N5dG1A622Ic/8/jao0Uz7uINKJZqJOO0XD6jq
         r05mABf/UvMWuTNbvrPQbZOqBe5TccvyqYE1hG5KLI4w4G7FZ3En0nMBuLw+giBWEeHB
         g9m+FjF3nuzo/aIG0t4b8j5krjXen8vMK79FP2bC7HQH3AasSkaq1e52uIgBus+QoR+M
         Vnzw==
X-Gm-Message-State: AO0yUKVvouQhz35ozcF6QCyNjWb7gpNEDs1vzlUvNn/4HqhAu5vqumQF
        pqPz9hxhfXuLvOR08f7OOODsxFTmUjdh9GMm
X-Google-Smtp-Source: AK7set+JDyiia5Voce5GLKkLct2+Yzvfa9sU0a5lIhUqlFhpUAwkMC/Ed2BUbnRftHWhwmHUZBMLbw==
X-Received: by 2002:aa7:c44e:0:b0:49d:a60f:7827 with SMTP id n14-20020aa7c44e000000b0049da60f7827mr4812709edr.6.1676513334253;
        Wed, 15 Feb 2023 18:08:54 -0800 (PST)
Received: from smurf (80.71.142.58.ipv4.parknet.dk. [80.71.142.58])
        by smtp.gmail.com with ESMTPSA id n19-20020a509353000000b004aacec09ca6sm163389eda.42.2023.02.15.18.08.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 18:08:53 -0800 (PST)
Date:   Thu, 16 Feb 2023 03:08:21 +0100 (CET)
From:   Jesper Juhl <jesperjuhl76@gmail.com>
To:     Mike Kravetz <mike.kravetz@oracle.com>
cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Muchun Song <songmuchun@bytedance.com>,
        Andi Kleen <ak@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] hugetlb: check for undefined shift on 32 bit
 architectures
In-Reply-To: <20230216013542.138708-1-mike.kravetz@oracle.com>
Message-ID: <e722a4bb-96fb-db3d-6182-63eaed2d9066@gmail.com>
References: <20230216013542.138708-1-mike.kravetz@oracle.com>
User-Agent: Alpine 2.26 (LNX 649 2022-06-02)
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,MALFORMED_FREEMAIL,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 15 Feb 2023, Mike Kravetz wrote:

> Users can specify the hugetlb page size in the mmap, shmget and
> memfd_create system calls.  This is done by using 6 bits within the
> flags argument to encode the base-2 logarithm of the desired page size.
> The routine hstate_sizelog() uses the log2 value to find the
> corresponding hugetlb hstate structure.  Converting the log2 value
> (page_size_log) to potential hugetlb page size is the simple statement:
>
> 	1UL << page_size_log
>
> Because only 6 bits are used for page_size_log, the left shift can not
> be greater than 63.  This is fine on 64 bit architectures where a long
> is 64 bits.  However, if a value greater than 31 is passed on a 32 bit
> architecture (where long is 32 bits) the shift will result in undefined
> behavior.  This was generally not an issue as the result of the
> undefined shift had to exactly match hugetlb page size to proceed.
>
> Recent improvements in runtime checking have resulted in this undefined
> behavior throwing errors such as reported below.
>
> Fix by comparing page_size_log to BITS_PER_LONG before doing shift.
>
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> Link: https://lore.kernel.org/lkml/CA+G9fYuei_Tr-vN9GS7SfFyU1y9hNysnf=PB7kT0=yv4MiPgVg@mail.gmail.com/
> Fixes: 42d7395feb56 ("mm: support more pagesizes for MAP_HUGETLB/SHM_HUGETLB")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>

Looks good to me.

Reviewed-by: Jesper Juhl <jesperjuhl76@gmail.com>

