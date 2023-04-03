Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A68086D48C2
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233481AbjDCObo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233491AbjDCObk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:31:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73AAD35009
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:31:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE72661DC8
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:31:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F452C433D2;
        Mon,  3 Apr 2023 14:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532294;
        bh=610eYB4IEW3NrhHmH0fo76VOsyahLA/go6GJkQBsv+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wEf6zE2tEuDYfWIeMk4N1eWXcYzCCYsa73dJCX4Luik1220BSdavX5kHpi8bt1722
         tnZwk2MDr+CWvTENoHYjjXu440ZjKmGddjfVRjyCt33v+GuwMQqj57BjcClgdQG0FN
         HngqJvvLrdLgNWQo71FP5rrzDAQJNQApmnnyojHI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
        Mark Pearson <mpearson-lenovo@squebb.ca>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 28/99] platform/x86: think-lmi: use correct possible_values delimiters
Date:   Mon,  3 Apr 2023 16:08:51 +0200
Message-Id: <20230403140404.120824261@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140356.079638751@linuxfoundation.org>
References: <20230403140356.079638751@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Pearson <mpearson-lenovo@squebb.ca>

[ Upstream commit 45e21289bfc6e257885514790a8a8887da822d40 ]

firmware-attributes class requires that possible values are delimited
using ';' but the Lenovo firmware uses ',' instead.
Parse string and replace where appropriate.

Suggested-by: Thomas Weißschuh <linux@weissschuh.net>
Fixes: a40cd7ef22fb ("platform/x86: think-lmi: Add WMI interface support on Lenovo platforms")
Signed-off-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Link: https://lore.kernel.org/r/20230320003221.561750-2-mpearson-lenovo@squebb.ca
Reviewed-by: Thomas Weißschuh <linux@weissschuh.net>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/think-lmi.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/think-lmi.c b/drivers/platform/x86/think-lmi.c
index 0c166b4fa7167..f10fe5ffe47df 100644
--- a/drivers/platform/x86/think-lmi.c
+++ b/drivers/platform/x86/think-lmi.c
@@ -538,7 +538,7 @@ static ssize_t type_show(struct kobject *kobj, struct kobj_attribute *attr,
 
 	if (setting->possible_values) {
 		/* Figure out what setting type is as BIOS does not return this */
-		if (strchr(setting->possible_values, ','))
+		if (strchr(setting->possible_values, ';'))
 			return sysfs_emit(buf, "enumeration\n");
 	}
 	/* Anything else is going to be a string */
@@ -934,6 +934,13 @@ static int tlmi_analyze(void)
 				pr_info("Error retrieving possible values for %d : %s\n",
 						i, setting->display_name);
 		}
+		/*
+		 * firmware-attributes requires that possible_values are separated by ';' but
+		 * Lenovo FW uses ','. Replace appropriately.
+		 */
+		if (setting->possible_values)
+			strreplace(setting->possible_values, ',', ';');
+
 		kobject_init(&setting->kobj, &tlmi_attr_setting_ktype);
 		tlmi_priv.setting[i] = setting;
 		kfree(item);
-- 
2.39.2



