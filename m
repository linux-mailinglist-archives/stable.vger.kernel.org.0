Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22EFD1B762C
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 15:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbgDXNF6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 09:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726699AbgDXNF5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Apr 2020 09:05:57 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E9B5C09B045
        for <stable@vger.kernel.org>; Fri, 24 Apr 2020 06:05:57 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id i10so10702230wrv.10
        for <stable@vger.kernel.org>; Fri, 24 Apr 2020 06:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=auGOkVlJG2i/aNN/COO5M+dD12KEjmYZImaR8ZZh+Do=;
        b=A45AEe6yfVyjlMv+DgFM5b2k0CVtja1wyfRRHnVuekxaPlmO3O1HUAiOrgoqi+tRCO
         US8zRMF+aD+swuxvP8/YYNTnaa0XAPTasxRhEkxpwV4AFfk1gS64ztgAWw2d38OMAzPD
         hZG3jVXP7M7BdsgM2hHwZr8qx7kzrIRqhCsAs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=auGOkVlJG2i/aNN/COO5M+dD12KEjmYZImaR8ZZh+Do=;
        b=DDOOu9rjMiwa1l7cOlndB4NJl4js4BYbvGKVczjEgubAo7ESGGfEvIx2/+4mBgti4l
         42joVM3apZk/ciwgkd2DpwlJACBTQtB8KX28zgf1LHbLk41oENZYuAB1HUGAtYvrSn59
         g9ASRcJmoxDfJODV/4nWwHIExAPRHXmqjO9F/IFAiRaTti3lkbKGESV7MP/AjIzKzji7
         4hrTMwPSVdzQzW3tnOToHyUsnPtILGa5Bema1KDjzfqM56h3SaO2ko2QtMU91fCJiW6C
         YUIXbHW6D8rkRm0lNrvVcS+6X8m95aogvf5aWETyPGj2gfonGeB/fOGZ4UpcMuv4gTP8
         QHbQ==
X-Gm-Message-State: AGi0Puah1wQkAiK9mVTlPDF3zYNMwxXW4mqpq87lK3guce2lsU/60b+0
        peYHDCUeOedpWrdeIp3v7bSkFA==
X-Google-Smtp-Source: APiQypLAf59/tHRnRR8kS5JUaX+dtrefzQUXMjAUpoLtD45sUqgmTfRhIn2cXi9cw5f+t1BM/LS1cA==
X-Received: by 2002:a5d:610e:: with SMTP id v14mr10792558wrt.159.1587733555924;
        Fri, 24 Apr 2020 06:05:55 -0700 (PDT)
Received: from localhost ([2620:10d:c092:180::1:5fe8])
        by smtp.gmail.com with ESMTPSA id y63sm2877129wmg.21.2020.04.24.06.05.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 06:05:55 -0700 (PDT)
Date:   Fri, 24 Apr 2020 14:05:54 +0100
From:   Chris Down <chris@chrisdown.name>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Linux MM <linux-mm@kvack.org>, Roman Gushchin <guro@fb.com>,
        stable@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm, memcg: fix wrong mem cgroup protection
Message-ID: <20200424130554.GA1462690@chrisdown.name>
References: <20200423061629.24185-1-laoar.shao@gmail.com>
 <20200423153323.GA1318256@chrisdown.name>
 <CALOAHbDpvRZWcaoKBs2ywJFSY0MXT-WEe6wZTR=ed4-85Ovcgg@mail.gmail.com>
 <20200424121836.GA1379200@chrisdown.name>
 <CALOAHbAPkB4ryfQ1Lof+5REyC6KAD+WCz+sZqPb9tK3iZs+xnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CALOAHbAPkB4ryfQ1Lof+5REyC6KAD+WCz+sZqPb9tK3iZs+xnQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm not debating whether your test case is correct or not, or whether the 
numbers are correct or not. The point is that 3 out of 4 people from mm list 
who have looked at this patch have no idea what it's trying to do, why it's 
important, or why these numbers *should* necessarily be wrong.

It's good that you have provided a way to demonstrate the effects of your 
changes, but one can't solve cognitive gaps with testing. If one could, then 
things like TDD would be effective on complex projects -- but they aren't[0].

We're really getting off in the weeds here, though. I just want to make it 
clear to you that if you think "more testing" is a solution to kernel ailments 
like this, you're going to be disappointed.

0: http://people.brunel.ac.uk/~csstmms/FucciEtAl_ESEM2016.pdf
