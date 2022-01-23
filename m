Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 848BD49735B
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 18:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239060AbiAWRDu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 12:03:50 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:31412 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233237AbiAWRDt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 12:03:49 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20N6u5Pv025472;
        Sun, 23 Jan 2022 17:03:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=r2Jg9NhLyl6tnhrp1ISjldoHxfPSQo8GElhs/C+RvRY=;
 b=MD46zNCuEcJ02gBXPJIUH9tKwdVApePY/EvkxkqpmBZqNh+KjJ7YyELMVGrVmMXfWYoD
 azwqIYcM/NY5gXYEpipqPPBKKKE8qP5mSG7UE9KTBzzWDQqmvrPVKJyg60IEOlEKOTBL
 o/2boGp727FlkiUFmadlOmK+Uj9BPJ+if32CpZJ2q9zwA+MwdwDUVmMEETTZybjlN++U
 8cVloe/zb3H8oi/AQMtY746botSJxkQnAMsjRe+SF5pl5J1dtMCRu2iZAIShpEIuOKiS
 GWwt66yTbQYTnGNTDtoTalF7CuOJfPFu/V0+RPrOgDP6TTInIzAG2rmRK1I0aZR51PA/ 2w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dr8q3aj8s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Jan 2022 17:03:45 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20NH0qWX189326;
        Sun, 23 Jan 2022 17:03:44 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by userp3030.oracle.com with ESMTP id 3dr71u15de-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Jan 2022 17:03:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f+F58prfP+QjO1nnyMIHWhcTrynAJliapBQyScsQR5BGi4Zv3b2qK74cjnWmJVkWVjVmwzv66wCQJwIX06TAdjDVEI+tSQhF/iaZ7shzE/VK3mTr+7H55k2tlVirVNhoFBBk9SsX8528oaNzTLy7NQyGXadA6Ex0qB6EsruDcBnlXAc7gfZfhFAV5//5NjegG0TeLgx2lSHfZN/1KTQQDlR5+PZGxi7mwYq4eOjzg3AtGd1fi15asBI35ZGNhWlNgTs5PEKCdBt4QxRcMehXF0SetoAiiCAw9WatPTMm0SZh8QPfIfOPtl97gKtKcfkG2TkoYl0l8K4hWaJscwHevg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r2Jg9NhLyl6tnhrp1ISjldoHxfPSQo8GElhs/C+RvRY=;
 b=d3oVcE5/+J1O+kDt8xo/Lf7wWupc0I7o7A9CgQR0jhys0nRxllheTvZmDskiTcew6LpiHzeO7LKHy03QfsqxogkUvSUqcUv10smdLycBEyX+cskLpHpEd2c+8Zu6P00azg8sGNh16B1xVdY6PX9n2X94WVyNhb4WiSRn4HWYau9VYKOzAZB5hb3cpYUD42EotL8SChqG/M1r4seuoLY56xPZH3ph/TVy/4QoZFWGhPdBDfc/rRNJzU64WTTdIHI+Q4JKRZZhJ1bDNgFWAZUIEx2BioaBSZtuC/s9ELJRO/ytTp1Wfiqz9PHjRso8aWfculUFFF7TsJjNfMw97R/u1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r2Jg9NhLyl6tnhrp1ISjldoHxfPSQo8GElhs/C+RvRY=;
 b=dqaHhCSwCVfvxm6O+lBAMrqTGQr173tlqYZCclxw4A1Tiyt/Ik3CuQNYEZlVTjKGbis8udX6U0kpj0DptaRbnBaB7xrC1S6lLYsmy1MitkwlmM60AmJqCdhhDEktkySpz9I5tbYhkzaI5Dmrrk7HgjSUYJQjYUSHCD1GUBFbVes=
