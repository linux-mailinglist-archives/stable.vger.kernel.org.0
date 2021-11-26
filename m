Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED46B45EBD1
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 11:38:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232343AbhKZKmE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 05:42:04 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:61694 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1377168AbhKZKkD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Nov 2021 05:40:03 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AQ9QTbQ010888;
        Fri, 26 Nov 2021 10:36:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=PBx/A07C5tTKM4Gl1XEoXZ6S6MOvzitTPwKLjIbbTgE=;
 b=qVUjsWoSKR81qSSV0eHXshGHJZ7b+oh9i/UcikyFdUPyFx91HVj+pb0WGYK6Vz9xvjUf
 G6ZEcHsvhRAfTVgOZhMEHvojTqtcGIzNYKXApmwwJp5vXO5PzuROyWfs97/kxosy5Uy/
 M9S3pqVfhNQkZUFCFHiX6yZBq8+0gzvwz5tjUJZaGvK5Hl1YTOttjttUH1feBCuaos7Q
 X0/AsrO1gDzQZcRWsm6EJaPfKG+rwnxnrNTXnwMK3xRzaTluqKyFFWePpwNB8cBH1pvn
 99FzyCIe32yviiSV7/iN+aqo/2q8hhjqQFjkSh0V7aUxQNFfb16bzNQr3r3UsE912z/X FA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3chmfnb00a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Nov 2021 10:36:45 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AQAVWS3007928;
        Fri, 26 Nov 2021 10:36:43 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by userp3030.oracle.com with ESMTP id 3cep5515ra-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Nov 2021 10:36:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hKCiFkLBR83UQx7Zudlo9uVDpD2YCqZbmQ5HW+wUPAeRlvYxhE4Z2+6N9cMo2PF/a8484OZFfF3jiF3eWCbHf+Slh+Up9qJsxHV6Q1iQpbQdYPXtqvhczZOqKTkq/dyZGuGx31a6OZk8SqQZ5sENTw1lVsRax3r/EPCBg3gszKGDJAJkrQYPpd30K+gA1sbVQNe3103pGhAHOUhwC1tf9GXXEGi9pXcbNhdfX1vsvfgeBqHBmu7lozoyg5JfyStkItR1PQilcwq5CrDbxM5HoBawrnRM8qAMozpaoD1CjTWDT+kDPQHfRwQZqS7nORAPcJvoPHEL100aM8bed8cm1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PBx/A07C5tTKM4Gl1XEoXZ6S6MOvzitTPwKLjIbbTgE=;
 b=c3lwyVG8sWYFeCTzesEYq+YKlgeHlOLnv1DMLNjvlOQax3XIqNIs2+jeD1GaD3eQxjKheZvLBkukncF3h4CY21vkCrYn/zLYjMqipigAMIXJDH/SPxLBhPrzIOMeCfGjNATnkUv5N8Isl0A7Z4SWbJc66mEbqNbXGl1znHNSDBFaFBzCVB+FsDkIHEjMy1vr+Ax712MMWQLp6s58ec0a0HOGBBduYH1vwYN3eSVG2ZPs2+PNPWmWpr/2ZgQcieOwTetg9HASArDds/pbx7d2++pMASGV37SXB5JD4VCtpUGeGdlPbcPNfILvfYYJWBDp9VNgnvSfSmCKjYzjhLExFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PBx/A07C5tTKM4Gl1XEoXZ6S6MOvzitTPwKLjIbbTgE=;
 b=UQ+frktBIxiWCEppohPDq0VIrDmrVdOWurVUhWp3YiPX3mrNt8bVpi7gBJ7n2K0vbqbJ6zYue6ZBgXkQI/WgWqPPSxTi8IEEgJrVwjifh9B5xxvEMvW6E9qyYWO7gcKjQhHFvI4CDPaLtMTFjRTcW9r+8RF+Mb+/P6Ld7mmhJIw=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR1001MB2400.namprd10.prod.outlook.com
 (2603:10b6:301:33::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.24; Fri, 26 Nov
 2021 10:36:41 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0%6]) with mapi id 15.20.4734.023; Fri, 26 Nov 2021
 10:36:41 +0000
Date:   Fri, 26 Nov 2021 13:36:22 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     devel@driverdev.osuosl.org, arve@android.com,
        stable@vger.kernel.org, riandrews@android.com, labbott@redhat.com,
        sumit.semwal@linaro.org
