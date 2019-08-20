Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2C2295FE4
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 15:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729975AbfHTNVv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 09:21:51 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:24376 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729639AbfHTNVu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Aug 2019 09:21:50 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7KDITe7002514;
        Tue, 20 Aug 2019 06:21:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=QB+08b1v1rKYRA1qd5VIFpEw6MuG5H5/ZQKsylsIOnQ=;
 b=nwinD8Mk3cI1wky7UCUprqG64R25NZmVnoX8xDc89SLzXgOLyAqg5hUxKxnNF/NyxEuJ
 4uECS9Zm7eKmo3DgEWjYaHrqfWxRUJkLu8/XKXabQrbTXuqh7vAP4ZF6C4wB/jYdkgnR
 tUKWlWgtzVqpar2MXAu5uUXGsTETGhGohOE= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2ugebr8sj3-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 20 Aug 2019 06:21:38 -0700
Received: from prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 20 Aug 2019 06:21:36 -0700
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 20 Aug 2019 06:21:36 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 20 Aug 2019 06:21:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OZZh+Hsl0PBGBxHD/mz+Z3q4ZYIak6JE4MzwFOmx1S1RaRB8Uuj9K3eUtrN2c0r6g0HU3YcL3rnMnnAEGqXYXFClnakQI+WBuQnImL2JsOr7RfdEx2XaeO23dUU17XAl6BGGSgsHrm07pYN3plMQF8+VrQhK2flAKRPUyaAsNu2vXWz24DWo8cRFMQz1aY6OXwjzDvzpQTRagQ9kT9vh6j+EdnOwuMGLXlBy1Df8lWjp0H0j5ZEUuOH/DZc0pf1DDXQkJkjCXiQMZNgOtReBaJqmR88TIDV+VJSm8mZrZg2h/SyJ/oBRh9S9T5XjV1FjqovA78mnkUi0XrARtTMMvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QB+08b1v1rKYRA1qd5VIFpEw6MuG5H5/ZQKsylsIOnQ=;
 b=Eri7gvSlHdfrmLG7jPn1spmOwz0EJvlH6npmJxAf137N0Ui5NzEj6ViO0AXc4ZTF7G0yxCHq5u3JETfCZ9wkdY0A5+CyhlPpq+MtXJGeokEaNi1o8EatiNxfcRs8JR2VEoa5wn66vhL8TT5GY/Gx9L7uibHwe4cKJvB5ubj/Pe9/7EkRPRSgd6FIR+qUj0Wu0y2NsFGNvX7hfOKaoZv0nsf14dpQm+qnYzQHnczfUIVR91d7BLSxMT8nIZr/zZ7UlcNBvi5niKTePOJTdZmFGeEYXlJ9ISIR3Wf+/FNb6pzfG+Spo07wxo4Wo1swfPtx1o/R8sBkBfqEWkVLYKF1UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QB+08b1v1rKYRA1qd5VIFpEw6MuG5H5/ZQKsylsIOnQ=;
 b=WZ1LGxWz23/c7u1YPHGkxAPRAOuPi5w+UuIqP2MihH77ebq6ik1bzCprxLBEcma1Gx7Jkdol9frIX9wYmiI029hTOS1STPqzmNDho7A01Yx6jb4xZg5jWOL5ERj4aAbGygsd2ig4q+Ji75fWHZgv3nFoB0mqgcoA+3fC222/p1g=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1389.namprd15.prod.outlook.com (10.173.235.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Tue, 20 Aug 2019 13:21:34 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::45ee:bc50:acfa:60a5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::45ee:bc50:acfa:60a5%3]) with mapi id 15.20.2178.018; Tue, 20 Aug 2019
 13:21:34 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Thomas Gleixner <tglx@linutronix.de>
CC:     Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Kernel Team <Kernel-team@fb.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Joerg Roedel <jroedel@suse.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH] x86/mm/pti: in pti_clone_pgtable() don't increase addr by
 PUD_SIZE
Thread-Topic: [PATCH] x86/mm/pti: in pti_clone_pgtable() don't increase addr
 by PUD_SIZE
