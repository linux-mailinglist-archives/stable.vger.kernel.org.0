Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B54742ADF3
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 22:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234843AbhJLUiO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 16:38:14 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:29628 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234894AbhJLUiC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Oct 2021 16:38:02 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19CJtV71016786;
        Tue, 12 Oct 2021 20:35:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=UIxv9jdnlppb6G35hMZXoDX3RXCDlKF+v2RFwDUoVJw=;
 b=L1xvfZnq2SH17B5B28RFTGTAnpdv/yOqCTQNnAeZGNOOvawZN0PQs9AdlrcVfVPt8hVJ
 DWpkL6K03QtdzCEcVVdMRhDoZvq+7yVNeIJuoVa9W+ocKYTc5Dn/83Y3h7mI0eIsyVqV
 P+mrL9JJ9vnuQv3Axu/wdrz23scUFvUFUkslCY0DllYqyrkrcHyNtAXcAJzg6FvAqePz
 w3UbsmyjZ/BqYCr1ju08+NIQm6jgLXzphjYHQJbahyx8mEtjIdiI21Tz/gI5aJQdlIzi
 hX7AqFOlFxGYb1CjtGgQHRz2niiDbdZc4dhUf6D32bx5Y6Go8oBCenF8unaRxIp3NGnh Hg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bmtmk9gna-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 20:35:44 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19CKZ7M1009545;
        Tue, 12 Oct 2021 20:35:29 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by userp3030.oracle.com with ESMTP id 3bkyv9jq2n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 20:35:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nyR2FDiEE7D74Z7bZm/MkrGKUbX1igX+ue/acvosrFp9TQsn7/DkFzp14m0xtFu1nlbGCB1ZElqYsRMxrrLoLg3Xz16+wWbHUTSnhnP4wmaPTMy4P/1PwA0YcP6SsE9lTI5R9dGoxDWrAZfScK4Tjyd7YuSef+KB61Xx+EwgUMUfcwHfJEnTHt52Wuhtj1AXWS1Xnh4u/lCxMT4Zl8ig3w2G2SuA9w/eP7gSVEvWNytbybdhse1zkRcoB2SmuHn/hygnHGQF4a854DCuX3Z2oUSZ2pUIeKay6EgB6dBOOcquCrX5tWqJU4jsS6/KKrLyusIdPefEaeeFvgjA23Ujlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UIxv9jdnlppb6G35hMZXoDX3RXCDlKF+v2RFwDUoVJw=;
 b=KfoOTS0kvAMrrE5rlRE8E6rO+hdtT8UPj/MJC9zx8rrdnF6LRG0SluKoUukJT9RwSCA5IKGRSDMjpu1wjZZUcdXbXsrUPDCiu5C8mb7khLpnYXHpfolzhTilytMwh1nHnxaG/N8UOr258yNmBmuwSDYvCUuonPVhF/CrgaW6BUW6US9BinseguTBSnSwcx1Mb5OezfHYIyfdogwL6XzFg2pWP3tt3lM8fm6OSWqhc4SOtqvbk52mzevgL9Xd0cA1Qx3ghep/6NkNl08P0TCtA7xnFTR0ERxFTBEYYnpJIIrXjwsHmLWKBdNnub4nHyi6yhUeWwOythtVwNmAfBqDbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UIxv9jdnlppb6G35hMZXoDX3RXCDlKF+v2RFwDUoVJw=;
 b=iSYdLNcwedMNC0om+bmDp6QymWBJTReO2iR0Q//EQGU82Hif/jpmG7oh6wHqhx5TK/57OpLLYl1NrJFmYgFwlvMgFNMgaYNZYzN/S2MiYTfGh51kre1Yhmq25wwE+LYg97oZWt/yDgK2MPFYpEOm9ENXZWUEHIkNGmllif6YdIw=
Authentication-Results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5514.namprd10.prod.outlook.com (2603:10b6:510:106::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.22; Tue, 12 Oct
 2021 20:35:27 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 20:35:27 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     bvanassche@acm.org, linux-scsi@vger.kernel.org,
        ming.lei@redhat.com, john.garry@huawei.com, haiyangz@microsoft.com,
        Dexuan Cui <decui@microsoft.com>, mikelley@microsoft.com,
        linux-hyperv@vger.kernel.org, kys@microsoft.com,
        longli@microsoft.com, jejb@linux.ibm.com, sthemmin@microsoft.com,
        wei.liu@kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] scsi: core: Fix shost->cmd_per_lun calculation in scsi_add_host_with_dma()
