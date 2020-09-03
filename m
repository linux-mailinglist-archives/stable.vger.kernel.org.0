Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52A3E25B8F7
	for <lists+stable@lfdr.de>; Thu,  3 Sep 2020 05:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbgICDBN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 23:01:13 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51026 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbgICDBM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Sep 2020 23:01:12 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0832xMMT043649;
        Thu, 3 Sep 2020 03:01:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=EDStHEgQBzySRTUK2s3lb3/zdxMyO59KDA+zCpJJaSQ=;
 b=YpPpy5ZpdqK6weXaV+tSAGf7O6hoRv9Z4WYKpXhpOpOXDkFpnbF8QGQ6ohsZ14erPCC3
 zYr6lQVlZpjxCcyPSE7K0fgSohqo4L70VXxLN/VrudipPF1Ivvv5T8TpD15pcTrJDVrG
 LNPE/C8x0EqWEANQIuIdyFZhEyNyQ/RaNHWyd/lZJ/uEdRl8yANoxrpfbFUnpNi+/9dC
 cshyLeYm/u7Uv4PLfdx/WgP3wg7Zg86TLma9CaeH1Rq0yIUl1ctxxQ1U9NoJ6iJvdG60
 JYAq9Tdp5aXsQR05IKVwBQ7Pf4NEj69B6EeARVcsmMExXvhjFpsZHvK2i/LUoPzNDER/ tA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 337eer67m0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 03 Sep 2020 03:01:10 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0832tGAB175876;
        Thu, 3 Sep 2020 03:01:09 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 3380kr1d3c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Sep 2020 03:01:09 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 083317vZ009097;
        Thu, 3 Sep 2020 03:01:08 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Sep 2020 20:01:07 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Hou Pu <houpu@bytedance.com>, michael.christie@oracle.com,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] iscsi-target: fix hang in iscsit_access_np() when getting tpg->np_login_sem
Date:   Wed,  2 Sep 2020 23:00:58 -0400
Message-Id: <159910202092.23499.4192678071370193305.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200729130343.24976-1-houpu@bytedance.com>
References: <20200729130343.24976-1-houpu@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 suspectscore=0 malwarescore=0 mlxlogscore=991 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009030027
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 impostorscore=0 mlxlogscore=988 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009030027
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 29 Jul 2020 09:03:43 -0400, Hou Pu wrote:

> The iscsi target login thread might stuck in following stack:
> 
> cat /proc/`pidof iscsi_np`/stack
> [<0>] down_interruptible+0x42/0x50
> [<0>] iscsit_access_np+0xe3/0x167
> [<0>] iscsi_target_locate_portal+0x695/0x8ac
> [<0>] __iscsi_target_login_thread+0x855/0xb82
> [<0>] iscsi_target_login_thread+0x2f/0x5a
> [<0>] kthread+0xfa/0x130
> [<0>] ret_from_fork+0x1f/0x30
> 
> [...]

Applied to 5.9/scsi-fixes, thanks!

[1/1] scsi: target: iscsi: Fix hang in iscsit_access_np() when getting tpg->np_login_sem
      https://git.kernel.org/mkp/scsi/c/ed43ffea78dc

-- 
Martin K. Petersen	Oracle Linux Engineering
