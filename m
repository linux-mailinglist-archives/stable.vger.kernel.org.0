Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83AB9F33AA
	for <lists+stable@lfdr.de>; Thu,  7 Nov 2019 16:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389109AbfKGPoQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Nov 2019 10:44:16 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:39777 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388901AbfKGPoQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Nov 2019 10:44:16 -0500
Received: by mail-qk1-f195.google.com with SMTP id 15so2365387qkh.6;
        Thu, 07 Nov 2019 07:44:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/VLsWSGCw7M78G2ciEeMt8ki0nUc+nWXcIjdygNoX4M=;
        b=POhLYOxufAI7xHlzUJDemniGTcznmIvhHjolHRByJVTX3xroAktxe3C1Liz/KxCXZ6
         6VaC61mFQW0hAuUJlPxrGVCEzcw2PkEKtvRl/1fnuD/Ag6A7t5p/cwE6gBWJptUI60Vk
         e7V9SH8Fe3pHCGnaPrPWX7HMYocKHMr/nJa2UcRmmpYynv24nKSwcNzkqdvw5fc3xFTW
         5DPNQz2AZIX8ZEgYZhdcp2jrSvcUALboEuXkf5JBt1iEZtM7OLE1rgbj767PvQ1fMnAO
         ROaVcKgdglj5gXWKGQh0RjoC5feo/Iv3LeIPq0C2wwP1PXRpKv+wFE0bxrGEw5cPehHw
         DYnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=/VLsWSGCw7M78G2ciEeMt8ki0nUc+nWXcIjdygNoX4M=;
        b=cGqQ+AfKJkoldgyFi/dws2KebqKLznAuRiJnhaUcw9ulXOtuoj4bnJfpjLpOk2Gs4W
         qLwE9L5UUMPR6K5MkKMtSOgApEcPS/W2Ro+veqUfsN7Iw1+lgV8c3cfMQc/J/72Ygzzw
         ISVKACDaFm5yaXUhzInNlR3M+anQcODB7XkRmi/c8MSS10+nDXAvsX4z1QkG/KmSzhRf
         FfZvM7POECNyWRe0nm9EzVtO5PwdQvJOrKymKH0hu4WSOdrRLp727L8UEcLlLmrfFoEN
         CBQ2VrOw7CFKD6ylW78kNXkdgMAcZZWuWtlC8jZIoY5ScgdLVfjuabBCDh3X+H8j2lW9
         hoCQ==
X-Gm-Message-State: APjAAAVme72tYQPZ5PQYuy7m1U3BC0tbOiRcky4RG/UJ2I8SwCBWuUL+
        IS7/quzfU/jnIA/4N0siZvw=
X-Google-Smtp-Source: APXvYqynNCHiUDdEWnZVcJRvtZWFE3Xbj5ykMaCKEADa4CIKtYZS7E5JETW/Bpzi8CvOCLGCFF7hug==
X-Received: by 2002:a37:a950:: with SMTP id s77mr3448271qke.463.1573141454976;
        Thu, 07 Nov 2019 07:44:14 -0800 (PST)
Received: from localhost ([2620:10d:c091:500::2:3f13])
        by smtp.gmail.com with ESMTPSA id 19sm1330971qkg.89.2019.11.07.07.44.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Nov 2019 07:44:14 -0800 (PST)
Date:   Thu, 7 Nov 2019 07:44:13 -0800
From:   Tejun Heo <tj@kernel.org>
To:     Roman Gushchin <guro@fb.com>
Cc:     linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        linux-kernel@vger.kernel.org, kernel-team@fb.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: hugetlb: switch to css_tryget() in
 hugetlb_cgroup_charge_cgroup()
Message-ID: <20191107154413.GZ3622521@devbig004.ftw2.facebook.com>
References: <20191106225131.3543616-1-guro@fb.com>
 <20191106225131.3543616-2-guro@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191106225131.3543616-2-guro@fb.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 06, 2019 at 02:51:31PM -0800, Roman Gushchin wrote:
> An exiting task might belong to an offline cgroup. In this case
> an attempt to grab a cgroup reference from the task can end up
> with an infinite loop in hugetlb_cgroup_charge_cgroup(), because
> neither the cgroup will become online, neither the task will
> be migrated to a live cgroup.
> 
> Fix this by switching over to css_tryget(). As css_tryget_online()
> can't guarantee that the cgroup won't go offline, in most cases
> the check doesn't make sense. In this particular case users of
> hugetlb_cgroup_charge_cgroup() are not affected by this change.
> 
> A similar problem is described by commit 18fa84a2db0e ("cgroup: Use
> css_tryget() instead of css_tryget_online() in task_get_css()").
> 
> Signed-off-by: Roman Gushchin <guro@fb.com>
> Cc: stable@vger.kernel.org
> Cc: Tejun Heo <tj@kernel.org>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
