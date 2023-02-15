Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 176EA697D82
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 14:35:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbjBONfn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 08:35:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjBONfn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 08:35:43 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC80F3C3D
        for <stable@vger.kernel.org>; Wed, 15 Feb 2023 05:35:41 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31FCs0tM015902;
        Wed, 15 Feb 2023 13:35:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=UbLCmT1heIepZu1hpVkj9YrJAjOzfg/2zyCPGn+l8Z8=;
 b=rfEmVCwCpuZYOIpP1zNxRHSfPXNEEY4cPE31vtG/vB0/kQWyXZYJJ5FQt+PtBMhzDzun
 Tg2NOsMhWe/fVGqUwwur3wGbNsX0rqfVxH7kB+GP1EjbK3pLe//ETkkOiD5eGc/eqGNx
 MNHzuVC4g5k/lDYMyRkgNR7iwKQAAzYavCKtuAxtKIM3M6iMf9tTXXzeMCWRDtd2Jt81
 ztQqsJIQ7bo0hT5m4tv5ipmXuKw+bJS5/DJiHBKfimXQfFbVbGebEOmBT4S8Nd5xxgZu
 c9gn7561tPqjNddNMheinlCnWfDWJ8RJu/UlgEO/sE3wnIKdkFvo0a21DMw4GbG2oa1W Dw== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nryt89bhu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Feb 2023 13:35:33 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31FCaXei017578;
        Wed, 15 Feb 2023 13:35:31 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3np2n6ndcd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Feb 2023 13:35:31 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31FDZQjw22938330
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Feb 2023 13:35:26 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B1CE20040;
        Wed, 15 Feb 2023 13:35:26 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B5B0120043;
        Wed, 15 Feb 2023 13:35:25 +0000 (GMT)
Received: from osiris (unknown [9.171.86.127])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Wed, 15 Feb 2023 13:35:25 +0000 (GMT)
Date:   Wed, 15 Feb 2023 14:35:24 +0100
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Sumanth Korikkar <sumanthk@linux.ibm.com>, stable@vger.kernel.org,
        debian-s390@lists.debian.org, debian-kernel@lists.debian.org,
        svens@linux.ibm.com, gor@linux.ibm.com, Ulrich.Weigand@de.ibm.com,
        dipak.zope1@ibm.com
Subject: Re: [PATCH 0/1] s390: fix endless loop in do_signal
Message-ID: <Y+zfnNPp6SZ4lXxe@osiris>
References: <20230215120413.949348-1-sumanthk@linux.ibm.com>
 <Y+zcyBGnQ9BuLwFv@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+zcyBGnQ9BuLwFv@kroah.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: D92AeAJC0zwENdXwKWYgfEA4Du8sh-OL
X-Proofpoint-GUID: D92AeAJC0zwENdXwKWYgfEA4Du8sh-OL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-15_06,2023-02-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 impostorscore=0 mlxlogscore=650 suspectscore=0 lowpriorityscore=0
 clxscore=1011 mlxscore=0 priorityscore=1501 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302150122
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 15, 2023 at 02:23:20PM +0100, Greg KH wrote:
> On Wed, Feb 15, 2023 at 01:04:12PM +0100, Sumanth Korikkar wrote:
> > Hi,
> > 
> > This patch fixes the issue for s390  stable kernel starting  5.10.162.
> > The issue was specifically seen after stable version 5.10.162:
> > Following commits can trigger it:
> > 1. stable commit id - 788d0824269b ("io_uring: import 5.15-stable
> > io_uring") can trigger this problem.
> > 2. upstream commit id - 75309018a24d ("s390: add support for
> > TIF_NOTIFY_SIGNAL")
> > 
> > Problem:
> > qemu and user processes could stall when TIF_NOTIFY_SIGNAL is set from
> > io_uring work.
> > 
> > Affected users:
> > The issue was first raised by the debian team, where the s390
> > bullseye build systems are affected.
> > 
> > Upstream commit Id:
> > * The attached patch has no upstream commit. However, the stable kernel
> > 5.10.162+ uses upstream commit id - 75309018a24d ("s390: add support for
> > TIF_NOTIFY_SIGNAL"), which would need this fix
> > * Starting from v5.12, there are s390 generic entry commits 
> > 56e62a737028 ("s390: convert to generic entry")  and its relevant fixes,
> > which are recommended and should address these problems.
> 
> I'm sorry, but I do not understand.  What exact commits should be added
> to the 5.10.y tree to resolve this?

Only the patch sent by Sumanth as reply to this cover letter should be
added to the 5.10.y tree.

The problem that is addressed here is that commit 75309018a24d ("s390: add
support for TIF_NOTIFY_SIGNAL") was backported to 5.10. This commit is
broken, but nobody noticed upstream, since shortly after s390 converted to
generic entry with commit 56e62a737028 ("s390: convert to generic entry"),
which implicitly fixed that.

I doesn't look sane to backport commit 56e62a737028 ("s390: convert to
generic entry"), since that is huge and came with a lot of bugs, where I'm
not sure if all bug fixes had Fixes tags.

So the one-liner provided by Sumanth seems to be the best way to address
this bug.
