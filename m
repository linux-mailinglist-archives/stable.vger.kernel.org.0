Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D43756DEE06
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbjDLIja (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:39:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbjDLIjQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:39:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 235807285
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:38:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF3AA62FFD
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:36:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF4B3C433EF;
        Wed, 12 Apr 2023 08:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288598;
        bh=588O07Z+3ILdCH6W3SAvUtlEB26cU4bVuHNfzB0mMzM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JMUgcy2b3Seyh9Hhwvu8pi3w3GPY8atPFeon0as9iOcSR3Khc7ZZxn0FwKlfR0mmE
         kN8bZ21TZx9ByXCKctwHsQmkCTPKRdZxqvG/Zvm4Zn69bklIcrABpg8LnnSuA3G3aI
         290oRdEihrnz4GxImgmJOfhwCQsRA17ExcCRNSeM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>,
        Armin Wolf <W_Armin@gmx.de>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 38/93] platform/x86: think-lmi: Fix memory leak when showing current settings
Date:   Wed, 12 Apr 2023 10:33:39 +0200
Message-Id: <20230412082824.729116934@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
References: <20230412082823.045155996@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit a3c4c053014585dcf20f4df954791b74d8a8afcd ]

When retriving a item string with tlmi_setting(), the result has to be
freed using kfree(). In current_value_show() however, malformed
item strings are not freed, causing a memory leak.
Fix this by eliminating the early return responsible for this.

Reported-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Link: https://lore.kernel.org/platform-driver-x86/01e920bc-5882-ba0c-dd15-868bf0eca0b8@alu.unizg.hr/T/#t
Tested-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Fixes: 0fdf10e5fc96 ("platform/x86: think-lmi: Split current_value to reflect only the value")
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://lore.kernel.org/r/20230331213319.41040-1-W_Armin@gmx.de
Tested-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/think-lmi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/think-lmi.c b/drivers/platform/x86/think-lmi.c
index c9ed2644bb8a6..5676587271988 100644
--- a/drivers/platform/x86/think-lmi.c
+++ b/drivers/platform/x86/think-lmi.c
@@ -514,10 +514,12 @@ static ssize_t current_value_show(struct kobject *kobj, struct kobj_attribute *a
 	/* validate and split from `item,value` -> `value` */
 	value = strpbrk(item, ",");
 	if (!value || value == item || !strlen(value + 1))
-		return -EINVAL;
+		ret = -EINVAL;
+	else
+		ret = sysfs_emit(buf, "%s\n", value + 1);
 
-	ret = sysfs_emit(buf, "%s\n", value + 1);
 	kfree(item);
+
 	return ret;
 }
 
-- 
2.39.2



