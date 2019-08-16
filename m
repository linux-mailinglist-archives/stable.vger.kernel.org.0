Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43AA8903E7
	for <lists+stable@lfdr.de>; Fri, 16 Aug 2019 16:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbfHPOVq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Aug 2019 10:21:46 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38249 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727291AbfHPOVq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Aug 2019 10:21:46 -0400
Received: by mail-pf1-f195.google.com with SMTP id o70so3212929pfg.5
        for <stable@vger.kernel.org>; Fri, 16 Aug 2019 07:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1qs3FupYCeuyWTYicYTDnBGFUm9sEaGIldWaetjZunk=;
        b=CZqB0qDqlDP8eIHZjzChvMfrpw96JwCkZdU3U+8mu6xLzgfQeSpz62mBhLiJbv+K4u
         MR2yDCbKDlnX9UTiV5iFYGZ7jjUlRzws2LBk0CVDphZNALJcjzYaOfDKQ7P8CA4ZYeni
         HgA50WvKuSNo//IVn4leW4i1w8qsmoOvqoFh3FiaHm0/5VVnO2yNxTevLUHHfBufuPqQ
         ZYDmCMYPkLfPuxG2yygh1l9gvURhtMTZQT5UFklj6iNLWds4vhjRnJHflOzl5wqbYgPo
         zpXeG7+O5RWTogR8pVWuPc1ZGWD54MgBl6lT0z3FKeSS16/ZqJrfTbyHQoZkAJA3mcDe
         asmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1qs3FupYCeuyWTYicYTDnBGFUm9sEaGIldWaetjZunk=;
        b=DsfgwXsf4YXAI0qBuB2fnmO/kWptNZUma64Jw30lbiGLsLf6kFFSqY/PAKEs1n/tGs
         OhOJoeTihrd12lCM4lv61dafKaTvohIxJnEKdm5dTtiC4I9+JIGniAx4MtNzaBNLdQQy
         RXtR8wahfG335TEVWEFYKSQy5cJHyZrmw47MJKNfK+o2vpUpTEzRRKWCx9DkUUhwuQEQ
         tG3JicMb8Bhp35j5jx8fzPnR1kFUDoX36iwo6cuKmYnZWIZCRmMD7N8s8dYa0Qhc7xF9
         tCwV5vOKLtulndvH/5eWDMTjVDA4ZM0bG1hj06cZC8O5eJOI9YUES+qwbEJQfBFJLQou
         MVQQ==
X-Gm-Message-State: APjAAAUiJTBW/4odxBgGe0cV9/kQRR66T8jXHeS3kGZJ96DfD06vJhjn
        vO1e1Y6BPPPezaAOVPjAgytNf7VMjAEdtg==
X-Google-Smtp-Source: APXvYqyIOpGx5DqXfom21jtA56Lvalb+ghlS7BbJDnV9V1A6ygwP5YmC4rC3rQ4zXo+Lbj++ddaYDA==
X-Received: by 2002:a17:90a:7d09:: with SMTP id g9mr7356662pjl.38.1565965305149;
        Fri, 16 Aug 2019 07:21:45 -0700 (PDT)
Received: from [192.168.1.188] (66.29.164.166.static.utbb.net. [66.29.164.166])
        by smtp.gmail.com with ESMTPSA id z14sm3887704pjr.23.2019.08.16.07.21.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Aug 2019 07:21:44 -0700 (PDT)
Subject: Re: [PATCH] blk-mq: avoid sysfs buffer overflow by too many CPU cores
To:     Greg KH <gregkh@linuxfoundation.org>,
        Ming Lei <ming.lei@redhat.com>
Cc:     "Ray, Mark C (Global Solutions Engineering (GSE))" <mark.ray@hpe.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20190815121518.16675-1-ming.lei@redhat.com>
 <20190815122419.GA31891@kroah.com> <20190815122909.GA28032@ming.t460p>
 <20190815123535.GA29217@kroah.com> <20190815124321.GB28032@ming.t460p>
 <AT5PR8401MB05784C37BAF2939B776103FC99AC0@AT5PR8401MB0578.NAMPRD84.PROD.OUTLOOK.COM>
 <20190816024934.GA27844@ming.t460p> <20190816071234.GE1368@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c5b1b6f3-d461-9379-7e5c-6c6bee6a7bd5@kernel.dk>
Date:   Fri, 16 Aug 2019 08:21:42 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190816071234.GE1368@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/16/19 1:12 AM, Greg KH wrote:
> On Fri, Aug 16, 2019 at 10:49:35AM +0800, Ming Lei wrote:
>> On Thu, Aug 15, 2019 at 11:10:35PM +0000, Ray, Mark C (Global Solutions Engineering (GSE)) wrote:
>>> Hi Ming,
>>>
>>> In the customer case, the cpu_list file was not needed.   It was just part of a SAP Hana script to collect all the block device data (similar to sosreport).    So they were just dumping everything, and it picks up the mq-related files.
>>>
>>> I know with IRQs, we have bitmaps/mask, and can represent the list such as "0-27", without listing every CPU.   I'm sure there's lots of options to address this, and getting rid of the cpu_list is one of them.
>>
>> Indeed, same with several attributes under /sys/devices/system/cpu/,
>> actually we can use cpumap_print_to_pagebuf() to print the CPUs.
> 
> And that is changing the format of the file, which means it is obvious
> no one is using it, so just please delete the thing.

IFF that patch was valid, then yes, it follows that you could delete it.
But that's not a given.

-- 
Jens Axboe

