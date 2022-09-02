Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 496A05AB04F
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237912AbiIBMwN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:52:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237835AbiIBMvV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:51:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A92002CDDC;
        Fri,  2 Sep 2022 05:37:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D1E8B82AD7;
        Fri,  2 Sep 2022 12:35:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECA30C433D6;
        Fri,  2 Sep 2022 12:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662122151;
        bh=Bs2CQBsnUjpIZ+XxHHFSiRhfkB928kkGSKMck2e8gws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nFipbIvLdvWGNnFudSU0aS7GUedmCQyE3XwtX7MhLuPX7gYNSGY08Dc4wo1+PnpKe
         bMEeIZacatV/jzUhMnqMy57Ojyql7gJVLz7t0K3VX9iul3p+EDgj8U3GbDWzJTFYqk
         9sboJsnet0w+wnZ21ZHvhMSxB3Kwkyy/skLTY3FI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-input@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.19 09/72] HID: steam: Prevent NULL pointer dereference in steam_{recv,send}_report
Date:   Fri,  2 Sep 2022 14:18:45 +0200
Message-Id: <20220902121405.102987587@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.772492078@linuxfoundation.org>
References: <20220902121404.772492078@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Lee Jones <lee.jones@linaro.org>

commit cd11d1a6114bd4bc6450ae59f6e110ec47362126 upstream.

It is possible for a malicious device to forgo submitting a Feature
Report.  The HID Steam driver presently makes no prevision for this
and de-references the 'struct hid_report' pointer obtained from the
HID devices without first checking its validity.  Let's change that.

Cc: Jiri Kosina <jikos@kernel.org>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: linux-input@vger.kernel.org
Fixes: c164d6abf3841 ("HID: add driver for Valve Steam Controller")
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-steam.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/hid/hid-steam.c
+++ b/drivers/hid/hid-steam.c
@@ -134,6 +134,11 @@ static int steam_recv_report(struct stea
 	int ret;
 
 	r = steam->hdev->report_enum[HID_FEATURE_REPORT].report_id_hash[0];
+	if (!r) {
+		hid_err(steam->hdev, "No HID_FEATURE_REPORT submitted -  nothing to read\n");
+		return -EINVAL;
+	}
+
 	if (hid_report_len(r) < 64)
 		return -EINVAL;
 
@@ -165,6 +170,11 @@ static int steam_send_report(struct stea
 	int ret;
 
 	r = steam->hdev->report_enum[HID_FEATURE_REPORT].report_id_hash[0];
+	if (!r) {
+		hid_err(steam->hdev, "No HID_FEATURE_REPORT submitted -  nothing to read\n");
+		return -EINVAL;
+	}
+
 	if (hid_report_len(r) < 64)
 		return -EINVAL;
 


