Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE0916A0972
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:06:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234308AbjBWNGE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:06:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234306AbjBWNGD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:06:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09D0256513
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 05:06:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA898616EB
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 13:06:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97642C433EF;
        Thu, 23 Feb 2023 13:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157559;
        bh=uq3agZOl51Ax+BE3TqjgYC7xSN1ZcH100dakCXoB3RQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0ta5vegp8J6t+IqVxoyXUo8F7fblmYMfx89ZQrqrm0NUX8VLlNo3/37HDE8doA0m7
         9+1ipkdQ9mXoQAB8FZi65pnPI/aIEhUmMiYRXA3ylTvIlYbwFpw6cLkVHXiX1O+BY+
         9pY+mkhB4fGrG3AdqPd1Ji4ELcP1Ml+JY2Xpnk0U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH 6.2 05/11] HID: mcp-2221: prevent UAF in delayed work
Date:   Thu, 23 Feb 2023 14:04:59 +0100
Message-Id: <20230223130426.400061350@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130426.170746546@linuxfoundation.org>
References: <20230223130426.170746546@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Tissoires <benjamin.tissoires@redhat.com>

commit 47e91fdfa511139f2549687edb0d8649b123227b upstream.

If the device is plugged/unplugged without giving time for mcp_init_work()
to complete, we might kick in the devm free code path and thus have
unavailable struct mcp_2221 while in delayed work.

Canceling the delayed_work item is enough to solve the issue, because
cancel_delayed_work_sync will prevent the work item to requeue itself.

Fixes: 960f9df7c620 ("HID: mcp2221: add ADC/DAC support via iio subsystem")
CC: stable@vger.kernel.org
Acked-by: Jiri Kosina <jkosina@suse.cz>
Link: https://lore.kernel.org/r/20230215-wip-mcp2221-v2-1-109f71fd036e@redhat.com
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-mcp2221.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-mcp2221.c
+++ b/drivers/hid/hid-mcp2221.c
@@ -922,6 +922,9 @@ static void mcp2221_hid_unregister(void
 /* This is needed to be sure hid_hw_stop() isn't called twice by the subsystem */
 static void mcp2221_remove(struct hid_device *hdev)
 {
+	struct mcp2221 *mcp = hid_get_drvdata(hdev);
+
+	cancel_delayed_work_sync(&mcp->init_work);
 }
 
 #if IS_REACHABLE(CONFIG_IIO)


