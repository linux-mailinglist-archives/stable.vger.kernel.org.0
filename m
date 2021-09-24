Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EDC24168D4
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 02:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243621AbhIXAR7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Sep 2021 20:17:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:31632 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236352AbhIXAR6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Sep 2021 20:17:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632442584;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bcJHGrbVrok/puPN7U+j5l98fkTL9q1bHJVrXWV2gUI=;
        b=O9ThL9A81lLU1YtL4IwDhF+5I61cMfzuKIh+X7k4p3wr3F4XEyjy/36ISt0n2trpn4yJhg
        235mFlAfe25FlIZsoYxaD5JzCX2ZoJ5j3m+DkgwESTPcjG4PgTy2NQGAfmNIUOkvqttKoA
        yrAMquQNzOtI9cvsDp3/U5yeOTuYHwQ=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-51-tHthIyroPWGZq-RZvgKwEQ-1; Thu, 23 Sep 2021 20:16:22 -0400
X-MC-Unique: tHthIyroPWGZq-RZvgKwEQ-1
Received: by mail-qv1-f70.google.com with SMTP id p75-20020a0c90d1000000b0037efc8547d4so27664334qvp.16
        for <stable@vger.kernel.org>; Thu, 23 Sep 2021 17:16:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bcJHGrbVrok/puPN7U+j5l98fkTL9q1bHJVrXWV2gUI=;
        b=l5cbVS5i6C9fW7Rmw+g17f5mA+QbmhEu45JUJL/8CcASZL+KF0shCLIjJ0D5ECSCrC
         OtN6rstyAaY4oOLmANaTQNKu1D0vKRDa7iBkW2SKGjjXQTxCftKa/ZsX9CKB4J61dppB
         vHcQAhqNNVmJE8uroKqH8qhj4pccnQFega08LpGvjR6x9bcERQPCaR3jfn6RPBbBV1JI
         Su8bYrXCpQo3w6ljJwOv+TqIhvhGclO3CuFW2bOOxWLgbqEOwzFnwRHDDnQub/NMN3Fv
         lfnK2wvabyCQCDj3I03SOsBJO01vCsTE//9RGzRs5wpcZAsSdZH94j0zYsVyWfQMXpAQ
         /Ziw==
X-Gm-Message-State: AOAM530lGQEF4XjArwnt//iAh6Y5lEOEPoyHO2rIDH2s5qdTFgAmzuIL
        aSLC9LdgahA2zUlmHKri/BPTo9nB9oKNKMIRF0MMfpqjBrAZWuryHy105L6OtyvPRAyGMC/WcrA
        WVBvusYA58E4nLWvX
X-Received: by 2002:ad4:4671:: with SMTP id z17mr7540869qvv.62.1632442582377;
        Thu, 23 Sep 2021 17:16:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzt4VN3dyUV71vYtJqa+uT4n4219syJ2qIIsc4SgS9eeq/Vm275w4yivFfacM2Y2MzU13kKOQ==
X-Received: by 2002:ad4:4671:: with SMTP id z17mr7540849qvv.62.1632442581978;
        Thu, 23 Sep 2021 17:16:21 -0700 (PDT)
Received: from t490s ([2607:fea8:56a2:9100::d3ec])
        by smtp.gmail.com with ESMTPSA id h4sm5098180qkp.86.2021.09.23.17.16.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 17:16:21 -0700 (PDT)
Date:   Thu, 23 Sep 2021 20:16:19 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Li Wang <liwang@redhat.com>
Cc:     Nadav Amit <nadav.amit@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, linux-fsdevel@vger.kernel.org,
        Nadav Amit <namit@vmware.com>,
        Andrea Arcangeli <aarcange@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH] userfaultfd: fix a race between writeprotect and
 exit_mmap()
Message-ID: <YU0Y045lHEpdIu3X@t490s>
References: <20210921200247.25749-1-namit@vmware.com>
 <CAEemH2d++nJmTkMYzNsJ-KsfdoQ=WHSFpY=EfBZn2jqVauBGAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAEemH2d++nJmTkMYzNsJ-KsfdoQ=WHSFpY=EfBZn2jqVauBGAw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 22, 2021 at 05:06:53PM +0800, Li Wang wrote:
> Hi,

Li,

> 
> I confirmed this patch (applied on 5.14) gets rid of the below userfaultfd
> test failure.
> 
> # ./userfaultfd anon 16 2
> nr_pages: 4096, nr_pages_per_cpu: 256
> bounces: 1, mode: rnd read, userfaults: 313 missing
> (51+34+37+26+41+28+15+20+16+12+13+7+10+2+0+1) 995 wp
> (121+79+96+53+90+104+48+61+56+82+56+41+49+26+11+22)
> bounces: 0, mode: read, userfaults: 64 missing
> (15+8+10+6+5+2+4+3+3+1+4+0+0+2+0+1) 2157 wp
> (223+274+189+141+116+132+203+153+143+126+110+114+101+66+42+24)
> testing uffd-wp with pagemap (pgsize=4096): done
> testing uffd-wp with pagemap (pgsize=2097152): done
> testing UFFDIO_ZEROPAGE: done.
> testing signal delivery: done.
> testing events (fork, remap, remove): ERROR: nr 3933 memory corruption 0 1
>  (errno=0, line=963)
> ERROR: faulting process failed (errno=0, line=1117)

Just to keep a record within this thread - my understanding is above issue is a
separate issue from what Nadav has fixed.  The other fix could be:

  https://lore.kernel.org/lkml/20210923232512.210092-1-peterx@redhat.com/

When verify with Nadav's patch, please check whether you have thp enabled
globally:

  # echo always > /sys/kernel/mm/transparent_hugepage/enabled

Thanks,

-- 
Peter Xu

