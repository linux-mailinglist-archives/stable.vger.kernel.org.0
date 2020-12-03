Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13FDD2CDFEF
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 21:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727307AbgLCUsA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 15:48:00 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:46630 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbgLCUsA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Dec 2020 15:48:00 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B3Kj8Ru030892;
        Thu, 3 Dec 2020 20:45:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=1LXP9D1+B9hUfYyzLOZtgb+vEzU/N5ctuPzRovVvNtU=;
 b=adNHtY5Dw7BRWavEq09fQxsusSS1HmYNQHluL3XKAl2nK4yJIuTzXdrvSNVoWY6IJUfE
 MtyMFUXdgczzoxTp6+AhbXxf2G0Di19f3LvDGzPJFHnWsPzGzOtq3F0YErEB1kWfn6eH
 zkRM4uvzOD9uoMMwh/bUppdeJc5HiBrHR4ewaTBAjQw0e1yKAApX7hvJ5msCdgJnskWC
 ylZWnWZjtVtnjKlFqSkBGC9ifXx7WwuyBNL7utJJyIX9m2bSCNxzSlAwfZj82M6UncVn
 2wTPYJIqYrWsmaixYWuHs2XU5vnYJrbkqdpPFf+qxQO4u+aMNhzaLX5FCBLtmO2RKp2c +Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 353c2b883v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 03 Dec 2020 20:45:08 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B3KdSLD029552;
        Thu, 3 Dec 2020 20:45:07 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 3540g2ds87-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Dec 2020 20:45:07 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B3Kj4ai031535;
        Thu, 3 Dec 2020 20:45:04 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Dec 2020 12:45:03 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Subbu Seetharaman <subbu.seetharaman@broadcom.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Thomas Lamprecht <t.lamprecht@proxmox.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        jejb@linux.ibm.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, stable@vger.kernel.org,
        jitendra.bhivare@broadcom.com, linux-scsi@vger.kernel.org,
        jayamohank@hdredirect-lb5-1afb6e2973825a56.elb.us-east-1.amazonaws.com,
        James.Bottomley@suse.de, ketan.mukadam@broadcom.com,
        Greg KH <greg@kroah.com>
Subject: Re: [PATCH] scsi: be2iscsi: revert "Fix a theoretical leak in beiscsi_create_eqs()"
Date:   Thu,  3 Dec 2020 15:45:01 -0500
Message-Id: <160702820882.27665.13232983618301808305.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <X8jXkt6eThjyVP1v@mwanda>
References: <X8jXkt6eThjyVP1v@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 phishscore=0 mlxlogscore=971 adultscore=0 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012030121
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 lowpriorityscore=0
 clxscore=1011 bulkscore=0 mlxlogscore=982 phishscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012030121
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 3 Dec 2020 15:18:26 +0300, Dan Carpenter wrote:

> My patch caused kernel Oopses and delays in boot.  Revert it.
> 
> The problem was that I moved the "mem->dma = paddr;" before the call to
> be_fill_queue().  But the first thing that the be_fill_queue() function
> does is memset the whole struct to zero which overwrites the assignment.

Added Cc: stable and applied to 5.10/scsi-fixes, thanks!

[1/1] scsi: be2iscsi: revert "Fix a theoretical leak in beiscsi_create_eqs()"
      https://git.kernel.org/mkp/scsi/c/eeaf06af6f87

-- 
Martin K. Petersen	Oracle Linux Engineering
