Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E97F5D963
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 02:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbfGCAm3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 20:42:29 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53874 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726430AbfGCAm2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jul 2019 20:42:28 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x62KJUkC012245;
        Tue, 2 Jul 2019 20:37:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2018-07-02;
 bh=fueYM9eyTvkbZeEIBz3R0f1MZEh81+cPxnT08admdT8=;
 b=wI1+tiHOHvPB7MJ9DqyK6UmskqgS5QUYfFJTqMJeLmTNamGGw0KyEuqI/6JAFQjKM27w
 TliOenZbQ/h1XC45SwV5MyH1dXbi4HamWkvZneeAV5cd7XPftSMb2R7d7YZDU/DD2npS
 yixUrvuAKq/5kA5y9g2vCQm9Sp7LxK5hOspo/JXxe23aUz8CfzQ5PNS6fdGyiI05WDqX
 Tc18fFzsX4mpOefjaRcnf1AaxiCOYOt4Fr19lalbW9nl/HOjWa4W4JCM+A49r7xXGlZO
 mcLYNC+8lnL0XLYM79fbVXP9I8uNuxNoOVMTnxdfYGYXrNCMOS2EwPjRU9uIBrM/jlfK qA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2te5tbnv4n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jul 2019 20:37:21 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x62KNbG9196020;
        Tue, 2 Jul 2019 20:37:20 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2tebqgqst4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jul 2019 20:37:20 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x62KbIbS027858;
        Tue, 2 Jul 2019 20:37:18 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Jul 2019 13:37:18 -0700
To:     Roman Bolshakov <r.bolshakov@yadro.com>
Cc:     <target-devel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <stable@vger.kernel.org>, Bart Van Assche <bvanassche@acm.org>
Subject: Re: [RESEND PATCH] scsi: target/iblock: Fix overrun in WRITE SAME emulation
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190702191636.26481-1-r.bolshakov@yadro.com>
Date:   Tue, 02 Jul 2019 16:37:16 -0400
In-Reply-To: <20190702191636.26481-1-r.bolshakov@yadro.com> (Roman Bolshakov's
        message of "Tue, 2 Jul 2019 22:16:38 +0300")
Message-ID: <yq1pnmsfa0z.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9306 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=974
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907020227
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9306 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907020227
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Roman,

> WRITE SAME corrupts data on the block device behind iblock if the
> command is emulated. The emulation code issues (M - 1) * N times more
> bios than requested, where M is the number of 512 blocks per real
> block size and N is the NUMBER OF LOGICAL BLOCKS specified in WRITE
> SAME command. So, for a device with 4k blocks, 7 * N more LBAs gets
> written after the requested range.
>
> The issue happens because the number of 512 byte sectors to be written
> is decreased one by one while the real bios are typically from 1 to 8
> 512 byte sectors per bio.

Applied to 5.2/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
