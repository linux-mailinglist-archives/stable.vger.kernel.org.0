Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5C56694EC
	for <lists+stable@lfdr.de>; Fri, 13 Jan 2023 11:57:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241351AbjAMK52 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Jan 2023 05:57:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241303AbjAMK4x (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Jan 2023 05:56:53 -0500
Received: from frasgout11.his.huawei.com (frasgout11.his.huawei.com [14.137.139.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C77F67A218;
        Fri, 13 Jan 2023 02:53:15 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.18.147.229])
        by frasgout11.his.huawei.com (SkyGuard) with ESMTP id 4NtdNj4W7Fz9xFPt;
        Fri, 13 Jan 2023 18:45:25 +0800 (CST)
Received: from roberto-ThinkStation-P620 (unknown [10.204.63.22])
        by APP2 (Coremail) with SMTP id GxC2BwDnvGMGOMFj4RKRAA--.11240S2;
        Fri, 13 Jan 2023 11:53:02 +0100 (CET)
Message-ID: <e1a1fe029aea21ba533cb6196e64f29c7b052c57.camel@huaweicloud.com>
Subject: Re: [PATCH v2] security: Restore passing final prot to
 ima_file_mmap()
From:   Roberto Sassu <roberto.sassu@huaweicloud.com>
To:     Mimi Zohar <zohar@linux.ibm.com>, Paul Moore <paul@paul-moore.com>
Cc:     jmorris@namei.org, serge@hallyn.com,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        Roberto Sassu <roberto.sassu@huawei.com>,
        stable@vger.kernel.org
Date:   Fri, 13 Jan 2023 11:52:51 +0100
In-Reply-To: <058f1bdf4ba75c3a00918cefbf1be32477b51639.camel@linux.ibm.com>
References: <20221221141007.2579770-1-roberto.sassu@huaweicloud.com>
         <CAHC9VhQUAuF-Fan72j7BOqOdLE=B=mJpJ_GpR5p5cUmXruYT=Q@mail.gmail.com>
         <4b8688ee3d533d989196004d5f9f2c7eb4093f8b.camel@huaweicloud.com>
         <CAHC9VhSamRVpgrDrSuc2dsbbw3-pvjDi9BsFWoWssHkAD2W5vA@mail.gmail.com>
         <a764acb285d0616c8608eaab8671ceb9c22cb390.camel@huaweicloud.com>
         <058f1bdf4ba75c3a00918cefbf1be32477b51639.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: GxC2BwDnvGMGOMFj4RKRAA--.11240S2
X-Coremail-Antispam: 1UD129KBjvJXoW3Gw1xArWrWF1UJrW8tr4UCFg_yoW7Cr4rpF
        W5ta4jkr4kJFyFyrn2v3W3uFyFk39rKa4UWF1qgry8Ar1qgF1akr13AFWj9Fy8XrykW3WU
        Zw17KrW3X3WqyaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUk0b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxV
        AFwI0_Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
        x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
        0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IYc2Ij
        64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
        8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE
        2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
        xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv
        6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUrR6zUUUUU
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAQAQBF1jj4eO+AAAsV
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2023-01-12 at 12:45 -0500, Mimi Zohar wrote:
> On Thu, 2023-01-12 at 13:36 +0100, Roberto Sassu wrote:
> > On Wed, 2023-01-11 at 09:25 -0500, Paul Moore wrote:
> > > On Wed, Jan 11, 2023 at 4:31 AM Roberto Sassu
> > > <roberto.sassu@huaweicloud.com> wrote:
> > > > On Fri, 2023-01-06 at 16:14 -0500, Paul Moore wrote:
> > > > > On Wed, Dec 21, 2022 at 9:10 AM Roberto Sassu
> > > > > <roberto.sassu@huaweicloud.com> wrote:
> > > > > > From: Roberto Sassu <roberto.sassu@huawei.com>
> > > > > > 
> > > > > > Commit 98de59bfe4b2f ("take calculation of final prot in
> > > > > > security_mmap_file() into a helper") moved the code to update prot with the
> > > > > > actual protection flags to be granted to the requestor by the kernel to a
> > > > > > helper called mmap_prot(). However, the patch didn't update the argument
> > > > > > passed to ima_file_mmap(), making it receive the requested prot instead of
> > > > > > the final computed prot.
> > > > > > 
> > > > > > A possible consequence is that files mmapped as executable might not be
> > > > > > measured/appraised if PROT_EXEC is not requested but subsequently added in
> > > > > > the final prot.
> > > > > > 
> > > > > > Replace prot with mmap_prot(file, prot) as the second argument of
> > > > > > ima_file_mmap() to restore the original behavior.
> > > > > > 
> > > > > > Cc: stable@vger.kernel.org
> > > > > > Fixes: 98de59bfe4b2 ("take calculation of final prot in security_mmap_file() into a helper")
> > > > > > Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> > > > > > ---
> > > > > >  security/security.c | 2 +-
> > > > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > > > 
> > > > > > diff --git a/security/security.c b/security/security.c
> > > > > > index d1571900a8c7..0d2359d588a1 100644
> > > > > > --- a/security/security.c
> > > > > > +++ b/security/security.c
> > > > > > @@ -1666,7 +1666,7 @@ int security_mmap_file(struct file *file, unsigned long prot,
> > > > > >                                         mmap_prot(file, prot), flags);
> > > > > >         if (ret)
> > > > > >                 return ret;
> > > > > > -       return ima_file_mmap(file, prot);
> > > > > > +       return ima_file_mmap(file, mmap_prot(file, prot));
> > > > > >  }
> > > > > 
> > > > > This seems like a reasonable fix, although as the original commit is
> > > > > ~10 years old at this point I am a little concerned about the impact
> > > > > this might have on IMA.  Mimi, what do you think?
> > 
> > As a user, I probably would like to know that my system is not
> > measuring what it is supposed to measure. The rule:
> 
> Agreed, that it is measuring what it is supposed to measure.
> 
> > measure func=MMAP_CHECK mask=MAY_EXEC
> > 
> > is looking for executable code mapped in memory. If it is requested by
> > the application or the kernel, probably it does not make too much
> > difference from the perspective of measurement goals.
> 
> Currently, it's limited to measuring file's being mmapped.  From what I
> can tell from looking at the code, additional measurements would be
> included when "current->personality & READ_IMPLIES_EXEC".

Yes, I developed a small program to see the differences:

void main()
{
        struct stat st;
        personality(READ_IMPLIES_EXEC);
        stat("test-file", &st);
        int fd = open("test-file", O_RDONLY);
        mmap(0, st.st_size, PROT_READ, MAP_PRIVATE, fd, 0);
}

Without the patch, the test-file measurement does not appear.

> > If we add a new policy keyword, existing policies would not be updated
> > unless the system administrator notices it. If a remote attestation
> > fails, the administrator has to look into it.
> 
> Verifying the measurement list against a TPM quote should work
> regardless of additional measurements.  The attestation server,
> however, should also check for unknown files.
> 
> > Maybe we can introduce a new hook called MMAP_CHECK_REQ, so that an
> > administrator could change the policy to have the current behavior, if
> > the administrator wishes so.
> 
> Agreed, for backwards compatibility this would be good.  Would you
> support it afterward transitioning IMA to an LSM?

Yes, I have a patch to align ima_file_mmap() with the mmap_file() hook
definition:

-int ima_file_mmap(struct file *file, unsigned long prot)
+int ima_file_mmap(struct file *file, unsigned long reqprot,
+		  unsigned long prot, unsigned long flags)

This would have also fixed the issue. But for backporting, I did a
standalone patch.

I noticed that Kees found this as well:

-int ima_file_mmap(struct file *file, unsigned long prot)
+static int ima_file_mmap(struct file *file, unsigned long reqprot,
+			 unsigned long prot, unsigned long flags)
 {
 	u32 secid;
 
-	if (file && (prot & PROT_EXEC)) {
+	if (file && (reqprot & PROT_EXEC)) {

but from the history I saw that the original intent was to consider
prot, not reqprot.

> However "_REQ" could mean either requested or required.

It was to recall reqprot. I could rename to MMAP_CHECK_REQPROT.

Thanks

Roberto

> > > > > Beyond that, my only other comment would be to only call mmap_prot()
> > > > > once and cache the results in a local variable.  You could also fix up
> > > > > some of the ugly indentation crimes in security_mmap_file() while you
> > > > > are at it, e.g. something like this:
> > > > 
> > > > Hi Paul
> > > > 
> > > > thanks for the comments. With the patch set to move IMA and EVM to the
> > > > LSM infrastructure we will be back to calling mmap_prot() only once,
> > > > but I guess we could do anyway, as the patch (if accepted) would be
> > > > likely backported to stable kernels.
> > > 
> > > I think there is value in fixing this now and keeping it separate from
> > > the IMA-to-LSM work as they really are disjoint.
> > > 

