Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8275B6641C9
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 14:29:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233023AbjAJN33 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 08:29:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232102AbjAJN31 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 08:29:27 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB2D4BDA;
        Tue, 10 Jan 2023 05:29:22 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30ACg99x012519;
        Tue, 10 Jan 2023 13:29:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=SB7rMwOE94Li0kjdEjnPUTF6MqoJXwPV27PO5V8sPIw=;
 b=tXlYsGuZ7Fz1FC2PV56yv5nC6d0REY2z0/cXQFYHBdvTt9xKsVH9sm/Ydivn/wFPllDM
 r/+4LS4sQJaNGLneVi9sD8VipfGQA+PAaRWNYzoDQ4KnbYbrcpVdczXqD+TIDHvSqgFX
 knN9lspNr4BS/xHgdBfyR//dM6icfyA6W448O0d/JH2lCsDs+dVSMXJwdX2sHtGO9w/v
 SDCgVIE7tr5JRUjTjse8pnV9+DExP1t2SnFP6HUsXQ/DaPkDdST7qnVfEAfRgEJD4SxF
 QP23nW74kC0I7No3shMu39E/u/SsWl/dCPXqFdP9SZia4zvTn5RVMCKFGJcvfVlJXVgk Vg== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n188ds5m1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Jan 2023 13:29:10 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30ACgEGd007636;
        Tue, 10 Jan 2023 13:29:10 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([9.208.129.114])
        by ppma04dal.us.ibm.com (PPS) with ESMTPS id 3my0c7p90g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Jan 2023 13:29:09 +0000
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
        by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30ADT8pE43188686
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Jan 2023 13:29:08 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 94F2F58055;
        Tue, 10 Jan 2023 13:29:08 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 791AA5804B;
        Tue, 10 Jan 2023 13:29:07 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown [9.160.108.101])
        by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 10 Jan 2023 13:29:07 +0000 (GMT)
Message-ID: <22d40a8820ebbf593d0e905cddc48a20e4796e8b.camel@linux.ibm.com>
Subject: Re: [PATCH v7 0/3] ima: Fix IMA mishandling of LSM based rule during
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Paul Moore <paul@paul-moore.com>, GUO Zihua <guozihua@huawei.com>
Cc:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-integrity@vger.kernel.org, luhuaxin1@huawei.com
Date:   Tue, 10 Jan 2023 08:29:07 -0500
In-Reply-To: <CAHC9VhR7JXB5KNGardhRA2422VLEUmWVx-AQVPCFANikdsUbEw@mail.gmail.com>
References: <20230106012106.21559-1-guozihua@huawei.com>
         <CAHC9VhR7JXB5KNGardhRA2422VLEUmWVx-AQVPCFANikdsUbEw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: -9Zs3rnysCerG7y0SOVbOn_ltY6O_iSM
X-Proofpoint-GUID: -9Zs3rnysCerG7y0SOVbOn_ltY6O_iSM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-10_04,2023-01-10_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 phishscore=0 adultscore=0 suspectscore=0 spamscore=0 priorityscore=1501
 bulkscore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301100081
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2023-01-09 at 21:51 -0500, Paul Moore wrote:
> On Thu, Jan 5, 2023 at 8:24 PM GUO Zihua <guozihua@huawei.com> wrote:
> >
> > Backports the following three patches to fix the issue of IMA mishandling
> > LSM based rule during LSM policy update, causing a file to match an
> > unexpected rule.
> >
> > v7:
> >   Fixed the target for free in ima_lsm_copy_rule().
> >
> > v6:
> >   Removed the redundent i in ima_free_rule().
> >
> > v5:
> >   goes back to ima_lsm_free_rule() instead to avoid freeing
> > rule->fsname.
> >
> > v4:
> >   Make use of the exisiting ima_free_rule() instead of backported
> > ima_lsm_free_rule(). Which resolves additional memory leak issues.
> >
> > v3:
> >   Backport "LSM: switch to blocking policy update notifiers" as well, as
> > the prerequsite of "ima: use the lsm policy update notifier".
> >
> > v2:
> >   Re-adjust the bacported logic.
> >
> > GUO Zihua (1):
> >   ima: Handle -ESTALE returned by ima_filter_rule_match()
> >
> > Janne Karhunen (2):
> >   LSM: switch to blocking policy update notifiers
> >   ima: use the lsm policy update notifier
> 
> I'll defer to Mimi for the IMA bits, but the LSM and SELinux related
> bits looks fine to me and appear to be faithful backports of patches
> already in Linus' tree.

Thanks, Paul, for reviewing and confirming that it looks fine.

Mimi

> 
> >  drivers/infiniband/core/device.c    |   4 +-
> >  include/linux/security.h            |  12 +--
> >  security/integrity/ima/ima.h        |   2 +
> >  security/integrity/ima/ima_main.c   |   8 ++
> >  security/integrity/ima/ima_policy.c | 151 ++++++++++++++++++++++------
> >  security/security.c                 |  23 +++--
> >  security/selinux/hooks.c            |   2 +-
> >  security/selinux/selinuxfs.c        |   2 +-
> >  8 files changed, 155 insertions(+), 49 deletions(-)
> >
> > --
> > 2.17.1
> 


