Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21CC410AF93
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 13:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbfK0Mcb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 07:32:31 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46129 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbfK0Mcb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 07:32:31 -0500
Received: by mail-wr1-f65.google.com with SMTP id z7so23038198wrl.13;
        Wed, 27 Nov 2019 04:32:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=APAHGrPXLQYqK4XEoTpL2DzSySkqv8Fb1fkOTesm7KY=;
        b=LwZR714aKNW53eU2PrzF8ld6L7vBnmV7u/N8kuk7ie4toOHHh+jtUVVd1J8W9xBpFP
         +V+j+nJKAZcYvUylzzmynyzIK/N/OquiTEJDSAOvJLw/qREeLYe2aA+6EZJHrPN1dzGV
         C/xmCHAekdf6oKxpN1+hS/AbZqbrd07SrbAmOXFo2OBQufmjQwWismEM9oYEMhG9vqCz
         WVgcndjZ4FbHMHmVFRz/LELqaqzKwoDaSfVgnOKej8bZapxtSg13asl1xQ0l/xMBSRXi
         CtqMhCqTJ3rI2rXAJonHhuNbFe6Qd8XY2T5pbPODcPiYJjwe6KoMgHY41OA9+NvjcwQD
         ADAg==
X-Gm-Message-State: APjAAAUM+QD/GcWc0Lmz++MrM6GisBItrbSL5mf/mNs7reJjHrfhcpHE
        n2a9yBg/XbniVJQGiKNRyJ0=
X-Google-Smtp-Source: APXvYqxfKgQ5PfmLC6R8aUvg0wAMhGCvN28Tabbxnu2utp0rEv/IP2wvtLrgZvqhCyzrvsU3FB+Yjw==
X-Received: by 2002:adf:f3d0:: with SMTP id g16mr22568717wrp.2.1574857947424;
        Wed, 27 Nov 2019 04:32:27 -0800 (PST)
Received: from localhost (prg-ext-pat.suse.com. [213.151.95.130])
        by smtp.gmail.com with ESMTPSA id b14sm6614061wmj.18.2019.11.27.04.32.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2019 04:32:26 -0800 (PST)
Date:   Wed, 27 Nov 2019 13:32:25 +0100
From:   Michal Hocko <mhocko@kernel.org>
To:     Roman Gushchin <guro@fb.com>
Cc:     "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] mm: memcg/slab: wait for !root kmem_cache refcnt killing
 on root kmem_cache destruction
Message-ID: <20191127123225.GR20912@dhcp22.suse.cz>
References: <20191125185453.278468-1-guro@fb.com>
 <20191126092918.GB20912@dhcp22.suse.cz>
 <20191126184135.GA66034@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191126184135.GA66034@localhost.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 26-11-19 18:41:41, Roman Gushchin wrote:
> On Tue, Nov 26, 2019 at 10:29:18AM +0100, Michal Hocko wrote:
> > On Mon 25-11-19 10:54:53, Roman Gushchin wrote:
[...]
> > > So in a rare case when not all children kmem_caches are destroyed
> > > at the moment when the root kmem_cache is about to be gone, we need
> > > to wait another rcu grace period before destroying the root
> > > kmem_cache.
> > 
> > Could you explain how rare this really is please?
> 
> It seems that we don't destroy root kmem_caches with enabled memcg
> accounting that often, but maybe I'm biased here.

So this happens each time a root kmem_cache is destroyed? Which would
imply that only dynamically created ones?
-- 
Michal Hocko
SUSE Labs
