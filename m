Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B19AF63DA85
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 17:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbiK3QZ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 11:25:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbiK3QZ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 11:25:27 -0500
Received: from frasgout13.his.huawei.com (frasgout13.his.huawei.com [14.137.139.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 590CE4EC28;
        Wed, 30 Nov 2022 08:25:22 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.18.147.228])
        by frasgout13.his.huawei.com (SkyGuard) with ESMTP id 4NMks86yx3z9v7RF;
        Thu,  1 Dec 2022 00:18:20 +0800 (CST)
Received: from roberto-ThinkStation-P620 (unknown [10.204.63.22])
        by APP1 (Coremail) with SMTP id LxC2BwAHpXHVg4djmfirAA--.3567S2;
        Wed, 30 Nov 2022 17:25:02 +0100 (CET)
Message-ID: <e678d661515a191cb1bbfc41d9378e7cb538ef53.camel@huaweicloud.com>
Subject: Re: [PATCH] ima: Make a copy of sig and digest in
 asymmetric_verify()
From:   Roberto Sassu <roberto.sassu@huaweicloud.com>
To:     Mimi Zohar <zohar@linux.ibm.com>, dmitry.kasatkin@gmail.com,
        paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
        rusty@rustcorp.com.au, axboe@kernel.dk
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Roberto Sassu <roberto.sassu@huawei.com>,
        stable@vger.kernel.org
Date:   Wed, 30 Nov 2022 17:24:51 +0100
In-Reply-To: <1658d421c391d0609680b89ca0573fab1ca5e091.camel@linux.ibm.com>
References: <20221104122023.1750333-1-roberto.sassu@huaweicloud.com>
         <9ef25f1b8621dab8b3cd4373bf6ce1633daae70e.camel@linux.ibm.com>
         <a676b387d23f9ca630418ece20a6761a9437ce76.camel@huaweicloud.com>
         <c6c448c2acc07caf840046067322f3e1110cedff.camel@linux.ibm.com>
         <f8f95d37211bac6ce4322a715740d2b2ae20db84.camel@huaweicloud.com>
         <859f70a2801cffa3cb42ae0d43f5753bb01a7eac.camel@huaweicloud.com>
         <1658d421c391d0609680b89ca0573fab1ca5e091.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: LxC2BwAHpXHVg4djmfirAA--.3567S2
