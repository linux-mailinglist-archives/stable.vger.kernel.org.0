Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69A4E561D6F
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 16:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236516AbiF3OI0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 10:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236621AbiF3OHG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 10:07:06 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F765E3D
        for <stable@vger.kernel.org>; Thu, 30 Jun 2022 06:54:24 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25UCrZPe003792;
        Thu, 30 Jun 2022 13:54:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to; s=pp1;
 bh=ykWO3szqez1BIuaj1Q5ZQQqd74reoS4gGKLUepIXgXc=;
 b=rC6vevhB9tzpS+7fT1AddWv5p6V5XC7SBBNW2jlG9u+T2BlUokspqySRHprOg2ByOwrn
 g9PktT8rpPv5vPKmf+lHrQG7gacnX8qZwC8cya5N66wbvWeqpKemO/d/a7LCsLJJKmaU
 rlJrnpl7yerXoHKiuC0DCUjVDqSEBK+GF36abMio0gb0faQ0rHiyctGCQFQ+yxIoKb6u
 OoiEhnLOZ8yWIQYTmpizfMRkgf1CPO4V8VpDeLIiDi/Wga2OUmkf18qvCODufadGoQ/B
 hqpMJshE9dwZVlBoezoLyKja/iwpVox9JEewIGTTVColG5kQLbHzJ3A3lni9iXUL+Gmi 4w== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h1c82t07f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Jun 2022 13:54:11 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25UDp10S016843;
        Thu, 30 Jun 2022 13:54:09 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3gwt0906wf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Jun 2022 13:54:09 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25UDs76924183258
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jun 2022 13:54:07 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9DC99A4053;
        Thu, 30 Jun 2022 13:54:07 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9102CA4040;
        Thu, 30 Jun 2022 13:54:06 +0000 (GMT)
Received: from smtpclient.apple (unknown [9.43.87.229])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 30 Jun 2022 13:54:06 +0000 (GMT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: [PATCH] powerpc/powernv: delay rng of node creation until later
 in boot
From:   Sachin Sant <sachinp@linux.ibm.com>
In-Reply-To: <20220630121654.1939181-1-Jason@zx2c4.com>
Date:   Thu, 30 Jun 2022 19:24:05 +0530
Cc:     linuxppc-dev@lists.ozlabs.org,
        Michael Ellerman <mpe@ellerman.id.au>, stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <8A9A296D-D7BD-42BE-AB32-C951C29E4C40@linux.ibm.com>
References: <Yr2PQSZWVtr+Y7a2@zx2c4.com>
 <20220630121654.1939181-1-Jason@zx2c4.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
X-Mailer: Apple Mail (2.3696.100.31)
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: m2zEpfcZKIrtkS4anqfpknm_BwEPNiQg
X-Proofpoint-ORIG-GUID: m2zEpfcZKIrtkS4anqfpknm_BwEPNiQg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-30_09,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 adultscore=0 impostorscore=0 lowpriorityscore=0 mlxlogscore=716
 spamscore=0 clxscore=1011 phishscore=0 priorityscore=1501 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206300054
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On 30-Jun-2022, at 5:46 PM, Jason A. Donenfeld <Jason@zx2c4.com> =
wrote:
>=20
> The of node for the rng must be created much later in boot. Otherwise =
it
> tries to connect to a parent that doesn't yet exist, resulting on this
> splat:
>=20
> [    0.000478] kobject: '(null)' ((____ptrval____)): is not =
initialized, yet kobject_get() is being called.
> [    0.002925] [c000000002a0fb30] [c00000000073b0bc] =
kobject_get+0x8c/0x100 (unreliable)
> [    0.003071] [c000000002a0fba0] [c00000000087e464] =
device_add+0xf4/0xb00
> [    0.003194] [c000000002a0fc80] [c000000000a7f6e4] =
of_device_add+0x64/0x80
> [    0.003321] [c000000002a0fcb0] [c000000000a800d0] =
of_platform_device_create_pdata+0xd0/0x1b0
> [    0.003476] [c000000002a0fd00] [c00000000201fa44] =
pnv_get_random_long_early+0x240/0x2e4
> [    0.003623] [c000000002a0fe20] [c000000002060c38] =
random_init+0xc0/0x214
>=20
> This patch fixes the issue by doing the of node creation inside of
> machine_subsys_initcall.
>=20
> Fixes: f3eac426657d ("powerpc/powernv: wire up rng during setup_arch")
> Cc: stable@vger.kernel.org
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Reported-by: Sachin Sant <sachinp@linux.ibm.com>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---

Thanks Jason for the patch. This fixes the reported problem for me.

Tested-by: Sachin Sant <sachinp@linux.ibm.com>

- Sachin

