Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93AFE2CF072
	for <lists+stable@lfdr.de>; Fri,  4 Dec 2020 16:12:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730348AbgLDPLw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Dec 2020 10:11:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730289AbgLDPLw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Dec 2020 10:11:52 -0500
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13BA7C0613D1
        for <stable@vger.kernel.org>; Fri,  4 Dec 2020 07:11:12 -0800 (PST)
Received: by mail-qk1-x741.google.com with SMTP id i199so5665482qke.5
        for <stable@vger.kernel.org>; Fri, 04 Dec 2020 07:11:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sl6eaPlhSG6WYUXzEE1vFTr+0n+0v0XVzNUTOkRqEt4=;
        b=QgZZ1TF4r/vQd/hna9Wf9jDMaIu10j3666w1c2L79HFEr15x81l29nUiYf0iJL6+VR
         sBwYnMPD9+RpFSVQy0VHKH52hu69D+jerH0jbVGIS3FplyW/pRaDpx4T2lnXnB3dYRxh
         J1Gf0foIucAdUNqOkbk+g/WNI3j6q40qqWlHfZflKMYvfkf9R+Q0ksNjV9IWfhkyOZZJ
         oeeDIrYKrXwken90O2ivmh6TE3ADiGlao386eX7YQjN0g/woN8O05eqPiJYMD0v/x/JB
         KIXIVAXTSoUwuGa45nbNZ96PzYNcc1BNEqlOa8ETsSPMOTjQaiPn5nGB20FpCc5rwDSJ
         lPVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sl6eaPlhSG6WYUXzEE1vFTr+0n+0v0XVzNUTOkRqEt4=;
        b=j6F0dg346plHfYN31Z1nQjJBj4NMzMBjoiVwmxYZjamYa1fhH7qijTccPPv8XI9mk2
         fQl3KhhEoQuNCFSJcUsLmNgmN7pV26vA3UO7pwgPTEmxlt/YQzP9THyZv6EDyUDfPR4+
         qRZCLKw9FoK4BKZzIKrizIZs6xX8fual7w8dJdJ967prm1lcYzmifjR+7E8O18upLcRz
         oJsu4uxUdHV7lJYPqLFw9Cc7CtCSdwj42ZIfbuSdIXB54l7KjPOUteANgIx9tAiWtd8X
         qpcwgpdmVhyU6lxDDSNsZvqZXwD5uUkJEiqWIUdyV2dBORe21MRzuJoIJK6z7ooCysuW
         RjbQ==
X-Gm-Message-State: AOAM530MNLiUOIudU211EPlmajzc5SyrlRFhXSAQu+cmePrzszMHe+DI
        o6HuWdbm5Caj82VRGTNsOU66Hw==
X-Google-Smtp-Source: ABdhPJx3XgCSBCF7e90fsWH+mJ4z0fv5M5FFICgAQtmN2Uy1Xh3mFb2TiHci3/8aEBQYrn5VcrA1XQ==
X-Received: by 2002:a37:a390:: with SMTP id m138mr9134038qke.18.1607094671168;
        Fri, 04 Dec 2020 07:11:11 -0800 (PST)
Received: from ziepe.ca ([206.223.160.26])
        by smtp.gmail.com with ESMTPSA id d16sm5250322qkc.58.2020.12.04.07.11.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Dec 2020 07:11:10 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1klCjl-005uYg-8g; Fri, 04 Dec 2020 11:11:09 -0400
Date:   Fri, 4 Dec 2020 11:11:09 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Liu Zixian <liuzixian4@huawei.com>
Cc:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        louhongxiang@huawei.com, linux-mm@kvack.org, hushiyuan@huawei.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] fix mmap return value when vma is merged after
 call_mmap()
Message-ID: <20201204151109.GA5487@ziepe.ca>
References: <20201203085350.22624-1-liuzixian4@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201203085350.22624-1-liuzixian4@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 03, 2020 at 04:53:50PM +0800, Liu Zixian wrote:
> On success, mmap should return the begin address of newly mapped area,
> but patch "mm: mmap: merge vma after call_mmap() if possible"
> set vm_start of newly merged vma to return value addr.
> Users of mmap will get wrong address if vma is merged after call_mmap().
> We fix this by moving the assignment to addr before merging vma.
> 
> Fixes: d70cec898324 ("mm: mmap: merge vma after call_mmap() if possible")
> Signed-off-by: Liu Zixian <liuzixian4@huawei.com>
> ---
> v2:
> We want to do "addr = vma->vm_start;" unconditionally,
> so move assignment to addr before if(unlikely) block.
> ---
>  mm/mmap.c | 26 ++++++++++++--------------
>  1 file changed, 12 insertions(+), 14 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
