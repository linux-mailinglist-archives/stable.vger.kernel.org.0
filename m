Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0B6962E421
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 19:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235002AbiKQS2o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Nov 2022 13:28:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240288AbiKQS2n (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Nov 2022 13:28:43 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FA22697F5;
        Thu, 17 Nov 2022 10:28:39 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AHGxX39019741;
        Thu, 17 Nov 2022 18:28:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=+4owGTGRmhSdZ2ecuhihdvRvYEiDoPPqpPmps9xlO8Q=;
 b=xYbBQP0r1w/fxFVrLmeD3SdyXjLjMyaqqU0BWZJ3hvKr2DFTodWyXNa6Xz3IM9zHth13
 VOZw93FGS7md4oO2DvUaoQxJVI+3iG8kNCtTrd2/elF71YTlG8SkWesm3PHeRdfAp1db
 LVbNsEeLBxq0zxpSd7k7mw6WoiPvU4JPU7KFIgLya84b3f67+Ltg47I/9UpQWqJsEcNX
 fXFtE++S6vteZC0w/xg/kxNSSIoeT72cYIEp/cba2xksQsogBUqioorcnjIIl6Xo9xwp
 JSoxqo8Btld62y5n1wO3dm5rd/qanpDH34aXpjAlJn5IHwC1CNmXSNjsSrcoWb2/iH9U 4g== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kwryb896r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Nov 2022 18:28:38 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AHH95ct008712;
        Thu, 17 Nov 2022 18:28:37 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kt1xft5q4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Nov 2022 18:28:37 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AHISano025586;
        Thu, 17 Nov 2022 18:28:36 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3kt1xft5pj-1;
        Thu, 17 Nov 2022 18:28:36 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Steffen Maier <maier@linux.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Vasily Gorbik <gor@linux.ibm.com>, linux-scsi@vger.kernel.org,
        stable@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
        Fedor Loshakov <loshakov@linux.ibm.com>,
        linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>
Subject: Re: [PATCH] zfcp: fix double free of fsf request when qdio send fails
Date:   Thu, 17 Nov 2022 13:28:31 -0500
Message-Id: <166870940540.1572108.9327933975941507142.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <979f6e6019d15f91ba56182f1aaf68d61bf37fc6.1668595505.git.bblock@linux.ibm.com>
References: <979f6e6019d15f91ba56182f1aaf68d61bf37fc6.1668595505.git.bblock@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-17_06,2022-11-17_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=906 bulkscore=0 mlxscore=0
 phishscore=0 suspectscore=0 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211170133
X-Proofpoint-ORIG-GUID: CYHgXcS4xGL3TriDD0Sz5eB3oTjB5vwp
X-Proofpoint-GUID: CYHgXcS4xGL3TriDD0Sz5eB3oTjB5vwp
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 16 Nov 2022 11:50:37 +0100, Benjamin Block wrote:

> We used to use the wrong type of integer in `zfcp_fsf_req_send()` to
> cache the FSF request ID when sending a new FSF request. This is used in
> case the sending fails and we need to remove the request from our
> internal hash table again (so we don't keep an invalid reference and use
> it when we free the request again).
> 
> In `zfcp_fsf_req_send()` we used to cache the ID as `int` (signed and 32
> bit wide), but the rest of the zfcp code (and the firmware
> specification) handles the ID as `unsigned long`/`u64` (unsigned and 64
> bit wide [s390x ELF ABI]).
>     For one this has the obvious problem that when the ID grows past 32
> bit (this can happen reasonably fast) it is truncated to 32 bit when
> storing it in the cache variable and so doesn't match the original ID
> anymore.
>     The second less obvious problem is that even when the original ID
> has not yet grown past 32 bit, as soon as the 32nd bit is set in the
> original ID (0x80000000 = 2'147'483'648) we will have a mismatch when we
> cast it back to `unsigned long`. As the cached variable is of a signed
> type, the compiler will choose a sign-extending instruction to
> load the 32 bit variable into a 64 bit register (e.g.:
> `lgf %r11,188(%r15)`). So once we pass the cached variable into
> `zfcp_reqlist_find_rm()` to remove the request again all the leading
> zeros will be flipped to ones to extend the sign and won't match the
> original ID anymore (this has been observed in practice).
> 
> [...]

Applied to 6.1/scsi-fixes, thanks!

[1/1] zfcp: fix double free of fsf request when qdio send fails
      https://git.kernel.org/mkp/scsi/c/0954256e970e

-- 
Martin K. Petersen	Oracle Linux Engineering
