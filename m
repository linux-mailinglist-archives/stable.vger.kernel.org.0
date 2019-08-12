Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1FD989526
	for <lists+stable@lfdr.de>; Mon, 12 Aug 2019 03:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbfHLBUB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Aug 2019 21:20:01 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:51072 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725870AbfHLBT6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Aug 2019 21:19:58 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7C1GjiO121373
        for <stable@vger.kernel.org>; Sun, 11 Aug 2019 21:19:57 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2uatsudbm7-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Sun, 11 Aug 2019 21:19:57 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <alastair@au1.ibm.com>;
        Mon, 12 Aug 2019 02:19:55 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 12 Aug 2019 02:19:52 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7C1JpxE48234554
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Aug 2019 01:19:51 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1B93D4203F;
        Mon, 12 Aug 2019 01:19:51 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BF80F42045;
        Mon, 12 Aug 2019 01:19:50 +0000 (GMT)
Received: from ozlabs.au.ibm.com (unknown [9.192.253.14])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 12 Aug 2019 01:19:50 +0000 (GMT)
Received: from adsilva.ozlabs.ibm.com (haven.au.ibm.com [9.192.254.114])
        (using TLSv1.2 with cipher AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ozlabs.au.ibm.com (Postfix) with ESMTPSA id A7973A021B;
        Mon, 12 Aug 2019 11:19:49 +1000 (AEST)
Subject: Re: [PATCH 1/2] powerpc: Allow flush_icache_range to work across
 ranges >4GB
From:   "Alastair D'Silva" <alastair@au1.ibm.com>
To:     Christophe Leroy <christophe.leroy@c-s.fr>
Cc:     stable@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Date:   Mon, 12 Aug 2019 11:19:49 +1000
In-Reply-To: <a9bcc457-9f9b-7010-6796-fb263135f8bc@c-s.fr>
References: <20190809004548.22445-1-alastair@au1.ibm.com>
         <a9bcc457-9f9b-7010-6796-fb263135f8bc@c-s.fr>
Organization: IBM Australia
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19081201-0028-0000-0000-0000038E9C09
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19081201-0029-0000-0000-00002450A655
Message-Id: <72a3fca157a508a9f1bc6ea20801b9227d788f1d.camel@au1.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-11_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=899 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908120012
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2019-08-09 at 10:59 +0200, Christophe Leroy wrote:
> 
> Le 09/08/2019 à 02:45, Alastair D'Silva a écrit :
> > From: Alastair D'Silva <alastair@d-silva.org>
> > 
> > When calling flush_icache_range with a size >4GB, we were masking
> > off the upper 32 bits, so we would incorrectly flush a range
> > smaller
> > than intended.
> > 
> > This patch replaces the 32 bit shifts with 64 bit ones, so that
> > the full size is accounted for.
> > 
> > Heads-up for backporters: the old version of flush_dcache_range is
> > subject to a similar bug (this has since been replaced with a C
> > implementation).
> 
> Can you submit a patch to stable, explaining this ?
> 

This patch was sent to stable too - or did you mean send another patch
for the stable asm version of flush_dcache_range?

-- 
Alastair D'Silva
Open Source Developer
Linux Technology Centre, IBM Australia
mob: 0423 762 819

