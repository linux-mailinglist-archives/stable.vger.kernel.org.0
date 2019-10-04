Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93076CB324
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 03:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730466AbfJDBsC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 21:48:02 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40842 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729789AbfJDBsB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Oct 2019 21:48:01 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x941kTam004248;
        Fri, 4 Oct 2019 01:47:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=ZjhteXT3OwBVTPu4mrAsamQ4K3g8uYi1qeGqXEEBBGg=;
 b=eg9Z7h0yDpUcopOfh4TdRZT/FLWspWIw35FKy9zsOWPSaPj4N5jlhbliFcv1sfLaBJs+
 c1mz1HhQl6+O5w2Qy3oRPtoNa3Arxt/uCJ8L7ITE5PbXGQSizkyFnJTf6EuaV+OfSF/3
 9rYC4oWM+IjEZ33oNqlrwvg1UNx84EMeuMKlSu3JY0HUXk5zaspD4BnchkmHq5P/OmFd
 tTru/dSE0wWNoHUb7DQVljd2zMplCp59vJHmwVoRiESNZ+pT7ykFwMqEurTiihaYXZbw
 UsPn0c/grWaEy/oEEOvg5a2FV1MzvRVewn4hNZwFF3sBUVVQxPlXeZw2oGbJ99CxxGi2 Yw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2v9yfqr4rt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Oct 2019 01:47:57 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x941ijGJ099249;
        Fri, 4 Oct 2019 01:47:56 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2vdn18kgpb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Oct 2019 01:47:56 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x941lsYj017718;
        Fri, 4 Oct 2019 01:47:54 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Oct 2019 18:47:53 -0700
To:     Steffen Maier <maier@linux.ibm.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Benjamin Block <bblock@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] zfcp: fix reaction on bit error theshold notification with adapter close
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <yq1d0fhw2ex.fsf@oracle.com>
        <20191001104949.42810-1-maier@linux.ibm.com>
        <20191001141408.GB3129841@kroah.com>
        <71b8fc68-23a8-a591-1018-f290d6e3312a@linux.ibm.com>
        <20191001154208.GB3523275@kroah.com> <yq1tv8stj87.fsf@oracle.com>
        <c0a921a4-f529-03cd-b39c-24c5f25f8b44@linux.ibm.com>
Date:   Thu, 03 Oct 2019 21:47:50 -0400
In-Reply-To: <c0a921a4-f529-03cd-b39c-24c5f25f8b44@linux.ibm.com> (Steffen
        Maier's message of "Wed, 2 Oct 2019 10:31:01 +0200")
Message-ID: <yq1pnjds2m1.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9399 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=500
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910040011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9399 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=580 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910040011
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Steffen,

>> Why not just shut FCP down unconditionally on excessive bit errors?
>> What's the benefit of allowing things to continue? Are you hoping things
>> will eventually recover in a single-path scenario?
>
> Experience told me that there will be an unforeseen end user scenario
> where I need a quick switch to let even shaky paths survive.

Can't say I like it. But it's your driver.

Applied to 5.4/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
