Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88A5C142429
	for <lists+stable@lfdr.de>; Mon, 20 Jan 2020 08:22:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725872AbgATHWk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jan 2020 02:22:40 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42863 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbgATHWk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jan 2020 02:22:40 -0500
Received: by mail-wr1-f67.google.com with SMTP id q6so28223345wro.9;
        Sun, 19 Jan 2020 23:22:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=hTCsEqhnbed2yOohKKa5cDEabb8n+zDv0sqNRlWlasA=;
        b=EQBP+t6WVO61LQob2SXQ5C0ZjDPuq3xh0z0fv+IpWyzkAVvHNaC9XlvHAB4r82gcf8
         9UqdSC9Ha3Zfp0La4d1/TyOcA+RjW6iHQDhmH7jbA6ZPyqdT2oO5CVxXE4YJY2aG+t+J
         4I9ru4bBgsuEb/7GLXTABStMXSmehC4fDLqGs3/o8/9lrRAD6TZvG4CvkMQT0EH8XIpb
         6xVj7rzA6wEs+54x+kxVx46g0gcGVCZpK/66OU8FXsM6LdUcosiIrvNPoP8s3vp9McsP
         N26TXUTHU0kBqqY8DxPNQ39Cu4XFXSeNXMyl/PhTXwf7w4vOnlQCYvPQUhj3oN7x7gG/
         5P6Q==
X-Gm-Message-State: APjAAAVh2upr6LTwvAteSPA6nhMVPFx5Vo/RRXlIbNmdGpWzxuS+Dms6
        oZS6Om4NhE164q4g2vEi0KQ=
X-Google-Smtp-Source: APXvYqz2iKEyfHH4o8n7UwHlrXbuZHD2r/KRCLb4H54aiHlWXHfI2T42/+/ZrJKyKqvFz7N2h/rY6Q==
X-Received: by 2002:adf:e3c7:: with SMTP id k7mr16533068wrm.80.1579504958617;
        Sun, 19 Jan 2020 23:22:38 -0800 (PST)
Received: from localhost (ip-37-188-138-155.eurotel.cz. [37.188.138.155])
        by smtp.gmail.com with ESMTPSA id w83sm21395092wmb.42.2020.01.19.23.22.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jan 2020 23:22:37 -0800 (PST)
Date:   Mon, 20 Jan 2020 08:22:37 +0100
From:   Michal Hocko <mhocko@kernel.org>
To:     David Rientjes <rientjes@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Wei Yang <richardw.yang@linux.intel.com>, hannes@cmpxchg.org,
        vdavydov.dev@gmail.com, ktkhai@virtuozzo.com,
        kirill.shutemov@linux.intel.com, yang.shi@linux.alibaba.com,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, alexander.duyck@gmail.com,
        stable@vger.kernel.org
Subject: Re: [Patch v4] mm: thp: remove the defer list related code since
 this will not happen
Message-ID: <20200120072237.GA18451@dhcp22.suse.cz>
References: <20200117233836.3434-1-richardw.yang@linux.intel.com>
 <20200118145421.0ab96d5d9bea21a3339d52fe@linux-foundation.org>
 <alpine.DEB.2.21.2001181525250.27051@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.2001181525250.27051@chino.kir.corp.google.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat 18-01-20 15:36:06, David Rientjes wrote:
> On Sat, 18 Jan 2020, Andrew Morton wrote:
> 
> > On Sat, 18 Jan 2020 07:38:36 +0800 Wei Yang <richardw.yang@linux.intel.com> wrote:
> > 
> > > If compound is true, this means it is a PMD mapped THP. Which implies
> > > the page is not linked to any defer list. So the first code chunk will
> > > not be executed.
> > > 
> > > Also with this reason, it would not be proper to add this page to a
> > > defer list. So the second code chunk is not correct.
> > > 
> > > Based on this, we should remove the defer list related code.
> > > 
> > > Fixes: 87eaceb3faa5 ("mm: thp: make deferred split shrinker memcg aware")
> > > 
> > > Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
> > > Suggested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > > Cc: <stable@vger.kernel.org>    [5.4+]
> > 
> > This patch is identical to "mm: thp: grab the lock before manipulating
> > defer list", which is rather confusing.  Please let people know when
> > this sort of thing is done.
> > 
> > The earlier changelog mentioned a possible race condition.  This
> > changelog does not.  In fact this changelog fails to provide any
> > description of any userspace-visible runtime effects of the bug. 
> > Please send along such a description for inclusion, as always.
> > 
> 
> The locking concern that Wei was originally looking at is no longer an 
> issue because we determined that the code in question could simply be 
> removed.
> 
> I think the following can be added to the changelog:
> 
> ----->o-----
> 
> When migrating memcg charges of thp memory, there are two possibilities:
> 
>  (1) The underlying compound page is mapped by a pmd and thus does is not 
>      on a deferred split queue (it's mapped), or
> 
>  (2) The compound page is not mapped by a pmd and is awaiting split on a
>      deferred split queue.
> 
> The current charge migration implementation does *not* migrate charges for 
> thp memory on the deferred split queue, it only migrates charges for pages 
> that are mapped by a pmd.
> 
> Thus, to migrate charges, the underlying compound page cannot be on a 
> deferred split queue; no list manipulation needs to be done in 
> mem_cgroup_move_account().
> 
> With the current code, the underlying compound page is moved to the 
> deferred split queue of the memcg its memory is not charged to, so 
> susbequent reclaim will consider these pages for the wrong memcg.  Remove 
> the deferred split queue handling in mem_cgroup_move_account() entirely.

I believe this still doesn't describe the underlying problem to the full
extent. What happens with the page on the deferred list when it
shouldn't be there in fact? Unless I am missing something deferred_split_scan
will simply split that huge page. Which is a bit unfortunate but nothing
really critical. This should be mentioned in the changelog.

With that clarified, feel free to add

Acked-by: Michal Hocko <mhocko@suse.com>

-- 
Michal Hocko
SUSE Labs
