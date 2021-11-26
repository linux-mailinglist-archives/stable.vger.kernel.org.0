Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8C445E9DD
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 10:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238769AbhKZJHz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 04:07:55 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:8720 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346360AbhKZJFx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Nov 2021 04:05:53 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AQ7a0O6010888;
        Fri, 26 Nov 2021 09:02:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=MpJFVzocKL3lp2YVZZY0auDXkI6m/zQq18mokW4PxyE=;
 b=mu2O9iDE6L/I9717bYpxj03HxnoY9UmHCtYlfDFCnAZv/TVQFmU/Wm/sfocQXL53nxTg
 LoWAtZPQHuQWUW9/nwRzO7rG4gz+AVNf4wmIYi1NULR6/s8cntjG+PX/qubVmry3Y43G
 ms3niP9+EAd854TrDM1PQCRhjRfVxdB/ESPpWy9Loo6oOPEM/GCaTAQvN1t74tcR/HaE
 aRckJYkeuS72LHpttO44Ataqu3U2LKAirPBQv5BPezbajxtRiab677SABpD4l+ZZsg4o
 OgOI03U8BydtWYKeKt/0Kx7nacf8AKndtJDZkZTcG1u+DOS4B4FCeyx6OJkboxXO/I1Z aQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3chmfnabrn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Nov 2021 09:02:35 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AQ8vP5n067404;
        Fri, 26 Nov 2021 09:02:34 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by aserp3030.oracle.com with ESMTP id 3ceq2jnn2h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Nov 2021 09:02:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XcvHa3hCfLyypNr7rAOpq5xE+XnyNiK/mci+5d/cm06uN4vmMki6Ku/t5g2rxlpQm1CAvgjNAArB9NU1b2bheTUjw/X0StIXm/5U9q2xtNe7QzsRXPhVBDyPaU3c9yOORLDKT3zMRWXYx2O3LfGj+ol8Hf4GWpTfBYkWlA8p2mA56lBZv353elxHNe6rDcwx7hNcbEoO7s/Ipf3aYtptkcF2uEn+1SqOd2nftMKKHw/uSnhoas1y7tc1KPj2jn8rATrwPfeWa8ucpGC7f2ZEziLtyUqUbMLGswkEBHhZs4V22gLn/GeKzHj6E1KYfp+EVHb/U9t+lOyJ8pJbbnZPPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MpJFVzocKL3lp2YVZZY0auDXkI6m/zQq18mokW4PxyE=;
 b=XWjj9xP2+x9/3OOBm6jk3Bgw/BpSF5UFB436g6ryKjz9qUHSzX+M8qbBUtdw5RZGhZq2qmsjprhEpuBSRk6ImErBWRdN3q0ctmdX9tnw5MEycpJZNCjW8XiPcWGC/hzkm2U36SKfKaWaAoU8GDg2A8/htqarNeIxJxFZ3Cxdn0aa4KtyOJrzGk3pKyt4Rm+v1HNhsT5uhu6dXF7jSDSqZoCMUDQO2/kLF9pQ5psmPR+hDVMW7L8M9FYgqv3ehRxM0Lg5MjvmbAlmFLC+E/z5KyISTrmLdMC7Tpb8Y5JDgPH69SdH9Gd2aao7xEoWeW1cotKBJ0LgA2Z+J3Apwo0ghw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MpJFVzocKL3lp2YVZZY0auDXkI6m/zQq18mokW4PxyE=;
 b=MKaSitlD5GvnmNsdNzzuqVZbqN/yVNNZLUkIWib5xpTL4A5RE+o16x0psvhFTFivAPfP1sGrjR47DoGTz/onpb/JIITynNyKkguVpaJUF2nmcUh6/Rq3UsQlr0PraJgHHWo/eMBAAzUEZaxMoqjN+5jutzyrnWtJyyHFU/6m5Hc=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO1PR10MB4708.namprd10.prod.outlook.com
 (2603:10b6:303:90::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22; Fri, 26 Nov
 2021 09:02:31 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0%6]) with mapi id 15.20.4734.023; Fri, 26 Nov 2021
 09:02:31 +0000
Date:   Fri, 26 Nov 2021 12:02:10 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     devel@driverdev.osuosl.org, riandrews@android.com,
        stable@vger.kernel.org, arve@android.com, labbott@redhat.com,
        sumit.semwal@linaro.org
Subject: Re: [PATCH 1/1] staging: ion: Prevent incorrect reference counting
 behavour
Message-ID: <20211126090210.GK18178@kadam>
References: <20211125142004.686650-1-lee.jones@linaro.org>
 <20211125145004.GN6514@kadam>
 <YZ+muS7vC5iNs/kq@google.com>
 <20211125151822.GJ18178@kadam>
 <20211126071641.GO6514@kadam>
 <YaChOzfm2/3gY4o3@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YaChOzfm2/3gY4o3@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNXP275CA0048.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:18::36)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (102.222.70.114) by JNXP275CA0048.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:18::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.19 via Frontend Transport; Fri, 26 Nov 2021 09:02:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a8240f90-a6ce-4bf2-3951-08d9b0bb7a48
