Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA9002EC6E
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732335AbfE3DUs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:20:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:59968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732325AbfE3DUr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:20:47 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77BDD24953;
        Thu, 30 May 2019 03:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186446;
        bh=8ZGw+O+lYMpOk7M7BplUdAuuAL/k6VhQ0Oqhxramy5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JNOpOiBSotfv6WGs5VJjNShgGTrygSApKPI9s5DMKy6mI8RRdSlmIIXL207H0R+BY
         SjqmPDOu7P6F+n4a6jgOiIHyjFD6kRoCoHY2+7lr9nstWalKVkl1B7ul47AWTxM2h+
         QASSmQJSroTAQYF6GXkShrroUmMc5yhGTFu4Zkzw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 054/128] HID: logitech-hidpp: use RAP instead of FAP to get the protocol version
Date:   Wed, 29 May 2019 20:06:26 -0700
Message-Id: <20190530030444.717362972@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030432.977908967@linuxfoundation.org>
References: <20190530030432.977908967@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 096377525cdb8251e4656085efc988bdf733fb4c ]

According to the logitech_hidpp_2.0_specification_draft_2012-06-04.pdf doc:
https://lekensteyn.nl/files/logitech/logitech_hidpp_2.0_specification_draft_2012-06-04.pdf

We should use a register-access-protocol request using the short input /
output report ids. This is necessary because 27MHz HID++ receivers have
a max-packetsize on their HIP++ endpoint of 8, so they cannot support
long reports. Using a feature-access-protocol request (which is always
long or very-long) with these will cause a timeout error, followed by
the hidpp driver treating the device as not being HID++ capable.

This commit fixes this by switching to using a rap request to get the
protocol version.

Besides being tested with a (046d:c517) 27MHz receiver with various
27MHz keyboards and mice, this has also been tested to not cause
regressions on a non-unifying dual-HID++ nano receiver (046d:c534) with
k270 and m185 HID++-2.0 devices connected and on a unifying/dj receiver
(046d:c52b) with a HID++-2.0 Logitech Rechargeable Touchpad T650.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-hidpp.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index 3198faf5cff4d..38d9deb03d16c 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -449,13 +449,16 @@ static int hidpp_root_get_feature(struct hidpp_device *hidpp, u16 feature,
 
 static int hidpp_root_get_protocol_version(struct hidpp_device *hidpp)
 {
+	const u8 ping_byte = 0x5a;
+	u8 ping_data[3] = { 0, 0, ping_byte };
 	struct hidpp_report response;
 	int ret;
 
-	ret = hidpp_send_fap_command_sync(hidpp,
+	ret = hidpp_send_rap_command_sync(hidpp,
+			REPORT_ID_HIDPP_SHORT,
 			HIDPP_PAGE_ROOT_IDX,
 			CMD_ROOT_GET_PROTOCOL_VERSION,
-			NULL, 0, &response);
+			ping_data, sizeof(ping_data), &response);
 
 	if (ret == HIDPP_ERROR_INVALID_SUBID) {
 		hidpp->protocol_major = 1;
@@ -475,8 +478,14 @@ static int hidpp_root_get_protocol_version(struct hidpp_device *hidpp)
 	if (ret)
 		return ret;
 
-	hidpp->protocol_major = response.fap.params[0];
-	hidpp->protocol_minor = response.fap.params[1];
+	if (response.rap.params[2] != ping_byte) {
+		hid_err(hidpp->hid_dev, "%s: ping mismatch 0x%02x != 0x%02x\n",
+			__func__, response.rap.params[2], ping_byte);
+		return -EPROTO;
+	}
+
+	hidpp->protocol_major = response.rap.params[0];
+	hidpp->protocol_minor = response.rap.params[1];
 
 	return ret;
 }
-- 
2.20.1



