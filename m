Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C874449CEA9
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 16:36:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234332AbiAZPgK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 10:36:10 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:15052 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243018AbiAZPf6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 10:35:58 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20QEXqDA006704;
        Wed, 26 Jan 2022 15:35:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=QhUh0kRD1+6zOI49b+lz+j1r4nUKUy5wvJ0+kzXpYu8=;
 b=uq1hWgcRcjEyEXoYzaPpIaB2EnvWM9RkIkdW6ieyI242GqD8GGC4q8BsRYxn1B6Pc+M+
 O/vlXze5OZ2G2mXlH0gz8Caq4Kni1IQKVBBElE0Acr8eSSlHYtcy+pJh4H73AwTLbVFU
 AM/WI42D1pDqz6dg7d4EwSAJl6edswh+4R/2T6v5BIcZPo+hD4Hov0gk+3ndU4s3vBOb
 8XzChOzWWeABiY51Ymxfqz7zh60cI0yilJfEeR/Ste1ch19/whqHLxZ/NyCtOjdRE+HD
 sPzZs+pRszpHm/fx6Dtvfl1kaiPQ8X/QGvCmVvza4WNfQlkv27RKt/ABF1jRrIkJ4Oc2 yw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dsvmjex3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jan 2022 15:35:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20QFWUrb013273;
        Wed, 26 Jan 2022 15:35:24 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by userp3020.oracle.com with ESMTP id 3drbcrbrq2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jan 2022 15:35:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EgiJXWkKg91mRASZMPuIF8l34UYfJzGkovnyE6wCRrSzomMCcVBORZpuOFPdczXS/K1lf/I8YO9UqKf0Gyr3DJZvdu11eO8OZ6s3C3S/SA3oJxue97j965OvEWRdzBRTQ6Qx79UEcljvLJjcb3bP8R62Sy11cpN3R3NG4u9Y2lE62Jup4xxuAk05HX/l5oylxfLIx53YoWieT0FN9ltTlNH3gLk/V53/hZNc23g21y/Z8sC97bLpguK3qBCR40LK265uJdDHHlM8KCydZPK3prLn1HocD0HZBELXZpzUj5CVmCDaDBh1FvMD+WJ/R6BkllpL9izDNPQPZMIdvSpmoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QhUh0kRD1+6zOI49b+lz+j1r4nUKUy5wvJ0+kzXpYu8=;
 b=Pz07poHISCJGGGFFMSwGcwrOBCgtFlRF97TtvXyum/gghzCUpiuFdVK56ZS0khzl/mQ8s3FEh4X59cHDrsBv/P76Lg9g+6K+312xW9S0YE554mM6E5TPYjYmUoXL5V6GN5HN9orjVU4IbHb3VpCX/cNM6NyE+nbPn4zyc5AG/tanoyEj7ijnJWYnZM1/binghtzF3+3/tObEncZjtMHPepA7HHm83a/tmVyjmsrXv+0ZiZ7nSyEM7aekqwLbuvc3YJ7N8Bpqjpl4mO/VSSZsWfcUc6p9YkBCgNILiumKm8cx1xaH0xtBwVe7hOGZudzXDIraE0rdz18kwMnPPse0gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QhUh0kRD1+6zOI49b+lz+j1r4nUKUy5wvJ0+kzXpYu8=;
 b=PD7VswM6WMX9BJpx6kzvA7QvGC8CM1F3vrm/67t7bqcLoK6dRxqjFVveTGcgc2hUgK3EUJ8WVL/Alxpt5ztS19STUgAI4F+TLsb/yr7KsIQrfeR7Gyc3XPSur1jAqTzHUle7k+lHEpGnVYSE4BjqJa4dvrhesESpAB2oJJP3lUY=
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by CO1PR10MB4786.namprd10.prod.outlook.com (2603:10b6:303:94::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7; Wed, 26 Jan
 2022 15:35:20 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::49df:513e:bdbb:33a6]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::49df:513e:bdbb:33a6%6]) with mapi id 15.20.4930.017; Wed, 26 Jan 2022
 15:35:20 +0000
