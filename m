Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D52E2F4A54
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 12:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728429AbhAMLfM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 06:35:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727403AbhAMLfL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jan 2021 06:35:11 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79937C061786;
        Wed, 13 Jan 2021 03:34:31 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id n25so1337701pgb.0;
        Wed, 13 Jan 2021 03:34:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dth9qsoBxQdg0Q+nb23OtMhlRan8r4Tw7UF7z6sod7E=;
        b=q66bTbptdxvrBdYbSGImEFekplRIEDpjdsqyrEo+WPMpWnfah/1wOXSQyl9AbbeiWC
         y/xg6C3m24NRpZQJXJ9EG+p1lbhdIgtjngrRsoC9KaBPN8ISUNjUOgHz2Xfzrn4f7PQy
         zyN4u7krT8ci6JXbsZRHSR88Vb/9UBMpd+HqxQiPXSWYF/l5HkTjxPo9ZvpUtZbgvr0T
         ejmIsABe8+E9qpthYtS/bMvEZ+ef7cW7MpuD8UEnvyDzGhB9OeOH7B5g04tGBNGHcsiX
         u3FO9DY0uFV99S4tOtlTWQ8AqMxCaLI4Ur4h9wFRlVyoSH1grHeFtjGjfxhZ6ELOUnBO
         EeEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dth9qsoBxQdg0Q+nb23OtMhlRan8r4Tw7UF7z6sod7E=;
        b=c5gunggot42bMnBuRiuiG/x0+0RtQvZOr/TxBBG8afs7pBO85iGbfpslyusLVv/tT2
         9yzW5ZQGtunAshNHELLWQRvVC2jwVSrFXDytDAk2L6vkx5XR2vqLQVg1xU80zNMdDYTd
         Kk2/tttvS0z9IF2Z/mDO6eId3M+daCT1WaRq6YNacSxfVwJ0Lv5TvZuyvDz4J8/41JQr
         Kw28aBERvQu7TFIkWzigu5qkHbQ/30AuJBiyEJ+xes1boRpgxCEi2Jk5n9JWxx9EiKR/
         KLZ8N8u4s+Xw1uN+nMZ5s5bcGs+fEREHOdaNUJ6iw0unC+G0Kg94eUuDPvLCpvDONQ9s
         0MJA==
X-Gm-Message-State: AOAM531mbEveGTflFXGFkovLfEmtGYzjRI38EuCySE86STCGGqg4SsyZ
        MegLmqDC1ZFkmyXL27qOnnE=
X-Google-Smtp-Source: ABdhPJwcVvKok/Q0yW/9KyCHM5jCd6JQ/SwGesVC4emseSMqb2pcXCh+q6oCvyHuMJqdXy3EpolXeA==
X-Received: by 2002:a62:5b07:0:b029:1ae:177d:69e1 with SMTP id p7-20020a625b070000b02901ae177d69e1mr1750169pfb.25.1610537671050;
        Wed, 13 Jan 2021 03:34:31 -0800 (PST)
Received: from localhost ([100.87.84.221])
        by smtp.gmail.com with ESMTPSA id c62sm2314832pfa.116.2021.01.13.03.34.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 03:34:30 -0800 (PST)
Date:   Wed, 13 Jan 2021 20:34:12 +0900
From:   Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Suleiman Souhlal <suleiman@google.com>,
        linux-fscrypt@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [stable] ext4 fscrypt_get_encryption_info() circular locking
 dependency
Message-ID: <X/7atDqEyQTb+sGW@google.com>
References: <20201211033657.GE1667627@google.com>
 <X9LsDPsXdLNv0+va@sol.localdomain>
 <20201211040807.GF1667627@google.com>
 <X9O0brQ7junfZTfI@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X9O0brQ7junfZTfI@sol.localdomain>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

Eric, sorry for the delay.

On (20/12/11 10:03), Eric Biggers wrote:
> > [..]
> > 
> > [ 1598.658233]  __rwsem_down_read_failed_common+0x186/0x201
> > [ 1598.658235]  call_rwsem_down_read_failed+0x14/0x30
> > [ 1598.658238]  down_read+0x2e/0x45
> > [ 1598.658240]  rmap_walk_file+0x73/0x1ce
> > [ 1598.658242]  page_referenced+0x10d/0x154
> > [ 1598.658247]  shrink_active_list+0x1d4/0x475
> > [ 1598.658250]  shrink_node+0x27e/0x661
> > [ 1598.658254]  try_to_free_pages+0x425/0x7ec
> > [ 1598.658258]  __alloc_pages_nodemask+0x80b/0x1514
> > [ 1598.658279]  __do_page_cache_readahead+0xd4/0x1a9
> > [ 1598.658282]  filemap_fault+0x346/0x573
> > [ 1598.658287]  ext4_filemap_fault+0x31/0x44
> 
> Could you provide some more information about what is causing these actual
> lockups for you?  Are there more stack traces?

I think I have some leads, and, just like you said, this deos not appear
to be ext4 related.

A likely root cause for the lockups I'm observing, is that kswapd
and virtio_balloon have reverse locking order for THP pages:

	down_write(mapping->i_mmap_rwsem)  -->  page->PG_locked
vs
	page->PG_locked --> down_read(mapping->i_mmap_rwsem)

	-ss
