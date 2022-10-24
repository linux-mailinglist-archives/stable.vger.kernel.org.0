Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA8B660A4E2
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233102AbiJXMSL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:18:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233108AbiJXMQS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:16:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51F6A7AC36;
        Mon, 24 Oct 2022 04:56:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A802C612D3;
        Mon, 24 Oct 2022 11:56:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9254C433D6;
        Mon, 24 Oct 2022 11:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612598;
        bh=t+BBSIhts49B2P3FN9Z48QUqlQMj20aVsD3IeoAmpEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QGdnJzN2VxvAPRXu+cc8W7PUebo+W5L3mvQTtjvJn7qHp5a/2XiRoukl7hGmaWxEx
         iZQfCZ3ovOdCjC6z7dy5FrPjWaPkhPhMOGTvULvz6RWJuyNlc7e7a5zTcYs6Bo+gom
         TOLmDcLZwgeqfyNFQmNOfAMY4VxCBXfQxlI6c7AU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andri Yngvason <andri@yngvason.is>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH 4.19 046/229] HID: multitouch: Add memory barriers
Date:   Mon, 24 Oct 2022 13:29:25 +0200
Message-Id: <20221024113000.581586783@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112959.085534368@linuxfoundation.org>
References: <20221024112959.085534368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andri Yngvason <andri@yngvason.is>

commit be6e2b5734a425941fcdcdbd2a9337be498ce2cf upstream.

This fixes broken atomic checks which cause a race between the
release-timer and processing of hid input.

I noticed that contacts were sometimes sticking, even with the "sticky
fingers" quirk enabled. This fixes that problem.

Cc: stable@vger.kernel.org
Fixes: 9609827458c3 ("HID: multitouch: optimize the sticky fingers timer")
Signed-off-by: Andri Yngvason <andri@yngvason.is>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Link: https://lore.kernel.org/r/20220907150159.2285460-1-andri@yngvason.is
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-multitouch.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1154,7 +1154,7 @@ static void mt_touch_report(struct hid_d
 	int contact_count = -1;
 
 	/* sticky fingers release in progress, abort */
-	if (test_and_set_bit(MT_IO_FLAGS_RUNNING, &td->mt_io_flags))
+	if (test_and_set_bit_lock(MT_IO_FLAGS_RUNNING, &td->mt_io_flags))
 		return;
 
 	scantime = *app->scantime;
@@ -1235,7 +1235,7 @@ static void mt_touch_report(struct hid_d
 			del_timer(&td->release_timer);
 	}
 
-	clear_bit(MT_IO_FLAGS_RUNNING, &td->mt_io_flags);
+	clear_bit_unlock(MT_IO_FLAGS_RUNNING, &td->mt_io_flags);
 }
 
 static int mt_touch_input_configured(struct hid_device *hdev,
@@ -1672,11 +1672,11 @@ static void mt_expired_timeout(struct ti
 	 * An input report came in just before we release the sticky fingers,
 	 * it will take care of the sticky fingers.
 	 */
-	if (test_and_set_bit(MT_IO_FLAGS_RUNNING, &td->mt_io_flags))
+	if (test_and_set_bit_lock(MT_IO_FLAGS_RUNNING, &td->mt_io_flags))
 		return;
 	if (test_bit(MT_IO_FLAGS_PENDING_SLOTS, &td->mt_io_flags))
 		mt_release_contacts(hdev);
-	clear_bit(MT_IO_FLAGS_RUNNING, &td->mt_io_flags);
+	clear_bit_unlock(MT_IO_FLAGS_RUNNING, &td->mt_io_flags);
 }
 
 static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)


