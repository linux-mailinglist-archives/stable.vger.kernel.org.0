Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6861313029B
	for <lists+stable@lfdr.de>; Sat,  4 Jan 2020 15:21:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbgADOVR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Jan 2020 09:21:17 -0500
Received: from sender2-pp-o92.zoho.com.cn ([163.53.93.251]:25331 "EHLO
        sender2-pp-o92.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725924AbgADOVR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Jan 2020 09:21:17 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1578147644; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=UP5v/gTFe0EoamPGJk/WCJd2JodnefWKtjVR7nniThTrWZyrGKLR91BN3S2vjnge9aQapbroNQ4wQfM+zY8R6pYu2dSpi9t530EkJtwP1TpedpHw/1vUaRzIQJZfLadw/Eavm0WL+EyxwJ68A86dMd3bUSLR8HME0mAQFQZPaQI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1578147644; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:References:Subject:To; 
        bh=WXgRlYlDQiMQqPDWb4znFahq2VSqYBgacavFm5kZdZs=; 
        b=dGnCp3tQwZMyv1UKmrAOZBjP3+qBzzRkNVpu5nINu2sH9NDkDnjE1+JOlMK65S3qsQFhFXzomyDMelteQnxf45WmBBdbh9S7hKC2NIC4eUMLdsue5OyRNj5rTcKGqN2HzPlR+HN+QFt1VNonSk9eMKR3NPzgXINrMpqrf+8YEM8=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1578147644;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:From:Reply-To:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=WXgRlYlDQiMQqPDWb4znFahq2VSqYBgacavFm5kZdZs=;
        b=LLlTOhYdqt3XBobFMfb0tFs/LfyWwnAKOV6ZMvhiXYDQvoYDG8/R3+8g0e80W9RT
        VEezyCczBQHCsOPPWvwIo2YX2Qk0UqwNYJj1Eg4c6XYAtGriTaPRM9SBGjD0mTALw9d
        zG/CBctW2edP5tV1ac+ZKJfkxkmCQ9c6cj+f2Mn0=
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 1578147642134520.0998453017459; Sat, 4 Jan 2020 22:20:42 +0800 (CST)
Date:   Sat, 04 Jan 2020 22:20:42 +0800
From:   Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
To:     "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Cc:     "Pavel Machek" <pavel@denx.de>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "stable" <stable@vger.kernel.org>, "Chao Yu" <yuchao0@huawei.com>,
        "Jaegeuk Kim" <jaegeuk@kernel.org>,
        "Sasha Levin" <sashal@kernel.org>
Message-ID: <16f70edfb11.12deacc7a49186.2118741807946874161@mykernel.net>
In-Reply-To: <20200104115308.GA1296856@kroah.com>
References: <20200102220029.183913184@linuxfoundation.org>
 <20200102220035.294585461@linuxfoundation.org>
 <20200103171213.GC14328@amd>
 <16f6e3f5bbe.d291a05d38838.5222280714928609391@mykernel.net> <20200104115308.GA1296856@kroah.com>
Subject: Re: [PATCH 4.19 062/114] f2fs: choose hardlimit when softlimit is
 larger than hardlimit in f2fs_statfs_project()
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Priority: Medium
User-Agent: ZohoCN Mail
X-Mailer: ZohoCN Mail
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E5=85=AD, 2020-01-04 19:53:08 Greg Kroah=
-Hartman <gregkh@linuxfoundation.org> =E6=92=B0=E5=86=99 ----
 > On Sat, Jan 04, 2020 at 09:50:43AM +0800, Chengguang Xu wrote:
 > >  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E5=85=AD, 2020-01-04 01:12:13 Pavel=
 Machek <pavel@denx.de> =E6=92=B0=E5=86=99 ----
 > >  > Hi!
 > >  >=20
 > >  > > From: Chengguang Xu <cgxu519@mykernel.net>
 > >  > >=20
 > >  > > [ Upstream commit 909110c060f22e65756659ec6fa957ae75777e00 ]
 > >  > >=20
 > >  > > Setting softlimit larger than hardlimit seems meaningless
 > >  > > for disk quota but currently it is allowed. In this case,
 > >  > > there may be a bit of comfusion for users when they run
 > >  > > df comamnd to directory which has project quota.
 > >  > >=20
 > >  > > For example, we set 20M softlimit and 10M hardlimit of
 > >  > > block usage limit for project quota of test_dir(project id 123).
 > >  >=20
 > >  > > Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
 > >  > > Reviewed-by: Chao Yu <yuchao0@huawei.com>
 > >  > > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
 > >  > > Signed-off-by: Sasha Levin <sashal@kernel.org>
 > >  > > ---
 > >  > >  fs/f2fs/super.c | 20 ++++++++++++++------
 > >  > >  1 file changed, 14 insertions(+), 6 deletions(-)
 > >  > >=20
 > >  > > diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
 > >  > > index 7a9cc64f5ca3..662c7de58b99 100644
 > >  > > --- a/fs/f2fs/super.c
 > >  > > +++ b/fs/f2fs/super.c
 > >  > > @@ -1148,9 +1148,13 @@ static int f2fs_statfs_project(struct supe=
r_block *sb,
 > >  > >          return PTR_ERR(dquot);
 > >  > >      spin_lock(&dquot->dq_dqb_lock);
 > >  > > =20
 > >  > > -    limit =3D (dquot->dq_dqb.dqb_bsoftlimit ?
 > >  > > -         dquot->dq_dqb.dqb_bsoftlimit :
 > >  > > -         dquot->dq_dqb.dqb_bhardlimit) >> sb->s_blocksize_bits;
 > >  > > +    limit =3D 0;
 > >  > > +    if (dquot->dq_dqb.dqb_bsoftlimit)
 > >  > > +        limit =3D dquot->dq_dqb.dqb_bsoftlimit;
 > >  > > +    if (dquot->dq_dqb.dqb_bhardlimit &&
 > >  > > +            (!limit || dquot->dq_dqb.dqb_bhardlimit < limit))
 > >  > > +        limit =3D dquot->dq_dqb.dqb_bhardlimit;
 > >  > > +
 > >  > >      if (limit && buf->f_blocks > limit) {
 > >  >=20
 > >  > >> blocksize disappeared here. That can't be right.
 > >  >=20
 > >  > Plus, is this just obfuscated way of saying
 > >  >=20
 > >  > limit =3D min_not_zero(dquot->dq_dqb.dqb_bsoftlimit, dquot->dq_dqb.=
dqb_bhardlimit)?
 > >  >=20
 > >=20
 > > Please  skip this patch from  stable list,  I'll send  a revised patch=
 to upstream.
 >=20
 > This patch is already in Linus's tree, so you can't send a "revised"
 > version, only one that applies on top of this one :)
 >=20
 > That being said, I'll go drop this from the stable queues, thanks.
 > Please let us know when the fixed patch is in Linus's tree and we will
 > be glad to take both of them.
=20
I got it, Thanks Greg!