X-MS-TrafficTypeDiagnostic: CO1PR10MB4708:
X-Microsoft-Antispam-PRVS: <CO1PR10MB4708711D28085A4120801EE88E639@CO1PR10MB4708.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EMLtTCN/T8xDIBOmU9AI/PdQWRBb3hYXaOMX1yTfCZS186l/5LaWvoLxJur642e6HdSS19mHrHsrBosYPKzqNN1wsKm/VWUgr1pJhNvhkiQtWlNub+nstxazHd9o0E4eCnVtKHJ65TImkcqhM3XKSNJFOAGyG1Mk7utbiDMV/D+2G+BVBE/Kl3HtO7xM/o36x5tfl8ZRf+TnONJiXEssBAtPmDefug2fTQpwYh2XF7+q/BUxOgspDkXq68l3w6aVHIip3yjM+l8jEA1hN6qwquxhVl9qlHJnL/psIfDi4+M6n4nyonOdoMOM+qn8juSu1BWY/gZXHsx3MElw3eWHl5QZ/GcFdjKw6sV86QJsVgghh1DAq2TSI4zhhFIsIIIAmW2JrnZkj/WybVojk3ymbod9qsUH+aIEY1UJlzzll6W+z+H9W9GJvnv7SWGFE+QSNSx3mm3fP2gYzn1qS4DjWryIdQUxiLE0GRA8kbqduJt4vfIeAWQrIqb/0cyOvvE92puksYz+TyukfHOKtkuYF25flhd+Cct/o3ngWhG0S5BxQErytEBrdvM33RB60iMOr7jLziggyP0eZXIB954GuMNWZbzEzqBsA602Q7zsWVrt3dhr8m6CzJP46RtXAEzWmf/M8sa9DRW7LGEZKjeyBIrrWDVAhJ4DNdDYdM1xDOm37VFwsrZeLZNiLf3cT5UxyFuPCUYEebQLznhRRD1iMA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52116002)(86362001)(9686003)(8936002)(6496006)(38100700002)(38350700002)(44832011)(33716001)(8676002)(55016003)(6666004)(9576002)(956004)(6916009)(4326008)(33656002)(1076003)(2906002)(26005)(66476007)(66946007)(508600001)(66556008)(5660300002)(316002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?afmG9pK5m/sjMHZ2TSBmvEtVn4i58eWWAAttMEjG3wptncMcdL23oakoOq9L?=
 =?us-ascii?Q?ZZEGgn+C/68vPFkfP60timLyM4gVZVC29FH10Uy69cDlaiDW1NHS8q9bMGIg?=
 =?us-ascii?Q?N5FdruCXNldmm7KbUolzU5dGRIAuBR5k/QZZ18eOYOPLZMWRyWBA/yy1qU0D?=
 =?us-ascii?Q?KMdjatcEf9voQV1TgGqiBrXW9/qWuvSBOImAgJ0GUaQptO1zEh6y9JTsnJu2?=
 =?us-ascii?Q?AW6o2i+pBJkCLKvQRAkcnXbAOiTBS2Iuy9UrHQycKpdQRuWcUOHiWhDNgrSe?=
 =?us-ascii?Q?8f1IRY4NvMVLtkurpsiUshdL8qUtvE0hCUuYkqL/6VrlQKI29pVDed6u3Sx6?=
 =?us-ascii?Q?odRdUMZZjcaQG8jplTzqJzR/bFAsZwlOm+wwYLY6koeJPXB3DOfd8/Df9ATK?=
 =?us-ascii?Q?GjiXY8QNqnMpbCMlHg9o94wvrb3ioz+/0vOwlaYy0bgY+k+BtGcjIxIRCLVb?=
 =?us-ascii?Q?Q3xMOeviuJfq4emg7I0huR81UQsQ2Zjx9Yuc2U+ouykiRBjsO9eSkdhux6S/?=
 =?us-ascii?Q?7Y3GRcKYkgQTaBavG7qSCp75fabVOdOn9fdIZbWWFhug6sqpF1eH4zW7BSNp?=
 =?us-ascii?Q?k83uWrfAfgyfs8Yu48ubpBQT1Et/baB2YcRr/XBxAvIR4daReMhYyhnNwVwS?=
 =?us-ascii?Q?RzLD090IOGJAA7KuEKM0FE0z93FgRdaEV3CAni7KfboDq3hMjHfeptbi6Fjn?=
 =?us-ascii?Q?SmyQe3PW0CxLZXPWAlgtDTZNM34qcY4J+HKfdPkznQIoksSjQyxxh8dZPt1P?=
 =?us-ascii?Q?FP2Q+E2Y/K8DThuV/w/L6uzZHgHUhHvpntc3zrCPsSdkUZpyEVwHysk882Ng?=
 =?us-ascii?Q?5ealGIIhccE1bj7tERfUf+KIKwA0mK9zcsrQDhi7OpdbM8VRatdcW62HWQqc?=
 =?us-ascii?Q?PdVv5spfiw6kxhrgA8QAlY6ed745ilNml1LP6V06RvvMNU6aUv00UnTuhu6y?=
 =?us-ascii?Q?VOrC+79Ap93k/zhRHeUW7xdDLO8XN+/C2PEBBNDNfzg0ZR5pENxIPVLqq+zR?=
 =?us-ascii?Q?SJfSHrFNdoPRK3Qjcboxb48COGXcSMlteCf1GTAyCohcpW7Jik80iFlnUZal?=
 =?us-ascii?Q?40sPkxyjF7AMGw6aSBsqIcohiV/QFoaQFykh5Rb50pRk3LOlFc6AZYhPI/5F?=
 =?us-ascii?Q?zrcJNpJfVNh9vuXEGhp7JFUvMmzpCQDajPUlqWCOzstWWemNGgi8dKyZL9AL?=
 =?us-ascii?Q?ZGGaDYmxtPvE0pwjNW8vaRXp0Avprh/LOl8F336ABnnQ3xzEh0TIEnB4s3ws?=
 =?us-ascii?Q?zWSWlPn1dTdlqTMcqVidiCoG8jJvj0jglB5NycPPJZGw1wbi+Sq4wjnBD1uN?=
 =?us-ascii?Q?C0zD8AahTTu7FL4U9UX2ovU4l7+ZHCqpzp41NPxKaJXjDZcw3IwwvtWMdGi/?=
 =?us-ascii?Q?8XNIYoB1T/brOMJMx20OWiJYmivDHfZn26qg0KGyk+zQQDQ2USydyWiLJRJq?=
 =?us-ascii?Q?4vqoTtxTJIOQtce5Bcfc6iG6AERbahZDq4Nx/c+mEiiGg1ddI46aVvkHAlQ+?=
 =?us-ascii?Q?uO/uC8N17IPXwlBTMtpiOE999YVzkjd3aRiQzTCpIPAzv2RW/JZho4oEtdGI?=
 =?us-ascii?Q?0blraZpn2ybmcXv3kYXriiW1W97Rqh8MMJG4ap+JYrvf2Yo3DeLTOaA/cSPz?=
 =?us-ascii?Q?xBgksNWMsSoWhKVXWAMJDJ2h8lD4ALJ51S7xfUzkD1GOXSUCq3evKSEPAyrE?=
 =?us-ascii?Q?87zF0sb383Hj1TtZj+iCS5yARPw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8240f90-a6ce-4bf2-3951-08d9b0bb7a48
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2021 09:02:31.1259
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UyfOZ1L61VOP08pKlDlmqjeQ0vz7P34/3o36hEQvO3NwISh8sNB/5hBkFnCh9ZuRSu7b5aequwIv8cVu3TGyieyhRTJBx8/8/cyXC7WjpAI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4708
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10179 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 bulkscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111260052
X-Proofpoint-ORIG-GUID: 0P2Rz23SyA7750-3o9SOVBRdYxvPGtkE
X-Proofpoint-GUID: 0P2Rz23SyA7750-3o9SOVBRdYxvPGtkE
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 26, 2021 at 08:56:27AM +0000, Lee Jones wrote:
> On Fri, 26 Nov 2021, Dan Carpenter wrote:
> 
> > On Thu, Nov 25, 2021 at 06:18:22PM +0300, Dan Carpenter wrote:
> > > I had thought that ->kmap_cnt was a regular int and not an unsigned
> > > int, but I would have to pull a stable tree to see where I misread the
> > > code.
> > 
> > I was looking at (struct ion_buffer)->kmap_cnt but this is
> > (struct ion_handle)->kmap_cnt.  I'm not sure how those are related but
> > it makes me nervous that one can go higher than the other.  Also both
> > probably need overflow protection.
> > 
> > So I guess I would just do something like:
> > 
> > diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
> > index 806e9b30b9dc8..e8846279b33b5 100644
> > --- a/drivers/staging/android/ion/ion.c
> > +++ b/drivers/staging/android/ion/ion.c
> > @@ -489,6 +489,8 @@ static void *ion_buffer_kmap_get(struct ion_buffer *buffer)
> >  	void *vaddr;
> >  
> >  	if (buffer->kmap_cnt) {
> > +		if (buffer->kmap_cnt == INT_MAX)
> > +			return ERR_PTR(-EOVERFLOW);
> >  		buffer->kmap_cnt++;
> >  		return buffer->vaddr;
> >  	}
> > @@ -509,6 +511,8 @@ static void *ion_handle_kmap_get(struct ion_handle *handle)
> >  	void *vaddr;
> >  
> >  	if (handle->kmap_cnt) {
> > +		if (handle->kmap_cnt == INT_MAX)
> > +			return ERR_PTR(-EOVERFLOW);
> >  		handle->kmap_cnt++;
> >  		return buffer->vaddr;
> >  	}
> 
> Which is all well and good until somebody changes the type.

It would only break if they change it to something smaller than an int.
I have zero sympathy for them if they do that.

regards,
dan carpenter

