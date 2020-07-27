Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A78F022FA3D
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 22:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbgG0Ukp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 16:40:45 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41480 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbgG0Ukp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jul 2020 16:40:45 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06RKbcpu146352;
        Mon, 27 Jul 2020 20:40:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=LyXgMk0f2r2QyhaI8yTJHaBKGPFro/rxd5GTPDWD6B4=;
 b=WOWsIZqj41ThqMb+p7GdDDHm5AV1uiYsm/CMxIzod/VeKcNyQ1mShNlKBXPFcNeIwzXo
 zoL0SFIIU826nYdlE6U8cRdy6QLmR5LyFfBF1NQperb779Daxxxxgub//yaFkE3fV2BB
 9D/InZpmLbvu5xwMDKkAK9eWesUZGD52OplWgyADvSMqdIQhb/QXMHzDGelJnPWuh9G3
 pGAs79+GVrWrF6HGk5e02tRg6/oyrmCOv6UeHTPSMuYEDewjKk26bbueRmLFp8sw4Qs7
 J3QxxFKPWSLyWUyOwcLtiKos3seIDcZCYwhusTx4+eZX4y4dvJM4dr8071IKQo7NikOo Yw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 32hu1jbsg9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 27 Jul 2020 20:40:41 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06RKcO2f014022;
        Mon, 27 Jul 2020 20:38:40 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 32hu5rq8qg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Jul 2020 20:38:40 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06RKcdHI010469;
        Mon, 27 Jul 2020 20:38:39 GMT
Received: from dhcp-10-154-112-121.vpn.oracle.com (/10.154.112.121)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Jul 2020 13:38:39 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.5\))
Subject: Re: (resend) [PATCH [linux-4.14.y]] dm cache: submit writethrough
 writes in parallel to origin and cache
From:   John Donnelly <john.p.donnelly@oracle.com>
In-Reply-To: <20200727201700.GJ406581@sasha-vm>
Date:   Mon, 27 Jul 2020 15:38:38 -0500
Cc:     Mike Snitzer <snitzer@redhat.com>, stable@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <6F764B9B-DEE6-4060-9F11-050D2F0999ED@oracle.com>
References: <37c5a615-655d-c106-afd0-54e03f3c0eef@oracle.com>
 <20200727150014.GA27472@redhat.com> <20200727191809.GI406581@sasha-vm>
 <D8DDA535-33D5-4E80-85B3-62A463441B5F@oracle.com>
 <20200727201700.GJ406581@sasha-vm>
To:     Sasha Levin <sashal@kernel.org>
X-Mailer: Apple Mail (2.3445.9.5)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9695 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 adultscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007270138
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9695 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 impostorscore=0 priorityscore=1501 spamscore=0 phishscore=0
 suspectscore=3 bulkscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007270138
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Jul 27, 2020, at 3:17 PM, Sasha Levin <sashal@kernel.org> wrote:
>=20
> On Mon, Jul 27, 2020 at 02:38:52PM -0500, John Donnelly wrote:
>>=20
>>=20
>>> On Jul 27, 2020, at 2:18 PM, Sasha Levin <sashal@kernel.org> wrote:
>>>=20
>>> On Mon, Jul 27, 2020 at 11:00:14AM -0400, Mike Snitzer wrote:
>>>> This mail needs to be saent to stable@vger.kernel.org (now cc'd).
>>>>=20
>>>> Greg et al: please backport =
2df3bae9a6543e90042291707b8db0cbfbae9ee9
>>>=20
>>> Hm, what's the issue that this patch addresses? It's not clear from =
the
>>> commit message.
>>>=20
>>> --
>>> Thanks,
>>> Sasha
>>=20
>> HI Sasha ,
>>=20
>> In an off-line conversation I had with Mike , he indicated that :
>>=20
>>=20
>> commit 1b17159e52bb31f982f82a6278acd7fab1d3f67b
>> Author: Mike Snitzer <snitzer@redhat.com>
>> Date:   Fri Feb 28 18:00:53 2020 -0500
>>=20
>>  dm bio record: save/restore bi_end_io and bi_integrity
>>=20
>>=20
>> commit 248aa2645aa7fc9175d1107c2593cc90d4af5a4e
>> Author: Mike Snitzer <snitzer@redhat.com>
>> Date:   Fri Feb 28 18:11:53 2020 -0500
>>=20
>>  dm integrity: use dm_bio_record and dm_bio_restore
>>=20
>>=20
>> Were picked up  in  "stable" kernels picked up even though
>> neither was marked for stable@vger.kernel.org
>>=20
>> Adding this missing  commit :
>>=20
>> 2df3bae9a6543e90042291707b8db0cbfbae9ee9
>>=20
>>=20
>> Completes the series
>=20
> Should we just revert those two commits instead if they're not needed?
>=20
> --=20
> Thanks,
> Sasha

  As I stated above:

> Fixes: 705559706d62038b74c5088114c1799cf2c9dce8 (dm bio record:
> save/restore bi_end_io and bi_integrity, version 4.14.188)
>=20
> 70555970 introduced a mkfs.ext4 hang on a LVM device that has been
> modified with lvconvert --cachemode=3Dwritethrough.

  It corrects an issue we discovered in 4.14.188 .    Any other branches =
those two commits have migrated to will likely have the same regression.=20=


I am confident linux-4.14.y will  be better off with it ;-)=20




