Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D32FD113B78
	for <lists+stable@lfdr.de>; Thu,  5 Dec 2019 06:53:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbfLEFx1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 00:53:27 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:13518 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725953AbfLEFx1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Dec 2019 00:53:27 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5de89b460000>; Wed, 04 Dec 2019 21:53:10 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Wed, 04 Dec 2019 21:53:26 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Wed, 04 Dec 2019 21:53:26 -0800
Received: from [10.2.163.157] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 5 Dec
 2019 05:53:26 +0000
Subject: Re: [v2 PATCH] mm: move_pages: return valid node id in status if the
 page is already on the target node
From:   John Hubbard <jhubbard@nvidia.com>
To:     Yang Shi <yang.shi@linux.alibaba.com>, <fabecassis@nvidia.com>,
        <mhocko@suse.com>, <cl@linux.com>, <vbabka@suse.cz>,
        <mgorman@techsingularity.net>, <akpm@linux-foundation.org>
CC:     <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
References: <1575519678-86510-1-git-send-email-yang.shi@linux.alibaba.com>
 <d4935b9f-39ef-fb91-1786-be84784dccd0@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <565bf53f-1a08-d472-30ac-cf9953e1490a@nvidia.com>
Date:   Wed, 4 Dec 2019 21:50:37 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <d4935b9f-39ef-fb91-1786-be84784dccd0@nvidia.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1575525191; bh=fcuwO+qF7oSQ+luHDShI2/Xlyftz/4idYXdV3q3Mch0=;
        h=X-PGP-Universal:Subject:From:To:CC:References:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=Dwjcnt5J5LvzvJBffj8B2N/ltqQn5cKac3cmsokwj8ehF2Tuyf4UkltlP3JiuOYGD
         lXOJkJlWp867qETui/MZlkheM+VapeBQwRZORmakbX3GB/x6Ehp2Nzfr0YBmlbMtLU
         MAoPyiRDKM02I8d8ZrJzTWKWtaabl7WegDuxXmSLtpM/MLbb5WumxKRrkPQtqO9bbC
         gmbm4nRNYKzWH8h2xfU0tyQtRGI6uKU1z2yC846tTCEwUzthb3jbTVZvD7OVoBmEYw
         fwzbkJ0YoKvQRm+SgtV7zdwYay3hXJRxOd0elGYyMQlQcFHH3wr0E+ijirQwcp6obs
         bDDcS84I+g8Fg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/4/19 9:44 PM, John Hubbard wrote:
...=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>=20
> Let's change the comment above add_page_for_migration(), to read:
>=20
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * Most errors in the pa=
ge lookup or isolation are not fatal
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * and we simply report =
them via the status array. However,
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * positive error values=
 are fatal.
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>=20
>=20
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 err =3D add_page_=
for_migration(mm, addr, current_node,
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 &pagelist, flags & MPOL_MF_MOVE_ALL);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 &pagelist, flags & MPOL_MF_MOVE_ALL, status,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 i);
>> +
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!err)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 continue;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* store_status() failed in =
add_page_for_migration() */
>=20
> ...and let's replace the above line, with the following:
>=20

Correction, I experienced a fatal editor copy-paste mistake here. :) I mean=
t to
suggest this:

		/*
		 * add_page_for_migration() experienced a fatal failure (see the
		 * comments in that routine for details).
		 */

>=20
>=20
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (err > 0) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 err =
=3D -EFAULT;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto=
 out_flush;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> +
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 err =3D store_sta=
tus(status, i, err, 1);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (err)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 goto out_flush;
>>

thanks,
--=20
John Hubbard
NVIDIA
