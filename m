Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B90C477294
	for <lists+stable@lfdr.de>; Thu, 16 Dec 2021 14:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237198AbhLPNEr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Dec 2021 08:04:47 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:42584 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237170AbhLPNEq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Dec 2021 08:04:46 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BGCZJR2000415;
        Thu, 16 Dec 2021 13:04:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=ZCKx9BG9BlqsRphb39KlG12NwEaAaVcCQX64pfI4wak=;
 b=ZKPbJ/FBkOP1Vz5KkhqqlOAZP8ZcoL4hBd1AWGj1P6BQLLn2nkZJr7xF+eiZYVgoWdg1
 vkXYxGl5JiijsvEGZvVLaQMO9XYKqpcQkOvuG95q9SkoNswq9RbdniG/ZI8F8QRl4BdF
 EVcWoY+NW4Tg6SwZpAVU/wmMRL/bR1oRtkhDNClnq4HIOSu5q2GwTj53UBa9wLk8gjy+
 a5F521Lef4CxKPignFFr7XNUzX6aCXY6cyMA9B8YnsF+D3IW2hDxu6HXMbMQqvPja39f
 FiDFLxTgIBCbY2ycQ0uTvuy22iFLc11BvdFckvnC/g2r3XDb7Q9WJc8iymH8yyUctC1H yw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cyknrjmkr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Dec 2021 13:04:46 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BGD0hMu008386;
        Thu, 16 Dec 2021 13:04:45 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by userp3030.oracle.com with ESMTP id 3cvh41xmua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Dec 2021 13:04:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nZajEFoVrZO+Q1wpXTPlb0PliQW3HkGVS4Cfd9SdFuIW5OQ5TjlExHXy1B/Agp7X24iPST8JEXg82KDNzJkrEgFfcfjyG0W1s9XzrKH8FCp+YBSrHu9WYkVbTX5d68nNVqpJCOZzQm+sP+iUsltf2i4Td5VjXD5zl5TkUSGTADVTTcpVErkDZrzDNX2FDTYQR+VEPxoBMZw6d1KpUMoDZc24q5A5Bn2XnPMQGGQ87YHomtL3MuYk0eJOTcw6phSW1RbkDS9j4K7bjNn7kniEwe6o1jrZSkgqS//MOMSxp220u4gBgy87h5NNib4uu+3cT8320Khl8au7MS9scxvuzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZCKx9BG9BlqsRphb39KlG12NwEaAaVcCQX64pfI4wak=;
 b=L213r69Sccy6uX12uYZ09KYszuoggsVknwdsXF8V9uwpOJ4Kcmk2D1vWKDaWzAoMpMsGSsxo7XAtWQYV3ANqaJbTEtWEJbA+dbhfuNlKOIrXU9Q58AiB1+rGflGrqbKblFjpyoTeuyXIOe+0QR87rdbR7CFI3rXB4Kk8AZIAaF0+Y0cS9YippVHvNvOG4OL/iUFXnP2STGg1BH0jds1+JSN0r14TQPy37nY32ydi5tbJq1V556nxcWpi7DwpXMALGE3H7gemd0344m1c2VfJ7wKNPi35v5MFfzPbULs1E/SsHrp0BbCFjQDfqx2VTzWMhJk9PSc76kTwcLW7akCAlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZCKx9BG9BlqsRphb39KlG12NwEaAaVcCQX64pfI4wak=;
 b=JsjFSX1re8TX/51N3nZ0z8Ar7/MBnCHZNsO0yB4qkKiAV9brAfX/ijcwm1kyPvdI8CoX2SlnpWmKPeySG8ds/GkwzhLpSgTMFRtURTcZegAD0KcAoWHVFpt8DcQCnitE+zIEVnO0mEkLhfeY3u5jzvVWD5ZhOwvKu4FqIq/DRhI=
