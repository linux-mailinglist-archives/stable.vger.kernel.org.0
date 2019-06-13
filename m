Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9904428E
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727256AbfFMQX3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:23:29 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:40278 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731024AbfFMIhk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 04:37:40 -0400
Received: by mail-yb1-f194.google.com with SMTP id g62so7498614ybg.7
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 01:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xQyhQbksvj61RPrZv6HE/27WZ2p7zM6vRmq6wqbq8Qs=;
        b=Fx7IJ3Rn6+Ui58vZZjWSalUo87E2IkSKQDLMUtkgAPO4CmSr7POvW2xsqzpKzq5uhF
         0f7g+rHnj3GBTKOCeRKhjRPPjQ4GVn+bwZdVpu+vrj/dOJr4Jj1ZIkTbJ3YLMTlyMxMN
         dFMsKo5sE6beFBhyxH44nY5lY9n2acrQ4g7CdoyFqTBJVwOr6pTnEnT5NOllmkVF9RP6
         IgCU7hIvmaN/Y+hE5quNLy9iXnlQ2onRzC1oZrgFYiPOaJytXxn79iHsne5eQcZMRhvR
         OnUqbsrKe5fbWBuAfzOebwrdLBXouzVannJlsiiYbLyWJKuNqhB0elmrcQ+PNSaiuFsW
         y3Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xQyhQbksvj61RPrZv6HE/27WZ2p7zM6vRmq6wqbq8Qs=;
        b=OSCWHVKXNacJRhjZagoVnY/L7hDWI0TGDuw+HtPlx7upen6Kgkz0NxBoJl2j83yDBj
         qPQwNq77RJjUJRbb5CYssXTGNUJpB7ZBlwwE0lYVC3uE3dONOX2xWbObToJkJjQ4V6Rs
         clDqG9RhoWZ5vfZYTDgW2/SpBVHQphvrY7MP2JG8V+RxDgnoQXsSMrC+Yytn7a6+Jptu
         EMmuvCmPOe4iYuYaHUOhfsXZ2/I849ADb7ZlHP/43lwcgi1QKH4vqWTXq4ghivPJU1xk
         hRit4Le9UdFNLtx5pJ2/F2rJEO8oenrZf3cAn3eUxYJ5KhQQ+cQUqxM+SL28iTQFnaiU
         BbDg==
X-Gm-Message-State: APjAAAXY4O9SHXj7UAvwkezlsFIKHT5rDP90ojEL+qZCt5zL+42LvzUw
        i0qaalaQ0AU3ve6matBD9XbDEjMt+/bvVRZa
X-Google-Smtp-Source: APXvYqyCnK2ALhwLtTPvX0AEYshPEqUIKjRxcqh3pgRhqVo+A2spmhGkm2WC+o0o7oMW27T55jkwSw==
X-Received: by 2002:a25:7413:: with SMTP id p19mr39487999ybc.310.1560415057147;
        Thu, 13 Jun 2019 01:37:37 -0700 (PDT)
Received: from ?IPv6:2600:380:9e2c:9b66:68e0:4c59:dc75:6d4b? ([2600:380:9e2c:9b66:68e0:4c59:dc75:6d4b])
        by smtp.gmail.com with ESMTPSA id r6sm597826ywd.47.2019.06.13.01.37.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 01:37:36 -0700 (PDT)
Subject: Re: CFQ idling kills I/O performance on ext4 with blkio cgroup
 controller
To:     "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>,
        Jan Kara <jack@suse.cz>
Cc:     Paolo Valente <paolo.valente@linaro.org>,
        linux-fsdevel@vger.kernel.org,
        linux-block <linux-block@vger.kernel.org>,
        linux-ext4@vger.kernel.org, cgroups@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>, Theodore Ts'o <tytso@mit.edu>,
        amakhalov@vmware.com, anishs@vmware.com, srivatsab@vmware.com,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stable <stable@vger.kernel.org>
