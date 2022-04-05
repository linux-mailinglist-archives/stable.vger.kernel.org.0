Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1328C4F2B5A
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237114AbiDEJD4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:03:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236218AbiDEIQk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:16:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA476E57D;
        Tue,  5 Apr 2022 01:03:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BAEF6B81BB3;
        Tue,  5 Apr 2022 08:03:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18A7AC385A0;
        Tue,  5 Apr 2022 08:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145825;
        bh=jLruKmILlgbBgaSZn6Gfot+4tRiKmAdDXmu2BVM3Du4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=anape+oc2IqCWme6OWL/UZie8XanyIXa+vRfE9H7xLDyXs3CCDpsFpONBNRRSZ1s5
         p/9OaK82zJuxG16fuV125cuOBcwZZVdXabXLk4w665Otg0zn20+Im2qX/uMq5q+AzZ
         640803Ut1JLSmferXbWMLh3pLlTqEqm2eOHYEFcY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0542/1126] HID: i2c-hid: fix GET/SET_REPORT for unnumbered reports
Date:   Tue,  5 Apr 2022 09:21:29 +0200
Message-Id: <20220405070423.541532287@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 6726567d7297..8d6fc50dab65 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -618,6 +618,17 @@ static int i2c_hid_get_raw_report(struct hid_device *hid,
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
 
@@ -639,6 +650,9 @@ static int i2c_hid_get_raw_report(struct hid_device *hid,
 	count = min(count, ret_count - 2);
 	memcpy(buf, ihid->rawbuf + 2, count);
 
+	if (!report_number)
+		count++;
+
 	return count;
 }
 
@@ -655,17 +669,19 @@ static int i2c_hid_output_raw_report(struct hid_device *hid, __u8 *buf,
 
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



