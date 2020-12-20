Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D90642DF322
	for <lists+stable@lfdr.de>; Sun, 20 Dec 2020 04:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728278AbgLTDg3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 22:36:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:57982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728277AbgLTDg2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Dec 2020 22:36:28 -0500
From:   Sasha Levin <sashal@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Rajat Jain <rajatja@google.com>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 2/3] Input: cros_ec_keyb - send 'scancodes' in addition to key events
Date:   Sat, 19 Dec 2020 22:35:25 -0500
Message-Id: <20201220033526.2728841-2-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201220033526.2728841-1-sashal@kernel.org>
References: <20201220033526.2728841-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 80db2a087f425b63f0163bc95217abd01c637cb5 ]

To let userspace know what 'scancodes' should be used in EVIOCGKEYCODE
and EVIOCSKEYCODE ioctls, we should send EV_MSC/MSC_SCAN events in
addition to EV_KEY/KEY_* events. The driver already declared MSC_SCAN
capability, so it is only matter of actually sending the events.

Link: https://lore.kernel.org/r/X87aOaSptPTvZ3nZ@google.com
Acked-by: Rajat Jain <rajatja@google.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/keyboard/cros_ec_keyb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/keyboard/cros_ec_keyb.c b/drivers/input/keyboard/cros_ec_keyb.c
index 25943e9bc8bff..328792e26a9f6 100644
--- a/drivers/input/keyboard/cros_ec_keyb.c
+++ b/drivers/input/keyboard/cros_ec_keyb.c
@@ -140,6 +140,7 @@ static void cros_ec_keyb_process(struct cros_ec_keyb *ckdev,
 					"changed: [r%d c%d]: byte %02x\n",
 					row, col, new_state);
 
+				input_event(idev, EV_MSC, MSC_SCAN, pos);
 				input_report_key(idev, keycodes[pos],
 						 new_state);
 			}
-- 
2.27.0