Subject: Re: [PATCH v3 1/1] staging: ion: Prevent incorrect reference
 counting behavour
Message-ID: <20211126103621.GP6514@kadam>
References: <20211126103335.880816-1-lee.jones@linaro.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211126103335.880816-1-lee.jones@linaro.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNXP275CA0046.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:18::34)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (102.222.70.114) by JNXP275CA0046.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:18::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20 via Frontend Transport; Fri, 26 Nov 2021 10:36:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 94e99433-6ba9-4337-9026-08d9b0c8a265
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2400:
X-Microsoft-Antispam-PRVS: <MWHPR1001MB2400EAE77FB6C29342B9B1408E639@MWHPR1001MB2400.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1775;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9tj4PTkjqof3SVicJj4WD7Ut5Gc+wJCyvldA2eM2WS1Ghlrs+v/KvAzFWr20vubtC4o1fFJ+wRg8B9Njqg/PL5dbCIgTxFOOnnmXTeCsXaSJKCZ1kJq/7x6GmvH2M+1jOqJB94X4JtUGyyI9p5wwyqUDLnjE+lETMf/0SRynJtPynWUmgrLe0jXbrV5oFgUG889ft7k2IntE78eXMGZFrC1DxCD6J6eQ7LEx3cPCbO9wPMUxjZpr5SP+ZthzDf7sTsmVczoca7ESi835R583hhWtpNOfJlU+pZCgW7TpWTQXsUg1GgWX6n9/EVTVWA0Gy2adtB88XgtuyKb/Zw2JitrZrdcF36eJ76+8zy+lTfGVym3pL3QBpl5VNnVJgQV17LJJs3NhVN+mrtGT5YoEm3mXhAMqR8sPF6EgUBZrn8DSbZQJREz4MK+m+qY6OtSa2eS3CXQfr1bp5ZQU/VPLtOoAl4NNWQ8FMFkCnjdR+vN/kisrv5Vix4HIlnOkuWJAPhqSlogx4m2+g3GMMm/SJUaJE6S8b3BCftYBTvVWP+rmnydMAJ8WDXLvLnH6GvepamP+uPnGXtFYADaxPWPSwDWRxFvoqmpcZXcRQ92PJhPh/GMTKWnNNY0ShIyclWpYhpjcFB23gXCBjHEGYBI1gBwvuLT8Fm+hcRC3kkyDrOX2xetY3veAFJ69XwtOuofqo7FMRgWf6DwIpgE0EiUHVQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(6666004)(6496006)(38100700002)(4744005)(6916009)(956004)(38350700002)(52116002)(55016003)(66946007)(8936002)(33716001)(66476007)(66556008)(83380400001)(1076003)(9686003)(508600001)(2906002)(44832011)(316002)(9576002)(33656002)(26005)(186003)(5660300002)(4326008)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2+zmyFvB52gZ+ibPllEV2OCpdSqou0G8AOxzBLRY9jp5us/KSmDb52eBgHvV?=
 =?us-ascii?Q?ddwUm+sFBGbXY2s/lkkmyt6qZcWNyDOM2bX/KotCFLHzosBAxDqj3IDMh7C7?=
 =?us-ascii?Q?bWWeLDQweu3pYaJAs/jrN4OmEP52mMBzf492Bopg3GDfD9qD2Yfx5XKEam+D?=
 =?us-ascii?Q?2B0qTmC7HQOLfu0hv/XVhpn8ZGd4Tm+92brNCoWHwpqtUlmVRdWX15/HRUBP?=
 =?us-ascii?Q?WKAgnriEbV+tace7kKG+MxrphJGHkDZY1hHI88eIfzxd0Keg0lK4/hC9LSmc?=
 =?us-ascii?Q?sS9tI7vHQ/PcagkBSkq9q4LGU6Hq5cyuGxzzHc72Pst+gvXAvlao5SElQjyl?=
 =?us-ascii?Q?uIE2aNX5bef/ts7oPK90gmCMyO0pNcEF+u3qekMTzj4nP5FDhfPnPwty5GmF?=
 =?us-ascii?Q?dOkNPyvyYK9PYEHy1dwf0XPQSt/ffp0gGWTgjWqirGlqNzfZOlMUB0ekX2FQ?=
 =?us-ascii?Q?xalkV9d/5T85AR6XEwYi7XixmoCFVcLm6VoAN+ZCEBDQEOpRhzC97J0QDoPV?=
 =?us-ascii?Q?HtRcMo1ru259AVWy/nnVxO27L1K+sbhMwpaK1bECjpaauM0jIxnKU7vEu6Zi?=
 =?us-ascii?Q?8kz4lZybKlWBiGhYE7ETAHHCUgnefiIl/yLDDANF1iBCSJ9wiNO4ijVYWTqZ?=
 =?us-ascii?Q?A0j4EmT4fghFTz6wzaV3pR7wOSPDyHfLqa3sGPGQcSqAZAMJrP4gDfrHSeXe?=
 =?us-ascii?Q?kFDmKKndtSiNuoqHdFM2SOMiozywdR8+emYKkKwaz1zlkHzY94CpBBM3dsPj?=
 =?us-ascii?Q?nCRJG6N8A4P3U2Vxp/BGQ9gy5gaEQ7oLe5OMLxkUjfIwpst1lPdAHtyl9G+o?=
 =?us-ascii?Q?AD7oNLxTjXRQzPZxumpMgUcWdlaC7J2NPWIh/HjmKYd3lvgC6fmfEtSbn8/Y?=
 =?us-ascii?Q?Shr9yylpQTPYFdLGnHVUKyjB7zrEfv/kVJbjePwHrIVlpWe5OS+zXLCDGJPm?=
 =?us-ascii?Q?IX32O0VJ1sZTbWpnESnEfkA11piu7/b+TvBVplHPCnSmccyygbKrKhubDYUX?=
 =?us-ascii?Q?Vr9ZKWTVcuk5fOTQnsyCTknk5GbvIH1gu0ROgPnUA7JuAllaFX91Xr2TLdr4?=
 =?us-ascii?Q?N31H21ArZp7M8122eldSlTFwYfx3Gu9+xs1jwUm14/alRcMgeyDsybL3Fj1t?=
 =?us-ascii?Q?EbV0rkrChotXTlcEltmi+kwQlZTD5jUin393zwqR4pU5wRC+mj7Uy+X3DIuD?=
 =?us-ascii?Q?6Vqwxt0z+iee1C1LZE2LCg71ZgolFo77xPAmnhcmvoApyoVC8bbc8AKQ5nZR?=
 =?us-ascii?Q?sP8sNA86Q+0ie6qyDCVS3w82DBrNwjig/JNPcSQ0JuXEnDV0HWW9mAcx1973?=
 =?us-ascii?Q?2THOwd+107Zzf30LZv9Cw5UB20tOnI6LcOFz7S5WI8PiqtXcM7OCGGZwarVy?=
 =?us-ascii?Q?6J7cGWVLJEkX2bHgmZcoszh47GMaJKcBFavoq3XqfWETW/YFrM3g2NhV8exk?=
 =?us-ascii?Q?Av3oLWcI9KhpgUG09ze3ynOugR7Or1wvrWivk8d23+fG0dCHo9aGU65OnTP/?=
 =?us-ascii?Q?oKL1uU4kt4RKARutymWdMVcMelolQLzBtLX8gbS1w9Jqkgai8YAn9woVG4Ur?=
 =?us-ascii?Q?IwVFeRWQWM2qXM1jJtv8Df5/ccUtpx3HfNwdd82aXmiaxi9lsDE92RhvtXm3?=
 =?us-ascii?Q?hiD3+1nm1IN+W2nH917C5M+kxYO+5wJdhprPo7NuLwQGrmFsWLG1ozQ0g8Hs?=
 =?us-ascii?Q?uNFSfO+htOdIMhY4T5kdiPFNrEI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94e99433-6ba9-4337-9026-08d9b0c8a265
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2021 10:36:41.5637
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vpS4xwiczgHQW/BUTpQbtSOQfzyvgJpNS0Qk9W5qCQ+C9eoC0xisztkqR9NBNTEAB6lenyO3w61fteAnjGCl3ZxJQY7k1f+hllHcwMusvVk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2400
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10179 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111260061
X-Proofpoint-ORIG-GUID: _bqH1Ohoftyi4yRXe98bIW7ryL8JbnG9
X-Proofpoint-GUID: _bqH1Ohoftyi4yRXe98bIW7ryL8JbnG9
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 26, 2021 at 10:33:35AM +0000, Lee Jones wrote:
> Supply additional checks in order to prevent unexpected results.
> 
> Fixes: b892bf75b2034 ("ion: Switch ion to use dma-buf")
> Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
> Destined for v4.4.y and v4.9.y

Thanks!

regards,
dan carpenter

