Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6D96A6BEA
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 12:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbjCALyg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 06:54:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjCALyg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 06:54:36 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9E1F2A15A;
        Wed,  1 Mar 2023 03:54:34 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id o15so50186872edr.13;
        Wed, 01 Mar 2023 03:54:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677671673;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r9eBe8+7YQ/M59DcxO/TsvFOMgr/dp8saDDEAiBUiNg=;
        b=evG5WpgYwbyzE139g1XTYu1BdI29WDCu5qpt2vbeBH/cmGwF9r3yslLIsVQGKO+ocA
         kTo+NXvQNwmnFyD1zOvdIncqaB0UWmQ+ggOqjxYeB2dzkLdsBuxS1d2d1/g5rH4mm9nW
         f7gHqV24RXteYFBYuTEtzh0TdgVVN6DGBsh1Ga4f0gKU1xfi32NbBS+TehcX858olelD
         MPuV11zVMlZtG7bj83IQCtNvuNOsk8NZglYEfdJW3xJeY9swplKY8BzO1Ss+ERvztzyR
         5fHM26/rkcB8bdVOVQUZ5YarY2oveWLI8l2DvGb3MoOATgDHHCcXWF9wi2x/7XpzyhNv
         H1ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677671673;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r9eBe8+7YQ/M59DcxO/TsvFOMgr/dp8saDDEAiBUiNg=;
        b=zpfVgiVUJYPS6hWegx6vW6VqraT+DpBtIlPfpPpVBGzkLZPkULzxIvkSFxn0ZyKR55
         UN5RF7NFKHdw+ei0/H0uHwS7j4EHX5QEIdauoi/IMK2ZGYAxu1cho1jvr54lJRoY339A
         fHPva1hxO+mZ3htmXFvsCDhUGVATh3KgapwAFWir0BvsXX47L53KVrxQpjfTBaNXssvM
         1oX9w0cK78pR1VD2mFM239DL/ovt5cUhFoDutMwpU8y6HWV0GxwHpPPT7TgzpKAL/bCw
         LFg6L85tafsG4q5iFgVGcrHIt6AuQtyetk7JqiwNQHla1mSYrgUlpiHRzW+g8b7WVxv2
         kj1w==
X-Gm-Message-State: AO0yUKVLP5lQxZ45IRAfJG/zAiYPLmrG/7nHMvyzg9ZYEhZXGOlkOYb9
        9SF5TwVRgRKQtcm3uGkbtu/QWCO9nORHVGrmVyw=
X-Google-Smtp-Source: AK7set+zTjr941YrtuGjFKeE2KE1CqziQ0n2HhGGhs0dQ/WMezUBXXe8OBNCwfrYWDKR4GamdkNljZ40n8dSFFd/k9U=
X-Received: by 2002:a50:d494:0:b0:4ac:b442:5a4b with SMTP id
 s20-20020a50d494000000b004acb4425a4bmr3534195edi.0.1677671673211; Wed, 01 Mar
 2023 03:54:33 -0800 (PST)
MIME-Version: 1.0
References: <20230301011918.64629-1-xiubli@redhat.com>
In-Reply-To: <20230301011918.64629-1-xiubli@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 1 Mar 2023 12:54:20 +0100
Message-ID: <CAOi1vP8i6EY-m-bGDNp5QhmHDepvgCAQ1FTnySVg7Bb=6h5uqw@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: do not print the whole xattr value if it's too long
To:     xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org, lhenriques@suse.de,
        vshankar@redhat.com, mchangir@redhat.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 1, 2023 at 2:19=E2=80=AFAM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> If the xattr's value size is long enough the kernel will warn and
> then will fail the xfstests test case.
>
> Just print part of the value string if it's too long.
>
> Cc: stable@vger.kernel.org
> URL: https://tracker.ceph.com/issues/58404

Hi Xiubo,

Does this really need to go to stable kernels?  None of the douts are
printed by default.

> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>
> V2:
> - switch to use min() from Jeff's comment
> - s/XATTR_MAX_VAL/MAX_XATTR_VAL/g
>
>
>  fs/ceph/xattr.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> index b10d459c2326..887a65279fcf 100644
> --- a/fs/ceph/xattr.c
> +++ b/fs/ceph/xattr.c
> @@ -561,6 +561,7 @@ static struct ceph_vxattr *ceph_match_vxattr(struct i=
node *inode,
>         return NULL;
>  }
>
> +#define MAX_XATTR_VAL 256

Perhaps MAX_XATTR_VAL_PRINT_LEN?  Also, I'd add a blank like after the
define -- it's used by more than one function.

Thanks,

                Ilya
