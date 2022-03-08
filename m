Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE9794D1BA0
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 16:26:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346734AbiCHP12 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 10:27:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234931AbiCHP11 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 10:27:27 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D694754D;
        Tue,  8 Mar 2022 07:26:30 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id F132B1F380;
        Tue,  8 Mar 2022 15:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1646753188; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=m2m+Ogcvgk7zAck8lJL9y5rOuyf0bq56RUWhNvKb8gE=;
        b=OFDOb0EX8vyJa+0LJDX7Xt+dj6BWiRqgtFSXsPFEiYkQ6sdEw/loo4IXxjnn4hrfyZx4nu
        xtvYdMNA0TmRGdgQCsrBvDWK+/YB3GNo5U1S690uSfCWm1EOUwu+z/F/Fl1e8LfoiK7zg1
        decbmKM6dxZOdt3C97MlG/yD3bCKPZY=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 80421A3B83;
        Tue,  8 Mar 2022 15:26:26 +0000 (UTC)
Date:   Tue, 8 Mar 2022 16:26:26 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] mm: vmalloc: introduce array allocation functions
Message-ID: <Yid1orgE/Yf56WSV@dhcp22.suse.cz>
References: <20220308105918.615575-1-pbonzini@redhat.com>
 <20220308105918.615575-2-pbonzini@redhat.com>
 <Yidefp4G/Hk2Twfy@dhcp22.suse.cz>
 <77a34051-2672-88cf-99dd-60f5acfb905e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77a34051-2672-88cf-99dd-60f5acfb905e@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 08-03-22 14:55:39, Paolo Bonzini wrote:
> On 3/8/22 14:47, Michal Hocko wrote:
> > Seems useful
> > Acked-by: Michal Hocko<mhocko@suse.com>
> > 
> > Is there any reason you haven't used __alloc_size(1, 2) annotation?
> 
> It's enough to have them in the header:
> 
> > > +extern void *__vmalloc_array(size_t n, size_t size, gfp_t flags) __alloc_size(1, 2);
> > > +extern void *vmalloc_array(size_t n, size_t size) __alloc_size(1, 2);
> > > +extern void *__vcalloc(size_t n, size_t size, gfp_t flags) __alloc_size(1, 2);
> > > +extern void *vcalloc(size_t n, size_t size) __alloc_size(1, 2);

My bad, I have expected __alloc_size before the function name and simply
haven't noticed it at the end.
-- 
Michal Hocko
SUSE Labs
