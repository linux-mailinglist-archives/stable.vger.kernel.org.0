Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 843722E42F8
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391530AbgL1Nws (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:52:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:54650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391525AbgL1Nwr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:52:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFBE820791;
        Mon, 28 Dec 2020 13:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163526;
        bh=8oGGp5xXe/o8MkOEYfYerB3yQG5FjAmtKGpzIWitqTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eXltDuCTwDkiGG2eVj5tN54gfjBIkPKI9Fpib2/1Gwvi4ajKqc0O3M9upYqd8Cpiw
         jN2Ydq1Qaf1sbkWLeVGqC8HjG72PSc9qR7PgRzDZlaNWYq6IbjYdYe68QRv6fAtprf
         cwXz3gCuJtLYFaqlC2/jAKFnGm+p/8wjgzN/wxBI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rajat Jain <rajatja@google.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 317/453] Input: cros_ec_keyb - send scancodes in addition to key events
Date:   Mon, 28 Dec 2020 13:49:13 +0100
Message-Id: <20201228124952.464705574@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 8d4d9786cc745..cae262b6ff398 100644
--- a/drivers/input/keyboard/cros_ec_keyb.c
+++ b/drivers/input/keyboard/cros_ec_keyb.c
@@ -183,6 +183,7 @@ static void cros_ec_keyb_process(struct cros_ec_keyb *ckdev,
 					"changed: [r%d c%d]: byte %02x\n",
 					row, col, new_state);
 
+				input_event(idev, EV_MSC, MSC_SCAN, pos);
 				input_report_key(idev, keycodes[pos],
 						 new_state);
 			}
-- 
2.27.0



