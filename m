Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8738542F5B
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 13:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238274AbiFHLir (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 07:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238325AbiFHLip (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 07:38:45 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADC1B1D871D;
        Wed,  8 Jun 2022 04:38:44 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 097A01C0BB4; Wed,  8 Jun 2022 13:38:43 +0200 (CEST)
Date:   Wed, 8 Jun 2022 13:38:42 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Nikolay Borisov <nborisov@suse.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 026/452] selftests/bpf: Fix vfs_link kprobe
 definition
Message-ID: <20220608113842.GB9333@duo.ucw.cz>
References: <20220607164908.521895282@linuxfoundation.org>
 <20220607164909.326145660@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="4SFOXa2GPu3tIq4H"
Content-Disposition: inline
In-Reply-To: <20220607164909.326145660@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--4SFOXa2GPu3tIq4H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit e299bcd4d16ff86f46c48df1062c8aae0eca1ed8 ]
>=20
> Since commit 6521f8917082 ("namei: prepare for idmapped mounts")
> vfs_link's prototype was changed, the kprobe definition in
> profiler selftest in turn wasn't updated. The result is that all
> argument after the first are now stored in different registers. This
> means that self-test has been broken ever since. Fix it by updating the
> kprobe definition accordingly.

I don't see 6521f8917082 ("namei: prepare for idmapped mounts") in
5.10-stable tree. In 5.10, we still have:

include/linux/fs.h:extern int vfs_link(struct dentry *, struct inode *, str=
uct dentry *, struct inode **);

I believe that means we should not have this one, either.

Best regards,
							Pavel
						=09
> +++ b/tools/testing/selftests/bpf/progs/profiler.inc.h
> @@ -826,8 +826,9 @@ int kprobe_ret__do_filp_open(struct pt_regs* ctx)
> =20
>  SEC("kprobe/vfs_link")
>  int BPF_KPROBE(kprobe__vfs_link,
> -	       struct dentry* old_dentry, struct inode* dir,
> -	       struct dentry* new_dentry, struct inode** delegated_inode)
> +	       struct dentry* old_dentry, struct user_namespace *mnt_userns,
> +	       struct inode* dir, struct dentry* new_dentry,
> +	       struct inode** delegated_inode)
>  {
>  	struct bpf_func_stats_ctx stats_ctx;
>  	bpf_stats_enter(&stats_ctx, profiler_bpf_vfs_link);
> --=20
> 2.35.1
>=20
>=20

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--4SFOXa2GPu3tIq4H
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYqCKQgAKCRAw5/Bqldv6
8krmAJ9uV43+nIvLcGiHf85fB/Xh1kPU3wCcC2Wo19xvIxoxnv4YScAutAJ5aQU=
=XVZZ
-----END PGP SIGNATURE-----

--4SFOXa2GPu3tIq4H--
