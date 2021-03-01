Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC92C3284B0
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234824AbhCAQlD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:41:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:36326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232698AbhCAQc2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:32:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 761B964F58;
        Mon,  1 Mar 2021 16:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615907;
        bh=YaxCMftwgxD6JmXs/9OR16eB/9zxdm6NwX39b2sOag8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T57LyZvwl7l2o4f6783FdFgj4QnVriTjjXOYvgs90rxkjHUNc1qZUM8uoTYxMMNPk
         Gw4G+tjU6xL4dEeFYe4CIXnbm0751gk0nLSh1VMVBKpWWkd88ASfia4iSY7l6C2cs3
         AhJeYPh0M13cF2isKUlrCwBm7NjeTRjBghkfmhOw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 072/134] Input: elo - fix an error code in elo_connect()
Date:   Mon,  1 Mar 2021 17:12:53 +0100
Message-Id: <20210301161017.101158106@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161013.585393984@linuxfoundation.org>
References: <20210301161013.585393984@linuxfoundation.org>
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
index 8051a4b704ea3..e2e31cbd6b2c3 100644
--- a/drivers/input/touchscreen/elo.c
+++ b/drivers/input/touchscreen/elo.c
@@ -345,8 +345,10 @@ static int elo_connect(struct serio *serio, struct serio_driver *drv)
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