Date:   Wed, 26 Jan 2022 15:35:01 +0000 (GMT)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@MyRouter
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        =?ISO-8859-15?Q?Daniel_D=EDaz?= <daniel.diaz@linaro.org>,
        pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, stable@vger.kernel.org,
        Russell King <russell.king@oracle.com>,
        Alan Maguire <alan.maguire@oracle.com>
Subject: Re: [PATCH 5.15 000/846] 5.15.17-rc1 review
In-Reply-To: <CA+G9fYtTU_7DVaxwbLWnKBfqwbW51ebEoP=+vah7f6cWYSrKkQ@mail.gmail.com>
Message-ID: <alpine.LRH.2.23.451.2201261532050.15350@MyRouter>
References: <20220124184100.867127425@linuxfoundation.org> <374e9357-35eb-3555-3fe5-7b72c3a77a39@linaro.org> <ef6a4bcf-832b-3a5d-9643-827239293772@linaro.org> <CA+G9fYtTU_7DVaxwbLWnKBfqwbW51ebEoP=+vah7f6cWYSrKkQ@mail.gmail.com>
Content-Type: multipart/mixed; boundary="-1463809791-720778370-1643211318=:15350"
X-ClientProxiedBy: LO2P265CA0371.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a3::23) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c9ad7bc4-9d18-4f50-0751-08d9e0e175dc
X-MS-TrafficTypeDiagnostic: CO1PR10MB4786:EE_
X-Microsoft-Antispam-PRVS: <CO1PR10MB47867772C4748C00500D9C60EF209@CO1PR10MB4786.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 40L5ag2y/MHzKcqKLQ5AwhV3FK/dG1ViWuQcYUNIR8XRBRaZrv+BqcP7xiZQRr7KpU96v036kt+cQZ+jd2+t0BMDhIxC0oZCrj3wbPwd8UUwHU0bVoGsKkJPky2mgaWY2hP3io6DvO+LLtIK8raAGUjyGdlxnczJkiBmMGLKNUnwHx5edcAprp4D6bA0PpKNC/PKEJtW7xFWdP4w7X/rV2tKWZtShKI8RoBth1Or8RVslNcrlP1wflvxUWm+5+t1NTbfyqDl7kuxI4l3aF9cVLFeDSo8cbPd7wFwmtbpE82v5w2jlAIvnTZ38sl4AcHaAoh3x+uZVcomPIkj24DEpM0925ahi/q+naCv+rqrmkNjcspHLuICGqr47wDiriDJB+CmVwhJwzggrT2NDZig6q+tpWKBFAvnEy28OkCNZT0uEdRw4zDx4P5aERCL7b/kHVhQKtq5Ml8GUcb9LjuYluM7wbsgW2i+Reww62edi8kDYx0HnJQHdwGlF5OD56MD5AeCPs1PQUlfMLHUar6Eh1DglL3qo3qv3n/YHNthHEKFBr3a8xeq3WepL31hiqtZ3JTwQ0v4fX6001CFnbMnUFiDjPicnjjxWhXXb3lyXF7+N1qPuFKguP9bZwNFM32i3SkdUVEqdp5162cbl0sx0A+WnVi4BSa05uCY369ccbzzruMuQB+0U2xU1FQC22/RoDvH0qEe1yumIoVxJE6vt/8aKdVZpkBOBcbxsZXPel0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(4326008)(44832011)(33964004)(966005)(8936002)(52116002)(7416002)(33716001)(5660300002)(508600001)(186003)(6486002)(6666004)(107886003)(6506007)(8676002)(66946007)(54906003)(83380400001)(38100700002)(6512007)(316002)(9686003)(2906002)(53546011)(6916009)(66574015)(66556008)(66476007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WGJlc0k5dW40ZUd4a3RTYjc0eDFXemlmYWJFVUpYMnQ2ZHhpNFFuUW1YU1A4?=
 =?utf-8?B?MjN4cW1ZbHkxOWY1aUUvcmNvTEozRVh4THlLUThjNnVTdjBOQjQrQTR6NTJw?=
 =?utf-8?B?emJaeEM2VmprcDdtUThTY1k0aW9hT3MwV2RuQm5rU2ZUaXRUSzJpbThZcUJm?=
 =?utf-8?B?ejdnN0UraHNmNmlPSGZDZEdPcnErUEVEaW5haThYeFJsTzdvb0p6czJha05W?=
 =?utf-8?B?bUZ1V09SNFc1VS9wYWxYZFU1V0FlaXdMcytDU1BBMFVmSmE0anJPNTRVYWU0?=
 =?utf-8?B?SmZHL2hoRWwzbFpqV2RPYVNrN25TcDI4YVZtak9kZTEvOFZIbVpZbzhuZGdl?=
 =?utf-8?B?TE5scXdpYnhFNWh4QVJwNWYyZVdOSGRIMGtTOHdnTjg1dXBjQjdzR3VJS1B4?=
 =?utf-8?B?L1lONklIZXFqbFltalNKTGNFc2VGWUtsUkF6MjI0NFE5Mk9XSnZ0MzNCNWlZ?=
 =?utf-8?B?eDE0NXlZSjYwdUxPNU1xNml1akZKalVVOTVKeDArSDREQXp2WDV3dW1KREpV?=
 =?utf-8?B?VjdZcXpHT3RoUHJ0TUthWC9HdDNkamM5K29EQkMrVmJIeU9nTmNGN1FlRjJQ?=
 =?utf-8?B?aDV4ekVseW9NQU5La2RtQ1R6VzU4T2ZZaFNSMklJQmoxemtXdWJFUEd2TzA1?=
 =?utf-8?B?RVpxNC9aVlpoS1BNMHMvMnJnYnFhdUhzakhVRnBrTjltMkljQm5Fd3owYUV0?=
 =?utf-8?B?c2hDNUx3dmNGRG9vZzc0QlFDNFJSR3ZPYWQ0Y3dlR0V0QXpVczVEWnQyZGpC?=
 =?utf-8?B?VGVNeCtWZ09ZZm9Ib1Nnd0dQVkhTRDd1Vzk2cXp2QXErcW1lZGNLSWVBS1VH?=
 =?utf-8?B?bW96V0NHTzhoc2pWbWxQWUR4V3V6eE14YzhZTitKUVJ2d0hQejhCWU1PWGRl?=
 =?utf-8?B?OFBVQTBreXdsYk9Db3UvaUE2elZGZXlpbW1VWGkwMU9hUzJvTGFaa2ZRdEha?=
 =?utf-8?B?amlXYThHVzdLVmVrYXhKcGJKTjVZOWlyQUduS1FiTm5yTmp5azNxZkJHb0tw?=
 =?utf-8?B?TUFCaWxtU1IrWUdwTG1GNmJwYzJLcTcyZHlsL29KazltL1VkT3RYNGdVWFV5?=
 =?utf-8?B?RDBudHdWSm1VNXNkZmNrNmQ3MDRNd3RuRDBuaTM3YXBSbko3dnZMeFV4Q2Fp?=
 =?utf-8?B?NE8zamxJcXg1UUVmU1U4cFlDNmVSSnRobjVieWhsS0Y3bGlOdmVXZHN5TExL?=
 =?utf-8?B?bk9JOWlFQUw5amZ4QXlUTHNqeUdycWtIUncxVFRaSmt2WnhIeml2VFZIekN3?=
 =?utf-8?B?THh5eHFZNmljNkhEZGtONXNXcEFYZFZlOGhNRzh6aHJudHZQdDBiQ0xtR1pi?=
 =?utf-8?B?VERTdkRvRmRwQXR5UzVEd0pqb29iUk5QQlNHRjdPZ3BmUi9vY2NaU2ZJbnFw?=
 =?utf-8?B?aVk1Vks4eGs0SXlDcjFWTWFIQUdlMkhZVitDQmxQY29sM2dPNXVwcnB1aytj?=
 =?utf-8?B?VzJLNHZicm1ucEY2bzFnSFlSMkQ1azVHQ2FuQkdvNEVRckJXYjlDc2JjMDR4?=
 =?utf-8?B?NlRjbVNjZjBlYWJGYlEyV3BxT213eU1HN1Y1bVJ1RDhZMWNrTDJFbWRieVVm?=
 =?utf-8?B?WE9yNHhFTzRsd2lUQmlNa2g2R080WWhLbjFQK2F5Z2UwNGVpeWptSVVsSWov?=
 =?utf-8?B?eDc3bWNGczhZbnlOaHYveUFNWFBjOHlUZnU3M1g2VDVxaVdNZ3Q3bDJUTlRk?=
 =?utf-8?B?QnVtVGZNaWhqNGdsS2ROQnl0T0RRK3RNQkpPK2lITFR3UE05L1Ywd1dIRmJG?=
 =?utf-8?B?QmtQNjNyRWV0SW1aeUNGWUZ2YjZtZGNNUTRmZ25wUE9UVTBVb2hVNE9KbkJ3?=
 =?utf-8?B?NG9qcityR1dWeFBCSWdQVGRnNnpoc1g3NUhQMGtTRis5dlppNEZtbnc5N3JZ?=
 =?utf-8?B?SGpVYU56UlkzcW44RnF5S0p4dTg5ZG1ncnRxdm1ydWtiU29iWHc2NzdIYmxT?=
 =?utf-8?B?NndBdUJORXdKVHp0SndTK2YzRms4aEZ1WjN6SkdXa2hSV1ZvTm1KN3Q0eVJN?=
 =?utf-8?B?aUlxTFBENHBaWWJIYk9RaVpxMHRZUytONm9iMmQvSmtqT3dKcEFIWG9QQ1Fw?=
 =?utf-8?B?SElzYyt1NjZ2SGppd2I3UFhYanB1QTZTMGlSUG4xSkRPWWNQakxiOEtCYVlE?=
 =?utf-8?B?d2dDTkRocDFKUlhaZWUreGV5MGpUcFdUUWMrajlvaUNrOE8ySGVYczJvMVpO?=
 =?utf-8?Q?BvZGe6YFfrIhTT+4RyUGFe+mLezD5HD0y7P2WHm8Cfd1?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9ad7bc4-9d18-4f50-0751-08d9e0e175dc
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2022 15:35:20.1127
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MkMhQSaS3cznMDhgv4KUPOMY8Vx2fvfcPL3ADEL5nE4jNh+sH3jC4ytZmi8ppGXRMOy8GnEEXguIzko0CROTtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4786
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10239 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 malwarescore=0
 spamscore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201260097
X-Proofpoint-GUID: 1NzK5ZrOiuTli_unRECMvE7eATVwUw3T
X-Proofpoint-ORIG-GUID: 1NzK5ZrOiuTli_unRECMvE7eATVwUw3T
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

---1463809791-720778370-1643211318=:15350
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Tue, 25 Jan 2022, Naresh Kamboju wrote:

> On Tue, 25 Jan 2022 at 09:09, Daniel Díaz <daniel.diaz@linaro.org> wrote:
> >
> > Hello!
> >
> > On 1/24/22 16:50, Daniel Díaz wrote:
> > > Hello!
> > >
> > > On 1/24/22 12:31, Greg Kroah-Hartman wrote:
> > >> This is the start of the stable review cycle for the 5.15.17 release.
> > >> There are 846 patches in this series, all will be posted as a response
> > >> to this one.  If anyone has any issues with these being applied, please
> > >> let me know.
> > >>
> > >> Responses should be made by Wed, 26 Jan 2022 18:39:11 +0000.
> > >> Anything received after that time might be too late.
> > >>
> > >> The whole patch series can be found in one patch at:
> > >>     https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.17-rc1.gz
> > >> or in the git tree and branch at:
> > >>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > >> and the diffstat can be found below.
> > >>
> > >> thanks,
> > >>
> > >> greg k-h
> > >
> 
> Regressions detected on arm, arm64, i386, x86 on 5.15 and 5.10
> 
> > >
> > > This is one from arm64:
> > >    /builds/linux/arch/arm64/mm/extable.c: In function 'fixup_exception':
> > >    /builds/linux/arch/arm64/mm/extable.c:17:13: error: implicit declaration of function 'in_bpf_jit' [-Werror=implicit-function-declaration]
> > >       17 |         if (in_bpf_jit(regs))
> > >          |             ^~~~~~~~~~
> > >    cc1: some warnings being treated as errors
> > >    make[3]: *** [/builds/linux/scripts/Makefile.build:277: arch/arm64/mm/extable.o] Error 1
> >
> > Bisection here pointed to "arm64/bpf: Remove 128MB limit for BPF JIT programs". Reverting made the build succeed.
> 
> arm64/bpf: Remove 128MB limit for BPF JIT programs
> commit b89ddf4cca43f1269093942cf5c4e457fd45c335 upstream.
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 

Thanks for the report!

This one needs slightly different handling on 5.15. Russell had a 5.15
patch for this (where BPF exception handling was still handled separately)
and I've included it below. I verified it applies cleanly to the 
linux-5.15.y branch and builds.  I'd suggest either skipping backport of 
this fix to stable completely, or just applying the below to 5.15 and
skipping further backports.

Thanks!

From dfe0e5d5c7101dd848822a7be8d0e63fa137919f Mon Sep 17 00:00:00 2001
From: Russell King <russell.king@oracle.com>
Date: Fri, 29 Oct 2021 15:37:01 +0100
Subject: [PATCH] arm64/bpf: remove 128MB limit for BPF JIT programs

commit 91fc957c9b1d ("arm64/bpf: don't allocate BPF JIT programs in module memory")

...restricts BPF JIT program allocation to a 128MB region to ensure
BPF programs are still in branching range of each other.  However
this restriction should not apply to the aarch64 JIT, since
BPF_JMP | BPF_CALL are implemented as a 64-bit move into a register
and then a BLR instruction - which has the effect of being able to call
anything without proximity limitation.  Removing the contiguous JIT
region requires explicitly searching the bpf exception tables first
in fixup_exception(), since they are formatted differently from
the rest of the exception tables.  Previously we used the fact that
the JIT memory was contiguous to identify the fact that the context
for the exception (the program counter) is a BPF program.

The approach used differs slightly from upstream since in 5.16 the
format of the exception tables was reorganized to accommodate BPF;
in upstream no explicit BPF exception handling was required.

The practical reason to relax this restriction on JIT memory is that 128MB
of JIT memory can be quickly exhausted, especially where PAGE_SIZE is 64KB -
one page is needed per program.  In cases where seccomp filters are applied
to multiple VMs on VM launch - such filters are classic BPF but converted to
BPF - this can severely limit the number of VMs that can be launched.  In a
world where we support BPF JIT always on, turning off the JIT isn't always
an option either.

Fixes: 91fc957c9b1d ("arm64/bpf: don't allocate BPF JIT programs in module memory")

Suggested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Russell King <russell.king@oracle.com>
Tested-by: Alan Maguire <alan.maguire@oracle.com>
Reviewed-by: Tom Saeger <tom.saeger@oracle.com>
---
 arch/arm64/include/asm/extable.h |  9 ---------
 arch/arm64/include/asm/memory.h  |  5 +----
 arch/arm64/kernel/traps.c        |  2 +-
 arch/arm64/mm/extable.c          | 13 +++++++++----
 arch/arm64/mm/ptdump.c           |  2 --
 arch/arm64/net/bpf_jit_comp.c    |  7 ++-----
 6 files changed, 13 insertions(+), 25 deletions(-)

diff --git a/arch/arm64/include/asm/extable.h b/arch/arm64/include/asm/extable.h
index b15eb4a..840a35e 100644
--- a/arch/arm64/include/asm/extable.h
+++ b/arch/arm64/include/asm/extable.h
@@ -22,15 +22,6 @@ struct exception_table_entry
 
 #define ARCH_HAS_RELATIVE_EXTABLE
 
-static inline bool in_bpf_jit(struct pt_regs *regs)
-{
-	if (!IS_ENABLED(CONFIG_BPF_JIT))
-		return false;
-
-	return regs->pc >= BPF_JIT_REGION_START &&
-	       regs->pc < BPF_JIT_REGION_END;
-}
-
 #ifdef CONFIG_BPF_JIT
 int arm64_bpf_fixup_exception(const struct exception_table_entry *ex,
 			      struct pt_regs *regs);
diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index f1745a8..0588632 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -44,11 +44,8 @@
 #define _PAGE_OFFSET(va)	(-(UL(1) << (va)))
 #define PAGE_OFFSET		(_PAGE_OFFSET(VA_BITS))
 #define KIMAGE_VADDR		(MODULES_END)
-#define BPF_JIT_REGION_START	(_PAGE_END(VA_BITS_MIN))
-#define BPF_JIT_REGION_SIZE	(SZ_128M)
-#define BPF_JIT_REGION_END	(BPF_JIT_REGION_START + BPF_JIT_REGION_SIZE)
 #define MODULES_END		(MODULES_VADDR + MODULES_VSIZE)
-#define MODULES_VADDR		(BPF_JIT_REGION_END)
+#define MODULES_VADDR		(_PAGE_END(VA_BITS_MIN))
 #define MODULES_VSIZE		(SZ_128M)
 #define VMEMMAP_START		(-(UL(1) << (VA_BITS - VMEMMAP_SHIFT)))
 #define VMEMMAP_END		(VMEMMAP_START + VMEMMAP_SIZE)
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index b03e383..fe0cd05 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -988,7 +988,7 @@ static int bug_handler(struct pt_regs *regs, unsigned int esr)
 static int reserved_fault_handler(struct pt_regs *regs, unsigned int esr)
 {
 	pr_err("%s generated an invalid instruction at %pS!\n",
-		in_bpf_jit(regs) ? "BPF JIT" : "Kernel text patching",
+		"Kernel text patching",
 		(void *)instruction_pointer(regs));
 
 	/* We cannot handle this */
diff --git a/arch/arm64/mm/extable.c b/arch/arm64/mm/extable.c
index aa00601..60a8b6a 100644
--- a/arch/arm64/mm/extable.c
+++ b/arch/arm64/mm/extable.c
@@ -9,14 +9,19 @@
 int fixup_exception(struct pt_regs *regs)
 {
 	const struct exception_table_entry *fixup;
+	unsigned long addr;
 
-	fixup = search_exception_tables(instruction_pointer(regs));
-	if (!fixup)
-		return 0;
+	addr = instruction_pointer(regs);
 
-	if (in_bpf_jit(regs))
+	/* Search the BPF tables first, these are formatted differently */
+	fixup = search_bpf_extables(addr);
+	if (fixup)
 		return arm64_bpf_fixup_exception(fixup, regs);
 
+	fixup = search_exception_tables(addr);
+	if (!fixup)
+		return 0;
+
 	regs->pc = (unsigned long)&fixup->fixup + fixup->fixup;
 	return 1;
 }
diff --git a/arch/arm64/mm/ptdump.c b/arch/arm64/mm/ptdump.c
index 1c40353..9bc4066 100644
--- a/arch/arm64/mm/ptdump.c
+++ b/arch/arm64/mm/ptdump.c
@@ -41,8 +41,6 @@ enum address_markers_idx {
 	{ 0 /* KASAN_SHADOW_START */,	"Kasan shadow start" },
 	{ KASAN_SHADOW_END,		"Kasan shadow end" },
 #endif
-	{ BPF_JIT_REGION_START,		"BPF start" },
-	{ BPF_JIT_REGION_END,		"BPF end" },
 	{ MODULES_VADDR,		"Modules start" },
 	{ MODULES_END,			"Modules end" },
 	{ VMALLOC_START,		"vmalloc() area" },
diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index 803e777..465c44d 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -1138,15 +1138,12 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 
 u64 bpf_jit_alloc_exec_limit(void)
 {
-	return BPF_JIT_REGION_SIZE;
+	return VMALLOC_END - VMALLOC_START;
 }
 
 void *bpf_jit_alloc_exec(unsigned long size)
 {
-	return __vmalloc_node_range(size, PAGE_SIZE, BPF_JIT_REGION_START,
-				    BPF_JIT_REGION_END, GFP_KERNEL,
-				    PAGE_KERNEL, 0, NUMA_NO_NODE,
-				    __builtin_return_address(0));
+	return vmalloc(size);
 }
 
 void bpf_jit_free_exec(void *addr)
-- 
1.8.3.1

---1463809791-720778370-1643211318=:15350--
