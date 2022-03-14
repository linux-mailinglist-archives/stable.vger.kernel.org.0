Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F74E4D830B
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:11:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240792AbiCNMMO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:12:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241622AbiCNMI6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:08:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F26C04F9DC;
        Mon, 14 Mar 2022 05:05:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53381B80DF0;
        Mon, 14 Mar 2022 12:05:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0C80C340E9;
        Mon, 14 Mar 2022 12:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259537;
        bh=t1emTD1hQqRTM2s+FLqtKL1MLVKlmYxN8zFn0YVOEuQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n63v3IE53q0r5/xA5zPa6ZtjoHA0NSnP7PzzrQjbq6ANM6FXW4IkRrpam0VXauEH7
         WsawqQ7AK5E/VeegM+iyLoXANqwUG7JSE3woNkiO8xczff3xShax6d4ykH+ObJL64B
         PXOCaSoGJeCl//yh/MaKUm24W0fv6cppv0UDD1PA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 003/110] HID: elo: Revert USB reference counting
Date:   Mon, 14 Mar 2022 12:53:05 +0100
Message-Id: <20220314112743.127452645@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112743.029192918@linuxfoundation.org>
References: <20220314112743.029192918@linuxfoundation.org>
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



