Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FAA2635FF8
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 14:34:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238856AbiKWNec (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 08:34:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238957AbiKWNca (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 08:32:30 -0500
Received: from frasgout12.his.huawei.com (frasgout12.his.huawei.com [14.137.139.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 576E55289C;
        Wed, 23 Nov 2022 05:19:49 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.18.147.229])
        by frasgout12.his.huawei.com (SkyGuard) with ESMTP id 4NHLZX2tt0z9xFYJ;
        Wed, 23 Nov 2022 20:50:28 +0800 (CST)
Received: from roberto-ThinkStation-P620 (unknown [10.204.63.22])
        by APP2 (Coremail) with SMTP id GxC2BwB3q_d7GH5jku+JAA--.33167S2;
        Wed, 23 Nov 2022 13:56:35 +0100 (CET)
Message-ID: <a676b387d23f9ca630418ece20a6761a9437ce76.camel@huaweicloud.com>
Subject: Re: [PATCH] ima: Make a copy of sig and digest in
 asymmetric_verify()
From:   Roberto Sassu <roberto.sassu@huaweicloud.com>
To:     Mimi Zohar <zohar@linux.ibm.com>, dmitry.kasatkin@gmail.com,
        paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Roberto Sassu <roberto.sassu@huawei.com>,
        stable@vger.kernel.org
Date:   Wed, 23 Nov 2022 13:56:22 +0100
In-Reply-To: <9ef25f1b8621dab8b3cd4373bf6ce1633daae70e.camel@linux.ibm.com>
References: <20221104122023.1750333-1-roberto.sassu@huaweicloud.com>
         <9ef25f1b8621dab8b3cd4373bf6ce1633daae70e.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: GxC2BwB3q_d7GH5jku+JAA--.33167S2
X-Coremail-Antispam: 1UD129KBjvJXoW7KFyfKw48Gw4kGr4xXFW3trb_yoW8uw48pF
        48K3Wqkrs8Jr1IkFW7Aw45G398Gw4rKrW7W397Cw1rZF98Ww4kZ397t3WxXr98WryxZFWf
        t3WagrnrZr15GaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkFb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxV
        AFwI0_Gr1j6F4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
        6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
        Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxAIw28IcxkI
        7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxV
        Cjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY
        6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6x
        AIw20EY4v20xvaj40_Wr1j6rW3Jr1lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280
        aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x07UQzVbUUUUU=
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAQAFBF1jj4XJJwAAsa
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2022-11-22 at 14:39 -0500, Mimi Zohar wrote:
> Hi Roberto,
> 
> On Fri, 2022-11-04 at 13:20 +0100, Roberto Sassu wrote:
> > From: Roberto Sassu <roberto.sassu@huawei.com>
> > 
> > Commit ac4e97abce9b8 ("scatterlist: sg_set_buf() argument must be in linear
> > mapping") requires that both the signature and the digest resides in the
> > linear mapping area.
> > 
> > However, more recently commit ba14a194a434c ("fork: Add generic vmalloced
> > stack support"), made it possible to move the stack in the vmalloc area,
> > which could make the requirement of the first commit not satisfied anymore.
> > 
> > If CONFIG_SG=y and CONFIG_VMAP_STACK=y, the following BUG() is triggered:
> 
> ^CONFIG_DEBUG_SG
> 
> > [  467.077359] kernel BUG at include/linux/scatterlist.h:163!
> > [  467.077939] invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
> > 
> > [...]
> > 
> > [  467.095225] Call Trace:
> > [  467.096088]  <TASK>
> > [  467.096928]  ? rcu_read_lock_held_common+0xe/0x50
> > [  467.097569]  ? rcu_read_lock_sched_held+0x13/0x70
> > [  467.098123]  ? trace_hardirqs_on+0x2c/0xd0
> > [  467.098647]  ? public_key_verify_signature+0x470/0x470
> > [  467.099237]  asymmetric_verify+0x14c/0x300
> > [  467.099869]  evm_verify_hmac+0x245/0x360
> > [  467.100391]  evm_inode_setattr+0x43/0x190
> > 
> > The failure happens only for the digest, as the pointer comes from the
> > stack, and not for the signature, which instead was allocated by
> > vfs_getxattr_alloc().
> 
> Only after enabling CONFIG_DEBUG_SG does EVM fail.
> 
> > Fix this by making a copy of both in asymmetric_verify(), so that the
> > linear mapping requirement is always satisfied, regardless of the caller.
> 
> As only EVM is affected, it would make more sense to limit the change
> to EVM.

I found another occurrence:

static int xattr_verify(enum ima_hooks func, struct integrity_iint_cache *iint,
			struct evm_ima_xattr_data *xattr_value, int xattr_len,
			enum integrity_status *status, const char **cause)
{

[...]

		rc = integrity_digsig_verify(INTEGRITY_KEYRING_IMA,
					     (const char *)xattr_value,
					     xattr_len, hash.digest,
					     hash.hdr.length);

Should I do two patches?

Thanks

Roberto

