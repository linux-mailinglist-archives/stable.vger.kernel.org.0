Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 897BC2CD9AB
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 15:57:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730914AbgLCOzt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 09:55:49 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39640 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725903AbgLCOzs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Dec 2020 09:55:48 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B3Eexhl182531;
        Thu, 3 Dec 2020 09:54:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=aTanWXDu6GDQOgBiwV6VCa4+Gz8xmuiEnuHmxtcgxPE=;
 b=JqgdPm8hiRdcgHmP2Asq50K14PiR4++DD5Vd+nt7oiR5rd0dVWxNV+CyaTMf2v55XBpe
 s+gVM1OtIwF2Xnm6yZRH5aEnHoH29g2Yy8k/Ydrh+57AZhG9ihxP6O/ACCzsKz7KkpOm
 9uS4eAhzbs0Rj2Rj4AMToilq6M0k4MDriKFj72s90FNSX+Q9/pCO+3fSr2ZGQr23vN8l
 GYsZ4WHeDjYTuCodVhHapE4fIyykKImPmGci1Z/T4XpayaYDLVLAdQj2574h9vrX3CRA
 fq8QCuZA7L9FqVJdEZDAIvcQsl+YOkjb9kuPNJCT0dbuGMlFlnmoHAfQVay2BAazStvv tQ== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3571nssyg2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Dec 2020 09:54:49 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B3EppGY020571;
        Thu, 3 Dec 2020 14:54:47 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 35693xh8ty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Dec 2020 14:54:47 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B3EsjwT26083698
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Dec 2020 14:54:45 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DDC8C11C054;
        Thu,  3 Dec 2020 14:54:44 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0F8A611C058;
        Thu,  3 Dec 2020 14:54:44 +0000 (GMT)
Received: from osiris (unknown [9.171.50.208])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu,  3 Dec 2020 14:54:43 +0000 (GMT)
Date:   Thu, 3 Dec 2020 15:54:42 +0100
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Sven Schnelle <svens@linux.ibm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-csky@vger.kernel.org, uclinux-h8-devel@lists.sourceforge.jp,
        linux-hexagon@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux-mips@vger.kernel.org, openrisc@lists.librecores.org,
        linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-um@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 5.9 27/39] sched/idle: Fix arch_cpu_idle() vs
 tracing
Message-ID: <20201203145442.GC9994@osiris>
References: <20201203132834.930999-1-sashal@kernel.org>
 <20201203132834.930999-27-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201203132834.930999-27-sashal@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-03_07:2020-12-03,2020-12-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=999 bulkscore=0 clxscore=1031 priorityscore=1501 adultscore=0
 suspectscore=0 spamscore=0 phishscore=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012030085
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 03, 2020 at 08:28:21AM -0500, Sasha Levin wrote:
> From: Peter Zijlstra <peterz@infradead.org>
> 
> [ Upstream commit 58c644ba512cfbc2e39b758dd979edd1d6d00e27 ]
> 
> We call arch_cpu_idle() with RCU disabled, but then use
> local_irq_{en,dis}able(), which invokes tracing, which relies on RCU.
> 
> Switch all arch_cpu_idle() implementations to use
> raw_local_irq_{en,dis}able() and carefully manage the
> lockdep,rcu,tracing state like we do in entry.
> 
> (XXX: we really should change arch_cpu_idle() to not return with
> interrupts enabled)
> 
> Reported-by: Sven Schnelle <svens@linux.ibm.com>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Reviewed-by: Mark Rutland <mark.rutland@arm.com>
> Tested-by: Mark Rutland <mark.rutland@arm.com>
> Link: https://lkml.kernel.org/r/20201120114925.594122626@infradead.org
> Signed-off-by: Sasha Levin <sashal@kernel.org>

This patch broke s390 irq state tracing. A patch to fix this is
scheduled to be merged upstream today (hopefully).
Therefore I think this patch should not yet go into 5.9 stable.
