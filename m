Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0C7D174538
	for <lists+stable@lfdr.de>; Sat, 29 Feb 2020 06:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbgB2F2b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Feb 2020 00:28:31 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:49546 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgB2F2b (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Feb 2020 00:28:31 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01T5SRC6082863;
        Sat, 29 Feb 2020 05:28:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=6VapVng/jtzoDQPMgdcK8bwRNBxxrgyEhGau0mbGViI=;
 b=ccp5IsqX7mGbdC2dkj9IYTM/goL+uPqohBcvoezWQJRSedd22btzbndCqUjTGTM2JDEP
 q6WotnvzEYoovelAaOVO9fNfwjYg0nfznMjZvX8Z0JNxgHsSZBGTne0h3xmMQjY4T6wS
 s9Xpk8tO+Oh35yt1j7rot1U/EGO6o8Mc7fogdfaagTy49800fCk+GTuNhmQJSbnGa08A
 80nju6YQla/4D+3lkt4hf5ryEN1ku0/qp0ueG/7AqZM1Fva2TccQzoOicXizeWcqtZc8
 KxZ43vxktFjzRLtL4BcsOXBtct/kIp8n8+bQHrdSaENEzg2/gVneEruTJnUwIV7VI92g Sg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2yffcu07uu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 29 Feb 2020 05:28:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01T5IYJW075190;
        Sat, 29 Feb 2020 05:26:27 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2yff9ngyyq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 29 Feb 2020 05:26:27 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01T5QPsX029330;
        Sat, 29 Feb 2020 05:26:25 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Feb 2020 21:26:25 -0800
To:     Sagar Biradar <Sagar.Biradar@microchip.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi <linux-scsi@vger.kernel.org>, <aacraid@microsemi.com>,
        Scott Benesh <scott.benesh@microsemi.com>,
        Brian King <brking@linux.vnet.ibm.com>,
        <stable@vger.kernel.org>, Balsundar P <balsundar.p@microsemi.com>
Subject: Re: [PATCH] aacraid: Disabling TM path and only processing IOP reset
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1581553771-25796-1-git-send-email-Sagar.Biradar@microchip.com>
Date:   Sat, 29 Feb 2020 00:26:22 -0500
In-Reply-To: <1581553771-25796-1-git-send-email-Sagar.Biradar@microchip.com>
        (Sagar Biradar's message of "Wed, 12 Feb 2020 16:29:31 -0800")
Message-ID: <yq1sgiu3qwx.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 suspectscore=0
 malwarescore=0 phishscore=0 mlxscore=0 mlxlogscore=973 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002290037
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 adultscore=0 suspectscore=0 spamscore=0 malwarescore=0 impostorscore=0
 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002290037
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Sagar,

> Fixes the occasional adapter panic when sg_reset is issued with -d,
> -t, -b and -H flags.  Removal of command type HBA_IU_TYPE_SCSI_TM_REQ
> in aac_hba_send since iu_type, request_id and fib_flags are not
> populated.  Device and target reset handlers made to send TMF commands
> only when reset_state is 0.

Applied to 5.7/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
