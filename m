Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01F794744A8
	for <lists+stable@lfdr.de>; Tue, 14 Dec 2021 15:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232530AbhLNOSy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 09:18:54 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:24360 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232479AbhLNOSy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Dec 2021 09:18:54 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BEECmlj022072;
        Tue, 14 Dec 2021 14:18:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=b5qJa+jQLqUz7zN7hV6Tf29nX7jNi/KJtwO1Ud+UxsI=;
 b=MNDMaIjWIiYjkwKLhmsbp/uJYwfYsWnf1SKnExrVz5O7IPq8xVOced7N/2hJXE0j9Rxv
 IPT5lYfv+yJlK9RZqNXwdVOdULAS/FDo+m38H5pLlyUvf2Nz+uCesSfNZGPt84j7N1ro
 v9NnyQ/XsxL+GDD/Cn9OW6XTtcEGyZztD3Q4R8pwdMtbP1xVIscIb681MIeF57wvx7zY
 10cdHFwb9VehqlkUcorPZH5NqqvJUP/p+MByuBwSRuI8IUJbu6W7P2xR962/5t9Zg5q1
 ZMTecdOuecmnv7VdMdGFdeYY1vzjACa+NYlah+Pqv2ECPHAhCBucXVKn0hVeB5EvqTWn OA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx2nfbywd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 14:18:52 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BEEF5BU014710;
        Tue, 14 Dec 2021 14:18:51 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by userp3020.oracle.com with ESMTP id 3cvneq1fhy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 14:18:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BYyMNPnOthmax1W30zQmp+RrhuVnF8CJpIySqk3LZJdUK/xMwR8ROi/vWCaYYDZ4HL00zVy+RkzL33lQaLCFhsFi8UtHwjW7LPBUv8kH8PuOzottG4nDSsVD9lGQVxFSsYNHMyS9e236KStuY3j5qkuTl2gBGd5FNaHxku571AoH6t/egYktc8bxrZj97US3kWrN1ec+SxFQk0uujeIuHAMzLQcerMXQB2NMfvbNGK2g1YHsdl9rF3sDm1YEgrGOy7z2ViSlZ3uTFNl6uxLfMPRsZngcB6UfbTpTUUFlXDC40mQK3T4lAAUmin+eMJ4czbF/p3yVF8pk1BbVvQF6jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b5qJa+jQLqUz7zN7hV6Tf29nX7jNi/KJtwO1Ud+UxsI=;
 b=UZKOh9TroAFJvz637Ty1NSEKlWVEjGBQsEHJ1/lqKe5XLL1eVNq/FtQhLEN23aJh4ZIYEpR3DPsRjuIUytxZr5FgZ1uniqn803s8zDD6C4nJ4IlyoknL3HO1kVdF6fAtsqkEixCcGI7dWgL9OQ9t8SpopAmnF4lHFpzRqFqo3ybPLRz/6XbDoa9b+f41tH+bWrcsCidCpUWWmst0+JDJC7EzIURu7sCDkKoJ4hy4ZdF4e+dvQ3RML0HLLTv7+LPWRF5KINGED75hJn3HQKEUFnsOrbdnLZnZFAYcoX0ks6z0+B8G36O/FBWIQVMsK+eHAAT0FlWWKst7u6I/iB64Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b5qJa+jQLqUz7zN7hV6Tf29nX7jNi/KJtwO1Ud+UxsI=;
 b=FLw3ibO1RuoZF1QaEXPvrgl/T7su4vM+MGq3UA8dPqt0SRCFRFrIGsyZVSu4roCLIKSsYAz+/BU7MY+5f5WtDAfjWghIKtQlgUMS0Rl64iutyPdrPk9cOYg89ubBSC1Z5sPCQpR+RMlOH6znC3iM7L4XBEQv3IsNBAsIR1B/Sag=
