Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53B71566CBC
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235770AbiGEMUM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237227AbiGEMSz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:18:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AD491CB29;
        Tue,  5 Jul 2022 05:14:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A003C619B9;
        Tue,  5 Jul 2022 12:14:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACDF8C341C8;
        Tue,  5 Jul 2022 12:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023250;
        bh=+JZA5OEGxWIXPapYMcqe4lqYXS/n4xM+niU/hqgXiag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1ht73Bse5DIS45JhP9PVAOyuStC0eJWRoqlNmAGeabZEAVQks0xrSMhAebNWMa8da
         1xQ8Fw34F8boIs0WxJpfWoiz9IEJj2dM+S1sXKOBTmBVX+HrMhIcaDH+v1O6N5LVcf
         SHfRWkHRL7ef+s+qqpsOKScrtsWJbzGdppFPeo14=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Stefan Seyfried <seife+kernel@b1-systems.com>,
        Kenneth Chan <kenneth.t.chan@gmail.com>
Subject: [PATCH 5.15 92/98] platform/x86: panasonic-laptop: revert "Resolve hotkey double trigger bug"
Date:   Tue,  5 Jul 2022 13:58:50 +0200
Message-Id: <20220705115620.180418351@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115617.568350164@linuxfoundation.org>
References: <20220705115617.568350164@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 83a5ddc3dc561c40d948b85553514aaba99123d8 ]

In hindsight blindly throwing away most of the key-press events is not
a good idea. So revert commit ed83c9171829 ("platform/x86:
panasonic-laptop: Resolve hotkey double trigger bug").

Fixes: ed83c9171829 ("platform/x86: panasonic-laptop: Resolve hotkey double trigger bug")
Reported-and-tested-by: Stefan Seyfried <seife+kernel@b1-systems.com>
Reported-and-tested-by: Kenneth Chan <kenneth.t.chan@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20220624112340.10130-5-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/panasonic-laptop.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/platform/x86/panasonic-laptop.c b/drivers/platform/x86/panasonic-laptop.c
index b89fbbc2fd08..cd3c23593eee 100644
--- a/drivers/platform/x86/panasonic-laptop.c
+++ b/drivers/platform/x86/panasonic-laptop.c
@@ -783,12 +783,8 @@ static void acpi_pcc_generate_keyinput(struct pcc_acpi *pcc)
 					key, 0x80, false);
 	}
 
-	/* for the magic values, see panasonic_keymap[] above */
-	if (key == 7 || key == 9 || key == 10) {
-		if (!sparse_keymap_report_event(hotk_input_dev,
-						key, updown, false))
-			pr_err("Unknown hotkey event: 0x%04llx\n", result);
-	}
+	if (!sparse_keymap_report_event(hotk_input_dev, key, updown, false))
+		pr_err("Unknown hotkey event: 0x%04llx\n", result);
 }
 
 static void acpi_pcc_hotkey_notify(struct acpi_device *device, u32 event)
-- 
2.35.1



