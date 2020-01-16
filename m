Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 815C213D305
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 05:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729110AbgAPEG3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jan 2020 23:06:29 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:57878 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729048AbgAPEG2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jan 2020 23:06:28 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G3xQ1v124597;
        Thu, 16 Jan 2020 04:01:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=uKDNCB63FyMaskGVot3YarGxZwgjqh7FukgNd7alg8A=;
 b=LI85uRZyi8UFbncNHRWnlG+OHXGlk5Mcl50KED7wwNhWSv8KS838yoDQCbtqIw/CG+CQ
 81qjagYHkmFAvfbezJ3/7ZrmnHG9wtxFs6yObz9/ps7EPtU4AbcxKfQbIkKE+u9qhBr+
 gJvzNck2qf1jaWQmEkH/8uizlS50FWHBJe0UY4ps6FeJSt0ZGcp3ssQp5OsGQ0Pb311l
 N8yFMFkvO+avJY/lZOotuMy8Mj9itZhbzsiAOd4RUSegNJ8PSh6xXWhjejmGp8CoOyRX
 SQ02dQ1Yg+UPssyrMyUJuDBHjMuohvp+acCo9kiUOFJQUs62VHely7XWsZQ642yG0Xk0 nQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2xf73yr1tg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 04:01:47 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G3wWa8175503;
        Thu, 16 Jan 2020 04:01:46 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2xj61kusae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 04:01:46 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00G41Z9l011886;
        Thu, 16 Jan 2020 04:01:35 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jan 2020 20:01:34 -0800
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Satish Kharat <satishkh@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Oleksandr Natalenko <oleksandr@redhat.com>,
        stable@vger.kernel.org, Joe Eykholt <jeykholt@cisco.com>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Abhijeet Joglekar <abjoglek@cisco.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Colin Ian King <colin.king@canonical.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fnic: fix invalid stack access
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200107201602.4096790-1-arnd@arndb.de>
Date:   Wed, 15 Jan 2020 23:01:31 -0500
In-Reply-To: <20200107201602.4096790-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Tue, 7 Jan 2020 21:15:49 +0100")
Message-ID: <yq1lfq8nj6s.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=920
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001160031
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=971 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001160031
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Arnd,

> gcc -O3 warns that some local variables are not properly initialized:
>
> drivers/scsi/fnic/vnic_dev.c: In function 'fnic_dev_hang_notify':
> drivers/scsi/fnic/vnic_dev.c:511:16: error: 'a0' is used uninitialized
> in this function [-Werror=uninitialized] vdev->args[0] = *a0;

Applied to 5.5/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
