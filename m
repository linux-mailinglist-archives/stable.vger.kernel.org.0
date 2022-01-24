Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73E5E498D7A
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353051AbiAXTcf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:32:35 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57134 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352185AbiAXT3t (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:29:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96CEA6121F;
        Mon, 24 Jan 2022 19:29:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BC21C340E5;
        Mon, 24 Jan 2022 19:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052587;
        bh=/VPIGVCi6Rg+PZ+mSK3jbNzMWjhnDYX74Ty8HuWxxy0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jY3AImKH2uiS5AriRHJkGLj7fpjOlpAipEUyvy3lg1ShZ088Bfs/oHqhB0gvXUtLj
         iQwTZXPjmdghWPxRZWFiG7uJlXtZV+4OXu4YpNovgBniWqdcobesnCP6ZfpHbqUreG
         0Vsv7gk9Bwf9NkHatGwV7MN8inru+7y8jDzTlYh8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 109/320] HID: hid-uclogic-params: Invalid parameter check in uclogic_params_get_str_desc
Date:   Mon, 24 Jan 2022 19:41:33 +0100
Message-Id: <20220124183957.423180733@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: José Expósito <jose.exposito89@gmail.com>

[ Upstream commit 0a94131d6920916ccb6a357037c535533af08819 ]

The function performs a check on the hdev input parameters, however, it
is used before the check.

Initialize the udev variable after the sanity check to avoid a
possible NULL pointer dereference.

Fixes: 9614219e9310e ("HID: uclogic: Extract tablet parameter discovery into a module")
Addresses-Coverity-ID: 1443827 ("Null pointer dereference")
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-uclogic-params.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-uclogic-params.c b/drivers/hid/hid-uclogic-params.c
index 0afd368115891..1f3ea6c93ef44 100644
--- a/drivers/hid/hid-uclogic-params.c
+++ b/drivers/hid/hid-uclogic-params.c
@@ -65,7 +65,7 @@ static int uclogic_params_get_str_desc(__u8 **pbuf, struct hid_device *hdev,
 					__u8 idx, size_t len)
 {
 	int rc;
-	struct usb_device *udev = hid_to_usb_dev(hdev);
+	struct usb_device *udev;
 	__u8 *buf = NULL;
 
 	/* Check arguments */
@@ -74,6 +74,8 @@ static int uclogic_params_get_str_desc(__u8 **pbuf, struct hid_device *hdev,
 		goto cleanup;
 	}
 
+	udev = hid_to_usb_dev(hdev);
+
 	buf = kmalloc(len, GFP_KERNEL);
 	if (buf == NULL) {
 		rc = -ENOMEM;
-- 
2.34.1



