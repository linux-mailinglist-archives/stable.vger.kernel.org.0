Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7B767DF1C
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 09:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232382AbjA0I2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 03:28:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbjA0I2o (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 03:28:44 -0500
Received: from frasgout13.his.huawei.com (frasgout13.his.huawei.com [14.137.139.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 860552D44;
        Fri, 27 Jan 2023 00:28:42 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.18.147.228])
        by frasgout13.his.huawei.com (SkyGuard) with ESMTP id 4P39WC0sLYz9xyNp;
        Fri, 27 Jan 2023 16:20:39 +0800 (CST)
Received: from roberto-ThinkStation-P620 (unknown [10.204.63.22])
        by APP2 (Coremail) with SMTP id GxC2BwD3xl0Ti9Nj7gjNAA--.18823S2;
        Fri, 27 Jan 2023 09:28:15 +0100 (CET)
Message-ID: <d2a54ddec403cad12c003132542070bf781d5e26.camel@huaweicloud.com>
Subject: Re: [PATCH v5 2/2] KEYS: asymmetric: Copy sig and digest in
 public_key_verify_signature()
From:   Roberto Sassu <roberto.sassu@huaweicloud.com>
To:     dhowells@redhat.com
Cc:     Eric Biggers <ebiggers@kernel.org>, herbert@gondor.apana.org.au,
        davem@davemloft.net, zohar@linux.ibm.com,
        dmitry.kasatkin@gmail.com, paul@paul-moore.com, jmorris@namei.org,
        serge@hallyn.com, linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>
Date:   Fri, 27 Jan 2023 09:27:58 +0100
In-Reply-To: <Y64XB0yi24yjeBDw@sol.localdomain>
References: <20221227142740.2807136-1-roberto.sassu@huaweicloud.com>
         <20221227142740.2807136-3-roberto.sassu@huaweicloud.com>
         <Y64XB0yi24yjeBDw@sol.localdomain>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: GxC2BwD3xl0Ti9Nj7gjNAA--.18823S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Zr15ur18uw4DGFyfGryfJFb_yoW8XFy5pF
        W3G3W5GF1jqryxCFsIv3yFva4rG3ykJr13Xw43X3s5Zr18urs8Wr1IqF4fWFyDAry8KFWF
        yFW5Xr1qgw1YkaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUk0b4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxV
        AFwI0_Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
        x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
        0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IYc2Ij
        64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
        8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE
        2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42
        xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv
        6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUFDGOUUUUU
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAQAKBF1jj4goZAABs7
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2022-12-29 at 14:39 -0800, Eric Biggers wrote:
> On Tue, Dec 27, 2022 at 03:27:40PM +0100, Roberto Sassu wrote:
> > From: Roberto Sassu <roberto.sassu@huawei.com>
> > 
> > Commit ac4e97abce9b8 ("scatterlist: sg_set_buf() argument must be in linear
> > mapping") checks that both the signature and the digest reside in the
> > linear mapping area.
> > 
> > However, more recently commit ba14a194a434c ("fork: Add generic vmalloced
> > stack support") made it possible to move the stack in the vmalloc area,
> > which is not contiguous, and thus not suitable for sg_set_buf() which needs
> > adjacent pages.
> > 
> > Always make a copy of the signature and digest in the same buffer used to
> > store the key and its parameters, and pass them to sg_init_one(). Prefer it
> > to conditionally doing the copy if necessary, to keep the code simple. The
> > buffer allocated with kmalloc() is in the linear mapping area.
> > 
> > Cc: stable@vger.kernel.org # 4.9.x
> > Fixes: ba14a194a434 ("fork: Add generic vmalloced stack support")
> > Link: https://lore.kernel.org/linux-integrity/Y4pIpxbjBdajymBJ@sol.localdomain/
> > Suggested-by: Eric Biggers <ebiggers@kernel.org>
> > Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> > ---
> >  crypto/asymmetric_keys/public_key.c | 38 ++++++++++++++++-------------
> >  1 file changed, 21 insertions(+), 17 deletions(-)
> 
> Reviewed-by: Eric Biggers <ebiggers@google.com>

Hi David

could you please take this patch in your repo, if it is ok?

Thanks

Roberto

