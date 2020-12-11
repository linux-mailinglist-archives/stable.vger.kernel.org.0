Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BEB42D6F01
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 05:12:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395253AbgLKEJQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 23:09:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726253AbgLKEIw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 23:08:52 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76E14C0613CF;
        Thu, 10 Dec 2020 20:08:12 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id q22so6168942pfk.12;
        Thu, 10 Dec 2020 20:08:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ius18itnGQVstq9bqYZLUwNWbZ8T7njWch6EzxvjPsA=;
        b=Qd/trmlZE61igq11WRWlvIXhwMKIGAzikr4i85zvqPvP0xZu3RPsj+GWkP7PWqYqbV
         hKhnyA8nl0zK3Y7gS3Dx3zvWWER5pFfzo10n0asMk/GPUnexwT2IK/zJoFBacHO9n/Gr
         qY0uY4Fig/b2Z9L00DDx7YKXxXA3X2735Ip1LrYRoq+nh71jxV9PddF7X63i0gI/qF2i
         0erYwJVM1aO02gLsEjR9/MHMoO5+KLTyC48+qADFNqfjgc8NgPfE6jgbg0CLKlsNzzGx
         WUxPoirrrHCK9E4xjQwcYhiYiPRvE/wxzKsEq9ZZdRyEJSPws1mXYkHP2LaT36f+KUDN
         Fncg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ius18itnGQVstq9bqYZLUwNWbZ8T7njWch6EzxvjPsA=;
        b=YfVxQ4K0dhW81MBw5sy0LpBNEgAKrsklKkmoXUEvLjY9XgMSnpDjrmLetY4Jm7znGa
         hv/J7OExRnoaMHBdoiwdZrOxwl9p4sh6XJmY7NRR/ea9909u/hZMqrRzJ3tlAnKwupp2
         Bd3VrL8WKIThZMo21evvsilc/IryNjiTV3Kc+Ahay1reCTw2u/1XLOJOYVqhTjWXssx7
         e1NeXy5hYLCAQpMnU7R1o5tkuHeepcX01FDaPN+xRGxkJ0uKZRg1rvVZWhbnmC3SrPnc
         DohbX5xJDLnObxzg5MvV3ByNE0oHP7yRWZy46Dpu+gO6Pv1w4hW0IOlbe38/0n4wrE7N
         FJhQ==
X-Gm-Message-State: AOAM533F+D9VGdAO8/FnW/Kda/iDn72osp9tHAhbApT2vnWxjAp2HVZ9
        KR5qurC6AHkXShmheoIriyw=
X-Google-Smtp-Source: ABdhPJy6X+B1ThgRb512lrgxQUK0VKgDoRZDc0qiKYGrIfhMfxa3FRkxaEj/zY8y9KLjoo8S+hWuzw==
X-Received: by 2002:a62:7fc1:0:b029:19f:1dab:5029 with SMTP id a184-20020a627fc10000b029019f1dab5029mr3656993pfd.13.1607659691987;
        Thu, 10 Dec 2020 20:08:11 -0800 (PST)
Received: from localhost ([2401:fa00:8f:203:a6ae:11ff:fe11:4b46])
        by smtp.gmail.com with ESMTPSA id b4sm8017019pju.33.2020.12.10.20.08.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Dec 2020 20:08:11 -0800 (PST)
Date:   Fri, 11 Dec 2020 13:08:07 +0900
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
Message-ID: <20201211040807.GF1667627@google.com>
References: <20201211033657.GE1667627@google.com>
 <X9LsDPsXdLNv0+va@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X9LsDPsXdLNv0+va@sol.localdomain>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On (20/12/10 19:48), Eric Biggers wrote:
> > 
> > [  133.454836] Chain exists of:
> >                  jbd2_handle --> fscrypt_init_mutex --> fs_reclaim
> > 
> > [  133.454840]  Possible unsafe locking scenario:
> > 
> > [  133.454841]        CPU0                    CPU1
> > [  133.454843]        ----                    ----
> > [  133.454844]   lock(fs_reclaim);
> > [  133.454846]                                lock(fscrypt_init_mutex);
> > [  133.454848]                                lock(fs_reclaim);
> > [  133.454850]   lock(jbd2_handle);
> > [  133.454851] 
> 
> This actually got fixed by the patch series
> https://lkml.kernel.org/linux-fscrypt/20200913083620.170627-1-ebiggers@kernel.org/
> which went into 5.10.  The more recent patch to remove ext4_dir_open() isn't
> related.
> 
> It's a hard patch series to backport.  Backporting it to 5.4 would be somewhat
> feasible, while 4.19 would be very difficult as there have been a lot of other
> fscrypt commits which would heavily conflict with cherry-picks.
> 
> How interested are you in having this fixed?  Did you encounter an actual
> deadlock or just the lockdep report?

Difficult to say. On one hand 'yes' I see lockups on my devices (4.19
kernel); I can't tell at the moment what's the root cause. So on the
other hand 'no' I can't say that it's because of ext4_dir_open().

What I saw so far involved ext4, kswapd, khugepaged and lots of other things.

[ 1598.655901] INFO: task khugepaged:66 blocked for more than 122 seconds.
[ 1598.655914] Call Trace:
[ 1598.655920]  __schedule+0x506/0x1240
[ 1598.655924]  ? kvm_zap_rmapp+0x52/0x69
[ 1598.655927]  schedule+0x3f/0x78
[ 1598.655929]  __rwsem_down_read_failed_common+0x186/0x201
[ 1598.655933]  call_rwsem_down_read_failed+0x14/0x30
[ 1598.655936]  down_read+0x2e/0x45
[ 1598.655939]  rmap_walk_file+0x73/0x1ce
[ 1598.655941]  page_referenced+0x10d/0x154
[ 1598.655948]  shrink_active_list+0x1d4/0x475

[..]

[ 1598.655986] INFO: task kswapd0:79 blocked for more than 122 seconds.
[ 1598.655993] Call Trace:
[ 1598.655995]  __schedule+0x506/0x1240
[ 1598.655998]  schedule+0x3f/0x78
[ 1598.656000]  __rwsem_down_read_failed_common+0x186/0x201
[ 1598.656003]  call_rwsem_down_read_failed+0x14/0x30
[ 1598.656006]  down_read+0x2e/0x45
[ 1598.656008]  rmap_walk_file+0x73/0x1ce
[ 1598.656010]  page_referenced+0x10d/0x154
[ 1598.656015]  shrink_active_list+0x1d4/0x475

[..]

[ 1598.658233]  __rwsem_down_read_failed_common+0x186/0x201
[ 1598.658235]  call_rwsem_down_read_failed+0x14/0x30
[ 1598.658238]  down_read+0x2e/0x45
[ 1598.658240]  rmap_walk_file+0x73/0x1ce
[ 1598.658242]  page_referenced+0x10d/0x154
[ 1598.658247]  shrink_active_list+0x1d4/0x475
[ 1598.658250]  shrink_node+0x27e/0x661
[ 1598.658254]  try_to_free_pages+0x425/0x7ec
[ 1598.658258]  __alloc_pages_nodemask+0x80b/0x1514
[ 1598.658279]  __do_page_cache_readahead+0xd4/0x1a9
[ 1598.658282]  filemap_fault+0x346/0x573
[ 1598.658287]  ext4_filemap_fault+0x31/0x44

	-ss
