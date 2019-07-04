Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A63EB5F5F1
	for <lists+stable@lfdr.de>; Thu,  4 Jul 2019 11:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727385AbfGDJrV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jul 2019 05:47:21 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46014 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727338AbfGDJrV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Jul 2019 05:47:21 -0400
Received: by mail-pf1-f194.google.com with SMTP id r1so2681516pfq.12
        for <stable@vger.kernel.org>; Thu, 04 Jul 2019 02:47:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4SdpUWyY7nF3zRR/WMwiXn1AtrDLUN6rhbCHpANtkn8=;
        b=IitgCdR9whQSNacj1M/nbSJsdQPhLvWz8YGHjZuDfyKn4J/+kYtYS/1A1sF8ib44xI
         Jzi+3vhstnJ0PEPZlPBIFJGgMuq6tjar0vi5VCqSjKABufTv9J/BouQzD8NZGsj2rXQc
         JFq2z4Gxqbb5bHDI+1AEOEE6vD4aj8UrnzLPo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4SdpUWyY7nF3zRR/WMwiXn1AtrDLUN6rhbCHpANtkn8=;
        b=CX9EFjw5R1X8Gbj4IZ6EjLsWaeZWDsMymVGIMCFh7pJZrc1hPJ97Y7ff59kU0PBEB3
         yZiUXjLrd3Obqi41efNEQMtuDHpsHynUICC+zuZfWwK6aYnfNDb8fi4A/BJRhTJq7ltv
         q8CGvBaC3c+kiBFBCgTI2/cJoITRY8JJWeygbsNa3EZFTBEaP9FGitwqzOeEqPfqy558
         VeR5VvW0x2eirSRZkpY7/iIvoeGFYbjsj+pWTzhm0O7rPFSLPrATe4JejUKCEyj+3Bn1
         boEwCi3318wO74EYxlSP8wag2mlatBbNFKYxIPunFBVOIsRfYkWCohgEI3pwf657VQyJ
         FGfQ==
X-Gm-Message-State: APjAAAXnaMrhe8ZFA8q/P3GdO+K5DAETU1r06wn3ZdqBzyoX8pGHTlfC
        KeNmy7UNhXE9NQM39lprtA3R
X-Google-Smtp-Source: APXvYqw8E268vWmApfolD80e2lRtPey+EBMugZPC5t2scycuY0Z9LV07oJTYtyfmFbz+c/ETJr/dPg==
X-Received: by 2002:a63:1723:: with SMTP id x35mr41829828pgl.233.1562233640402;
        Thu, 04 Jul 2019 02:47:20 -0700 (PDT)
Received: from google.com ([2401:fa00:1:b:d89e:cfa6:3c8:e61b])
        by smtp.gmail.com with ESMTPSA id m101sm4159465pjb.7.2019.07.04.02.47.18
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 04 Jul 2019 02:47:19 -0700 (PDT)
Date:   Thu, 4 Jul 2019 17:47:16 +0800
From:   Kuo-Hsin Yang <vovoy@chromium.org>
To:     Michal Hocko <mhocko@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan@kernel.org>,
        Sonny Rao <sonnyrao@chromium.org>,
        Kuo-Hsin Yang <vovoy@chromium.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] mm: vmscan: scan anonymous pages on file refaults
Message-ID: <20190704094716.GA245276@google.com>
References: <20190628111627.GA107040@google.com>
 <20190701081038.GA83398@google.com>
 <20190703143057.GQ978@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190703143057.GQ978@dhcp22.suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 03, 2019 at 04:30:57PM +0200, Michal Hocko wrote:
> 
> How does the reclaim behave with workloads with file backed data set
> not fitting into the memory? Aren't we going to to swap a lot -
> something that the heuristic is protecting from?
> 

In common case, most of the pages in a large file backed data set are
non-executable. When there are a lot of non-executable file pages,
usually more file pages are scanned because of the recent_scanned /
recent_rotated ratio.

I modified the test program to set the accessed sizes of the executable
and non-executable file pages respectively. The test program runs on 2GB
RAM VM with kernel 5.2.0-rc7 and this patch, allocates 2000 MB anonymous
memory, then accesses 100 MB executable file pages and 2100 MB
non-executable file pages for 10 times. The test also prints the file
and anonymous page sizes in kB from /proc/meminfo. There are not too
many swaps in this test case. I got similar test result without this
patch.

$ ./thrash 2000 100 2100 10
Allocate 2000 MB anonymous pages
Active(anon): 1850964, Inactive(anon): 133140, Active(file): 1528, Inactive(file): 1352
Access 100 MB executable file pages
Access 2100 MB regular file pages
File access time, round 0: 26.833665 (sec)
Active(anon): 1476084, Inactive(anon): 492060, Active(file): 2236, Inactive(file): 2224
File access time, round 1: 26.362102 (sec)
Active(anon): 1471364, Inactive(anon): 490464, Active(file): 8508, Inactive(file): 8172
File access time, round 2: 26.828894 (sec)
Active(anon): 1469184, Inactive(anon): 489688, Active(file): 10012, Inactive(file): 9840
File access time, round 3: 27.105603 (sec)
Active(anon): 1468128, Inactive(anon): 489408, Active(file): 11000, Inactive(file): 10388
File access time, round 4: 26.936500 (sec)
Active(anon): 1466380, Inactive(anon): 488788, Active(file): 12872, Inactive(file): 12504
File access time, round 5: 26.294687 (sec)
Active(anon): 1466384, Inactive(anon): 488780, Active(file): 13332, Inactive(file): 12396
File access time, round 6: 27.382404 (sec)
Active(anon): 1466344, Inactive(anon): 488772, Active(file): 13100, Inactive(file): 12276
File access time, round 7: 26.607976 (sec)
Active(anon): 1466392, Inactive(anon): 488764, Active(file): 12892, Inactive(file): 11928
File access time, round 8: 26.477663 (sec)
Active(anon): 1466344, Inactive(anon): 488760, Active(file): 12920, Inactive(file): 12092
File access time, round 9: 26.552859 (sec)
Active(anon): 1465820, Inactive(anon): 488748, Active(file): 13300, Inactive(file): 12372
