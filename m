Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3090F6945FF
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 13:37:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbjBMMhz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 07:37:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbjBMMhx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 07:37:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF0231ABF1
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 04:37:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D670B811A9
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 12:37:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D76AEC433D2;
        Mon, 13 Feb 2023 12:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676291838;
        bh=Tdej6gvFNVysWw9GQj/Qq0GUgNahcVR7Gs0kfr0uKwQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=hFTFVqdZbxzsi3Y9KIz1YyeBJvLZqvjn6w2+g8F8YcUnFsAsxyBJ/sdlk4XOfIaov
         6HA8y0XN+iMdLfQDbXDyEYk62GdOOmT8S6AX0oWIOrDYx9nrRRVxshKA8QUXGLrO6D
         EiBwybRKgVyZ+oKDam/ZBfOdc0wjFNl2LZBLlQ1ImUpmOx/Rrd514Ouv+od9Tm2lQV
         /DCTFYqPS1GRnXSubjEz/sXPdHaXs1WdO6EUTCBym8WrzMZrOL9B6OGiFeKd8GNc+J
         YdPs6P84zLdW1c+xgSxwc/4NS/Y9iqf60rmYBdLa3T2OptDFzSzZhCeMb5I865GRJB
         YXQH/mYplIEiw==
Message-ID: <732e55f69d06c4e0de3c5c7eee10f254253391f6.camel@kernel.org>
Subject: Re: [PATCH] ceph: update the time stamps and try to drop the
 suid/sgid
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com
Cc:     vshankar@redhat.com, mchangir@redhat.com, stable@vger.kernel.org
Date:   Mon, 13 Feb 2023 07:37:16 -0500
In-Reply-To: <20230213111038.15021-1-xiubli@redhat.com>
References: <20230213111038.15021-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2023-02-13 at 19:10 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
>=20
> The fallocate will try to clear the suid/sgid if a unprevileged user
> changed the file.
>=20
> There is no Posix item requires that we should clear the suid/sgid
> in fallocate code path but this is the default behaviour for most of
> the filesystems and the VFS layer. And also the same for the write
> code path, which have already support it.
>=20

Huh, you're right. It really doesn't say anything about the timestamps
or setuid bits:

    https://pubs.opengroup.org/onlinepubs/9699919799/functions/posix_falloc=
ate.html


That's arguably a bug in the spec. It really does need to do those
things.

> And also we need to update the time stamps since the fallocate will
> change the file contents.
>=20
> Cc: stable@vger.kernel.org
> URL: https://tracker.ceph.com/issues/58054
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/file.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>=20
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 903de296f0d3..dee3b445f415 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -2502,6 +2502,9 @@ static long ceph_fallocate(struct file *file, int m=
ode,
>  	loff_t endoff =3D 0;
>  	loff_t size;
> =20
> +	dout("%s %p %llx.%llx mode %x, offset %llu length %llu\n", __func__,
> +	     inode, ceph_vinop(inode), mode, offset, length);
> +
>  	if (mode !=3D (FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
>  		return -EOPNOTSUPP;
> =20
> @@ -2539,6 +2542,10 @@ static long ceph_fallocate(struct file *file, int =
mode,
>  	if (ret < 0)
>  		goto unlock;
> =20
> +	ret =3D file_modified(file);
> +	if (ret)
> +		goto put_caps;
> +
>  	filemap_invalidate_lock(inode->i_mapping);
>  	ceph_fscache_invalidate(inode, false);
>  	ceph_zero_pagecache_range(inode, offset, length);
> @@ -2554,6 +2561,7 @@ static long ceph_fallocate(struct file *file, int m=
ode,
>  	}
>  	filemap_invalidate_unlock(inode->i_mapping);
> =20
> +put_caps:
>  	ceph_put_cap_refs(ci, got);
>  unlock:
>  	inode_unlock(inode);

Reviewed-by: Jeff Layton <jlayton@kernel.org>
