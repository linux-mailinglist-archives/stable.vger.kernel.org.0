Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20567667255
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 13:37:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbjALMhw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 07:37:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbjALMhs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 07:37:48 -0500
Received: from frasgout11.his.huawei.com (frasgout11.his.huawei.com [14.137.139.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E987E3E85F;
        Thu, 12 Jan 2023 04:37:45 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.18.147.228])
        by frasgout11.his.huawei.com (SkyGuard) with ESMTP id 4Nt3ll6nC5z9v7J2;
        Thu, 12 Jan 2023 20:29:55 +0800 (CST)
Received: from roberto-ThinkStation-P620 (unknown [10.204.63.22])
        by APP1 (Coremail) with SMTP id LxC2BwD3fQkE_79jOUaOAA--.54221S2;
        Thu, 12 Jan 2023 13:37:31 +0100 (CET)
Message-ID: <a764acb285d0616c8608eaab8671ceb9c22cb390.camel@huaweicloud.com>
Subject: Re: [PATCH v2] security: Restore passing final prot to
 ima_file_mmap()
From:   Roberto Sassu <roberto.sassu@huaweicloud.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     zohar@linux.ibm.com, jmorris@namei.org, serge@hallyn.com,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        Roberto Sassu <roberto.sassu@huawei.com>,
        stable@vger.kernel.org
Date:   Thu, 12 Jan 2023 13:36:56 +0100
In-Reply-To: <CAHC9VhSamRVpgrDrSuc2dsbbw3-pvjDi9BsFWoWssHkAD2W5vA@mail.gmail.com>
References: <20221221141007.2579770-1-roberto.sassu@huaweicloud.com>
         <CAHC9VhQUAuF-Fan72j7BOqOdLE=B=mJpJ_GpR5p5cUmXruYT=Q@mail.gmail.com>
         <4b8688ee3d533d989196004d5f9f2c7eb4093f8b.camel@huaweicloud.com>
         <CAHC9VhSamRVpgrDrSuc2dsbbw3-pvjDi9BsFWoWssHkAD2W5vA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: LxC2BwD3fQkE_79jOUaOAA--.54221S2
X-Coremail-Antispam: 1UD129KBjvJXoWxJF48Xr4rAr4Dtry5Ar1UJrb_yoW5tryDpa
        y5ta4jkrs5XFySyrn2q3W3Ga4Fk39xKFy7Ww1DKry8uw1DXF12kr13JFWj9FykXrn5G34j
        q3W29rW3C3Wqy3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkFb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv6xkF7I
        0E14v26r4j6r4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
        6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
        Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxAIw28IcxkI
        7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxV
        Cjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY
        6xIIjxv20xvE14v26r4j6ryUMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1lIxAIcV
        CF04k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2
        jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UQzVbUUUUU=
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAgAPBF1jj4OGmAADsm
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2023-01-11 at 09:25 -0500, Paul Moore wrote:
> On Wed, Jan 11, 2023 at 4:31 AM Roberto Sassu
> <roberto.sassu@huaweicloud.com> wrote:
> > On Fri, 2023-01-06 at 16:14 -0500, Paul Moore wrote:
> > > On Wed, Dec 21, 2022 at 9:10 AM Roberto Sassu
> > > <roberto.sassu@huaweicloud.com> wrote:
> > > > From: Roberto Sassu <roberto.sassu@huawei.com>
> > > > 
> > > > Commit 98de59bfe4b2f ("take calculation of final prot in
> > > > security_mmap_file() into a helper") moved the code to update prot with the
> > > > actual protection flags to be granted to the requestor by the kernel to a
> > > > helper called mmap_prot(). However, the patch didn't update the argument
> > > > passed to ima_file_mmap(), making it receive the requested prot instead of
> > > > the final computed prot.
> > > > 
> > > > A possible consequence is that files mmapped as executable might not be
> > > > measured/appraised if PROT_EXEC is not requested but subsequently added in
> > > > the final prot.
> > > > 
> > > > Replace prot with mmap_prot(file, prot) as the second argument of
> > > > ima_file_mmap() to restore the original behavior.
> > > > 
> > > > Cc: stable@vger.kernel.org
> > > > Fixes: 98de59bfe4b2 ("take calculation of final prot in security_mmap_file() into a helper")
> > > > Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> > > > ---
> > > >  security/security.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > 
> > > > diff --git a/security/security.c b/security/security.c
> > > > index d1571900a8c7..0d2359d588a1 100644
> > > > --- a/security/security.c
> > > > +++ b/security/security.c
> > > > @@ -1666,7 +1666,7 @@ int security_mmap_file(struct file *file, unsigned long prot,
> > > >                                         mmap_prot(file, prot), flags);
> > > >         if (ret)
> > > >                 return ret;
> > > > -       return ima_file_mmap(file, prot);
> > > > +       return ima_file_mmap(file, mmap_prot(file, prot));
> > > >  }
> > > 
> > > This seems like a reasonable fix, although as the original commit is
> > > ~10 years old at this point I am a little concerned about the impact
> > > this might have on IMA.  Mimi, what do you think?

As a user, I probably would like to know that my system is not
measuring what it is supposed to measure. The rule:

measure func=MMAP_CHECK mask=MAY_EXEC

is looking for executable code mapped in memory. If it is requested by
the application or the kernel, probably it does not make too much
difference from the perspective of measurement goals.

If we add a new policy keyword, existing policies would not be updated
unless the system administrator notices it. If a remote attestation
fails, the administrator has to look into it.

Maybe we can introduce a new hook called MMAP_CHECK_REQ, so that an
administrator could change the policy to have the current behavior, if
the administrator wishes so.

Roberto

> > > Beyond that, my only other comment would be to only call mmap_prot()
> > > once and cache the results in a local variable.  You could also fix up
> > > some of the ugly indentation crimes in security_mmap_file() while you
> > > are at it, e.g. something like this:
> > 
> > Hi Paul
> > 
> > thanks for the comments. With the patch set to move IMA and EVM to the
> > LSM infrastructure we will be back to calling mmap_prot() only once,
> > but I guess we could do anyway, as the patch (if accepted) would be
> > likely backported to stable kernels.
> 
> I think there is value in fixing this now and keeping it separate from
> the IMA-to-LSM work as they really are disjoint.
> 

