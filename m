Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABB40329071
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:09:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242922AbhCAUIq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:08:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:33480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237875AbhCAT5G (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:57:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9496B6537C;
        Mon,  1 Mar 2021 17:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621330;
        bh=ezJy23QlAriG+7ei6cVDvyg4Ri2F9tWiLiC5Wv2Do54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GkCSb7yC/qFUW5f7Qxt6iWC5yBs44dKqfdsE4Yg+LIqS3+kwAqG1LEBLmAcKdCOh/
         MU84kOteTUzQN9HO5Os5uWEsBxSVeutM/jhGzeWYr6MN0ln99WnpIMW9i+R8TYojfW
         aa3HIe3glMrbHYdmomJPxJ+nExsY/qvhIbtGdc0w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Michael Tretter <m.tretter@pengutronix.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 477/775] Input: st1232 - fix NORMAL vs. IDLE state handling
Date:   Mon,  1 Mar 2021 17:10:45 +0100
Message-Id: <20210301161225.112164617@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 1bff77f41a805b16b5355497c217656711601282 ]

NORMAL (0x0) and IDLE (0x4) are really two different states.  Hence you
cannot check for both using a bitmask, as that checks for IDLE only,
breaking operation for devices that are in NORMAL state.

Fix the wait function to report either state as ready.

Fixes: 6524d8eac258452e ("Input: st1232 - add IDLE state as ready condition")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Michael Tretter <m.tretter@pengutronix.de>
Link: https://lore.kernel.org/r/20210223090201.1430542-1-geert+renesas@glider.be
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/st1232.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/input/touchscreen/st1232.c b/drivers/input/touchscreen/st1232.c
index 885f0572488dd..6abae665ca71d 100644
--- a/drivers/input/touchscreen/st1232.c
+++ b/drivers/input/touchscreen/st1232.c
@@ -94,8 +94,13 @@ static int st1232_ts_wait_ready(struct st1232_ts_data *ts)
 
 	for (retries = 10; retries; retries--) {
 		error = st1232_ts_read_data(ts, REG_STATUS, 1);
-		if (!error && ts->read_buf[0] == (STATUS_NORMAL | STATUS_IDLE | ERROR_NONE))
-			return 0;
+		if (!error) {
+			switch (ts->read_buf[0]) {
+			case STATUS_NORMAL | ERROR_NONE:
+			case STATUS_IDLE | ERROR_NONE:
+				return 0;
+			}
+		}
 
 		usleep_range(1000, 2000);
 	}
-- 
2.27.0



