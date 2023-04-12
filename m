Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B376C6DEE7E
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbjDLImA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:42:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231161AbjDLIld (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:41:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AB166A49
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:40:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A0A463014
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:40:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD53C433A1;
        Wed, 12 Apr 2023 08:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288846;
        bh=b58c0GxXaSToQJMoKlWIf/Npy4kK0r9k02SR2EDdD6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SMSV6cGcGa4/4Xxx1yCd/fyOg8vaV6SQO8d7ouuqpIw9T003ochLhZXfMmRz0uaah
         lvxlJYMXLpDzWACqFIW6+X7Z2TR3wJ/ThYlsPo3nJTNDvegpHr2dfIm979TjAAZBEM
         QktLF7w0TOV/Rt8djavEQJZl3EizkdKbV8W0DrQg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mark Pearson <mpearson-lenovo@squebb.ca>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 039/164] platform/x86: think-lmi: Clean up display of current_value on Thinkstation
Date:   Wed, 12 Apr 2023 10:32:41 +0200
Message-Id: <20230412082838.522256427@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
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

From: Mark Pearson <mpearson-lenovo@squebb.ca>

[ Upstream commit 7065655216d4d034d71164641f3bec0b189ad6fa ]

On ThinkStations on retrieving the attribute value the BIOS appends the
possible values to the string.
Clean up the display in the current_value_show function so the options
part is not displayed.

Fixes: a40cd7ef22fb ("platform/x86: think-lmi: Add WMI interface support on Lenovo platforms")
Reported by Mario Limoncello <Mario.Limonciello@amd.com>
Link: https://github.com/fwupd/fwupd/issues/5077#issuecomment-1488730526
Signed-off-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Link: https://lore.kernel.org/r/20230403013120.2105-2-mpearson-lenovo@squebb.ca
Tested-by: Mario Limonciello <mario.limonciello@amd.com>
Tested-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/think-lmi.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/think-lmi.c b/drivers/platform/x86/think-lmi.c
index 70c4ee254c43a..336b9029d1515 100644
--- a/drivers/platform/x86/think-lmi.c
+++ b/drivers/platform/x86/think-lmi.c
@@ -920,7 +920,7 @@ static ssize_t display_name_show(struct kobject *kobj, struct kobj_attribute *at
 static ssize_t current_value_show(struct kobject *kobj, struct kobj_attribute *attr, char *buf)
 {
 	struct tlmi_attr_setting *setting = to_tlmi_attr_setting(kobj);
-	char *item, *value;
+	char *item, *value, *p;
 	int ret;
 
 	ret = tlmi_setting(setting->index, &item, LENOVO_BIOS_SETTING_GUID);
@@ -931,9 +931,12 @@ static ssize_t current_value_show(struct kobject *kobj, struct kobj_attribute *a
 	value = strpbrk(item, ",");
 	if (!value || value == item || !strlen(value + 1))
 		ret = -EINVAL;
-	else
+	else {
+		/* On Workstations remove the Options part after the value */
+		p = strchrnul(value, ';');
+		*p = '\0';
 		ret = sysfs_emit(buf, "%s\n", value + 1);
-
+	}
 	kfree(item);
 
 	return ret;
-- 
2.39.2



