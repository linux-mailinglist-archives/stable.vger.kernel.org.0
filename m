Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B48327DEFB
	for <lists+stable@lfdr.de>; Wed, 30 Sep 2020 05:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727206AbgI3DdI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 23:33:08 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:47980 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbgI3DdI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Sep 2020 23:33:08 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08U3NuIY146548;
        Wed, 30 Sep 2020 03:32:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=ggEbhGxsmKu0jJukfKnzC8SsbODsi/dD5e3sMRvdYnk=;
 b=rEIYf9kwEcN+hLKZ4LP1QBOP+qKHcozH03cNK0I3/H4U/csDG3UF1OL1Wrsk+4sPB6na
 9QXEwJWLi9PLUhxaLQ+5dQy249J0NBtPvafun5GFTmnmp1cpjUoBkXB/+dz6flGcDy5z
 BNaRrYKZ8tzRF/Fwjqh018QTA0ojUFE2ebP8FOo0Z4qZIWHTVH0pS7mLgg9SXL8ytoNE
 J9Bl4sfcQBG6lnF5kgdsUa9EVSJBkhIxZ7i8rbuo1+tz8OUF4PHOWw/WlnUqA2fWv/rf
 n/h7FWBuPNiu49ejW7+0OlxHYuTpBoRkds7K3IWerkNufhMARKIoHNxmPvNVjeAlJCPl Rw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 33su5axbwn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 30 Sep 2020 03:32:59 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08U3QVEu064860;
        Wed, 30 Sep 2020 03:32:59 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 33tfhygk0k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Sep 2020 03:32:59 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08U3WwEO026773;
        Wed, 30 Sep 2020 03:32:58 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 29 Sep 2020 20:32:57 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Chris Leech <cleech@redhat.com>, Lee Duncan <lduncan@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Mark Mielke <mark.mielke@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        open-iscsi@googlegroups.com, Marc Dionne <marc.c.dionne@gmail.com>,
        stable@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] iscsi: iscsi_tcp: Avoid holding spinlock while calling getpeername
Date:   Tue, 29 Sep 2020 23:32:56 -0400
Message-Id: <160143675721.27517.12028217524794232407.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200928043329.606781-1-mark.mielke@gmail.com>
References: <20200928043329.606781-1-mark.mielke@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9759 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=862 bulkscore=0
 phishscore=0 malwarescore=0 adultscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009300023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9759 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=868 suspectscore=0
 lowpriorityscore=0 spamscore=0 clxscore=1011 mlxscore=0 impostorscore=0
 malwarescore=0 phishscore=0 adultscore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009300023
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 28 Sep 2020 00:33:29 -0400, Mark Mielke wrote:

> Kernel may fail to boot or devices may fail to come up when
> initializing iscsi_tcp devices starting with Linux 5.8.
> 
> Marc Dionne identified the cause in RHBZ#1877345.
> 
> Commit a79af8a64d39 ("[SCSI] iscsi_tcp: use iscsi_conn_get_addr_param
> libiscsi function") introduced getpeername() within the session spinlock.
> 
> [...]

Applied to 5.9/scsi-fixes, thanks!

[1/1] scsi: iscsi: iscsi_tcp: Avoid holding spinlock while calling getpeername()
      https://git.kernel.org/mkp/scsi/c/bcf3a2953d36

-- 
Martin K. Petersen	Oracle Linux Engineering
