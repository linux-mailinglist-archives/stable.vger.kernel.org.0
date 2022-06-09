Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFF635456B8
	for <lists+stable@lfdr.de>; Thu,  9 Jun 2022 23:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234901AbiFIVtj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jun 2022 17:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233015AbiFIVti (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jun 2022 17:49:38 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D96715FE22;
        Thu,  9 Jun 2022 14:49:34 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id cx11so22485800pjb.1;
        Thu, 09 Jun 2022 14:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OqWT2+rs9ONxjJPi5zpOEh7NoBzb3sfwmxsPGIJo9Ek=;
        b=dsNmKyR8/Kn0lBpff4o8kscF+y8WEiWN7qe/Y1QdBUJkfYtqt9MwF9mcGg/YCgljwa
         Y3SdusFY+q8XzxCr8RqDXlvJTlUHQtKc+6pfXDQ0LrtZlWo6g0p7DOTE6DLJ3sS1KQPY
         9psnnZQhQDcBWdHh75S18SvB8u5U3JE2uaK7YrVYXfhByAjQn8xrajALooQWiPCqJwPm
         w5q6oLhJMERM7qj0N535LyCyA9AhynzGurpljaNmg5kP+u2fy8Vyur1k+9THF1UDR6CW
         ZkOSEkVTKYk3w3wMQeIIrawX5qwuUSuX2ft0sqqcLgUp/UZSrFrw8P53wav6PHnR4tDO
         x5mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OqWT2+rs9ONxjJPi5zpOEh7NoBzb3sfwmxsPGIJo9Ek=;
        b=l2g40xUDQih8ubgGAMMhYiE9JtdR9kP6yF72quyjqm+5BsNbLh2jk682JbaX+h09pB
         QRufItF2YhT6IsffiB0b/pGdl549TX59bPCLnneIIC4HQJHmdSkerFJzzzgYo01wA/h3
         tl0Ijl+Ya4SwtdTGVUjjOEuUx9aTG4VnaG4uDWe1oDQTYEC71i+iwjKuawQcVdeYa4zA
         zcf510U6ExYj0zyjtUBWS6h9G19fEekJhV8QBi/RkTVnhYusLgWNopmq+tJDy/qpZO7T
         T22Zx49Zv9c4advvM2yvkPv8c9Cs/gG7XW2uHnA05xa0UezuW52Qv3oIEl+9nZTI2Lfw
         KJXQ==
X-Gm-Message-State: AOAM531cDxka46qDq3zzM1fBMzBoUwYvMNJq/HLaXm0LGnKM3ar3dTgN
        fPt1CvzWQGhW5N9U/FpeMCc=
X-Google-Smtp-Source: ABdhPJzKuHA3e++qD1J1+2gtrORg9rwJEIfmEkbuCyqSWM3iMvjL2retYMovMhZIVD9PM2dlK7/jTQ==
X-Received: by 2002:a17:902:854c:b0:163:7dd2:130f with SMTP id d12-20020a170902854c00b001637dd2130fmr41678602plo.57.1654811373949;
        Thu, 09 Jun 2022 14:49:33 -0700 (PDT)
Received: from fedora.hsd1.wa.comcast.net ([2601:1c1:4202:28a0::ec2b])
        by smtp.gmail.com with ESMTPSA id q65-20020a17090a4fc700b001e8520b211bsm152669pjh.53.2022.06.09.14.49.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 14:49:33 -0700 (PDT)
From:   Jared Kangas <kangas.jd@gmail.com>
To:     vaibhav.sr@gmail.com
Cc:     elder@kernel.org, gregkh@linuxfoundation.org,
        greybus-dev@lists.linaro.org, johan@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-staging@lists.linux.dev, mgreer@animalcreek.com,
        kangas.jd@gmail.com, Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH v2] staging: greybus: audio: fix loop cursor use after iteration
Date:   Thu,  9 Jun 2022 14:45:18 -0700
Message-Id: <20220609214517.85661-1-kangas.jd@gmail.com>
X-Mailer: git-send-email 2.34.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

gbaudio_dapm_free_controls() iterates over widgets using the
list_for_each_entry*() family of macros from <linux/list.h>, which
leaves the loop cursor pointing to a meaningless structure if it
completes a traversal of the list. The cursor was set to NULL at the end
of the loop body, but would be overwritten by the final loop cursor
update.

Because of this behavior, the widget could be non-null after the loop
even if the widget wasn't found, and the cleanup logic would treat the
pointer as a valid widget to free.

To fix this, introduce a temporary variable to act as the loop cursor
and copy it to a variable that can be accessed after the loop finishes.
Due to not removing any list elements, use list_for_each_entry() instead
of list_for_each_entry_safe() in the revised loop.

This was detected with the help of Coccinelle.

Fixes: 510e340efe0c ("staging: greybus: audio: Add helper APIs for dynamic audio modules")
Cc: stable@vger.kernel.org
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Jared Kangas <kangas.jd@gmail.com>
---

Changes since v1:
 * Removed safe list iteration as suggested by Johan Hovold <johan@kernel.org>
 * Updated patch changelog to explain the list iteration change
 * Added tags to changelog based on feedback (Cc:, Fixes:, Reviewed-by:)

 drivers/staging/greybus/audio_helper.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/greybus/audio_helper.c b/drivers/staging/greybus/audio_helper.c
index 843760675876..05e91e6bc2a0 100644
--- a/drivers/staging/greybus/audio_helper.c
+++ b/drivers/staging/greybus/audio_helper.c
@@ -115,7 +115,7 @@ int gbaudio_dapm_free_controls(struct snd_soc_dapm_context *dapm,
 			       int num)
 {
 	int i;
-	struct snd_soc_dapm_widget *w, *next_w;
+	struct snd_soc_dapm_widget *w, *tmp_w;
 #ifdef CONFIG_DEBUG_FS
 	struct dentry *parent = dapm->debugfs_dapm;
 	struct dentry *debugfs_w = NULL;
@@ -124,13 +124,13 @@ int gbaudio_dapm_free_controls(struct snd_soc_dapm_context *dapm,
 	mutex_lock(&dapm->card->dapm_mutex);
 	for (i = 0; i < num; i++) {
 		/* below logic can be optimized to identify widget pointer */
-		list_for_each_entry_safe(w, next_w, &dapm->card->widgets,
-					 list) {
-			if (w->dapm != dapm)
-				continue;
-			if (!strcmp(w->name, widget->name))
+		w = NULL;
+		list_for_each_entry(tmp_w, &dapm->card->widgets, list) {
+			if (tmp_w->dapm == dapm &&
+			    !strcmp(tmp_w->name, widget->name)) {
+				w = tmp_w;
 				break;
-			w = NULL;
+			}
 		}
 		if (!w) {
 			dev_err(dapm->dev, "%s: widget not found\n",
-- 
2.34.3

