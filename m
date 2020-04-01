Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF2119A36E
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 04:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731625AbgDACEs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 22:04:48 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56194 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731523AbgDACEs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Mar 2020 22:04:48 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03122txX156617;
        Wed, 1 Apr 2020 02:04:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=KYZQADMy6iUAntv77AmPcrVeURMPecIbQPhgJFkoyfo=;
 b=myc0+X7Qt80zJkYphDgC1FywX5gxWwTJJmSwOSj3e03O0UXO9A69UuD/UgYHsLaYeKfu
 d7D14GygBuFUVZZw4tXdiTpLXzhV2cvSAuOymXQYY1EGEV/cxRj4QFfpKsEG25hGADmS
 cRQnX6SU5+oRBEUxL2zD2TVVNkIEtbrz1WTXzS+6i7xzeE1xrpQDMjtFofEH2vLobT27
 c7qK1KDqZVPklI1yoc5sPGz4N+kkFNtBmGullqELARNTL0tzI+PrGoGTYvIid+i+xS+W
 /Wn1tmgdREU8b6NmG79Pjeg2KhZ0fUWdiiPG87mHlbm6gbZfLcp+KQQFHd5zpoQ6vfeE rQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 303aqhk7n3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Apr 2020 02:04:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03122DXa089557;
        Wed, 1 Apr 2020 02:04:43 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 302g4sne1p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Apr 2020 02:04:43 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03124hrn029791;
        Wed, 1 Apr 2020 02:04:43 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Mar 2020 19:04:42 -0700
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        sathya.prakash@broadcom.com, suganath-prabu.subramani@broadcom.com,
        stable@vger.kernel.org, amit@kernel.org
Subject: Re: [PATCH v2] mpt3sas: Fix kernel panic observed on soft HBA unplug
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1585302763-23007-1-git-send-email-sreekanth.reddy@broadcom.com>
Date:   Tue, 31 Mar 2020 22:04:40 -0400
In-Reply-To: <1585302763-23007-1-git-send-email-sreekanth.reddy@broadcom.com>
        (Sreekanth Reddy's message of "Fri, 27 Mar 2020 05:52:43 -0400")
Message-ID: <yq1d08s6jwn.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9577 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 spamscore=0 malwarescore=0 mlxlogscore=809 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004010017
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9577 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 mlxlogscore=885 spamscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004010017
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Sreekanth,

> Generic protection fault type kernel panic is observed when user
> performs soft(ordered) HBA unplug operation while IOs are running
> on drives connected to HBA.

Applied to 5.7/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
