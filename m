Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2E87499B35
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:00:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1574819AbiAXVu1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:50:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457340AbiAXVlb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:41:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73391C0419D3;
        Mon, 24 Jan 2022 12:28:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F560B81239;
        Mon, 24 Jan 2022 20:28:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 828C0C340E5;
        Mon, 24 Jan 2022 20:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056081;
        bh=jbqkzaLPuG7F9MJqasxivM+Wt50FAHFkrTX3lFvAvtw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aiuDda5KXWRc2pZbL6dRHuhF8U9oVJWodm5D8cN8Wm+0cTQEHXjyIBTyZVNi1cIL/
         /rxAqlDXJ3JGg/oKvTXxDoCCNTD2d+iQO++Wdvu3wuAehE4APuxPS37AmYQdtc2oN8
         Zii6YV0irPCZNfDGFBWowNI4+ZKDxhZTugaFPnlc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 331/846] HID: hid-uclogic-params: Invalid parameter check in uclogic_params_frame_init_v1_buttonpad
Date:   Mon, 24 Jan 2022 19:37:28 +0100
Message-Id: <20220124184112.325119198@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: José Expósito <jose.exposito89@gmail.com>

[ Upstream commit aa320fdbbbb482c19100f51461bd0069753ce3d7 ]

The function performs a check on the hdev input parameters, however, it
is used before the check.

Initialize the udev variable after the sanity check to avoid a
possible NULL pointer dereference.

Fixes: 9614219e9310e ("HID: uclogic: Extract tablet parameter discovery into a module")
Addresses-Coverity-ID: 1443763 ("Null pointer dereference")
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-uclogic-params.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-uclogic-params.c b/drivers/hid/hid-uclogic-params.c
index 4136837e4d158..3e70f969fb849 100644
--- a/drivers/hid/hid-uclogic-params.c
+++ b/drivers/hid/hid-uclogic-params.c
@@ -452,7 +452,7 @@ static int uclogic_params_frame_init_v1_buttonpad(
 {
 	int rc;
 	bool found = false;
-	struct usb_device *usb_dev = hid_to_usb_dev(hdev);
+	struct usb_device *usb_dev;
 	char *str_buf = NULL;
 	const size_t str_len = 16;
 
@@ -462,6 +462,8 @@ static int uclogic_params_frame_init_v1_buttonpad(
 		goto cleanup;
 	}
 
+	usb_dev = hid_to_usb_dev(hdev);
+
 	/*
 	 * Enable generic button mode
 	 */
-- 
2.34.1



