Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 319A8141A78
	for <lists+stable@lfdr.de>; Sun, 19 Jan 2020 00:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbgARXgJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Jan 2020 18:36:09 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:37653 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727008AbgARXgJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Jan 2020 18:36:09 -0500
Received: by mail-pj1-f66.google.com with SMTP id m13so5193174pjb.2
        for <stable@vger.kernel.org>; Sat, 18 Jan 2020 15:36:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=uIkVi5/18BrXAFhDrVTXIWex0kk8NMAn2RkTWk0CSSY=;
        b=iu115+9lV/04EU32wHPVpF5SDtYyBN/ZzP+6hYsCU3Loxosw509E7TMGGGSST3zeco
         midRiRU45Kip2a5+PVlNYHG5rnRUAbAya88HCQLSqJXOSRpyh5D5ysfQA5zKL6VN9cjo
         YFLcul8JrbJIRsTxm9W8BTYuu3mU+NggVPgGJ9oWUH5JAgZl/jl6BaXT+mi8ElktC7eP
         K9uDl0rvufOE+biNXeyhrorGReyOFLb9SLyQGcLRZd1fvH03NkUt5aPxE9CraNLEZ1eK
         HAbBTyicLdpaAK/ntvqjoTh0C0873jNLJNI1hXCrkWwl8Oh9yEcFe2V7ZSHQgpmk/zH/
         ts0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=uIkVi5/18BrXAFhDrVTXIWex0kk8NMAn2RkTWk0CSSY=;
        b=qmnJR8orKXXH272elYQN1ibzVR4ZJDgG66wGku+8NCqB9ADlJDnH0MpCzPu5HjiIf2
         qrmd/aZiyUuf6qImaPSm3ppLhYVrNVP1QA/gd2H9qT/e0+3BdBDsMazY+ryILHTfvG54
         2gv12e1z80swTCop8FWPlqJjGCOi5oK6SaDxGGbydcT1keDWtiVhvp3VKEq61IEKXaAu
         0T53o9i+JEVAEu+XUrlkkFd+7VpDtFwTgRnxap0+MiXYoUS5cVzD+5KZPRdlA+Q12gw+
         eSOg2sNztfzIYNKxJsHiDaIkq9tfFVwx0DsDD759m+MHwsbPOUGyt7iUAgU8JcKCXwOn
         vdhg==
X-Gm-Message-State: APjAAAXMFYHZOVKTjMXnk6krE5J/Iiyb2zAixNYDpq6PxI3sYZLdvk3l
        kL8stpADPJDfdya05z/8Zi5mpA==
X-Google-Smtp-Source: APXvYqz7a/YBmpU2KpRRbYHzpssvbNtNYLKoplHj5DlHRkIHmGTqw52wuPetVnUrdiiuBUzJdi0dNg==
X-Received: by 2002:a17:902:34a:: with SMTP id 68mr6912460pld.250.1579390568189;
        Sat, 18 Jan 2020 15:36:08 -0800 (PST)
Received: from [2620:15c:17:3:3a5:23a7:5e32:4598] ([2620:15c:17:3:3a5:23a7:5e32:4598])
        by smtp.gmail.com with ESMTPSA id w5sm11953694pjt.32.2020.01.18.15.36.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jan 2020 15:36:07 -0800 (PST)
Date:   Sat, 18 Jan 2020 15:36:06 -0800 (PST)
From:   David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To:     Andrew Morton <akpm@linux-foundation.org>
cc:     Wei Yang <richardw.yang@linux.intel.com>, hannes@cmpxchg.org,
        mhocko@kernel.org, vdavydov.dev@gmail.com, ktkhai@virtuozzo.com,
        kirill.shutemov@linux.intel.com, yang.shi@linux.alibaba.com,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, alexander.duyck@gmail.com,
        stable@vger.kernel.org
Subject: Re: [Patch v4] mm: thp: remove the defer list related code since
 this will not happen
In-Reply-To: <20200118145421.0ab96d5d9bea21a3339d52fe@linux-foundation.org>
Message-ID: <alpine.DEB.2.21.2001181525250.27051@chino.kir.corp.google.com>
References: <20200117233836.3434-1-richardw.yang@linux.intel.com> <20200118145421.0ab96d5d9bea21a3339d52fe@linux-foundation.org>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 18 Jan 2020, Andrew Morton wrote:

> On Sat, 18 Jan 2020 07:38:36 +0800 Wei Yang <richardw.yang@linux.intel.com> wrote:
> 
> > If compound is true, this means it is a PMD mapped THP. Which implies
> > the page is not linked to any defer list. So the first code chunk will
> > not be executed.
> > 
> > Also with this reason, it would not be proper to add this page to a
> > defer list. So the second code chunk is not correct.
> > 
> > Based on this, we should remove the defer list related code.
> > 
> > Fixes: 87eaceb3faa5 ("mm: thp: make deferred split shrinker memcg aware")
> > 
> > Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
> > Suggested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > Cc: <stable@vger.kernel.org>    [5.4+]
> 
> This patch is identical to "mm: thp: grab the lock before manipulating
> defer list", which is rather confusing.  Please let people know when
> this sort of thing is done.
> 
> The earlier changelog mentioned a possible race condition.  This
> changelog does not.  In fact this changelog fails to provide any
> description of any userspace-visible runtime effects of the bug. 
> Please send along such a description for inclusion, as always.
> 

The locking concern that Wei was originally looking at is no longer an 
issue because we determined that the code in question could simply be 
removed.

I think the following can be added to the changelog:

----->o-----

When migrating memcg charges of thp memory, there are two possibilities:

 (1) The underlying compound page is mapped by a pmd and thus does is not 
     on a deferred split queue (it's mapped), or

 (2) The compound page is not mapped by a pmd and is awaiting split on a
     deferred split queue.

The current charge migration implementation does *not* migrate charges for 
thp memory on the deferred split queue, it only migrates charges for pages 
that are mapped by a pmd.

Thus, to migrate charges, the underlying compound page cannot be on a 
deferred split queue; no list manipulation needs to be done in 
mem_cgroup_move_account().

With the current code, the underlying compound page is moved to the 
deferred split queue of the memcg its memory is not charged to, so 
susbequent reclaim will consider these pages for the wrong memcg.  Remove 
the deferred split queue handling in mem_cgroup_move_account() entirely.

----->o-----

Acked-by: David Rientjes <rientjes@google.com>
