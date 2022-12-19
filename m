Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4346508DE
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 09:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231128AbiLSIvH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 03:51:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231387AbiLSIub (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 03:50:31 -0500
Received: from frasgout12.his.huawei.com (frasgout12.his.huawei.com [14.137.139.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5ECCCE02;
        Mon, 19 Dec 2022 00:50:11 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.18.147.228])
        by frasgout12.his.huawei.com (SkyGuard) with ESMTP id 4NbCs63L1Mz9ttD8;
        Mon, 19 Dec 2022 16:43:06 +0800 (CST)
Received: from roberto-ThinkStation-P620 (unknown [10.204.63.22])
        by APP1 (Coremail) with SMTP id LxC2BwBHywagJaBjl6AmAA--.3254S2;
        Mon, 19 Dec 2022 09:49:46 +0100 (CET)
Message-ID: <0f80852578436dbba7a0fce03d86c3fa2d38c571.camel@huaweicloud.com>
Subject: Re: [PATCH v2] KEYS: asymmetric: Copy sig and digest in
 public_key_verify_signature()
From:   Roberto Sassu <roberto.sassu@huaweicloud.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Eric Biggers <ebiggers@kernel.org>, dhowells@redhat.com,
        davem@davemloft.net, zohar@linux.ibm.com,
        dmitry.kasatkin@gmail.com, paul@paul-moore.com, jmorris@namei.org,
        serge@hallyn.com, linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roberto Sassu <roberto.sassu@huawei.com>,
        stable@vger.kernel.org
Date:   Mon, 19 Dec 2022 09:49:29 +0100
In-Reply-To: <Y5bxJ5UZNPzxwtoy@gondor.apana.org.au>
References: <20221209150633.1033556-1-roberto.sassu@huaweicloud.com>
         <Y5OGr59A9wo86rYY@sol.localdomain>
         <fa8a307541735ec9258353d8ccb75c20bb22aafe.camel@huaweicloud.com>
         <Y5bxJ5UZNPzxwtoy@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: LxC2BwBHywagJaBjl6AmAA--.3254S2
X-Coremail-Antispam: 1UD129KBjvdXoW7JF43Gr1UCw18Gr47ZFWUJwb_yoWfuwbEgF
        y3CF4kX34Fvr17tF4rtr4qqrs3GrWkAry7Xr4Ig3sxJ3s5Jws7WrsYkrs3Wr1xXr4rJF9F
        gryrZ347X3W29jkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb78YFVCjjxCrM7AC8VAFwI0_Xr0_Wr1l1xkIjI8I6I8E6xAIw20E
        Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
        A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWUJVWUCwA2z4x0Y4vE2Ix0cI8IcVCY1x02
        67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIE14v26r4j6F4UM28EF7xvwVC2z280aVCY1x0267
        AKxVW8JVW8Jr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2
        j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7x
        kEbVWUJVW8JwACjcxG0xvEwIxGrwACI402YVCY1x02628vn2kIc2xKxwCF04k20xvY0x0E
        wIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E74
        80Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0
        I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04
        k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY
        1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU13rcDUUUUU==
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAQALBF1jj4bHxwAAs5
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2022-12-12 at 17:15 +0800, Herbert Xu wrote:
> On Mon, Dec 12, 2022 at 10:07:38AM +0100, Roberto Sassu wrote:
> > The problem is a misalignment between req->src_len (set to sig->s_size
> > by akcipher_request_set_crypt()) and the length of the scatterlist (if
> > we set the latter to sig->s_size + sig->digest_size).
> > 
> > When rsa_enc() calls mpi_read_raw_from_sgl(), it passes req->src_len as
> > argument, and the latter allocates the MPI according to that. However,
> > it does parsing depending on the length of the scatterlist.
> > 
> > If there are two scatterlists, it is not a problem, there is no
> > misalignment. mpi_read_raw_from_sgl() picks the first. If there is just
> > one, mpi_read_raw_from_sgl() parses all data there.
> 
> Thanks for the explanation.  That's definitely a bug which should
> be fixed either in the RSA code or in MPI.
> 
> I'll look into it.

Hi Herbert

do you have any news on this bug?

Thanks

Roberto