Received: from CH0PR10MB4858.namprd10.prod.outlook.com (2603:10b6:610:cb::17)
 by CO1PR10MB5508.namprd10.prod.outlook.com (2603:10b6:303:163::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7; Sun, 23 Jan
 2022 17:03:42 +0000
Received: from CH0PR10MB4858.namprd10.prod.outlook.com
 ([fe80::241e:15fa:e7d8:dea7]) by CH0PR10MB4858.namprd10.prod.outlook.com
 ([fe80::241e:15fa:e7d8:dea7%9]) with mapi id 15.20.4909.017; Sun, 23 Jan 2022
 17:03:42 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Trond Myklebust <trondmy@hammerspace.com>
CC:     "dan.aloni@vastdata.com" <dan.aloni@vastdata.com>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Anna Schumaker <Anna.Schumaker@netapp.com>
Subject: Re: [PATCH v3] NFSD: trim reads past NFS_OFFSET_MAX and fix NFSv3
 check
Thread-Topic: [PATCH v3] NFSD: trim reads past NFS_OFFSET_MAX and fix NFSv3
 check
Thread-Index: AQHYED6pOMI/9V2oVkmi353YFkSzN6xwu4+AgAAaS4A=
Date:   Sun, 23 Jan 2022 17:03:41 +0000
Message-ID: <A1AF622A-6794-4104-8A89-EA5CD9E19D7D@oracle.com>
References: <ADEC85C2-8D72-4E25-A49B-2039C1FF82F2@oracle.com>
 <20220123095023.2775411-1-dan.aloni@vastdata.com>
 <58db6c327e2c72776f051a987f9b813606c53a71.camel@hammerspace.com>
In-Reply-To: <58db6c327e2c72776f051a987f9b813606c53a71.camel@hammerspace.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 747c0fc9-d91d-4140-bc4f-08d9de924eef
x-ms-traffictypediagnostic: CO1PR10MB5508:EE_
x-microsoft-antispam-prvs: <CO1PR10MB5508A7372382BC19E6137896935D9@CO1PR10MB5508.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qBDroveKNrl368s2D1V3NsGeZxN3MKN0qR2eqZ2Ffzx4AVAXX5Cr5Xuz1oGOHzylXtoL0qmlaANJsPUR+XiUfR5/Hp4VyK4UAVGeDfbBhPOMFi4eUZufHqP8alnXtI+es1wZyU8EPGJQzbnSc3Z+eb40x0J/g3lhavmGsEhxx1MLKfW6Cd6IyeYRhBC3pvqAB+7FztDAvlkMEN4TVF1OkaH99X0Yma23i9M6rjpx+mQv5vDnZQrtcOqPyW3p6N0506BGKdck7ZY3T+cDq+vAmbQipqOo/2C0qKXwfsuOJuWpJDCinUQ1bmWyQh5llywsNz8sTe2wD9ZDRnxMggP7Vj5U6amK2ySCHrBCHCngohYKjGJHkeaH1WK/4bxa/JSKGWAS+1er2AdHsauid0+KTgMONefkfpAI77icGgpDCj2b7ZBXaD04LPu8AgmhsXVCHD44bOo6kgsH0tSsn7buLZdys9pVIjqEFd8hT+RKR3ws+3fKAKaMVZGaWWt9gxoLQOnrIRvBn6+KndSrYHSbY26oQH9z3aYj1u237bng3zR1F+OXS2MRuBn4vwXM92CBv01B2wx6/FLS0MN6+HOGyp3MgrRvmBavUWOj1Y3Gmqn1Cppa2mRHdreBn2OW2gJVwLW9PPUBQqbLOWTYJn2Ws6TBwoSi/3jqRTJhwLWIwzD1vpa/XUSRS4SwDyYDqSRuTDfSpq7Iz9NieRj7kNW1vQjGQ/1S5X6kuSb6tUKnciFZd2u5RWh6/XH/MySaMcTu
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB4858.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(5660300002)(6916009)(36756003)(71200400001)(53546011)(4326008)(6486002)(86362001)(26005)(38100700002)(122000001)(2906002)(6512007)(6506007)(508600001)(186003)(66946007)(2616005)(33656002)(54906003)(66556008)(66476007)(76116006)(316002)(38070700005)(8936002)(66446008)(64756008)(8676002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LovSTfa/nIqvGVYCGLSEZ+6N6NkCybfne/61v5VpM/e4yAbd/GXP7f6cB3fo?=
 =?us-ascii?Q?wK7xloCP+K41v5OJ0CsUR746wWQ0Vkwk2Z2n3vvEqLHCT0CyVomaIO9fPslx?=
 =?us-ascii?Q?yuEmzO09QRJZMqd4VrJ4CsySoEUlwQQamMvwd5mGoc5UxGE6ad6qahnBTG/+?=
 =?us-ascii?Q?9kDITRSOTkmx6OXPYvdXDEayTPeMCuicMS5yi0ryaYSEyV7B70ONZch6zN12?=
 =?us-ascii?Q?mPyfIVkOqcSbm8a84zSCFPUUcpSCJQX0kGHYvcUtlmwQ0KBUyuDRJMAsbHHw?=
 =?us-ascii?Q?YrZV5syN25J97WDIhKtS0K2tAkIvv9lPPQw5Lj90loG1CANwkn2fZJToQO/6?=
 =?us-ascii?Q?ocr8H5lvQdGtADZcp6jK+MqyvWj2Uszdsc66MSvUY3u+n7O9PYfUluCiTNl4?=
 =?us-ascii?Q?+VEsh3V7l2lKA4rijJOSn5Ox2GPp1OIF0kiY+l+HaPxW9sGhEh/xUmjz5/AC?=
 =?us-ascii?Q?Y0u3XEVOubxPLA4+1F+jTU5QXuW2pBtRt6PZ0Qv/EC5k6Xhpb7utOnlN8RAT?=
 =?us-ascii?Q?i7VDMYOVc6uYCmpO/kaE3SQr8xO2DogHzitbQQ0u2lpSNN+JglaGWnV7dEWD?=
 =?us-ascii?Q?wpurzgHWGEBDE3FsKSbk5sD8iJEQgl5MnFFpBu2m5ullVjJXO5UTeYjkMmUd?=
 =?us-ascii?Q?EG2W5yh+ERzyYfBsFXWgG0rNwf9s+9/YrMBfKMckabPeA0z4b8XgP4ESP4+s?=
 =?us-ascii?Q?vPnU+2wiUwtQGPqTFih1ZHmtqBxAlowO60bY9u5CWDGdnr3FnoNOYjpwrBG/?=
 =?us-ascii?Q?kGH2NerZjxXQawm/M5C70iquskGViEcKUQDYeW+BfnXR1++xXA29T6iHZEsv?=
 =?us-ascii?Q?TfEqrOn3+LocWGxPIFKms7z2btx2rG+yefaVOdTBimGEONJ3YbQphjjeyQx8?=
 =?us-ascii?Q?PBTirWdfxSLYLnPARNUy29MnuRqjrmGcZMzPCPJ/qAx6bghPsThBig9DUJZV?=
 =?us-ascii?Q?7FQG+eoZxpqXGY+oYXTspmrWtmQTpJ1/0uq++hSninhR5PEok58Ll0HXzNOq?=
 =?us-ascii?Q?REfHSKKa6Z8VfmaXfPTqY5qoQtcsn/zQ/XMMcvJZ4Df2nad6VGmFsjP2D4R5?=
 =?us-ascii?Q?gexNbXxzWBRmmKyRNN6eW0xOZqEIToQZMmu0PvZE6xabaAoBpDeh3AYae/ms?=
 =?us-ascii?Q?kne9alDdEQgXlOV29INeerogfVjybZBv34af+l9PFfMGDUAQ1nMxQdq/Rok3?=
 =?us-ascii?Q?chWItx9hg2cYUJSpoqt9F8278mDfbdANnS9ageQCP7esr9ch+x4+QhVHTMtC?=
 =?us-ascii?Q?yg/O4uOOZVwvheqB8DssyI8/ggcruYv85wc0AD+g2PQMaFBa6jCcXYceX+ZT?=
 =?us-ascii?Q?0m9pdC8NERRc4MtoWipwiHVWo4NJlHcSvbOXFUrqTiQINvLxZAHcrx4/eeSC?=
 =?us-ascii?Q?uGJZqTnxl/oOz1vU6uYquEco4e0ACwuBSBo2wfmvUUCps9C6hB3Ar5HuM3ej?=
 =?us-ascii?Q?k9iyURuiExg6ZEtzTuKLzP2ftp10mKCAncWUXQ/NEXUSTym1bCxRZSPPlU1K?=
 =?us-ascii?Q?JZZorlYACY6T4Yo4K6qfeg7Tba0zmexEwkMmcsR05LcaEgBzGAShQzTpqkTJ?=
 =?us-ascii?Q?rAZgfYXERl3fLZrAec00JK/D6Uz6Mhk4XCCkkkPP8AjgFJfGzrDUgEkzONJ4?=
 =?us-ascii?Q?Dc6ZNXiuNdLkykpJlrUpLHU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9087E5DD79F1D84188C3FAEF5DDCA31A@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB4858.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 747c0fc9-d91d-4140-bc4f-08d9de924eef
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2022 17:03:41.9624
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZpP1Th5wvQAG6Yu9Te3CsagFCON0wQEzotIDfZzzfN/NhmPO+l0NgQhChuqzTuayjvKl5EHrDEP7Y1yy8yE95A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB5508
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10236 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 spamscore=0 bulkscore=0 mlxscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201230132
X-Proofpoint-ORIG-GUID: eFRlLPPNW19Yk-SpSpzQsqSaXRQuTSPo
X-Proofpoint-GUID: eFRlLPPNW19Yk-SpSpzQsqSaXRQuTSPo
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


> On Jan 23, 2022, at 10:29 AM, Trond Myklebust <trondmy@hammerspace.com> w=
rote:
>=20
> On Sun, 2022-01-23 at 11:50 +0200, Dan Aloni wrote:
>> Due to commit 8cfb9015280d ("NFS: Always provide aligned buffers to
>> the
>> RPC read layers") on the client, a read of 0xfff is aligned up to
>> server
>> rsize of 0x1000.
>>=20
>> As a result, in a test where the server has a file of size
>> 0x7fffffffffffffff, and the client tries to read from the offset
>> 0x7ffffffffffff000, the read causes loff_t overflow in the server and
>> it
>> returns an NFS code of EINVAL to the client. The client as a result
>> indefinitely retries the request.
>>=20
>> This fixes the issue at server side by trimming reads past
>> NFS_OFFSET_MAX. It also adds a missing check for out of bound offset
>> in
>> NFSv3, copying a similar check from NFSv4.x.
>>=20
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Dan Aloni <dan.aloni@vastdata.com>
>> ---
>>  fs/nfsd/nfs4proc.c | 3 +++
>>  fs/nfsd/vfs.c      | 6 ++++++
>>  2 files changed, 9 insertions(+)
>>=20
>> diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
>> index 486c5dba4b65..816bdf212559 100644
>> --- a/fs/nfsd/nfs4proc.c
>> +++ b/fs/nfsd/nfs4proc.c
>> @@ -785,6 +785,9 @@ nfsd4_read(struct svc_rqst *rqstp, struct
>> nfsd4_compound_state *cstate,
>>         if (read->rd_offset >=3D OFFSET_MAX)
>>                 return nfserr_inval;
>> =20
>> +       if (unlikely(read->rd_offset + read->rd_length > OFFSET_MAX))
>> +               read->rd_length =3D OFFSET_MAX - read->rd_offset;
>> +
>>         trace_nfsd_read_start(rqstp, &cstate->current_fh,
>>                               read->rd_offset, read->rd_length);
>> =20
>> diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
>> index 738d564ca4ce..ad4df374433e 100644
>> --- a/fs/nfsd/vfs.c
>> +++ b/fs/nfsd/vfs.c
>> @@ -1045,6 +1045,12 @@ __be32 nfsd_read(struct svc_rqst *rqstp,
>> struct svc_fh *fhp,
>>         struct file *file;
>>         __be32 err;
>> =20
>> +       if (unlikely(offset >=3D NFS_OFFSET_MAX))
>> +               return nfserr_inval;
>=20
> POSIX does allow you to lseek to the maximum filesize offset (sb-
>> s_maxbytes), however any subsequent read will return 0 bytes (i.e.
> eof), whereas a subsequent write will return EFBIG.

I'm simply trying to clarify your request.

You've stated that the Linux NFS client does not handle INVAL
responses, even though both RFC 1813 and 8881 permit it. So
are you suggesting (here) that the Linux NFS server should
not return INVAL on READs beyond the filesystem's supported
maximum file size but instead return a successful 0-byte
result with EOF set?


>> +
>> +       if (unlikely(offset + *count > NFS_OFFSET_MAX))
>> +               *count =3D NFS_OFFSET_MAX - offset;
>=20
> Can we please fix this to use the actual per-filesystem file size
> limit, which is set as sb->s_maxbytes, instead of using NFS_OFFSET_MAX?
>=20
> Ditto for 'read' above.

That sounds reasonable. But I wonder if there are some other
places that need the same treatment.


>> +
>>         trace_nfsd_read_start(rqstp, fhp, offset, *count);
>>         err =3D nfsd_file_acquire(rqstp, fhp, NFSD_MAY_READ, &nf);
>>         if (err)

--
Chuck Lever



