Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3057B4522D1
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344778AbhKPBQW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:16:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:42218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244512AbhKOTPH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:15:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 479BF63415;
        Mon, 15 Nov 2021 18:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000509;
        bh=lsK4NtStt7bCYYBoRbBL/bYDlvgbP/fC4WL50yzicpI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0cAE4cDCeIVE1QuTVYwjOvmoXdj2Lwv+uERPVcC+7RQ7JeRDsQSJpF4KSKiLN8EsA
         YB4bqTa6MGNIlmdWqNOvM6LvmU3HuBohTH9QKzNd/aJM1Eaet94/AP52MRtHgXw4g1
         R8JFJBg9b3ap58eXJNJCScRpwKNrwFdtSIp8Rf/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Keeping <john@metanate.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 687/849] Input: st1232 - increase "wait ready" timeout
Date:   Mon, 15 Nov 2021 18:02:50 +0100
Message-Id: <20211115165443.504419527@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Keeping <john@metanate.com>

[ Upstream commit 2667f6b7af99e81958fa97c03bb519fcb09d0055 ]

I have a ST1633 touch controller which fails to probe due to a timeout
waiting for the controller to become ready.  Increasing the minimum
delay to 100ms ensures that the probe sequence completes successfully.

The ST1633 datasheet says nothing about the maximum delay here and the
ST1232 I2C protocol document says "wait until" with no notion of a
timeout.

Since this only runs once during probe, being generous with the timout
seems reasonable and most likely the device will become ready
eventually.

(It may be worth noting that I saw this issue with a PREEMPT_RT patched
kernel which probably has tighter wakeups from usleep_range() than other
preemption models.)

Fixes: f605be6a57b4 ("Input: st1232 - wait until device is ready before reading resolution")
Signed-off-by: John Keeping <john@metanate.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20210929152609.2421483-1-john@metanate.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/st1232.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/st1232.c b/drivers/input/touchscreen/st1232.c
index 6abae665ca71d..9d1dea6996a22 100644
--- a/drivers/input/touchscreen/st1232.c
+++ b/drivers/input/touchscreen/st1232.c
@@ -92,7 +92,7 @@ static int st1232_ts_wait_ready(struct st1232_ts_data *ts)
 	unsigned int retries;
 	int error;
 
-	for (retries = 10; retries; retries--) {
+	for (retries = 100; retries; retries--) {
 		error = st1232_ts_read_data(ts, REG_STATUS, 1);
 		if (!error) {
 			switch (ts->read_buf[0]) {
-- 
2.33.0



