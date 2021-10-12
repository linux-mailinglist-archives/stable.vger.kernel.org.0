Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECACD42AEE4
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 23:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233775AbhJLVaB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 17:30:01 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:49366 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233221AbhJLVaA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Oct 2021 17:30:00 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19CKsxvf020805;
        Tue, 12 Oct 2021 21:27:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=86qvPe6mgxAU0e5KjGM3smetJ6iHClJlIu1p1AWaVag=;
 b=TGd2d7Jt0gLLHaN6Hmzbn/17RweV7/xxJUHLv/tiRrhMkAsOZEgAvLYinvlrEwt+o0Ik
 qKCQp7rQ4op+/zLbMBpDlkutilT4eqcW1NPhnmNKjJkJv3Y7k18epE/OcoKfSSMrdlJG
 tfRo53dtabN2gBQHJ7xvFJQpaHlGwpwhXBHnwF9mrdezZxrvG1+iSGgZ38D3ZBJ97zoU
 3cOHHTt6hIoJGeVLRtzqoYQdB9pTf3xYO5lnUDyd7GIeYdnGqueHsQ6TNFsUdmQCzkMy
 iuVSEm/SMQIG8BLnAEnoRKdrbJ/116f+NccdkDJgPLpVXU4CfIKEPTZVMeaeQAi5X8sX ng== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bmq29v0mx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 21:27:46 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19CLAj6i177202;
        Tue, 12 Oct 2021 21:27:45 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by aserp3020.oracle.com with ESMTP id 3bmadyqmbd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 21:27:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dm0p8Y3rW9ycGXb+3wz/PGQGWKebE1mJ6dbUCK6qMSt1raPr3ZKXH6KLwTI5CxW4tJM0XC9DJTCFIrH3H+dnMlUy8mNvF+uDO22tEZzDjpFZwMNxlRxvTEhc6QUmJVxFmEpMt2TQAqN8Z8q5+pgcxrIyLCor/GL7Tm74JknHrv7X8rRafgN9sMOFNHizh13dYuwB/2D4gtfpdaKe4MIAah5/V32bPjgiZnArwx3ZfC6B+NfhUx3n4Wmhn4HWsle3MFa9XAH7A1H87G6qAdQ7/fDkmuOxYjx5XRdtgY1LPDVQIYnuQY0VGX2rzUi7We3UzsFRjARZhmdYdA5FGQSXlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=86qvPe6mgxAU0e5KjGM3smetJ6iHClJlIu1p1AWaVag=;
 b=RJaVhn1/nZRJEmM4X1hGZJ3tu8cyOqAutAQPJRsl4HnXq37kL0p8mPyTvxYibxO7I9/8Kef0Bjj7iIc0iQc1QyBCG0gLJLGAaawyryo7fu1ur4ofO7pnZsVMOK17IDgZOb044fy4w36mep8sAdI7jxlhfp5ECulgiMe3t2pArmU+/CW3SAZWs7BS6XX3yjqPFA2By8pAxAeE9ytH3o6TS6tzE0zCDQWt440CgO9rTh+sUpasBkh0MmPUtGO+/h/CxfstKJ04GsD5Kse/MCwJdIdX8NaTf41QDwAQ27roOaC0TtK9FYsmKBIxn39kMte+8BscMAzMO8y8yrq9RVQF1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=86qvPe6mgxAU0e5KjGM3smetJ6iHClJlIu1p1AWaVag=;
 b=Oz6XpfC+NQfuweqfIAwA8pZE1z7CXa3OABgw6+rumOxIR9hJedUGXwJcorYWKol0g68tt02K5CFR684UidVF1tF4amwuBJ3trwG5HNkr2m72MmTMD2Q4r4T5xw++GQ+xjP7XgntSCM3SbemS0UEtWouwDuqgnTZmA8w78sUJ9ms=
Authentication-Results: microsoft.com; dkim=none (message not signed)
 header.d=none;microsoft.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5529.namprd10.prod.outlook.com (2603:10b6:510:106::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.22; Tue, 12 Oct
 2021 21:27:43 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 21:27:43 +0000
To:     Dexuan Cui <decui@microsoft.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "ming.lei@redhat.com" <ming.lei@redhat.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "john.garry@huawei.com" <john.garry@huawei.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        Long Li <longli@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v3] scsi: core: Fix shost->cmd_per_lun calculation in
 scsi_add_host_with_dma()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq135p6q8k3.fsf@ca-mkp.ca.oracle.com>
