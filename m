Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFAB43FF8A4
	for <lists+stable@lfdr.de>; Fri,  3 Sep 2021 03:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344508AbhICB16 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Sep 2021 21:27:58 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:11648 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230434AbhICB16 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Sep 2021 21:27:58 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 182MsVPH031391
        for <stable@vger.kernel.org>; Fri, 3 Sep 2021 01:26:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=waPZYRFjPpq1tsCPTaionNPXQZaM1Cwx46CqtklCM4U=;
 b=pP9ufl7Z6Q3fOxPRZIgEQF81CeU+6PssstaIdFRqNiNiVKnSuvSJZ57SxEyPVm0i13DB
 N0e3E0he3zpQuJI8vohVzgppD1NYaqLuqfOEpt7jWaTByi5IGDgriMrLelYJP0uccL0o
 TxNJKtd27HPCDdh1Uz14z288ksBSG2L8hRv321FKWleXc0tm1V9iV32ip3LldgQZlSUw
 cB8mWyqt32l+ilMBaHwg0JXMFURxRDxagQhTTGA/ZUlW9nfn4D2X0322utjRAUr5jVFr
 x1Sw09UL1KaSSQZza+OVnrTvVzqpvRhX4zRzVJC2azq3VZoar+5jBlavfBM8pIoPo++0 vQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=waPZYRFjPpq1tsCPTaionNPXQZaM1Cwx46CqtklCM4U=;
 b=scjpgDS2irG8tzWhRLcdsb7mGtjAiGqUNLeu121s2dcHzAi2/YBxUvz9YpllXKwP++V+
 YzoZPEn7NJdH4iKxWAgPzgxJ5nWLvA+v1ET7tftpdL3dpzatS0WTEYyKOPh0kMfpmSA1
 e9WUtN8t9ijAEpubTJMbtH/eOJsWp3OC9ePU81+Q9t2HPPM526+okYS5M12ZvBDC+UTF
 yAb55CkSVdsJO1gwR9e0/RfA279SEA0u2br+49WASH3EJjV7lqXn72898XjEf9DdqJ5n
 KzihUAv9QbfzW6ePe4tS9tLkF7clRlFk05Y6TFxnJ7GT8zo5ymMfQIDNMGfsOZ//ADmC iA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3atdw5cghp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <stable@vger.kernel.org>; Fri, 03 Sep 2021 01:26:58 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1831FwF4015287
        for <stable@vger.kernel.org>; Fri, 3 Sep 2021 01:26:57 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by userp3020.oracle.com with ESMTP id 3ate00t59y-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <stable@vger.kernel.org>; Fri, 03 Sep 2021 01:26:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lCT2p8kI3Ox4Qy9AoWst1IJxWslcZ3CK0Bq3zxXFgnTblr1T/fFE0YRzEyoV8SZNj3d0GK/O+IP3una/GCLDsr9N9Ea80IB3VZ8vLKmRluVqf3nLxKMeUQUKDWGyAmpNpZLOAGOQRNBcR+JUVUSZVZExcGdojv0XCtU0fl5c7uQDkkfDaX0XebDC/zlbKoWRIaLgoumfvZD6objlOk0QOeQoHlnjkOUmqnRqzceJ2LRhbyziN7dAuAm4fBuHuJGucbIE6fwTnhCKFwFH08lM518DxTAFA4KBRxsN1WbzHL0bNdUoi/4o8HvtRhOYFNOWwVBQxwM04kqlRIJLq140+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=waPZYRFjPpq1tsCPTaionNPXQZaM1Cwx46CqtklCM4U=;
 b=ciCP/CVeOOVnJ2rwKOwTQCiCQXopxpyE9cG0EFcDWB83H1Y4sumhn/yd/ynv9ucJhGoUcmt0R86S1zEhgEm45zHVk6nhCGJ3f3l3IkSk/QuJZV5yUUN4a4vJfBq8wuEQgtKHWS7WFeHzYoQAdAKIifmyqIjmBuhP/xWKfIyxRD7QaNl9tNwhKA5Z0SCE2oLw1G7ZbrU9/1Hcib7umkh7Bl6tWcZ/1byQkAbcdj2MyVRJQ+kjgJJ1lv0trNIYTgGLeDgfCM+pehQKFMjpAP57L60KcbJK+L5Z9GUMDBTiXSNh76QpN/2cqh7NQG+74YPJJoWm+R8+yjOeoePjCwoPdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=waPZYRFjPpq1tsCPTaionNPXQZaM1Cwx46CqtklCM4U=;
 b=WMy+v+7p87b8mnWGzbyoLmPUc7WaeFZja6gIG6Jy0yUJvE0EHYEoTwhZSlcWFWqyeFRX3ZbGvPs7KRChVFl4AkxExz97wYK8xc8Y7ou1kzlawryAsvO4AeTpX5p4BoJYWfe0WniRbpefRD9X+XylybOiyxt/f2iyzTFg/dApXQw=
