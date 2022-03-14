Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A71464D83F7
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:21:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241253AbiCNMW1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241773AbiCNMSX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:18:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E6A26427;
        Mon, 14 Mar 2022 05:12:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96702B80DE1;
        Mon, 14 Mar 2022 12:12:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 003EFC340E9;
        Mon, 14 Mar 2022 12:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259969;
        bh=t1emTD1hQqRTM2s+FLqtKL1MLVKlmYxN8zFn0YVOEuQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X+dLvZH5nPZd+jiOF9pbSBabUkIPO0+ne5yuxkqz0pZhYQ2EEbNjQssu1Q2OVn/v3
         x5thiqYLHJNLtm6dHiUf+Ji228KE9G/DhZ5W3iMwlWrPYqogJXk3gpAtnlLQP5zcHt
         /KyzqjqjlFQCQHEd7CBxRScBsgFoqZtHuxeIIYds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 003/121] HID: elo: Revert USB reference counting
Date:   Mon, 14 Mar 2022 12:53:06 +0100
Message-Id: <20220314112744.219863098@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112744.120491875@linuxfoundation.org>
References: <20220314112744.120491875@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

[ Upstream commit ac89895213d8950dba6ab342863a0959f73142a7 ]

Commit 817b8b9c539 ("HID: elo: fix memory leak in elo_probe") introduced
memory leak on error path, but more importantly the whole USB reference
counting is not needed at all in the first place, as the driver itself
doesn't change the reference counting in any way, and the associated
usb_device is guaranteed to be kept around by USB core as long as the
driver binding exists.

Reported-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: fbf42729d0e ("HID: elo: update the reference count of the usb device structure")
Fixes: 817b8b9c539 ("HID: elo: fix memory leak in elo_probe")
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-elo.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/hid/hid-elo.c b/drivers/hid/hid-elo.c
index 9b42b0cdeef0..2876cb6a7dca 100644
--- a/drivers/hid/hid-elo.c
+++ b/drivers/hid/hid-elo.c
@@ -228,7 +228,6 @@ static int elo_probe(struct hid_device *hdev, const struct hid_device_id *id)
 {
 	struct elo_priv *priv;
 	int ret;
-	struct usb_device *udev;
 
 	if (!hid_is_usb(hdev))
 		return -EINVAL;
@@ -238,8 +237,7 @@ static int elo_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		return -ENOMEM;
 
 	INIT_DELAYED_WORK(&priv->work, elo_work);
-	udev = interface_to_usbdev(to_usb_interface(hdev->dev.parent));
-	priv->usbdev = usb_get_dev(udev);
+	priv->usbdev = interface_to_usbdev(to_usb_interface(hdev->dev.parent));
 
 	hid_set_drvdata(hdev, priv);
 
@@ -262,7 +260,6 @@ static int elo_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 	return 0;
 err_free:
-	usb_put_dev(udev);
 	kfree(priv);
 	return ret;
 }
@@ -271,8 +268,6 @@ static void elo_remove(struct hid_device *hdev)
 {
 	struct elo_priv *priv = hid_get_drvdata(hdev);
 
-	usb_put_dev(priv->usbdev);
-
 	hid_hw_stop(hdev);
 	cancel_delayed_work_sync(&priv->work);
 	kfree(priv);
-- 
2.34.1



