Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBD5B6CD9F4
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 15:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229379AbjC2NF0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 09:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbjC2NFX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 09:05:23 -0400
Received: from frasgout11.his.huawei.com (frasgout11.his.huawei.com [14.137.139.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C94514C02;
        Wed, 29 Mar 2023 06:05:15 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.18.147.228])
        by frasgout11.his.huawei.com (SkyGuard) with ESMTP id 4Pmmkr3z68z9v7gX;
        Wed, 29 Mar 2023 20:56:04 +0800 (CST)
Received: from huaweicloud.com (unknown [10.204.63.22])
        by APP1 (Coremail) with SMTP id LxC2BwCXFABgNyRk2AzcAQ--.1625S3;
        Wed, 29 Mar 2023 14:04:52 +0100 (CET)
From:   Roberto Sassu <roberto.sassu@huaweicloud.com>
To:     zohar@linux.ibm.com, dmitry.kasatkin@gmail.com,
        paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
        stephen.smalley.work@gmail.com, eparis@parisplace.org,
        casey@schaufler-ca.com
Cc:     reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        bpf@vger.kernel.org, kpsingh@kernel.org, keescook@chromium.org,
        nicolas.bouchinet@clip-os.org,
        Roberto Sassu <roberto.sassu@huawei.com>,
        stable@vger.kernel.org
Subject: [PATCH v9 1/4] reiserfs: Add security prefix to xattr name in reiserfs_security_write()
Date:   Wed, 29 Mar 2023 15:04:12 +0200
Message-Id: <20230329130415.2312521-2-roberto.sassu@huaweicloud.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230329130415.2312521-1-roberto.sassu@huaweicloud.com>
References: <20230329130415.2312521-1-roberto.sassu@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: LxC2BwCXFABgNyRk2AzcAQ--.1625S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Zw17Aw13Xr18GrW3WFWruFg_yoW8ZryfpF
        WUK3WDCr1DJF1vg3sakanxua40gFWrW3y7W39rK3sFyanrXw1xtFW0yrW3WrW8GrWDXr92
        qa18Gw45A3Z5A3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUPqb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUGw
        A2048vs2IY020Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
        w2x7M28EF7xvwVC0I7IYx2IY67AKxVWUCVW8JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
        W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
        6r4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2
        WlYx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkE
        bVWUJVW8JwACjcxG0xvY0x0EwIxGrwACI402YVCY1x02628vn2kIc2xKxwCY1x0262kKe7
        AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02
        F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_Wr
        ylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7Cj
        xVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI
        0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x
        07jfcTPUUUUU=
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAgALBF1jj4dSKQAAsA
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roberto Sassu <roberto.sassu@huawei.com>

Reiserfs sets a security xattr at inode creation time in two stages: first,
it calls reiserfs_security_init() to obtain the xattr from active LSMs;
then, it calls reiserfs_security_write() to actually write that xattr.

Unfortunately, it seems there is a wrong expectation that LSMs provide the
full xattr name in the form 'security.<suffix>'. However, LSMs always
provided just the suffix, causing reiserfs to not write the xattr at all
(if the suffix is shorter than the prefix), or to write an xattr with the
wrong name.

Add a temporary buffer in reiserfs_security_write(), and write to it the
full xattr name, before passing it to reiserfs_xattr_set_handle().

Since the 'security.' prefix is always prepended, remove the name length
check.

Cc: stable@vger.kernel.org # v2.6.x
Fixes: 57fe60df6241 ("reiserfs: add atomic addition of selinux attributes during inode creation")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 fs/reiserfs/xattr_security.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/reiserfs/xattr_security.c b/fs/reiserfs/xattr_security.c
index 6bffdf9a4fd..b0c354ab113 100644
--- a/fs/reiserfs/xattr_security.c
+++ b/fs/reiserfs/xattr_security.c
@@ -95,11 +95,13 @@ int reiserfs_security_write(struct reiserfs_transaction_handle *th,
 			    struct inode *inode,
 			    struct reiserfs_security_handle *sec)
 {
+	char xattr_name[XATTR_NAME_MAX + 1];
 	int error;
-	if (strlen(sec->name) < sizeof(XATTR_SECURITY_PREFIX))
-		return -EINVAL;
 
-	error = reiserfs_xattr_set_handle(th, inode, sec->name, sec->value,
+	snprintf(xattr_name, sizeof(xattr_name), "%s%s", XATTR_SECURITY_PREFIX,
+		 sec->name);
+
+	error = reiserfs_xattr_set_handle(th, inode, xattr_name, sec->value,
 					  sec->length, XATTR_CREATE);
 	if (error == -ENODATA || error == -EOPNOTSUPP)
 		error = 0;
-- 
2.25.1

