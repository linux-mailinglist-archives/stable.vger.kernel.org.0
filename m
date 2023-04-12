Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 608346DEF32
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231266AbjDLItF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:49:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231256AbjDLIsx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:48:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02AE583D9
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:48:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF31563122
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:47:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2127C4339B;
        Wed, 12 Apr 2023 08:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289272;
        bh=44hdiDc/hmsXy7eU4R3GTlkJvlovBQOh576uDgGNeRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ESdBrs5DDoaf8Ccu/9eXLoNb+WNS7DJyBIpzQAbYmjUSo+Q8udAuPb6b91g/ChPCu
         DnahhZ2f+3zPQBnuNjJ8SREXrtz9RsUg+hFNzhnOe6P31HJ4c7zZ9d+RANdYUk1V41
         SokrlfiufmqsH/CidIMLkvtp2V6rxECM9kWSrV5Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>,
        Armin Wolf <W_Armin@gmx.de>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 036/173] platform/x86: think-lmi: Fix memory leak when showing current settings
Date:   Wed, 12 Apr 2023 10:32:42 +0200
Message-Id: <20230412082839.549776571@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
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
index 74af3e593b2ca..4e738ec5e6fb8 100644
--- a/drivers/platform/x86/think-lmi.c
+++ b/drivers/platform/x86/think-lmi.c
@@ -930,10 +930,12 @@ static ssize_t current_value_show(struct kobject *kobj, struct kobj_attribute *a
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



