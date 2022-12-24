Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 888FA655750
	for <lists+stable@lfdr.de>; Sat, 24 Dec 2022 02:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236658AbiLXBdm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Dec 2022 20:33:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236671AbiLXBdM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Dec 2022 20:33:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 718D640806;
        Fri, 23 Dec 2022 17:31:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50BEB61F9C;
        Sat, 24 Dec 2022 01:31:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23ABCC433F0;
        Sat, 24 Dec 2022 01:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671845474;
        bh=IttfnRdxllbwwyrZh41FfXPVwXvCKzCGyp9jpI3PxN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hefv+Jui/kGXe4r3z27ShHfS8OxftO/4LP22NIy+v5EWGX4pZLyt/eQLMeCgZ6TIp
         r3FC2jjgwH/xaoPCUNIWfDpH5g9iZIe6Ll/YCqKcY7N8dwyn7TqvafKM+zGehK/OlQ
         0p3rYgnWfVPjl+CFv/+xGtAWOexI4ARDdvhrmvIdedRspdo0qj2bTj9v/WwhI2ba9C
         ginzu7Kc2y9UOXDdxtyod6SY7bxLEsVjaTxaK/qMnV+ebumpTOKTL7QOvfDtqjcKYL
         JiGOCpi3qld6UM19j0Nhz5Zcx1HfPZYFfY/wk2zmXUxpIRhX+Ke2ic6I5SKM6J6pk2
         jWF97KZUFBHAw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eli Billauer <eli.billauer@gmail.com>,
        Hyunwoo Kim <imv4bel@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.0 11/18] char: xillybus: Fix trivial bug with mutex
Date:   Fri, 23 Dec 2022 20:30:27 -0500
Message-Id: <20221224013034.392810-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221224013034.392810-1-sashal@kernel.org>
References: <20221224013034.392810-1-sashal@kernel.org>
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

From: Eli Billauer <eli.billauer@gmail.com>

[ Upstream commit c002f04c0bc79ec00d4beb75fb631d5bf37419bd ]

@unit_mutex protects @unit from being freed, so obviously it should be
released after @unit is used, and not before.

This is a follow-up to commit 282a4b71816b ("char: xillybus: Prevent
use-after-free due to race condition") which ensures, among others, the
protection of @private_data after @unit_mutex has been released.

Reported-by: Hyunwoo Kim <imv4bel@gmail.com>
Signed-off-by: Eli Billauer <eli.billauer@gmail.com>
Link: https://lore.kernel.org/r/20221117071825.3942-1-eli.billauer@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/xillybus/xillybus_class.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/char/xillybus/xillybus_class.c b/drivers/char/xillybus/xillybus_class.c
index 0f238648dcfe..e9a288e61c15 100644
--- a/drivers/char/xillybus/xillybus_class.c
+++ b/drivers/char/xillybus/xillybus_class.c
@@ -227,14 +227,15 @@ int xillybus_find_inode(struct inode *inode,
 			break;
 		}
 
-	mutex_unlock(&unit_mutex);
-
-	if (!unit)
+	if (!unit) {
+		mutex_unlock(&unit_mutex);
 		return -ENODEV;
+	}
 
 	*private_data = unit->private_data;
 	*index = minor - unit->lowest_minor;
 
+	mutex_unlock(&unit_mutex);
 	return 0;
 }
 EXPORT_SYMBOL(xillybus_find_inode);
-- 
2.35.1

