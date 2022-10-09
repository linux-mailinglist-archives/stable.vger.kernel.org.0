Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D99425F94F8
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 02:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbiJJAOC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 20:14:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231327AbiJJAMx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 20:12:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D1CD56026;
        Sun,  9 Oct 2022 16:50:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B54660DC5;
        Sun,  9 Oct 2022 23:50:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1024C433C1;
        Sun,  9 Oct 2022 23:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665359448;
        bh=+bDLyobCzXL7wDQw/U6oi4YdNCx8flKdh8jVS9hCnO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b8OMWaHhc9egQsCP1hFHRtjOuyAudSqCnPZ28Z10w8Iya+ha5sjVPbYmW8lgGwixj
         s7P4a7mbBQJ3PDciaHm0qA+3n5jzfl1LjiMBMpvHr/6qQk2aOFBrSlp8nLOeLDgqMn
         SBGCwiYVy2GpjqD+RLAlyU/CS9niQavSj3H4+Q153IFkpxbjBrb5BiQHvAHWKLU/ku
         uFmzOqnPh9uLytNwXDAeYjhkifuejhe1M08h4/9UmFeUapKXsdtzsP5HqZoD7nYBaO
         BLjrJRgjH1bMZlbt3uY3H2iCqeqjB539ghN0iKSb4KAgWRM2nOSj1iOZNCRfGMbEB5
         L+Q+LpLpvbZWA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jameson Thies <jthies@google.com>,
        Prashant Malani <pmalani@chromium.org>,
        Benson Leung <bleung@chromium.org>,
        Tzung-Bi Shih <tzungbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        chrome-platform@lists.linux.dev
Subject: [PATCH AUTOSEL 6.0 22/44] platform/chrome: cros_ec: Notify the PM of wake events during resume
Date:   Sun,  9 Oct 2022 19:49:10 -0400
Message-Id: <20221009234932.1230196-22-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009234932.1230196-1-sashal@kernel.org>
References: <20221009234932.1230196-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jameson Thies <jthies@google.com>

[ Upstream commit 8edd2752b0aa498b3a61f3caee8f79f7e0567fad ]

cros_ec_handle_event in the cros_ec driver can notify the PM of wake
events. When a device is suspended, cros_ec_handle_event will not check
MKBP events. Instead, received MKBP events are checked during resume by
cros_ec_report_events_during_suspend. But
cros_ec_report_events_during_suspend cannot notify the PM if received
events are wake events, causing wake events to not be reported if
received while the device is suspended.

Update cros_ec_report_events_during_suspend to notify the PM of wake
events during resume by calling pm_wakeup_event.

Signed-off-by: Jameson Thies <jthies@google.com>
Reviewed-by: Prashant Malani <pmalani@chromium.org>
Reviewed-by: Benson Leung <bleung@chromium.org>
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Link: https://lore.kernel.org/r/20220913204954.2931042-1-jthies@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/cros_ec.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/chrome/cros_ec.c b/drivers/platform/chrome/cros_ec.c
index 8aace50d446d..110df0fd4b00 100644
--- a/drivers/platform/chrome/cros_ec.c
+++ b/drivers/platform/chrome/cros_ec.c
@@ -349,10 +349,16 @@ EXPORT_SYMBOL(cros_ec_suspend);
 
 static void cros_ec_report_events_during_suspend(struct cros_ec_device *ec_dev)
 {
+	bool wake_event;
+
 	while (ec_dev->mkbp_event_supported &&
-	       cros_ec_get_next_event(ec_dev, NULL, NULL) > 0)
+	       cros_ec_get_next_event(ec_dev, &wake_event, NULL) > 0) {
 		blocking_notifier_call_chain(&ec_dev->event_notifier,
 					     1, ec_dev);
+
+		if (wake_event && device_may_wakeup(ec_dev->dev))
+			pm_wakeup_event(ec_dev->dev, 0);
+	}
 }
 
 /**
-- 
2.35.1

