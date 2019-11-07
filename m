Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6DDF2357
	for <lists+stable@lfdr.de>; Thu,  7 Nov 2019 01:26:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727597AbfKGA0r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Nov 2019 19:26:47 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:32789 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfKGA0q (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Nov 2019 19:26:46 -0500
Received: by mail-pl1-f194.google.com with SMTP id ay6so137097plb.0
        for <stable@vger.kernel.org>; Wed, 06 Nov 2019 16:26:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=KEOopLJ5iB8RmpEZTW4jEm10x8g53h0m9wq9YjVBDLY=;
        b=lFJWdmZXI9+2+oMrIJP43CTG56fV3KIfPp/Qh8xHL8cg35kS1x4Dp/SxrZkjsSECvk
         KJmBS+bONNbKXnrVc6mASGrPB7I+usQ0ttu+yCrsvvJF+Zc/64T9RuJWm4e4HJQ3LQI0
         S0ClECVzkELJiWf/U675WfVrtD4a4MaUM3tKXceQuKbqOxVAcPEKLaIjojA8q7RyvF9x
         TgjKMAtx+UWfzcbO+ICuL/CXdUpPbrjlktWidyLEk6HT/XVA6R/m+Te9n4lSFOybVZMy
         u0Yx8eJBr2sz/L5GfPpGaXnsb0G1tcE0FLjYAo8nEzCYzF0FN9eqicVMSY6W4Jl91EQ3
         0R1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=KEOopLJ5iB8RmpEZTW4jEm10x8g53h0m9wq9YjVBDLY=;
        b=dIQDnuSE92MUKTohw8p9UubfBBnjoviKUyUQMbVPehor4NC0mf0ayECr4FT05OznKW
         OkRkG3q1HcUKTvaOcaU1nxE9Y+N8zlELiL5vhBJ/uVWPSmlKAN70kHNC/fGQ13OU0yTR
         ZfzrLEZK8/Bzoumo9sI4xd+FKpGvh3b1dBOLI/oQ0xa61dtlGl65wZ29MaayK3Ha+3+2
         N3zmuZTFBWb2B4jw62THAUmf4jGUae8hf3JcUiOtPDkUjYKaH/dFgYX0VsyyyKjbeK4W
         KV6/+QXBoN2ym8AM/CYO8vd7tKkDyzZD88kQrQtn4znB7on5iLMy8lucycUqRPGZetP1
         vKbg==
X-Gm-Message-State: APjAAAV3mp7IE6o25hsc17Wbc8KJhwH3Qv8nBsegl5ZFFfV7k1zkXynM
        WoV6vt8lEhq8Wbv/xDOxSXLmzQ==
X-Google-Smtp-Source: APXvYqzNhi4Z4rqSd1SYZHPd68UCauRrDczwT9rsRKj8pjv7pVf3AFuzhiJThxTX5L2Fg9OfLaicyA==
X-Received: by 2002:a17:902:7d90:: with SMTP id a16mr481361plm.149.1573086406181;
        Wed, 06 Nov 2019 16:26:46 -0800 (PST)
Received: from localhost ([2620:10d:c090:200::2:deb0])
        by smtp.gmail.com with ESMTPSA id l3sm169756pff.9.2019.11.06.16.26.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2019 16:26:45 -0800 (PST)
Date:   Wed, 6 Nov 2019 16:26:44 -0800
From:   Johannes Weiner <hannes@cmpxchg.org>
To:     Roman Gushchin <guro@fb.com>
Cc:     linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>, linux-kernel@vger.kernel.org,
        kernel-team@fb.com, stable@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] mm: hugetlb: switch to css_tryget() in
 hugetlb_cgroup_charge_cgroup()
Message-ID: <20191107002644.GB96548@cmpxchg.org>
References: <20191106225131.3543616-1-guro@fb.com>
 <20191106225131.3543616-2-guro@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191106225131.3543616-2-guro@fb.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
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

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
