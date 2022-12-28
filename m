Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C002657B0B
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233129AbiL1PRe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:17:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233148AbiL1PRa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:17:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6190013E90
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:17:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 014376155A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:17:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14046C433EF;
        Wed, 28 Dec 2022 15:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240649;
        bh=MLRtfCooDebbWIHo2dsGHUY0wjpBQIhx4CKbimFIDYw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UQAAIeKQCOfbfu+919pZJQtHgCcYlLF/tgTqQoqcmOGnnMw+auOVZoXXitAFjqHLu
         J9nxHtiuvFQ0GTuHteYDNOC2WNlEO4Fiqvd7ex81WgyaRLumQ+eFhnNlpKP4eD9nfE
         3J/JXMWJRQqzdC/Rk3tYui4dqLEjK/qQeB5ShL88=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xiu Jianfeng <xiujianfeng@huawei.com>,
        John Johansen <john.johansen@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 377/731] apparmor: Fix memleak in alloc_ns()
Date:   Wed, 28 Dec 2022 15:38:04 +0100
Message-Id: <20221228144307.490248094@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiu Jianfeng <xiujianfeng@huawei.com>

[ Upstream commit e9e6fa49dbab6d84c676666f3fe7d360497fd65b ]

After changes in commit a1bd627b46d1 ("apparmor: share profile name on
replacement"), the hname member of struct aa_policy is not valid slab
object, but a subset of that, it can not be freed by kfree_sensitive(),
use aa_policy_destroy() to fix it.

Fixes: a1bd627b46d1 ("apparmor: share profile name on replacement")
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/policy_ns.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/apparmor/policy_ns.c b/security/apparmor/policy_ns.c
index 70921d95fb40..53d24cf63893 100644
--- a/security/apparmor/policy_ns.c
+++ b/security/apparmor/policy_ns.c
@@ -121,7 +121,7 @@ static struct aa_ns *alloc_ns(const char *prefix, const char *name)
 	return ns;
 
 fail_unconfined:
-	kfree_sensitive(ns->base.hname);
+	aa_policy_destroy(&ns->base);
 fail_ns:
 	kfree_sensitive(ns);
 	return NULL;
-- 
2.35.1



