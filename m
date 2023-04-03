Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A56026D4A52
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233962AbjDCOqV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:46:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233940AbjDCOqP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:46:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EFD2280D4
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:45:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92818B80B98
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:45:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FDB6C4339C;
        Mon,  3 Apr 2023 14:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680533150;
        bh=6q0Ps7XB8faagxeptPEDGa8C3aWgFEcEf3qeY75/eCo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CAbDwyLgQ8kDFFQIu23pE374iNzPg+09tkCQ6Al+C38fnDSA6r4+RChpBHT1SPT10
         dN6EWfjcrtTC/kbHZeY9od5MRb1ASX8tuD3Hjei/8+ip+xW16AycJGPrwbgKk9ddP6
         n4k7f6JILQ0ZrwWqFBN+Kq3NZcJEwNbhP8LDYpNQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mark Pearson <mpearson-lenovo@squebb.ca>,
        =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 073/187] platform/x86: think-lmi: only display possible_values if available
Date:   Mon,  3 Apr 2023 16:08:38 +0200
Message-Id: <20230403140418.352055298@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
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

[ Upstream commit cf337f27f3bfc4aeab4954c468239fd6233c7638 ]

Some attributes don't have any values available. In those cases don't
make the possible_values entry visible.

Fixes: a40cd7ef22fb ("platform/x86: think-lmi: Add WMI interface support on Lenovo platforms")
Signed-off-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Link: https://lore.kernel.org/r/20230320003221.561750-3-mpearson-lenovo@squebb.ca
Reviewed-by: Thomas Weißschuh <linux@weissschuh.net>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/think-lmi.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/think-lmi.c b/drivers/platform/x86/think-lmi.c
index 62241680c8a90..ccd085bacf298 100644
--- a/drivers/platform/x86/think-lmi.c
+++ b/drivers/platform/x86/think-lmi.c
@@ -941,9 +941,6 @@ static ssize_t possible_values_show(struct kobject *kobj, struct kobj_attribute
 {
 	struct tlmi_attr_setting *setting = to_tlmi_attr_setting(kobj);
 
-	if (!tlmi_priv.can_get_bios_selections)
-		return -EOPNOTSUPP;
-
 	return sysfs_emit(buf, "%s\n", setting->possible_values);
 }
 
@@ -1052,6 +1049,18 @@ static struct kobj_attribute attr_current_val = __ATTR_RW_MODE(current_value, 06
 
 static struct kobj_attribute attr_type = __ATTR_RO(type);
 
+static umode_t attr_is_visible(struct kobject *kobj,
+					     struct attribute *attr, int n)
+{
+	struct tlmi_attr_setting *setting = to_tlmi_attr_setting(kobj);
+
+	/* We don't want to display possible_values attributes if not available */
+	if ((attr == &attr_possible_values.attr) && (!setting->possible_values))
+		return 0;
+
+	return attr->mode;
+}
+
 static struct attribute *tlmi_attrs[] = {
 	&attr_displ_name.attr,
 	&attr_current_val.attr,
@@ -1061,6 +1070,7 @@ static struct attribute *tlmi_attrs[] = {
 };
 
 static const struct attribute_group tlmi_attr_group = {
+	.is_visible = attr_is_visible,
 	.attrs = tlmi_attrs,
 };
 
-- 
2.39.2



