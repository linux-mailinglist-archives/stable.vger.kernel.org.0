Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3A906556F8
	for <lists+stable@lfdr.de>; Sat, 24 Dec 2022 02:30:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233343AbiLXB36 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Dec 2022 20:29:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233351AbiLXB3w (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Dec 2022 20:29:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2FE017418;
        Fri, 23 Dec 2022 17:29:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8AD2961FA3;
        Sat, 24 Dec 2022 01:29:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FE0EC433A7;
        Sat, 24 Dec 2022 01:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671845383;
        bh=MnkZUn0SXCpGTDedym3TUcplPdhbJQvWIUT/qY8tqcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZamrtyTKt5IBeeqeptU6yWzQMS3OAM7mXmn3zGVqDiGOZPGkoiSvfpA9Z8R+t/iMS
         ZFHPNOxmaC64P7WXx31rzvjpRzUNYIK93adXTwbh0Uryw0filrMLulbSY/Yz2K4qCK
         qONAiTYDhuPFEaBpbRFjfiphR8p1WeFkwuOciJgCqUn/iNGREGOD3BQf/HBp2sLj2U
         tI2gNWy+Y/D9aqExbXSK5N/APHn0l+isguprxFWWELUMg2guHS9FSDNmgIS7QinP2F
         lvcH6gFeAp1K4oB1PTMUr4LXEK0ExZT5fV2o1RbzW7v+mPtsLJ6D/xJ0teS0fXoEOa
         R5AURRUm4y+fQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Luben Tuikov <luben.tuikov@amd.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.1 08/26] kset: fix memory leak when kset_register() returns error
Date:   Fri, 23 Dec 2022 20:29:12 -0500
Message-Id: <20221224012930.392358-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221224012930.392358-1-sashal@kernel.org>
References: <20221224012930.392358-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 1662cea4623f75d8251adf07370bbaa958f0355d ]

Inject fault while loading module, kset_register() may fail.
If it fails, the kset.kobj.name allocated by kobject_set_name()
which must be called before a call to kset_register() may be
leaked, since refcount of kobj was set in kset_init().

To mitigate this, we free the name in kset_register() when an
error is encountered, i.e. when kset_register() returns an error.

A kset may be embedded in a larger structure which may be dynamically
allocated in callers, it needs to be freed in ktype.release() or error
path in callers, in this case, we can not call kset_put() in kset_register(),
or it will cause double free, so just call kfree_const() to free the
name and set it to NULL to avoid accessing bad pointer in callers.

With this fix, the callers don't need care about freeing the name
and may call kset_put() if kset_register() fails.

Suggested-by: Luben Tuikov <luben.tuikov@amd.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: <luben.tuikov@amd.com>
Link: https://lore.kernel.org/r/20221025071549.1280528-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/kobject.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index a0b2dbfcfa23..3cd19b9ca5ab 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -834,6 +834,9 @@ EXPORT_SYMBOL_GPL(kobj_sysfs_ops);
 /**
  * kset_register() - Initialize and add a kset.
  * @k: kset.
+ *
+ * NOTE: On error, the kset.kobj.name allocated by() kobj_set_name()
+ * is freed, it can not be used any more.
  */
 int kset_register(struct kset *k)
 {
@@ -844,8 +847,12 @@ int kset_register(struct kset *k)
 
 	kset_init(k);
 	err = kobject_add_internal(&k->kobj);
-	if (err)
+	if (err) {
+		kfree_const(k->kobj.name);
+		/* Set it to NULL to avoid accessing bad pointer in callers. */
+		k->kobj.name = NULL;
 		return err;
+	}
 	kobject_uevent(&k->kobj, KOBJ_ADD);
 	return 0;
 }
-- 
2.35.1

