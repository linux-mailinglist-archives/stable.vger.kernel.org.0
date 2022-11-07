Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C67D61F778
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 16:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232091AbiKGPVa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 10:21:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231990AbiKGPV3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 10:21:29 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80410289;
        Mon,  7 Nov 2022 07:21:28 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id z18so18087212edb.9;
        Mon, 07 Nov 2022 07:21:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tGC52wQ3g/9VRF1d+6K6tt2aG94zpt4OAawBYFo8Iis=;
        b=kH8SBO+tp4AMT0a02LfVAJ/roIifj+4DFD9DkKUAJHl/yrYagfDQiYL6odMWJVCKdS
         f07BfDfar0sWZuSOFwmIzXAnHoB24dlrsOCAk0LFr1+yE2HcWm3W8BFYhQFQXd3snNhZ
         70BuLlNJYUDzBEnrHdCFx9f9GbPV9N62q3VaO2VCbKmGHR7a6Hv+H56/5v9z2y++B6aB
         eBFRZ8ES8TVlF152zLvFOvAmpzENknfcBCk73LgqILEjluRZklZe20fXEMTNsvQDokG6
         MdtH4kavIi2/N5Y6ewUjO4lV2F2wGy5FxajFriVbhg4Jnq6glwgRfx1D8co2IKzvkGkn
         emlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tGC52wQ3g/9VRF1d+6K6tt2aG94zpt4OAawBYFo8Iis=;
        b=DWITQ6T7vTf65JtD45LdEQ4XS50X9/ixBCDSRINdu250Sx6g32MxUouLKvZaXpWNH8
         gzHeOhZxsvREQVvLKjRJzRQDntO/pY5wWbL3lZ1oCQppiig5GjEovByshG3v/Ik327Cf
         wIXEPIRyheAeAJhD1vvxA4lN8sxq9qFwSZMFnI4/TrCnL+tY1GRrKgp1BahbONfInEX7
         +UvF9VAX29BZROCXpxAPLgjiTDpXBdUVEUpt0r3OriaGgr2Zw0iKhIVz8Bikcvk+uHmP
         TRrQ5mRXYyK4H+Ke6r58CWvfaZO83ZvHVvObjqowzDhhpgSD71HTJAslSfnykLI2CTVQ
         FQaA==
X-Gm-Message-State: ANoB5pk3mcUqJyoBw5UzLhzWF6E4gX35v9MDaHJPvdTdSasM8b6NFgN8
        5A6ZLAqTpmo4K1LS1/cT8SXB70m4frxfOIiYYM4=
X-Google-Smtp-Source: AA0mqf6jNBn6B9i7WSxD0/bT61dL4nPvbUizVjV0H5ZQ9T9I+sQLLMacwo6O5LLhmz1DT2Cl/1IdB82FGElXClRYy7k=
X-Received: by 2002:a50:8742:0:b0:466:45c8:1e35 with SMTP id
 2-20020a508742000000b0046645c81e35mr8815127edv.395.1667834487136; Mon, 07 Nov
 2022 07:21:27 -0800 (PST)
MIME-Version: 1.0
References: <20221107071759.32000-1-xiubli@redhat.com>
In-Reply-To: <20221107071759.32000-1-xiubli@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 7 Nov 2022 16:21:15 +0100
Message-ID: <CAOi1vP-orfs-CK+KjWyMXiRRQqZxcw=r_yvLRDAVMEvrrOw8vg@mail.gmail.com>
Subject: Re: [PATCH] ceph: avoid putting the realm twice when docoding snaps fails
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

On Mon, Nov 7, 2022 at 8:18 AM <xiubli@redhat.com> wrote:
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
>  fs/ceph/snap.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> index 9bceed2ebda3..baf17df05107 100644
> --- a/fs/ceph/snap.c
> +++ b/fs/ceph/snap.c
> @@ -849,10 +849,12 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
>         if (realm_to_rebuild && p >= e)
>                 rebuild_snap_realms(realm_to_rebuild, &dirty_realms);
>
> -       if (!first_realm)
> +       if (!first_realm) {
>                 first_realm = realm;
> -       else
> +               realm = NULL;

Hi Xiubo,

I wonder why realm is cleared only in !first_realm branch?  Can't
the same issue occur with realm?

    first_realm is already set, ceph_put_snap_realm(realm)
    p < e, goto more
    decoding fails, goto bad
    realm is still set and not IS_ERR, ceph_put_snap_realm(realm)
    <realm is put twice>

Thanks,

                Ilya
