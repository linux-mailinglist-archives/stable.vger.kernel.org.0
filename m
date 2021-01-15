Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A745A2F70B2
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 03:45:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728705AbhAOCpx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jan 2021 21:45:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727293AbhAOCpw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jan 2021 21:45:52 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 722DAC061757
        for <stable@vger.kernel.org>; Thu, 14 Jan 2021 18:45:12 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id c22so5051430pgg.13
        for <stable@vger.kernel.org>; Thu, 14 Jan 2021 18:45:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XxBa9myEMoly4f0Ku1j+lmGwFi3yYwt6WDu7BUfWd9U=;
        b=ER9Uf4WaTCzHexGcXkkYlNipY9MtGhtjteu3ldUnv8IxoErutHcTuIH1klUfnLvT8D
         9OjsHr+E5yomDWiy7ekEMWlck9vBxXhFRSWSnwEBpHv272f6CfSiPJISn/l8y61hzLrz
         yxWcCHwe21NzRekJcYTk5wVOHX29annAe2Skx39/qiddkRA2Fph7m7XA6YyMbixwcJlN
         BHuNW7c+1KuaofRGSvblC3w1YmkBR6TkjCSje4OrdirunWaiY2dE99q4Cpykfrzffzwm
         PLtnhOuaek8lp6CIbY0DtTx4BjLaaEptZsgqHstY75JK/2Hpwp4+tI9dE1iLbC5G+mJE
         YqPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XxBa9myEMoly4f0Ku1j+lmGwFi3yYwt6WDu7BUfWd9U=;
        b=W4CRaLmDqsO1InhLGtyfaJWqKgBU1SEG4cXKqRKFQt9k4am23MZo3twJ4GiwS28O3O
         cz/K7aY6R2oGtByYzq1wvARtLsJmAobfsMXwwB+tkVF+2cv7bD41z+maBZ2R+4cQSAx0
         0cLtcRcqZGrjdb7xqXrjQmYLhdqTffl/bsXQ/ss1ujKXL9AVw/tz0kuqfxeiBMv+TpyK
         EiXQCZto3Qn5RioBaxvlU70wG5M053CNciw9VuIFByysXsMv+ex2iKIUL4HXRFNTJiyI
         bk0GhVV3IJftB7/uM00aTb3qfUdceSDR3p68H4K1dOJFkdw4dl5PSAx6/IhHES7suU4F
         DE1Q==
X-Gm-Message-State: AOAM533fKuu3qdnxZocPC99wVf/7nLL5vs1aIMELZstK0yOpChd9ijuI
        i0HEycQcf7jIxwhc2vnW503e7Q==
X-Google-Smtp-Source: ABdhPJwwvcONy/p8iJ/5ga853zBIAmVrW51BeELzMGnDFah+dAX0cppdwJPI+zn8zeNoR5EWWonFZA==
X-Received: by 2002:a62:303:0:b029:1a5:a6f7:ac0d with SMTP id 3-20020a6203030000b02901a5a6f7ac0dmr10458196pfd.63.1610678711775;
        Thu, 14 Jan 2021 18:45:11 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id b197sm6294194pfb.42.2021.01.14.18.45.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jan 2021 18:45:11 -0800 (PST)
Subject: Re: Fix CVE-2020-29372 in 4.19 and 5.4
To:     Sasha Levin <sashal@kernel.org>, Saied Kazemi <saied@google.com>
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        Vaibhav Rustagi <vaibhavrustagi@google.com>
References: <CA+Um-ghfTG=+x8iT-uPikM7NNsN1J6CCiztxsBgQ9OJPUBQjyg@mail.gmail.com>
 <20210115024330.GW4035784@sasha-vm>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7c22b3d8-0f33-19b5-feeb-db0c684a6c35@kernel.dk>
Date:   Thu, 14 Jan 2021 19:45:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210115024330.GW4035784@sasha-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/14/21 7:43 PM, Sasha Levin wrote:
> On Thu, Jan 14, 2021 at 05:55:13PM -0800, Saied Kazemi wrote:
>> Hi Greg,
>>
>> To fix CVE-2020-29372 in COS kernel versions 4.19 and 5.4, we
>> cherry-picked the commit "mm: check that mm is still valid in
>> madvise()" (bc0c4d1e176e) that Jens introduced in kernel version 5.7.0
>> into our kernel sources.  The commit is small and the cherry-pick was
>> successful for both COS kernels versions.
>>
>> Because COS 4.19 and 5.4 kernels track 4.19.y and 5.4.y respectively,
>> can you please cherry-pick the commit to those stable branches?
> 
> 5.4 didn't support IORING_OP_MADVISE and 4.19 didn't have io_uring to
> begin with, how is this an issue on those branches?

Good point on 5.4, I didn't even think of that. So yeah, doesn't seem
like it's applicable to any of those kernels?

-- 
Jens Axboe

