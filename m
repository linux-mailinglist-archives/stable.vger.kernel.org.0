Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF1E760A439
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232684AbiJXMGi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233083AbiJXMFE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:05:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FF6D7CAA2;
        Mon, 24 Oct 2022 04:51:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57F29B811C0;
        Mon, 24 Oct 2022 11:50:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACFB6C4314F;
        Mon, 24 Oct 2022 11:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612200;
        bh=xK4TJAnvmIYn/27eY3hx0LNJJauXMyCiuXPB+sk2Bhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QWXODkGgUiFSeb+Od8xymSOu3+++Jn82mPzmDwGbp0YyFch9rctlRhk0K+VwMkPZK
         RBGZDTxR/v5SHcz+WzO/9It/mvCSMV5jwyRap4KcMQ4pNf2LLFcDhgSgavUa9IPmxB
         bKmmTf13slKtTUs/f4eCE2JxyQJK9DSUxsl+Uzt0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 100/210] platform/x86: msi-laptop: Fix resource cleanup
Date:   Mon, 24 Oct 2022 13:30:17 +0200
Message-Id: <20221024113000.267229182@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 5523632aa10f906dfe2eb714ee748590dc7fc6b1 ]

Fix the input-device not getting free-ed on probe-errors and
fix the msi_touchpad_dwork not getting cancelled on neither
probe-errors nor on remove.

Fixes: 143a4c0284dc ("msi-laptop: send out touchpad on/off key")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20220825141336.208597-3-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/msi-laptop.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/platform/x86/msi-laptop.c b/drivers/platform/x86/msi-laptop.c
index 7279390a2d54..1ba5f4689df4 100644
--- a/drivers/platform/x86/msi-laptop.c
+++ b/drivers/platform/x86/msi-laptop.c
@@ -1129,6 +1129,8 @@ static int __init msi_init(void)
 fail_create_group:
 	if (quirks->load_scm_model) {
 		i8042_remove_filter(msi_laptop_i8042_filter);
+		cancel_delayed_work_sync(&msi_touchpad_dwork);
+		input_unregister_device(msi_laptop_input_dev);
 		cancel_delayed_work_sync(&msi_rfkill_dwork);
 		cancel_work_sync(&msi_rfkill_work);
 		rfkill_cleanup();
@@ -1149,6 +1151,7 @@ static void __exit msi_cleanup(void)
 {
 	if (quirks->load_scm_model) {
 		i8042_remove_filter(msi_laptop_i8042_filter);
+		cancel_delayed_work_sync(&msi_touchpad_dwork);
 		input_unregister_device(msi_laptop_input_dev);
 		cancel_delayed_work_sync(&msi_rfkill_dwork);
 		cancel_work_sync(&msi_rfkill_work);
-- 
2.35.1



