Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25791206B1B
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 06:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728808AbgFXE3z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 00:29:55 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56644 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727862AbgFXE3x (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jun 2020 00:29:53 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05O4LvSc030582;
        Wed, 24 Jun 2020 04:29:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=jt9ppXIndIGWmGXxqK3cCyssTE94sxkPsZAau7yXdVk=;
 b=sdj2F3YKsX86XmRgJddHfdtO4l9GAnHza4TRJihFrbUSgKMa6Ys041jbVj40Vib3v2sV
 rHrf1gjCA4N2nrFN7DqfLy3EUQ063jHE5stlhYEV5wpM1bhkur4bS9Sq7Byv9DaBHhRt
 4o4LM4s0sToaHCYWBa/MHV8/dp0y+S843sPmiWL82Mhr15xO1br1Ye5gn0MYf+k3K7Kw
 sLfp7XunhoJ0RM3x8ta008eU/q1idZgDyk6XIf/wAajCNF/m0CDrU+84d+F24LnPiKe3
 +n9l8S7GyaVo/+C0U6lwTd2702PW36oTJFxWpr/V41R2aWRZai5UjNDMV+eoZGWnvtHG vQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 31uustrksy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 24 Jun 2020 04:29:50 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05O4Nmxc086112;
        Wed, 24 Jun 2020 04:29:50 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 31uuqy7dg0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Jun 2020 04:29:50 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05O4Tmem030156;
        Wed, 24 Jun 2020 04:29:48 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 24 Jun 2020 04:29:47 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Steffen Maier <maier@linux.ibm.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Kees Cook <keescook@chromium.org>, linux-scsi@vger.kernel.org,
        stable@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-s390@vger.kernel.org, Benjamin Block <bblock@linux.ibm.com>
Subject: Re: [PATCH] zfcp: fix panic on ERP timeout for previously dismissed ERP action
Date:   Wed, 24 Jun 2020 00:29:40 -0400
Message-Id: <159297296072.9797.12946914828075340057.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200623140242.98864-1-maier@linux.ibm.com>
References: <20200623140242.98864-1-maier@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9661 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=851
 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006240031
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9661 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 cotscore=-2147483648 malwarescore=0 mlxscore=0 clxscore=1011
 lowpriorityscore=0 mlxlogscore=866 phishscore=0 priorityscore=1501
 spamscore=0 impostorscore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006240031
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 23 Jun 2020 16:02:42 +0200, Steffen Maier wrote:

> Suppose that, for unrelated reasons, FSF requests on behalf of recovery
> are very slow and can run into the ERP timeout.
> 
> In the case at hand, we did adapter recovery to a large degree.
> However due to the slowness a LUN open is pending
> so the corresponding fc_rport remains blocked.
> After fast_io_fail_tmo we trigger close physical port recovery
> for the port under which the LUN should have been opened.
> The new higher order port recovery
> dismisses the pending LUN open ERP action and
> dismisses the pending LUN open FSF request.
> Such dismissal decouples the ERP action from the pending corresponding
> FSF request by setting zfcp_fsf_req->erp_action to NULL
> (among other things) [zfcp_erp_strategy_check_fsfreq()].
> 
> [...]

Applied to 5.8/scsi-fixes, thanks!

[1/1] scsi: zfcp: Fix panic on ERP timeout for previously dismissed ERP action
      https://git.kernel.org/mkp/scsi/c/936e6b85da04

-- 
Martin K. Petersen	Oracle Linux Engineering
