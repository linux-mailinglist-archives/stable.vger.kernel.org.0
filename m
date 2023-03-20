Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B32D86C0780
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 01:58:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbjCTA6d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Mar 2023 20:58:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbjCTA5n (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Mar 2023 20:57:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1154206B0;
        Sun, 19 Mar 2023 17:55:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 634EE61151;
        Mon, 20 Mar 2023 00:55:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED78DC4339B;
        Mon, 20 Mar 2023 00:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679273725;
        bh=N0JngPiakVmWn0pas8UQ6o3gjr4WlERh/VaRTspIy+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RJCb83Ismanr4enTTAIpR5TtMuAmp7+NhrVdLuPkcvBWPYCgcbCiyJg9KGGeHTt7E
         cBj+bPiy9ShcrCzukVKlc6E6e03zKpbpaOy5UNVsSdX0vZ9BJL1rI31+qUAxdkxIcn
         9RP2xD1fsMO2TsTtlIgDOQ7EZgqeaS479WwqASnY1Mv5F6zRhCNVWivonSwPhCVIJP
         Nf054oiG9xl/pBURO+1OZsDSoGNsdonJNdyyO9wQANVMVUwM/HuaxY+Ca+DzoCnI3c
         +JP6M8vqt9G1sxr1Lz5XmHar5aqWjz7z0Ipe1yxVL2y6l/WxsEs02pBJXUhsSy6i15
         Apl+bsJtDb1cw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lee Jones <lee@kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        Sasha Levin <sashal@kernel.org>, david.rheinsberg@gmail.com,
        jikos@kernel.org, benjamin.tissoires@redhat.com,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 02/17] HID: uhid: Over-ride the default maximum data buffer value with our own
Date:   Sun, 19 Mar 2023 20:55:04 -0400
Message-Id: <20230320005521.1428820-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230320005521.1428820-1-sashal@kernel.org>
References: <20230320005521.1428820-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lee Jones <lee@kernel.org>

[ Upstream commit 1c5d4221240a233df2440fe75c881465cdf8da07 ]

The default maximum data buffer size for this interface is UHID_DATA_MAX
(4k).  When data buffers are being processed, ensure this value is used
when ensuring the sanity, rather than a value between the user provided
value and HID_MAX_BUFFER_SIZE (16k).

Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/uhid.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/uhid.c b/drivers/hid/uhid.c
index fc06d8bb42e0f..ba0ca652b9dab 100644
--- a/drivers/hid/uhid.c
+++ b/drivers/hid/uhid.c
@@ -395,6 +395,7 @@ struct hid_ll_driver uhid_hid_driver = {
 	.parse = uhid_hid_parse,
 	.raw_request = uhid_hid_raw_request,
 	.output_report = uhid_hid_output_report,
+	.max_buffer_size = UHID_DATA_MAX,
 };
 EXPORT_SYMBOL_GPL(uhid_hid_driver);
 
-- 
2.39.2