Received: from BN0PR10MB5192.namprd10.prod.outlook.com (2603:10b6:408:115::8)
 by BN6PR10MB1380.namprd10.prod.outlook.com (2603:10b6:404:45::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Tue, 14 Dec
 2021 14:18:49 +0000
Received: from BN0PR10MB5192.namprd10.prod.outlook.com
 ([fe80::4440:4f39:6d92:a14c]) by BN0PR10MB5192.namprd10.prod.outlook.com
 ([fe80::4440:4f39:6d92:a14c%8]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 14:18:49 +0000
From:   George Kennedy <george.kennedy@oracle.com>
To:     damien.lemoal@opensource.wdc.com
Cc:     george.kennedy@oracle.com, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH v2] libata: if T_LENGTH is zero, dma direction should be DMA_NONE
Date:   Tue, 14 Dec 2021 09:16:51 -0500
Message-Id: <1639491411-14401-1-git-send-email-george.kennedy@oracle.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0029.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::34) To BN0PR10MB5192.namprd10.prod.outlook.com
 (2603:10b6:408:115::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c86daa8c-c552-420e-a083-08d9bf0ca58c
X-MS-TrafficTypeDiagnostic: BN6PR10MB1380:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB1380F5E1008D62447EF9E3B3E6759@BN6PR10MB1380.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1148;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KTbKY2R6wyym2tNbHxCWHt0Y9Fo0x0+ndnlxUj5gMwiDoVT3CFrP5We9Auqx6hva1b0mljo9xsGEy47c2fsDPPXlVwxnYI0NQ7HE3XUqfMmZWoPPDEIfFLAiZzaVLL6wY072f0OMheiEOMjuvSOPM0KIfKBnA6BTPp1RvFHZOv6rUEzmHz9G2haR5dRDAfAmKYUqmCv7eT+yVZjE/djU3wJoNFljcX+bDgiYCzlPyJxjIej+kUULLKv6cwtb1k2QwjlIAXFQb2/D4m+GMx5RcB1SxomoJH1jNuRogiw4g+pE965DiDIaK24LfPvgIv9oNDcoTN4647PMGp4WNuWNtxW2vM8byHW6LOnTr8qVSEZyI0EYyBEpkWy4w7wir3iZbDGu5A5yFJBnxOB1JzZXqoKG5rxqohJqr357p0vKzge7Lfcxof1V2CyP13PKPeNv2hXMEwFlhwlPGPUSSfhML+qZh+9BzWeuTd+e25IvsYmc/Hs+OsR306PUyVYOIdm6fJupD0BYl1JxTquJ4TSrr7PoEkHZ4A1okwClVyK0t5i+bLiUg6FBsv02r6SjDx1JPDa2S6y9TninXrZD0kXflg/z1l39CZaJOWUn7SiMNrFnphcOFczX2XP+Y+inDzfvZEu7J4YWxENZeFsclIQzz22lr3BGM4YzKsYbtDh84TqHWxYreuKsrzOXxqJiroJzokvz1ZVY3zKSL9Obr0Ky7Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5192.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(6512007)(26005)(8676002)(6916009)(316002)(52116002)(38350700002)(86362001)(66556008)(6666004)(38100700002)(186003)(508600001)(36756003)(5660300002)(44832011)(6506007)(6486002)(66946007)(2616005)(8936002)(83380400001)(2906002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?c5vnwzq0XBuUkKfAWDrj6k+YgusNxmmbKmr1UJxzQ6+RpvxxZ2pkKfCrqTyY?=
 =?us-ascii?Q?jxLad8sVv1HNSzPmTL6DIEA5CRbSaC0Mua8/dq5hikHIpyA2+jVZsL7uTYqd?=
 =?us-ascii?Q?Dapydzx8LuzTSjgdsx5LyYbezz1AYBphdkHblHRzVTI8G0O8g7ru8QoHYmls?=
 =?us-ascii?Q?Mx+zFsT6dqtQIXTBb3dXslmqDamr9vr7bfj8Y2Izht/juudpbJVBdDSNVhkj?=
 =?us-ascii?Q?ae+0pDGTtmaOQDtqWFU8i3wQPw9n6cGG14zmU7diF5CmbzRs7tgGsVS3O1q+?=
 =?us-ascii?Q?toUiYQn72cor+w0qKrqI9/Yn7hSDA0fsGEFjenqdYQT/hrHyTfW7F8xGB5Uj?=
 =?us-ascii?Q?51kU+FxrWWYYb6uQfk06Q8F27LZwfESkGDXGoghCgVEx05SLkA0uVKkYaGEB?=
 =?us-ascii?Q?gDx7uWGUgryWj5EPVpWA5e/0t3Erp2MzvTJdKeWEQ7TVqUpCB4gIgntCDm9O?=
 =?us-ascii?Q?pWcnKAo4puonke19LKM8rkJ+/7EfvMXWadfRtp+9UTz2HuU3kTIc7L/nisHd?=
 =?us-ascii?Q?eG0m6pmi1igbGXfCDk7VVdSdHTwMdsP67vd/djsGIjhy7m/LytmWERLcudei?=
 =?us-ascii?Q?vPIohP7XXwdMSHMW5V2RJXwAbw/3CFZRZxmAtOK3/aJ8sUFtgovuWSj+OSWB?=
 =?us-ascii?Q?L7pkQYfQA3kVyrgAInqASMfpMASN4evj+AakIWz7oevddexbiCnYHpnVEhHF?=
 =?us-ascii?Q?DaticPgiR8vzjeFhYtemv/xF8L3XIJEsCq7ZnwJz5nmuAtmTBv28u52ni38P?=
 =?us-ascii?Q?VVkWJwOJ5u+H/P87C2d3BQWEnG0jQF7axYeS9sL2YdqPuHzp6aLi4e1/X8aX?=
 =?us-ascii?Q?97c+d6oFuAadGfS9dktt6+iI9g0Eeb37HfSTwtjrVZsAVpT9HYwbcNah9b5W?=
 =?us-ascii?Q?kfEwHmJT/I7I1iuS/Lq8ymoXz2sz7i4E8jGUUos0UDNOous1f+TbGe1FdMzY?=
 =?us-ascii?Q?/nEGiJXUyyavFg+bHGyLM89O4EXGD4VQw1DmIqs9kKVfwD7PRpyQG6OHx83i?=
 =?us-ascii?Q?gW/pCqqs7DE90mWx8hHmmSprclAv4AEL2QwzCjMrIrCyHvjakmvwCqYNScca?=
 =?us-ascii?Q?8iVgYuOpq1qJm9tcSDHeGlXr2O9IcngUo6hxyd1Xyh5m+QaZ7RBinNY0tYqh?=
 =?us-ascii?Q?Pm5YX39NTe9g1yA09Xk4Fwdv4TsEXoSbxvrZ6zsEzAr/GL4iXP+BQscj8bI8?=
 =?us-ascii?Q?5xm36ZKx1Swto4WAptipumKjurwF8+oeEnPx9hxGD/0TclRdiMVkmHuJieyY?=
 =?us-ascii?Q?D7RkGe6dw8/TT9SZjxmQwvDUlRYZhCMeY5khnDlD/NM4PQoIW9lszHX9p1vm?=
 =?us-ascii?Q?vDJzdn8VZcRAjRMx7cin7TbyN4F+E53SE5Fpg7Nl224saKk5S6jPbbpelAdD?=
 =?us-ascii?Q?fh3MYv4JfE7dmb2G6+FbwXojJsdNBRMWFDgDUUm+fkqQQiLHnkljndHcmo2X?=
 =?us-ascii?Q?/1BJZXsz8e4Mfx+K/CjT7g8bVz/mjAmgJh1iuQswnvOyq3B/dysr86d7yiEs?=
 =?us-ascii?Q?dOfWcnGjJQZt9xlV1U2H0ITCsXeogZVUOXBNCX00Jr8Wazo7+150tn7iV55w?=
 =?us-ascii?Q?VCwAE4u79FG/sell+FP8m3f1Wp+MjglR0beISOHmf3/gYxOTJVBeWSbGRAle?=
 =?us-ascii?Q?H24RfgQGU99ZdSigpdh/T4/mSNzXDpk74R2O4yojL1FBfwUpCQei4MJz6VGb?=
 =?us-ascii?Q?KnE7mg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c86daa8c-c552-420e-a083-08d9bf0ca58c
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5192.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 14:18:48.9323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cDW+IqccZd2hJN5m5CM04D8UJXZiRA6ATOUNDt+ISA25D6Uk5BRn/KOmlRnhjOJH1YH3pBKOmAsCTQOf4/+hU8HKZ59YwwJil2JyBtF/IjQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1380
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10197 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 bulkscore=0 spamscore=0 mlxlogscore=884 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112140083
X-Proofpoint-ORIG-GUID: -pm4z4pY34rgqrzXbACuzVSTpE2fTiEM
X-Proofpoint-GUID: -pm4z4pY34rgqrzXbACuzVSTpE2fTiEM
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Avoid data corruption by rejecting pass-through commands where
T_LENGTH is zero (No data is transferred) and the dma direction
is not DMA_NONE.

Cc: <stable@vger.kernel.org>
Reported-by: syzkaller<syzkaller@googlegroups.com>
Signed-off-by: George Kennedy<george.kennedy@oracle.com>
---
 drivers/ata/libata-scsi.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 1b84d55..313e947 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2859,8 +2859,19 @@ static unsigned int ata_scsi_pass_thru(struct ata_queued_cmd *qc)
 		goto invalid_fld;
 	}
 
-	if (ata_is_ncq(tf->protocol) && (cdb[2 + cdb_offset] & 0x3) == 0)
-		tf->protocol = ATA_PROT_NCQ_NODATA;
+	if ((cdb[2 + cdb_offset] & 0x3) == 0) {
+		/*
+		 * When T_LENGTH is zero (No data is transferred), dir should
+		 * be DMA_NONE.
+		 */
+		if (scmd->sc_data_direction != DMA_NONE) {
+			fp = 2 + cdb_offset;
+			goto invalid_fld;
+		}
+
+		if (ata_is_ncq(tf->protocol))
+			tf->protocol = ATA_PROT_NCQ_NODATA;
+	}
 
 	/* enable LBA */
 	tf->flags |= ATA_TFLAG_LBA;
-- 
1.8.3.1

