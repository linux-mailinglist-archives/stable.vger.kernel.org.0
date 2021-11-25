Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC3F45DD32
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 16:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234557AbhKYPWj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 10:22:39 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:19376 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237620AbhKYPWD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 10:22:03 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1APDTPCP001306;
        Thu, 25 Nov 2021 15:18:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=XqkVrGD2w6lIQ1iqkL4DP6KecuqQRIvSlmEU/nQzXsk=;
 b=tho8B+4UCNFv4B/NBVgPwfAHNVkzIc4ZOBYI2ZL9jFO8kaGrdxe71AZEceX1oFUN8ZE7
 E9gDTwW9JcP1JRqs/IskwSEJCYoCgEaL02WNK0bCxjMqELEeVOCcdMnuHwuFmqySyv9d
 H4srDcw/xqmw8vw4RrR6pDUW7Iic6O7d4zARu87A/iGYIrkDRQof9yLtbZg7lkXPHrxu
 yqTnbqpFEqASbdoMu5JCyAik8ROU80gktlM7cUgvXQ8ETbaOzI1Zt3SIW7Zu5OWpUYLW
 1HNnY8M+lDZy9fA6G/+FL+qekvqNJ1uMoJxXeh9KJBbf5E35IEnAPWlP4fMWfC2t4RJA 4A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3chkfkfyg8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Nov 2021 15:18:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1APFFQbR134923;
        Thu, 25 Nov 2021 15:18:48 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
        by userp3020.oracle.com with ESMTP id 3chtx807xd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Nov 2021 15:18:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UNhDSZsPj+qbfXjlyaSvtUdmdi+61yfn70ZL84WMxr4GrGERemkjwwLSO0Or9JArenE9VLFZiOn2sylBnUQw3krU7uyTR6ADRpBV+NBZkqZJgj53d26IzslbnniAPfWoryPaQq33OIHaGNuA3WUBmfOA4W/rjpn0P5yd0n0zAZPMw5cIk2VfMd54tBV/BrXO72tdpoHuWp81b/AZ5Urj/lEaGtERopzlA0eB6DRr+/9PdJKr8aPf2NLMj16DJCeDtpH2BhVoMQCLZig2hIL1jJKRnsKP69jaaphFTL0Gh+7+0NqA2CJwppmmgFvD9AcmBEEQn+ITHD+UC5irMnb3aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XqkVrGD2w6lIQ1iqkL4DP6KecuqQRIvSlmEU/nQzXsk=;
 b=BlM3lptGUXu6uNk4usrNhAOHmypkPB3MPIe0aIVy4MqN1XiPyskfII3S/Eik+xcLWNH2kqS77Rk230nEnDwnlZHMwt7WCuRYZ6Vp8vk9M0YyPqztS162g354Ij7UAD82l2hudGzIBUSxMr87PcucAH8acIk4KyQ9hZG//Avm3CHXGPxKurYqjRY2oGBjoElIqyasBXkauFo69ThnULju95o4iPvGPmx9Pb/5oSwRCEUK6jU9+PE6qWJqorSSyqTT7rf+QR+4FptYW+ayezStniKnZ8VFHqUG3qLlzxA7fSKqOa/IMJX49sxZqrxPU2DxM+usAHSSa/gqrwgpQvDYRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XqkVrGD2w6lIQ1iqkL4DP6KecuqQRIvSlmEU/nQzXsk=;
 b=oQriuz6+8+7nLfmOX2cK4QqpizIjlbg70kARmPysjiV5mCsVIWUToAGwUqnH9noNXY4q9A/8DcyQip00zZjXHCSSLXIU5VzeUXnYPuQbhQ0x7I1kZ+I/f8snT+XaPf7eZZL81fMoPp55jFHcx7kynenbbAopRmLD3UQEvUfslG4=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1726.namprd10.prod.outlook.com
 (2603:10b6:301:a::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Thu, 25 Nov
 2021 15:18:46 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0%6]) with mapi id 15.20.4734.022; Thu, 25 Nov 2021
 15:18:45 +0000
