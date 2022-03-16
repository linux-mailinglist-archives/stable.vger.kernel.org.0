Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8E6C4DB2C5
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 15:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356688AbiCPOUP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 10:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356786AbiCPOT3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 10:19:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C81C1CFE3;
        Wed, 16 Mar 2022 07:17:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0798B81B7A;
        Wed, 16 Mar 2022 14:17:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEE0BC340E9;
        Wed, 16 Mar 2022 14:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647440267;
        bh=ZqGrjoyTLlzOYsHDVHM6YzmHsPEEPwNgz/tXn328VLA=;
        h=From:To:Cc:Subject:Date:From;
        b=Qn59ktinCFv4+OrP+0sBx7jj8GD2kkw8BJq6U/SwETYfB++QK7HuTgFT7iXybcDOX
         3bRCs3N+28b0VjTo1bdxh6hGoo/mrGRHqUFFATfaZ0MG3Zgz79c8jVri9TBL/pWrKD
         tYSCnG+Des+ngi25d100OyadUOygwifu4rYZwtuKqII5SFE5n1Gw14U2aSlS8yYl3m
         YlD4Anr5krQMulWKTUPEEP2D2a0hB+aWvnYpJKdSfAafw2swYYYdP8O7XBUCnlUALW
         qJY35wlP7ue4KWGs5HO+lxpE8g73iGxXnwos94Fp+i2Uye5GiYbkVHrO7PZqsBvVOM
         lWDEt4XjC3kBg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lucas Zampieri <lzampier@redhat.com>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        jikos@kernel.org, benjamin.tissoires@redhat.com,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 1/7] HID: logitech-dj: add new lightspeed receiver id
Date:   Wed, 16 Mar 2022 10:17:32 -0400
Message-Id: <20220316141738.248513-1-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Zampieri <lzampier@redhat.com>

[ Upstream commit 25666e8ccd952627899b09b68f7c9b68cfeaf028 ]

As of logitech lightspeed receiver fw version 04.02.B0009,
HIDPP_PARAM_DEVICE_INFO is being reported as 0x11.

With patch "HID: logitech-dj: add support for the new lightspeed receiver
iteration", the mouse starts to error out with:
  logitech-djreceiver: unusable device of type UNKNOWN (0x011) connected on
  slot 1
and becomes unusable.

This has been noticed on a Logitech G Pro X Superlight fw MPM 25.01.B0018.

Signed-off-by: Lucas Zampieri <lzampier@redhat.com>
Acked-by: Nestor Lopez Casado <nlopezcasad@logitech.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-dj.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index 4267e2f2e70f..a663cbb7b683 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -1000,6 +1000,7 @@ static void logi_hidpp_recv_queue_notif(struct hid_device *hdev,
 		workitem.reports_supported |= STD_KEYBOARD;
 		break;
 	case 0x0f:
+	case 0x11:
 		device_type = "eQUAD Lightspeed 1.2";
 		logi_hidpp_dev_conn_notif_equad(hdev, hidpp_report, &workitem);
 		workitem.reports_supported |= STD_KEYBOARD;
-- 
2.34.1

