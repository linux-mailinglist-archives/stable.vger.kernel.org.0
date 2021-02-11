Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A15131898B
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 12:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhBKLbc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 06:31:32 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:30344 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231591AbhBKL3U (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Feb 2021 06:29:20 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11BBIwUv195111;
        Thu, 11 Feb 2021 06:28:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=J8XkNxnzTANSvad+tV1zVRL62x8HQfAH1so5t6b2Bbo=;
 b=EZyr//4gR19waKYjTFOgeNKsc8GDtdp5LsQVkFovZlB7s7mB/sVakKR8NkT/zWa0tuey
 E9YCZA1gfj/USPu4SG4blYyG78QaX66+h0h26EHEcr6MbXKtsXnSrI1W8RkkHElhCfzF
 704pXQa4SfWY7GGrgIslGeOBCUPlIFad0iXTUemubQjiKorOhws/2GZb0b95j7jEo7Qb
 P36nZcrqM0Fxr5mdMW5+CWlPa2xFKEYNtX2aicES6wYAWE9pf2oZOA3R+cqGpLsNnj4C
 18xz2hEH3r1tfl5fDLoDHeRSgKn725/S1N6OrIfZmwZsb3Q79G1k5b5GJWExtKTgiTZt Sg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36n3kpg5uk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 06:28:16 -0500
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11BBQ4a5024006;
        Thu, 11 Feb 2021 06:28:16 -0500
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36n3kpg5u9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 06:28:16 -0500
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11BBRT06002943;
        Thu, 11 Feb 2021 11:28:15 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma04dal.us.ibm.com with ESMTP id 36hjr9xgmf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 11:28:15 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11BBSEtf12649134
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Feb 2021 11:28:14 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 77F02C6057;
        Thu, 11 Feb 2021 11:28:14 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2774FC6055;
        Thu, 11 Feb 2021 11:28:13 +0000 (GMT)
Received: from work-tp (unknown [9.65.218.248])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Thu, 11 Feb 2021 11:28:12 +0000 (GMT)
Date:   Thu, 11 Feb 2021 08:28:09 -0300
From:   Raoni Fassina Firmino <raoni@linux.ibm.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH] powerpc/64/signal: Fix regression in
 __kernel_sigtramp_rt64() semantics
Message-ID: <20210211112809.ao77vciijej5kdu7@work-tp>
References: <20210209150240.epboynhzuaia4qyr@work-tp>
 <YCPtOTuh0kOk7Xee@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YCPtOTuh0kOk7Xee@kroah.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-11_05:2021-02-10,2021-02-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 clxscore=1011 spamscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 mlxlogscore=999 lowpriorityscore=0 mlxscore=0 impostorscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102110094
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 10, 2021 at 03:27:05PM +0100, Greg KH wrote:
> On Tue, Feb 09, 2021 at 12:02:40PM -0300, Raoni Fassina Firmino wrote:
> > Repeated the same tests as the upstream code on top of v5.10.14 and
> > v5.9.16, tested on powerpc64 and powerpc64le, with a glibc build and
> > running the affected glibc's testcase[2], inspected that glibc's
> > backtrace() now gives the correct result and gdb backtrace also keeps
> > working as before.
> > 
> > I believe this should be backported to releases 5.9 and 5.10 as
> > userspace is affected in this releases. I hope I had tagged this
> > correctly in the patch.
> 
> Now added to 5.10.y, 5.9.y is long end-of-life so there is nothing we
> can do there, sorry.

No problem, I didn't know 5.9.y was already EOL, that is on me.

Thanks,

o/
Raoni
