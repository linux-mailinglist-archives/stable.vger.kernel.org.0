Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 881306217B4
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 16:11:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233980AbiKHPLM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 10:11:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231576AbiKHPLL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 10:11:11 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A5E1193DD;
        Tue,  8 Nov 2022 07:11:08 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id v17so22948863edc.8;
        Tue, 08 Nov 2022 07:11:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=b/7jqpcqRF+tk0KLQA9+lO9Hgn5SkzzUvopv4WdvCZs=;
        b=kJXwZ4JWYMnupS1gDN4Y2xZ1nGhWS0cONIqXWB/7BrS+1y56GmxI5hzpxkH0ehC+Gr
         FEL3uzE23VDhn0+onsCZ7x48F+9HZP5L9dAEaDJKFC/zKEELeA2GyUyuaCkAfLXkojR0
         qjsPNwahkN35DolYNTwIbNqAoqDnPyaw4rvh8PxGb3mLwYsq/S34t0oI536Qn3zjpgeD
         xt/oZYARRjy6t1sUFHV3V6N/EqZ+V8B50/JTP0UiFsvpgiHAYXanQ6W7MOrqxBq4t+5K
         0kdowApw5cHrvLhTWdTKeGqkSvu4EMSAl16Rd2GE8aqjEKYeY+rnjFkoQ4WWS3MNGPkQ
         XD+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b/7jqpcqRF+tk0KLQA9+lO9Hgn5SkzzUvopv4WdvCZs=;
        b=am4XbKjoYM9dbJ2aFy2xLyszDFAE1/9XGsTy1HO7gQE08ZbE4SaU/Z8Jwls33FbF0z
         HJuMtPRXOX9zKew8wfVtRNLsVZEcNcUn485bWBfkeJwmHd6TfTs2/wRl4FqFPADPM1oQ
         a4hfbK+0BF0KFbNmTiqCelKWvDHwdNLNfI/YlZ5CIHtWsdKI6rfGVy7LTKAt+3zu5xVa
         VLQ2/ZWn25fEzMZpFZhw1OXUbr01e3FaFug0ja5K74+DXCs7BxcxJ77rtNTKTPNtL31a
         u3jchx229BNDohMuTigWokgYN2Awbzq1A7tinK3R7zb2pkYIJypka84Z9ZwHawH4e7mk
         0nKw==
X-Gm-Message-State: ANoB5pkm8gNgMl62EUIq/SShtQA1HfKpqtRSz3ps08u0vDVH0cMOR1Dd
        wBWBtHpoFQoeEpaU5LrFSsmMaeHG69X8r1c5/k8=
X-Google-Smtp-Source: AA0mqf5wP49/3bJGHS6JgsO+CBuY5F4b+OUnGZxcYIUgGwh4Gi0GIRp8G2ZpkJ8va5gP2m4HKslm0P8AZT2bFokS0vM=
X-Received: by 2002:a05:6402:1ac7:b0:466:b14b:497c with SMTP id
 ba7-20020a0564021ac700b00466b14b497cmr2944788edb.210.1667920266839; Tue, 08
 Nov 2022 07:11:06 -0800 (PST)
MIME-Version: 1.0
References: <20221108134633.557928-1-xiubli@redhat.com>
In-Reply-To: <20221108134633.557928-1-xiubli@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 8 Nov 2022 16:10:54 +0100
Message-ID: <CAOi1vP-XiSj35RDbc3zkoNvHfwRujAA8_BEFW3C=5fo+rPWfiQ@mail.gmail.com>
Subject: Re: [PATCH v3] ceph: avoid putting the realm twice when decoding
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

On Tue, Nov 8, 2022 at 2:46 PM <xiubli@redhat.com> wrote:
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
>  fs/ceph/snap.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> index 9bceed2ebda3..f5b0fa1ff705 100644
> --- a/fs/ceph/snap.c
> +++ b/fs/ceph/snap.c
> @@ -775,6 +775,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
>
>         dout("%s deletion=%d\n", __func__, deletion);
>  more:
> +       realm = NULL;

Nit: realm doesn't need to be initialized anymore, I would drop that.

Thanks,

                Ilya
