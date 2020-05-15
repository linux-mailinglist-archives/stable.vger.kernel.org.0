Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 992F61D42BB
	for <lists+stable@lfdr.de>; Fri, 15 May 2020 03:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgEOBKk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 21:10:40 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37152 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbgEOBKk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 May 2020 21:10:40 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04F13BTU130944;
        Fri, 15 May 2020 01:10:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=jxxby5iUD46yjAC399mm0IUPNoJCIBV3YoDAubY5aWk=;
 b=WpL+j7PDVHRMbo0q2ePpew+llQMO6OVc9IChPHEXUp47CL2/b/bxMpiFZuVx9494QvjI
 4S4dpLqvthTYOWAEgkHvM3Pg/zG/FuwxyPa905owbOb9/w1KVzXTln4XPXIJ5uGuMuBv
 MV4/uMmEOXHXrMwlEfwyYvsspbMTQedFmKvCR8udZE0mEZ4yT6fB0Mw86LRxRQkCELiB
 zjK6BTzpJVCqhqUHb8CGumGt9CptagWaLD5hTiXHj4jk2QEbpMURVgKCGm+0A1BeONvZ
 /zhvvwpTBRQRc97aiuv9sEzUHM+HqRzix3Hh0u6wneOd0h3YKyJCuirACoqERgJw5EUM Wg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 3100xwxp8x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 15 May 2020 01:10:33 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04F148KU003572;
        Fri, 15 May 2020 01:10:33 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 3100yhw4re-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 May 2020 01:10:32 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04F1AV3W013992;
        Fri, 15 May 2020 01:10:31 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 14 May 2020 18:10:31 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     mchristi@redhat.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, bly@catalogicsoftware.com,
        Bodo Stroesser <bstroesser@ts.fujitsu.com>, bvanassche@acm.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] scsi: target: put lun_ref at end of tmr processing
Date:   Thu, 14 May 2020 21:10:25 -0400
Message-Id: <158950481363.8120.6288768454257707610.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513153443.3554-1-bstroesser@ts.fujitsu.com>
References: <20200513153443.3554-1-bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 phishscore=0 suspectscore=0 adultscore=0 mlxscore=0 mlxlogscore=921
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005150007
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 cotscore=-2147483648 bulkscore=0
 phishscore=0 adultscore=0 mlxlogscore=950 lowpriorityscore=0
 impostorscore=0 spamscore=0 malwarescore=0 priorityscore=1501 mlxscore=0
 suspectscore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005150007
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 13 May 2020 17:34:43 +0200, Bodo Stroesser wrote:

> Testing with Loopback I found, that after a Loopback LUN
> has executed a TMR, I can no longer unlink the LUN.
> The rm command hangs in transport_clear_lun_ref() at
> wait_for_completion(&lun->lun_shutdown_comp)
> The reason is, that transport_lun_remove_cmd() is not
> called at the end of target_tmr_work().
> 
> [...]

Applied to 5.7/scsi-fixes, thanks!

[1/1] scsi: target: Put lun_ref at end of tmr processing
      https://git.kernel.org/mkp/scsi/c/f2e6b75f6ee8

-- 
Martin K. Petersen	Oracle Linux Engineering
