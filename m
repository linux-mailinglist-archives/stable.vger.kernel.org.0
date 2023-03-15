Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63E116BB340
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232993AbjCOMmz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:42:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233030AbjCOMmf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:42:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60EB7A5684
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:41:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 507F661D57
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:41:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66502C433D2;
        Wed, 15 Mar 2023 12:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678884070;
        bh=VQBdy/b9AsaFWTPJJFTQN1CCxBXFZCaBKSUQfhykkl0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s5fUbLJRDql8AmIxrab/Ng2ymWoaePlL8hSzYn+hrXRM9eZP2k8yH+RTcsiEOc2Oc
         +s/VTfsdFlmHOf9O5sBjnuNXzf+xuUCfeRWCajfCG0pd2Tdpajow+VINdjU6SUeHAk
         UaWQqYYdOcIP7mncBafNUdT/WgvvHuCQMmPxR4iY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Armin Wolf <W_Armin@gmx.de>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 094/141] platform/x86: dell-ddv: Return error if buffer is empty
Date:   Wed, 15 Mar 2023 13:13:17 +0100
Message-Id: <20230315115742.860584598@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
References: <20230315115739.932786806@linuxfoundation.org>
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

[ Upstream commit 36d44825faf42903a0b92dd49a9620e2cbdcbe18 ]

In several cases, the DDV WMI interface can return buffers
with a length of zero. Return -ENODATA in such a case for
proper error handling. Also replace some -EIO errors with
more specialized ones.

Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://lore.kernel.org/r/20230126194021.381092-3-W_Armin@gmx.de
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Stable-dep-of: 0331b1b0ba65 ("platform/x86: dell-ddv: Fix temperature scaling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/dell/dell-wmi-ddv.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/dell/dell-wmi-ddv.c b/drivers/platform/x86/dell/dell-wmi-ddv.c
index 9cb6ae42dbdc8..f99c4cb686fdc 100644
--- a/drivers/platform/x86/dell/dell-wmi-ddv.c
+++ b/drivers/platform/x86/dell/dell-wmi-ddv.c
@@ -11,6 +11,7 @@
 #include <linux/debugfs.h>
 #include <linux/device.h>
 #include <linux/dev_printk.h>
+#include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/kstrtox.h>
 #include <linux/math.h>
@@ -125,21 +126,27 @@ static int dell_wmi_ddv_query_buffer(struct wmi_device *wdev, enum dell_ddv_meth
 	if (ret < 0)
 		return ret;
 
-	if (obj->package.count != 2)
-		goto err_free;
+	if (obj->package.count != 2 ||
+	    obj->package.elements[0].type != ACPI_TYPE_INTEGER ||
+	    obj->package.elements[1].type != ACPI_TYPE_BUFFER) {
+		ret = -ENOMSG;
 
-	if (obj->package.elements[0].type != ACPI_TYPE_INTEGER)
 		goto err_free;
+	}
 
 	buffer_size = obj->package.elements[0].integer.value;
 
-	if (obj->package.elements[1].type != ACPI_TYPE_BUFFER)
+	if (!buffer_size) {
+		ret = -ENODATA;
+
 		goto err_free;
+	}
 
 	if (buffer_size > obj->package.elements[1].buffer.length) {
 		dev_warn(&wdev->dev,
 			 FW_WARN "WMI buffer size (%llu) exceeds ACPI buffer size (%d)\n",
 			 buffer_size, obj->package.elements[1].buffer.length);
+		ret = -EMSGSIZE;
 
 		goto err_free;
 	}
@@ -151,7 +158,7 @@ static int dell_wmi_ddv_query_buffer(struct wmi_device *wdev, enum dell_ddv_meth
 err_free:
 	kfree(obj);
 
-	return -EIO;
+	return ret;
 }
 
 static int dell_wmi_ddv_query_string(struct wmi_device *wdev, enum dell_ddv_method method,
-- 
2.39.2



