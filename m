Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFA385054FD
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241357AbiDRNVy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243545AbiDRNUl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:20:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55B8E13FA4;
        Mon, 18 Apr 2022 05:52:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BFD0612B4;
        Mon, 18 Apr 2022 12:52:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 786E0C385A1;
        Mon, 18 Apr 2022 12:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286335;
        bh=1tiWxrqYPrAAaM/c/XVuoPXAq9gRwFSBq32ZwyucpU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sYnsZjlSOZntHXlLAqiw8wTM4/jYTWgisNdWCdXSsPf+f3nUSY+wBh8YGwCZn0yXH
         gYOE5P0XsP/4z8S7r2QIkJS1ZVLNN9mRjfbC/lSog5l8x+7HhsYkg4m55IBi9S9fdC
         ZFyORFYCfQ/aKhir/2fiX0oNcbKlGWnPq540+HmI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 102/284] HID: i2c-hid: fix GET/SET_REPORT for unnumbered reports
Date:   Mon, 18 Apr 2022 14:11:23 +0200
Message-Id: <20220418121213.731703841@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
References: <20220418121210.689577360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit a5e5e03e94764148a01757b2fa4737d3445c13a6 ]

Internally kernel prepends all report buffers, for both numbered and
unnumbered reports, with report ID, therefore to properly handle unnumbered
reports we should prepend it ourselves.

For the same reason we should skip the first byte of the buffer when
calling i2c_hid_set_or_send_report() which then will take care of properly
formatting the transfer buffer based on its separate report ID argument
along with report payload.

[jkosina@suse.cz: finalize trimmed sentence in changelog as spotted by Benjamin]
Fixes: 9b5a9ae88573 ("HID: i2c-hid: implement ll_driver transport-layer callbacks")
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Tested-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/i2c-hid/i2c-hid-core.c | 32 ++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
index b16bf4358485..9a070d65ed34 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -582,6 +582,17 @@ static int i2c_hid_get_raw_report(struct hid_device *hid,
 	if (report_type == HID_OUTPUT_REPORT)
 		return -EINVAL;
 
+	/*
+	 * In case of unnumbered reports the response from the device will
+	 * not have the report ID that the upper layers expect, so we need
+	 * to stash it the buffer ourselves and adjust the data size.
+	 */
+	if (!report_number) {
+		buf[0] = 0;
+		buf++;
+		count--;
+	}
+
 	/* +2 bytes to include the size of the reply in the query buffer */
 	ask_count = min(count + 2, (size_t)ihid->bufsize);
 
@@ -603,6 +614,9 @@ static int i2c_hid_get_raw_report(struct hid_device *hid,
 	count = min(count, ret_count - 2);
 	memcpy(buf, ihid->rawbuf + 2, count);
 
+	if (!report_number)
+		count++;
+
 	return count;
 }
 
@@ -619,17 +633,19 @@ static int i2c_hid_output_raw_report(struct hid_device *hid, __u8 *buf,
 
 	mutex_lock(&ihid->reset_lock);
 
-	if (report_id) {
-		buf++;
-		count--;
-	}
-
+	/*
+	 * Note that both numbered and unnumbered reports passed here
+	 * are supposed to have report ID stored in the 1st byte of the
+	 * buffer, so we strip it off unconditionally before passing payload
+	 * to i2c_hid_set_or_send_report which takes care of encoding
+	 * everything properly.
+	 */
 	ret = i2c_hid_set_or_send_report(client,
 				report_type == HID_FEATURE_REPORT ? 0x03 : 0x02,
-				report_id, buf, count, use_data);
+				report_id, buf + 1, count - 1, use_data);
 
-	if (report_id && ret >= 0)
-		ret++; /* add report_id to the number of transfered bytes */
+	if (ret >= 0)
+		ret++; /* add report_id to the number of transferred bytes */
 
 	mutex_unlock(&ihid->reset_lock);
 
-- 
2.34.1



