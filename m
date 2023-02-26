Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB62E6A3115
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 15:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbjBZO4I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 09:56:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230484AbjBZOyh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 09:54:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 962875FE8;
        Sun, 26 Feb 2023 06:50:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6DBDB80C75;
        Sun, 26 Feb 2023 14:50:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79C7AC433EF;
        Sun, 26 Feb 2023 14:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677423003;
        bh=UUm4tSIP2oQ/cNLrwzxPHH7f4fd91DROcezNUsi8aPQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c0waMukm+Kf3c0/kRqKhIGBL2SegsIamQ6lA4upIvm0WHtjfB78nX2WOP1dC6YEws
         xU4PYdVdCR2lK+eK3V2qzKZnyQQ0ObxiIgdEjA7cBvCT14Xp65HWdyJytpgWMfOVOz
         rGi89wfD95q+VLyGG0/00xnN2rkyeBWzx+W3r8I/qiNJ9DOhRglNp9cIOmxZSFomiC
         qIlfLfAXYRG0nAw7BrDWgjRUS8C+CJFQA+lcpze+a4eTwhfCauFyojRXQY+rIx3dQz
         84iPO41V7ZDONkxseWluwpbZ7Po5NRM3MnZt8xueIiYYaxP8Mimhgj8lzxGNbYEpFz
         GEvYu0yVxFLbA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        pavel@ucw.cz, len.brown@intel.com, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 32/36] PM: EM: fix memory leak with using debugfs_lookup()
Date:   Sun, 26 Feb 2023 09:48:40 -0500
Message-Id: <20230226144845.827893-32-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226144845.827893-1-sashal@kernel.org>
References: <20230226144845.827893-1-sashal@kernel.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit a0e8c13ccd6a9a636d27353da62c2410c4eca337 ]

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To make things simpler, just
call debugfs_lookup_and_remove() instead which handles all of the logic
at once.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/power/energy_model.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/kernel/power/energy_model.c b/kernel/power/energy_model.c
index 97e62469a6b32..1b902f986f91c 100644
--- a/kernel/power/energy_model.c
+++ b/kernel/power/energy_model.c
@@ -85,10 +85,7 @@ static void em_debug_create_pd(struct device *dev)
 
 static void em_debug_remove_pd(struct device *dev)
 {
-	struct dentry *debug_dir;
-
-	debug_dir = debugfs_lookup(dev_name(dev), rootdir);
-	debugfs_remove_recursive(debug_dir);
+	debugfs_lookup_and_remove(dev_name(dev), rootdir);
 }
 
 static int __init em_debug_init(void)
-- 
2.39.0