Received: from MN2PR10MB4128.namprd10.prod.outlook.com (2603:10b6:208:1d2::24)
 by MN2PR10MB4093.namprd10.prod.outlook.com (2603:10b6:208:114::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Thu, 16 Dec
 2021 13:04:43 +0000
Received: from MN2PR10MB4128.namprd10.prod.outlook.com
 ([fe80::f450:87d2:4d68:5e00]) by MN2PR10MB4128.namprd10.prod.outlook.com
 ([fe80::f450:87d2:4d68:5e00%8]) with mapi id 15.20.4778.018; Thu, 16 Dec 2021
 13:04:43 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Anand Jain <anand.jain@oracle.com>
Subject: [PATCH stable-5.15.y 0/4] backport test case btrfs/216 fixes
Date:   Thu, 16 Dec 2021 21:04:09 +0800
Message-Id: <cover.1639658429.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0024.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::20) To MN2PR10MB4128.namprd10.prod.outlook.com
 (2603:10b6:208:1d2::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c33cfa25-5532-4b07-2ed9-08d9c094a08f
X-MS-TrafficTypeDiagnostic: MN2PR10MB4093:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB40931E5CADEBFC4DA125A629E5779@MN2PR10MB4093.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j5GL0eaAASqSiK/LTJz1qabvoqT5IL/UzD61LRDkD4Tj/isFqgj42ocV2cY0ZGfcS4YCqOs4g7brwkJJqoa2h0EX8adZ9gUnSQiNJqx0zki92rNQPPFDIIFhPavGOQGxLluxMQfAZyAJ414889Q75w4qAzDQA2rZ1DGPnMFYF7CPUoYdK2gwxY2aaHe5pWHMYomSLi/Mi3wDKaK1/9MXxY7tfis4W3mKJmTSWtF0AZ6vwFH4OO+r6ptb9B8tTJo+DGyoRgplkXul4cksmsPZeh8EhM5tVuYCoU8XkS6R9YCBBHM9b+UXyNoO6giF4ZxH/ubA7kyVuU4qixBKqaL3HP4knuekuYvETw7qLowKn1G39BpnSbqXdDB2SsUdvj8uOPRse1UjLPLDun/VcdWMov/bBKJOiebhBy6BrLgh7hZNorOZoNnow8CFLE2+Njwzs2/127wDD8KCaMnyvTufnSh8yXzL/gvOFlyUhFvXE4tNc434YZOHtcohxz1ADRk9xTymG2aqAvX1jNR3MzIp3nH4457HYmv6NGJXTjkJvMSuryt+MYVmLRBZ8IW3C11ttYV2Y3oRK1GQV09OalDoq24gbynMqL121twjcmhgSKV/GGK6PCpeV6o1LRU9T9TaPBiG2GiQa0EYM0TPRAlS/Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(44832011)(316002)(4326008)(6486002)(5660300002)(4744005)(83380400001)(38100700002)(186003)(86362001)(450100002)(2906002)(6512007)(508600001)(8676002)(6506007)(8936002)(66556008)(36756003)(2616005)(107886003)(66946007)(6666004)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qdHPTWVzVIIWbCUTSgWuWOFpIxhPIjoFhSEopft6Qfjm3bY8A90ro9JhsYlB?=
 =?us-ascii?Q?RhjIRo3GycZxjL/GZqTJ9WHLKr9yB1T9iVvpOcO4Aimc2LeHff1eaZcHrPvZ?=
 =?us-ascii?Q?QXztGDxlOegBQcTyCP1bo43ibaMzJ56Ii5nrQUqLn+NFEROERuG5hKNUt2On?=
 =?us-ascii?Q?j2/eOCjuwln3/bDWkt9Jpgle/FlMh0CLdxXiavV3M7anxdoI8RD/vu5SZdrx?=
 =?us-ascii?Q?OaZqyxs8KyCwSQNnTcVA19Tl1Rt3eQW/6MWWDX6iu7anJ0mGf1YBC409UJ9u?=
 =?us-ascii?Q?rKj/UqjZeAKzhBQUJfWYKtLLHeWnYT60/MKq4NdHUA6i0GSadb4r8sKmH7AW?=
 =?us-ascii?Q?qwh5QQ6BFtVtOAcRz3koX+KpGHHlAgukhWs3BSM999fhF5sI88nI0qmlZo1g?=
 =?us-ascii?Q?PVVOkaEeE8FRaxv/Xp5AgldnKVXH96DskH51LT09+GDywMIa2sgOU4JZHw8Z?=
 =?us-ascii?Q?dmxfn+H5DaAbzH3aA6YwvjT9NrujfdE48h0pdsZeg6yjF/lxFKaLw+pGBWn6?=
 =?us-ascii?Q?z0SizHR2cVg+S+rh1Exg0D2pdfwcJD61Y+BlNlC1KUi3W1+K4aOjUUKJk4bd?=
 =?us-ascii?Q?4CcAXJb5SqqEIwS6vpCfDhRVjmj8jAYR+crCdWGyMojv2qPn5NQKmqakqYwy?=
 =?us-ascii?Q?CdiPoeEvIr4nUoXnpDfnjDA3Q9fPVLX2/ButOwP/aceP3CeGBiqTpGQek8pT?=
 =?us-ascii?Q?h271wj7YvyPHT1yjNyUG4yTeubOIzS/hH50+EkayG3pSyoV2NoQHP8bIGTvI?=
 =?us-ascii?Q?TrEzrhEg7jFPR2zNN6KZ2Nqvo5CpJPXEC6SAkR4FN9gM8VzxXOTLXBvYtjDr?=
 =?us-ascii?Q?t2UlFLN0L6qGF2Uk6mNINhBWT/Vkh4NPBAVbPgNkbxVYKMbo2MtwneglMgO6?=
 =?us-ascii?Q?trcWBvNdbf2AfjSGviun0a8lCZ/mEvvcoCL/UmTjU1yq450NyBMsIFch2Reu?=
 =?us-ascii?Q?S9TpgeqYx9o30fdiWw0x12CH6Z8pKZLdg4TS3fRUKXbyyyaHostWBWFBuQtx?=
 =?us-ascii?Q?TwVhpcv6BUff/J72rZedOJqGvncBbw51phv6WOkyLDNBDARSMv7Ytb2HKlC9?=
 =?us-ascii?Q?f7Wvba1S9pFa9Xlc6wJw57FctNKHS7YbPP0le+T7+PLHryc+8TbVN4EwgfBh?=
 =?us-ascii?Q?jJby96U8BuuOJoz8IkFhCt95VX0VVLjZn5il/exWACcTNqbe+1t+rX5FbqXE?=
 =?us-ascii?Q?fdYQLDiToCmFqkANV50nMk6BNIzRE8FiMbRHmXnR0iR+ObzYitLyjxap4xTO?=
 =?us-ascii?Q?L69qEPj43g7W8+OYcS3aIdxBgbhaVpyairArzFpPieXyei6Mp7hKQjPs3zmD?=
 =?us-ascii?Q?jwdPfMw6ODHb4gWaF5pVCFYnqytH46a7ZTbaf5XPBGCgr3vrtmQzl1hKUeYi?=
 =?us-ascii?Q?KoIx9YJGTVSJ10TAvQ29vJ/01g88lrNEJOTsbf3wueQtjieap9S7mxPuFXfJ?=
 =?us-ascii?Q?44X9S0hwMSWAroYVpYpj5twT6c5yxkhWvg2Ej2XQDLnM7qf6GOluBwCbUf3J?=
 =?us-ascii?Q?UryWwrgHvuAhzZL+QDIRWhO69ZJmoywGgB3pDnBcO5FASAcEYpGRIZvaj1S8?=
 =?us-ascii?Q?0o2VUj356t4MKh6hIvf67KZUGJywGF+YyQFeFc8pmDc02WRTc9QGhVJCNVfT?=
 =?us-ascii?Q?tZrvcuYWeu5hKDzlvGNIw6doFiAEBQ8nkTFwNbpaDZUVkori9RUqLeGL2aVf?=
 =?us-ascii?Q?YcbmuQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c33cfa25-5532-4b07-2ed9-08d9c094a08f
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2021 13:04:43.2004
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uzRHYu0mBime7mD/uuuN0laUrmtuMgpFMwTSDvEvuGYUEVG60mcuSNwn61GJwmWt3ejHQxPzBSr0k3pSAVUT5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4093
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10199 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=879 bulkscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112160073
X-Proofpoint-ORIG-GUID: 9ec62DvU_B5pbOGFITs7XbJCiZ8yqXxa
X-Proofpoint-GUID: 9ec62DvU_B5pbOGFITs7XbJCiZ8yqXxa
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In an attempt to make all the fstests test cases pass on stable-5.15.y,
backport fixes for the test case btrfs/216.

Anand Jain (4):
  btrfs: convert latest_bdev type to btrfs_device and rename
  btrfs: use latest_dev in btrfs_show_devname
  btrfs: update latest_dev when we create a sprout device
  btrfs: remove stale comment about the btrfs_show_devname

 fs/btrfs/disk-io.c   |  6 +++---
 fs/btrfs/extent_io.c |  2 +-
 fs/btrfs/inode.c     |  2 +-
 fs/btrfs/super.c     | 26 ++++++--------------------
 fs/btrfs/volumes.c   | 19 +++++++------------
 fs/btrfs/volumes.h   |  6 +++++-
 6 files changed, 23 insertions(+), 38 deletions(-)

-- 
2.33.1

