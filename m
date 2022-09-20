Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5349D5BDBC0
	for <lists+stable@lfdr.de>; Tue, 20 Sep 2022 06:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbiITEol (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 00:44:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbiITEoj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 00:44:39 -0400
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FFE860D6;
        Mon, 19 Sep 2022 21:44:38 -0700 (PDT)
Received: by mail-vs1-xe2a.google.com with SMTP id j17so1826681vsp.5;
        Mon, 19 Sep 2022 21:44:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=tXGR021bV9JvSSgG+0qjXLX+nPkxl9Ea7FWm8xT3kpM=;
        b=acpN0oyt9/ziZ3d4ynVlyaHAIuh/IKVIM8X1vEenO3z1hxuEMJZXPJ7EfBbdEI8u9u
         3eLKhisalgomCaHvIusJ10jgNN3GCdWIPPY3QpUS9+rvPSth5RdT6rLK74DZC0+P9Jaj
         opagpi2WjhxCjZpBsEjWivdXeehF9pEFnHC2+79adWFsi0QuBddWZFtfd+wDorjq0MDY
         2abTgsuXukf10juUhOIe+Xy9r4Uw9EekghOFVGJN53X7pHPJfU96QKKOv3ABjTR7ZHPn
         mmZuutMjn/tRkA6cn5TZ/AHEU36Lws93V0PDkX9OhpBVf5asmjNNJc5rHyxZq7/4vF4r
         +VfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=tXGR021bV9JvSSgG+0qjXLX+nPkxl9Ea7FWm8xT3kpM=;
        b=7z2REITvCwoVjijKMgwt4poJWw4KNU6w+zibZrn2eL1wre4BtnlOuqrwKUn614Jl/9
         py82dEwih/LxHLRFQhwCAMoIfgL9Z8AcORmgHkQYQDqM7DnpAOPdPfhv29Aygqa8tmBn
         G6yL0D4wgE00X5GTCVtV0fudqISyz/x2d8UfVOOgk5V69ql6Lm5E5wVj7DEFR4hS6VYb
         bREGnLXltsV9hLFeIEVgzQBAV/XieRC4Tj9s1K9kPiBEPnxeZqyPwRwGlB+ZajHdn4zi
         Lgv+2wXf6c+APZCsBKGmNphGxjh5KTtLvPrhpG3wTXe5+GWgkKLg94soZB4mapvJQ4wL
         KRNQ==
X-Gm-Message-State: ACrzQf3okrxamZSGpT76Ayl7I6/OxFGKFNNbxOBoJyX7YiWuzJ1mwGu3
        vSuYrvZV7EArzcrg2dPoqfeXN+ThsP+tKrdR6cU=
X-Google-Smtp-Source: AMsMyM5CXaqr9hSXGr5kLhzp1MN0GT0z+jDsgF0FIARd8gYBGzqZ2IXjDZZWg7/Q8KnTyQ7DLUW4GGPO7VEmdC241Sw=
X-Received: by 2002:a05:6102:215a:b0:39a:c2c6:cc5d with SMTP id
 h26-20020a056102215a00b0039ac2c6cc5dmr5850352vsg.61.1663649077616; Mon, 19
 Sep 2022 21:44:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220920043202.503191-1-lsahlber@redhat.com>
In-Reply-To: <20220920043202.503191-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 19 Sep 2022 23:44:26 -0500
Message-ID: <CAH2r5mtY6fLkmZLMBGJwGzoSn=r36N++bZc=WyYJdkhag3HBZw@mail.gmail.com>
Subject: Re: [PATCH] cifs: destage dirty pages before re-reading them for cache=none
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>, stable@vger.kernel.org,
        Paulo Alcantara <pc@cjr.nz>,
        Enzo Matsumiya <ematsumiya@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

tentatively merged into cifs-2.6.git for-next pending testing

Will be curious if this impacts performance of any of the buildbot
tests and also curious if it addresses any of the buildbot tests which
fail and are currently skipped

On Mon, Sep 19, 2022 at 11:32 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> This is the opposite case of kernel bugzilla 216301.
> If we mmap a file using cache=none and then proceed to update the mmapped
> area these updates are not reflected in a later pread() of that part of the
> file.
> To fix this we must first destage any dirty pages in the range before
> we allow the pread() to proceed.
>
> Cc: stable@vger.kernel.org
> Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/file.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 6f38b134a346..7d756721e1a6 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -4271,6 +4271,15 @@ static ssize_t __cifs_readv(
>                 len = ctx->len;
>         }
>
> +       if (direct) {
> +               rc = filemap_write_and_wait_range(file->f_inode->i_mapping,
> +                                                 offset, offset + len - 1);
> +               if (rc) {
> +                       kref_put(&ctx->refcount, cifs_aio_ctx_release);
> +                       return -EAGAIN;
> +               }
> +       }
> +
>         /* grab a lock here due to read response handlers can access ctx */
>         mutex_lock(&ctx->aio_mutex);
>
> --
> 2.35.3
>


-- 
Thanks,

Steve
