Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3FE42A9C9
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 18:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231742AbhJLQoJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 12:44:09 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:29934 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231683AbhJLQoI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Oct 2021 12:44:08 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19CGNadW010933;
        Tue, 12 Oct 2021 16:41:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=ou4k055Zuwnh81vufDUMueumWtzZD2Z4guN/LX1wS1E=;
 b=DUj6wDfW6trxiE+SXeOTTWgmLSVWbXIuubcDop7Wb3LsUStsrwTXyvztFMA0VcCL5XTJ
 aHZZdvNhVBoRY9nRfsBxmdwgj4k2xl5RLRJAthpuTlFHlsOacBafqmk6rFrcbB6Wlmas
 N5ORpdpdpki9VA0AjAgmm2xlOXihiDJRn5kjXk8vxh/5e3+FlY2DO3vWtM7QT+Oz7eZo
 ao6jLphFJmOvNhKBAgbQn/QkxOmnhzHs0vB+jdqhINsBsMENT1VXXSLsWARM2poLg/fA
 2+8mSZHSZ2iGkn/99DIPKE8eH/vF4UPao03tjMz9YEOVe9lSY0ehO1+ymVHBHl9lDzkn Uw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bmq29svts-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 16:41:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19CGUP5I134997;
        Tue, 12 Oct 2021 16:41:52 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by aserp3030.oracle.com with ESMTP id 3bkyxryuqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 16:41:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d3IAfodXR1qd7orvyPZiBxqsKJeA3cpD8eNrMq0yvZEZvo0Gme0bLjBoKO/FT23xja5yV20ZsNG08opDE1WtnnhUkhXXoSKNRdqivP7ablafFO9sHB7/ulTb0aKs4Hue/ILEb5cnDp2lhuIJfT4xwZusfSZXHsZklvWeUFkXBKs63u4FBK7GTnERu+EwKhhxWhTX7gyszxnqOkkCYmL3gFsAIJKBcLNcPSLDjPg7hJQ9cBWv19oP4cvMEUR1h2S9q4TIfR1/qFVKpVFwVJ6Y5j4R91mlqDMvZ9pWr6GRWzpbTNQfk3o2TYs58xvyypwZkTX+EYNSbWECQIGLiVg19Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ou4k055Zuwnh81vufDUMueumWtzZD2Z4guN/LX1wS1E=;
 b=VKtyqRNJvnHvtmvCbDpzrDvh/jym0IhPK1iHPM6qRnpGcw1dkAu/LwXOfK96NOeLb/kf/ZknqSdqlFtQylWYsO+DEnHs/RaNU/owBbVCux+Ri4EIemqRX3eotpZxKMLgaMYkyORnS0YdA/DtmNB/zc6gt0qaIgJfEIX191iY5AgJgo94L3yErSNs6CyhvuG9ayMQmZE8DkR2R2Uqg8sK2Cxmdy3On64t9zeYpehBiVg2Z0slayk6hX+hniGJFnO9cIUi5z8CqOgvLh6S8GlQQSgqE8FoQ2lc/bYSPSyMlFmjS5yo5Y3/YWPmBjXYokC3Vi+/N0d7aIRBVniBBKGQIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ou4k055Zuwnh81vufDUMueumWtzZD2Z4guN/LX1wS1E=;
 b=THGtlxu53hhkz2XzSz7LoIn+xDefM332sT611TFHr4EsDkNkUM/CT9e0t5OomnG5cJvOMg6y8NbaMCi+EElyqz80pJPBMpxqQzd6ablOyH6iUbyqLLB9xfFeBIS6tNrROZIrrBQ+8RIh3qYt4Z1+orYPSvffM0HwJg/m8imYeaU=
Authentication-Results: microsoft.com; dkim=none (message not signed)
 header.d=none;microsoft.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4566.namprd10.prod.outlook.com (2603:10b6:510:36::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Tue, 12 Oct
 2021 16:41:50 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 16:41:50 +0000
To:     Dexuan Cui <decui@microsoft.com>
Cc:     kys@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        haiyangz@microsoft.com, ming.lei@redhat.com, bvanassche@acm.org,
        john.garry@huawei.com, linux-scsi@vger.kernel.org,
        linux-hyperv@vger.kernel.org, longli@microsoft.com,
        mikelley@microsoft.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] scsi: core: Fix shost->cmd_per_lun calculation in
 scsi_add_host_with_dma()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1pmsaqjrk.fsf@ca-mkp.ca.oracle.com>
