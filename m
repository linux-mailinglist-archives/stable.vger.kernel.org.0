Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63EF7110381
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 18:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbfLCRbn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 12:31:43 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:58966 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbfLCRbn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Dec 2019 12:31:43 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB3HOOFd050929;
        Tue, 3 Dec 2019 17:31:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=iDDV1MNXRn9oPYn0jG/x5P+zH4XXxCnPUsxhYkfKBRE=;
 b=jdb47o9DjrlFKzU7xs7IZLvdvbVXpL7joCaJovJUo34Rwo3nt+dXtZCENMkqcr5cEuNX
 R8UL34ozv/cmu4hvn907uzLRkutls789KxXGAvYer89ymxKvxBsUGZHw3bi4W8+ej3Yt
 gvJn6xgPoG8w5l8+b53uksJsZfm2Atm99tUhykFeSIi51W15uHRr8+qLRZmMsHUE1Bkz
 86GPFuqZaBYHOJI1LB8/oVBJ0ak+goaI/s1Cq9eXgMlxvU0upqzbBpvtVy/B2M49/DH+
 XBSg81/orEwNqzlo/6na0gegiBEBHCg13sch/sos6bk3jAJbfTJkRiXjhcTm4ZyXYkJB mQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2wkh2r94xr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Dec 2019 17:31:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB3HSt0L077617;
        Tue, 3 Dec 2019 17:31:08 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2wn4qqa5u2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Dec 2019 17:31:08 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xB3HUtGf030441;
        Tue, 3 Dec 2019 17:30:55 GMT
Received: from dhcp-10-154-129-170.vpn.oracle.com (/10.154.129.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Dec 2019 09:30:55 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.1\))
Subject: Re:  FAILED -  [PATCH v2 3/3] drm/mgag200: Add workaround for HW that
 does not support 'startadd'
From:   John Donnelly <john.p.donnelly@oracle.com>
In-Reply-To: <20191128142337.1B32A217F5@mail.kernel.org>
Date:   Tue, 3 Dec 2019 11:30:50 -0600
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
Message-Id: <53967A49-E729-409B-8FDD-019160FFF675@oracle.com>
References: <20191126101529.20356-4-tzimmermann@suse.de>
 <20191128142337.1B32A217F5@mail.kernel.org>
To:     Sasha Levin <sashal@kernel.org>
X-Mailer: Apple Mail (2.3445.9.1)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9460 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912030131
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9460 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912030131
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hello Sasha and Thomas ,


This particular patch has failed on one class of servers that has a =
slightly different Sun Vendor. ID for  the BMC video device:=20

I will follow up with additional details in  the review comments for the =
original message,.=20




> On Nov 28, 2019, at 8:23 AM, Sasha Levin <sashal@kernel.org> wrote:
>=20
> Hi,
>=20
> [This is an automated email]
>=20
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: 81da87f63a1e ("drm: Replace =
drm_gem_vram_push_to_system() with kunmap + unpin").
>=20
> The bot has tested the following trees: v5.3.13.
>=20
> v5.3.13: Build failed! Errors:
>    drivers/gpu/drm/mgag200/mgag200_drv.c:104:18: error: =
=E2=80=98drm_vram_mm_debugfs_init=E2=80=99 undeclared here (not in a =
function); did you mean =E2=80=98drm_client_debugfs_init=E2=80=99?
>=20
>=20
> NOTE: The patch will not be queued to stable trees until it is =
upstream.
>=20
> How should we proceed with this patch?
>=20
> --=20
> Thanks,
> Sasha
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> =
https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__lists.freedesktop.o=
rg_mailman_listinfo_dri-2Ddevel&d=3DDwIGaQ&c=3DRoP1YumCXCgaWHvlZYR8PZh8Bv7=
qIrMUB65eapI_JnE&r=3Dt2fPg9D87F7D8jm0_3CG9yoiIKdRg4qc_thBw4bzMhc&m=3DvxMDO=
LV77rRe2ekdNFH9IxMSBQrTccltZd8A1H6xYCc&s=3DefHs2lc_RQYvzLC82c-D3wa8MpX5DCU=
_YsIo6XruAQg&e=3D

