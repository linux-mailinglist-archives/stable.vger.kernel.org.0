Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60BC014AE8E
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 05:01:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbgA1EB6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jan 2020 23:01:58 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:60474 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbgA1EB6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jan 2020 23:01:58 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00S3wP94021844;
        Tue, 28 Jan 2020 04:01:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=wz1uyWVuaoGCiEtAAcmsHnf7wTGKERqkCKMvoQYeZUE=;
 b=fde3CnQ9Xw95GXGAAvdMuZ0eATYkxgLVitIJ3h4Hsnq1ht3Uz3MvdF47NaQ6lYmnI3Ia
 ZkGTMFcXp+q759vjP1Wgcy6pS8k0QjzLQunTRo6RZYKxbrYQj8wp8y9qBMviYfprGD4k
 G2mCjEBDUcYkf09uELUJirx5vKpp+xZlfplVRRnYTLjgITJ0YAOld31/cX4+2r0YaLpe
 LpY7TWyUN2rCToRui7ciT0NBY65tJ0heeQ8KpkWZtHzm+oWZIE6Y1wEnBxIVSQ30f5MH
 p2FQoI6NH0bn/ArT9Y22GLeq98L6/J/WzVyhtpnKRFA4gqG/k9YUfLTVVfdc9EVPZWNN lA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2xrd3u3fn2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jan 2020 04:01:55 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00S3wTge076042;
        Tue, 28 Jan 2020 04:01:55 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2xryuasdmm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jan 2020 04:01:54 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00S41rNu023356;
        Tue, 28 Jan 2020 04:01:53 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Jan 2020 20:01:52 -0800
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     Masato Suzuki <masato.suzuki@wdc.com>,
        "stable\@vger.kernel.org" <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-scsi\@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] sd: Fix REQ_OP_ZONE_REPORT completion handling
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200127050746.136440-1-masato.suzuki@wdc.com>
        <BYAPR04MB5816781F4588054DF9C31380E70B0@BYAPR04MB5816.namprd04.prod.outlook.com>
Date:   Mon, 27 Jan 2020 23:01:50 -0500
In-Reply-To: <BYAPR04MB5816781F4588054DF9C31380E70B0@BYAPR04MB5816.namprd04.prod.outlook.com>
        (Damien Le Moal's message of "Mon, 27 Jan 2020 05:58:05 +0000")
Message-ID: <yq1k15c9qkx.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9513 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001280030
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9513 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001280030
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Damien,

>> Fixes: 89d947561077 ("sd: Implement support for ZBC devices")
>> Cc: <stable@vger.kernel.org> # 4.19
>> Cc: <stable@vger.kernel.org> # 4.14
>> Signed-off-by: Masato Suzuki <masato.suzuki@wdc.com>
>
> This bug exists since the beginning of SMR support in 4.10, until report
> zones was changed to a device file method in kernel 4.20. It fell through
> the cracks the entire time and was caught only recently with improvements
> to our test suite.

Looks good to me. Obviously only applies to stable since, as you point
out, this code has been substantially reworked.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
