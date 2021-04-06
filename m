Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7D0E355DAA
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 23:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232856AbhDFVLi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 17:11:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232861AbhDFVLi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 17:11:38 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11F6AC06174A;
        Tue,  6 Apr 2021 14:11:30 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id h7so12275285qtx.3;
        Tue, 06 Apr 2021 14:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5oMy+AxrchMa7qNBGPpnhH2Zlo695zWTE08uCBLDOgg=;
        b=U7AOIAmeZPyMFndmbgGGctXp4tWrR8AQhS7TppV+/uYwTJP5cFEbyNQfCMAR4oEog4
         t8Xz0bOszImDDSa3CHGL5amtMUzI7G7cqW7vikEeqi7txTiBytmLYcv3pXlJKaO0GEWL
         jUybfMPQkGF1PC7pQ+MFQtD3U6CwBNabjzP7Yz6wlMyeuBHc+8QCVNM1m1Nadr+UNoLz
         pNagOYHVa3beUM9DfFTX/a/V5jiNAXKR2WztQJmY4ACQz12TDV+yiB6RASW25W/dk1Xh
         BF5tO/uSK3CXs0qrnsfYoidAhatH3PJALHyTOyX2z03NrR6eWj7zWeZm/MxNZQq746PZ
         /SfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5oMy+AxrchMa7qNBGPpnhH2Zlo695zWTE08uCBLDOgg=;
        b=R0Evn1+IcYxqNotBhEmM7wcgTh1hb1XJzeaTZDXIyYjq+xqaknwEjFfeUMiOoWAWuI
         eoJUmJyaoqMNZKNc23BRZ6rpcpYt90UNukFX7RdZrQ7i8KA+kwB0UObYtjtb7wAucsA6
         1CRi28s/NWy/0vP4FRRigNAu9oiQ2DmpVIQ06yVTYIGH1CFUVVXhHgHRYUuEx/AfKzmr
         WUVEvOACuSULAB/9j9PrR+pWb8SEVTqzrFCVvP3xW84wZwV99c3YJTMqKKnd+J9YcPLl
         VVQvZlRkqsOKT1PgwKutbgdiKxM8DEeA2LF6jd8B6Ce8+OiI+3oFsVcVvbfMP1/v93kD
         ylxw==
X-Gm-Message-State: AOAM530J09SQDHGOBBf8pemC8fnqU/uwuFjVDnFq7f4arVv1aqTFnuij
        /IPXMOaMQ1mnjOo7UvDcbkU=
X-Google-Smtp-Source: ABdhPJyPCcC8Is/S1xJmNV+NFDhGvIIS29M76iqFYux8sAvPItCoQiIj4P9sRarK/4E5LpAT/fVjTQ==
X-Received: by 2002:ac8:7fcc:: with SMTP id b12mr28732609qtk.343.1617743489361;
        Tue, 06 Apr 2021 14:11:29 -0700 (PDT)
Received: from localhost.localdomain (c-73-60-226-25.hsd1.nh.comcast.net. [73.60.226.25])
        by smtp.gmail.com with ESMTPSA id g2sm15933477qtu.0.2021.04.06.14.11.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 14:11:28 -0700 (PDT)
Date:   Tue, 6 Apr 2021 17:11:26 -0400
From:   Eric Whitney <enwlinux@gmail.com>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Eric Whitney <enwlinux@gmail.com>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 004/126] ext4: shrink race window in
 ext4_should_retry_alloc()
Message-ID: <20210406211126.GA14411@localhost.localdomain>
References: <20210405085031.040238881@linuxfoundation.org>
 <20210405085031.189492366@linuxfoundation.org>
 <20210405152908.GA32232@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210405152908.GA32232@amd>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* Pavel Machek <pavel@ucw.cz>:
> Hi!
> 
> > From: Eric Whitney <enwlinux@gmail.com>
> 
> > A per filesystem percpu counter exported via sysfs is added to allow
> > users or developers to track the number of times the retry limit is
> > exceeded without resorting to debugging methods.  This should provide
> > some insight into worst case retry behavior.
> 
> This adds new counter exported via sysfs, but no documentation of that
> counter...
> 
> Best regards,
> 								Pavel
> 

Thanks for the observation.  I'll check with Ted to see what he'd like.

Eric


> > @@ -257,6 +259,7 @@ static struct attribute *ext4_attrs[] = {
> >  	ATTR_LIST(session_write_kbytes),
> >  	ATTR_LIST(lifetime_write_kbytes),
> >  	ATTR_LIST(reserved_clusters),
> > +	ATTR_LIST(sra_exceeded_retry_limit),
> >  	ATTR_LIST(inode_readahead_blks),
> >  	ATTR_LIST(inode_goal),
> >  	ATTR_LIST(mb_stats),
> 
> -- 
> http://www.livejournal.com/~pavelmachek


