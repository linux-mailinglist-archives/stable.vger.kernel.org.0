Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE1B6177F6
	for <lists+stable@lfdr.de>; Thu,  3 Nov 2022 08:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbiKCHt7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Nov 2022 03:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbiKCHty (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Nov 2022 03:49:54 -0400
Received: from frasgout13.his.huawei.com (frasgout13.his.huawei.com [14.137.139.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2ED96153;
        Thu,  3 Nov 2022 00:49:50 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.18.147.227])
        by frasgout13.his.huawei.com (SkyGuard) with ESMTP id 4N2wjJ5N4sz9v7Yb;
        Thu,  3 Nov 2022 15:43:16 +0800 (CST)
Received: from roberto-ThinkStation-P620 (unknown [10.204.63.22])
        by APP2 (Coremail) with SMTP id GxC2BwAnXPiHcmNjgWE0AA--.46417S2;
        Thu, 03 Nov 2022 08:49:35 +0100 (CET)
Message-ID: <de51358cb9019a1834cb6ad0f0b7785a8b21d72c.camel@huaweicloud.com>
Subject: Re: [PATCH] ima: Fix memory leak in __ima_inode_hash()
From:   Roberto Sassu <roberto.sassu@huaweicloud.com>
To:     Mimi Zohar <zohar@linux.ibm.com>, dmitry.kasatkin@gmail.com,
        paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaac.jmatt@gmail.com,
        Roberto Sassu <roberto.sassu@huawei.com>,
        stable@vger.kernel.org
Date:   Thu, 03 Nov 2022 08:49:23 +0100
In-Reply-To: <ef7375db277ac6a9398ee31a27e95eed717c4832.camel@linux.ibm.com>
References: <20221102163006.1039343-1-roberto.sassu@huaweicloud.com>
         <ef7375db277ac6a9398ee31a27e95eed717c4832.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: GxC2BwAnXPiHcmNjgWE0AA--.46417S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Gr13Cr1fKw4fZw4rtr43Wrg_yoW8JF17pa
        yUG3WYkr4vqFyfCrZ2vFW7Z3yrZ3yxJ3W2qrZ8twn8Zr13Wr90kr1xXF4Fga1v9r18KFyf
        t3W7Ka4rJa4jvaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkjb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWUJVW8JwA2z4x0Y4vEx4A2jsIEc7CjxV
        AFwI0_Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
        x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
        0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IYc2Ij
        64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
        8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE
        2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42
        xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
        c7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UWE__UUUUU=
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAgAFBF1jj4D+JAACsq
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2022-11-02 at 18:04 -0400, Mimi Zohar wrote:
> Hi Roberto,
> 
> On Wed, 2022-11-02 at 17:30 +0100, Roberto Sassu wrote:
> > From: Roberto Sassu <roberto.sassu@huawei.com>
> 
> Any chance you could fix your mailer?

Hi Mimi

not sure how to fix this. I need to send from @huaweicloud.com because
some people didn't receive the patches from @huawei.com. But I still
prefer to have the original email in the patches.

Thanks

Roberto

> > Commit f3cc6b25dcc5 ("ima: always measure and audit files in
> > policy") lets
> > measurement or audit happen even if the file digest cannot be
> > calculated.
> > 
> > As a result, iint->ima_hash could have been allocated despite
> > ima_collect_measurement() returning an error.
> > 
> > Since ima_hash belongs to a temporary inode metadata structure,
> > declared
> > at the beginning of __ima_inode_hash(), just add a kfree() call if
> > ima_collect_measurement() returns an error different from -ENOMEM
> > (in that
> > case, ima_hash should not have been allocated).
> > 
> > Cc: stable@vger.kernel.org
> > Fixes: 280fe8367b0d ("ima: Always return a file measurement in
> > ima_file_hash()")
> > Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> 
> Thanks,
> 
> Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>

