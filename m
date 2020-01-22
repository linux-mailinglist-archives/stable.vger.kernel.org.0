Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18BD1145F3B
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 00:39:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728139AbgAVXjT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 18:39:19 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42689 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726811AbgAVXjT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jan 2020 18:39:19 -0500
Received: by mail-pg1-f195.google.com with SMTP id s64so349076pgb.9
        for <stable@vger.kernel.org>; Wed, 22 Jan 2020 15:39:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=YNvajkPj2BUn62eVSIlq+7puNDrKQpZK5MXXRGczBsE=;
        b=WZJFiO4NDHzrXRTXfEk15plzqfBCf/XF0WnvEGStfqkfZ8Fj/EQr8PPvQ1mLAYqSCP
         v+tE914RPXI/94X6Y2Ek89gj39gHYxA1NTi3sKa6IgtxsqR7fEYjau6jIW00dazgJtqm
         NZx1MnFTfqkmUSUZZeskkvhavOEJCNt5fV+mYrZt5vPpBAD/vBNFA/RgfJYLX8D9PJaA
         G3KnjIHOycLCS+ldcv/ah1Uk5FmX3GkTjliBdERDyczvEhEsSyWkRdr9Dv0Y86tQcqZ1
         /LhnvAT2PoZqjNrkdXKx4QNEIv+ukhBvwK0989ik3JobGkgCQ3qE+FM9Wjg3YeOp+dJQ
         Gk/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=YNvajkPj2BUn62eVSIlq+7puNDrKQpZK5MXXRGczBsE=;
        b=jJSmbVQBSSPEwiZOTsoa2NN+SaoHH4CScHcAY45Fh89aluBnzDUi2U5C3IGN/eHhZN
         H/qXte8LnbpWCSjY7LccjMEgWzpSh0A7XCZ8A7UJpANabBXvjXbUQ9cwc1Loeu1LWOet
         6HdHaKJ3+GK3gMZtyst/H/ZW1rtdrMuUXWMlPtdXUG9q4p0mQIQw2MijE+SctAh5FXoU
         IpM1jSJEvtt6K9LcxAexjv7sUGZOdW6vEUgqUc9oBuWNMkRBpLIgZkdLB0/O3Abgy9+x
         lGEccGHntjju+kd2t/piHuzxNhtNQexDaRi3zKHABhJAdXS/ZYBEyJY0zKA79lzpslDY
         heXw==
X-Gm-Message-State: APjAAAV/M5yjEFfQap1nrzGaxoomBVt8+m6IYcbe2e8WOKTe7yWx7wLI
        CJ6RyX/CxNwJixYxfeJy2vJwhQ==
X-Google-Smtp-Source: APXvYqzYKfqD7EIYVVlkhEXDYVigv+4+OFhdSez6pqm4NRA/CZmbpyFtyH7DKP240xSGf/Xi6bieBA==
X-Received: by 2002:a62:e80a:: with SMTP id c10mr4833932pfi.91.1579736358110;
        Wed, 22 Jan 2020 15:39:18 -0800 (PST)
Received: from [2620:15c:17:3:3a5:23a7:5e32:4598] ([2620:15c:17:3:3a5:23a7:5e32:4598])
        by smtp.gmail.com with ESMTPSA id m101sm98110pje.13.2020.01.22.15.39.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 15:39:17 -0800 (PST)
Date:   Wed, 22 Jan 2020 15:39:16 -0800 (PST)
From:   David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To:     Michal Hocko <mhocko@kernel.org>
cc:     Andrew Morton <akpm@linux-foundation.org>,
        Wei Yang <richardw.yang@linux.intel.com>, hannes@cmpxchg.org,
        vdavydov.dev@gmail.com, ktkhai@virtuozzo.com,
        kirill.shutemov@linux.intel.com, yang.shi@linux.alibaba.com,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, alexander.duyck@gmail.com,
        stable@vger.kernel.org
Subject: Re: [Patch v4] mm: thp: remove the defer list related code since
 this will not happen
In-Reply-To: <20200122081406.GO29276@dhcp22.suse.cz>
Message-ID: <alpine.DEB.2.21.2001221534510.159514@chino.kir.corp.google.com>
References: <20200117233836.3434-1-richardw.yang@linux.intel.com> <20200118145421.0ab96d5d9bea21a3339d52fe@linux-foundation.org> <alpine.DEB.2.21.2001181525250.27051@chino.kir.corp.google.com> <20200120072237.GA18451@dhcp22.suse.cz>
 <alpine.DEB.2.21.2001201307520.259466@chino.kir.corp.google.com> <20200120212726.GB29276@dhcp22.suse.cz> <alpine.DEB.2.21.2001211500250.157547@chino.kir.corp.google.com> <20200122081406.GO29276@dhcp22.suse.cz>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 22 Jan 2020, Michal Hocko wrote:

> > The current code in 5.4 from commit 87eaceb3faa59 places any migrated 
> > compound page onto the deferred split queue of the destination memcg 
> > regardless of whether it has a mapping pmd 
> > (list_empty(page_deferred_list()) was already false) or it does not have a 
> > mapping pmd (but is now on the wrong queue).  For the latter, 
> > can_split_huge_page() can help for the actual split but not for the 
> > removal of the page that is now erroneously on the queue.
> 
> Does that mean that those fully mapped THPs are not going to be split?
> 

It believe it should but deferred_split_scan() also won't take it off the 
wrong split queue so it will remain there and any other checks for 
page_deferred_list(page) will succeed.

> > For the former, 
> > memcg reclaim would not see the pages that it should split under memcg 
> > pressure so we'll see the same memcg oom conditions we saw before the 
> > deferred split shrinker became SHRINKER_MEMCG_AWARE: unnecessary ooms.
> 
> OK, this is yet another user visibile effect and it would be better to
> mention it explicitly in the changelog. 
> 

Ok, feel free to add to the last paragraph:

Memcg reclaim would not see the compound pages that it should split under 
memcg pressure so we'll otherwise see the same memcg oom conditions we saw 
before the deferred split shrinker became SHRINKER_MEMCG_AWARE: 
unnecessary ooms.
