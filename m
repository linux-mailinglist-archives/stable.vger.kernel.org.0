Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4308AF812
	for <lists+stable@lfdr.de>; Wed, 11 Sep 2019 10:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727290AbfIKIgr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Sep 2019 04:36:47 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49108 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727152AbfIKIgr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Sep 2019 04:36:47 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8B8Vo6G119802
        for <stable@vger.kernel.org>; Wed, 11 Sep 2019 04:36:46 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2uxc00e65n-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Wed, 11 Sep 2019 04:36:46 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <frankja@linux.ibm.com>;
        Wed, 11 Sep 2019 09:36:43 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 11 Sep 2019 09:36:40 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8B8adlH56229922
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Sep 2019 08:36:39 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0FE1BAE051;
        Wed, 11 Sep 2019 08:36:39 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ACAD3AE057;
        Wed, 11 Sep 2019 08:36:38 +0000 (GMT)
Received: from dyn-9-152-224-131.boeblingen.de.ibm.com (unknown [9.152.224.131])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 11 Sep 2019 08:36:38 +0000 (GMT)
Subject: Re: [PATCH v2] KVM: s390: kvm_s390_vm_start_migration: check
 dirty_bitmap before using it as target for memset()
To:     Igor Mammedov <imammedo@redhat.com>, linux-kernel@vger.kernel.org
Cc:     borntraeger@de.ibm.com, david@redhat.com, cohuck@redhat.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        imbrenda@linux.ibm.com, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, stable@vger.kernel.org
References: <20190911075218.29153-1-imammedo@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Wed, 11 Sep 2019 10:36:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190911075218.29153-1-imammedo@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="vRyjy3CQeEKOH3G9VNNkmYEGONAMZRI1Y"
X-TM-AS-GCONF: 00
x-cbid: 19091108-0016-0000-0000-000002A9EF85
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19091108-0017-0000-0000-0000330A7A92
Message-Id: <19baa04d-0d77-7a80-65e2-e00b0d096811@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-11_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=817 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1909110081
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vRyjy3CQeEKOH3G9VNNkmYEGONAMZRI1Y
Content-Type: multipart/mixed; boundary="dzBoqpYyJe1rGZE0BD3rqKHntsX41AMyO";
 protected-headers="v1"
From: Janosch Frank <frankja@linux.ibm.com>
To: Igor Mammedov <imammedo@redhat.com>, linux-kernel@vger.kernel.org
Cc: borntraeger@de.ibm.com, david@redhat.com, cohuck@redhat.com,
 heiko.carstens@de.ibm.com, gor@linux.ibm.com, imbrenda@linux.ibm.com,
 linux-s390@vger.kernel.org, kvm@vger.kernel.org, stable@vger.kernel.org
Message-ID: <19baa04d-0d77-7a80-65e2-e00b0d096811@linux.ibm.com>
Subject: Re: [PATCH v2] KVM: s390: kvm_s390_vm_start_migration: check
 dirty_bitmap before using it as target for memset()
References: <20190911075218.29153-1-imammedo@redhat.com>
In-Reply-To: <20190911075218.29153-1-imammedo@redhat.com>

--dzBoqpYyJe1rGZE0BD3rqKHntsX41AMyO
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 9/11/19 9:52 AM, Igor Mammedov wrote:
> If userspace doesn't set KVM_MEM_LOG_DIRTY_PAGES on memslot before call=
ing
> kvm_s390_vm_start_migration(), kernel will oops with:
>=20
>   Unable to handle kernel pointer dereference in virtual kernel address=
 space
>   Failing address: 0000000000000000 TEID: 0000000000000483
>   Fault in home space mode while using kernel ASCE.
>   AS:0000000002a2000b R2:00000001bff8c00b R3:00000001bff88007 S:0000000=
1bff91000 P:000000000000003d
>   Oops: 0004 ilc:2 [#1] SMP
>   ...
>   Call Trace:
>   ([<001fffff804ec552>] kvm_s390_vm_set_attr+0x347a/0x3828 [kvm])
>    [<001fffff804ecfc0>] kvm_arch_vm_ioctl+0x6c0/0x1998 [kvm]
>    [<001fffff804b67e4>] kvm_vm_ioctl+0x51c/0x11a8 [kvm]
>    [<00000000008ba572>] do_vfs_ioctl+0x1d2/0xe58
>    [<00000000008bb284>] ksys_ioctl+0x8c/0xb8
>    [<00000000008bb2e2>] sys_ioctl+0x32/0x40
>    [<000000000175552c>] system_call+0x2b8/0x2d8
>   INFO: lockdep is turned off.
>   Last Breaking-Event-Address:
>    [<0000000000dbaf60>] __memset+0xc/0xa0
>=20
> due to ms->dirty_bitmap being NULL, which might crash the host.
>=20
> Make sure that ms->dirty_bitmap is set before using it or
> return -ENIVAL otherwise.

Fixed that while picking and added my reviewed-by, as well as the others
you removed.
Thanks for your patch.


--dzBoqpYyJe1rGZE0BD3rqKHntsX41AMyO--

--vRyjy3CQeEKOH3G9VNNkmYEGONAMZRI1Y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl14shYACgkQ41TmuOI4
ufhBAhAAoOSaWNtX+nzRWC/HmJHPpeav8+63Qo91vK6EVOpXq/A4mKa1Hcb/IMbg
wrXMAxEg3ODpSBTHJzp9t9MjQwdHO8SKfJvcMAJhGHzeEuLycUSBbBdOns1UFwtl
xa1Xcxlk3j8jVCqeQZCQHayj2iSKVlCeF6BVhvmtbMjMBwlUdrkjG3Fc1nX0XngU
BrE+Of03FCmOe0PBa6OU5IsWyGDb6hO30uY7rdf79jPeb15TQqyEJtzSfoLcc4qh
3+6z9QVmJfC/he2kb7KB7K8KDzBTIp8QQUan4R/XGDKqVGkoIB/WPdkkVXNxoGSf
Zy7i531iDZ8eexEwWP2dUSC681r7fermJUS7JWGmvuR15iGhfIvEkliQKG2kmQQ8
U9aeCtrW6hC2/zXbfJ3RZUl4/Km668cUMolgn2lSbta2p2ASsKZ/YsNFkVQYX9t2
cowNHv59ClN87LHRRzQDJj5lUVvncLG8oc7BK9o4Azo3y2iT8Hko7J2TJx1rHXjZ
yUgSTsVOVhMXEdcGCmwgIZ964EAW0L2NnqXFrf8qUfo04yMgWwOPbThDYwx2o4XI
mT6XsfiqUo+TIrqxJObH9cJEWJHT6ld3+AWqyWuApnZ/11lLT7Ue1Y2PO/xhLhHE
qhUXYZgF1gQyRY2N1LD5w+GqZWtclRDf+/hA0d2tJrpzf49dKd4=
=6bmL
-----END PGP SIGNATURE-----

--vRyjy3CQeEKOH3G9VNNkmYEGONAMZRI1Y--

