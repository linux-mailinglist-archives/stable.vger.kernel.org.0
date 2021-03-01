Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47236328908
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238844AbhCARsa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:48:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:34728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238867AbhCARnr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:43:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C870B64FDC;
        Mon,  1 Mar 2021 16:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617879;
        bh=UbYNAoMR8WZcRAe1hWpwa/TxwlSKBARtltxfnTQdrik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PGvoOMffCxf8rlJZ2Hhntgshi0KdyARyV4bFmMhtArIPLk5K6tBK42Ju2OvNup55h
         JToNf6klXkMyT155H6q1YEaiMATp/wHEK5Vhfc9S/oEmc25jacuezev6slWqfc2MHm
         h4V8dxfiP9vnBlc42Cd6ZNkuKd4v0L5OuSMUbYq4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 199/340] Input: elo - fix an error code in elo_connect()
Date:   Mon,  1 Mar 2021 17:12:23 +0100
Message-Id: <20210301161058.101824323@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 0958351e93fa0ac142f6dd8bd844441594f30a57 ]

If elo_setup_10() fails then this should return an error code instead
of success.

Fixes: fae3006e4b42 ("Input: elo - add support for non-pressure-sensitive touchscreens")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/YBKFd5CvDu+jVmfW@mwanda
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/elo.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/elo.c b/drivers/input/touchscreen/elo.c
index d6772a2c2d096..e396857cb4c1b 100644
--- a/drivers/input/touchscreen/elo.c
+++ b/drivers/input/touchscreen/elo.c
@@ -341,8 +341,10 @@ static int elo_connect(struct serio *serio, struct serio_driver *drv)
 	switch (elo->id) {
 
 	case 0: /* 10-byte protocol */
-		if (elo_setup_10(elo))
+		if (elo_setup_10(elo)) {
+			err = -EIO;
 			goto fail3;
+		}
 
 		break;
 
-- 
2.27.0



