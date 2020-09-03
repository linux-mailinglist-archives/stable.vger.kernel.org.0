Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5199725B908
	for <lists+stable@lfdr.de>; Thu,  3 Sep 2020 05:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgICDDW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 23:03:22 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49314 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726528AbgICDDW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Sep 2020 23:03:22 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08330smq122707;
        Thu, 3 Sep 2020 03:03:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=lzHCMLAJKT0OGaXfhj6KuXZd8UEwzAzFfn9ZZO+GkdE=;
 b=nr71cf4E6w8PhaZZzlNUafRb1scgDOsaJVMAmQmotnKriH0sqYl6QD4593wThUCiCqmn
 jmbRtEx5OT4j444O8KQhWFbA22LlxZF+46Ted0fWJg3KFuqhGhG36IEQfBQtxvtb0U8A
 E7c190jT/uDNJs5wn28QSc6RibdsX7aUsX38tcnkOl0fKCTR66CADkS3pEAI8av+1RXH
 SBV/TSOUyPklbk26eQ2VsfUzf3cKP4I51d5ifNeVSp85BsSMjQDGNOmD/+3io2D398yH
 xzDxSJT0BSQZV/vnIywkY0rvWTzKoFNuszhZUXIr6iK3WWHiDFlAyEPvUNHJPlVfgayc NQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 337eyme4mk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 03 Sep 2020 03:03:17 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0832t5wM060086;
        Thu, 3 Sep 2020 03:01:16 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 3380sv5y3s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Sep 2020 03:01:16 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08331E0M031544;
        Thu, 3 Sep 2020 03:01:15 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Sep 2020 20:01:14 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Varun Prakash <varun@chelsio.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, bvanassche@acm.org,
        stable@vger.kernel.org, michael.christie@oracle.com,
        nab@linux-iscsi.org, target-devel@vger.kernel.org
Subject: Re: [PATCH] scsi: target: iscsi: Fix data digest calculation
Date:   Wed,  2 Sep 2020 23:01:05 -0400
Message-Id: <159910202092.23499.16081491903720380193.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <1598358910-3052-1-git-send-email-varun@chelsio.com>
References: <1598358910-3052-1-git-send-email-varun@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=948 adultscore=0
 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009030027
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=961 mlxscore=0
 lowpriorityscore=0 clxscore=1011 spamscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009030027
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 25 Aug 2020 18:05:10 +0530, Varun Prakash wrote:

> Current code does not consider 'page_off' in data digest
> calculation, to fix this add a local variable 'first_sg' and
> set first_sg.offset to sg->offset + page_off.

Applied to 5.9/scsi-fixes, thanks!

[1/1] scsi: target: iscsi: Fix data digest calculation
      https://git.kernel.org/mkp/scsi/c/5528d03183fe

-- 
Martin K. Petersen	Oracle Linux Engineering
