Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6485B3F0888
	for <lists+stable@lfdr.de>; Wed, 18 Aug 2021 17:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238409AbhHRPyg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 11:54:36 -0400
Received: from mail-lf1-f53.google.com ([209.85.167.53]:41676 "EHLO
        mail-lf1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236905AbhHRPyg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Aug 2021 11:54:36 -0400
Received: by mail-lf1-f53.google.com with SMTP id y34so5597360lfa.8;
        Wed, 18 Aug 2021 08:54:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BHMjZ/i4Omck1upCZSLIcKpTxWs6ScKdudtkHXwFkLE=;
        b=kIAGGTZeQM0Ibms+kJwy8pA8L6EfqqeVEwF3moFKOrx6ov3go2zXy4J1DcI/Wj4X5u
         4AOIsAaOpd0czWRqpxQWC2eN3c9PEceL70s2ofS8YphQsquo9K/k3wn+q+tk0r4K+Ch3
         4UVWjPoVU0ph112LKSsNF6POt339wYGwVZ4vCp/SvY/Weq0MVEF9jxSWaRDyX7sGnjJs
         w/n5/AnBSWe+vO0vZrQ+G1krGMioxgky5l0nk8V2aMzA2ex41uIeLoG66UtP1KMha4zD
         hEEyz1wkNRVKk9Vv1ML1wpUrlx7CkE5zoPWe32D31U5zXlPFqJFhlMSGnlJsg15WaXcs
         EG1Q==
X-Gm-Message-State: AOAM531AAwqr08LI/ctkYCW4zqT5sAR7rvlVnBHgSafzlx2zUFuk4zdp
        ibwZ6J4dGhFbKmhr3AJEm5PIbyibRzofIQh8
X-Google-Smtp-Source: ABdhPJzX63+YdtxMD3d2t0KhRquyfJSWRbwehMnKvCRyitRNSB4q0CCa4GjIT1G2HjeO+ujGwlCaDg==
X-Received: by 2002:a05:6512:1501:: with SMTP id bq1mr7028514lfb.286.1629302040079;
        Wed, 18 Aug 2021 08:54:00 -0700 (PDT)
Received: from [10.68.32.40] (broadband-188-32-236-56.ip.moscow.rt.ru. [188.32.236.56])
        by smtp.gmail.com with ESMTPSA id n18sm27302ljg.40.2021.08.18.08.53.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Aug 2021 08:53:59 -0700 (PDT)
Subject: Re: [PATCH] Revert "floppy: reintroduce O_NDELAY fix"
To:     Jiri Kosina <jikos@kernel.org>
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        regressions@lists.linux.dev, Mark Hounschell <markh@compro.net>,
        Wim Osterholt <wim@djo.tudelft.nl>,
        Kurt Garloff <kurt@garloff.de>, stable@vger.kernel.org
References: <de10cb47-34d1-5a88-7751-225ca380f735@compro.net>
 <20210808074246.33449-1-efremov@linux.com>
 <nycvar.YFH.7.76.2108160914070.8253@cbobk.fhfr.pm>
From:   Denis Efremov <efremov@linux.com>
Message-ID: <5ca95b90-c6e0-99b3-b129-75dc05cfb1d4@linux.com>
Date:   Wed, 18 Aug 2021 18:53:58 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <nycvar.YFH.7.76.2108160914070.8253@cbobk.fhfr.pm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 8/16/21 10:17 AM, Jiri Kosina wrote:
> On Sun, 8 Aug 2021, Denis Efremov wrote:
> 
>> The patch breaks userspace implementations (e.g. fdutils) and introduces
>> regressions in behaviour. Previously, it was possible to O_NDELAY open a
>> floppy device with no media inserted or with write protected media without
>> an error. Some userspace tools use this particular behavior for probing.
>>
>> It's not the first time when we revert this patch. Previous revert is in
>> commit f2791e7eadf4 (Revert "floppy: refactor open() flags handling").
>>
>> This reverts commit 8a0c014cd20516ade9654fc13b51345ec58e7be8.
> 
> By reverting it you bring back the bugs that were fixed by it

I agree with you, that O_NDELAY is broken for floppies (and always been).
However, just by removing O_NDELAY we break many existing tools that use
it for probing and ioctl-only opens. With the patch tools fail to open the
device without a diskette and try to read a diskette if there is one (this is
not as fast on a real hardware as in QEMU).
I think that there should be a better fix that doesn't break existing tools.
It appears that people still use software that depends on O_NDELAY in floppies.
Same patch was already reverted in 2016 (presumably) by the same reason.

>  -- e.g. the 
> possibility to livelock mmap() on the returned fd to keep waiting on the 
> page unlock bit forever

As far as I understand this is a problem only for syzkaller.
And this is not a security issue nowadays since most distributions
(I don't know exceptions) require at least "disk" group to access floppies.
Do you know a link for the syzkaller reproducer?

> or the functionality bug reported at [1], and 
> likely others.
> 
> [1] https://bugzilla.suse.com/show_bug.cgi?id=1181018

The patch starts to return -ENXIO for O_NDELAY|O_RDONLY opens and devices
without a diskette. I don't think this is an expected behavior during 
libblkid probing.

Probably there is a better fix for [1], maybe even an additional workaround
for floppies in libblkid. They already have workarounds for cdroms
https://github.com/karelzak/util-linux/commit/dc30fd4383e57a0440cdb0e16ba5c4336a43b290

I started to add simple tests https://lkml.org/lkml/2021/8/18/845
However, I failed to reproduce mount bug [1], probably
because I don't know how to configure cloudinit properly. I tried to reproduce
a mount fail bug with open("/dev/fd0", O_NDELAY|O_RDONLY) and mount("/dev/fd0", ...)
but it works. Looks like there should be something else in between...

Regards,
Denis
