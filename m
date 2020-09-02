Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C08A25AE2E
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 17:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbgIBPAb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 11:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727112AbgIBNvv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Sep 2020 09:51:51 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B2A4C061258
        for <stable@vger.kernel.org>; Wed,  2 Sep 2020 06:41:47 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id h4so5783964ioe.5
        for <stable@vger.kernel.org>; Wed, 02 Sep 2020 06:41:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uGk7KDEbX5F6v/izFfZdYkNkgWTbNPRwzL1S1Uk1DQM=;
        b=NkBTQ6j/9NYFv7XkGKIGdPL3xNnkxkYDEEmYW9rd/guUtvCBmuKLAqhsLHWgSuGpff
         zDbycLzApdRkUndzxfiJa/uqz+LE7QfS/OjUJ45bwaEXqufgSaORDyAjxrtvi6EN5Q7O
         +vygUaCBSrrYugs9VY82KzHnC5zY5AZ7+pMjByTKkenaQpuY/UhSxQF3np9Dz2TStxKX
         6DXkZht/Y+eBlpHnqH+/d+ug11KneqJaxC/LgxphsEEvF1FG7+X4tKTSHbkJHvrnrVXZ
         BJwzkwMnLl6b2tLgAyE1oFWnAv0uGbGIPr94ZzMZiKgO0CEEsz4AhNgJ6qRxys/sXnJP
         Pj9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uGk7KDEbX5F6v/izFfZdYkNkgWTbNPRwzL1S1Uk1DQM=;
        b=ayTUtCLyLna9NUAPzN7VzP0x0G4A0jBNI51vnVBNYucOpSQ5tr+PAe1121uLG70yFz
         Qyu9Z8UQU8riapfkk96SnLV72yPSP3bJdbLZX0ejCSvnzB2nkJyO9utcykZS0aNVWIa4
         nogyxmDdZAxa3dS7rZERxBdbgF82SpNCfr5lNXxepHRnU7bULo1AsK7nAt2uI7N00k92
         chWJoNcCmj1/LKuWGzCI4/zyOZPTjsfnOykcGHyCoGtje4RXXnzzTBNYrxYilgzvJb5M
         fQEwFO1u7SmUrq5LLEUmZd3KX2/06lX97vTJaOIxrq7K89n9xf8X1z6poVIlfawBSwvc
         IMQA==
X-Gm-Message-State: AOAM53194Fy/jeY+yy85xzC2g92UbFz+tuOUeV4RT0gOtQj6o3pOdx4V
        RW4RDIuJrmCuCaOrJEsaz/GRF2NGq84exp35
X-Google-Smtp-Source: ABdhPJwkeUOxDVN+VRkUwfkb6FOMFR6yeEnzSMRruxSsveQPjgw3MD3yC6I718YxoT4ieX0h58rEnA==
X-Received: by 2002:a02:85e1:: with SMTP id d88mr3372903jai.8.1599054106073;
        Wed, 02 Sep 2020 06:41:46 -0700 (PDT)
Received: from [192.168.1.57] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id z72sm1991260iof.29.2020.09.02.06.41.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2020 06:41:45 -0700 (PDT)
Subject: Re: Fwd: [PATCH] io_uring: Fix NULL pointer dereference in
 io_sq_wq_submit_work()
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
References: <20200902015948.109580-1-yinxin_1989@aliyun.com>
 <be051730-4ffe-0907-65c3-ace0ce070e09@kernel.dk>
 <20200902072809.GB1610179@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6d76855f-612b-ad7c-0e45-8d94e9dca63d@kernel.dk>
Date:   Wed, 2 Sep 2020 07:41:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200902072809.GB1610179@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/2/20 1:28 AM, Greg KH wrote:
> On Tue, Sep 01, 2020 at 08:12:52PM -0600, Jens Axboe wrote:
>> Hi,
>>
>> Can you queue this for 5.4-stable? Thanks!
> 
> As I need to do a -rc2 for this version, I've now queued this up,
> thanks.

Great, thanks Greg!

-- 
Jens Axboe

