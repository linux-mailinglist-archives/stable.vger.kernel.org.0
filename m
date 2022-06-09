Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95B3854488A
	for <lists+stable@lfdr.de>; Thu,  9 Jun 2022 12:15:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234852AbiFIKPc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jun 2022 06:15:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242762AbiFIKPZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jun 2022 06:15:25 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16F8211E4A1
        for <stable@vger.kernel.org>; Thu,  9 Jun 2022 03:15:22 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id a10so20956728pju.3
        for <stable@vger.kernel.org>; Thu, 09 Jun 2022 03:15:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ufJl6VIloac58LmFJOTIIuW4aL5dursujGi4quOZJbo=;
        b=FPueMYm4/4TPKnGa+7C+y/GXKMYfJu6ySLsinY2ZCgrg8+ahFW54U2f+NTWeg+UPMf
         PihxWT6aRHx5VHWmsQa23ZD3YqyGp2jEXZwFJRXC/bu08Gx4LA9VhbMFl9JvW5PnuFzw
         52nupEclf109zIKJ7NJ837fivrbytrq03avp1CbY3AG7JO1PvnnnSY1EUzC/D82X8c/I
         x3Yo7vupRVvhfnG3s7pBht+sp7oJ3uCT6Fy2mWJw0kmDFSRrKGgqdf1MRvD13EGc4Nqi
         /LTKUZ3/JFyEp9xGzfnwLjyRpF1we4mkYGxW8C1qVKc/aN9vJCtC5chbGLdQsM5VQkMZ
         6GcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ufJl6VIloac58LmFJOTIIuW4aL5dursujGi4quOZJbo=;
        b=2nuosu8nnw6UA9VLMKzxqOzZrqBBrF86PERnzgURQunNIM1eeiVnx/3oyxrgb9+1FK
         xXgzPCRWKs7ltTlP0nA6oyVlim4wvPxS3QYwsIJFM67yQcPWtrAzUjkM/vtVXqAJidiX
         V8ZplJ5BDJTBJBcQyiHvCbMN1/2lcZzqvHjZ5dz3t6o7H9o75UDzzZNP4bvppjTi17k/
         uPeuRN8CsgsjcGoS4axuxUMsOF6vPOSM8BnX/ZObTCBAdIJcxq/XO7U0JPYgNbYjaCQ9
         KZn7ILRPT1Duumbl6AdkrlUbxnISpbjqhaYrhzXupmbArnnTnGLi7S3esB/BMulX6Y6F
         hw3w==
X-Gm-Message-State: AOAM532Qdh0Ia3XAcJH+vTdWqQekynkp+DeTaIc9LzsH71NsBTx64yHk
        xixUKYbT3r2N2neJ5S7HXGPJ1A==
X-Google-Smtp-Source: ABdhPJwtXMiI03JSAH/v54Ng0739h8q3umyvW1cZffBfxkhwLE90SKyBifS8Zo6kLL7EHL8HzBmMDQ==
X-Received: by 2002:a17:90b:4f8d:b0:1e8:38f5:e199 with SMTP id qe13-20020a17090b4f8d00b001e838f5e199mr2751665pjb.64.1654769721623;
        Thu, 09 Jun 2022 03:15:21 -0700 (PDT)
Received: from localhost ([139.177.225.238])
        by smtp.gmail.com with ESMTPSA id v12-20020a170902b7cc00b00163f2fe1e64sm16490156plz.255.2022.06.09.03.15.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 03:15:21 -0700 (PDT)
Date:   Thu, 9 Jun 2022 18:15:16 +0800
From:   Muchun Song <songmuchun@bytedance.com>
To:     Michal Hocko <mhocko@suse.com>
Cc:     mcgrof@kernel.org, keescook@chromium.org, yzaikin@google.com,
        akpm@linux-foundation.org, vbabka@suse.cz,
        mgorman@techsingularity.net, peterz@infradead.org,
        dhowells@redhat.com, willy@infradead.org, Liam.Howlett@oracle.com,
        kemi.wang@intel.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] mm: sysctl: fix missing numa_stat when
 !CONFIG_HUGETLB_PAGE
Message-ID: <YqHINBztFFf+Flqm@FVFYT0MHHV2J.usts.net>
References: <20220609040342.2703-1-songmuchun@bytedance.com>
 <YqGzRNnkZIHgx/OM@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqGzRNnkZIHgx/OM@dhcp22.suse.cz>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 09, 2022 at 10:45:56AM +0200, Michal Hocko wrote:
> On Thu 09-06-22 12:03:42, Muchun Song wrote:
> > "numa_stat" should not be included in the scope of CONFIG_HUGETLB_PAGE,
> > if CONFIG_HUGETLB_PAGE is not configured even if CONFIG_NUMA is configured,
> > "numa_stat" is missed form /proc.  Remove it out of CONFIG_HUGETLB_PAGE
> > and move numa_stat sysctl handling to mm/vmstat.c.
> > 
> > Fixes: 4518085e127d ("mm, sysctl: make NUMA stats configurable")
> > Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> > Cc: <stable@vger.kernel.org>
> 
> It really looks like numa_stat is misplaced but I am wondering why the
> fix cannot be as simple as
>

Your changes LGTM. I think I have overdone it. I really should seprate
this into two separate patches, one is bug fix (just like your changes),
another is simplify the code further.  I'll rework this patch.

Thanks.
