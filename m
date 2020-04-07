Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA5621A12AE
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 19:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbgDGR1D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 13:27:03 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49434 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726395AbgDGR1D (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 13:27:03 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 037HHtdY138304;
        Tue, 7 Apr 2020 17:27:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=Hflc8Yn6RVcTCzZL4j6A4FyU9U4e1ddTCKHWNRk5ZeE=;
 b=S6ZVDuQlQ4OP+Sc8gny5SOHfgYEBK+yzAVnSTyR9xcjJTrqYZ6p7enQYySeKTCPoJbmU
 ErTs46CMAq0EAFHw6xItKroZgEe81fnj0gx+rlrCAz5a3v+293aAivL2m5QyU9np4D3O
 e557T2gfdro0QpPVNLWGiU6knKDhBvbhAzF65+KjVPEqM6eFYHFn36p6rZ54b0qvbmy3
 R5detjtfP03IxKkTzBzZdwaNIukZ393UoQYK0WUASbQch3mXaLc3RHa6STU+qZq2Ngn7
 XPVdQgCYMzrT5361POxew3fWfFZIF0lE/Ywv42xu+8cqFKjB+vpHn47GfUKWxnd0HX9v mA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 308ffdcemg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Apr 2020 17:27:00 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 037HHILR119991;
        Tue, 7 Apr 2020 17:27:00 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 3073qgpm7e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Apr 2020 17:27:00 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 037HQx10016269;
        Tue, 7 Apr 2020 17:26:59 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Apr 2020 10:26:58 -0700
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, stable@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] crypto: algapi - Avoid spurious modprobe on LOADED
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <20200407051744.GA13037@gondor.apana.org.au>
        <20200407060240.175837-1-ebiggers@kernel.org>
Date:   Tue, 07 Apr 2020 13:26:57 -0400
In-Reply-To: <20200407060240.175837-1-ebiggers@kernel.org> (Eric Biggers's
        message of "Mon, 6 Apr 2020 23:02:40 -0700")
Message-ID: <yq1eesz2om6.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9584 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 mlxlogscore=999
 spamscore=0 bulkscore=0 adultscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004070141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9584 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 priorityscore=1501
 impostorscore=0 malwarescore=0 mlxlogscore=999 lowpriorityscore=0
 clxscore=1011 phishscore=0 mlxscore=0 bulkscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004070141
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Eric,

> Currently after any algorithm is registered and tested, there's an
> unnecessary request_module("cryptomgr") even if it's already loaded.
> Also, CRYPTO_MSG_ALG_LOADED is sent twice, and thus if the algorithm
> is "crct10dif", lib/crc-t10dif.c replaces the tfm twice rather than
> once.
>
> This occurs because CRYPTO_MSG_ALG_LOADED is sent using
> crypto_probing_notify(), which tries to load "cryptomgr" if the
> notification is not handled (NOTIFY_DONE).  This doesn't make sense
> because "cryptomgr" doesn't handle this notification.
>
> Fix this by using crypto_notify() instead of crypto_probing_notify().

Looks good to me.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
