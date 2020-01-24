Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0C0D148C82
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 17:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389186AbgAXQuq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 11:50:46 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:15372 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387875AbgAXQuq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jan 2020 11:50:46 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00OGocjN037085
        for <stable@vger.kernel.org>; Fri, 24 Jan 2020 11:50:43 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2xq3ma59n4-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Fri, 24 Jan 2020 11:50:43 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <gerald.schaefer@de.ibm.com>;
        Fri, 24 Jan 2020 16:50:28 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 24 Jan 2020 16:50:27 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00OGoQHN39911832
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 16:50:26 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 35D4E4C05C;
        Fri, 24 Jan 2020 16:50:26 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F1A494C058;
        Fri, 24 Jan 2020 16:50:25 +0000 (GMT)
Received: from thinkpad (unknown [9.145.149.112])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 24 Jan 2020 16:50:25 +0000 (GMT)
Date:   Fri, 24 Jan 2020 17:50:24 +0100
From:   Gerald Schaefer <gerald.schaefer@de.ibm.com>
To:     Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Cc:     linux390-list@tuxmaker.boeblingen.de.ibm.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] s390: prevent leaking kernel address in BEAR
In-Reply-To: <20200124122515.80348-1-svens@linux.ibm.com>
References: <20200124122515.80348-1-svens@linux.ibm.com>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20012416-0008-0000-0000-0000034C64AE
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20012416-0009-0000-0000-00004A6CD4F0
Message-Id: <20200124175024.6ebfc8c4@thinkpad>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-24_06:2020-01-24,2020-01-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 clxscore=1011 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 spamscore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001240137
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 24 Jan 2020 13:25:15 +0100
Sven Schnelle <svens@linux.ibm.com> wrote:

> When userspace executes a syscall or gets interrupted,
> BEAR contains a kernel address when returning to userspace.
> This make it pretty easy to figure out where the kernel is
> mapped even with KASLR enabled. To fix this, add lpswe to
> lowcore and always execute it there, so userspace sees only
> the lowcore address of lpswe. For this we have to extend
> both critical_cleanup and the SWITCH_ASYNC macro to also check
> for lpswe addresses in lowcore.
> 
> Fixes: b2d24b97b2a9 ("s390/kernel: add support for kernel address space layout randomization (KASLR)")
> Cc: <stable@vger.kernel.org> # v5.2+
> Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
> ---

Looks good,
Reviewed-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>

I think you can push to devel, but this should hang around a bit before
sending upstream (@Vasily). Maybe at least wait until Heiko can also
have a look.

Since the small extra window for critical section cleanup introduced by
the lowcore lpswe is hit surprisingly easy and often, this will get some
good testing on devel branch.