Thread-Index: AQHVVywgQMe0L9XqWkSJYmnWEvsfracDzfeAgAAVLICAACLjgA==
Date:   Tue, 20 Aug 2019 13:21:34 +0000
Message-ID: <44EA504D-2388-49EF-A807-B9712903B146@fb.com>
References: <20190820075128.2912224-1-songliubraving@fb.com>
 <20190820100055.GI2332@hirez.programming.kicks-ass.net>
 <alpine.DEB.2.21.1908201315450.2223@nanos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.21.1908201315450.2223@nanos.tec.linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::f412]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a8d7be68-7337-4fcf-5773-08d7257152a5
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MWHPR15MB1389;
x-ms-traffictypediagnostic: MWHPR15MB1389:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB1389D970D3918DB78D883C66B3AB0@MWHPR15MB1389.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 013568035E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(346002)(396003)(376002)(136003)(39860400002)(199004)(189003)(6246003)(2906002)(6506007)(25786009)(53936002)(8936002)(36756003)(66946007)(71200400001)(71190400001)(76116006)(7736002)(66476007)(4326008)(64756008)(66446008)(305945005)(66556008)(33656002)(46003)(229853002)(316002)(476003)(486006)(11346002)(446003)(6486002)(76176011)(8676002)(4744005)(14454004)(57306001)(5660300002)(86362001)(6512007)(6116002)(186003)(50226002)(478600001)(6436002)(81166006)(81156014)(54906003)(2616005)(256004)(6916009)(102836004)(53546011)(99286004);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1389;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: rRJhG79xTty+bTC3VtlXncgiUSb79nGzjwKi2LIwiN0a7LRBp2DkZ3GL4cWxJ4PBvHL+VRIodE3s0m3sXbbR9EQ8UfwNhQb4bUm4YP+m9liAsYZ1knnK+etdIsTmUuFpqblGOd55lhNXGtM0FdsFJ+5KdpubR87kS/xGsLzb4f++8Z0PaIwwANh019s/mr+sWadTid31vVkfPcqFuYB9JvTDQzlDENOASIArGpnzLePETbmgjkb3cJhsa7yPUVEz9HY7QZ4Y/R+RzVAYcaSWsT3WHEOKAmCTl2YKfGxKONr15DCywpiwEY/q1CQ49asUwmNxrh4jCW7iwYlaoZNbrT6nR6WWuqsM557VcODpOsrS7r3wmni543rm9RlYPAyicZSI4YBwpo4UJOIl39LcS8QdRULhmjDkkruoUdRySeY=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <58155422A2A47E4F9C5679A6D5EE2DEB@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a8d7be68-7337-4fcf-5773-08d7257152a5
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2019 13:21:34.2859
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Gt4p+FKoyA14w9ljmz03u/fKVwVDO+/GRGbefQXhOtBZG1SFErro2yczSUW2XkSEyPVA5C8UWlKpsDXPL7447A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1389
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-20_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=877 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908200140
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Aug 20, 2019, at 4:16 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>=20
> On Tue, 20 Aug 2019, Peter Zijlstra wrote:
>> What that code wants to do is skip to the end of the pud, a pmd_size
>> increase will not do that. And right below this, there's a second
>> instance of this exact pattern.
>>=20
>> Did I get the below right?
>>=20
>> ---
>> diff --git a/arch/x86/mm/pti.c b/arch/x86/mm/pti.c
>> index b196524759ec..32b20b3cb227 100644
>> --- a/arch/x86/mm/pti.c
>> +++ b/arch/x86/mm/pti.c
>> @@ -330,12 +330,14 @@ pti_clone_pgtable(unsigned long start, unsigned lo=
ng end,
>>=20
>> 		pud =3D pud_offset(p4d, addr);
>> 		if (pud_none(*pud)) {
>> +			addr &=3D PUD_MASK;
>> 			addr +=3D PUD_SIZE;
>=20
> 			round_up(addr, PUD_SIZE);

I guess we need "round_up(addr + PMD_SIZE, PUD_SIZE)".=20

Thanks,
Song

>=20
> perhaps?
>=20
>> 			continue;
>> 		}
>>=20
>> 		pmd =3D pmd_offset(pud, addr);
>> 		if (pmd_none(*pmd)) {
>> +			addr &=3D PMD_MASK;
>> 			addr +=3D PMD_SIZE;
>> 			continue;
>> 		}
>>=20

