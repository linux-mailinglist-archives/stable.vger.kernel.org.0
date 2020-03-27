Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10139194E9B
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 02:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727607AbgC0BvB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 21:51:01 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:46504 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727122AbgC0BvA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Mar 2020 21:51:00 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02R1o3QK102384;
        Fri, 27 Mar 2020 01:50:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=3qGek2yKWQLijs+5JbpVCUiG2M8HpMlzKySDTcmY8YM=;
 b=kgeOGsuB5EhESLZic4SdXkd8oeZ+hhPTA2H8QZYOyiuVElVwjSIboUJEN1475BrSKkuz
 +pjdH8jzWyp7rbRfSOH0OhcE7FxL+k9iwK1VW7mGgKkUjStZaFiUkkNOGYiAQRfjwe69
 qo0Xbqzf7tGwmxN8+SbDBZ6DeNFM/mzmhc4SG5ai28dWyEh9GjTAKH1S8tKnR7vbpI6o
 ODVJ7QLmrAlVh/TbR+DAEJrolgw3eEnMSEKYZhtHY7A/mN6lh6OpKBAc15teXvrwp967
 1ikjVQaA8sdGC8aQr2qVw1hEtQ6Dz6Kdzzr4GfTUDsWaL+eTrGgK07R5bmjKqZp++bgd mg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 300urk3m79-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 01:50:55 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02R1oDsx166315;
        Fri, 27 Mar 2020 01:50:54 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 3006r9fskt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 01:50:54 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02R1ooWJ000698;
        Fri, 27 Mar 2020 01:50:52 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 26 Mar 2020 18:50:50 -0700
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     "Elliott\, Robert \(Servers\)" <elliott@hpe.com>,
        "martin.petersen\@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi\@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "sathya.prakash\@broadcom.com" <sathya.prakash@broadcom.com>,
        "suganath-prabu.subramani\@broadcom.com" 
        <suganath-prabu.subramani@broadcom.com>,
        "stable\@vger.kernel.org" <stable@vger.kernel.org>,
        "amit\@kernel.org" <amit@kernel.org>
Subject: Re: [PATCH] mpt3sas: Fix kernel panic observed on soft HBA unplug
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1583923013-3935-1-git-send-email-sreekanth.reddy@broadcom.com>
        <DF4PR8401MB12415ADC9760286F3930DBE4ABFB0@DF4PR8401MB1241.NAMPRD84.PROD.OUTLOOK.COM>
        <CAK=zhgqWJs+Wbmgy9xp6WDRp2w5e+5BGD+R5mck-dVh5oOUQ0g@mail.gmail.com>
Date:   Thu, 26 Mar 2020 21:50:47 -0400
In-Reply-To: <CAK=zhgqWJs+Wbmgy9xp6WDRp2w5e+5BGD+R5mck-dVh5oOUQ0g@mail.gmail.com>
        (Sreekanth Reddy's message of "Mon, 16 Mar 2020 11:45:15 +0530")
Message-ID: <yq1bloiftvs.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9572 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=0
 phishscore=0 spamscore=0 mlxscore=0 mlxlogscore=680 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003270012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9572 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=741 clxscore=1011 lowpriorityscore=0 mlxscore=0 phishscore=0
 bulkscore=0 impostorscore=0 adultscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003270012
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Sreekanth,

> In the unload path driver call sas_remove_host() API before releasing
> the resources. This sas_remove_host() API waits for all the
> outstanding IOs to be completed. So here, indirectly driver is waiting
> for the outstanding IOs to be processed before releasing the HBA
> resources.  So only in the cases where HBA is inaccessible (e.g. HBA
> unplug case), driver is flushing out the outstanding commands to avoid
> SCSI error handling over head and can quilkey complete the driver
> unload operation.

None of this is clear from the commit description. Please resubmit patch
with a new description clarifying why and when it is safe to drop
outstanding commands.

-- 
Martin K. Petersen	Oracle Linux Engineering
