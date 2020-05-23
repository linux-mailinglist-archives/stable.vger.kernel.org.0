Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD8941DFAD3
	for <lists+stable@lfdr.de>; Sat, 23 May 2020 21:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387870AbgEWT51 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 May 2020 15:57:27 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:13884 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387593AbgEWT51 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 May 2020 15:57:27 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04NJWXYE140459;
        Sat, 23 May 2020 15:57:23 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 316x5b4daj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 23 May 2020 15:57:23 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 04NJvMDB188787;
        Sat, 23 May 2020 15:57:22 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 316x5b4da1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 23 May 2020 15:57:22 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 04NJslTY012439;
        Sat, 23 May 2020 19:57:20 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 316uf81594-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 23 May 2020 19:57:20 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04NJvIrf54657102
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 May 2020 19:57:18 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3BA07AE045;
        Sat, 23 May 2020 19:57:18 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5A6C0AE053;
        Sat, 23 May 2020 19:57:17 +0000 (GMT)
Received: from linux.ibm.com (unknown [9.148.201.18])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Sat, 23 May 2020 19:57:17 +0000 (GMT)
Date:   Sat, 23 May 2020 22:57:15 +0300
From:   Mike Rapoport <rppt@linux.ibm.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Linux-MM <linux-mm@kvack.org>, kernel test robot <lkp@intel.com>,
        Anatoly Pugachev <matorola@gmail.com>,
        mm-commits@vger.kernel.org, stable <stable@vger.kernel.org>
Subject: Re: [patch 09/11] sparc32: use PUD rather than PGD to get PMD in
 srmmu_nocache_init()
Message-ID: <20200523195715.GY1059226@linux.ibm.com>
References: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
 <20200523052309.4caVN81-C%akpm@linux-foundation.org>
 <20200523190145.GX1059226@linux.ibm.com>
 <CAHk-=wisORTa7QVPnFqNw9pFs62UiwgsD4C4d=MtYy1o4JPyGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wisORTa7QVPnFqNw9pFs62UiwgsD4C4d=MtYy1o4JPyGQ@mail.gmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-23_10:2020-05-22,2020-05-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 mlxscore=0 lowpriorityscore=0 bulkscore=0 priorityscore=1501
 suspectscore=1 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 clxscore=1015 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005230163
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 23, 2020 at 12:10:27PM -0700, Linus Torvalds wrote:
> On Sat, May 23, 2020 at 12:02 PM Mike Rapoport <rppt@linux.ibm.com> wrote:
> >
> > Unfortunately, this fixes a compile warning but breaks the boot :(
> 
> Argh. I delayed applying/merging this overnight to see if there were
> any reports, but this came in after I'd already merged Andrew's
> patches and pushed them out.

Actually, it's really by chance I noticed it tonight, although still it
was too late :)

> So it's in my tree now as commit c2bc26f7ca1f ("sparc32: use PUD
> rather than PGD to get PMD in srmmu_nocache_init()")
>
> > The correcteted patch is below, boot tested with qemu-systems-sparc.
> 
> Mind sending a patch relative to the previous one that already got merged?
 
Sure.

> Also, would it perhaps be worth it to just make __nocache_fix() not
> throw the type away? IOW, make it do something like
> 
>   #define __nocache_fix(VADDR) \
>         ((__typeof__(VADDR))__va(__nocache_pa(VADDR)))
> 
> or whatever? Wouldn't that show when those pgd/p4d/pud pointers get
> mis-used because they don't end up dropping the type info..

Yes, I'll look into it.

>               Linus

-- 
Sincerely yours,
Mike.
