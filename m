Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0978B299342
	for <lists+stable@lfdr.de>; Mon, 26 Oct 2020 18:02:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1787064AbgJZRCl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 13:02:41 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34406 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1775678AbgJZRCf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Oct 2020 13:02:35 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QGt29M030539;
        Mon, 26 Oct 2020 17:02:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=44GDkLc6kJbDFvAd8EZbxYxwh8jmuWu+PJUUda+TNTU=;
 b=giUG0iJNhnf6C0MouW+Nny0iMj9i6GXMDm7rfyFf5LXLBN15gAS0uN/jBIJB51NCHeh5
 OGqO19z/4FXL/Wz64DcoBfY6wgpT0wPUIproBzKw8j4ULOFoyJgt5owROirY2TY6OAXr
 5ycrH/jtf11k58BBo7b85WopU43xtkEd5/nVWYUF5OUBBKZrNzhZg5ZySi6TgdeZ8SKm
 jYUW9OjD1TiR8lBbXQ3Dfp3ygCu+IiQnn0Bg0NHki1Q2wd9z7SkAeArwTokRUSF8Cdy0
 4pAvWoeSJg+6/4kBGwsgThWDBlnBLX3ncrpkFHLjJzRi1ZBFB9ftob6URKuhknKgE6Vv 4Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 34cc7knr76-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 17:02:22 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QGuLq1186614;
        Mon, 26 Oct 2020 17:00:22 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 34cwuke7by-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 17:00:22 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09QH0CI3009581;
        Mon, 26 Oct 2020 17:00:13 GMT
Received: from dhcp-10-159-254-24.vpn.oracle.com (/10.159.254.24)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 10:00:12 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH 1/1] video: fbdev: fix divide error in fbcon_switch
From:   Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
In-Reply-To: <ad87c5c1-061d-8a81-7b2c-43a8687a464f@suse.de>
Date:   Mon, 26 Oct 2020 10:00:11 -0700
Cc:     Thomas Zimmermann <tzimmermann@suse.de>,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        b.zolnierkie@samsung.com, jani.nikula@intel.com,
        daniel.vetter@ffwll.ch, gustavoars@kernel.org,
        dri-devel@lists.freedesktop.org, akpm@linux-foundation.org,
        rppt@kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <3294C797-1BBB-4410-812B-4A4BB813F002@oracle.com>
References: <20201021235758.59993-1-saeed.mirzamohammadi@oracle.com>
 <ad87c5c1-061d-8a81-7b2c-43a8687a464f@suse.de>
To:     stable@vger.kernel.org
X-Mailer: Apple Mail (2.3608.120.23.2.1)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260114
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260114
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks, adding stable.

Saeed

> On Oct 22, 2020, at 12:34 AM, Thomas Zimmermann <tzimmermann@suse.de> =
wrote:
>=20
> Hi
>=20
> On 22.10.20 01:57, saeed.mirzamohammadi@oracle.com wrote:
>> From: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
>>=20
>> This patch fixes the issue due to:
>>=20
>> [   89.572883] divide_error: 0000 [#1] SMP KASAN PTI
>> [   89.572897] CPU: 3 PID: 16083 Comm: repro Not tainted =
5.9.0-rc7.20200930.rc1.allarch-19-g3e32d0d.syzk #5
>> [   89.572902] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), =
BIOS 0.5.1 01/01/2011
>> [   89.572934] RIP: 0010:cirrusfb_check_var+0x84/0x1260
>=20
> BTW, if you run qemu with cirrus, there's also a DRM driver named
> cirrus.ko. Might be a better choice than the old fbdev driver. If you
> just care about qemu, but not the actual graphics device, take a look =
at
>=20
>  =
https://urldefense.com/v3/__https://www.kraxel.org/blog/2014/10/qemu-using=
-cirrus-considered-harmful/__;!!GqivPVa7Brio!LmgeM-pVBVH80uVELF1P1nBGAbAlh=
vnxKKE_ZrEc9d76AznvAAgP1FAp3_zNa2frKaIUZteK$=20
>=20
> Anyway, thanks for your patch.
>=20
> Best regards
> Thomas
>=20
>>=20
>> The error happens when the pixels value is calculated before =
performing the sanity checks on bits_per_pixel.
>> A bits_per_pixel set to zero causes divide by zero error.
>>=20
>> This patch moves the calculation after the sanity check.
>>=20
>> Signed-off-by: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
>> Tested-by: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
>> ---
>> drivers/video/fbdev/cirrusfb.c | 3 ++-
>> 1 file changed, 2 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/drivers/video/fbdev/cirrusfb.c =
b/drivers/video/fbdev/cirrusfb.c
>> index 15a9ee7cd734..a7749101b094 100644
>> --- a/drivers/video/fbdev/cirrusfb.c
>> +++ b/drivers/video/fbdev/cirrusfb.c
>> @@ -531,7 +531,7 @@ static int cirrusfb_check_var(struct =
fb_var_screeninfo *var,
>> {
>> 	int yres;
>> 	/* memory size in pixels */
>> -	unsigned pixels =3D info->screen_size * 8 / var->bits_per_pixel;
>> +	unsigned int pixels;
>> 	struct cirrusfb_info *cinfo =3D info->par;
>>=20
>> 	switch (var->bits_per_pixel) {
>> @@ -573,6 +573,7 @@ static int cirrusfb_check_var(struct =
fb_var_screeninfo *var,
>> 		return -EINVAL;
>> 	}
>>=20
>> +	pixels =3D info->screen_size * 8 / var->bits_per_pixel;
>> 	if (var->xres_virtual < var->xres)
>> 		var->xres_virtual =3D var->xres;
>> 	/* use highest possible virtual resolution */
>>=20
>=20
> --=20
> Thomas Zimmermann
> Graphics Driver Developer
> SUSE Software Solutions Germany GmbH
> Maxfeldstr. 5, 90409 N=C3=BCrnberg, Germany
> (HRB 36809, AG N=C3=BCrnberg)
> Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=B6rffer

