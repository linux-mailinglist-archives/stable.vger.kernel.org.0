Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4031D114A4A
	for <lists+stable@lfdr.de>; Fri,  6 Dec 2019 01:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726034AbfLFAvI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 19:51:08 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:46966 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725959AbfLFAvI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Dec 2019 19:51:08 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB60nBgV150539;
        Fri, 6 Dec 2019 00:50:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=eFjcBwaYno7mPdQmIPpkjK+tyUgpp/REt++lLVi//+M=;
 b=nqvJn1n4CWUYTPjfwN+cW8s1CoYKg5/eEwU2Gfgfaou///DgSost/JLrLfF/vF0cEpbl
 tUGKG+0PV7HLuaj9HisXvKTT//+zN3GBHocUeK4rlmfU+CcEy34dBTFTRJhrnIzk/Z7W
 k4ozT0fggRH9+sVl7z82Bz+rNisCFBL0qEROLCCXELe4+D8IpkS9lk2FDyMmfARl0WiA
 i8oX1Q91KB+UpwmZ3bu+NfGHWDWtGi7FCd3KpfocnYLJX547o0Dx9a+UwYSs7nuykbm1
 zRiIa2YSbzoOkqm9D6nDXeDtoXWu0FLHlqvLhnwrl9WAjBPWTnUDC42xE8SbzPLWmCx3 ew== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2wkgcqrhwy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Dec 2019 00:50:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB60nDUK179321;
        Fri, 6 Dec 2019 00:50:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2wqcbb94bp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Dec 2019 00:50:30 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xB60m7ve011284;
        Fri, 6 Dec 2019 00:48:08 GMT
Received: from dhcp-10-154-176-80.vpn.oracle.com (/10.154.176.80)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Dec 2019 16:48:06 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.1\))
Subject: Re: FAILED -  [PATCH v2 3/3] drm/mgag200: Add workaround for HW that
 does not support 'startadd'
From:   John Donnelly <john.p.donnelly@oracle.com>
In-Reply-To: <53967A49-E729-409B-8FDD-019160FFF675@oracle.com>
Date:   Thu, 5 Dec 2019 18:48:04 -0600
Cc:     Thomas Zimmermann <tzimmermann@suse.de>, airlied@redhat.com,
        daniel@ffwll.ch, stable@vger.kernel.org,
        Neil Armstrong <narmstrong@baylibre.com>,
        David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, Gerd Hoffmann <kraxel@redhat.com>,
        =?utf-8?Q?Jos=C3=A9_Roberto_de_Souza?= <jose.souza@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        Sam Ravnborg <sam@ravnborg.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <68E1D255-8E73-4112-B966-AFE851389A34@oracle.com>
References: <20191126101529.20356-4-tzimmermann@suse.de>
 <20191128142337.1B32A217F5@mail.kernel.org>
 <53967A49-E729-409B-8FDD-019160FFF675@oracle.com>
To:     Sasha Levin <sashal@kernel.org>
X-Mailer: Apple Mail (2.3445.9.1)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9462 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912060005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9462 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912060005
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Dec 3, 2019, at 11:30 AM, John Donnelly =
<john.p.donnelly@oracle.com> wrote:
>=20
>=20
> Hello Sasha and Thomas ,
>=20
>=20
> This particular patch has failed on one class of servers that has a =
slightly different Sun Vendor. ID for  the BMC video device:=20
>=20
> I will follow up with additional details in  the review comments for =
the original message,.=20
>=20
>=20
>=20
>=20
>> On Nov 28, 2019, at 8:23 AM, Sasha Levin <sashal@kernel.org> wrote:
>>=20
>> Hi,
>>=20
>> [This is an automated email]
>>=20
>> This commit has been processed because it contains a "Fixes:" tag,
>> fixing commit: 81da87f63a1e ("drm: Replace =
drm_gem_vram_push_to_system() with kunmap + unpin").
>>=20
>> The bot has tested the following trees: v5.3.13.
>>=20
>> v5.3.13: Build failed! Errors:
>>   drivers/gpu/drm/mgag200/mgag200_drv.c:104:18: error: =
=E2=80=98drm_vram_mm_debugfs_init=E2=80=99 undeclared here (not in a =
function); did you mean =E2=80=98drm_client_debugfs_init=E2=80=99?
>>=20


   I had this same issue and removed that from my local 5.4.0-rc8 build=20=





>>=20
>> NOTE: The patch will not be queued to stable trees until it is =
upstream.
>>=20
>> How should we proceed with this patch?
>>=20
>> --=20
>> Thanks,
>> Sasha
>> _______________________________________________
>> dri-devel mailing list
>> dri-devel@lists.freedesktop.org
>> =
https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__lists.freedesktop.o=
rg_mailman_listinfo_dri-2Ddevel&d=3DDwIGaQ&c=3DRoP1YumCXCgaWHvlZYR8PZh8Bv7=
qIrMUB65eapI_JnE&r=3Dt2fPg9D87F7D8jm0_3CG9yoiIKdRg4qc_thBw4bzMhc&m=3DvxMDO=
LV77rRe2ekdNFH9IxMSBQrTccltZd8A1H6xYCc&s=3DefHs2lc_RQYvzLC82c-D3wa8MpX5DCU=
_YsIo6XruAQg&e=3D
>=20

