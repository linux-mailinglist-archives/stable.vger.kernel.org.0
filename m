Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ABD8211402
	for <lists+stable@lfdr.de>; Wed,  1 Jul 2020 22:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbgGAUDX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 16:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbgGAUDW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jul 2020 16:03:22 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A67AC08C5DB
        for <stable@vger.kernel.org>; Wed,  1 Jul 2020 13:03:22 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id o13so9275420pgf.0
        for <stable@vger.kernel.org>; Wed, 01 Jul 2020 13:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=DG/OiDzZKYxcN7tgph7u8U8cnXnzZZZ9acgCYJ83YwI=;
        b=KypgvuN8A6GvTF5CN3Jkyl+A7/LMTi++GIYEZVAvfQi8Ot5Tt64QQjwC4jI0Hirc63
         iBxqDmcC8hQBSMpQTuj32vL9Fuu9LG1Pvcyb6jm8sCChD5g6kENuDDiDPl8siCk5ItI1
         9BNxJ9NPtSYOUcfNQUih4K3sxuEZfSR932DUdWkGiN8GefDd6KVkKhnbNa1N8U0k19js
         aJXpTsMFQ0iIxT9bJ1RKG5ebx8FJH3c6RukiwJ5CMFoJHAlM/naxjBXIoTyLtVzwDz9L
         cZM71EnZcykycNMhxQWdJwYTAX11OSuRavVKU054lU719RM88tvgtw45NLNa/pVDas6l
         kvvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=DG/OiDzZKYxcN7tgph7u8U8cnXnzZZZ9acgCYJ83YwI=;
        b=VbEM1V3ahPO3gfSxDAKf5vg3raEBB2SspLKdDOUqu5M89FQhnM/RmTbbLmCPxD4RP3
         Bgvwvi/ZejOJdd/zK+TZpWojO4PZFaLqTyfMc5AVD3sIOA5F3s4x/MHvQKqWN15pIjRU
         2KQoOwq/JEsb6LxfPG9rMznOpsmYY1lp8EbjxTr8siYaV/YPCFbEO5SypcnU9SejQAHD
         Gale35QTvleMBnCShN+lvszeiNttKRqPTCstm/Bt4lcJBJ+Z7YNRpmSuYxgNPSU7eGNG
         TU/4zgDXuNemzI44p1OVLfs+a/JJ5O3BwViEHEvguqXJLhy1kGN2rTXZTBSoMrywpbea
         2/nA==
X-Gm-Message-State: AOAM533gPXIQZmMfJqsobCs4zpPQ/CTpW1xU0VCw0/mhq1hL2HrsipsU
        q++CREwfpgnDGQ7f+RHIzU+nHA==
X-Google-Smtp-Source: ABdhPJzS45NkXiunLsIzMQvukb9uRBU3YXdQl00MI74iobOT3CgQ4L0Gm7O7Mii1eRv3hj+zNHOjbw==
X-Received: by 2002:aa7:86c1:: with SMTP id h1mr12889126pfo.175.1593633801894;
        Wed, 01 Jul 2020 13:03:21 -0700 (PDT)
Received: from [2620:15c:17:3:4a0f:cfff:fe51:6667] ([2620:15c:17:3:4a0f:cfff:fe51:6667])
        by smtp.gmail.com with ESMTPSA id u2sm5954919pfl.21.2020.07.01.13.03.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 13:03:21 -0700 (PDT)
Date:   Wed, 1 Jul 2020 13:03:20 -0700 (PDT)
From:   David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To:     Dave Hansen <dave.hansen@linux.intel.com>
cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        ben.widawsky@intel.com, alex.shi@linux.alibaba.com,
        dwagner@suse.de, tobin@kernel.org, cl@linux.com,
        akpm@linux-foundation.org, ying.huang@intel.com,
        dan.j.williams@intel.com, cai@lca.pw, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] mm/vmscan: restore zone_reclaim_mode ABI
In-Reply-To: <20200701152623.384AF0A7@viggo.jf.intel.com>
Message-ID: <alpine.DEB.2.23.453.2007011303080.1908531@chino.kir.corp.google.com>
References: <20200701152621.D520E62B@viggo.jf.intel.com> <20200701152623.384AF0A7@viggo.jf.intel.com>
User-Agent: Alpine 2.23 (DEB 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 1 Jul 2020, Dave Hansen wrote:

> 
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> I went to go add a new RECLAIM_* mode for the zone_reclaim_mode
> sysctl.  Like a good kernel developer, I also went to go update the
> documentation.  I noticed that the bits in the documentation didn't
> match the bits in the #defines.
> 
> The VM never explicitly checks the RECLAIM_ZONE bit.  The bit is,
> however implicitly checked when checking 'node_reclaim_mode==0'.
> The RECLAIM_ZONE #define was removed in a cleanup.  That, by itself
> is fine.
> 
> But, when the bit was removed (bit 0) the _other_ bit locations also
> got changed.  That's not OK because the bit values are documented to
> mean one specific thing and users surely rely on them meaning that one
> thing and not changing from kernel to kernel.  The end result is that
> if someone had a script that did:
> 
> 	sysctl vm.zone_reclaim_mode=1
> 
> That script went from doing nothing to writing out pages during
> node reclaim after the commit in question.  That's not great.
> 
> Put the bits back the way they were and add a comment so something
> like this is a bit harder to do again.  Update the documentation to
> make it clear that the first bit is ignored.
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Fixes: 648b5cf368e0 ("mm/vmscan: remove unused RECLAIM_OFF/RECLAIM_ZONE")
> Cc: Ben Widawsky <ben.widawsky@intel.com>
> Cc: Alex Shi <alex.shi@linux.alibaba.com>
> Cc: Daniel Wagner <dwagner@suse.de>
> Cc: "Tobin C. Harding" <tobin@kernel.org>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Huang Ying <ying.huang@intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Qian Cai <cai@lca.pw>
> Cc: Daniel Wagner <dwagner@suse.de>
> Cc: stable@vger.kernel.org

Acked-by: David Rientjes <rientjes@google.com>
