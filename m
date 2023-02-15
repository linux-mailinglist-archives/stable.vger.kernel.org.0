Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5B26986C0
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 22:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbjBOVBU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 16:01:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbjBOVBE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 16:01:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E4EF4743C;
        Wed, 15 Feb 2023 12:59:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D860B8225F;
        Wed, 15 Feb 2023 20:46:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EF4DC4339B;
        Wed, 15 Feb 2023 20:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676494008;
        bh=wOf9TsCuyj5000zw3qgyvwtH59ys6dWVyqhYx7gD7x8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sv28U0bhQGZHMuv8HI2PtAOyib93/Y5J9JpjqBnpP7CrdNM9GxzHBVJPm5nGI+oXD
         0huFTnSrJqR9A+KL2ikrGR5mSHKZkiGuiXJZ0ad4xH+Vg2jp47kOFIDARHUkj2UBkh
         5gHuLmeB2Q5i0DsqC0t1pyPN/3/Na4yenIPVktnsAApKGyH/mzi9owjd1hEgKxxIWj
         qCLARe93+dbBYGP5nqwbzgv5NI84coIxPWfeKniY69rbv9h2gOx/XumLUDM1kfREkD
         hrB910gVWI2iSCbuKlwN2x4/kSQmNo540Oi/LYxGeAaCb5fM6Dtr7nHr8HME4fC/Pv
         i82fgoHw3bnBw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xin Zhao <xnzhao@google.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Sasha Levin <sashal@kernel.org>, jikos@kernel.org,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 11/12] HID: core: Fix deadloop in hid_apply_multiplier.
Date:   Wed, 15 Feb 2023 15:46:33 -0500
Message-Id: <20230215204637.2761073-11-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230215204637.2761073-1-sashal@kernel.org>
References: <20230215204637.2761073-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Zhao <xnzhao@google.com>

[ Upstream commit ea427a222d8bdf2bc1a8a6da3ebe247f7dced70c ]

The initial value of hid->collection[].parent_idx if 0. When
Report descriptor doesn't contain "HID Collection", the value
remains as 0.

In the meanwhile, when the Report descriptor fullfill
all following conditions, it will trigger hid_apply_multiplier
function call.
1. Usage page is Generic Desktop Ctrls (0x01)
2. Usage is RESOLUTION_MULTIPLIER (0x48)
3. Contain any FEATURE items

The while loop in hid_apply_multiplier will search the top-most
collection by searching parent_idx == -1. Because all parent_idx
is 0. The loop will run forever.

There is a Report Descriptor triggerring the deadloop
0x05, 0x01,        // Usage Page (Generic Desktop Ctrls)
0x09, 0x48,        // Usage (0x48)
0x95, 0x01,        // Report Count (1)
0x75, 0x08,        // Report Size (8)
0xB1, 0x01,        // Feature

Signed-off-by: Xin Zhao <xnzhao@google.com>
Link: https://lore.kernel.org/r/20230130212947.1315941-1-xnzhao@google.com
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 2e475bd426b84..f1ea883db5de1 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1197,6 +1197,7 @@ int hid_open_report(struct hid_device *device)
 	__u8 *end;
 	__u8 *next;
 	int ret;
+	int i;
 	static int (*dispatch_type[])(struct hid_parser *parser,
 				      struct hid_item *item) = {
 		hid_parser_main,
@@ -1247,6 +1248,8 @@ int hid_open_report(struct hid_device *device)
 		goto err;
 	}
 	device->collection_size = HID_DEFAULT_NUM_COLLECTIONS;
+	for (i = 0; i < HID_DEFAULT_NUM_COLLECTIONS; i++)
+		device->collection[i].parent_idx = -1;
 
 	ret = -EINVAL;
 	while ((next = fetch_item(start, end, &item)) != NULL) {
-- 
2.39.0

