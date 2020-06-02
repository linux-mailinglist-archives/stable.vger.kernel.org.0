Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6FB1EB98A
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 12:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbgFBKZf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 06:25:35 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45844 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726217AbgFBKZD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jun 2020 06:25:03 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0529W2sD115764;
        Tue, 2 Jun 2020 06:24:39 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31dfmksvxg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Jun 2020 06:24:39 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0529aMS7132792;
        Tue, 2 Jun 2020 06:24:38 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31dfmksvw6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Jun 2020 06:24:38 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 052AK7EJ031346;
        Tue, 2 Jun 2020 10:24:36 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 31bf47tcdp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Jun 2020 10:24:35 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 052ANIxI53412138
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Jun 2020 10:23:18 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 889CF5205F;
        Tue,  2 Jun 2020 10:24:33 +0000 (GMT)
Received: from oc3871087118.ibm.com (unknown [9.145.29.146])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id B65545204E;
        Tue,  2 Jun 2020 10:24:32 +0000 (GMT)
Date:   Tue, 2 Jun 2020 12:24:31 +0200
From:   Alexander Gordeev <agordeev@linux.ibm.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-s390@vger.kernel.org, Stable <stable@vger.kernel.org>,
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
Subject: Re: [PATCH RESEND] lib: fix bitmap_parse() on 64-bit big endian archs
Message-ID: <20200602102430.GA17703@oc3871087118.ibm.com>
References: <1589798090-11136-1-git-send-email-agordeev@linux.ibm.com>
 <CAHp75VdM2yrpd2d3pK2RkmbhF3yiM4=fiTXL4i3yu3AxV3wY-A@mail.gmail.com>
 <20200518115059.GA19150@oc3871087118.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200518115059.GA19150@oc3871087118.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-02_11:2020-06-01,2020-06-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 suspectscore=0 adultscore=0
 cotscore=-2147483648 bulkscore=0 phishscore=0 clxscore=1015
 impostorscore=0 spamscore=0 priorityscore=1501 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006020061
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 18, 2020 at 01:50:59PM +0200, Alexander Gordeev wrote:
> On Mon, May 18, 2020 at 02:33:43PM +0300, Andy Shevchenko wrote:
> > On Mon, May 18, 2020 at 1:40 PM Alexander Gordeev
> > <agordeev@linux.ibm.com> wrote:
> > >
> > > Commit 2d6261583be0 ("lib: rework bitmap_parse()") does
> > > not take into account order of halfwords on 64-bit big
> > > endian architectures.
> > 
> > Thanks for report and the patch!
> > 
> > Did it work before? Can we have a test case for that that we will see
> > the failure?
> 
> The test exists and enabled with CONFIG_TEST_BITMAP.
> It does not appear ever passed before on 64 BE.
> It does not fail on 64 LE for me either.

Hi Andy et al,

Any feedback on the fix? Does it work on 64 LE for you?

Thanks!

> Thanks!
> 
> [...]
> 
> > -- 
> > With Best Regards,
> > Andy Shevchenko