Date:   Tue, 12 Oct 2021 16:35:23 -0400
Message-Id: <163407065460.24401.12829276973949007468.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211008043546.6006-1-decui@microsoft.com>
References: <20211008043546.6006-1-decui@microsoft.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN6PR04CA0095.namprd04.prod.outlook.com
 (2603:10b6:805:f2::36) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN6PR04CA0095.namprd04.prod.outlook.com (2603:10b6:805:f2::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18 via Frontend Transport; Tue, 12 Oct 2021 20:35:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 35e57796-8dde-4ac0-83ba-08d98dbfd373
X-MS-TrafficTypeDiagnostic: PH0PR10MB5514:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB55145EA3C7EFD9D1D66DA1338EB69@PH0PR10MB5514.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:765;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6yNqbxDyT0NKYSx6kcHJvRvki9FKhx18NdV+tgEGj6Yzw4K3z/w62pygsbdsEF90LOG155aNblaLe1SrKQ9WkhBoXdHlp8h4HNEWQeXbFA/eE0P4/2vh6qzvZ0okmwcADFFgUkuk5v1EUf5/ltXx4yEnFFQ/Jb7SYfzz9Fg18/0vURt/UbWamedKxHvRmUFrgVROc+F3hBay+21ay7EM+qH58JiQaIAJK2R7XqNQiQKbnKSTpzSEOWSgu2hwHvhTJilo782WBOqY8GIHL14+wtQNCt/PKPjsO5iCml6OkNtWeralrsattfr5XNxEvlaKMDUgXfIkTAIi1h0gERI6UtQ69dX1oqjeSRGJNlMjuFQ1g44oqNEDz3UMuiMWorxE8iQtNi8s8UtsYtnt4te1J9CT9EcSSJF8i/P6g/VyjJDG4+5lYGbDKTllRrkWix8H8CGs8xB1vAPLWjilocubYtmhVxf1bK5bZmsvaZOzm3MXiDa0nBrWBeTU/3MFgS7Q6n60INgTFMCfkoPNCDoIRwsn+Qz5W2Y4s4Qvj+Pq6ug336Vda5jPUc0x1bsqWVPfknH2hg6E6w4JyvVX4BB4zQQdEkgzp+4sorkExujVfG4ViOsTVWuOd1xkeYUma2WjYmZq1etUexcsoeMlaKk/hgNcGCJYu+s2zR5b0looNVQ2Ttywc6xIJvDGx6oaiYoTmqZ/7Yfk+Q8vpaQKFIUvx80tmqT2Y0KXrBt/93FEyHavM/xmxo2yh3D14uML7wu8FOPbMiBRbXNd5DORsBDO32jqSn+d055wV7xe/JpfHDwCu9LbbVi7yor+ZTerk5XJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(7416002)(86362001)(5660300002)(8676002)(2906002)(52116002)(66476007)(66556008)(7696005)(6666004)(956004)(66946007)(6486002)(921005)(38100700002)(8936002)(4326008)(83380400001)(36756003)(186003)(103116003)(4744005)(508600001)(26005)(2616005)(38350700002)(966005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RG1aZThRaVJnWkVGQTc2UEE0bFJaV3g1a24wN2pTZExOR1UzZnNYcXRtOVVa?=
 =?utf-8?B?WWRsNXBjOERWeENOMEdYU3BLZEZyM3c4ZUh1WnZuNFVvSnFsMkdOZUFEcnhG?=
 =?utf-8?B?VFZqVC90bWxqUGs3aVRLOGJLdDdQcWFlVVBMRDZMTFg3bGdCZE0rak5aWkpB?=
 =?utf-8?B?dHNUNmN1RlRKMjd2NEZVemRzdEoxUlJXV3ptTUNONjNyY2lkdUdHNDJFbFVO?=
 =?utf-8?B?RzhXTk9ZbW9FdmlTMkdzTUs0Q0s3MStUUW16WG1qWGNNelM3cmw0aFJHZW90?=
 =?utf-8?B?QmNjS2l2ekR3NmJFdzQrcGdIK0FhNWhzMWlPODg2WHFOcEljTmhpSlB4Z3VW?=
 =?utf-8?B?OGR4bmxxSDBBYlR2SitkZk1hZ1RqYWNoODJORERlcnd6RjRnWHNuL0owOTk3?=
 =?utf-8?B?aVVncWJQVFBaeFZkTVQ4c1lQNk94QlBhVitFQndSbjZkRTZLdEx5VG8zV3ZU?=
 =?utf-8?B?QnpYa040NEd0V0cxYmhkQ2R6SkphaVNzNkw4TUw1OSt2a1pzbmk3NEd3VWlL?=
 =?utf-8?B?eHEzK1BtTDZlUzJJMXA2VFR6Y2l4MG81aTgvZzNXeWc1Mi8xai8rbXRFRERk?=
 =?utf-8?B?eUR1czdsRGFQbjlEa29iK2tZUG91VWcrRkZwNnlOaHpMeFhKaW4xeTM1NTZP?=
 =?utf-8?B?SE9PMDB5Z0JLR2JJVzYxVTZrSkE0RGNFWEtoak5zcnVNZi92eEp6Tys2Vms2?=
 =?utf-8?B?Y2JNdjdUWkxsb0hGOEYwaE9PVnA1YlF1eUMyQzFoRFZvbzRjbGtIQkJleGNQ?=
 =?utf-8?B?d3l2R2RIZ3Y0VzEvTVB2c2ZoVmo2dmFyMDEvcUdqdDM0TmZlOFdHZUhid1pH?=
 =?utf-8?B?YkpMdWZSUG5BcjNKalpKWjZLNEpMOHQweVRsbWxFdWRrQjQ3YjFLOUlQVDJT?=
 =?utf-8?B?YUpuVjZ2NFhFRzZWaUoyNUdNVytJaXFsekdkSmI4bDM2dVFqRHh6WTBSOG44?=
 =?utf-8?B?NXZMMHhSRmxPTFYxS1BVM2RYU3FqTzFiSkluOHRRbGEwelBkcU9NSll0VzN4?=
 =?utf-8?B?NzR6WkM2bGw3RFZYUGZpc0pYczkzVElRN2JXaHAxTkZxWGpxTDBJRUl3Ym9Z?=
 =?utf-8?B?U3BHbjdNOUlnZDVVR3B2YUdOVndlS3pOS2Z6VE0yWGFHYkFEVTJyY2lmaVN4?=
 =?utf-8?B?ZlBKWmxqVVN4b0tPc0FrWFhwa2l4dkFNYng4VVVtSmphSlNxK1FFYkx2bmU2?=
 =?utf-8?B?ZG0yWnYxWmNDRHJNUENvNVl4TDZXRXdDMGMwc2FTUjlybVVYcXVYdDdPMGs3?=
 =?utf-8?B?bEZqWXd4bXhxYmhmNVF4eEs5SERQMVNiem5zNkVnK0k0bGlTdm8zWTExd3JG?=
 =?utf-8?B?S3JGdlAzcmFZWGVvQXg1bWtSZzBIWFJZS3NKZFJqSGR0bkRrcUNERGRWREt0?=
 =?utf-8?B?NU9HVm80dUdzMlRsRmNiQUtvWDh4TTcwRXI2bzNGT1dyT09ucGNlQllJRytM?=
 =?utf-8?B?RnFtSVB6dDlHZ2NOYU1hTFlaK1FYUUdDd1Uxc1NvVkJ1eWpsQ09SdW9TNDY5?=
 =?utf-8?B?SGdoajFvcTViOTNQNGVIS01kTFI1WFU4MFRJaWNOMTlXc0dMN0xLbmN6UkFH?=
 =?utf-8?B?OU5NNVIxemIwcHlvckZ0a2hvRG04Zk9LK21sVTU5WWFOY1pkSVZWd3laRkNt?=
 =?utf-8?B?aDBUNCt3WVpVTkErUEZxTWc5dDhGT3hhMUZybVNwMS9zdUpJdjNOZUFSZXc5?=
 =?utf-8?B?bFozVmd4RUxQQWxYWFNoSnVPQmZ4dk9hUEhUazZCSEVaVUhPYTAyejhtYmYw?=
 =?utf-8?Q?7jpJ5+Hk/cqi24efve1NtoLWIfdbI3Yt0a8bYql?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35e57796-8dde-4ac0-83ba-08d98dbfd373
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 20:35:27.7888
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LdDnKjMiCYN2QTgWMiVj8hfoZwF6b/O/yrPcQ/zh6Hz1K5jRJtGkcr2FY5EdV2/PxhHbFQWEOkpz7KSQZZQo4j4zfv8ITWkiQnYYJSNJfHE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5514
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10135 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110120109
X-Proofpoint-GUID: 9liN9mXFRbjQQ8NzL7gghSbCD2fvYmQl
X-Proofpoint-ORIG-GUID: 9liN9mXFRbjQQ8NzL7gghSbCD2fvYmQl
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 7 Oct 2021 21:35:46 -0700, Dexuan Cui wrote:

> After commit ea2f0f77538c, a 416-CPU VM running on Hyper-V hangs during
> boot because the hv_storvsc driver sets scsi_driver.can_queue to an "int"
> value that exceeds SHRT_MAX, and hence scsi_add_host_with_dma() sets
> shost->cmd_per_lun to a negative "short" value.
> 
> Use min_t(int, ...) to fix the issue.
> 
> [...]

Applied to 5.15/scsi-fixes, thanks!

[1/1] scsi: core: Fix shost->cmd_per_lun calculation in scsi_add_host_with_dma()
      https://git.kernel.org/mkp/scsi/c/50b6cb351636

-- 
Martin K. Petersen	Oracle Linux Engineering
