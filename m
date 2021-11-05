Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3924466DF
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 17:19:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233019AbhKEQW0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Nov 2021 12:22:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232718AbhKEQW0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Nov 2021 12:22:26 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78FC4C061714
        for <stable@vger.kernel.org>; Fri,  5 Nov 2021 09:19:46 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id c4so14538706wrd.9
        for <stable@vger.kernel.org>; Fri, 05 Nov 2021 09:19:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rbAN5/q5aC9W3g+TNBCzDR83qZDPyKlQY+DOynOxaWc=;
        b=VhRTph4H734/VFWv5Yc71JjNDUjDWgs0/IuG/jYe+c8C50wENnseJ+QPDkeHwA/Nue
         3Xbz6x92PZ1BndQkUjML5iQSRz57Exiqd4kboE5ww4Ti3PhYah3rJXKFO3VBZuHPSm5d
         /Vp2YxW1Ff7eL1Hof4VeOgn/6RiT1J2qNZBgTT5dWMbqkoNDUOHmieu/xtNsT+DOfHse
         lp4ngxhcokO09ZxK4RxQit5P3ZgRlqPR9QAcPp8UKoyZIKMT5Ch7QIC8S6CWCGMCMyRa
         K4TrMCiO7ZTy3gyYspywYPzKmkKetTIZYOYIW9iHGu85e53bazQM34oeM0j/mZqmD+Bq
         Zgqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rbAN5/q5aC9W3g+TNBCzDR83qZDPyKlQY+DOynOxaWc=;
        b=M2JxAvmMP4Lrl+6H/x8/eOYXnzBFMcDzqZ7TnhnNNWI0rXWnfZF2OyLnKSEmtCV6uj
         65fUSFBXGH4L3SJHJ5kyDR97XQ/wrsZmYNigxN7fMDQE1QzTdCfr3h3YHGGm29BMGSkL
         Pj6vzl9o2GNcDgdM9dEWAzKCgk00XUQtA/c5UdvAm21pFUo9ApVYUmL9/7QE7p9SeuwH
         oTvSbKPCGtlyaaTnwiugUCNfmiC9mFWDgykdz199ypobPUmWpOitdiwl8ueh7jksoRmW
         PTV38Hjr2QXkZtoylnEAqX7eofAov8Y70K6DNbuC1UaMfPuOBnpYO0yc95TA81cEUlJ3
         7DJg==
X-Gm-Message-State: AOAM533YxrbDAWXo2CARnUsmy2ni6N8SFseevuH9YyLrP2/M2IzEzrEE
        +pK1xRutjG/nIGjnB5lx1ePo8D5LvQkLSQ==
X-Google-Smtp-Source: ABdhPJy4CVexYxHVciN9OvU9Rmn1DM0uKsGgR4pRPBwBd95RUZkv9/fHFHDsW2awhxYolxwd+SzRiA==
X-Received: by 2002:a5d:4575:: with SMTP id a21mr60441042wrc.193.1636129184919;
        Fri, 05 Nov 2021 09:19:44 -0700 (PDT)
Received: from ?IPv6:2a01:e34:ed2f:f020:decd:efcb:adc8:b46? ([2a01:e34:ed2f:f020:decd:efcb:adc8:b46])
        by smtp.googlemail.com with ESMTPSA id x4sm6686432wmi.3.2021.11.05.09.19.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Nov 2021 09:19:43 -0700 (PDT)
Subject: Re: [RESEND PATCH v2] thermal: Fix a NULL pointer dereference
To:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Subbaraman Narayanamurthy <quic_subbaram@quicinc.com>
Cc:     Amit Kucheria <amitk@kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Linux PM <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Collins <quic_collinsd@quicinc.com>,
        Manaf Meethalavalappu Pallikunhi <quic_manafm@quicinc.com>,
        Stable <stable@vger.kernel.org>
References: <1636070227-15909-1-git-send-email-quic_subbaram@quicinc.com>
 <CAJZ5v0gONybD_pVCAq6ZJTMuStXtoF064u9qPYxco4y=b-JD9A@mail.gmail.com>
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
Message-ID: <c7ede029-b75f-e57e-24f1-9633d5d47401@linaro.org>
Date:   Fri, 5 Nov 2021 17:19:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CAJZ5v0gONybD_pVCAq6ZJTMuStXtoF064u9qPYxco4y=b-JD9A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 05/11/2021 16:14, Rafael J. Wysocki wrote:
> On Fri, Nov 5, 2021 at 12:57 AM Subbaraman Narayanamurthy
> <quic_subbaram@quicinc.com> wrote:
>>
>> of_parse_thermal_zones() parses the thermal-zones node and registers a
>> thermal_zone device for each subnode. However, if a thermal zone is
>> consuming a thermal sensor and that thermal sensor device hasn't probed
>> yet, an attempt to set trip_point_*_temp for that thermal zone device
>> can cause a NULL pointer dereference. Fix it.
>>
>>  console:/sys/class/thermal/thermal_zone87 # echo 120000 > trip_point_0_temp
>>  ...
>>  Unable to handle kernel NULL pointer dereference at virtual address 0000000000000020
>>  ...
>>  Call trace:
>>   of_thermal_set_trip_temp+0x40/0xc4
>>   trip_point_temp_store+0xc0/0x1dc
>>   dev_attr_store+0x38/0x88
>>   sysfs_kf_write+0x64/0xc0
>>   kernfs_fop_write_iter+0x108/0x1d0
>>   vfs_write+0x2f4/0x368
>>   ksys_write+0x7c/0xec
>>   __arm64_sys_write+0x20/0x30
>>   el0_svc_common.llvm.7279915941325364641+0xbc/0x1bc
>>   do_el0_svc+0x28/0xa0
>>   el0_svc+0x14/0x24
>>   el0_sync_handler+0x88/0xec
>>   el0_sync+0x1c0/0x200
>>
>> While at it, fix the possible NULL pointer dereference in other
>> functions as well: of_thermal_get_temp(), of_thermal_set_emul_temp(),
>> of_thermal_get_trend().
> 
> Can the subject be more specific, please?
> 
> The issue appears to be limited to the of_thermal_ family of
> functions, but the subject doesn't reflect that at all.
> 
>> Suggested-by: David Collins <quic_collinsd@quicinc.com>
>> Signed-off-by: Subbaraman Narayanamurthy <quic_subbaram@quicinc.com>
> 
> Daniel, any concerns regarding the code changes below?

I've a concern about the root cause but I did not have time to
investigate how to fix it nicely.

thermal_of is responsible of introducing itself between the thermal core
code and the backend. So it defines the ops which in turn call the
sensor ops leading us to this problem.

So, without a better solution, this fix can be applied until we rethink
the thermal_of approach.

Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>


-- 
<http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog
