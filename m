Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC5A4997E9
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378438AbiAXVRZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:17:25 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34150 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388853AbiAXVM7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:12:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B8EFB80FA3;
        Mon, 24 Jan 2022 21:12:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80F82C340EB;
        Mon, 24 Jan 2022 21:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058772;
        bh=jbqkzaLPuG7F9MJqasxivM+Wt50FAHFkrTX3lFvAvtw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0d0DaJOjH6SnSutFUe4AIw/GpBqYfPgbtv23ZyQrfO45qQSUZGaDZ/futrtcVUG4n
         ZBZmE5px7QYqrvsZ6bkdWyBT1/C934+eTfPsZL0RE+cgNY4C7EktvK6/FLxJIcXuzl
         bB9JQaGSYS5ppRnhesXFc57tJGCcGHFPBi7hC750=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0397/1039] HID: hid-uclogic-params: Invalid parameter check in uclogic_params_frame_init_v1_buttonpad
Date:   Mon, 24 Jan 2022 19:36:26 +0100
Message-Id: <20220124184138.662439112@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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



