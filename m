Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 949DE432FA5
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 09:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234517AbhJSHhp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 03:37:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234511AbhJSHhp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Oct 2021 03:37:45 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E520C061745
        for <stable@vger.kernel.org>; Tue, 19 Oct 2021 00:35:32 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id v17so45902678wrv.9
        for <stable@vger.kernel.org>; Tue, 19 Oct 2021 00:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LsN013nKThqaG548oxT8eN2kEk6pmD1K6/Ot7iQ/bYg=;
        b=V9zsPhXNAitiduGUsElE8qwd9XM0yA3jgolBcw22hm/Gi+HYdMI+ynf/ql+EMgtSVa
         EzpbRqmfXb8+0iq/Tsa8jMixolAJKQNStQg/W+j8mbA2o47ic4UR+d7xc8sxKzcpb7sc
         JfJNkh9wPihx8z1tRClzTgL9QuZsxEBLe+Nfj7s1cParBnZi48QaiocwH6SLHaG9v64Y
         cXT0BnzrgmljRgo/GMIK9+c/fDkZwMeUEOZ10iP9ckSYCf11iQmbM5GoL23E4tEec3A1
         ciZoC8yCvtQ2Lv6bILVzpzhCEZXikFw56z+YJfD2SafVH7RktP78C9PTMoEa1ANfPG4R
         jAJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LsN013nKThqaG548oxT8eN2kEk6pmD1K6/Ot7iQ/bYg=;
        b=6VdPjsd1C8u/5HB2w5rOY4UVGuw+s8SNajHl23PXA1YUuAxkIhuFSVAiCqvIxmD7f0
         e0+EK0fgRFN+OQJQg8mXTc5A+8+14vb7yUydUOgReOdU0gkRco1aJg1qLMQZfpQwAq/p
         W5Ck8NGxaUyvLdPTSav4X+rSKRRk4wwn9Nvp83ZizqaYW/LXII/jfyDEe3Q4VX4JPfvn
         WKwImdUxNgzwpLPMhr5vvjSLyc8PIKB2XZSkkDC62l0/CWoIBgE4jfKElcN3CqiiOQKh
         kdHeByLrFhMU+W6GDAmjHdrXHLyRaku1hOZTVNISABrlDP68/ftm1tYDIvG+d7morQaC
         KsoA==
X-Gm-Message-State: AOAM533SmAiMR9+13Kewmjp1KycXsOPEuYKknOo/3qWe/d7mEu0kXjWc
        Tk7PucQw3HXClw03EFV6vl05V08I2CvW1P8o
X-Google-Smtp-Source: ABdhPJxejApZ4ndF6pk1lzENhacdizDtjesZCvgm1MmaDuG2zt/pS32F9KSDVicnf3CXVGJa0mapkg==
X-Received: by 2002:adf:e0cc:: with SMTP id m12mr42701877wri.62.1634628931087;
        Tue, 19 Oct 2021 00:35:31 -0700 (PDT)
Received: from ?IPv6:2a01:e34:ed2f:f020:c590:9206:d20a:23bd? ([2a01:e34:ed2f:f020:c590:9206:d20a:23bd])
        by smtp.googlemail.com with ESMTPSA id 10sm1723951wme.27.2021.10.19.00.35.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Oct 2021 00:35:30 -0700 (PDT)
Subject: Re: [PATCH v2] thermal: Fix a NULL pointer dereference
To:     Subbaraman Narayanamurthy <quic_subbaram@quicinc.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Amit Kucheria <amitk@kernel.org>
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Collins <quic_collinsd@quicinc.com>,
        Manaf Meethalavalappu Pallikunhi <manafm@codeaurora.org>,
        Ram Chandrasekar <rkumbako@codeaurora.org>,
        stable@vger.kernel.org
References: <1631041289-11804-1-git-send-email-quic_subbaram@quicinc.com>
 <003252f2-510f-e9ea-0032-6034f26aad11@linaro.org>
 <16af9946-b662-0bbf-206f-278b7ef98123@quicinc.com>
 <8cda69a6-907b-e09e-ba64-011b0216a4df@quicinc.com>
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
Message-ID: <dbf9a03f-6c66-dcfe-6158-d93532272a5c@linaro.org>
Date:   Tue, 19 Oct 2021 09:35:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <8cda69a6-907b-e09e-ba64-011b0216a4df@quicinc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 19/10/2021 03:21, Subbaraman Narayanamurthy wrote:
> On 10/8/21 12:50 PM, Subbaraman Narayanamurthy wrote:
>> On 10/6/21 4:08 AM, Daniel Lezcano wrote:

[ ... ]

>> /sys/devices/virtual/thermal/thermal_zone87 # echo 120000 > trip_point_0_temp  
>> [  184.290964][  T211] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000020
>> [  184.300896][  T211] Mem abort info:                                         
>> [  184.304486][  T211]   ESR = 0x96000006                                      
>> [  184.308348][  T211]   EC = 0x25: DABT (current EL), IL = 32 bits            
>> [  184.314531][  T211]   SET = 0, FnV = 0                                      
>> [  184.318384][  T211]   EA = 0, S1PTW = 0                                     
>> [  184.322323][  T211] Data abort info:                                        
>> [  184.325993][  T211]   ISV = 0, ISS = 0x00000006                             
>> [  184.330655][  T211]   CM = 0, WnR = 0                                       
>> [  184.334425][  T211] user pgtable: 4k pages, 39-bit VAs, pgdp=000000081a7a2000
>> [  184.341750][  T211] [0000000000000020] pgd=000000081a7a7003, p4d=000000081a7a7003, pud=000000081a7a7003, pmd=0000000000000000
>> [  184.353359][  T211] Internal error: Oops: 96000006 [#1] PREEMPT SMP         
>> [  184.359797][  T211] Dumping ftrace buffer:                                  
>> [  184.364001][  T211]    (ftrace buffer empty)
>>
>> Hope this helps.
> 
> Hi Daniel,
> Have you got a chance to look at this?

Hi Subbaraman,

Actually, I think the root problem is the thermal zone is showing up
while there is no sensor associated with it. You can read the
temperature and get a kernel warning also.

That's what should be fixed IMO.


-- 
<http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog
