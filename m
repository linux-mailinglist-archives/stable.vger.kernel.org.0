Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 799A810C61D
	for <lists+stable@lfdr.de>; Thu, 28 Nov 2019 10:43:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbfK1JnQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Nov 2019 04:43:16 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41686 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbfK1JnQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Nov 2019 04:43:16 -0500
Received: by mail-wr1-f65.google.com with SMTP id b18so30253451wrj.8;
        Thu, 28 Nov 2019 01:43:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=UgTnLC+3ETJ4P4Qbb/UkyHfmjqLaw4B3tOIrLW9bCaw=;
        b=EyQ+NTNTbYT83uwCrZSFdd7xibeDhUU6qgZj8abvlH1DIRp33/H7UwD7fBlUV32fws
         vGInlnoz8FZC8og7ukCmL/wlMtgf0ludJ8pfg8MJy3kqO5l+tQn50fWiwh1Ny1e5CCNC
         OzJY64afr4xEfwERaE3z99puOo39pBdrATesGDTUPa3NZFQASs2vx9eHomu0SgeBpG/r
         4HSHJRezvDo6smmLXcvc6EqJMGboDiosR9xCG0qjEcVZq8Z+Wiea86kTnWSfO9e7y48P
         9JMnNCb8XzLY+7swnjW8BMG7LuJd7EyLVEWOKmpzcpo6CY9kSQcNqH9UCpRIsfeBekOX
         7gXw==
X-Gm-Message-State: APjAAAUUr+Kat32a3FDknl8vg/Kd1iYNoBWs5qjwFWPa02xGdSGLEKx/
        8cxmkfIUkt9dwLLeenDNbpI=
X-Google-Smtp-Source: APXvYqwdZRlp/S4BaX1ZlxE2h9655+sgC0OLlqItykCfBmpFF+5UX/uwTKwitYPuGZ1XCtbmnwpBHA==
X-Received: by 2002:a05:6000:12c9:: with SMTP id l9mr12196977wrx.304.1574934194317;
        Thu, 28 Nov 2019 01:43:14 -0800 (PST)
Received: from localhost (prg-ext-pat.suse.com. [213.151.95.130])
        by smtp.gmail.com with ESMTPSA id l4sm9453508wml.33.2019.11.28.01.43.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2019 01:43:13 -0800 (PST)
Date:   Thu, 28 Nov 2019 10:43:12 +0100
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
Message-ID: <20191128094312.GF26807@dhcp22.suse.cz>
References: <20191125185453.278468-1-guro@fb.com>
 <20191126092918.GB20912@dhcp22.suse.cz>
 <20191126184135.GA66034@localhost.localdomain>
 <20191127123225.GR20912@dhcp22.suse.cz>
 <20191127172724.GA67742@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191127172724.GA67742@localhost.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed 27-11-19 17:27:29, Roman Gushchin wrote:
> On Wed, Nov 27, 2019 at 01:32:25PM +0100, Michal Hocko wrote:
> > On Tue 26-11-19 18:41:41, Roman Gushchin wrote:
> > > On Tue, Nov 26, 2019 at 10:29:18AM +0100, Michal Hocko wrote:
> > > > On Mon 25-11-19 10:54:53, Roman Gushchin wrote:
> > [...]
> > > > > So in a rare case when not all children kmem_caches are destroyed
> > > > > at the moment when the root kmem_cache is about to be gone, we need
> > > > > to wait another rcu grace period before destroying the root
> > > > > kmem_cache.
> > > > 
> > > > Could you explain how rare this really is please?
> > > 
> > > It seems that we don't destroy root kmem_caches with enabled memcg
> > > accounting that often, but maybe I'm biased here.
> > 
> > So this happens each time a root kmem_cache is destroyed? Which would
> > imply that only dynamically created ones?
> 
> Yes, only dynamically created and only in those cases when destruction
> of the root cache happens immediately after the deactivation of the
> non-root cache.
> Tbh I can't imagine any other case except rmmod after
> removing the cgroup.

Thanks for the confirmation! Could you please make this explicit in the
changelog please? Maybe it is obvious to you but it took me quite some
time to grasp what the hell is going on here. Both memcg and kmem_cache
destruction are quite complex and convoluted.

Thanks a lot.

-- 
Michal Hocko
SUSE Labs
