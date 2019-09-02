Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5820A5CB7
	for <lists+stable@lfdr.de>; Mon,  2 Sep 2019 21:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727129AbfIBTed (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Sep 2019 15:34:33 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:39739 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727109AbfIBTed (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Sep 2019 15:34:33 -0400
Received: by mail-lf1-f65.google.com with SMTP id l11so11103995lfk.6
        for <stable@vger.kernel.org>; Mon, 02 Sep 2019 12:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bGRyo55Grqjgw6KDZGiTGmb9hZemVetuNkxEfZG9oYg=;
        b=G7z0JoJAYy37w3VV/CgWWddE8KL+oLKTSQI0QgFPQ9hN+10YbJwiju/xqiFy4sBTzI
         M6aKDgfaSBwS7/5J05zM+k42sovpEZVIEaJ2bgpTMViytUmNbBymPBEVcXFC9YSJ2DZq
         DU0Ax2Zw5CfIiufCxY8Zh4tSdHuHWnjTNfLAxsvqTpjdFrhT4ghbriTggztIidQGrdGM
         fGIqBJvBb+h0OVa5yBHWHZUwwIpY7wvuFXnR7LP2v9kkom0L/V87DvAn4q89IAWyu/m+
         YHpn1LLr1JL926BGz7fffWKJxoItVSI0vrWwlYVRCPtHFRvFjBUMgI89X28yGW7Zs7bS
         xA6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bGRyo55Grqjgw6KDZGiTGmb9hZemVetuNkxEfZG9oYg=;
        b=uTWGfF/ewqAUTMH7j5duVAlWMbA5VUGAyeaPTPZ0Erg+i2timHLWYeyoxUeapw/p8Z
         DpKa+SDlxgA+SG61tYvQuCWy9LeI3LUZqzxyDci9djSbOdLf8gSpU5oaEwjIV9mpikAC
         fb2AY8KNvP0XxJMmhApaH/r1BsS33YE01HtwVGVTZtVDKvB7SdNDKjyEYi6f19wYOZje
         uiPtUKBAKu38je5oXoDYcaasX9afV03w4HqwhL4Ie4Ht1LdT7ePSZCe6lYztnudnFK6g
         DQ8nDxXfPL6Y4VKa60MYfFQ7PcdPxNfAuVc+YdpdAyESx6J+RhWqBtGsT86dFtP4nzWs
         13MA==
X-Gm-Message-State: APjAAAXC3i7U8xFKBUhCLwUVDP9N4wVJ1ksPwzTre9CL68MBwBoJe3wI
        S7e57nQ/R0+qW7L8FxD/zF10XwSeyME=
X-Google-Smtp-Source: APXvYqzbas2dakjU1oMyYKQ4EruEVWImpf4syEuKbV9b8Sw/3Fk3CjDA4OMiZnmZg/0SNDHfjW9o3Q==
X-Received: by 2002:a19:beca:: with SMTP id o193mr18399333lff.137.1567452870845;
        Mon, 02 Sep 2019 12:34:30 -0700 (PDT)
Received: from [84.217.160.234] (c-8caed954.51034-0-757473696b74.bbcust.telenor.se. [84.217.160.234])
        by smtp.gmail.com with ESMTPSA id c21sm173243ljj.6.2019.09.02.12.34.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Sep 2019 12:34:30 -0700 (PDT)
Subject: Re: [BUG] Early OOM and kernel NULL pointer dereference in 4.19.69
To:     Michal Hocko <mhocko@kernel.org>
Cc:     linux-mm@kvack.org, stable@vger.kernel.org
References: <31131c2d-a936-8bbf-e58d-a3baaa457340@gmail.com>
 <20190902071617.GC14028@dhcp22.suse.cz>
From:   Thomas Lindroth <thomas.lindroth@gmail.com>
Message-ID: <a07da432-1fc1-67de-ae35-93f157bf9a7d@gmail.com>
Date:   Mon, 2 Sep 2019 21:34:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190902071617.GC14028@dhcp22.suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/2/19 9:16 AM, Michal Hocko wrote:
> On Sun 01-09-19 22:43:05, Thomas Lindroth wrote:
>> After upgrading to the 4.19 series I've started getting problems with
>> early OOM.
> 
> What is the kenrel you have updated from? Would it be possible to try
> the current Linus' tree?

I did some more testing and it turns out this is not a regression after all.

I followed up on my hunch and monitored memory.kmem.max_usage_in_bytes while
running cgexec -g memory:12G bash -c 'find / -xdev -type f -print0 | \
         xargs -0 -n 1 -P 8 stat > /dev/null'

Just as memory.kmem.max_usage_in_bytes = memory.kmem.limit_in_bytes the OOM
killer kicked in and killed my X server.

Using the find|stat approach it was easy to test the problem in a testing VM.
I was able to reproduce the problem in all these kernels:
   4.9.0
   4.14.0
   4.14.115
   4.19.0
   5.2.11

5.3-rc6 didn't build in the VM. The build environment is too old probably.

I was curious why I initially couldn't reproduce the problem in 4.14 by
building chromium. I was again able to successfully build chromium using
4.14.115. Turns out memory.kmem.max_usage_in_bytes was 1015689216 after
building and my limit is set to 1073741824. I guess some unrelated change in
memory management raised that slightly for 4.19 triggering the problem.

If you want to reproduce for yourself here are the steps:
1. build any kernel above 4.9 using something like my .config
2. setup a v1 memory cgroup with memory.kmem.limit_in_bytes lower than
    memory.limit_in_bytes. I used 100M in my testing VM.
3. Run "find / -xdev -type f -print0 | xargs -0 -n 1 -P 8 stat > /dev/null"
    in the cgroup.
4. Assuming there is enough inodes on the rootfs the global OOM killer
    should kick in when memory.kmem.max_usage_in_bytes =
    memory.kmem.limit_in_bytes and kill something outside the cgroup.
