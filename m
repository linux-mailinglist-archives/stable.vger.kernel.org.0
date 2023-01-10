Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 140E6663720
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 03:15:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbjAJCPp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Jan 2023 21:15:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbjAJCPo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Jan 2023 21:15:44 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19FE6249
        for <stable@vger.kernel.org>; Mon,  9 Jan 2023 18:15:43 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-4bdeb1bbeafso111572587b3.4
        for <stable@vger.kernel.org>; Mon, 09 Jan 2023 18:15:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=42F60C+bhrH6FdlXo69kMxONv+FtXk0R9aSJOqnDb3o=;
        b=D65TIw1r6/vVcii8yneiRVwuv4HZR7dZ0GpJ47tt0fzrGJkkfTfRnR+aKQxXYKVfY3
         lGyKgWYx6ODAo63+LfGbxhQzK21/e2099zJg1UycyZZ8CzcGGLWWAmLcR3nAA2wzYJ/O
         i5Rjxp2ZPHJKd3gPkeNJiCYZyNLNPtfxAre166fc1woXsLjGGDjl8hhO5UgSEzBL0Uku
         +i+6aA4Hjaf4j7g5dmS2Qma8wJrqsVGjqf8LZ3ucM8pyL/hs4rA85EpFxb25zta5tE5a
         AEOXb8eJsmFvyhfAgTjdC8cAmDYoyvOgcF5fROp2/QTwLC13ZOAr52GME259uRIuVq62
         b0NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=42F60C+bhrH6FdlXo69kMxONv+FtXk0R9aSJOqnDb3o=;
        b=Bcw739qaHicD8pB95hcjySGK0WOl7GPMbcFY5y3jWGDw56HG4i69mRbbp/ipYXbkDB
         enecDE1Snq66nC/oYvMigoXc8OXrlRFQZSU4DVT61PZdoQEIGA9ETEgbyBK9AW5ga8XG
         W+qmmblSXHw2elKKWgAQNe7j8b06w+MJ2VTsOBbNBa4vOrpv57vZTmbdDFitaefhvM5O
         MKJGQeZkT1QKcKg1Sb0hYO1mBZrNdiEN0HF/WbE6haMN9Wt0YAhJdRydwh1GJFHJFFM8
         Bvju5qqYGqvZE/+cJ0ghxuGVyPtV7Vu/QPAfFlj1u5onO5Jm2xRxd9vAJdoqgkIWUt0p
         irDg==
X-Gm-Message-State: AFqh2kq4Zqtw4tHPF+CAgeZS5LeUBMaABVJLi19/fzOXPlKClgCEm1F1
        Bc3lZnCTildYNnYWaU/w3sjl+1GGTeCLsqSJ4eNWhw==
X-Google-Smtp-Source: AMrXdXsPot540It71PJmlWz/rhfw/FchQBUvtGk7/X2jq0XCIHntTag/Zn0MjrHA9Rrc4oCSfFEKrTh3zvTti9q/VUivKA==
X-Received: from isaacmanjarres.irv.corp.google.com ([2620:15c:2d:3:3990:5e50:b0f8:bcdd])
 (user=isaacmanjarres job=sendgmr) by 2002:a25:ad85:0:b0:7c0:10d2:437 with
 SMTP id z5-20020a25ad85000000b007c010d20437mr141966ybi.330.1673316942398;
 Mon, 09 Jan 2023 18:15:42 -0800 (PST)
Date:   Mon,  9 Jan 2023 18:15:36 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230110021536.1347134-1-isaacmanjarres@google.com>
Subject: [PATCH stable-4.14] driver core: Fix bus_type.match() error handling
 in __driver_attach()
From:   "Isaac J. Manjarres" <isaacmanjarres@google.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>
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
index a7bcbb99e820..0f006cad2be7 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -785,8 +785,12 @@ static int __driver_attach(struct device *dev, void *data)
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
 
 	if (dev->parent)	/* Needed for USB */
-- 
2.39.0.314.g84b9a713c41-goog

