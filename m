Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 565E76A59FC
	for <lists+stable@lfdr.de>; Tue, 28 Feb 2023 14:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbjB1N3k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Feb 2023 08:29:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjB1N3j (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Feb 2023 08:29:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D601912BC6;
        Tue, 28 Feb 2023 05:29:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97C58B80E25;
        Tue, 28 Feb 2023 13:29:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 812F8C433EF;
        Tue, 28 Feb 2023 13:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677590976;
        bh=fgtn8Wpjeekxicek6q6O9rTut9/0L53TKr8hnYa1CNc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=eLiIAbti5aWDpHQBIAaSZHppE0Yuul1cyInc1sa5Y9X3SWHagD541CyV93qft+aLp
         8klsF62x3HQ8yoI297rioeTCKwUWnZEps1dxtZTpnoxUSBDQB0zkPtvEwhjZ0cRStb
         BPpa84eI4z/BGcCJjwPAgU21wfe2DcW21WU2G9w/WGbvjUB7DSUMX9SCl0M7+2GlIw
         nVJI3GWRaAj0pUYD22sYX/wZNK0YIXawiWoanPnof2EIF3tCAOrUIC5hdI/gdEsTw7
         qKDX1nF/uvfonW1bkaC6ds+67pAoVITKXvyDoUd3A9qPcWbnAcm+NbLug+zxWMI7qS
         m09WVCJLQ61gA==
Message-ID: <12ed3a557618c331c6a5949f7335d563cdc1531c.camel@kernel.org>
Subject: Re: [PATCH] ceph: do not print the whole xattr value if it's too
 long
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     lhenriques@suse.de, vshankar@redhat.com, mchangir@redhat.com,
        stable@vger.kernel.org
Date:   Tue, 28 Feb 2023 08:29:34 -0500
In-Reply-To: <20230228125531.165361-1-xiubli@redhat.com>
References: <20230228125531.165361-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2023-02-28 at 20:55 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
>=20
> If the xattr's value size is long enough the kernel will warn and
> then will fail the xfstests test case.
>=20
> Just print part of the value string if it's too long.
>=20
> Cc: stable@vger.kernel.org
> URL: https://tracker.ceph.com/issues/58404
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/xattr.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
>=20
> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> index b10d459c2326..6638bb0ec10f 100644
> --- a/fs/ceph/xattr.c
> +++ b/fs/ceph/xattr.c
> @@ -561,6 +561,7 @@ static struct ceph_vxattr *ceph_match_vxattr(struct i=
node *inode,
>  	return NULL;
>  }
> =20
> +#define XATTR_MAX_VAL 256
>  static int __set_xattr(struct ceph_inode_info *ci,
>  			   const char *name, int name_len,
>  			   const char *val, int val_len,
> @@ -654,8 +655,10 @@ static int __set_xattr(struct ceph_inode_info *ci,
>  		dout("__set_xattr_val p=3D%p\n", p);
>  	}
> =20
> -	dout("__set_xattr_val added %llx.%llx xattr %p %.*s=3D%.*s\n",
> -	     ceph_vinop(&ci->netfs.inode), xattr, name_len, name, val_len, val)=
;
> +	dout("__set_xattr_val added %llx.%llx xattr %p %.*s=3D%.*s%s\n",
> +	     ceph_vinop(&ci->netfs.inode), xattr, name_len, name,
> +	     val_len > XATTR_MAX_VAL ? XATTR_MAX_VAL : val_len, val,

		min(val_len, XATTR_MAX_VAL), val,...

> +	     val_len > XATTR_MAX_VAL ? "..." : "");
> =20
>  	return 0;
>  }
> @@ -681,8 +684,10 @@ static struct ceph_inode_xattr *__get_xattr(struct c=
eph_inode_info *ci,
>  		else if (c > 0)
>  			p =3D &(*p)->rb_right;
>  		else {
> -			dout("__get_xattr %s: found %.*s\n", name,
> -			     xattr->val_len, xattr->val);
> +			int len =3D xattr->val_len;
> +			dout("__get_xattr %s: found %.*s%s\n", name,
> +			     len > XATTR_MAX_VAL ? XATTR_MAX_VAL : len,

				min(len, XATTR_MAX_VAL)

> +			     xattr->val, len > XATTR_MAX_VAL ? "..." : "");
>  			return xattr;
>  		}
>  	}

--=20
Jeff Layton <jlayton@kernel.org>