Date:   Thu, 25 Nov 2021 18:18:22 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     devel@driverdev.osuosl.org, arve@android.com,
        stable@vger.kernel.org, riandrews@android.com, labbott@redhat.com,
        sumit.semwal@linaro.org
Subject: Re: [PATCH 1/1] staging: ion: Prevent incorrect reference counting
 behavour
Message-ID: <20211125151822.GJ18178@kadam>
References: <20211125142004.686650-1-lee.jones@linaro.org>
 <20211125145004.GN6514@kadam>
 <YZ+muS7vC5iNs/kq@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZ+muS7vC5iNs/kq@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0059.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4f::12)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (102.222.70.114) by JNAP275CA0059.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4f::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22 via Frontend Transport; Thu, 25 Nov 2021 15:18:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 04277eb2-ea9d-456b-1943-08d9b026df6c
X-MS-TrafficTypeDiagnostic: MWHPR10MB1726:
X-Microsoft-Antispam-PRVS: <MWHPR10MB1726F31CE78CBBA78BA0C6B08E629@MWHPR10MB1726.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UrOrHJcBIT1maMxVF9OKVHheTWQoA+eoV2DA2/6AWszjXDAZAecW6GdLBepoG8jxurAhs56gTd9n9gnQoTFumDdSKuWE76K10NEIeVonb540N33Yxy+DY9bogCGD/ypG6w0WlopptjCgaW9piGIsTjKsFJKUCCaG+o1vh/40/BRNLkJBDR0l6iPwb1MyjIjQ6hO9iCW1v5k7ZN6CfJJ4zndQwdKbAhYWCUkOID5ubLluNWOQO2RiVP8eDlOJ+glurMP+IMDPHhplHeByHPnugz/6e6mZnG0htvlZgxJA5Nm2BXzGO9uC6vdfuXSxPhOjAWUDiAY1O4DJCOIFpWQKKjKnfaxGdu+F4ZhhXPvM0x3124Au5qtlBK1Xw5ZKrsCM1nhzYlCsIaEB6OPi5n7SqS/nAGZo5wvVmAQnmjihREkwNYyfPugufMtPVCr7dhXUINKb2Aw/3lOATo2+dfSifrYmQZ42ySjDfHcSckESXr0il+yAq+z1MGP2naTLSk1f00pZF+UbePF7qxNxdOakEDW9+L7/qu0auc3UDZZVlUj6NKJf16kXiHrx1i78CICaItek6Gf9dDPRjob+XI1/Z/KM6+jz5Z+eNHiPKT9sJ0TlYbXTZTuGK281Ds5554nSMD61h2kaM6quWW/e7YOxVpex0OkJAQg6QVv7OlLhP35QQoJN5kbmroQ4CXwMw4CdKi2qQvDRRRUrJNip8yOy/IdxDBbTjBGAcR6NSUsqcp46PKGb/tnp/Iy54Gf67e6pm5Yg8EcoQL2ZZOKlOclV0u9KipAIAJOAn06YSDDEcaQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8676002)(66476007)(186003)(26005)(44832011)(83380400001)(33716001)(6666004)(8936002)(66946007)(38350700002)(9576002)(55016003)(66556008)(4326008)(86362001)(316002)(1076003)(33656002)(966005)(508600001)(2906002)(5660300002)(956004)(6496006)(6916009)(38100700002)(52116002)(9686003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Cps1pgBcYp6oGxTo3KadvXRDZSisB9d2oesoCs+7jK0pQYRghm/ZjoVZjqvs?=
 =?us-ascii?Q?XC/dZ8BXj9BQ2DRgRoMjJCycnt8wTlQ6QSL5IY+npNV0SFtd7UslHqFu04CO?=
 =?us-ascii?Q?5QrF6wvXmRa6vXG+AgPsoxKIcqTSt8lMxjQX9drtYeXz75UQi7csSIH0GCq+?=
 =?us-ascii?Q?/KMheQAWTWXB6OfDCAk4Vf2Y0rypviGJAWzXHb39/dcm59WL7yLH6GLIAMTb?=
 =?us-ascii?Q?HKJRiWTNiBU2aBGVoIZZ3rzWd4kyjA3DvOMaRv1kYOVIJ1jWW/Q5jLJEmm0u?=
 =?us-ascii?Q?VfiWQBOg+bTEt/ElgR2DV6jMEjgWbUT318DqyXF2z4baNtHTP8IMxytw5DdQ?=
 =?us-ascii?Q?PVrV1DdqCmKHvOgFGY4wFCU8aOKg2AWsSSdCygq9zDqOEelzWjUAC3b1fWU/?=
 =?us-ascii?Q?mB8gMdhQ5vqCbcpiD58d/xRq7bOLzz+4P1r0/EUWNGDK3MLkQgIVhRaPTIDY?=
 =?us-ascii?Q?+kWU9IUutuZRCed92/T7ppZa6TtFumGaJdDumJ48Y0ctLtCpLuR2rbDMB8+K?=
 =?us-ascii?Q?HXH1m7K7IXyeGacgVclRa0NjoC90sNBhhqjWDaPHAkg58QD7dgDoI+FuZ9ee?=
 =?us-ascii?Q?0harZQxP5e7lQozMFfyX2cIGpHTnTzMQO0jeMZDaEfnUAvGJx9CRSakPcImx?=
 =?us-ascii?Q?L4hv3xabWUIssQfzP2Cpwt9BEZgvCYESfaQw5QYiaN+e+vLvzrv+xjSR3Gfh?=
 =?us-ascii?Q?6k0ybze/cV5BS56gm6Vv2rGojpmgmPqPkLhisG1rxl4gU9qfZK694KfpFvhj?=
 =?us-ascii?Q?rr2cBY2VOvICTXtilIbJwbZBVJ9pBB/IUIY6Tbmeld+5ZaaWbN/5cb3S87Pa?=
 =?us-ascii?Q?X/Tcbu77G8I7Ef7qg0q3GSZqnrhk7M86zBgMkvg3RbRHRRkBWvyF/FL2hrZ6?=
 =?us-ascii?Q?A1XvTh36qq1TFrHxrJqjNrVpWwoTpdWs8Zn8lHuK6jd//eHe92NceSnAI+xE?=
 =?us-ascii?Q?etQMGMTkU/PSfHwv7dcrxAs+4o4b/A2gIsPO5NMNMSTaXbiiCTnL7S226yBo?=
 =?us-ascii?Q?og0MEU9CSR+82VwOxD2a9AnyqDR56JWlTJVm8X5d/oJdiLEuvvOqrwzpSKGF?=
 =?us-ascii?Q?thE9Hb2PXjKvt3dMi7IuFqivPsQG2VNCQ5WMYDP3bR7vnYQ1tTbxvq/Vw5W0?=
 =?us-ascii?Q?if2B2UYO7gm4TtM+NmY14gRf6M1kuS1g49iMPb6/uLT0DcU1wdBI7Z3mRWEI?=
 =?us-ascii?Q?6MxbG/RnZpTaj5Ia7B7LHGe6uXPAXSD1rRUqb3iAHE5rlKoMHKzphPwnO87q?=
 =?us-ascii?Q?6oo1KpYv3DgDhPWC5rivpYkj2JUlET/OU1yKrnIQvpmhe/pQAeQ5JxvJXHt0?=
 =?us-ascii?Q?NRzucuSJgWbXgm4LlwISTI+O8hB6xEn8Whc/w4gobwpwjmVnJjHfubeBfv0H?=
 =?us-ascii?Q?D5g++aV6f6Q0so7cqqMFPT5PUsgWU/351zI2t3gKzP/EtJqRV/ABNT3ayDE7?=
 =?us-ascii?Q?LEFtyLYWkbH5ZGDmuCC180OCgMbgl9DlNwr6a+EUc5jPyUpxpQznT6C9Kz5B?=
 =?us-ascii?Q?R1/aoIzCprGbiD5yGaQMywwpqJHdrAF4TLGm6/Hcq42/iRmoGviXlIo3u16/?=
 =?us-ascii?Q?FhLJmM8u5EKPjM2Cl6G4QKjfJLUYXqd8+XQHs+MpbrVfSay3hjaadaZNZ2oc?=
 =?us-ascii?Q?4jAbwJ5ezw5o2wraJpXqF3DJ65vuI8Ul3+b6Z1KEml9UdHEfCushOhh9lg9B?=
 =?us-ascii?Q?OgzexTE3U4sLIoiScQvdUUUGLhU=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04277eb2-ea9d-456b-1943-08d9b026df6c
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2021 15:18:45.7712
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Klj3rWD+e/QEZwXKUrj884/izMj87d22MBAGOEEIMYW/nWla6Wc6czX/s/EOERBLcqPxKXAEdwtS9rutKZmiJVPeKxw27vY2u3PuB63rnTw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1726
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10179 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 malwarescore=0 phishscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111250085
X-Proofpoint-GUID: 9-rx7-q6ziFrw9GARf0FkMNl9wRZ8pFP
X-Proofpoint-ORIG-GUID: 9-rx7-q6ziFrw9GARf0FkMNl9wRZ8pFP
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 25, 2021 at 03:07:37PM +0000, Lee Jones wrote:
> On Thu, 25 Nov 2021, Dan Carpenter wrote:
> 
> > On Thu, Nov 25, 2021 at 02:20:04PM +0000, Lee Jones wrote:
> > > Supply additional checks in order to prevent unexpected results.
> > > 
> > > Fixes: b892bf75b2034 ("ion: Switch ion to use dma-buf")
> > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > ---
> > > Should be back-ported from v4.9 and earlier.
> > > 
> > >  drivers/staging/android/ion/ion.c | 5 +++++
> > >  1 file changed, 5 insertions(+)
> > > 
> > > diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
> > > index 806e9b30b9dc8..402b74f5d7e69 100644
> > > --- a/drivers/staging/android/ion/ion.c
> > > +++ b/drivers/staging/android/ion/ion.c
> > > @@ -29,6 +29,7 @@
> > >  #include <linux/export.h>
> > >  #include <linux/mm.h>
> > >  #include <linux/mm_types.h>
> > > +#include <linux/overflow.h>
> > >  #include <linux/rbtree.h>
> > >  #include <linux/slab.h>
> > >  #include <linux/seq_file.h>
> > > @@ -509,6 +510,10 @@ static void *ion_handle_kmap_get(struct ion_handle *handle)
> > >  	void *vaddr;
> > >  
> > >  	if (handle->kmap_cnt) {
> > > +		if (check_add_overflow(handle->kmap_cnt,
> > > +				       (unsigned int) 1, &handle->kmap_cnt))
> >                                                          ^^^^^^^^^^^^^^^^^
> > 
> > > +			return ERR_PTR(-EOVERFLOW);
> > > +
> > >  		handle->kmap_cnt++;
> >                 ^^^^^^^^^^^^^^^^^^^
> > This will not do what you want at all.  It's a double increment on the
> > success path and it leave handle->kmap_cnt overflowed on failure path.
> 
> I read the helper to take copies of the original variables.
> 
> #define __unsigned_add_overflow(a, b, d) ({     \
>         typeof(a) __a = (a);                    \
>         typeof(b) __b = (b);                    \
>         typeof(d) __d = (d);                    \
>         (void) (&__a == &__b);                  \
>         (void) (&__a == __d);                   \
>         *__d = __a + __b;                       \
          ^^^^^^^^^^^^^^^^
This assignment sets handle->kmap_cnt to the overflowed value.

>         *__d < __a;                             \
> })
> 
> Maybe I misread it.
> 
> So the original patch [0] was better?
> 
> [0] https://lore.kernel.org/stable/20211125120234.67987-1-lee.jones@linaro.org/ 

The original at least worked.  :P

You're catching me right as I'm knocking off for the day so I'm not
sure how to write this code.  I had thought that ->kmap_cnt was a
regular int and not an unsigned int, but I would have to pull a stable
tree to see where I misread the code.

I'll look at this tomorrow Nairobi time, but I expect by then you'll
already have it all figured out.

regards,
dan carpenter

