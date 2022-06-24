Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1DA6559CC1
	for <lists+stable@lfdr.de>; Fri, 24 Jun 2022 17:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233235AbiFXOt2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jun 2022 10:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233873AbiFXOtF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jun 2022 10:49:05 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04EE88152F;
        Fri, 24 Jun 2022 07:44:36 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25ODhpVb031953;
        Fri, 24 Jun 2022 14:44:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type; s=pp1; bh=2pXMCIgHJV6KAGdqoqXTrc497x6cWYzX2MTlOhCHfl4=;
 b=thakw+/g02odGKiUDC6CL+Mg9JrkCnvzKayejAB6vNlXr0aJHBHlHgaCS9UdPfVWa1O5
 pX3eG5XU7hxDB/Gx2yy1LATUvIVqXioy9y8dsDGok8Dkq1rGi6P5j2w2/Nmi8I2heIso
 2++bH/7ski2J5YBNeIlX13RFZqIZFYAMaUsGSXI3GMfHXVM9rP6e/7gve50YhsjwZH9A
 mR/OSiPEeS8faHWWXpfb3M8CGzibS+5q+fOoDe9HDnXBidSh9RUcniwxp8GJjOAAP9BF
 6FgGXn5cxdCnwShIX4nfXv19NN5F9Md/WCvufz+T31fSPYB40ynZIQ9cWWYixGd7RqVe fA== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gwedesm7c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Jun 2022 14:44:13 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25OELiCV009114;
        Fri, 24 Jun 2022 14:44:12 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma03dal.us.ibm.com with ESMTP id 3gs6bajnun-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Jun 2022 14:44:12 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25OEiBP731719754
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jun 2022 14:44:11 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4C7C678063;
        Fri, 24 Jun 2022 14:44:11 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7870E7805E;
        Fri, 24 Jun 2022 14:44:10 +0000 (GMT)
Received: from localhost (unknown [9.65.252.72])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Fri, 24 Jun 2022 14:44:10 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linuxppc-dev@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] powerpc/kvm: don't crash on missing rng, and use
 darn
In-Reply-To: <20220624142322.2049826-3-Jason@zx2c4.com>
References: <20220624142322.2049826-1-Jason@zx2c4.com>
 <20220624142322.2049826-3-Jason@zx2c4.com>
Date:   Fri, 24 Jun 2022 11:44:08 -0300
Message-ID: <874k0aqfyf.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: WGq4-4M6-bGPoD6pQDgTmrzJ_4o1fsug
X-Proofpoint-GUID: WGq4-4M6-bGPoD6pQDgTmrzJ_4o1fsug
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-24_07,2022-06-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 phishscore=0 bulkscore=0
 mlxlogscore=604 spamscore=0 suspectscore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206240056
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

"Jason A. Donenfeld" <Jason@zx2c4.com> writes:

> On POWER8 systems that don't have ibm,power-rng available, a guest that
> ignores the KVM_CAP_PPC_HWRNG flag and calls H_RANDOM anyway will
> dereference a NULL pointer. And on machines with darn instead of
> ibm,power-rng, H_RANDOM won't work at all.
>
> This patch kills two birds with one stone, by routing H_RANDOM calls to
> ppc_md.get_random_seed, and doing the real mode check inside of it.
>
> Cc: stable@vger.kernel.org # v4.1+
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Fixes: e928e9cb3601 ("KVM: PPC: Book3S HV: Add fast real-mode H_RANDOM implementation.")
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>

