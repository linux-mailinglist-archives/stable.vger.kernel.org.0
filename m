Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C58168389C
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 22:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232183AbjAaV1y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 16:27:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232214AbjAaV1t (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 16:27:49 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB0725618F;
        Tue, 31 Jan 2023 13:27:46 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id 78so11035266pgb.8;
        Tue, 31 Jan 2023 13:27:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AzK7zbHqMHdeBmanV3yZyUjocxSjOS0P2zK4GlPV5fg=;
        b=D6wvD2En7fL/J4jxZGOIQBNq1r2srmO4HOmSSPNUtrliYfnfu+LBoGk5BxIcMiuq2I
         +zwJ+mRwxgYtBtoDsGT1p7nE5JifYqFUf8hP1sgEtkOKyHfWhW4umWi9ewBl4h6lpann
         1FKRMTut+C+QYs/Mg9T/XGdMWHxAvc4vm7coGsd3WvOgoQt73PDTLpV3MfO+X+lC2HD/
         QNpAi6vLbe5SEo1NIxJIxqYOYG4hgDKEIE7e8sbyQhb8Yes6j5hPRgz/GjUPNoMDssZL
         IfTNvheB70L2NHCzBcWcOzJp3YlrWN80ciuNtnhhN2fCo38Ky5KInmRB9oeQm46P5CX+
         WVnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AzK7zbHqMHdeBmanV3yZyUjocxSjOS0P2zK4GlPV5fg=;
        b=6YN+Wct8BdUN/kT/tPaAhOxv0QX3gGAPiyGCpIXh0VS2nANxzdChcTdyHeEL7AoI8k
         B1pmLVfHVlIx/VHBopABxBSjinwofhX5Tne0P4DOnLlR9FHZ2EGE584s2wlAhvWs/JoO
         vDMi7plbtRR8se3VgzQ+4nZsKO5YeWJVI137PqkdUuNRS4292df026XnBCci7pNVoXvE
         9bCq/mJZ/QOUAEAOqW0HpN5H6yVhiA4Lt96VIa/eEsdi3t7MvcNuH+q9da03pNtYcOCp
         CfRSPdZQ9Tsfc2q3mJDdEzXyiqLfeShghq2R8t6j9MBRjHJFfFirWPa5bJCGLbkXaDSR
         glLA==
X-Gm-Message-State: AO0yUKU8ZF9dr9W733ACgh7KdsDFgLjCsYpxU37Zt7ID71+3Si/py76l
        7Z5K4K99sEKpbkriHVwvLjY=
X-Google-Smtp-Source: AK7set+AB9728U0/MEi1UBcwr36wg/R1RBbFv281U6594rkVfdnrCQy9OnZENcOw/xOdf9mhMZ4riA==
X-Received: by 2002:a62:7b0e:0:b0:593:a131:3692 with SMTP id w14-20020a627b0e000000b00593a1313692mr4489pfc.13.1675200466095;
        Tue, 31 Jan 2023 13:27:46 -0800 (PST)
Received: from localhost ([2620:10d:c090:400::5:1ad6])
        by smtp.gmail.com with ESMTPSA id j14-20020a62e90e000000b00590684f016bsm9913968pfh.137.2023.01.31.13.27.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 13:27:45 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Tue, 31 Jan 2023 11:27:44 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        stable@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH] fscrypt: Copy the memcg information to the ciphertext
 page
Message-ID: <Y9mH0PCcZoGPryXw@slm.duckdns.org>
References: <20230129121851.2248378-1-willy@infradead.org>
 <Y9a2m8uvmXmCVYvE@sol.localdomain>
 <Y9bkoasmAmtQ2nSV@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9bkoasmAmtQ2nSV@casper.infradead.org>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

On Sun, Jan 29, 2023 at 09:26:57PM +0000, Matthew Wilcox wrote:
> > > diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
> > > index e78be66bbf01..a4e76f96f291 100644
> > > --- a/fs/crypto/crypto.c
> > > +++ b/fs/crypto/crypto.c
> > > @@ -205,6 +205,9 @@ struct page *fscrypt_encrypt_pagecache_blocks(struct page *page,
> > >  	}
> > >  	SetPagePrivate(ciphertext_page);
> > >  	set_page_private(ciphertext_page, (unsigned long)page);
> > > +#ifdef CONFIG_MEMCG
> > > +	ciphertext_page->memcg_data = page->memcg_data;
> > > +#endif
> > >  	return ciphertext_page;
> > >  }
> > 
> > Nothing outside mm/ and include/linux/memcontrol.h does anything with memcg_data
> > directly.  Are you sure this is the right thing to do here?
> 
> Nope ;-)  Happy to hear from people who know more about cgroups than I
> do.  Adding some more ccs.
> 
> > Also, this patch causes the following:
> 
> Oops.  Clearly memcg_data needs to be set to NULL before we free it.

These can usually be handled by explicitly associating the bio's to the
desired cgroups using one of bio_associate_blkg*() or
bio_clone_blkg_association(). It is possible to go through memcg ownership
too using set_active_memcg() so that the page is owned by the target cgroup;
however, the page ownership doesn't directly map to IO ownership as the
relationship depends on the type of the page (e.g. IO ownership for
pagecache writeback is determined per-inode, not per-page). If the in-flight
pages are limited, it probably is better to set bio association directly.

Thanks.

-- 
tejun
