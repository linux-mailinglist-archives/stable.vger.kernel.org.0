Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7846D48C1
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233492AbjDCObl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:31:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233477AbjDCObg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:31:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE49CD4F9B
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:31:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C21F61DC8
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:31:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63474C4339C;
        Mon,  3 Apr 2023 14:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532291;
        bh=spU2mk02nSgoWe3tfnPu2qFBJVFM5uiI2NMJ37z2o+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nIgVv+UZeM6RnOjjHwKxr0uIGr63x0SjmsMitC2obnwGxI7sSRjYbavZErYTyJ+Ww
         Rxzr37gmP15gEWT7l+E+vEgeRFiknCt1DqiY0seovWCJBZ3Q0rqOvUp4wSs6gjzeRq
         gpAq37LI9vTc9V4+y90a+4oKGSLql2vaL+1/iVHA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mark Pearson <mpearson-lenovo@squebb.ca>,
        =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 27/99] platform/x86: think-lmi: add missing type attribute
Date:   Mon,  3 Apr 2023 16:08:50 +0200
Message-Id: <20230403140403.992770380@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140356.079638751@linuxfoundation.org>
References: <20230403140356.079638751@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Pearson <mpearson-lenovo@squebb.ca>

[ Upstream commit 583329dcf22e568a328a944f20427ccfc95dce01 ]

This driver was missing the mandatory type attribute...oops.

Add it in along with logic to determine whether the attribute is an
enumeration type or a string by parsing the possible_values attribute.

Upstream bug https://bugzilla.kernel.org/show_bug.cgi?id=216460

Fixes: a40cd7ef22fb ("platform/x86: think-lmi: Add WMI interface support on Lenovo platforms")
Signed-off-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Link: https://lore.kernel.org/r/20230320003221.561750-1-mpearson-lenovo@squebb.ca
Reviewed-by: Thomas Weißschuh <linux@weissschuh.net>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/think-lmi.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/platform/x86/think-lmi.c b/drivers/platform/x86/think-lmi.c
index c4d9c45350f7c..0c166b4fa7167 100644
--- a/drivers/platform/x86/think-lmi.c
+++ b/drivers/platform/x86/think-lmi.c
@@ -531,6 +531,20 @@ static ssize_t possible_values_show(struct kobject *kobj, struct kobj_attribute
 	return sysfs_emit(buf, "%s\n", setting->possible_values);
 }
 
+static ssize_t type_show(struct kobject *kobj, struct kobj_attribute *attr,
+		char *buf)
+{
+	struct tlmi_attr_setting *setting = to_tlmi_attr_setting(kobj);
+
+	if (setting->possible_values) {
+		/* Figure out what setting type is as BIOS does not return this */
+		if (strchr(setting->possible_values, ','))
+			return sysfs_emit(buf, "enumeration\n");
+	}
+	/* Anything else is going to be a string */
+	return sysfs_emit(buf, "string\n");
+}
+
 static ssize_t current_value_store(struct kobject *kobj,
 		struct kobj_attribute *attr,
 		const char *buf, size_t count)
@@ -601,10 +615,13 @@ static struct kobj_attribute attr_possible_values = __ATTR_RO(possible_values);
 
 static struct kobj_attribute attr_current_val = __ATTR_RW_MODE(current_value, 0600);
 
+static struct kobj_attribute attr_type = __ATTR_RO(type);
+
 static struct attribute *tlmi_attrs[] = {
 	&attr_displ_name.attr,
 	&attr_current_val.attr,
 	&attr_possible_values.attr,
+	&attr_type.attr,
 	NULL
 };
 
-- 
2.39.2



