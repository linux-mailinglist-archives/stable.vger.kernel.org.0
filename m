Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E52AC696E23
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 20:53:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbjBNTxT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 14:53:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjBNTxS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 14:53:18 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D2D52BEE4;
        Tue, 14 Feb 2023 11:53:17 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31EJOmDA015789;
        Tue, 14 Feb 2023 19:53:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2022-7-12; bh=9LlWaIyNaSLYW1FYX8pm9CedPzVocLX1DAB2FoWtUBI=;
 b=JStmyd36xej5z0GwH+47lfDskzws9aTfUmK6mCgYMo1v5YspNTj9dq6oEtUuf3Bx8Ctj
 vpnh2BDJZJyJm07wo1lkv3vaWz4yfBN5SMOVAFXiC94+yvzFZndpLhVlEK4AEgS0VeCx
 ZdNJHY5Gd1YCWBh2lCEM1Vx5dmoTZE0FGB4IARn7WediOCLYT4agVbqI2cw8ugQdNRem
 /Wrf+CWFLf8occP5mO1Oap5bSh7299Zz0/lCj4PWKN5Ss51dnEbNELSOW1qB1QH7Yo1B
 92IvgkaHkLrmDNHFRzhqJavmj1wX+7gk/FzpJuKNViJmKaWfgabsXgr7hcx6oFMiyjJo 2g== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np1xb6f0x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Feb 2023 19:53:10 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31EIFsr3027129;
        Tue, 14 Feb 2023 19:53:09 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f62ynb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Feb 2023 19:53:09 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31EJr9fX039557;
        Tue, 14 Feb 2023 19:53:09 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3np1f62ymq-1;
        Tue, 14 Feb 2023 19:53:09 +0000
From:   Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
To:     stable@vger.kernel.org
Cc:     saeed.mirzamohammadi@oracle.com,
        Dan Williams <dan.j.williams@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Xiu Jianfeng <xiujianfeng@huawei.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH stable v5.15.y 0/1] crypto: add __init/__exit annotations to init/exit funcs
Date:   Tue, 14 Feb 2023 11:52:59 -0800
Message-Id: <20230214195300.2432989-1-saeed.mirzamohammadi@oracle.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-14_14,2023-02-14_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 mlxscore=0
 bulkscore=0 malwarescore=0 phishscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302140172
X-Proofpoint-ORIG-GUID: PygRXR2_Hod4427rmgp3sWj7NZHC-GaP
X-Proofpoint-GUID: PygRXR2_Hod4427rmgp3sWj7NZHC-GaP
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add missing patch in stable v5.15.y that fixes missing __init/__exit
macros for crypto algorithms.

Commit Data:
  commit-id        : 33837be33367172d66d1f2bd6964cc41448e6e7c
  subject          : crypto: add __init/__exit annotations to init/exit funcs
  author           : xiujianfeng@huawei.com
  author date      : 2022-09-15 03:36:15

Xiu Jianfeng (1):
  crypto: add __init/__exit annotations to init/exit funcs

 crypto/async_tx/raid6test.c | 4 ++--
 crypto/curve25519-generic.c | 4 ++--
 crypto/dh.c                 | 4 ++--
 crypto/ecdh.c               | 4 ++--
 crypto/ecdsa.c              | 4 ++--
 crypto/rsa.c                | 4 ++--
 crypto/sm2.c                | 4 ++--
 7 files changed, 14 insertions(+), 14 deletions(-)

-- 
2.39.1

