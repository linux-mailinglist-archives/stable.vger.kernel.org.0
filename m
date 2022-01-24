Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1521D498D7C
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:34:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352120AbiAXTch (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:32:37 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57208 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352209AbiAXT3x (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:29:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F3E1614BB;
        Mon, 24 Jan 2022 19:29:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2019DC340E7;
        Mon, 24 Jan 2022 19:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052592;
        bh=y4gopLlU9cEaDX+IdBrDk0YyHq4orGkuszg4cJuHrPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iC9z/snKrDgtDIrH7t7hUxIPeIgV2U8ahUVCP89JcnAEKNYngE382iSZNQdH64D3i
         j7Zjp0NYoXi97dBCbc383JAMYnqsXJ6+NfJuisNL0rxLIwgrWUhWPGrwdVs2r7L5RU
         SYxmRe6YpJUijhGlpcVc6OPR8Rp42gtlXqDc89NA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 111/320] HID: hid-uclogic-params: Invalid parameter check in uclogic_params_frame_init_v1_buttonpad
Date:   Mon, 24 Jan 2022 19:41:35 +0100
Message-Id: <20220124183957.494825008@linuxfoundation.org>
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
index 0fdac91c5f510..191aba9f6b497 100644
--- a/drivers/hid/hid-uclogic-params.c
+++ b/drivers/hid/hid-uclogic-params.c
@@ -451,7 +451,7 @@ static int uclogic_params_frame_init_v1_buttonpad(
 {
 	int rc;
 	bool found = false;
-	struct usb_device *usb_dev = hid_to_usb_dev(hdev);
+	struct usb_device *usb_dev;
 	char *str_buf = NULL;
 	const size_t str_len = 16;
 
@@ -461,6 +461,8 @@ static int uclogic_params_frame_init_v1_buttonpad(
 		goto cleanup;
 	}
 
+	usb_dev = hid_to_usb_dev(hdev);
+
 	/*
 	 * Enable generic button mode
 	 */
-- 
2.34.1