References: <20211008043546.6006-1-decui@microsoft.com>
        <yq1pmsaqjrk.fsf@ca-mkp.ca.oracle.com>
        <BYAPR21MB1270CD89180A7979F34682EABFB69@BYAPR21MB1270.namprd21.prod.outlook.com>
Date:   Tue, 12 Oct 2021 17:27:41 -0400
In-Reply-To: <BYAPR21MB1270CD89180A7979F34682EABFB69@BYAPR21MB1270.namprd21.prod.outlook.com>
        (Dexuan Cui's message of "Tue, 12 Oct 2021 18:05:47 +0000")
Content-Type: text/plain
X-ClientProxiedBy: SA9PR13CA0071.namprd13.prod.outlook.com
 (2603:10b6:806:23::16) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.12) by SA9PR13CA0071.namprd13.prod.outlook.com (2603:10b6:806:23::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.5 via Frontend Transport; Tue, 12 Oct 2021 21:27:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 51d6f846-7d3f-4b7d-c7e3-08d98dc72093
X-MS-TrafficTypeDiagnostic: PH0PR10MB5529:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5529F884194BF1A660655AC88EB69@PH0PR10MB5529.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ENIHiEoZvu5h8i442ttaIXJ1yfwnSMpgM5st1j1JCEVpZqcin5kwpzKXn6ESFe1ktAQMgzqoTU5OFB+UW8e+QH5pTvKjW0KH4nHCenML73bJGni1yMFw7Wth739332/qOdBRG8zkiMFaPNZ6Wep4/FBrGt1WKYlXIFc3z06B+ey4JvHTNI1DFII3FqeGY8szlehC/Bd8PTUpEnAs3TVOlnnjmsQ7Jp6OkNG9y4Y2rW5uXCcWDeSX2dmJbSJGoHZYCflbkGMilFvo6d2chaBZvKYUHkC9qR5mgSCrGEC5sAzcbRRQ/BZUMo+/FFH7+7thZHECe9hBbNgCVtBPa3vKqeCeX8IhZYh0wahgvyNqNvSSugfhNnOXtUbKqDH0QUHDAdX7Hq8svLaNtxDnVefqVOFbhDLTyqk7gkQwWbfFxp46Qd9QO5kv1BxnOSnMU6GsTsIQzn0rBD8u644tL2BE+dUZjADatC/fq0G9Sz9uebR0JvYo800BHfe/8GjxiM3Q5IIAF+fgWlhfIHZupCFh/JjNAujxwgbxPelyov8+rc+HVmkv3/eSQATky1j0nr3x+y9u7BxBARvUZ3Xxq17Z+Pu5up6nh1mHmNftD+M4z9W2KYbUiw2ELH54io+g2ic4Q6EuUAgYZ1ALuKoNH7MV3ZRnKc25+GLILHyy6i/PsbnsKHPliJIZI7pAZx6vNvswEm9Gi9wzrUxC8di/oQ3kIQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(7416002)(316002)(38350700002)(5660300002)(86362001)(38100700002)(55016002)(956004)(8676002)(8936002)(4326008)(6916009)(26005)(186003)(66556008)(83380400001)(52116002)(508600001)(66946007)(2906002)(7696005)(36916002)(54906003)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VIUGggYFIGHwOKkKBL+K5i9rz90ZQzqCg5gpswU0PD/Rf+JigeJkcEhfbQ0o?=
 =?us-ascii?Q?e+FZfku69RkXvGscm+SeK9uShHTnuRzE851QDEMbtORAFfrYQ5QCzpsWs3zp?=
 =?us-ascii?Q?VL4SXHpY0PhkAbVEwFFlZyYn6IMVLTxE5kUUN4i9TV8CLK4J0c686mKNFISW?=
 =?us-ascii?Q?GKfF6NDzBDMROEd/Rm++gepJCx1Og4Pto2/X/+SFBHg4Ljzs+r4awr/+wvfX?=
 =?us-ascii?Q?PIWfF8TRZa4QE5Oip7VzCekLQDW7ElxQZzRCcUeCS0gvfXO6XZCgWMXvh5v3?=
 =?us-ascii?Q?XdTXIE+L5m5juKLpfzPnyPIitxgyxX/IqepzUsr+xlwQ8bGREIbUjOju5nNb?=
 =?us-ascii?Q?YW9SRVJZnb1P18Czf6L3HkAZVNcd3hmJFWHyiS5FCi21gczOv/EXERjt69kD?=
 =?us-ascii?Q?T9JY8HSTFnuC9L+pH7qG/02ienyr7DzVpA+F3crqshVq0gfUWwVMA0lGMW/x?=
 =?us-ascii?Q?+VDLkg3TUJ9SDZrwDIczarLjxzSbAO3QBBRkosfmFTf7rKLGHLSxdLlO/li5?=
 =?us-ascii?Q?xi3HJISXzduinS9yPZq8unxduorHs7N54UkqHl12FADmjCd7Tnd2ZmG6eoqa?=
 =?us-ascii?Q?nFvtJxT+ah9+Dr2oDP79G9jKOJL4do2Op4vvyY//YaS1zv8KnQfu3stYgJ4W?=
 =?us-ascii?Q?2vB7Wqazq8blyAVcQoh4hVU4xu4RJzPtdrIsOfEjCe+0fHfODFmgwMquiZdy?=
 =?us-ascii?Q?gxRqN6KpNRM9aIZlHAsBURJ6K9EShVaDCl4ps1W9pTRmg1mNSKROLdbxakiE?=
 =?us-ascii?Q?oDD6dyDmaURT2I0mAOKH4OsZnk0/KIbvyjP3rEJoyLTNOMTK1pSQd5CQxXKi?=
 =?us-ascii?Q?cauWk3wwmmtbKKGsyYUe5QGfHd9bl3N1zJ6TVcs3E5GiSjo1Ofc8/aN0JryH?=
 =?us-ascii?Q?3ZqsuQ0rd8JFUdpLc7YSJCvdRxMp1c3ab7yrXLwr2MiG3a2t8TKMvuYK25Qc?=
 =?us-ascii?Q?3xXT9icSUXqgI5AgWkS+UqIVZ5k0L5+uxM+dDZ6sCy5n76Kk8XBBiCgWThNc?=
 =?us-ascii?Q?ZRzmQ1KN3fDz38nAG1ffIsHcDvoLJtZXvdgOctjsMqRUFKxBClj9PK/t9ZSe?=
 =?us-ascii?Q?pBfi2rIoBKgnvefqonXUm8QPg7hYdqDsbI2U8z7d66rz3EIhRAXFTdp4kpiL?=
 =?us-ascii?Q?Ff7mqzmlbxQttrc8WCFezpOt04ZmqD/00b4jOt3wEaKD/NGuwNjJ4wS6XgLa?=
 =?us-ascii?Q?78mjwtCPXW1ZP/Ty0Yn7zncLCewhgqx20naj4AIogU7Cj/3DQlHU6OKx2arn?=
 =?us-ascii?Q?Q1h9hjaDf0HI0D0j9eatjrlwXtg8wklJ4IX64JaHCs34TxP9D3k4LaNYQBvj?=
 =?us-ascii?Q?/nMrgd3FxdymL1clkHdxfkWE?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51d6f846-7d3f-4b7d-c7e3-08d98dc72093
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 21:27:43.5534
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QvQsfzE2qLV2zhkNZEfYb8kq/0bQResBr75FUQ3JiMP992KnLHL4wlL4eBif6yRbkJ5izsObmCszw/oolj4CkNPJ1tSYT/PT9fNpeqqNkII=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5529
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10135 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 mlxlogscore=908 bulkscore=0 mlxscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110120112
X-Proofpoint-ORIG-GUID: dBOd64W4UOJdCyjv1FqcySQjY4nis8nR
X-Proofpoint-GUID: dBOd64W4UOJdCyjv1FqcySQjY4nis8nR
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Dexuan,

> Regarding this patch, I'm not sure if it's a "workaround": if it's
> incorrect to set a bigger-than-SHRT_MAX scsi_driver.can_queue value,
> probably we should change scsi_driver.can_queue from "int" to "u16"?

> BTW, I guess the "cmd_per_lun" should also be "u16" rather than
> "short"?

I agree that it would be nice to get all this cleaned up. Several,
somewhat peculiar, 25-year old design choices.

cmd_per_lun has traditionally been in the ballpark of low hundreds,
can_queue typically in the low thousands. And the block layer currently
caps at ~10K. Happy to take patches fixing this up, although I am a bit
worried about how much churn it will generate.

That said, I do think that cleaning this up is somewhat orthogonal to
the issue with storvsc. I suspect that allowing a huge amount of
concurrent outstanding commands is going to be detrimental to
performance for most workloads. And from that perspective I think that
the short->int fix, while valid given the type discrepancy, is just
treating the symptom.

Therefore I consider the short->int fix a workaround. And the proper fix
involves looking closely at things are scaled in the storvsc case. Which
I have noted that Michael is working on.

-- 
Martin K. Petersen	Oracle Linux Engineering
