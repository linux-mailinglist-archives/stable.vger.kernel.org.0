Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50C2E6227E6
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 11:03:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbiKIKDc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 05:03:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbiKIKDb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 05:03:31 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9159B60E3;
        Wed,  9 Nov 2022 02:03:28 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id b2so45293030eja.6;
        Wed, 09 Nov 2022 02:03:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=78QpZkkQC/Ciw0hVF3bQvZkciLm8soEhrJuFK2fYcSg=;
        b=iKjFOg5jEKQ8f4re6wP6UPtTCsVhM91rbJ0iNPNF1w94eZX+vGI2YZIGqMeoUsSLYN
         QZolStddNAVNhV0hIJXbOAqSukuP3Ahcmvo3url/VVytvnP8wPIumZSKrX59GPpRWBPd
         Y0acQt28AAtGTSeSZ8arlUc9IR6SL+2DeWvzp9HmiASfdwyX3CXglx40ZiepnLE9W5qT
         9T+RQ+0dQZJvvSyBWHp+Uzqy7CFkWGACI6xWwvl4RE9Nq7M6eSvsnGMw6S6WZ3mGa9xH
         hBsQq0kThk8eqGCp0DDn3NWA/dlkAEBwFhPivwNKeMZTlG5ZyVtgcRWNaKE1qCFmkq1G
         XYDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=78QpZkkQC/Ciw0hVF3bQvZkciLm8soEhrJuFK2fYcSg=;
        b=F8kUpOjmPk9+vyu5M4yFz+UFi+fxow15+5OBnCGK4lwGSVkcUPN0SDpliMBgXCJOLj
         0aYPLky4BEVc1ucgkiDz5zrPb+EIyHfbRFzdnKeECiKYztCFshkjKMMLpc37Mvt0N/lW
         UZcvkt1k9ESCWMbdoYzsKaUiXTm1rnsX6nmVunFV/7VghLqz5hvrDXp5+ceod6n91Gcf
         3ENeW9jCmfkz+WUgtj7nA0XT3H0I2GHUuQtJoKiNG1SVrXbqy8Tat/v+n5m5ok577Lfy
         HUZoo6YjPm3gLuLh36ZzHuFRVIZ3c5c57c4mmhc/aeRtdY6TYlRHqDrZmONEaH3BXqDP
         25Ww==
X-Gm-Message-State: ACrzQf1ueLOK3dJoJ2w+4Pe/oo+4HgViYkV2Eg0aeZHzZ5gVNbzbNPYh
        Fo7yr0tK3mS6GcPiF6NxIy1QiNgvW+HnAKDZjcY=
X-Google-Smtp-Source: AMsMyM4cVBaGczyRTni/w/pixcnTTGmrL48HAiElVnphFwMPE4uVixweYRRfgx9l9YPo91sBUC0yGPPMEumEYvy5uw8=
X-Received: by 2002:a17:906:4fc3:b0:72e:eab4:d9d7 with SMTP id
 i3-20020a1709064fc300b0072eeab4d9d7mr55026561ejw.599.1667988207031; Wed, 09
 Nov 2022 02:03:27 -0800 (PST)
MIME-Version: 1.0
References: <20221109030039.592830-1-xiubli@redhat.com>
In-Reply-To: <20221109030039.592830-1-xiubli@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 9 Nov 2022 11:03:15 +0100
Message-ID: <CAOi1vP-jbuyQ4AROR3cj9ybeT8mZT6w9J+yuVOi8ASdOZo8=xA@mail.gmail.com>
Subject: Re: [PATCH v4] ceph: avoid putting the realm twice when decoding
 snaps fails
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

On Wed, Nov 9, 2022 at 4:00 AM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> When decoding the snaps fails it maybe leaving the 'first_realm'
> and 'realm' pointing to the same snaprealm memory. And then it'll
> put it twice and could cause random use-after-free, BUG_ON, etc
> issues.
>
> Cc: stable@vger.kernel.org
> URL: https://tracker.ceph.com/issues/57686
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>
> Changed in V4:
> - remove initilizing of 'realm'.
>
>  fs/ceph/snap.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> index 9bceed2ebda3..c1c452afa84d 100644
> --- a/fs/ceph/snap.c
> +++ b/fs/ceph/snap.c
> @@ -764,7 +764,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
>         struct ceph_mds_snap_realm *ri;    /* encoded */
>         __le64 *snaps;                     /* encoded */
>         __le64 *prior_parent_snaps;        /* encoded */
> -       struct ceph_snap_realm *realm = NULL;
> +       struct ceph_snap_realm *realm;
>         struct ceph_snap_realm *first_realm = NULL;
>         struct ceph_snap_realm *realm_to_rebuild = NULL;
>         int rebuild_snapcs;
> @@ -775,6 +775,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
>
>         dout("%s deletion=%d\n", __func__, deletion);
>  more:
> +       realm = NULL;
>         rebuild_snapcs = 0;
>         ceph_decode_need(&p, e, sizeof(*ri), bad);
>         ri = p;
> --
> 2.31.1
>

Reviewed-by: Ilya Dryomov <idryomov@gmail.com>

Thanks,

                Ilya
