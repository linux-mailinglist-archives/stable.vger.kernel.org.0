Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABFD2C2C61
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 05:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbfJADte (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Sep 2019 23:49:34 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39112 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726590AbfJADtd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Sep 2019 23:49:33 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x913nHx1157299;
        Tue, 1 Oct 2019 03:49:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=o52ZS8bDMOxNE/hV3H09BNTrRlOTKrbZtQurBYCFd6g=;
 b=PPCXvtHHaMc42duGnj926pJUdf+XMoA03frMUZx2vPlCxJWJeBtQyplZhjFq41AN/pz7
 4OEMyaG4Eo3fm3ySoGOuBZ9Vm7lw+7G+Vg45FENK9dMQ18o4I9oOJFajRRDWr8Hu6BEB
 jct5HV7D/biI6UYMJq/vN61PPDn7VwDT7eCWL42YB9s/FCSKxXyTg6O/oVsi+27uwFZT
 Kq+x1K45XTmKY2Q4DckJyorAs65Mt8cmMP7aUTtpoACuWDu5GhHOAMMJxc3ZgZ4MILKU
 ZFkMPkafcoqEpTh1tOi1BnFVULBptqXGFBR9QIWTOytGV8dphJg8UVcE0D2QGJ3zrA9/ hw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2va05rjx7v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 03:49:30 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x913m170122355;
        Tue, 1 Oct 2019 03:49:30 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2vbsm15bg4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 03:49:29 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x913nSfA031680;
        Tue, 1 Oct 2019 03:49:29 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Sep 2019 20:49:28 -0700
To:     Steffen Maier <maier@linux.ibm.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Benjamin Block <bblock@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, stable@vger.kernel.org
Subject: Re: [PATCH] zfcp: fix reaction on bit error theshold notification with adapter close
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190924160616.15301-1-maier@linux.ibm.com>
Date:   Mon, 30 Sep 2019 23:49:26 -0400
In-Reply-To: <20190924160616.15301-1-maier@linux.ibm.com> (Steffen Maier's
        message of "Tue, 24 Sep 2019 18:06:16 +0200")
Message-ID: <yq1d0fhw2ex.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910010037
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910010037
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Steffen,

> Kernel message explanation:
>
>  * Description:
>  * The FCP channel reported that its bit error threshold has been exceeded.
>  * These errors might result from a problem with the physical components
>  * of the local fibre link into the FCP channel.
>  * The problem might be damage or malfunction of the cable or
>  * cable connection between the FCP channel and
>  * the adjacent fabric switch port or the point-to-point peer.
>  * Find details about the errors in the HBA trace for the FCP device.
>  * The zfcp device driver closed down the FCP device
>  * to limit the performance impact from possible I/O command timeouts.
>  * User action:
>  * Check for problems on the local fibre link, ensure that fibre optics are
>  * clean and functional, and all cables are properly plugged.
>  * After the repair action, you can manually recover the FCP device by
>  * writing "0" into its "failed" sysfs attribute.
>  * If recovery through sysfs is not possible, set the CHPID of the device
>  * offline and back online on the service element.

This commentary does not read like a patch description. It makes no
mention of the actual kernel changes and the introduced module
parameter.

> +static bool ber_stop = true;
> +module_param(ber_stop, bool, 0600);
> +MODULE_PARM_DESC(ber_stop,
> +		 "Shuts down FCP devices for FCP channels that report a bit-error count in excess of its threshold (default on)");
> +

-- 
Martin K. Petersen	Oracle Linux Engineering
