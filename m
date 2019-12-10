Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75E1E117C54
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 01:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727213AbfLJAU2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Dec 2019 19:20:28 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:34532 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726495AbfLJAU2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Dec 2019 19:20:28 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBA0Jxh4042662;
        Tue, 10 Dec 2019 00:20:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=OJnuPzQPoF0iS8DMzJ45Sw9F6y/joxKrLx/oNp/5Hpo=;
 b=a7h1fBQES5SQqfSEgNA6wAzwKiSS9yj0CM4m1+dGALBGv8k7ZwXPSPMGpd5xOANxGvZj
 otfkE86Z67BPWvE6anzefaaFaXcBDcfOQ1qgPJYHBNUIdRua4s+O7JpxCu7jco3uQ8lK
 CDU9O67paPPJeS+XhEO5VZ6Hd6bY8lYA7+yc0nF3tho+hp8sC+IyONKUUlLl4ydIGsFR
 c4XjEvWtTuRgYSatrfe7YxHQA4PaBNUormwIaLlyxq59TSIJ+WLL0eg90WyfRH2LrhIS
 z/5pP4itds+eIr3PLRxDuBhuNcEfSivr9kUtZoHjnDh8J5LRsZvZb20pzR1qiDcWZGGb FA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2wr41q2xv8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Dec 2019 00:20:11 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBA0Icxu089858;
        Tue, 10 Dec 2019 00:20:11 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2wsru8483x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Dec 2019 00:20:11 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBA0K9K0002069;
        Tue, 10 Dec 2019 00:20:09 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 09 Dec 2019 16:20:08 -0800
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <keith.busch@intel.com>,
        Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] iscsi: Fix a potential deadlock in the timeout handler
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191209173457.187370-1-bvanassche@acm.org>
Date:   Mon, 09 Dec 2019 19:20:06 -0500
In-Reply-To: <20191209173457.187370-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Mon, 9 Dec 2019 09:34:57 -0800")
Message-ID: <yq136dtowuh.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9466 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=687
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912100001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9466 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=752 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912100001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Bart,

> Some time ago the block layer was modified such that timeout handlers
> are called from thread context instead of interrupt context. Make it
> safe to run the iSCSI timeout handler in thread context. This patch
> fixes the following lockdep complaint:

Applied to 5.5/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
