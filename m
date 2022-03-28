Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDD864E9C01
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 18:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241514AbiC1QOL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 12:14:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238507AbiC1QOL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 12:14:11 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF6A854186
        for <stable@vger.kernel.org>; Mon, 28 Mar 2022 09:12:29 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id t5so13097451pfg.4
        for <stable@vger.kernel.org>; Mon, 28 Mar 2022 09:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=OYF/jvStaXgJs+lPLO95DLgpFNQWTZE9eUToA1rRs6g=;
        b=e+BGZaz9UF7wurI72M/5D45ULqW3ey6hXKY/Ts68ZgJK+22nFqMUvhRnEdRnUBpuvl
         qPQCU0In4ULU6FrtL4iIXhYl3zMBK19R+WUV7DTPh5cvUw6eRFk7AhjuMWBOTqlyWtQC
         nJKNVvqCmiJ+2LNK54Aq7rTRVFsfPFfRB/v6VG5I9BgHJXzNoHViwd1UmQgMDaSWQXpp
         2CS5wZFjeU2yLm1azU7lY7IbkgKzdX1RwEucQh4Bj2ntyML4fmuRyUdWr6bNzZXduSsv
         B679isvImDqKin6vhmJQq3ouLNW2MPfA9u+B75y+vagvE5heMpuBBBY2due9oOaT3xWM
         w8Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OYF/jvStaXgJs+lPLO95DLgpFNQWTZE9eUToA1rRs6g=;
        b=WybN3e3hdcy0RsoLdCuboqeC2zupOZrJVXMm3GB2l6Hsdf2WoKLxxUdn/uANLK6Uqt
         jvdlMZtewoRhQJ+CHOGSD+2V9+C06s4hjTAkr7Gski0+PXF77N+zHLuHxLXb+9uO4obg
         UKnCM7oiLeJsJ18afIgKOklcGX36fD8Cy+lopl2FLu7lu++pBXHevIkSdGaGuA/4w/A3
         axDN8irfSUDl6ZEIugCLrohBbjOINvvLgVnI0aF45yXN+fiqklSA8IEk1hldC5PBCvRe
         k6qnDaP3c1MHG9DRt6tzyNMMP4vKE6zK0s7NfUlfiepPapupZ4k8JQFsTRCXct30v6MV
         LWxQ==
X-Gm-Message-State: AOAM531k6aBjf07UK2OZtje+QpR4tK0KEAqKaUaDAKp7CFsGI3ntLnTo
        vi5I2m1ZGWFlt2Q4e3P17bzL/uXyz6uWtwNu
X-Google-Smtp-Source: ABdhPJwufdTEwBp0S3JduRuquBjA87WlSM0qhzSDEaHQGglV4NKMddG55IsfZm3xx1Hl90qslp+rzw==
X-Received: by 2002:a63:3fcc:0:b0:398:ae5:6905 with SMTP id m195-20020a633fcc000000b003980ae56905mr10471109pga.463.1648483949404;
        Mon, 28 Mar 2022 09:12:29 -0700 (PDT)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id z12-20020aa7888c000000b004f3fc6d95casm16878011pfe.20.2022.03.28.09.12.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Mar 2022 09:12:28 -0700 (PDT)
Message-ID: <21f3fd84-2de9-646c-4d0c-94007a996c70@linaro.org>
Date:   Mon, 28 Mar 2022 09:12:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2] ext4: check if offset+length is valid in fallocate
Content-Language: en-US
To:     linux-ext4@vger.kernel.org
Cc:     Andreas Dilger <adilger.kernel@dilger.ca>,
        Ritesh Harjani <riteshh@linux.ibm.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+7a806094edd5d07ba029@syzkaller.appspotmail.com,
        tytso@mit.edu
References: <20220315215439.269122-1-tadeusz.struk@linaro.org>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
In-Reply-To: <20220315215439.269122-1-tadeusz.struk@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/15/22 14:54, Tadeusz Struk wrote:
> Syzbot found an issue [1] in ext4_fallocate().
> The C reproducer [2] calls fallocate(), passing size 0xffeffeff000ul,
> and offset 0x1000000ul, which, when added together exceed the disk size,
> and trigger a BUG in ext4_ind_remove_space() [3].
> According to the comment doc in ext4_ind_remove_space() the 'end' block
> parameter needs to be one block after the last block to remove.
> In the case when the BUG is triggered it points to the last block on
> a 4GB virtual disk image. This is calculated in
> ext4_ind_remove_space() in [4].
> This patch adds a check that ensure the length + offest to be
> within the valid range and returns -ENOSPC error code in case
> it is invalid.

Hi,
Any feedback on this?

-- 
Thanks,
Tadeusz
