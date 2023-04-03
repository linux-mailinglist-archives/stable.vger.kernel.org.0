Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 165656D46B0
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232681AbjDCOMn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:12:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232770AbjDCOMe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:12:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 489D02C9F2
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:12:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F04AFB81B2C
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:12:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53D5EC433EF;
        Mon,  3 Apr 2023 14:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531142;
        bh=093Ln/iEyLKR+YvR8754BBR390+vfJDo299p2kacPec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SSFJY0rGwE5lB2ZBQzgxZ1l7kp0sb9az6FHc63fbDyQQ9wqfkZdwP/goLq6mn+8aJ
         4u2TfmDge3SzhbwTHMXOnfVkfB/3VTgj4kE5Lr0AAvmO9KR4AIhSfSIeapArhwtfJT
         KkwRY+3iTY9ykhOv1E1+XJq0qndTC+3JAJa2L2ys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Peter Chen <peter.chen@kernel.org>,
        Xu Yang <xu.yang_2@nxp.com>
Subject: [PATCH 4.14 35/66] usb: chipidea: core: fix possible concurrent when switch role
Date:   Mon,  3 Apr 2023 16:08:43 +0200
Message-Id: <20230403140353.124956140@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140351.636471867@linuxfoundation.org>
References: <20230403140351.636471867@linuxfoundation.org>
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
 drivers/usb/chipidea/ci.h   |    2 ++
 drivers/usb/chipidea/core.c |    8 +++++++-
 drivers/usb/chipidea/otg.c  |    5 ++++-
 3 files changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/usb/chipidea/ci.h
+++ b/drivers/usb/chipidea/ci.h
@@ -205,6 +205,7 @@ struct hw_bank {
  * @in_lpm: if the core in low power mode
  * @wakeup_int: if wakeup interrupt occur
  * @rev: The revision number for controller
+ * @mutex: protect code from concorrent running when doing role switch
  */
 struct ci_hdrc {
 	struct device			*dev;
@@ -259,6 +260,7 @@ struct ci_hdrc {
 	bool				in_lpm;
 	bool				wakeup_int;
 	enum ci_revision		rev;
+	struct mutex                    mutex;
 };
 
 static inline struct ci_role_driver *ci_role(struct ci_hdrc *ci)
--- a/drivers/usb/chipidea/core.c
+++ b/drivers/usb/chipidea/core.c
@@ -878,8 +878,12 @@ static ssize_t ci_role_store(struct devi
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
@@ -889,6 +893,7 @@ static ssize_t ci_role_store(struct devi
 		ci_handle_vbus_change(ci);
 	enable_irq(ci->irq);
 	pm_runtime_put_sync(dev);
+	mutex_unlock(&ci->mutex);
 
 	return (ret == 0) ? n : ret;
 }
@@ -927,6 +932,7 @@ static int ci_hdrc_probe(struct platform
 		return -ENOMEM;
 
 	spin_lock_init(&ci->lock);
+	mutex_init(&ci->mutex);
 	ci->dev = dev;
 	ci->platdata = dev_get_platdata(dev);
 	ci->imx28_write_fix = !!(ci->platdata->flags &
--- a/drivers/usb/chipidea/otg.c
+++ b/drivers/usb/chipidea/otg.c
@@ -167,8 +167,10 @@ static int hw_wait_vbus_lower_bsv(struct
 
 static void ci_handle_id_switch(struct ci_hdrc *ci)
 {
-	enum ci_role role = ci_otg_role(ci);
+	enum ci_role role;
 
+	mutex_lock(&ci->mutex);
+	role = ci_otg_role(ci);
 	if (role != ci->role) {
 		dev_dbg(ci->dev, "switching from %s to %s\n",
 			ci_role(ci)->name, ci->roles[role]->name);
@@ -191,6 +193,7 @@ static void ci_handle_id_switch(struct c
 		if (role == CI_ROLE_GADGET)
 			ci_handle_vbus_change(ci);
 	}
+	mutex_unlock(&ci->mutex);
 }
 /**
  * ci_otg_work - perform otg (vbus/id) event handle


