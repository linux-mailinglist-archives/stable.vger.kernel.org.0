Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE5DB09D5
	for <lists+stable@lfdr.de>; Thu, 12 Sep 2019 10:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728267AbfILICe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Sep 2019 04:02:34 -0400
Received: from mail-vs1-f66.google.com ([209.85.217.66]:40843 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726952AbfILICe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Sep 2019 04:02:34 -0400
Received: by mail-vs1-f66.google.com with SMTP id v10so12348537vsc.7;
        Thu, 12 Sep 2019 01:02:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=1lVBv82Gu5rmTemp9Ig/cpf4GsO//XxO5mHh0N3v/qI=;
        b=XgGxAR4R7kOPC/ut8+KftBSdNKs9fmo8ThIytNU5YcMw7100Vn3EBECwqF2zPPgf7o
         r5lUP2GZIxH5Cyn4wj6kdlEWIKDQ5MsylLInPL9xt+on85bqTGGnkA1lF9rn5gRct3xL
         qL2gEFQ60JzYuJIfm9bbPgzPn49wypihn1iXSdR9uv0pgat+3ZiVhk4W65X1dlGTB9l7
         Q0hHSMbPxmo+68ZMt9V4CJn1NM+iC0378QvpbrHnh0M1P7d46eiMhrV6+SDP7NIuXi2m
         pMsCMuIe+svgLop4cXBf3UprQqKJibDKREDk0OLygmFHFrYdbeoLgEx2hvXhTOMmBamf
         igBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=1lVBv82Gu5rmTemp9Ig/cpf4GsO//XxO5mHh0N3v/qI=;
        b=mV7x6G/ZNybTrN3A5PMRrob1dcklcYY3+NOqw8ns+xJzPvt8qupTAb6WxRTb99GfX+
         Kf/q9ly1yCt/L44pnGoS8CcTGeGqi+THtKEoWPGJEWMC+sYjAmo/lwquTKPvnUA+HoMh
         Z/A491tsv3z0usRU1S3Ifo5K3LAeixpNVOh/0Bjm8D9QBNjiKlm8uwIGxl4gfOTjuedC
         dobz63rPM/sXtqNYF0rEfTgxSEwPTfYj01/3i6/n+zRSC4Bka4lUZjF/bhzf0mX6Bri/
         LOizRxlH3Mn9XMPg93B+wcYVnWadh9afYxuUULcFk0oDYdbfpfQJt3qAhnnZ75wLF42Q
         h7+g==
X-Gm-Message-State: APjAAAVwct8jaWfKmEGbKujUhaSnKmSwN5nkmxeE+DZHk32dnWd5XEzD
        odJKMTV0JNF/beIWV4wDk+6JUu1QKuGWHDpU5kA=
X-Google-Smtp-Source: APXvYqwbqwXd5gyK6jObNOaHSdvhVybQ19jrZSyKEP0jv4lf5tEXn718c/EOsOT/v4cysPBKvtFaaVVgz//KMdVKBls=
X-Received: by 2002:a67:5c4:: with SMTP id 187mr22117899vsf.14.1568275351648;
 Thu, 12 Sep 2019 01:02:31 -0700 (PDT)
MIME-Version: 1.0
References: <20190910142649.19808-1-fdmanana@kernel.org> <20190912073046.47C2020830@mail.kernel.org>
In-Reply-To: <20190912073046.47C2020830@mail.kernel.org>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Thu, 12 Sep 2019 09:02:20 +0100
Message-ID: <CAL3q7H56hhre36hgMW6kLFqpbgxXN4hpDwww67ZqQuqOwqQ54A@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix assertion failure during fsync and use of
 stale transaction
To:     Sasha Levin <sashal@kernel.org>
Cc:     Filipe Manana <fdmanana@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 12, 2019 at 8:32 AM Sasha Levin <sashal@kernel.org> wrote:
>
> Hi,
>
> [This is an automated email]
>
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: 4.4+
>
> The bot has tested the following trees: v5.2.14, v4.19.72, v4.14.143, v4.=
9.192, v4.4.192.
>
> v5.2.14: Build OK!
> v4.19.72: Failed to apply! Possible dependencies:
>     6b5fc433a7ad ("Btrfs: fix fsync after succession of renames of differ=
ent files")
>     a3baaf0d786e ("Btrfs: fix fsync after succession of renames and unlin=
k/rmdir")
>     b8aa330d2acb ("Btrfs: improve performance on fsync of files with mult=
iple hardlinks")
>
> v4.14.143: Failed to apply! Possible dependencies:
>     0d836392cadd ("Btrfs: fix mount failure after fsync due to hard link =
recreation")
>     1f250e929a9c ("Btrfs: fix log replay failure after unlink and link co=
mbination")
>     6b5fc433a7ad ("Btrfs: fix fsync after succession of renames of differ=
ent files")
>     8d9e220ca084 ("btrfs: simplify IS_ERR/PTR_ERR checks")
>     a3baaf0d786e ("Btrfs: fix fsync after succession of renames and unlin=
k/rmdir")
>     b8aa330d2acb ("Btrfs: improve performance on fsync of files with mult=
iple hardlinks")
>
> v4.9.192: Failed to apply! Possible dependencies:
>     0b246afa62b0 ("btrfs: root->fs_info cleanup, add fs_info convenience =
variables")
>     0d836392cadd ("Btrfs: fix mount failure after fsync due to hard link =
recreation")
>     1f250e929a9c ("Btrfs: fix log replay failure after unlink and link co=
mbination")
>     4791c8f19c45 ("btrfs: Make btrfs_check_ref_name_override take btrfs_i=
node")
>     6b5fc433a7ad ("Btrfs: fix fsync after succession of renames of differ=
ent files")
>     a3baaf0d786e ("Btrfs: fix fsync after succession of renames and unlin=
k/rmdir")
>     cf8cddd38bab ("btrfs: don't abuse REQ_OP_* flags for btrfs_map_block"=
)
>     da17066c4047 ("btrfs: pull node/sector/stripe sizes out of root and i=
nto fs_info")
>     db0a669fb002 ("btrfs: Make btrfs_add_link take btrfs_inode")
>     de143792253e ("btrfs: struct btrfsic_state->root should be an fs_info=
")
>     fb456252d3d9 ("btrfs: root->fs_info cleanup, use fs_info->dev_root ev=
erywhere")
>
> v4.4.192: Failed to apply! Possible dependencies:
>     0132761017e0 ("btrfs: fix string and comment grammatical issues and t=
ypos")
>     09cbfeaf1a5a ("mm, fs: get rid of PAGE_CACHE_* and page_cache_{get,re=
lease} macros")
>     0b246afa62b0 ("btrfs: root->fs_info cleanup, add fs_info convenience =
variables")
>     0d836392cadd ("Btrfs: fix mount failure after fsync due to hard link =
recreation")
>     0e749e54244e ("dax: increase granularity of dax_clear_blocks() operat=
ions")
>     1f250e929a9c ("Btrfs: fix log replay failure after unlink and link co=
mbination")
>     44f714dae50a ("Btrfs: improve performance on fsync against new inode =
after rename/unlink")
>     4791c8f19c45 ("btrfs: Make btrfs_check_ref_name_override take btrfs_i=
node")
>     52db400fcd50 ("pmem, dax: clean up clear_pmem()")
>     6b5fc433a7ad ("Btrfs: fix fsync after succession of renames of differ=
ent files")
>     781feef7e6be ("Btrfs: fix lockdep warning about log_mutex")
>     a3baaf0d786e ("Btrfs: fix fsync after succession of renames and unlin=
k/rmdir")
>     b2e0d1625e19 ("dax: fix lifetime of in-kernel dax mappings with dax_m=
ap_atomic()")
>     bb7ab3b92e46 ("btrfs: Fix misspellings in comments.")
>     cf8cddd38bab ("btrfs: don't abuse REQ_OP_* flags for btrfs_map_block"=
)
>     d1a5f2b4d8a1 ("block: use DAX for partition table reads")
>     db0a669fb002 ("btrfs: Make btrfs_add_link take btrfs_inode")
>     de143792253e ("btrfs: struct btrfsic_state->root should be an fs_info=
")
>
>
> NOTE: The patch will not be queued to stable trees until it is upstream.
>
> How should we proceed with this patch?

After it lands on Linus' tree, I'll try to send patch versions that
apply to different kernel releases.

Thanks.

>
> --
> Thanks,
> Sasha



--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
