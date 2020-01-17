Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2511140611
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 10:33:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbgAQJdK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 04:33:10 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38239 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726915AbgAQJdA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jan 2020 04:33:00 -0500
Received: by mail-pl1-f196.google.com with SMTP id f20so9631866plj.5
        for <stable@vger.kernel.org>; Fri, 17 Jan 2020 01:33:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=p0FYXrhY0dK2Yq0ADqbuALXVIqL3DOBXcQh5lESagqw=;
        b=TF9fXgaUP4k4EAUC/Dy/SrOzwDt7ThZAFl1RiO2a29ruRoatv9IVB/khL4saK8kRVr
         jmQulM0N9UWJo1tVbMtZSwfUOSeBO82sunl63tNxOn9BFdV+BcFNIApGC+7vEbF5JCs/
         sFX4nSxwdD66o0jnSZQb+cuxIhTNSgQPJw+NbD6Yp2tQePUHbGgagbNBt9loJ1etUD8y
         ju0tJkK2IpWUyY0tP+T6wcrO6lkabPJHh0jysu0L3AYYtHptfY8IDpWqeHAFxNNvJ2PP
         2UZyeAiwnjYi/RrtKRf8YgfE3/Mwr3ec4ZhjQSrEwi+CGDiEwax83iA9qESUsmFSl9lm
         BKcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=p0FYXrhY0dK2Yq0ADqbuALXVIqL3DOBXcQh5lESagqw=;
        b=Q3EFZEU89D4IkvXXLPiAtJVABdwLx/ZHEryZ+N5jN251aUeWv3DqU0T1E5oXL08il8
         9d9+nfi/1Nb0R+iAPeef1wizT/X0sZodCBGB8dmh30smFvSi0pml0rUpZMpIj+Mtwx65
         bfuGiRvnJLMcShplHPbkQjH+gXw+j4XA0SF0iuQIONpgEC+sGf2uT5fRRxL0a+J4snWS
         SPMmrKkVdB9OyLjnaZ/yaxMMQ5jvU25Wr3QNJ6NcV5D5po5y/F0nM8oSyDyyJxVZWorV
         E9lfRCwM+mBqvtkkSkfCvic0FncOrom83I6IZcL8C9VsYIMlicMq7BO9MnWwSSMu3kfs
         acLg==
X-Gm-Message-State: APjAAAUSmsKUdRWw6aZfqqAScTGntqlyYjkWPF26nCwaEMtK04anyErn
        slSu0h1vIM0D5Tyqt+ZuTUtwoQ==
X-Google-Smtp-Source: APXvYqwrLEAFB5O9bxsGKIHjogYbkqKBu7pjTnCF9v/vgbb7R8TIhtoQCKwAw/QYjhF/m1x+onqgAg==
X-Received: by 2002:a17:902:59cd:: with SMTP id d13mr43612993plj.146.1579253579655;
        Fri, 17 Jan 2020 01:32:59 -0800 (PST)
Received: from [2620:15c:17:3:3a5:23a7:5e32:4598] ([2620:15c:17:3:3a5:23a7:5e32:4598])
        by smtp.gmail.com with ESMTPSA id c22sm28137098pfo.50.2020.01.17.01.32.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2020 01:32:59 -0800 (PST)
Date:   Fri, 17 Jan 2020 01:32:58 -0800 (PST)
From:   David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To:     Kirill Tkhai <ktkhai@virtuozzo.com>
cc:     Michal Hocko <mhocko@kernel.org>,
        Wei Yang <richardw.yang@linux.intel.com>, hannes@cmpxchg.org,
        vdavydov.dev@gmail.com, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, yang.shi@linux.alibaba.com,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, alexander.duyck@gmail.com,
        stable@vger.kernel.org
Subject: Re: [Patch v3] mm: thp: grab the lock before manipulation defer
 list
In-Reply-To: <b67fe2bb-e7a6-29fe-925e-dd1ae176cc4b@virtuozzo.com>
Message-ID: <alpine.DEB.2.21.2001170132090.20618@chino.kir.corp.google.com>
References: <20200116013100.7679-1-richardw.yang@linux.intel.com> <0bb34c4a-97c7-0b3c-cf43-8af6cf9c4396@virtuozzo.com> <alpine.DEB.2.21.2001161357240.109233@chino.kir.corp.google.com> <20200117091002.GM19428@dhcp22.suse.cz>
 <b67fe2bb-e7a6-29fe-925e-dd1ae176cc4b@virtuozzo.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 17 Jan 2020, Kirill Tkhai wrote:

> >> I think that's a good point, especially considering that the current code 
> >> appears to unconditionally place any compound page on the deferred split 
> >> queue of the destination memcg.  The correct list that it should appear 
> >> on, I believe, depends on whether the pmd has been split for the process 
> >> being moved: note the MC_TARGET_PAGE caveat in 
> >> mem_cgroup_move_charge_pte_range() that does not move the charge for 
> >> compound pages with split pmds.  So when mem_cgroup_move_account() is 
> >> called with compound == true, we're moving the charge of the entire 
> >> compound page: why would it appear on that memcg's deferred split queue?
> > 
> > I believe Kirill asked how do we know that the page should be actually
> > added to the deferred list just from the list_empty check. In other
> > words what if the page hasn't been split at all?
> 
> Yes, I'm talking about this. Function mem_cgroup_move_account() adds every
> huge page to the deferred list, while we need to do that only for pages,
> which are queued for splitting...
> 

Yup, and that appears broken before Wei's patch.  Since we only migrate 
charges of entire compound pages (we have a mapping pmd, the underlying 
page cannot be split), it should not appear on the deferred split queue 
for any memcg, right?
