Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2728661F6EF
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 15:57:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232813AbiKGO5Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 09:57:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232671AbiKGO44 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 09:56:56 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6376B1EED8;
        Mon,  7 Nov 2022 06:56:04 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id ud5so30848356ejc.4;
        Mon, 07 Nov 2022 06:56:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EhjDNl9PQP3JDkmEigcwG4twUd4lJpOdBik93ArHUi4=;
        b=AYGR+9FWkK57te0lMH1LWwYRXeTyCGVPEofDlRcNY9AubMt/CgpY/rhpPaTvHCnzvW
         zIF+Tme1ZlfNYuoYIT/se/S6hYv+e2q6X/VLHulAjdXwQX+4gcYiKlsNfBlGEltyN0VQ
         fF+zv0/K+LxcQcoIsw4Y0eNBJV4QtDBec/9gWRWR+qeqWdaRwPmGUmcP9pPRh14SEoNV
         ChmHuHH34pDE5mXQhYhDUuYaCz9uvSnnlKIuYD0HgeDF9zk7w4+qrtUB6MRO9KKysc5z
         TnOQwZ7uorgnF0afKuH8Dpdq+DdiXA4jCwby+EK9LNvWOktkqoHTHT7d4A+WVt8MrS2F
         Z5yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EhjDNl9PQP3JDkmEigcwG4twUd4lJpOdBik93ArHUi4=;
        b=bob0WqoTRUBB74lxWTM2KohIMlpc0wQNBuk83OFsPQljSV7pDg4on261CLsvev4ajM
         MFqxgjgtSz/udi7TDIMfoYFjrpXpeukiB1p6tsm7+rTw5y/5VchXzM3ytPvXpxgMGCGZ
         Q0525FS95/dbWobuDnZUJWO7YIkuIJTPJYyf6BYdSsc0E+dH+0kZCsulrud45ruDVClA
         vVHEuIA9tkAOuyE0KCNWpKcu5XspbiVeLe6ntMX+iuhwXSI1wD3HMtZSEUx+iBywL1JV
         Yc8JH6Bty1UoezUaiUEJdmPqpn4je5gNPOv/hqkyHpYidAy/bCoBMCSb7iO/ZbUnrNQx
         EvGg==
X-Gm-Message-State: ACrzQf2mO9DmcWhk3gM0uLjDXqoTFGSbhtFcjsq4HxSx1RaIU8oxDESY
        SSyLiDIQEaPXvdFYGPAiI9qvCYNAq7ZWC3sWDIQ=
X-Google-Smtp-Source: AMsMyM7qECndZEVwxey4hLqE6oPegvipDJ4Lh0VBF58GCWP2xYlr1pHRTRVG3uBaiZyy/5AUbkVslA88eoY8ksFdOic=
X-Received: by 2002:a17:906:4fc3:b0:72e:eab4:d9d7 with SMTP id
 i3-20020a1709064fc300b0072eeab4d9d7mr47120099ejw.599.1667832963858; Mon, 07
 Nov 2022 06:56:03 -0800 (PST)
MIME-Version: 1.0
References: <20221027091155.334178-1-xiubli@redhat.com>
In-Reply-To: <20221027091155.334178-1-xiubli@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 7 Nov 2022 15:55:51 +0100
Message-ID: <CAOi1vP9g1PkeOoxNwGBZ3QX=Hx+YxpCXDw28roiTmq8P2uHQtw@mail.gmail.com>
Subject: Re: [PATCH] ceph: fix NULL pointer dereference for req->r_session
To:     xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org, lhenriques@suse.de, jlayton@kernel.org,
        mchangir@redhat.com, stable@vger.kernel.org
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

On Thu, Oct 27, 2022 at 11:12 AM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> The request's r_session maybe changed when it was forwarded or
> resent.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/caps.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 894adfb4a092..d34ac716d7fe 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -2341,6 +2341,7 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
>                         goto out;
>                 }
>
> +               mutex_lock(&mdsc->mutex);

Hi Xiubo,

A few lines above, there is the following comment:

        /*
         * The mdsc->max_sessions is unlikely to be changed
         * mostly, here we will retry it by reallocating the
         * sessions array memory to get rid of the mdsc->mutex
         * lock.
         */

Does retry label and gotos still make sense if mdsc->mutex is
introduced?  Would it make sense to move it up and get rid of
retry code?

Thanks,

                Ilya
