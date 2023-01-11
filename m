Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CDE466578A
	for <lists+stable@lfdr.de>; Wed, 11 Jan 2023 10:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234158AbjAKJeO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 04:34:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238635AbjAKJdl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 04:33:41 -0500
Received: from frasgout11.his.huawei.com (frasgout11.his.huawei.com [14.137.139.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BACCA2180;
        Wed, 11 Jan 2023 01:31:48 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.18.147.227])
        by frasgout11.his.huawei.com (SkyGuard) with ESMTP id 4NsMgh2pz9z9v7Nd;
        Wed, 11 Jan 2023 17:24:00 +0800 (CST)
Received: from roberto-ThinkStation-P620 (unknown [10.204.63.22])
        by APP1 (Coremail) with SMTP id LxC2BwB3AAzugb5jAlOJAA--.2952S2;
        Wed, 11 Jan 2023 10:31:34 +0100 (CET)
Message-ID: <4b8688ee3d533d989196004d5f9f2c7eb4093f8b.camel@huaweicloud.com>
Subject: Re: [PATCH v2] security: Restore passing final prot to
 ima_file_mmap()
From:   Roberto Sassu <roberto.sassu@huaweicloud.com>
To:     Paul Moore <paul@paul-moore.com>, zohar@linux.ibm.com
Cc:     jmorris@namei.org, serge@hallyn.com,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        Roberto Sassu <roberto.sassu@huawei.com>,
        stable@vger.kernel.org
Date:   Wed, 11 Jan 2023 10:30:59 +0100
In-Reply-To: <CAHC9VhQUAuF-Fan72j7BOqOdLE=B=mJpJ_GpR5p5cUmXruYT=Q@mail.gmail.com>
References: <20221221141007.2579770-1-roberto.sassu@huaweicloud.com>
         <CAHC9VhQUAuF-Fan72j7BOqOdLE=B=mJpJ_GpR5p5cUmXruYT=Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: LxC2BwB3AAzugb5jAlOJAA--.2952S2
X-Coremail-Antispam: 1UD129KBjvJXoWxAF18JrWUZFWxWw43uryUZFb_yoW5AFy8pF
        s8t3WUKrs5JFySyrn7XF17CFySk3y3KFyDWa1vgryqy3Z8WF1xKr1akFW29F18ZrWkuFy0
        qa17urZxC3WqyrJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUyEb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxV
        AFwI0_Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
        x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
        0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IYc2Ij
        64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
        8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE
        2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
        xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
        c7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU1zuWJUUUUU==
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAQAOBF1jj4dyAQAAsO
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2023-01-06 at 16:14 -0500, Paul Moore wrote:
> On Wed, Dec 21, 2022 at 9:10 AM Roberto Sassu
> <roberto.sassu@huaweicloud.com> wrote:
> > From: Roberto Sassu <roberto.sassu@huawei.com>
> > 
> > Commit 98de59bfe4b2f ("take calculation of final prot in
> > security_mmap_file() into a helper") moved the code to update prot with the
> > actual protection flags to be granted to the requestor by the kernel to a
> > helper called mmap_prot(). However, the patch didn't update the argument
> > passed to ima_file_mmap(), making it receive the requested prot instead of
> > the final computed prot.
> > 
> > A possible consequence is that files mmapped as executable might not be
> > measured/appraised if PROT_EXEC is not requested but subsequently added in
> > the final prot.
> > 
> > Replace prot with mmap_prot(file, prot) as the second argument of
> > ima_file_mmap() to restore the original behavior.
> > 
> > Cc: stable@vger.kernel.org
> > Fixes: 98de59bfe4b2 ("take calculation of final prot in security_mmap_file() into a helper")
> > Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> > ---
> >  security/security.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/security/security.c b/security/security.c
> > index d1571900a8c7..0d2359d588a1 100644
> > --- a/security/security.c
> > +++ b/security/security.c
> > @@ -1666,7 +1666,7 @@ int security_mmap_file(struct file *file, unsigned long prot,
> >                                         mmap_prot(file, prot), flags);
> >         if (ret)
> >                 return ret;
> > -       return ima_file_mmap(file, prot);
> > +       return ima_file_mmap(file, mmap_prot(file, prot));
> >  }
> 
> This seems like a reasonable fix, although as the original commit is
> ~10 years old at this point I am a little concerned about the impact
> this might have on IMA.  Mimi, what do you think?
> 
> Beyond that, my only other comment would be to only call mmap_prot()
> once and cache the results in a local variable.  You could also fix up
> some of the ugly indentation crimes in security_mmap_file() while you
> are at it, e.g. something like this:

Hi Paul

thanks for the comments. With the patch set to move IMA and EVM to the
LSM infrastructure we will be back to calling mmap_prot() only once,
but I guess we could do anyway, as the patch (if accepted) would be
likely backported to stable kernels.

Thanks

Roberto

> diff --git a/security/security.c b/security/security.c
> index d1571900a8c7..2f9cad9ecac8 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -1662,11 +1662,12 @@ int security_mmap_file(struct file *file, unsigned long
> prot,
>                        unsigned long flags)
> {
>        int ret;
> -       ret = call_int_hook(mmap_file, 0, file, prot,
> -                                       mmap_prot(file, prot), flags);
> +       unsigned long prot_adj = mmap_prot(file, prot);
> +
> +       ret = call_int_hook(mmap_file, 0, file, prot, prot_adj, flags);
>        if (ret)
>                return ret;
> -       return ima_file_mmap(file, prot);
> +       return ima_file_mmap(file, prot_adj);
> }
> 
> --
> paul-moore.com

