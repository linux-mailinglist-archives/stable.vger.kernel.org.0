Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94ADA192ADA
	for <lists+stable@lfdr.de>; Wed, 25 Mar 2020 15:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727620AbgCYON2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Mar 2020 10:13:28 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48820 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727595AbgCYON1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Mar 2020 10:13:27 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02PE9GTe127381;
        Wed, 25 Mar 2020 14:13:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=Dcv6XiWIA3FWI0oL0yKD6E+jKrRuAaHzTaE1NeIMyi8=;
 b=0See8Jr5jzce6bXEMUJh7uLmi9Jjt+SAu9wc33sqntNdRg/dHY7zapEiFszatyCPiZCh
 EIzqs0F8MfmJW4MsDMcikLCpI8V1yRjATM2H0sl10Ch1aP7rVnQpLz4Rr0u8OiU99WrH
 3qQi5N7bzpMIfOQsuT72VwL3ML4c06cnEOxx6rQsxc5LKigTXkhuR9+dztAbRbtzmziG
 cH5bBSdEPQbFIz9l9rDiYDhhWDzXkqkeq1X2+8Uez6ujj/BboDWdUs2h1nOiStQvc76W
 op9diZlyX/vn5DNokECqmJV17tWaLkLLZMpSM28q/wBnKwMZJiHQgfR1hkJ8UWbeap+W og== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2ywavm9xxr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Mar 2020 14:13:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02PE7cl0117867;
        Wed, 25 Mar 2020 14:13:12 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 3003ght3y3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Mar 2020 14:13:12 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02PED9XG030912;
        Wed, 25 Mar 2020 14:13:10 GMT
Received: from anon-dhcp-153.1015granger.net (/68.61.232.219)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Mar 2020 07:13:09 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH] nfsd: fix race between cache_clean and cache_purge
From:   Chuck Lever <chuck.lever@oracle.com>
In-Reply-To: <20200325010158.81CD12074D@mail.kernel.org>
Date:   Wed, 25 Mar 2020 10:13:08 -0400
Cc:     Yihao Wu <wuyihao@linux.alibaba.com>,
        Bruce Fields <bfields@fieldses.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <6C811CEE-8FC8-46D1-8E64-BE667138C43D@oracle.com>
References: <5eed50660eb13326b0fbf537fb58481ea53c1acb.1585043174.git.wuyihao@linux.alibaba.com>
 <20200325010158.81CD12074D@mail.kernel.org>
To:     Sasha Levin <sashal@kernel.org>
X-Mailer: Apple Mail (2.3445.104.11)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 adultscore=0 spamscore=0 malwarescore=0 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003250117
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 bulkscore=0 clxscore=1011 impostorscore=0
 phishscore=0 suspectscore=2 mlxlogscore=999 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003250117
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Mar 24, 2020, at 9:01 PM, Sasha Levin <sashal@kernel.org> wrote:
>=20
> Hi
>=20
> [This is an automated email]
>=20
> The bot has tested the following trees: v5.5.11, v5.4.27, v4.19.112, =
v4.14.174, v4.9.217, v4.4.217.
>=20
> v5.5.11: Build OK!
> v5.4.27: Build OK!
> v4.19.112: Failed to apply! Possible dependencies:
>    1863d77f15da ("SUNRPC: Replace the cache_detail->hash_lock with a =
regular spinlock")
>=20
> v4.14.174: Failed to apply! Possible dependencies:
>    1863d77f15da ("SUNRPC: Replace the cache_detail->hash_lock with a =
regular spinlock")
>=20
> v4.9.217: Failed to apply! Possible dependencies:
>    1863d77f15da ("SUNRPC: Replace the cache_detail->hash_lock with a =
regular spinlock")
>    2b477c00f3bd ("svcrpc: free contexts immediately on PROC_DESTROY")
>    471a930ad7d1 ("SUNRPC: Drop all entries from cache_detail when =
cache_purge()")
>=20
> v4.4.217: Failed to apply! Possible dependencies:
>    1863d77f15da ("SUNRPC: Replace the cache_detail->hash_lock with a =
regular spinlock")
>    2b477c00f3bd ("svcrpc: free contexts immediately on PROC_DESTROY")
>    471a930ad7d1 ("SUNRPC: Drop all entries from cache_detail when =
cache_purge()")
>    d8d29138b17c ("sunrpc: remove 'inuse' flag from struct =
cache_detail.")
>=20
>=20
> NOTE: The patch will not be queued to stable trees until it is =
upstream.
>=20
> How should we proceed with this patch?

Please drop it. Thanks!


--
Chuck Lever



