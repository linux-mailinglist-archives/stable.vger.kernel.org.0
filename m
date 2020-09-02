Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE79E25A362
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 04:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726625AbgIBC7G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 22:59:06 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48134 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbgIBC7F (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Sep 2020 22:59:05 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0822reYl124264;
        Wed, 2 Sep 2020 02:59:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=0giVz1o+VCCS8VKnCNvTQEqXBGUN6yWSXQt6dCZHuEU=;
 b=oHRFz4j6AovQaOWR8xieEzt14PRdaP2mpEzk5RNCOY7zavt1iC7je3s9yJM8J1BC8sfy
 o2u8aF7vZtY+DQ9+SNpwEAkRvJF4TznM38kWVIh/ph6fBJWF6YvMxpVkG324thQBwK6q
 ZqMelE8QaVsIZhujjDP+zD0+7etDfop5Lm0XzK8IBbKbCgDw/FYdrghcFZtZsAP5W5d6
 wU3R014R58iOhq4v9QNGfjQoT20jErBWbUTUC4ScSIoHcMRWyCSiTzQ7z490gdTB0XiG
 THsT31LJXRaWZLAQzL1wmbrLklzER+gvovyMLnxUaWNvZ9P0CNLfWcJOsVVJyyeBfE+U Pw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 339dmmxaaf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 02 Sep 2020 02:59:03 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0822t16F186009;
        Wed, 2 Sep 2020 02:57:02 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 3380st0wt5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Sep 2020 02:57:02 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0822v1hJ005678;
        Wed, 2 Sep 2020 02:57:01 GMT
Received: from [20.15.0.5] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Sep 2020 19:57:01 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH] iscsi-target: fix hang in iscsit_access_np() when getting
 tpg->np_login_sem
From:   Michael Christie <michael.christie@oracle.com>
In-Reply-To: <20200729130343.24976-1-houpu@bytedance.com>
Date:   Tue, 1 Sep 2020 21:57:00 -0500
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <24875CC6-70FA-477D-BB74-51FBFDD96732@oracle.com>
References: <20200729130343.24976-1-houpu@bytedance.com>
To:     Hou Pu <houpu@bytedance.com>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9731 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009020026
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9731 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 impostorscore=0 mlxscore=0 suspectscore=0
 spamscore=0 clxscore=1011 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009020026
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Jul 29, 2020, at 8:03 AM, Hou Pu <houpu@bytedance.com> wrote:
>=20
> The iscsi target login thread might stuck in following stack:
>=20
> cat /proc/`pidof iscsi_np`/stack
> [<0>] down_interruptible+0x42/0x50
> [<0>] iscsit_access_np+0xe3/0x167
> [<0>] iscsi_target_locate_portal+0x695/0x8ac
> [<0>] __iscsi_target_login_thread+0x855/0xb82
> [<0>] iscsi_target_login_thread+0x2f/0x5a
> [<0>] kthread+0xfa/0x130
> [<0>] ret_from_fork+0x1f/0x30
>=20
> This could be reproduced by following steps:
> 1. Initiator A try to login iqn1-tpg1 on port 3260. After finishing
>   PDU exchange in the login thread and before the negotiation is
>   finished, at this time the network link is down. In a production
>   environment, this could happen. I could emulated it by bring
>   the network card down in the initiator node by ifconfig eth0 down.
>   (Now A could never finish this login. And tpg->np_login_sem is
>   hold by it).
> 2. Initiator B try to login iqn2-tpg1 on port 3260. After finishing
>   PDU exchange in the login thread. The target expect to process
>   remaining login PDUs in workqueue context.
> 3. Initiator A' try to re-login to iqn1-tpg1 on port 3260 from
>   a new socket. It will wait for tpg->np_login_sem with
>   np->np_login_timer loaded to wait for at most 15 second.
>   (Because the lock is held by A. A never gets a change to
>   release tpg->np_login_sem. so A' should finally get timeout).
> 4. Before A' got timeout. Initiator B gets negotiation failed and
>   calls iscsi_target_login_drop()->iscsi_target_login_sess_out().
>   The np->np_login_timer is canceled. And initiator A' will hang
>   there forever. Because A' is now in the login thread. All other
>   login requests could not be serviced.

iqn1 and iqn1 are different targets right? It=E2=80=99s not clear to me =
how when initiator B fails negotiation that it cancels the timer for the =
portal under a different iqn/target.

Is iqn2-tpg1->np1 a different struct than iqn1-tpg1-np1? I mean =
iscsit_get_tpg_from_np would return a different np struct for initiator =
B and for A?=