Authentication-Results: oss.oracle.com; dkim=none (message not signed)
 header.d=none;oss.oracle.com; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB2701.namprd10.prod.outlook.com (2603:10b6:805:45::20)
 by SA2PR10MB4732.namprd10.prod.outlook.com (2603:10b6:806:fa::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.23; Fri, 3 Sep
 2021 01:26:53 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::64da:7ae6:af82:ebfe]) by SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::64da:7ae6:af82:ebfe%5]) with mapi id 15.20.4457.024; Fri, 3 Sep 2021
 01:26:53 +0000
From:   Wengang Wang <wen.gang.wang@oracle.com>
To:     ocfs2-devel@oss.oracle.com
Cc:     wen.gang.wang@oracle.com, stable@vger.kernel.org
Subject: [PATCH] ocfs2: drop acl cache for directories too
Date:   Thu,  2 Sep 2021 18:26:31 -0700
Message-Id: <20210903012631.6099-1-wen.gang.wang@oracle.com>
X-Mailer: git-send-email 2.21.0 (Apple Git-122.2)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA9PR13CA0162.namprd13.prod.outlook.com
 (2603:10b6:806:28::17) To SN6PR10MB2701.namprd10.prod.outlook.com
 (2603:10b6:805:45::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dhcp-10-159-128-63.vpn.oracle.com (2606:b400:8301:1010::16aa) by SA9PR13CA0162.namprd13.prod.outlook.com (2603:10b6:806:28::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.4 via Frontend Transport; Fri, 3 Sep 2021 01:26:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f957abad-efd9-4c51-2036-08d96e79e952
X-MS-TrafficTypeDiagnostic: SA2PR10MB4732:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR10MB4732A46BA161260FEE7A3CC9CFCF9@SA2PR10MB4732.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ses168PzHvPWcuwUEUeZVgCSafZpJWJgzrr3rqdwEmAJt9h2Mwz8nEhJgSFgxluf4xEryU+0WKdJwjvVsCXvYaH0Gqn8efoww9KGxdF+f+9KQ1XsWjXevMaBU4vYYqTYHz+sdZp8CfRkTNAuO2sQBBeEDkqpDHnf/c67vQvjhExocaAvWcWynxPA1Yr0x5gjHNT2x69LvVfDTYuvqhSjcRz4hk1QM/Ir2DU6K04lCY2pKHICfDvdX4WgjvnnMXVmG6KrVK2M6MOrh92Wz0e1VaYSrXsZT+EAqbCcUjeDHE1QxjnSIeuzrxN3xPXaqLvoAUz36xD0PgPHbslPFyRRyzVDgdOSsz2v0O79GjagGTxXU+qVbMjBFxOEQVLUeaaFH5p8dYCu39kTO7C+0yzlDWGT21/clMi3tgYkbf81RAbrHM0J7LzFA+WCmkgg8akdQ+wf6Mxs3s0m34BjBKDTMNilXsTgIGJVVwagLDLjutqz6T5jJF4CrLjV7I3bdZmOPPF1c+Q/hOzgRlB1H0OX9e64D5D+/WPrBHQmB51p/XOqiuADTGJDGKTLCnxOv7nWva6BlYEsae7+P1XLhrRP2+JFVoHYuZW9n43pWgw1uxlE2sAw44NA0wxNeCQ7S0jGchYVvO8V0iqlXpvqecmG9Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2701.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(346002)(396003)(136003)(366004)(8676002)(66556008)(1076003)(4326008)(66946007)(36756003)(2616005)(6486002)(316002)(52116002)(83380400001)(5660300002)(478600001)(66476007)(2906002)(6666004)(34206002)(103116003)(7696005)(86362001)(186003)(8936002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1c8sXDfdlh/60zTBe3SeiCar9rLXGZb2ALawFXhxdwcHBDLZDeu/I90PzcCl?=
 =?us-ascii?Q?59CKL7iUebMmk+n1dHsCnSNNUCcZViwIHRVaRvNqAXWLe57eED4TSknhFZ9m?=
 =?us-ascii?Q?Z+8GIaaDpsQpJArI1oP0PAoCu+Q/UaxSkt4BkRa9VjRJ2xnJHwmM6haSgcV7?=
 =?us-ascii?Q?wJJBqQii9fn198vxsNTmzrMu9MOwONcTtQ9QpGKaBYmh7gfxvqNAkgzFtyVz?=
 =?us-ascii?Q?RgGWWUDJ7uMq5FOpCw0XkmUuLF6Wbho6DGijrQBC97NFP88Fni85qiBfzSAN?=
 =?us-ascii?Q?qVecT4BsUrnesjO5XTQ0e/F1B4+9Qd2LLAfhQemgbzREYKHy+VC10BEAJbIu?=
 =?us-ascii?Q?flPx2/MD1J7Z+0jl7GCmho7eOORshjLRFDPufEGBFPTvRNY/jwXdhsTf2UY/?=
 =?us-ascii?Q?nQUa/EJk69GZIWd0gKoCrnMThTvoIsxcZHGcJBPOYQCzJVd/oS63TznsowTH?=
 =?us-ascii?Q?s36dk/Hz5lMR8AN2+d5hAso41zhr50Zl3PthsbxSDDDXNGrXXI53v+l9R57h?=
 =?us-ascii?Q?NJ+hOO4MkWqn1whrWgr9K4cwkaEzI2QdODj25R6z0U2fa3qsqJvT24dXYHQs?=
 =?us-ascii?Q?1uTzCfomj7W3FuGGf2eZokuAkSN+fXpVGPs6HgYGh1oOfmJJZGp+Q4VuNcat?=
 =?us-ascii?Q?XVuBpFJa2Buo6qjalU95/8cVmtahpvUWLmwPpmri5YzF53TjF/lXKAU1Giwu?=
 =?us-ascii?Q?9r4NoIvDC52L5JSsD9rNhOnfxE1cGuxNYR0z9SEJmt4p+H9wQptklTX1t5a/?=
 =?us-ascii?Q?G1fOzBEx94ggqwVMQPBjO/FWJE2nq4YTwqeyUBao8FeqoKK603KJrO22Zz1U?=
 =?us-ascii?Q?TNGkyMGUFr9r82Hxp6twiH287nIfLw89GbH0cGx/EQ0nK1Ay8J6HKj4UEDCl?=
 =?us-ascii?Q?LInT1DOL63eLFD/KyqAXGu6rfzIp7DBQmBUjNAULvRJWEBU0Bx1fBe/SjznP?=
 =?us-ascii?Q?bWjs//4oOEV8O5fSYRc/l+s8Dkw4kNAmj9j/pHX7S0ljHztqkqKRGG4p8ATO?=
 =?us-ascii?Q?Tnk9I6iJjD4TzQMnRA3I4FbB47soanCn41xGd4xxSWTfqc/z1mC3a5HkKEmg?=
 =?us-ascii?Q?M797XL05mA4tT4zuVfnEWbwNGItm4NwpeRydTXD3gxHm3MomcjLWrdAX9C5E?=
 =?us-ascii?Q?nBv8yxf3RpOAF/0HFquZTZV+qL+fYO3VNxbDH/aQyhaapwPD3yGM7Y0w76TX?=
 =?us-ascii?Q?yl663FbftPqH+UeL9WGm49ZyODekxJCtaJAq3+c64IiwGGZSbc+97kqLwFAi?=
 =?us-ascii?Q?IwGb/RMaFQoARmntBGcMomLudq+HXLgwDXgz5RAr1X/6DexvZmNlh/509qv/?=
 =?us-ascii?Q?iWW8cE4Z5N/LjoHqScrxpuzqmes+LXyfKYKg973tl7lz9Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f957abad-efd9-4c51-2036-08d96e79e952
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2021 01:26:53.6376
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V9w7M/7VBou4aSLnnLaVvi62e4XJ9Em2ldS3Cclgi3sBQ81NZ2N21aZUJUff1iw/tibSWMcHq7GKa5MOSV4pGuqlBAD6/9pp7oZ5/SCEvHk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4732
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10095 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=772 mlxscore=0 suspectscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109030006
X-Proofpoint-GUID: HqVAZYkOaFis-LMdrV6t5Ux1zXumPJk8
X-Proofpoint-ORIG-GUID: HqVAZYkOaFis-LMdrV6t5Ux1zXumPJk8
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

ocfs2_data_convert_worker() is currently dropping any cached acl info
for FILE before down-converting meta lock. It should also drop for DIRECTORY.
Otherwise the second acl lookup returns the cached one (from VFS layer) which
could be already stale.

The problem we are seeing is that the acl changes on one node doesn't get
refreshed on other nodes in the following case:

  Node 1                    Node 2
--------------            ----------------
getfacl dir1

			  getfacl dir1    <-- this is OK

setfacl -m u:user1:rwX dir1
getfacl dir1   <-- see the change for user1

			  getfacl dir1    <-- can't see change for user1

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/dlmglue.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 50a863fc1779..207ec61569ea 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3933,7 +3933,7 @@ static int ocfs2_data_convert_worker(struct ocfs2_lock_res *lockres,
 		oi = OCFS2_I(inode);
 		oi->ip_dir_lock_gen++;
 		mlog(0, "generation: %u\n", oi->ip_dir_lock_gen);
-		goto out;
+		goto out_forget;
 	}
 
 	if (!S_ISREG(inode->i_mode))
@@ -3964,6 +3964,7 @@ static int ocfs2_data_convert_worker(struct ocfs2_lock_res *lockres,
 		filemap_fdatawait(mapping);
 	}
 
+out_forget:
 	forget_all_cached_acls(inode);
 
 out:
-- 
2.21.0 (Apple Git-122.2)

