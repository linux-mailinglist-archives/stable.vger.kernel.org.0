Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27EB71F18FE
	for <lists+stable@lfdr.de>; Mon,  8 Jun 2020 14:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728684AbgFHMpK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 08:45:10 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:1454 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727052AbgFHMpJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jun 2020 08:45:09 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 058CYG9p039911;
        Mon, 8 Jun 2020 08:44:42 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31g41dryjv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Jun 2020 08:44:42 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 058CYfGw042717;
        Mon, 8 Jun 2020 08:44:41 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31g41drygf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Jun 2020 08:44:41 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 058CfLi6030267;
        Mon, 8 Jun 2020 12:44:38 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 31g2s7uyqy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Jun 2020 12:44:38 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 058CialR6422786
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Jun 2020 12:44:36 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8076C4C05A;
        Mon,  8 Jun 2020 12:44:36 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9CE6E4C04E;
        Mon,  8 Jun 2020 12:44:35 +0000 (GMT)
Received: from oc3871087118.ibm.com (unknown [9.145.56.93])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon,  8 Jun 2020 12:44:35 +0000 (GMT)
Date:   Mon, 8 Jun 2020 14:44:34 +0200
From:   Alexander Gordeev <agordeev@linux.ibm.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-s390@vger.kernel.org, Stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yury Norov <yury.norov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Kees Cook <keescook@chromium.org>,
        Matthew Wilcox <willy@infradead.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "Tobin C . Harding" <tobin@kernel.org>,
        Vineet Gupta <vineet.gupta1@synopsys.com>,
        Will Deacon <will.deacon@arm.com>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH RESEND2] lib: fix bitmap_parse() on 64-bit big endian
 archs
Message-ID: <20200608124433.GA28369@oc3871087118.ibm.com>
References: <1591611829-23071-1-git-send-email-agordeev@linux.ibm.com>
 <CAHp75VcFdrvNMj0TL8ZHxShqqGDM31Hy8vitmn9HOPjZ6f9uYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VcFdrvNMj0TL8ZHxShqqGDM31Hy8vitmn9HOPjZ6f9uYw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-08_12:2020-06-08,2020-06-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 adultscore=0 malwarescore=0 impostorscore=0 clxscore=1015 mlxlogscore=999
 bulkscore=0 suspectscore=0 cotscore=-2147483648 priorityscore=1501
 spamscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006080094
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 08, 2020 at 03:03:05PM +0300, Andy Shevchenko wrote:
> On Mon, Jun 8, 2020 at 1:26 PM Alexander Gordeev <agordeev@linux.ibm.com> wrote:
> >
> > Commit 2d6261583be0 ("lib: rework bitmap_parse()") does not
> > take into account order of halfwords on 64-bit big endian
> > architectures. As result (at least) Receive Packet Steering,
> > IRQ affinity masks and runtime kernel test "test_bitmap" get
> > broken on s390.
> 
> ...
> 
> > +#if defined(__BIG_ENDIAN) && defined(CONFIG_64BIT)
> 
> I think it's better to re-use existing patterns.
> 
> ipc/sem.c:1682:#if defined(CONFIG_64BIT) && defined(__BIG_ENDIAN)
> 
> > +static void save_x32_chunk(unsigned long *maskp, u32 chunk, int chunk_idx)
> > +{
> > +       maskp += (chunk_idx / 2);
> > +       ((u32 *)maskp)[(chunk_idx & 1) ^ 1] = chunk;
> > +}
> > +#else
> > +static void save_x32_chunk(unsigned long *maskp, u32 chunk, int chunk_idx)
> > +{
> > +       ((u32 *)maskp)[chunk_idx] = chunk;
> > +}
> > +#endif
> 
> See below.
> 
> ...
> 
> > -               end = bitmap_get_x32_reverse(start, end, bitmap++);
> > +               end = bitmap_get_x32_reverse(start, end, &chunk);
> >                 if (IS_ERR(end))
> >                         return PTR_ERR(end);
> > +
> > +               save_x32_chunk(maskp, chunk, chunk_idx++);
> 
> Can't we simple do
> 
>         int chunk_index = 0;
>         ...
>         do {
> #if defined(CONFIG_64BIT) && defined(__BIG_ENDIAN)
>                end = bitmap_get_x32_reverse(start, end,
> bitmap[chunk_index ^ 1]);
> #else
>                end = bitmap_get_x32_reverse(start, end, bitmap[chunk_index]);
> #endif
>         ...
>         } while (++chunk_index);
> 
> ?

Well, unless we ignore coding style 21) Conditional Compilation
we could. Do you still insist it would be better?

Thanks for the review!

> -- 
> With Best Regards,
> Andy Shevchenko
