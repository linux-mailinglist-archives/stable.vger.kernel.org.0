Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5559F663722
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 03:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbjAJCQA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Jan 2023 21:16:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbjAJCP4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Jan 2023 21:15:56 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D33810EA
        for <stable@vger.kernel.org>; Mon,  9 Jan 2023 18:15:53 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-46eb8a5a713so111466557b3.1
        for <stable@vger.kernel.org>; Mon, 09 Jan 2023 18:15:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=IKw0nHewfyAcnobo9890ROV/gGIwiBDCIMT9U0Fts4o=;
        b=G1xR6AKcTXCuqCe/WpkaURQUMMo9N+steh6NueDOTfgV4+XkwHWE37rgGPopDug8S5
         soKU9yJvMTRonXsEK26iN5U8Wz2+9KvrnRp1yTSyoxBwr3xNXX1jJofOFOZRWnEeyFgT
         rZdL+NnWcbO4czexO0OJdVbHA9ufSNhefzhqiy5d/n+Djom71HdUU9xvS5ecAMUugpwN
         yfyJLcweGDfjgGJaYNDp7/BxrhgAu6RY2wWpDWVnR9dwQFoLgsH9GtrhGVzgj9uylt9G
         YwCgiuS0a4jO+20aUPYE2VW/0ZCJ1S8LFHCqQDxv7iyTLsJv1GaF45UCx8zgfPOd40Zu
         DxiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IKw0nHewfyAcnobo9890ROV/gGIwiBDCIMT9U0Fts4o=;
        b=BJDLJ81+SrltWADbS9dQbrh+z/yAXOQjEso+BCn+aEOg05TkU3KVIn5hJsKZy3gcrg
         9+pUH2o1izQvtWlzVHw0e0nQdaZR6Ismn+BOse8R96kdgCD+hu1Pl7NGTBDAgQ1MoNgp
         gPHPtnRC8DcsrqR+RjeoLLiSTsABvaSb3rCz814kx2lTt2o5eo6oQ/KhUzXog51OB95Z
         y0BPCUmavRmcdVqafPjeEMGvOpPGKDhvrrzh6Tae+Up+U/hr+HH/CErA90t42MiCFnlW
         APfRZjhnKrkitQzMehWxP5EW89Eq/1fAG7dacrzSt1IHb/S2MBgClqItkvTlc5pvvzV6
         Pvww==
X-Gm-Message-State: AFqh2krXJF4NudWwL9epYNfi7yuUnyb/lAl8qV1XGXsTgU4antSnZS6r
        ckNnbEkfttV/kexS7jmikvn92zEDkKwew+60cStLqg==
X-Google-Smtp-Source: AMrXdXvJ5CoYxQIPHJG2/AxrMkA6lDe+NURxnbNJQLBjRsRkvpcw9+qJgDURkx95PNDsjMjGB+P21cJ7nryjRzfGFTz9OQ==
X-Received: from isaacmanjarres.irv.corp.google.com ([2620:15c:2d:3:3990:5e50:b0f8:bcdd])
 (user=isaacmanjarres job=sendgmr) by 2002:a81:1441:0:b0:4bc:6c9c:bf9a with
 SMTP id 62-20020a811441000000b004bc6c9cbf9amr2865277ywu.255.1673316952380;
 Mon, 09 Jan 2023 18:15:52 -0800 (PST)
Date:   Mon,  9 Jan 2023 18:15:48 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230110021549.1347551-1-isaacmanjarres@google.com>
Subject: [PATCH stable-4.19] driver core: Fix bus_type.match() error handling
 in __driver_attach()
From:   "Isaac J. Manjarres" <isaacmanjarres@google.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Cc:     "Isaac J. Manjarres" <isaacmanjarres@google.com>,
        stable@vger.kernel.org, Saravana Kannan <saravanak@google.com>,
        kernel-team@android.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 27c0d217340e47ec995557f61423ef415afba987 upstream.

When a driver registers with a bus, it will attempt to match with every
device on the bus through the __driver_attach() function. Currently, if
the bus_type.match() function encounters an error that is not
-EPROBE_DEFER, __driver_attach() will return a negative error code, which
causes the driver registration logic to stop trying to match with the
remaining devices on the bus.

This behavior is not correct; a failure while matching a driver to a
device does not mean that the driver won't be able to match and bind
with other devices on the bus. Update the logic in __driver_attach()
to reflect this.

Fixes: 656b8035b0ee ("ARM: 8524/1: driver cohandle -EPROBE_DEFER from bus_type.match()")
Cc: stable@vger.kernel.org
Cc: Saravana Kannan <saravanak@google.com>
Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
---
 drivers/base/dd.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 63390a416b44..2dad29292487 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -902,8 +902,12 @@ static int __driver_attach(struct device *dev, void *data)
 		 */
 		return 0;
 	} else if (ret < 0) {
-		dev_dbg(dev, "Bus failed to match device: %d", ret);
-		return ret;
+		dev_dbg(dev, "Bus failed to match device: %d\n", ret);
+		/*
+		 * Driver could not match with device, but may match with
+		 * another device on the bus.
+		 */
+		return 0;
 	} /* ret > 0 means positive match */
 
 	if (dev->parent && dev->bus->need_parent_lock)
-- 
2.39.0.314.g84b9a713c41-goog

