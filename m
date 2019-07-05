Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05EDA60628
	for <lists+stable@lfdr.de>; Fri,  5 Jul 2019 14:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728337AbfGEMpK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jul 2019 08:45:10 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:45990 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727665AbfGEMpJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jul 2019 08:45:09 -0400
Received: by mail-pl1-f196.google.com with SMTP id bi6so4555655plb.12
        for <stable@vger.kernel.org>; Fri, 05 Jul 2019 05:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dF5ldfW86FJCU5Kc3o1c+7BuYCZNz4gnsUxsM2MILhg=;
        b=Y78t9ohm9IjqJTYbAV0G0UpCaRpc5X9RScVdIdmz4eqVB1CtoQpRVENQv5H9OJB6u3
         IHW38yAnNbwzW6vcGSiPkXs9kW4CnIKtbKQQihf+CPDRaHhL04ZyRYbRyfKQffGvavIp
         D8IdAu4ImWWGg3ot7QhkuD+LT+WNmRKXlpEXE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=dF5ldfW86FJCU5Kc3o1c+7BuYCZNz4gnsUxsM2MILhg=;
        b=uXdHGxE7m96ZVpibPEjvsSHP/Y17AHolJTosrMLQPKTSddxMiWRrfsgHde2+MLo3K6
         MGzxS5bNil347nue/FWlaKUBES6BsJjwua52u/aAFoQJ9jhP7tbz997fOC0f6fWpjh81
         xGCTSB+PIJCMOGn0c8guCbt3hPHBwZQ+HbL2G1/y2QwrrvKbFOssF3P0ELi8EvqPpTm3
         hGwMc2tFN3lR/LpZyg6aZGTyrRjM5zljYvhOGPfCOXGg5ByZONiBm/HFQhDwgbKSYGB0
         s60hgSmBc5+aWimamkKEWQRpMLiEsE4JfEInEdHPaLpA1+cDQy8qX+R/V1GEaE8QdZqb
         IM7g==
X-Gm-Message-State: APjAAAWgwJHtdkZjPwTQQYLCFOlDTeYXByej/UozboD8Yi/fYiEp1tY0
        V7tXuJT/01giR5Z8oSras2sq
X-Google-Smtp-Source: APXvYqxMUTixTbN+cdcvlkTjbvWDrPyHAWnhOqeIT0sxQ7x+/ZOrGTKueCUPUnH3QwRNCyffO+Wgnw==
X-Received: by 2002:a17:902:8b88:: with SMTP id ay8mr5266993plb.139.1562330709214;
        Fri, 05 Jul 2019 05:45:09 -0700 (PDT)
Received: from google.com ([2401:fa00:1:b:d89e:cfa6:3c8:e61b])
        by smtp.gmail.com with ESMTPSA id y22sm8626527pgj.38.2019.07.05.05.45.07
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 05 Jul 2019 05:45:08 -0700 (PDT)
Date:   Fri, 5 Jul 2019 20:45:05 +0800
From:   Kuo-Hsin Yang <vovoy@chromium.org>
To:     Michal Hocko <mhocko@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan@kernel.org>,
        Sonny Rao <sonnyrao@chromium.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] mm: vmscan: scan anonymous pages on file refaults
Message-ID: <20190705124505.GA173726@google.com>
References: <20190628111627.GA107040@google.com>
 <20190701081038.GA83398@google.com>
 <20190703143057.GQ978@dhcp22.suse.cz>
 <20190704094716.GA245276@google.com>
 <20190704110425.GD5620@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190704110425.GD5620@dhcp22.suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 04, 2019 at 01:04:25PM +0200, Michal Hocko wrote:
> On Thu 04-07-19 17:47:16, Kuo-Hsin Yang wrote:
> > On Wed, Jul 03, 2019 at 04:30:57PM +0200, Michal Hocko wrote:
> > > 
> > > How does the reclaim behave with workloads with file backed data set
> > > not fitting into the memory? Aren't we going to to swap a lot -
> > > something that the heuristic is protecting from?
> > > 
> > 
> > In common case, most of the pages in a large file backed data set are
> > non-executable. When there are a lot of non-executable file pages,
> > usually more file pages are scanned because of the recent_scanned /
> > recent_rotated ratio.
> > 
> > I modified the test program to set the accessed sizes of the executable
> > and non-executable file pages respectively. The test program runs on 2GB
> > RAM VM with kernel 5.2.0-rc7 and this patch, allocates 2000 MB anonymous
> > memory, then accesses 100 MB executable file pages and 2100 MB
> > non-executable file pages for 10 times. The test also prints the file
> > and anonymous page sizes in kB from /proc/meminfo. There are not too
> > many swaps in this test case. I got similar test result without this
> > patch.
> 
> Could you record swap out stats please? Also what happens if you have
> multiple readers?

Checked the swap out stats during the test [1], 19006 pages swapped out
with this patch, 3418 pages swapped out without this patch. There are
more swap out, but I think it's within reasonable range when file backed
data set doesn't fit into the memory.

$ ./thrash 2000 100 2100 5 1 # ANON_MB FILE_EXEC FILE_NOEXEC ROUNDS PROCESSES
Allocate 2000 MB anonymous pages
active_anon: 1613644, inactive_anon: 348656, active_file: 892, inactive_file: 1384 (kB)
pswpout: 7972443, pgpgin: 478615246
Access 100 MB executable file pages
Access 2100 MB regular file pages
File access time, round 0: 12.165, (sec)
active_anon: 1433788, inactive_anon: 478116, active_file: 17896, inactive_file: 24328 (kB)
File access time, round 1: 11.493, (sec)
active_anon: 1430576, inactive_anon: 477144, active_file: 25440, inactive_file: 26172 (kB)
File access time, round 2: 11.455, (sec)
active_anon: 1427436, inactive_anon: 476060, active_file: 21112, inactive_file: 28808 (kB)
File access time, round 3: 11.454, (sec)
active_anon: 1420444, inactive_anon: 473632, active_file: 23216, inactive_file: 35036 (kB)
File access time, round 4: 11.479, (sec)
active_anon: 1413964, inactive_anon: 471460, active_file: 31728, inactive_file: 32224 (kB)
pswpout: 7991449 (+ 19006), pgpgin: 489924366 (+ 11309120)

With 4 processes accessing non-overlapping parts of a large file, 30316
pages swapped out with this patch, 5152 pages swapped out without this
patch. The swapout number is small comparing to pgpgin.

[1]: https://github.com/vovo/testing/blob/master/mem_thrash.c
