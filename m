Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF284143366
	for <lists+stable@lfdr.de>; Mon, 20 Jan 2020 22:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgATV1f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jan 2020 16:27:35 -0500
Received: from mail-wr1-f43.google.com ([209.85.221.43]:34539 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbgATV1f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jan 2020 16:27:35 -0500
Received: by mail-wr1-f43.google.com with SMTP id t2so1060543wrr.1;
        Mon, 20 Jan 2020 13:27:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xRMZlrNlQg9cdO4fRMxM7tI9dWMAzyGA31Iy64N3nl8=;
        b=iWVwTeDEyN2muQbm+4Ut9dEwC0pJVh35SMTjzD0klwRpICJ04oCwPMtlucso3pGMOd
         VHP6lHsrfQSOkUsUVx7ZD0rNFol6wcR8txftXkLIVTBFt7vs1nFVwX510HsPTst1xP84
         BsjCzhWtKO4a4rWpZnUbmwzvJakc4t/cLHCdUD7lllx6/id+MrfkMcArXw1Zt59h9C8x
         Iu7hD0dovUFgZqbhQ4Uaj+kx5HMfAGjPcanWJfWUTiBxx5stWpvjXmdi0XjaXmFkAoOy
         GeU3eP2+fozkmHQOeU7AFEFfTwNq+wFmpvDYr22Ev67gY+aYKH8eGdsD/wiaGOXh/TTd
         HDiw==
X-Gm-Message-State: APjAAAX0f+BPHf58T6GLpBuiATEaVKBIl5B/IzY0INTUOF8ifGO4Xyf6
        MmeFHyKl6ig9K5QAqufqYfWj+OBr
X-Google-Smtp-Source: APXvYqyYgz2mI0koULHiATO7/pyVqYlpiyljM7jza7dSiOuNS5UDLDHVm+KJL6g9yjj9NKtYMqDKWw==
X-Received: by 2002:adf:d0c1:: with SMTP id z1mr1443832wrh.371.1579555653420;
        Mon, 20 Jan 2020 13:27:33 -0800 (PST)
Received: from localhost (ip-37-188-245-167.eurotel.cz. [37.188.245.167])
        by smtp.gmail.com with ESMTPSA id v83sm939560wmg.16.2020.01.20.13.27.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 13:27:32 -0800 (PST)
Date:   Mon, 20 Jan 2020 22:27:26 +0100
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
Message-ID: <20200120212726.GB29276@dhcp22.suse.cz>
References: <20200117233836.3434-1-richardw.yang@linux.intel.com>
 <20200118145421.0ab96d5d9bea21a3339d52fe@linux-foundation.org>
 <alpine.DEB.2.21.2001181525250.27051@chino.kir.corp.google.com>
 <20200120072237.GA18451@dhcp22.suse.cz>
 <alpine.DEB.2.21.2001201307520.259466@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.2001201307520.259466@chino.kir.corp.google.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon 20-01-20 13:10:56, David Rientjes wrote:
> On Mon, 20 Jan 2020, Michal Hocko wrote:
> 
> > > When migrating memcg charges of thp memory, there are two possibilities:
> > > 
> > >  (1) The underlying compound page is mapped by a pmd and thus does is not 
> > >      on a deferred split queue (it's mapped), or
> > > 
> > >  (2) The compound page is not mapped by a pmd and is awaiting split on a
> > >      deferred split queue.
> > > 
> > > The current charge migration implementation does *not* migrate charges for 
> > > thp memory on the deferred split queue, it only migrates charges for pages 
> > > that are mapped by a pmd.
> > > 
> > > Thus, to migrate charges, the underlying compound page cannot be on a 
> > > deferred split queue; no list manipulation needs to be done in 
> > > mem_cgroup_move_account().
> > > 
> > > With the current code, the underlying compound page is moved to the 
> > > deferred split queue of the memcg its memory is not charged to, so 
> > > susbequent reclaim will consider these pages for the wrong memcg.  Remove 
> > > the deferred split queue handling in mem_cgroup_move_account() entirely.
> > 
> > I believe this still doesn't describe the underlying problem to the full
> > extent. What happens with the page on the deferred list when it
> > shouldn't be there in fact? Unless I am missing something deferred_split_scan
> > will simply split that huge page. Which is a bit unfortunate but nothing
> > really critical. This should be mentioned in the changelog.
> > 
> 
> Are you referring to a compound page on the deferred split queue before a 
> task is moved?  I'm not sure this is within the scope of Wei's patch.. 
> this is simply preventing a page from being moved to the deferred split
> queue of a memcg that it is not charged to.  Is there a concern about why 
> this code can be removed or a suggestion on something else it should be 
> doing instead?

No, I do not have any concern about the patch itslef. It is that the
changelog doesn't decribe the user visible effect. All I am saying is
that the current code splits THPs of moved pages under memory pressure
even if that is not needed. And that is a clear bug.
-- 
Michal Hocko
SUSE Labs
