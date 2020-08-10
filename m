Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17E6C240C62
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 19:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbgHJRvg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 13:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726820AbgHJRvg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 13:51:36 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC254C061787
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 10:51:35 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id f9so294827pju.4
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 10:51:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bmgbqvJzM5mhwZqqR48ors7DLnJTAGMh4F4F9pwaoIQ=;
        b=VgSuZToR+k7daP1v5DhnXLx/YyjhlmSfQvkmTUA+sAzerrFeL9Z95b9UK92lElgY5k
         iOmWAGlN4NrCk4CNHqzbeS4VgvY5ClH5Vnz1NXpDX17+r2lbcncCtGdgF+Id7hbVASnl
         ZSWT21+0OpbPJEdpPlAPcZOka5n6OZHZBTpgPD2QGzzDnfNvyIpnho7FezeYxc777OAH
         RTk9F6s9RQoV4bEyfCRTgRJ5cklNLZ0ogKgek7J8hEfwm6kiHyLtGH5iwvz7ofNVsEke
         cPBaORZWrgZixGhB+BGhVc+3OCo6DmaiDdYknMaNgXdDw8SrYW32rHoRUycGjz8z2uza
         eA3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bmgbqvJzM5mhwZqqR48ors7DLnJTAGMh4F4F9pwaoIQ=;
        b=QoRg+bTvDx3lMiIrkeLeGM50v1UDHnmGx0nQ9TOYOJBBDmnJbyHYGsga2Wp+fkkXoA
         ty18uD23bXLoufnycX5Ewol5L1tQGuh0YJiWlPv7gFaS3s+BXzsmfskQ9cyxgTeZJgeR
         i6kc4L+RagGk0oMMkWYSpispb84PJ8Uo5f/nEPD7Hq+WZSqbkoK2iU5B9nal1YZKPvNg
         3+06XJdZlAZ28xXliJlPxA0WzqGtqr+Ilqnmp/WKAQdKTSWU/n/+027W+6dSlhDVZuy3
         GP5rsM2sFFp6YXY80OkYG8dUzWhmRa6ltveBnnTqfv2+b47VXS/hX6wK2k3lk6z+WEJM
         u5Ow==
X-Gm-Message-State: AOAM530umPO005FlxY1yucO4MyzYDx8UbQE+ChC9akfcTo8cqWC1UbEB
        GYD6QLeWf9SRhHU0SEZkWX/dedl1iTE=
X-Google-Smtp-Source: ABdhPJxY8ndp+UT844LyPCh5Sycfvtt8xTRcgs9eITe+mV+8szGz82nnCE/IxQuEG6IMIO8uWiuFRw==
X-Received: by 2002:a17:90a:cd06:: with SMTP id d6mr449680pju.202.1597081895057;
        Mon, 10 Aug 2020 10:51:35 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id s2sm179379pjb.33.2020.08.10.10.51.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2020 10:51:34 -0700 (PDT)
Subject: Re: [PATCH 1/2] kernel: split task_work_add() into two separate
 helpers
From:   Jens Axboe <axboe@kernel.dk>
To:     peterz@infradead.org
Cc:     io-uring@vger.kernel.org, stable@vger.kernel.org
References: <20200808183439.342243-1-axboe@kernel.dk>
 <20200808183439.342243-2-axboe@kernel.dk>
 <20200810113740.GR2674@hirez.programming.kicks-ass.net>
 <ae401501-ede0-eb08-12b7-1d50f6b3eaa5@kernel.dk>
Message-ID: <a420842b-40af-8e39-591e-ae70d797e241@kernel.dk>
Date:   Mon, 10 Aug 2020 11:51:33 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <ae401501-ede0-eb08-12b7-1d50f6b3eaa5@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/10/20 9:01 AM, Jens Axboe wrote:
> On 8/10/20 5:37 AM, peterz@infradead.org wrote:
>> On Sat, Aug 08, 2020 at 12:34:38PM -0600, Jens Axboe wrote:
>>> Some callers may need to make signaling decisions based on the state
>>> of the targeted task, and that can only safely be done post adding
>>> the task_work to the task. Split task_work_add() into:
>>>
>>> __task_work_add()	- adds the work item
>>> __task_work_notify()	- sends the notification
>>>
>>> No functional changes in this patch.
>>
>> Might be nice to mention __task_work_add() is now inline.
> 
> OK, will mention that.

Added a note of that in the commit message, otherwise the patch is
unchanged:

https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.9&id=67e5aca3cb1bd40de0392fea5a661eae2372d6cc

Are you happy with this one now, given that we cannot easily make
the exit_work const?

-- 
Jens Axboe