X-Coremail-Antispam: 1UD129KBjvJXoWxuF45GrW5Kw15KFW8KFyxAFb_yoWrCF1fpF
        48K3WUKr4DJr1IkF4Iywn8C345Kr4rKrWUX34kJw18Zryqqr1xAr48JF1UWFyDWr1xAF1U
        tFWftFy7Zrn8A3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkjb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxV
        AFwI0_Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
        x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
        0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IYc2Ij
        64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
        8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE
        2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42
        xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
        c7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UWE__UUUUU=
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAgAMBF1jj4IemAABs+
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        T_SPF_TEMPERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2022-11-30 at 11:22 -0500, Mimi Zohar wrote:
> On Wed, 2022-11-30 at 15:41 +0100, Roberto Sassu wrote:
> > On Wed, 2022-11-23 at 14:49 +0100, Roberto Sassu wrote:
> > > On Wed, 2022-11-23 at 08:40 -0500, Mimi Zohar wrote:
> > > > On Wed, 2022-11-23 at 13:56 +0100, Roberto Sassu wrote:
> > > > > On Tue, 2022-11-22 at 14:39 -0500, Mimi Zohar wrote:
> > > > > > Hi Roberto,
> > > > > > 
> > > > > > On Fri, 2022-11-04 at 13:20 +0100, Roberto Sassu wrote:
> > > > > > > From: Roberto Sassu <roberto.sassu@huawei.com>
> > > > > > > 
> > > > > > > Commit ac4e97abce9b8 ("scatterlist: sg_set_buf() argument must be in linear
> > > > > > > mapping") requires that both the signature and the digest resides in the
> > > > > > > linear mapping area.
> > > > > > > 
> > > > > > > However, more recently commit ba14a194a434c ("fork: Add generic vmalloced
> > > > > > > stack support"), made it possible to move the stack in the vmalloc area,
> > > > > > > which could make the requirement of the first commit not satisfied anymore.
> > > > > > > 
> > > > > > > If CONFIG_SG=y and CONFIG_VMAP_STACK=y, the following BUG() is triggered:
> > > > > > 
> > > > > > ^CONFIG_DEBUG_SG
> > > > > > 
> > > > > > > [  467.077359] kernel BUG at include/linux/scatterlist.h:163!
> > > > > > > [  467.077939] invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
> > > > > > > 
> > > > > > > [...]
> > > > > > > 
> > > > > > > [  467.095225] Call Trace:
> > > > > > > [  467.096088]  <TASK>
> > > > > > > [  467.096928]  ? rcu_read_lock_held_common+0xe/0x50
> > > > > > > [  467.097569]  ? rcu_read_lock_sched_held+0x13/0x70
> > > > > > > [  467.098123]  ? trace_hardirqs_on+0x2c/0xd0
> > > > > > > [  467.098647]  ? public_key_verify_signature+0x470/0x470
> > > > > > > [  467.099237]  asymmetric_verify+0x14c/0x300
> > > > > > > [  467.099869]  evm_verify_hmac+0x245/0x360
> > > > > > > [  467.100391]  evm_inode_setattr+0x43/0x190
> > > > > > > 
> > > > > > > The failure happens only for the digest, as the pointer comes from the
> > > > > > > stack, and not for the signature, which instead was allocated by
> > > > > > > vfs_getxattr_alloc().
> > > > > > 
> > > > > > Only after enabling CONFIG_DEBUG_SG does EVM fail.
> > > > > > 
> > > > > > > Fix this by making a copy of both in asymmetric_verify(), so that the
> > > > > > > linear mapping requirement is always satisfied, regardless of the caller.
> > > > > > 
> > > > > > As only EVM is affected, it would make more sense to limit the change
> > > > > > to EVM.
> > > > > 
> > > > > I found another occurrence:
> > > > > 
> > > > > static int xattr_verify(enum ima_hooks func, struct integrity_iint_cache *iint,
> > > > > 			struct evm_ima_xattr_data *xattr_value, int xattr_len,
> > > > > 			enum integrity_status *status, const char **cause)
> > > > > {
> > > > > 
> > > > > [...]
> > > > > 
> > > > > 		rc = integrity_digsig_verify(INTEGRITY_KEYRING_IMA,
> > > > > 					     (const char *)xattr_value,
> > > > > 					     xattr_len, hash.digest,
> > > > > 					     hash.hdr.length);
> > > > > 
> > > > > Should I do two patches?
> > > > 
> > > > I'm just not getting it.  Why did you enable CONFIG_DEBUG_SIG?  Were
> > > > you testing random kernel configs?  Are you actually seeing signature
> > > > verifications errors without it enabled?  Or is it causing other
> > > > problems?  Is the "BUG_ON" still needed?
> > > 
> > > When I test patches, I tend to enable more debugging options.
> > > 
> > > To be honest, I didn't check if there is any issue without enabling
> > > CONFIG_DEBUG_SG. I thought that if there is a linear mapping
> > > requirement, that should be satisfied regardless of whether the
> > > debugging option is enabled or not.
> > > 
> > > + Rusty, Jens for explanations.
> > 
> > Trying to answer the question, with the help of an old discussion:
> > 
> > https://groups.google.com/g/linux.kernel/c/dpIoiY_qSGc
> > 
> > sg_set_buf() calls virt_to_page() to get the page to start from. But if
> > the buffer spans in two pages, that would not work in the vmalloc area,
> > since there is no guarantee that the next page is adjiacent.
> > 
> > For small areas, much smaller than the page size, it is unlikely that
> > the situation above would happen. So, integrity_digsig_verify() will
> > likely succeeed. Although it is possible that it fails if there are
> > data in the next page.
> 
> Thanks, Roberto.  Confirmed that as the patch description indicates,
> without CONFIG_VMAP_STACK configured and with CONFIG_DEBUG_SG enabled
> there isn't a bug.  Does it make sense to limit this change to just
> CONFIG_VMAP_STACK?

Yes, I agree.

Roberto

