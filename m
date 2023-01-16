Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFB9E66B9A2
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 10:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232535AbjAPJAK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 04:00:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232504AbjAPI7k (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 03:59:40 -0500
Received: from frasgout13.his.huawei.com (frasgout13.his.huawei.com [14.137.139.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9342516317;
        Mon, 16 Jan 2023 00:58:32 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.18.147.228])
        by frasgout13.his.huawei.com (SkyGuard) with ESMTP id 4NwQhx3qpCz9xFH6;
        Mon, 16 Jan 2023 16:50:41 +0800 (CST)
Received: from roberto-ThinkStation-P620 (unknown [10.204.63.22])
        by APP2 (Coremail) with SMTP id GxC2BwAH112cEcVjDaOdAA--.61875S2;
        Mon, 16 Jan 2023 09:58:13 +0100 (CET)
Message-ID: <755e1dc9c777fa657ccd948f65f5f33240226c43.camel@huaweicloud.com>
Subject: Re: [PATCH v5 1/2] lib/mpi: Fix buffer overrun when SG is too long
From:   Roberto Sassu <roberto.sassu@huaweicloud.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     dhowells@redhat.com, davem@davemloft.net, zohar@linux.ibm.com,
        dmitry.kasatkin@gmail.com, paul@paul-moore.com, jmorris@namei.org,
        serge@hallyn.com, ebiggers@kernel.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Date:   Mon, 16 Jan 2023 09:57:57 +0100
In-Reply-To: <Y7g7sp6UJJrYKihK@gondor.apana.org.au>
References: <20221227142740.2807136-1-roberto.sassu@huaweicloud.com>
         <20221227142740.2807136-2-roberto.sassu@huaweicloud.com>
         <Y7g7sp6UJJrYKihK@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: GxC2BwAH112cEcVjDaOdAA--.61875S2
X-Coremail-Antispam: 1UD129KBjvdXoWrZry8ZFWDtr15KF1kAw1DZFb_yoW3Zwc_uF
        yqyr1fu39YqF42ya4vkFyvv3429343Wwn8CF4kJr17Za1rXFn3Zr48Ka4Fqwn7Ww4rtF9F
        gF95Zay3Jw1I9jkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb78YFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20E
        Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
        A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWUJVWUCwA2z4x0Y4vE2Ix0cI8IcVCY1x02
        67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIE14v26r4j6F4UM28EF7xvwVC2z280aVCY1x0267
        AKxVW8JVW8Jr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2
        j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7x
        kEbVWUJVW8JwACjcxG0xvEwIxGrwACI402YVCY1x02628vn2kIc2xKxwCF04k20xvY0x0E
        wIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E74
        80Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0
        I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04
        k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY
        1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1zuWJUUUUU==
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAgATBF1jj4OhjAAAsK
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2023-01-06 at 23:18 +0800, Herbert Xu wrote:
> On Tue, Dec 27, 2022 at 03:27:39PM +0100, Roberto Sassu wrote:
> > From: Herbert Xu <herbert@gondor.apana.org.au>
> > 
> > The helper mpi_read_raw_from_sgl sets the number of entries in
> > the SG list according to nbytes.  However, if the last entry
> > in the SG list contains more data than nbytes, then it may overrun
> > the buffer because it only allocates enough memory for nbytes.
> > 
> > Fixes: 2d4d1eea540b ("lib/mpi: Add mpi sgl helpers")
> > Reported-by: Roberto Sassu <roberto.sassu@huaweicloud.com>
> > Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> > ---
> >  lib/mpi/mpicoder.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Patch applied.  Thanks.

Hi Herbert

will you take also the second patch?

Thanks

Roberto

