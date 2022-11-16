Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C3F062B4BC
	for <lists+stable@lfdr.de>; Wed, 16 Nov 2022 09:14:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238657AbiKPIOK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Nov 2022 03:14:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233167AbiKPINr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Nov 2022 03:13:47 -0500
Received: from frasgout12.his.huawei.com (frasgout12.his.huawei.com [14.137.139.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E08D1054D;
        Wed, 16 Nov 2022 00:11:54 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.18.147.228])
        by frasgout12.his.huawei.com (SkyGuard) with ESMTP id 4NBwbF2qvFz9v7Yf;
        Wed, 16 Nov 2022 16:05:45 +0800 (CST)
Received: from roberto-ThinkStation-P620 (unknown [10.204.63.22])
        by APP1 (Coremail) with SMTP id LxC2BwBnUm8mm3RjHPlrAA--.18293S2;
        Wed, 16 Nov 2022 09:11:29 +0100 (CET)
Message-ID: <83cbff40f16a46e733a877d499b904cdf06949b6.camel@huaweicloud.com>
Subject: Re: [RFC][PATCH 3/4] lsm: Redefine LSM_HOOK() macro to add return
 value flags as argument
From:   Roberto Sassu <roberto.sassu@huaweicloud.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, revest@chromium.org,
        jackmanb@chromium.org, jmorris@namei.org, serge@hallyn.com,
        bpf@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Roberto Sassu <roberto.sassu@huawei.com>,
        stable@vger.kernel.org
Date:   Wed, 16 Nov 2022 09:11:15 +0100
In-Reply-To: <CAHC9VhTA7SgFnTFGNxOGW38WSkWu7GSizBmNz=TuazUR4R_jUg@mail.gmail.com>
References: <20221115175652.3836811-1-roberto.sassu@huaweicloud.com>
         <20221115175652.3836811-4-roberto.sassu@huaweicloud.com>
         <CAHC9VhTA7SgFnTFGNxOGW38WSkWu7GSizBmNz=TuazUR4R_jUg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: LxC2BwBnUm8mm3RjHPlrAA--.18293S2
X-Coremail-Antispam: 1UD129KBjvJXoW7KFWDWryxKr4fJrWxCr15Jwb_yoW8WryrpF
        43ta4YkFnYvr47C3ZxWF1fC34rJ393Wr15trnrXw1Fva42yrnxK34kua1S9Fy09rWIkr1Y
        krWagry5Kw1DArDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUk0b4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv6xkF7I
        0E14v26r4j6r4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
        6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
        Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxAIw28IcxkI
        7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxV
        Cjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY
        6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1lIxAIcV
        CF04k26cxKx2IYs7xG6Fyj6rWUJwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv
        6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUrWlkDUUUU
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAgASBF1jj4F8dQABss
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2022-11-15 at 21:27 -0500, Paul Moore wrote:
> On Tue, Nov 15, 2022 at 12:58 PM Roberto Sassu
> <roberto.sassu@huaweicloud.com> wrote:
> > From: Roberto Sassu <roberto.sassu@huawei.com>
> > 
> > Define four return value flags (LSM_RET_NEG, LSM_RET_ZERO, LSM_RET_ONE,
> > LSM_RET_GT_ONE), one for each interval of interest (< 0, = 0, = 1, > 1).
> > 
> > Redefine the LSM_HOOK() macro to add return value flags as argument, and
> > set the correct flags for each LSM hook.
> > 
> > Implementors of new LSM hooks should do the same as well.
> > 
> > Cc: stable@vger.kernel.org # 5.7.x
> > Fixes: 9d3fdea789c8 ("bpf: lsm: Provide attachment points for BPF LSM programs")
> > Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> > ---
> >  include/linux/bpf_lsm.h       |   2 +-
> >  include/linux/lsm_hook_defs.h | 779 ++++++++++++++++++++--------------
> >  include/linux/lsm_hooks.h     |   9 +-
> >  kernel/bpf/bpf_lsm.c          |   5 +-
> >  security/bpf/hooks.c          |   2 +-
> >  security/security.c           |   4 +-
> >  6 files changed, 466 insertions(+), 335 deletions(-)
> 
> Just a quick note here that even if we wanted to do something like
> this, it is absolutely not -stable kernel material.  No way.

I was unsure about that. We need a proper fix for this issue that needs
to be backported to some kernels. I saw this more like a dependency.
But I agree with you that it would be unlikely that this patch is
applied to stable kernels.

For stable kernels, what it would be the proper way? We still need to
maintain an allow list of functions that allow a positive return value,
at least. Should it be in the eBPF code only?

Thanks

Roberto

