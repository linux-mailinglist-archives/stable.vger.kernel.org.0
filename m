Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2961514F759
	for <lists+stable@lfdr.de>; Sat,  1 Feb 2020 10:25:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726213AbgBAJZF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Feb 2020 04:25:05 -0500
Received: from sender2-pp-o92.zoho.com.cn ([163.53.93.251]:25391 "EHLO
        sender2-pp-o92.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726197AbgBAJZF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 Feb 2020 04:25:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1580549067;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:From:Reply-To:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=iE8Hhw8qHt9Pqui/X5oxG6qwvlfgUokk5lTAAAe7Pic=;
        b=Yl8nJSlex0iCOEpfOfzb43kzM+aAEx/E0tyL/Z8gsXODpFTh3lU4CyrUMH/XTsrd
        bazvdajnbucaZCVSQv9Q6ndnPJtdssxggMofvV5twyPlpmI0uRNfv/jUkuHRlHPNk+8
        GtX/315EjZqJ/caNrmVfHC9CBsr3hYA10UpRewHs=
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 1580549065800805.4637087191738; Sat, 1 Feb 2020 17:24:25 +0800 (CST)
Date:   Sat, 01 Feb 2020 17:24:25 +0800
From:   Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
To:     "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Cc:     "Pavel Machek" <pavel@denx.de>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "stable" <stable@vger.kernel.org>, "Chao Yu" <yuchao0@huawei.com>,
        "Jaegeuk Kim" <jaegeuk@kernel.org>,
        "Sasha Levin" <sashal@kernel.org>
Message-ID: <1700010cc3e.12eb876364380.7472123035435503364@mykernel.net>
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
 >=20
=20

Hi Greg, Sasha

Now the fix patch has been in Linus's tree, you can add below three patches=
 together to  backport list.


commit 909110c060f22e6 "f2fs: choose hardlimit when softlimit is larger tha=
n hardlimit in f2fs_statfs_project()"
commit acdf2172172a511 "f2fs: fix miscounted block limit in f2fs_statfs_pro=
ject()"
commit bf2cbd3c57159c2 "f2fs: code cleanup for f2fs_statfs_project()"


Thanks,
Chengguang


