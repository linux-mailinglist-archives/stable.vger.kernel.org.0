Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCC68247C8F
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 05:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbgHRDOs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 23:14:48 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35164 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbgHRDOr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 23:14:47 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07I36sRp113679;
        Tue, 18 Aug 2020 03:14:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=bmnFBvbblDd4uPW3ksN/nz/pdXsfQaxSk+bxnq2E9ew=;
 b=LgNqzd/wJHu3OLRlufLByt3w8VKnFgiMeRzA161fhELQ2qoIsgDb1C0hRP4rsWJq9mTs
 6KTSOepjpycLsW5GZeUlYHN0vvvOyG8rvhL6K8IKNz+0d0b/jXxBnQs3MSZgimVpbr4a
 /10NHzSch2du58PsRCdOT9f71Jev8SxFa9G1Ou/yCKNduqlmDY3EEbglIYmJsrEEm/fh
 OOQP/g6vjj+U+C5AovGjFIWWAgkXrhtfEpOaI8n0lvuAeHogtwU7EM3mPw0gGa+zSXdn
 e3rEWwapj0A4bOjEz4BwXTjaR2UVQ3axO6yZh28oWXJnO/d0SKoImLolMgeyNbrP3fW7 Sw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 32x8bn22w1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 18 Aug 2020 03:14:45 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07I38BAY104642;
        Tue, 18 Aug 2020 03:12:44 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 32xsfraxrk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 03:12:44 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07I3ChnW029820;
        Tue, 18 Aug 2020 03:12:43 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Aug 2020 20:12:43 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Steffen Maier <maier@linux.ibm.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Vasily Gorbik <gor@linux.ibm.com>, linux-scsi@vger.kernel.org,
        linux-s390@vger.kernel.org, Benjamin Block <bblock@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        stable@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH] zfcp: fix use-after-free in request timeout handlers
Date:   Mon, 17 Aug 2020 23:12:28 -0400
Message-Id: <159772029326.19587.11457042799649167803.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200813152856.50088-1-maier@linux.ibm.com>
References: <20200813152856.50088-1-maier@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008180022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 clxscore=1011 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180022
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 13 Aug 2020 17:28:56 +0200, Steffen Maier wrote:

> Before v4.15 commit 75492a51568b ("s390/scsi: Convert timers to use
> timer_setup()"), we intentionally only passed zfcp_adapter as context
> argument to zfcp_fsf_request_timeout_handler(). Since we only trigger
> adapter recovery, it was unnecessary to sync against races between timeout
> and (late) completion.
> Likewise, we only passed zfcp_erp_action as context argument to
> zfcp_erp_timeout_handler(). Since we only wakeup an ERP action, it was
> unnecessary to sync against races between timeout and (late) completion.
> 
> [...]

Applied to 5.9/scsi-fixes, thanks!

[1/1] scsi: zfcp: Fix use-after-free in request timeout handlers
      https://git.kernel.org/mkp/scsi/c/2d9a2c5f581b

-- 
Martin K. Petersen	Oracle Linux Engineering
