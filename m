Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09302329062
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242776AbhCAUIL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:08:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:60470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240929AbhCATzo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:55:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D7A46537B;
        Mon,  1 Mar 2021 17:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621324;
        bh=++I0Nj0PLxescV1Sm9n34oAHLi3b9EOb8dWbDtGUHtw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fk0jfa2ig02WylXq74VgX5i5z+l3fAMF0cgAUaILhNhaN/MkDnQmFH/kYs0kqA8ZC
         faglZ2DNEwmvo6RErrjNWujopp+5+hH9mBmY5mMvtS365ChZVb+ZQ+Tjll6wh5aIbS
         w45GEC/a7NiJO5sACO0wsNcNd8CObQWWFbxN0Tiw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Tretter <m.tretter@pengutronix.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 475/775] Input: st1232 - add IDLE state as ready condition
Date:   Mon,  1 Mar 2021 17:10:43 +0100
Message-Id: <20210301161225.016236772@linuxfoundation.org>
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

From: Michael Tretter <m.tretter@pengutronix.de>

[ Upstream commit 6524d8eac258452e547f8a49c8a965ac6dd8a161 ]

The st1232 can switch from NORMAL to IDLE state after the configured
idle time (by default 8 s). If the st1232 is not reset during probe, it
might already be ready but in IDLE state. Since it does not enter NORMAL
state in this case, probe fails.

Fix the wait function to report the IDLE state as ready, too.

Fixes: f605be6a57b4 ("Input: st1232 - wait until device is ready before reading resolution")
Signed-off-by: Michael Tretter <m.tretter@pengutronix.de>
Link: https://lore.kernel.org/r/20210219110556.1858969-1-m.tretter@pengutronix.de
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/st1232.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/st1232.c b/drivers/input/touchscreen/st1232.c
index b4e7bcbe9b91d..885f0572488dd 100644
--- a/drivers/input/touchscreen/st1232.c
+++ b/drivers/input/touchscreen/st1232.c
@@ -94,7 +94,7 @@ static int st1232_ts_wait_ready(struct st1232_ts_data *ts)
 
 	for (retries = 10; retries; retries--) {
 		error = st1232_ts_read_data(ts, REG_STATUS, 1);
-		if (!error && ts->read_buf[0] == (STATUS_NORMAL | ERROR_NONE))
+		if (!error && ts->read_buf[0] == (STATUS_NORMAL | STATUS_IDLE | ERROR_NONE))
 			return 0;
 
 		usleep_range(1000, 2000);
-- 
2.27.0



