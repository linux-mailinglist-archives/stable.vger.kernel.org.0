Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E23722AFA4
	for <lists+stable@lfdr.de>; Thu, 23 Jul 2020 14:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbgGWMp1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jul 2020 08:45:27 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:57968 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726714AbgGWMp0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jul 2020 08:45:26 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06NCgeTD174866;
        Thu, 23 Jul 2020 12:44:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=cK2cFgOis2R+DBBvDtAyjAEsg79zt26p7s0U22V+oDA=;
 b=HlGBnyPnqNQzXrpwqmi6w63ragjArwk5iCoq7qX0djpFnSOF1h5MbEIgaD0u7jIwvxb3
 DujVQJ8d6ma+w1ej7zY2S8HskonJ4pfMvxTx6DNozFTwoykLyG5Tnb0sPGiNXxF6LfSs
 kZhZecVBXRXtgtMzUiae2ugNfYAdBknC7cWlkO89xENhhlnY0Q14e62XxHArSssuVigo
 VuxiNIIzDpBSKmIYagVS/McBd4fByhhKyi/wLX1y9m8oW1R9RNeSaBLJ6NaM9VPXW15u
 9srrF/hqcl1fQkCbO/QJBQ/r0PlleQuHtsXx29k9xJDMWv36L/COZtaq2MGXyQovbUVA /w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 32brgrs4ac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 23 Jul 2020 12:44:56 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06NCh8kb173785;
        Thu, 23 Jul 2020 12:44:55 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 32f9wbv78y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jul 2020 12:44:55 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06NCirpv002706;
        Thu, 23 Jul 2020 12:44:54 GMT
Received: from localhost (/10.175.219.9)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 Jul 2020 12:44:53 +0000
Date:   Thu, 23 Jul 2020 14:44:50 +0200
From:   Gregory Herrero <gregory.herrero@oracle.com>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        stable@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com
Subject: Re: [PATCH] recordmcount: only record relocation of type
 R_AARCH64_CALL26 on arm64.
Message-ID: <20200723124450.GA14422@ltoracle>
References: <20200717143338.19302-1-gregory.herrero@oracle.com>
 <20200723115216.GA17032@C02TD0UTHF1T.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200723115216.GA17032@C02TD0UTHF1T.local>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9690 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 phishscore=0 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007230094
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9690 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 impostorscore=0 suspectscore=2 adultscore=0 clxscore=1011 mlxlogscore=999
 priorityscore=1501 phishscore=0 lowpriorityscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007230094
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Mark,

On Thu, Jul 23, 2020 at 12:52:16PM +0100, Mark Rutland wrote:
> Hi Gregory,
> 
> As a general thing, for patches affecting arm64 could you please Cc the
> linx-arm-kernel mailing list (linux-arm-kernel@lists.infradead.org).
> Some folk working on arm/arm64 aren't subscribed to LKML, and it means
> patches like this may get missed.
> 
Got it, I will do that next time.

> On Fri, Jul 17, 2020 at 04:33:38PM +0200, gregory.herrero@oracle.com wrote:
> > From: Gregory Herrero <gregory.herrero@oracle.com>
> > 
> > Currently, if a section has a relocation to '_mcount' symbol, a new
> > __mcount_loc entry will be added whatever the relocation type is.
> > This is problematic when a relocation to '_mcount' is in the middle of a
> > section and is not a call for ftrace use.
> > 
> > Such relocation could be generated with below code for example:
> >     bool is_mcount(unsigned long addr)
> >     {
> >         return (target == (unsigned long) &_mcount);
> >     }
> > 
> > With this snippet of code, ftrace will try to patch the mcount location
> > generated by this code on module load and fail with:
> > 
> >     Call trace:
> >      ftrace_bug+0xa0/0x28c
> >      ftrace_process_locs+0x2f4/0x430
> >      ftrace_module_init+0x30/0x38
> >      load_module+0x14f0/0x1e78
> >      __do_sys_finit_module+0x100/0x11c
> >      __arm64_sys_finit_module+0x28/0x34
> >      el0_svc_common+0x88/0x194
> >      el0_svc_handler+0x38/0x8c
> >      el0_svc+0x8/0xc
> >     ---[ end trace d828d06b36ad9d59 ]---
> >     ftrace failed to modify
> >     [<ffffa2dbf3a3a41c>] 0xffffa2dbf3a3a41c
> >      actual:   66:a9:3c:90
> >     Initializing ftrace call sites
> >     ftrace record flags: 2000000
> >      (0)
> >     expected tramp: ffffa2dc6cf66724
> 
> Which code specifically is this triggering for? Is this something in an
> upstream kernel, or out-of-tree patches?
> 
We faced this issue while porting Ksplice on ARM64 architecture.  So
that's an out-of-tree module. And we got this issue because we have
multiple references to '_mcount' like the one described in the commit
description of this patch.

> Can you say which toolchain you're using, too?
> 
We are using native gcc version: gcc (GCC) 7.3.0 20180125 (Red Hat 7.3.0-5)
And native binutils 2.31.1.

> > So Limit the relocation type to R_AARCH64_CALL26 as in perl version of
> > recordmcount.
> 
> Given our patching code expects each callsite to be:
> 
> 	bl	_mcount
> 
> ... this looks sane to me, and I *think* that's sound for modules too.
> 
Ok great.

> > Fixes: ed60453fa8f8 ("ARM: 6511/1: ftrace: add ARM support for C version of recordmcount")
> 
> That's a 32-bit arm commit. I suspect that was meant to be:
> 
> Fixes: af64d2aa872a1747 ("ftrace: Add arm64 support to recordmcount")
> 
Right.

> > Signed-off-by: Gregory Herrero <gregory.herrero@oracle.com>
> > ---
> >  scripts/recordmcount.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/scripts/recordmcount.c b/scripts/recordmcount.c
> > index 7225107a9aaf..e59022b3f125 100644
> > --- a/scripts/recordmcount.c
> > +++ b/scripts/recordmcount.c
> > @@ -434,6 +434,11 @@ static int arm_is_fake_mcount(Elf32_Rel const *rp)
> >  	return 1;
> >  }
> >  
> > +static int arm64_is_fake_mcount(Elf64_Rel const *rp)
> > +{
> > +	return ELF64_R_TYPE(w(rp->r_info)) != R_AARCH64_CALL26;
> > +}
> > +
> >  /* 64-bit EM_MIPS has weird ELF64_Rela.r_info.
> >   * http://techpubs.sgi.com/library/manuals/4000/007-4658-001/pdf/007-4658-001.pdf
> >   * We interpret Table 29 Relocation Operation (Elf64_Rel, Elf64_Rela) [p.40]
> > @@ -547,6 +552,7 @@ static int do_file(char const *const fname)
> >  		make_nop = make_nop_arm64;
> >  		rel_type_nop = R_AARCH64_NONE;
> >  		ideal_nop = ideal_nop4_arm64;
> > +		is_fake_mcount64 = arm64_is_fake_mcount;
> >  		break;
> 
> As above, I think this is sound, but if you could answer my questions
> that'd be helpful.
> 
Thanks for the review,
Greg
