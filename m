Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3AD6CC35D
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233498AbjC1Ox0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:53:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233350AbjC1OxN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:53:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6591DBBA8
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:53:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00684B81BBF
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:53:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51308C4339B;
        Tue, 28 Mar 2023 14:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015189;
        bh=nGtLg67O8dMCGSO/jfVs9elCVnbhqXczJgjQafb3XtM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rIZPcWQP6pz3Z8e/4oV2goBvLt2cHSVO8eDVGtIUPR+O9C/UlcEpxeF0QOpWSocRg
         Duotpt5HJ/Y8etk2iH2iimFph4qpBt6G2Iv9TiVSm3cm+Paj/I0xjbkjIvQRffx9iE
         nKAmuK1p784r83wdcUXplesQuxOeHIhKS3Gvgqho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Peter Chen <peter.chen@kernel.org>,
        Xu Yang <xu.yang_2@nxp.com>
Subject: [PATCH 6.2 197/240] usb: chipidea: core: fix possible concurrent when switch role
Date:   Tue, 28 Mar 2023 16:42:40 +0200
Message-Id: <20230328142627.871113709@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
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

From: Xu Yang <xu.yang_2@nxp.com>

commit 451b15ed138ec15bffbebb58a00ebdd884c3e659 upstream.

The user may call role_store() when driver is handling
ci_handle_id_switch() which is triggerred by otg event or power lost
event. Unfortunately, the controller may go into chaos in this case.
Fix this by protecting it with mutex lock.

Fixes: a932a8041ff9 ("usb: chipidea: core: add sysfs group")
cc: <stable@vger.kernel.org>
Acked-by: Peter Chen <peter.chen@kernel.org>
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Link: https://lore.kernel.org/r/20230317061516.2451728-2-xu.yang_2@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/chipidea/ci.h   | 2 ++
 drivers/usb/chipidea/core.c | 8 +++++++-
 drivers/usb/chipidea/otg.c  | 5 ++++-
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/chipidea/ci.h b/drivers/usb/chipidea/ci.h
index 005c67cb3afb..f210b7489fd5 100644
--- a/drivers/usb/chipidea/ci.h
+++ b/drivers/usb/chipidea/ci.h
@@ -208,6 +208,7 @@ struct hw_bank {
  * @in_lpm: if the core in low power mode
  * @wakeup_int: if wakeup interrupt occur
  * @rev: The revision number for controller
+ * @mutex: protect code from concorrent running when doing role switch
  */
 struct ci_hdrc {
 	struct device			*dev;
@@ -260,6 +261,7 @@ struct ci_hdrc {
 	bool				in_lpm;
 	bool				wakeup_int;
 	enum ci_revision		rev;
+	struct mutex                    mutex;
 };
 
 static inline struct ci_role_driver *ci_role(struct ci_hdrc *ci)
diff --git a/drivers/usb/chipidea/core.c b/drivers/usb/chipidea/core.c
index b6f2a41de20e..281fc51720ce 100644
--- a/drivers/usb/chipidea/core.c
+++ b/drivers/usb/chipidea/core.c
@@ -987,8 +987,12 @@ static ssize_t role_store(struct device *dev,
 	if (role == CI_ROLE_END)
 		return -EINVAL;
 
-	if (role == ci->role)
+	mutex_lock(&ci->mutex);
+
+	if (role == ci->role) {
+		mutex_unlock(&ci->mutex);
 		return n;
+	}
 
 	pm_runtime_get_sync(dev);
 	disable_irq(ci->irq);
@@ -998,6 +1002,7 @@ static ssize_t role_store(struct device *dev,
 		ci_handle_vbus_change(ci);
 	enable_irq(ci->irq);
 	pm_runtime_put_sync(dev);
+	mutex_unlock(&ci->mutex);
 
 	return (ret == 0) ? n : ret;
 }
@@ -1033,6 +1038,7 @@ static int ci_hdrc_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	spin_lock_init(&ci->lock);
+	mutex_init(&ci->mutex);
 	ci->dev = dev;
 	ci->platdata = dev_get_platdata(dev);
 	ci->imx28_write_fix = !!(ci->platdata->flags &
diff --git a/drivers/usb/chipidea/otg.c b/drivers/usb/chipidea/otg.c
index 622c3b68aa1e..f5490f2a5b6b 100644
--- a/drivers/usb/chipidea/otg.c
+++ b/drivers/usb/chipidea/otg.c
@@ -167,8 +167,10 @@ static int hw_wait_vbus_lower_bsv(struct ci_hdrc *ci)
 
 void ci_handle_id_switch(struct ci_hdrc *ci)
 {
-	enum ci_role role = ci_otg_role(ci);
+	enum ci_role role;
 
+	mutex_lock(&ci->mutex);
+	role = ci_otg_role(ci);
 	if (role != ci->role) {
 		dev_dbg(ci->dev, "switching from %s to %s\n",
 			ci_role(ci)->name, ci->roles[role]->name);
@@ -198,6 +200,7 @@ void ci_handle_id_switch(struct ci_hdrc *ci)
 		if (role == CI_ROLE_GADGET)
 			ci_handle_vbus_change(ci);
 	}
+	mutex_unlock(&ci->mutex);
 }
 /**
  * ci_otg_work - perform otg (vbus/id) event handle
-- 
2.40.0



