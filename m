Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE9C4ECF30
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 23:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343980AbiC3VzK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 17:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344614AbiC3VzJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 17:55:09 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F97415FED;
        Wed, 30 Mar 2022 14:53:23 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22ULUf1O030446;
        Wed, 30 Mar 2022 21:53:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=gfE9HxwdfnxCj/hzPSNMwEoK+pBiJrRrtfdPHjR4KJE=;
 b=lfYkgxs+LO5ZQ/2z/3TG9/l2So5BWZmhrnwPk/6OSE/Hqz+2V04EJyMnEyM2HLULf+Jr
 LsKjqNXuVyOFPglUYe7pzxrxc3gJuvy4e8V/5VfN7W9O7oBmRf50IHMYVCg75kYbKP3U
 wSGjNM3vvkLSxQ5RVRqqhhA0ogzRerkMawCYSGWjWBf+NeHhstynjv+lmq9BEzjpayRx
 KWuPMeJenF1eaE1+VVgUF3Bl2XV0IyQKWCuPlqoI0ncYkHaKhEIP6SpJTwwhM2b/16ai
 BGhAijrgXK97sfCW5etUNjv3jvkaWzg6y0RsJ5CSpSo5IVzfKEJy+jHigYZ3fVaeZAIJ BA== 
Received: from aserp3030.oracle.com ([141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f1se0js3y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Mar 2022 21:53:15 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22ULl2MN050760;
        Wed, 30 Mar 2022 21:53:14 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2045.outbound.protection.outlook.com [104.47.73.45])
        by aserp3030.oracle.com with ESMTP id 3f1rv8ftkk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Mar 2022 21:53:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y+WVjt8Wk729DP6YabbqqpmZscyEmqnNSMbTyC6hT4oh3otNLoxDESiBV7pIr95kIAfVbaghDBDK/f/oDNHeGnyXVmxfL/3Xd1QMWzmIPTQz/FOqN6lP2KAB/BKjvRFOCvxWJAc+8KuxmS6KchEB7WmNJqNjC5IZd2YK+4dmUjj5cmHlXW1iAArFAp9qqOwiRVDPJ8vYtYKcOqwSaUqBwZj11AaMhVfN/3S4uXpnbeq/qVKW6u0XKv1vJJD6f380oE28PIqjnLZ24WdO+z98ng+bBMMbrZ401SGNg6pToG4KWBuO268KRM4toHktDNAJIHzRof7K2+UiyotoBNr1/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gfE9HxwdfnxCj/hzPSNMwEoK+pBiJrRrtfdPHjR4KJE=;
 b=ZOA6VVyHjrm5C6oxexFxRLnNrspPTP8VRrSukHWUosTC3LpP36zlNDXmPhPOALqjQJvpioyYONdySyuudfxUMkLgXDy+La/62bUZmJrLjEoMFNm6gWqfsWgXIkCNjFrCdX318pCWSV4utrdII/NCWxdvPBlnNlwJUm8+gzAzO74dqRgGJ3VFpTUQWS0rjJwlZN8oKY2qVic2cHdJ7OxVL8GwVD/oiia3C5O8NdBC20idGzowrXZ+S9eyj+nxuMD6egv/SVSmMbOVhcUM5Ddr4+Zh3YCOcprTje3TcMbj+9S+MmFEALz2WFLR33Kjm8/jjsdR3ZYSqdoJBSOieblLWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gfE9HxwdfnxCj/hzPSNMwEoK+pBiJrRrtfdPHjR4KJE=;
 b=O+dkGK6BecrENLxN8kL15Nz6FVA5/FYXRgIIdYCRXB2+RKBESrmpij/pA1AvWUnQHWaVH0wckKH8maZvpxghVCiQU8YcuUXEcseHMr4izM1W73xcmt0ehixTd5lY/R84fxwMy7G4b0Xk0WjC/WFRh8yrzAjxsi1h+CrUTAdIDz8=
Received: from CH0PR10MB5113.namprd10.prod.outlook.com (2603:10b6:610:c9::8)
 by SN6PR10MB2702.namprd10.prod.outlook.com (2603:10b6:805:48::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.19; Wed, 30 Mar
 2022 21:53:12 +0000
Received: from CH0PR10MB5113.namprd10.prod.outlook.com
 ([fe80::a8c2:7a0b:5845:1675]) by CH0PR10MB5113.namprd10.prod.outlook.com
 ([fe80::a8c2:7a0b:5845:1675%6]) with mapi id 15.20.5123.020; Wed, 30 Mar 2022
 21:53:12 +0000
From:   Sidhartha Kumar <sidhartha.kumar@oracle.com>
To:     shuah@kernel.org, akpm@linux-foundation.org
Cc:     Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] selftest/vm: clarify error statement in gup_test
Date:   Wed, 30 Mar 2022 21:52:57 +0000
Message-Id: <20220330215257.112029-1-sidhartha.kumar@oracle.com>
X-Mailer: git-send-email 2.24.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0401CA0041.namprd04.prod.outlook.com
 (2603:10b6:803:2a::27) To CH0PR10MB5113.namprd10.prod.outlook.com
 (2603:10b6:610:c9::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e3059185-b0bf-4d5b-570c-08da1297afb9
X-MS-TrafficTypeDiagnostic: SN6PR10MB2702:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB2702727CFCFE48E661CB607D951F9@SN6PR10MB2702.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KJdwd3KgkyhOJhroaOcZYyCkCoaKvgRuLKZY9n1WaK/CdJj6HFEzYa2a9tbqnwYGP+klD3Mrad0i06HDQPgXE1a2TSXlphdnMJvf99iiQ4+FEKqoxJndltFC7Kp1WiZYep73u8QOQxPKWF4WtZM3SH6cGO0OpfjjtpKUi1hPl8cIzRojuNnfLzEH530UP3ye7wBWBbgqUsRZx7sOV626t4NrKPVA0KjD5ZM/LyR7sjgwTQYyUkF4Go8ihz8WRjgIf0CRkAXx2OcPV22VZXnQ6yFZoFmRaYrAv3ID6OEL93mss8RxM7YtVY987k45EBYDRCkuOevr+p75BYShoWf+zSXQ62akqhiAtgW5t76j0YGvtzVKdUZ1Z0mTQPoI3x/DHv91U1dxDii730J0XZ0cCcYeepJdcJxjBERBTxCIubLHKE+z2QHN7zUUnvw2QpMR+H58kzNYnDqcxapc+mFJeq9f6un8Nkby8Ld+x3XJHExWvCaOOwraGaYHr75GywA5RVH/V5YeDsMv4FSEgm5hbF3sGOrHvOQDShV74e1xuVxStnsELKlrIQrjNsfJBhwYzj6fuYmV9E6H91Qv8WQz7BUMs0rUGQLxxlz52GcE9UmN4BfJGsTpIBXMhbtCNphKfKVUd2N31NbRqMWpWCDi6P9HIX9qgACmvpN/dYrFHh2aLWyvJz7biixE6S51wZUqW+8J9tqMxgbjGXL5xyr0Mw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5113.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(186003)(26005)(8936002)(83380400001)(1076003)(6486002)(508600001)(36756003)(6666004)(66476007)(316002)(8676002)(66556008)(2616005)(38100700002)(6506007)(44832011)(4744005)(52116002)(2906002)(66946007)(4326008)(86362001)(6512007)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?g9RHHRWfB1XaotkPFPqa3Tc/E7IswmZUNeQj+r3tBqCJ8BQ66j5PBgyJqNsY?=
 =?us-ascii?Q?kydKO+VZt6CxfR1DRe2353SsoePsgOp+h7Zm9RlczOOW35OfQf83i0YHJTlo?=
 =?us-ascii?Q?t2Iqk65IB3yLIJ5oyEEDTXXjQLrhfiKv/bWZ+NbIxwWhCAYT9o5v9yiXxrmR?=
 =?us-ascii?Q?lnH+RN36qoYKEDBUMlJ2MLLVynzkj5/u4ZdK/r/0tBO81r0fwrIP3gvfP0Y4?=
 =?us-ascii?Q?CqzNP+rI9TVxMIsOrAgf1FwuaFWDHPHxt6/SH+aDbufzCLbMdd/mrqVnb1kQ?=
 =?us-ascii?Q?ZLb1eTQQdyv7He9hsAVpnKRzYIiUQW7yhHjc7FCDGAPrszAv8tVV+xYpcAKK?=
 =?us-ascii?Q?Vk5KMXg37gvnd5QCw/TFdUAY680EfyAI55K78LHKhV/br3vbGG1K7SvN8QMb?=
 =?us-ascii?Q?Ko78QuC8NMw44+u3dUF0Qoczs/IHA4wWjxRXkSWrA9rq8WYG7BR0aRixJ8FC?=
 =?us-ascii?Q?olxF1JyrrsYTHYaaZ/R6Id/pf3mjjeUvyh+TXFh8Kx5fvJKG87vrERyGDIPV?=
 =?us-ascii?Q?JmYER6MTOeHpf3V9fXUVkoEJ4b/TGv5ZIdHbwXwL3OqkNmaPiJuAEmy7L74y?=
 =?us-ascii?Q?uEse063EwTUdEOSm+lWz8Rur8w3v9hVCP6YzW0w3wa/NcyLXeMUHSXRVjK4k?=
 =?us-ascii?Q?eW9ykBvHhmyw97Rab9YHEgXd1Uby67VjWLY1rkvC/9nyj0VwRQxwTv+EbEM6?=
 =?us-ascii?Q?yaEENE9qvtsE+Rb/SVthAwQqMF2/OovqtsnQ//2AiWIf7YVsFtECvkq3m+bw?=
 =?us-ascii?Q?+GeXLRJKih+Aj2HJQwyeJWPS47CeFFrP/YH7t8JpCQYzPw90cnM6okK0xdPp?=
 =?us-ascii?Q?M/jqD+d6k13c+h8h3PEv4UKE86hs1G4a9nsPr2PdiiwFqOFemCbIpUg/+XtT?=
 =?us-ascii?Q?rnkp541gL0+5w9jDI1tk9Ogf1DOHPwwjxnp3AiCaqLyNtVWCfvLgbAw3evEj?=
 =?us-ascii?Q?Sfg1tu+9YiWssjOoN79H5WZj9eYp8AMhI5sRunsUVqT9rkBEzurhD0NuP9Ni?=
 =?us-ascii?Q?6DmmP5PXv0eTDFUCBNddNFUwOe+EtHmCzQJM47YI/cQvf3buX7rttykLRGX8?=
 =?us-ascii?Q?llpCz2RhX9iPaLh1sxqjQlFD9Af6ag/W3rneVbxR5hBQ4dYtM8FpptfspGsd?=
 =?us-ascii?Q?IEEwgq4vmQiSJzREvzESrHghqvAa7DMKaLfCJxbT6C88MvPsKv8C+lrsOmb0?=
 =?us-ascii?Q?8UAZDz5eGpwb7u1dPwcX43oG4emqd5cyn2Cqf3KMB+Uq2ir/cj2O5oG+On+r?=
 =?us-ascii?Q?5CJDyMBN9Gfsi1B4A3sRaVn0qSM1Qf9HVwbZgMJBjsx4+dvLsa9cTmji/fHR?=
 =?us-ascii?Q?SKS8c8UHQBfz2do+r8zHAQtivCTBFFt+a82ld/WSKOLRLQCbGvuQ4LJ4qFOx?=
 =?us-ascii?Q?lU8n1HaK4t6fjlPsuO8qRJM8A+NSiYfNGi+xIwXVllPNmc1MgSMYYZF7LDVp?=
 =?us-ascii?Q?m2WRb8wO3ol92HPS9dud2PDVUqtGH6kD2VqAJmp1VdG7EPRkjm7QCX6le1vQ?=
 =?us-ascii?Q?hpoBMDYkbEFRfBWqwWM7eBxjkYvOMnWkwuKlpDLpkCBg6dLYCx/49mhn7Yuv?=
 =?us-ascii?Q?T8PLVWUBf9zoU2z4pdIUwbqTbV24Aps9vqoui447GMirqEnL/BuxMEG6v6Tw?=
 =?us-ascii?Q?FG0Pvt9Qe+6hin86YoV7NmWHs+pEiBhdCJ6Z/32FiY3wzWxyUOyq7w73Wrgn?=
 =?us-ascii?Q?+h03PpDre+MVP7Mh56uTdTkz1FuTkaV3Vt0NxasjjQqNMtbtpfo+tThDQtoV?=
 =?us-ascii?Q?fwuu+pFF3NqDhToKJCsilhRn3wOVa88=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3059185-b0bf-4d5b-570c-08da1297afb9
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5113.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2022 21:53:12.6835
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fv3X4qrUPmKxHkT/7Hih/NNpXu6g0vkKKKxJOv0BSbDCVOF5NpDa44VauQMeiHsWUGvJUFNK8NIfDMRFELP7hKoUswdoTR9uNyKLoYDOxXs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2702
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10302 signatures=695566
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 adultscore=0 mlxscore=0 phishscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203300106
X-Proofpoint-ORIG-GUID: Kp-UZRmJ_nqIrzb0FcVSh-50d2uuJMlA
X-Proofpoint-GUID: Kp-UZRmJ_nqIrzb0FcVSh-50d2uuJMlA
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Print two possible reasons /sys/kernel/debug/gup_test
cannot be opened to help users of this test diagnose
failures.

Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: stable@vger.kernel.org # 5.15+
---
 tools/testing/selftests/vm/gup_test.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/vm/gup_test.c b/tools/testing/selftests/vm/gup_test.c
index fe043f67798b0..c496bcefa7a0e 100644
--- a/tools/testing/selftests/vm/gup_test.c
+++ b/tools/testing/selftests/vm/gup_test.c
@@ -205,7 +205,9 @@ int main(int argc, char **argv)
 
 	gup_fd = open("/sys/kernel/debug/gup_test", O_RDWR);
 	if (gup_fd == -1) {
-		perror("open");
+		perror("failed to open /sys/kernel/debug/gup_test");
+		printf("check if CONFIG_GUP_TEST is enabled in kernel config\n");
+		printf("check if debugfs is mounted at /sys/kernel/debug\n");
 		exit(1);
 	}
 
-- 
2.24.1

