Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A38CE65323E
	for <lists+stable@lfdr.de>; Wed, 21 Dec 2022 15:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231421AbiLUOKg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Dec 2022 09:10:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbiLUOKf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Dec 2022 09:10:35 -0500
Received: from frasgout12.his.huawei.com (frasgout12.his.huawei.com [14.137.139.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDCD423BEC;
        Wed, 21 Dec 2022 06:10:31 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.18.147.227])
        by frasgout12.his.huawei.com (SkyGuard) with ESMTP id 4NcZsm2fxLz9xFrp;
        Wed, 21 Dec 2022 22:03:24 +0800 (CST)
Received: from huaweicloud.com (unknown [10.204.63.22])
        by APP2 (Coremail) with SMTP id GxC2BwAH2F7DE6NjUuUvAA--.8166S2;
        Wed, 21 Dec 2022 15:10:18 +0100 (CET)
From:   Roberto Sassu <roberto.sassu@huaweicloud.com>
To:     paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
        zohar@linux.ibm.com
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        Roberto Sassu <roberto.sassu@huawei.com>,
        stable@vger.kernel.org
Subject: [PATCH v2] security: Restore passing final prot to ima_file_mmap()
Date:   Wed, 21 Dec 2022 15:10:07 +0100
Message-Id: <20221221141007.2579770-1-roberto.sassu@huaweicloud.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: GxC2BwAH2F7DE6NjUuUvAA--.8166S2
X-Coremail-Antispam: 1UD129KBjvJXoW7AFW7AF45ArW3Gw1kGF1rJFb_yoW8Xr1fpa
        y5t3WUKrs5JFyFqFn7WFW7CF1Sk39xKFWUWan2gryj93Z8XFnYkr15AFWj9ry8Xrn5JFyF
        qw12k3y3A3Wqy3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUk2b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxV
        AFwI0_Gr1j6F4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
        6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
        Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxAIw28I
        cxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2
        IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI
        42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42
        IY6xAIw20EY4v20xvaj40_Zr0_Wr1UMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2
        jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvjxUOyCJDUUUU
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAgANBF1jj4LnoQAAs+
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roberto Sassu <roberto.sassu@huawei.com>

Commit 98de59bfe4b2f ("take calculation of final prot in
security_mmap_file() into a helper") moved the code to update prot with the
actual protection flags to be granted to the requestor by the kernel to a
helper called mmap_prot(). However, the patch didn't update the argument
passed to ima_file_mmap(), making it receive the requested prot instead of
the final computed prot.

A possible consequence is that files mmapped as executable might not be
measured/appraised if PROT_EXEC is not requested but subsequently added in
the final prot.

Replace prot with mmap_prot(file, prot) as the second argument of
ima_file_mmap() to restore the original behavior.

Cc: stable@vger.kernel.org
Fixes: 98de59bfe4b2 ("take calculation of final prot in security_mmap_file() into a helper")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 security/security.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/security.c b/security/security.c
index d1571900a8c7..0d2359d588a1 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1666,7 +1666,7 @@ int security_mmap_file(struct file *file, unsigned long prot,
 					mmap_prot(file, prot), flags);
 	if (ret)
 		return ret;
-	return ima_file_mmap(file, prot);
+	return ima_file_mmap(file, mmap_prot(file, prot));
 }
 
 int security_mmap_addr(unsigned long addr)
-- 
2.25.1

