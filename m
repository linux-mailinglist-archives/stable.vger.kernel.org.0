Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF326D4976
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233699AbjDCOiJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233709AbjDCOiF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:38:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5323A7A9B
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:38:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC1B961E4A
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:38:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D09C1C4339B;
        Mon,  3 Apr 2023 14:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532683;
        bh=91f3rYXBheiyoSvrK9v8HR8nVGsHmUGeWKN+axlOpJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rrUYbleJkQq8M8N7C0MVOxLlq+C8b3xb/SwOHLFl1RAamo6lbuBQlxEfXb9hMKg3t
         kwjX97Iwn49OFRsfTNRoac7VCbXZDwwbsa1MlBy6Nt3GJkHvckHLl7j4nsuHe0jiBt
         r50da/LUPv7a3GIJcq+DlngW+G1yuoSqxbmRxQHU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
        Mark Pearson <mpearson-lenovo@squebb.ca>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 076/181] platform/x86: think-lmi: use correct possible_values delimiters
Date:   Mon,  3 Apr 2023 16:08:31 +0200
Message-Id: <20230403140417.605798681@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
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
index 07c9dc21eff52..62241680c8a90 100644
--- a/drivers/platform/x86/think-lmi.c
+++ b/drivers/platform/x86/think-lmi.c
@@ -954,7 +954,7 @@ static ssize_t type_show(struct kobject *kobj, struct kobj_attribute *attr,
 
 	if (setting->possible_values) {
 		/* Figure out what setting type is as BIOS does not return this */
-		if (strchr(setting->possible_values, ','))
+		if (strchr(setting->possible_values, ';'))
 			return sysfs_emit(buf, "enumeration\n");
 	}
 	/* Anything else is going to be a string */
@@ -1441,6 +1441,13 @@ static int tlmi_analyze(void)
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



