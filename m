Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F31E6323FE
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 14:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231364AbiKUNkW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 08:40:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231414AbiKUNkD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 08:40:03 -0500
Received: from frasgout13.his.huawei.com (frasgout13.his.huawei.com [14.137.139.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F0118DA7E;
        Mon, 21 Nov 2022 05:39:57 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.18.147.228])
        by frasgout13.his.huawei.com (SkyGuard) with ESMTP id 4NG7cc6Wpxz9xrqG;
        Mon, 21 Nov 2022 21:33:04 +0800 (CST)
Received: from roberto-ThinkStation-P620 (unknown [10.204.63.22])
        by APP1 (Coremail) with SMTP id LxC2BwDn03CXf3tjASyCAA--.23585S2;
        Mon, 21 Nov 2022 14:39:43 +0100 (CET)
Message-ID: <6a3a6f0fba8cf09ce205efb3217cc0cfb8587074.camel@huaweicloud.com>
Subject: Re: [PATCH] ima: Make a copy of sig and digest in
 asymmetric_verify()
From:   Roberto Sassu <roberto.sassu@huaweicloud.com>
To:     zohar@linux.ibm.com, dmitry.kasatkin@gmail.com,
        paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Roberto Sassu <roberto.sassu@huawei.com>,
        stable@vger.kernel.org
Date:   Mon, 21 Nov 2022 14:39:25 +0100
In-Reply-To: <20221104122023.1750333-1-roberto.sassu@huaweicloud.com>
References: <20221104122023.1750333-1-roberto.sassu@huaweicloud.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: LxC2BwDn03CXf3tjASyCAA--.23585S2
X-Coremail-Antispam: 1UD129KBjvJXoWxWFy3Zr1fXr4DWw43Zr15twb_yoW5XF4xpa
        ykKa4DKF1UGw1xCa13Cw47WrZ5Wa1rKr47Wa93AryfZ3Z8Xr4vk3s7A3W7Xr98XryxXFWf
        trnFv3ZrCw1Dt3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUk0b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxV
        AFwI0_Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
        x7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
        0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IYc2Ij
        64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
        8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE
        2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42
        xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv
        6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUOyCJDUUUU
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAQADBF1jj4Wq9wABsu
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2022-11-04 at 13:20 +0100, Roberto Sassu wrote:
> From: Roberto Sassu <roberto.sassu@huawei.com>
> 
> Commit ac4e97abce9b8 ("scatterlist: sg_set_buf() argument must be in linear
> mapping") requires that both the signature and the digest resides in the
> linear mapping area.
> 
> However, more recently commit ba14a194a434c ("fork: Add generic vmalloced
> stack support"), made it possible to move the stack in the vmalloc area,
> which could make the requirement of the first commit not satisfied anymore.
> 
> If CONFIG_SG=y and CONFIG_VMAP_STACK=y, the following BUG() is triggered:

Hi Mimi

did you have the chance to have a look at this patch?

Thanks

Roberto

> [  467.077359] kernel BUG at include/linux/scatterlist.h:163!
> [  467.077939] invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
> 
> [...]
> 
> [  467.095225] Call Trace:
> [  467.096088]  <TASK>
> [  467.096928]  ? rcu_read_lock_held_common+0xe/0x50
> [  467.097569]  ? rcu_read_lock_sched_held+0x13/0x70
> [  467.098123]  ? trace_hardirqs_on+0x2c/0xd0
> [  467.098647]  ? public_key_verify_signature+0x470/0x470
> [  467.099237]  asymmetric_verify+0x14c/0x300
> [  467.099869]  evm_verify_hmac+0x245/0x360
> [  467.100391]  evm_inode_setattr+0x43/0x190
> 
> The failure happens only for the digest, as the pointer comes from the
> stack, and not for the signature, which instead was allocated by
> vfs_getxattr_alloc().
> 
> Fix this by making a copy of both in asymmetric_verify(), so that the
> linear mapping requirement is always satisfied, regardless of the caller.
> 
> Cc: stable@vger.kernel.org # 4.9.x
> Fixes: ba14a194a434 ("fork: Add generic vmalloced stack support")
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> ---
>  security/integrity/digsig_asymmetric.c | 19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/security/integrity/digsig_asymmetric.c b/security/integrity/digsig_asymmetric.c
> index 895f4b9ce8c6..635238d5c7fe 100644
> --- a/security/integrity/digsig_asymmetric.c
> +++ b/security/integrity/digsig_asymmetric.c
> @@ -122,11 +122,26 @@ int asymmetric_verify(struct key *keyring, const char *sig,
>  		goto out;
>  	}
>  
> -	pks.digest = (u8 *)data;
> +	pks.digest = kmemdup(data, datalen, GFP_KERNEL);
> +	if (!pks.digest) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
>  	pks.digest_size = datalen;
> -	pks.s = hdr->sig;
> +
> +	pks.s = kmemdup(hdr->sig, siglen, GFP_KERNEL);
> +	if (!pks.s) {
> +		kfree(pks.digest);
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
>  	pks.s_size = siglen;
> +
>  	ret = verify_signature(key, &pks);
> +	kfree(pks.digest);
> +	kfree(pks.s);
>  out:
>  	key_put(key);
>  	pr_debug("%s() = %d\n", __func__, ret);