References: <20211008043546.6006-1-decui@microsoft.com>
Date:   Tue, 12 Oct 2021 12:41:48 -0400
In-Reply-To: <20211008043546.6006-1-decui@microsoft.com> (Dexuan Cui's message
        of "Thu, 7 Oct 2021 21:35:46 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0601CA0004.namprd06.prod.outlook.com
 (2603:10b6:803:2f::14) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.24) by SN4PR0601CA0004.namprd06.prod.outlook.com (2603:10b6:803:2f::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.14 via Frontend Transport; Tue, 12 Oct 2021 16:41:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 25b22265-d10b-4583-4d5a-08d98d9f305d
X-MS-TrafficTypeDiagnostic: PH0PR10MB4566:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4566766CA5E62953A54F24248EB69@PH0PR10MB4566.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1247;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bv2I11flZtEW1CvYW/VpMvGLJsTQ8AQPRaeQl3GvFC78LyRnqberfYgJRGPbSm+2IIf/HcMdq3oJ8XK6u7EnKIHyyP6McTc1RzL92/YWPgzGLkZtyDrpvPUpzO1YxHPuv9xiXv5cwNGjw3NpLYt2+EfnPdN/qg9pGrWQm1QoCwyXcblGtDS1GGNxxkCF066SkCIhu7TEdUrFGT75ITqejgBYPnL0RHw8j8jSimgOUEvv/6Q5mLLibefsZYs9p8nJvCWhBHyrI9uzYNVZtkKGOhCxbH0H/h96qGs/i/CJcFG8U6ueC4+jPodAhWblkkvXpMkJnew11Zc3sLH5gFVEWdWO2dZAcnx8dujaXH0bQn+fkDWtGp2FK9+9V3Z1C0JrHMnus0KVvgcXgtfPqimhiPhGVvHOyVQQ+DZHvgWi2essjZxZf0xZepbjN+iUr3aU3yq8KDViPD0B51SU25Sc7UldDo7MZYrXy6/DedDLwu1tNh6T85g118blzb4dFy9XVvSLdBbYNCy8G6w3r7yDWZGY0b+A3PSUwc2qTunF6brYxsjW8IY3t8ZZak6p0IbqFsZq6hW+8xffCvULf3Ofs5NkrrKF2LPNgd4WEXsyn2ilnQ/98z00CvwG7YkyWZ3I+izyE22iKG3m6Szif9cQMpHLEdwq/p7IL8qzN57QOfrIHd9L7DaK/rOhm6HWdB/sTDcEkYAfPA0KyU4U9xoHuA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(55016002)(956004)(26005)(5660300002)(38100700002)(38350700002)(66556008)(66476007)(186003)(7696005)(83380400001)(36916002)(52116002)(66946007)(6916009)(86362001)(4326008)(316002)(8676002)(8936002)(2906002)(7416002)(508600001)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6L0D6AZBOU4xx30nCpCdb+Z1Pfx2jilRcQknLpj56Dr0Evzo5eGFH6sUlQMr?=
 =?us-ascii?Q?57J3MPJMb43/L8rcEOysUnXN84/6ZEp/7/EWj5MWRD0GY3mLAxD6BZME896N?=
 =?us-ascii?Q?efxZZB+b5XrRaQ/Stg3NbDbzaF4diVo++LN5zkwHjQmHt8w+/aDuE9SnrU94?=
 =?us-ascii?Q?7Z0VGGx/J6imFmoJxViKgGWW48c97UJaA0juDvWZzw3wpW3ZDHYWUTDe+EhT?=
 =?us-ascii?Q?8sO0Q4eltjG93kPV//N92vNxIG2pdoe8uO9ErcUffZ6Vl9SD1WyQ0F7P/jCO?=
 =?us-ascii?Q?j604V0Nh68Jc/lLprtxgzRMRIsSSiUV+64TGwdsnMJwaSybbkAjyd0D5bfAe?=
 =?us-ascii?Q?pMqJC+sk4rMMzQq8U3Wa3E4eed2Wbes7KTvYkbrayGXq1/SPuYH9jTtiQhci?=
 =?us-ascii?Q?NE9g7Fw5qLNcxar9z9MxcbxtMKbsdzqXIe/gHhK9xIfESO9nFVwh3+16Cqvs?=
 =?us-ascii?Q?jMOKzfSTbc7RwCE1AqnDA/fbEvWcSsnrsam7E53OveKIK7H55wXld6YhKx75?=
 =?us-ascii?Q?QaeL9IJUIf6nFKMoht7dpSP4AM7YfjFyF6iuzJDEwXgmbGTSr7+SwVfRLZCj?=
 =?us-ascii?Q?l65j+Lj3K3pu+9nBUsT8ui+7TY80Ezh1tgR2iFNqaPBD9/TxmedwXzfeeZpJ?=
 =?us-ascii?Q?OuI1VauWZAcYyJAEu2THN9hJV805zbd0fXJXZIUJ8vY9WxEND1QFxWavms34?=
 =?us-ascii?Q?u21gOOnFDzTYlXQ5WuXUQabVKiUN4ON7TsY640HAwUhFq/Ogxmaip9bD7sxL?=
 =?us-ascii?Q?VvkdeM7pekpfS1uUR4HeNDR6/Xgr98UNJ2GqYFyz9sBaJZvTog1l0cM/hfut?=
 =?us-ascii?Q?tU0xpiO1exUMOx0TY1r8SxVxkD0LXU/C8xBFpdWbwqoDTjiOoZOwdwAUAyRd?=
 =?us-ascii?Q?rhKyS/jnwX37PcOYPh4MpzEHJ8GCRALeOsNPZb4s3Gaebwb5RM9lHgULAVBi?=
 =?us-ascii?Q?iZRY3d1xGt9HFgf/3OGTSlNn7A/wzzizkgMtrwFlmNuEBPzMdtbvl+8bp61Q?=
 =?us-ascii?Q?6JcffLja+pIsVxSJhoVqky6R7SQ0pPweG6Y2ik4dbVK/nIWj53MnaIODflU9?=
 =?us-ascii?Q?PxFDO599e/bIPdEdXm41JFeY5b7aIyLnqFoZGDe35LiyovY8C+rkoQvhl5Ue?=
 =?us-ascii?Q?T1zcy/812fVjx8KUJvBVeoVfosrS49vTGE2Uw2rlwuPiLkgmpeA9c+icM2Vl?=
 =?us-ascii?Q?dPkH2mvqqAKXQy8a/2vvyLF9ggAY+L54VKWeFT+NlMqJ6wyex4YXGZK17rC2?=
 =?us-ascii?Q?iUcEaqd7CQ7PXempnv/uQ0u8f9lGqnDne3fCOop33r71e7BfvRpuDt3jnJ6w?=
 =?us-ascii?Q?tcylX2pxIP9DK7QfI3rxlVbG?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25b22265-d10b-4583-4d5a-08d98d9f305d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 16:41:50.1279
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: clNdj6oNEyO64lQ8kERknvnBLyZ+S8knwMqH4XqlSj0LgT7lz3smPnpvBXFeKtbKRZniw/mumPeDZ3NiuiVUlv0R1Reos8EGwheS3yt0iBc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4566
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10135 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110120092
X-Proofpoint-ORIG-GUID: GHQwJMqfHEPdyLELBs56Gl1BGY_6ZBfY
X-Proofpoint-GUID: GHQwJMqfHEPdyLELBs56Gl1BGY_6ZBfY
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Dexuan,

> After commit ea2f0f77538c, a 416-CPU VM running on Hyper-V hangs during
> boot because the hv_storvsc driver sets scsi_driver.can_queue to an "int"
> value that exceeds SHRT_MAX, and hence scsi_add_host_with_dma() sets
> shost->cmd_per_lun to a negative "short" value.
>
> Use min_t(int, ...) to fix the issue.

I queued this up as a short term workaround. However, I am hoping that
the rework of the scaling code in storvsc lands soon.

-- 
Martin K. Petersen	Oracle Linux Engineering
