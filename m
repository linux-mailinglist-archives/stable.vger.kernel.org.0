Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B724144D0C
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 09:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725911AbgAVIOK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 03:14:10 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45719 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbgAVIOK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jan 2020 03:14:10 -0500
Received: by mail-wr1-f66.google.com with SMTP id j42so6161378wrj.12;
        Wed, 22 Jan 2020 00:14:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Xc1OE301adpCBNtCcujnxgV30fLuT/0jt7wsYeyWTiw=;
        b=G10Z8+4btQ/WyBIsGexaLb0r5r+YK1C8ovJF/namQRx8XXX4yp8MrLC78ctuFuZfKG
         WUifP8WKFKmiTg/sJ0fUtH8fJF8UlmfLxYwg5UI2ig3Rofkkl472bsGSOFLtcqfySB33
         OuzFJJoU0Km1n+60GoVAzsFAlT7otMooQPAuOUcUEFn0PTUqqrasmbLo6f4jev0Q4hey
         qcOr9neNn9tGhvv/bOiM2xPG1aKn+pQyETQm+ZBAynLIvab88EkpFXdbuBUW7pAu7mKK
         khyZqPhiZrGuNLPUmHhnm/lMRjdyE9NLgamGgYPZa6En7GYL+vSz1HMXWB2daMcL5MuF
         Dz3g==
X-Gm-Message-State: APjAAAUMpwjvjt8/P5keMMQrNR+K4whrVgPvpnqnvRg+YWRv6gO8yHPg
        knSN49+UeCqwmxt53+1R3bk=
X-Google-Smtp-Source: APXvYqyOheT4FKJM36xAAG9yMCEXeHGMeg+EQx4a7xD4e+fUU9QX1mOCKWXFyYyYhjo0+Jhd7Q+x3g==
X-Received: by 2002:a05:6000:1187:: with SMTP id g7mr9774091wrx.109.1579680848513;
        Wed, 22 Jan 2020 00:14:08 -0800 (PST)
Received: from localhost (ip-37-188-245-167.eurotel.cz. [37.188.245.167])
        by smtp.gmail.com with ESMTPSA id t25sm2838897wmj.19.2020.01.22.00.14.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 00:14:07 -0800 (PST)
Date:   Wed, 22 Jan 2020 09:14:06 +0100
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
Message-ID: <20200122081406.GO29276@dhcp22.suse.cz>
References: <20200117233836.3434-1-richardw.yang@linux.intel.com>
 <20200118145421.0ab96d5d9bea21a3339d52fe@linux-foundation.org>
 <alpine.DEB.2.21.2001181525250.27051@chino.kir.corp.google.com>
 <20200120072237.GA18451@dhcp22.suse.cz>
 <alpine.DEB.2.21.2001201307520.259466@chino.kir.corp.google.com>
 <20200120212726.GB29276@dhcp22.suse.cz>
 <alpine.DEB.2.21.2001211500250.157547@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.2001211500250.157547@chino.kir.corp.google.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 21-01-20 15:08:39, David Rientjes wrote:
> On Mon, 20 Jan 2020, Michal Hocko wrote:
> 
> > > > > When migrating memcg charges of thp memory, there are two possibilities:
> > > > > 
> > > > >  (1) The underlying compound page is mapped by a pmd and thus does is not 
> > > > >      on a deferred split queue (it's mapped), or
> > > > > 
> > > > >  (2) The compound page is not mapped by a pmd and is awaiting split on a
> > > > >      deferred split queue.
> > > > > 
> > > > > The current charge migration implementation does *not* migrate charges for 
> > > > > thp memory on the deferred split queue, it only migrates charges for pages 
> > > > > that are mapped by a pmd.
> > > > > 
> > > > > Thus, to migrate charges, the underlying compound page cannot be on a 
> > > > > deferred split queue; no list manipulation needs to be done in 
> > > > > mem_cgroup_move_account().
> > > > > 
> > > > > With the current code, the underlying compound page is moved to the 
> > > > > deferred split queue of the memcg its memory is not charged to, so 
> > > > > susbequent reclaim will consider these pages for the wrong memcg.  Remove 
> > > > > the deferred split queue handling in mem_cgroup_move_account() entirely.
> > > > 
> > > > I believe this still doesn't describe the underlying problem to the full
> > > > extent. What happens with the page on the deferred list when it
> > > > shouldn't be there in fact? Unless I am missing something deferred_split_scan
> > > > will simply split that huge page. Which is a bit unfortunate but nothing
> > > > really critical. This should be mentioned in the changelog.
> > > > 
> > > 
> > > Are you referring to a compound page on the deferred split queue before a 
> > > task is moved?  I'm not sure this is within the scope of Wei's patch.. 
> > > this is simply preventing a page from being moved to the deferred split
> > > queue of a memcg that it is not charged to.  Is there a concern about why 
> > > this code can be removed or a suggestion on something else it should be 
> > > doing instead?
> > 
> > No, I do not have any concern about the patch itslef. It is that the
> > changelog doesn't decribe the user visible effect. All I am saying is
> > that the current code splits THPs of moved pages under memory pressure
> > even if that is not needed. And that is a clear bug.
> 
> Ah, gotcha.  I tried to do this in the final paragraph of my amedment to 
> Wei's patch and why it's important that this is marked as stable.

I considered "susbequent reclaim will consider these pages for the wrong
memcg." quite unclear TBH.
 
> The current code in 5.4 from commit 87eaceb3faa59 places any migrated 
> compound page onto the deferred split queue of the destination memcg 
> regardless of whether it has a mapping pmd 
> (list_empty(page_deferred_list()) was already false) or it does not have a 
> mapping pmd (but is now on the wrong queue).  For the latter, 
> can_split_huge_page() can help for the actual split but not for the 
> removal of the page that is now erroneously on the queue.

Does that mean that those fully mapped THPs are not going to be split?

> For the former, 
> memcg reclaim would not see the pages that it should split under memcg 
> pressure so we'll see the same memcg oom conditions we saw before the 
> deferred split shrinker became SHRINKER_MEMCG_AWARE: unnecessary ooms.

OK, this is yet another user visibile effect and it would be better to
mention it explicitly in the changelog. 

-- 
Michal Hocko
SUSE Labs