References: <6FE0A98F-1E3D-4EF6-8B38-2C85741924A4@linaro.org>
 <2A58C239-EF3F-422B-8D87-E7A3B500C57C@linaro.org>
 <a04368ba-f1d5-8f2c-1279-a685a137d024@csail.mit.edu>
 <E270AD92-943E-4529-8158-AB480D6D9DF8@linaro.org>
 <5b71028c-72f0-73dd-0cd5-f28ff298a0a3@csail.mit.edu>
 <FFA44D26-75FF-4A8E-A331-495349BE5FFC@linaro.org>
 <0d6e3c02-1952-2177-02d7-10ebeb133940@csail.mit.edu>
 <7B74A790-BD98-412B-ADAB-3B513FB1944E@linaro.org>
 <6a6f4aa4-fc95-f132-55b2-224ff52bd2d8@csail.mit.edu>
 <7c5e9d11-4a3d-7df4-c1e6-7c95919522ab@csail.mit.edu>
 <20190612130446.GD14578@quack2.suse.cz>
 <dd32ed59-a543-fc76-9a9a-2462f0119270@csail.mit.edu>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <aca00f05-4d71-7db0-52d6-7aa0932cc5c0@kernel.dk>
Date:   Thu, 13 Jun 2019 02:37:29 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <dd32ed59-a543-fc76-9a9a-2462f0119270@csail.mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/12/19 1:36 PM, Srivatsa S. Bhat wrote:
> 
> [ Adding Greg to CC ]
> 
> On 6/12/19 6:04 AM, Jan Kara wrote:
>> On Tue 11-06-19 15:34:48, Srivatsa S. Bhat wrote:
>>> On 6/2/19 12:04 AM, Srivatsa S. Bhat wrote:
>>>> On 5/30/19 3:45 AM, Paolo Valente wrote:
>>>>>
>>> [...]
>>>>> At any rate, since you pointed out that you are interested in
>>>>> out-of-the-box performance, let me complete the context: in case
>>>>> low_latency is left set, one gets, in return for this 12% loss,
>>>>> a) at least 1000% higher responsiveness, e.g., 1000% lower start-up
>>>>> times of applications under load [1];
>>>>> b) 500-1000% higher throughput in multi-client server workloads, as I
>>>>> already pointed out [2].
>>>>>
>>>>
>>>> I'm very happy that you could solve the problem without having to
>>>> compromise on any of the performance characteristics/features of BFQ!
>>>>
>>>>
>>>>> I'm going to prepare complete patches.  In addition, if ok for you,
>>>>> I'll report these results on the bug you created.  Then I guess we can
>>>>> close it.
>>>>>
>>>>
>>>> Sounds great!
>>>>
>>>
>>> Hi Paolo,
>>>
>>> Hope you are doing great!
>>>
>>> I was wondering if you got a chance to post these patches to LKML for
>>> review and inclusion... (No hurry, of course!)
>>>
>>> Also, since your fixes address the performance issues in BFQ, do you
>>> have any thoughts on whether they can be adapted to CFQ as well, to
>>> benefit the older stable kernels that still support CFQ?
>>
>> Since CFQ doesn't exist in current upstream kernel anymore, I seriously
>> doubt you'll be able to get any performance improvements for it in the
>> stable kernels...
>>
> 
> I suspected as much, but that seems unfortunate though. The latest LTS
> kernel is based on 4.19, which still supports CFQ. It would have been
> great to have a process to address significant issues on older
> kernels too.
> 
> Greg, do you have any thoughts on this? The context is that both CFQ
> and BFQ I/O schedulers have issues that cause I/O throughput to suffer
> upto 10x - 30x on certain workloads and system configurations, as
> reported in [1].
> 
> In this thread, Paolo posted patches to fix BFQ performance on
> mainline. However CFQ suffers from the same performance collapse, but
> CFQ was removed from the kernel in v5.0. So obviously the usual stable
> backporting path won't work here for several reasons:
> 
>    1. There won't be a mainline commit to backport from, as CFQ no
>       longer exists in mainline.
> 
>    2. This is not a security/stability fix, and is likely to involve
>       invasive changes.
> 
> I was wondering if there was a way to address the performance issues
> in CFQ in the older stable kernels (including the latest LTS 4.19),
> despite the above constraints, since the performance drop is much too
> significant. I guess not, but thought I'd ask :-)
> 
> [1]. https://lore.kernel.org/lkml/8d72fcf7-bbb4-2965-1a06-e9fc177a8938@csail.mit.edu/

This issue has always been there. There will be no specific patches made
for stable for something that doesn't even exist in the newer kernels.

-- 
Jens Axboe

