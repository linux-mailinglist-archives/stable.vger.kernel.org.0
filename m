Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 294D421B7D2
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 16:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727818AbgGJOIg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 10:08:36 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50436 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727031AbgGJOIf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jul 2020 10:08:35 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06AE2g12026023;
        Fri, 10 Jul 2020 14:08:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=HRjmvI4vZJxBEruWHqbfRo7K5lADy6bhYc6mrJ1sR1E=;
 b=PA2yqrPPZyMv8eyEvUUJIuFp3ndF1NELf/wUmT8pOBuj5B1E/Q+aXjWrWV6xhru4j+y0
 6qh8cA1tCnv+Ua/o31RkdRqduODzscZu8vb58EnCLTr44p2vQ8FSaAxhM9OKmZO58Eta
 U0QGwgSDrX5YXG0ifkOamdBmK5yWHZPN9/hYqe+Tu7Fz29sv+K4dLifcS3P8+spKol3a
 de/s6vopTqB4bHuvrXyW0Tm//SVQuDdG7hhuMnC7Z+0EMdYGf8kRVqPh+LJ1r7aTogUv
 hmQOzuuzXrnUxRADRanzyOdtKuqaXrk0zeeLPi+noHrG2+cQNBmo3QNQA1AS2AD1S5+p Hw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 325y0aqn31-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 10 Jul 2020 14:08:27 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06AE8OaG022349;
        Fri, 10 Jul 2020 14:08:26 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 325k42gnqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jul 2020 14:08:25 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06AE8EFc001292;
        Fri, 10 Jul 2020 14:08:14 GMT
Received: from anon-dhcp-153.1015granger.net (/68.61.232.219)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 10 Jul 2020 07:08:14 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.14\))
Subject: Re: [PATCH v3 01/10] xattr: break delegations in {set,remove}xattr
From:   Chuck Lever <chuck.lever@oracle.com>
In-Reply-To: <20200710140308.9C810207BB@mail.kernel.org>
Date:   Fri, 10 Jul 2020 10:08:12 -0400
Cc:     Frank van der Linden <fllinden@amazon.com>,
        Bruce Fields <bfields@fieldses.org>, stable@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Transfer-Encoding: quoted-printable
Message-Id: <75E4D727-E962-466A-AC40-AB047E1EF5AE@oracle.com>
References: <20200623223927.31795-2-fllinden@amazon.com>
 <20200710140308.9C810207BB@mail.kernel.org>
To:     Sasha Levin <sashal@kernel.org>
X-Mailer: Apple Mail (2.3445.104.14)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9677 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=2
 mlxlogscore=999 mlxscore=0 spamscore=0 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007100099
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9677 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1011 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 bulkscore=0 suspectscore=2
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007100098
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha-

> On Jul 10, 2020, at 10:03 AM, Sasha Levin <sashal@kernel.org> wrote:
>=20
> Hi
>=20
> [This is an automated email]
>=20
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: =
all
>=20
> The bot has tested the following trees: v5.7.6, v5.4.49, v4.19.130, =
v4.14.186, v4.9.228, v4.4.228.
>=20
> v5.7.6: Build OK!
> v5.4.49: Build OK!
> v4.19.130: Build OK!
> v4.14.186: Build OK!
> v4.9.228: Build OK!
> v4.4.228: Failed to apply! Possible dependencies:
>    5d6c31910bc07 ("xattr: Add __vfs_{get,set,remove}xattr helpers")
>    6b2553918d8b4 ("replace ->follow_link() with new method that could =
stay in RCU mode")
>    aa80deab33a8f ("namei: page_getlink() and page_follow_link_light() =
are the same thing")
>    cd3417c8fc950 ("kill free_page_put_link()")
>    ce23e64013348 ("->getxattr(): pass dentry and inode as separate =
arguments")
>    fceef393a5381 ("switch ->get_link() to delayed_call, kill =
->put_link()")
>=20
>=20
> NOTE: The patch will not be queued to stable trees until it is =
upstream.
>=20
> How should we proceed with this patch?

I've updated the "cc: stable" tag in my testing branch to include "# =
v4.9+".


--
Chuck Lever



