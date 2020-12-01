Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B80482C9765
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 07:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725945AbgLAGHQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 01:07:16 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:50414 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725859AbgLAGHQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Dec 2020 01:07:16 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B164une032756;
        Tue, 1 Dec 2020 06:06:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Q9uKMxCrUUNPymmd9mpaetni5jFgnpSUaYc8KT09e6Y=;
 b=GZdWd96e9pIopaIfGn3PUBR7/Bi6Zkpjy3ADBh46GNoc6SnFsD5d5Y/LFSFXBK1TwONN
 qi8qYsjd0jsUav+EfzO7Aff44egheqBKe0pFiR6l9Ob39FoDjHlWdW3oWiX8Bi0/LDtj
 KS/jAfwpanGPVESgwICCKa66L1jgOkLXRDj2tDml8Hh/le+VNgTgy+xmHNoJ/bBFmLhk
 kvAhYtl6u4lI/Uf4q32Sdrk1xIqQjkyILOznGmOR+I4q7CLe/AFmD+QoQ4qvem0grX/+
 RoXoMLez6zKdkjNnm85UV+nlS05U9M6QiUX4CEgy6T/iMNfDgqOIzPrXLkVzW8JzzlNv 4A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 353egkgr3d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Dec 2020 06:06:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B166LBX147137;
        Tue, 1 Dec 2020 06:06:31 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 3540arr6p4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Dec 2020 06:06:31 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B166Uoo011803;
        Tue, 1 Dec 2020 06:06:30 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Nov 2020 22:06:30 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     stable@vger.kernel.org,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com
Subject: Re: [PATCH] mpt3sas: Fix timeout issue in ioctl commands.
Date:   Tue,  1 Dec 2020 01:06:26 -0500
Message-Id: <160680263440.25762.6562939673076560027.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201125094838.4340-1-suganath-prabu.subramani@broadcom.com>
References: <20201125094838.4340-1-suganath-prabu.subramani@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010041
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1011 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010041
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 25 Nov 2020 15:18:38 +0530, Suganath Prabu S wrote:

> Description of issue:
> Patch with commit id "c1a6c5ac4278d406c112cc2f038e6e506feadff9"
> has modified ioctl path 'timeout' variable type to u8 from
> unsigned long. With this maximum timeout value that the driver
> can support is 255 seconds. But for some commands application is
> providing the higher timeout value (512 seconds as default), so
> it will be round off to zero value. Hence timeout is observed
> immediately and the IOCTL request fails.
> 
> [...]

Applied to 5.10/scsi-fixes, thanks!

[1/1] mpt3sas: Fix timeout issue in ioctl commands.
      https://git.kernel.org/mkp/scsi/c/42f687038bcc

-- 
Martin K. Petersen	Oracle Linux Engineering
