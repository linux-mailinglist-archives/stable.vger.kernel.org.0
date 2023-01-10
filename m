Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCE2C663724
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 03:16:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235173AbjAJCQS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Jan 2023 21:16:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbjAJCQF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Jan 2023 21:16:05 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 837A72AE3
        for <stable@vger.kernel.org>; Mon,  9 Jan 2023 18:16:04 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id w185-20020a6382c2000000b004b1fcf39c18so2384786pgd.13
        for <stable@vger.kernel.org>; Mon, 09 Jan 2023 18:16:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hjXN6DlW5iWocpPXZO+YPpO8vV9IgMx2qXzGmBcXsCg=;
        b=DEwdhVDHUdVd2gaW1yVVDmxnQhNt0LgwpdUIo/mB17X1bFsb99NQ8I4o5mUo2nr6TJ
         TCJ2IyN5drejBzobQh9kEgnmWQ50FIhb3k16p5PcJFaS3KTF/OaKB5im/Xv/jx8LZhYs
         ryWk3sV5hlY/BRjZV9rn9K2KnrvHiddiIvW10pzxFD+5Wl8Yvy2uwwEAbYdnXTBms4nd
         3UZWW82Uddo38dfD5AYE9ctJ+5MLLu6QL0ze/VAod6NYtdS8vaIrfmeYELBdFVQpA3k/
         d2WAUb4kbbsDOq2f5fBQ598+BmoHmIsxu6kLV0xdLdxcbOH13tdLH+/y1FROdDoI32Ph
         I/7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hjXN6DlW5iWocpPXZO+YPpO8vV9IgMx2qXzGmBcXsCg=;
        b=Ft3THI925jhT/UVLwpirrgT49K3A7DQOT+7arBLUcWrQaPfpICrj9fBL6gg7oDlSm9
         fmDEBMA23TVzm2lwypyqpVlyv32HP9T8583qHRj7WxV9yuFiMLCv0zjTuwuIgPKiarB1
         14+OSlFTYRoMg2jEELXJH4ICSb5VOWN/rqmOhI1HUBzCp1okZD9Ng5lSHV1pX9EUv7m7
         3LDxyn7zopODbL9mlsFbr6Bq6hhZqx3OIPN07ORgZ8aeUVoYkggoj3+zsFnmkOgxgxqJ
         sZWtwmMxqhTiOBWCMgBRzHSvRoXe0IMP3C+OzIH0I16v7gPTyHDHVtXtAuk9h1v0eq40
         Lnrw==
X-Gm-Message-State: AFqh2krIN5Ysp7NnG0h74E0IhlAziFCyrTY26Fyir8Q82Nue0Phu7VI5
        Nd//JWn86wDx5PEzH+T2Mtuhc9uvbSEz89Qseg6k7g==
X-Google-Smtp-Source: AMrXdXtyMvyOu+BcEar/61cbq0gpLj5K4zQEguINa/upU9HngVQ77pkh44I6KjUE7AKPvMmnQx3un2VfzYQvW8nVIyInag==
X-Received: from isaacmanjarres.irv.corp.google.com ([2620:15c:2d:3:3990:5e50:b0f8:bcdd])
 (user=isaacmanjarres job=sendgmr) by 2002:a62:4e97:0:b0:582:fa00:3c30 with
 SMTP id c145-20020a624e97000000b00582fa003c30mr1726478pfb.17.1673316963899;
 Mon, 09 Jan 2023 18:16:03 -0800 (PST)
Date:   Mon,  9 Jan 2023 18:16:00 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230110021600.1347946-1-isaacmanjarres@google.com>
Subject: [PATCH stable-5.4] driver core: Fix bus_type.match() error handling
 in __driver_attach()
From:   "Isaac J. Manjarres" <isaacmanjarres@google.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>
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
index 10063d8a1b7d..1abd39ed3f9f 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -1068,8 +1068,12 @@ static int __driver_attach(struct device *dev, void *data)
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
 
 	if (driver_allows_async_probing(drv)) {
-- 
2.39.0.314.g84b9a713c41-goog

