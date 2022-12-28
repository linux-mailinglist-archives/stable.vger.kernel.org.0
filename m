Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B624658045
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:16:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234507AbiL1QQ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:16:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232997AbiL1QQF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:16:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DE581A828
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:13:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB6E66156E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:13:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92198C433D2;
        Wed, 28 Dec 2022 16:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244003;
        bh=EIj8sJGijWRFsfgtNCgCcLWUcJjmrtfZbMz2oLgw5qE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gZUURE2/pWDRmXwv6zpLHRVHnK5ju4LVAedI5VfmNSxrxlk9pjL6/qupRKX+01GaO
         EfX/NKdZ3zvxJwkO95/ORN6iy/U+3s+vPLgkn6WfMLoiAvt7RiK0vDrM/O01YJURG7
         88wKODl135FUyvuW41I/D4lHqQjjVsJ/+gMKiu9Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xiu Jianfeng <xiujianfeng@huawei.com>,
        John Johansen <john.johansen@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0593/1146] apparmor: Fix memleak in alloc_ns()
Date:   Wed, 28 Dec 2022 15:35:32 +0100
Message-Id: <20221228144346.277195003@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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
index 43beaad083fe..78700d94b453 100644
--- a/security/apparmor/policy_ns.c
+++ b/security/apparmor/policy_ns.c
@@ -134,7 +134,7 @@ static struct aa_ns *alloc_ns(const char *prefix, const char *name)
 	return ns;
 
 fail_unconfined:
-	kfree_sensitive(ns->base.hname);
+	aa_policy_destroy(&ns->base);
 fail_ns:
 	kfree_sensitive(ns);
 	return NULL;
-- 
2.35.1



