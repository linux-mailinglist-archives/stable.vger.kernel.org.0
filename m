Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41D6F24096A
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbgHJPbh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:31:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:38864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728723AbgHJPb3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:31:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2316320774;
        Mon, 10 Aug 2020 15:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597073488;
        bh=2PCh6oLuxOyKaB0b/W2A72/vMsTCi5EUt/McGv1HIXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q2LXODy7++fog29JxXbUe8nPJCnH5lMLxIiCzSSYfvpEG3/xBbWe+hb61IjBaygLe
         YDxyfin/jua6BB5FKggTm3h0/1U7ym8395OJy/Q4PBK9Mr7WsEakIEN6NhbKcJML9s
         4UitCrb/9bvNcMigEmCE6lGnAQC2ArL9TTJ/8RVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Alain Volmat <alain.volmat@st.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 22/48] i2c: slave: improve sanity check when registering
Date:   Mon, 10 Aug 2020 17:21:44 +0200
Message-Id: <20200810151805.310493685@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151804.199494191@linuxfoundation.org>
References: <20200810151804.199494191@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 1b1be3bf27b62f5abcf85c6f3214bdb9c7526685 ]

Add check for ERR_PTR and simplify code while here.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Alain Volmat <alain.volmat@st.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/i2c-core-slave.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/i2c/i2c-core-slave.c b/drivers/i2c/i2c-core-slave.c
index 47a9f70a24a97..88959c8580ce0 100644
--- a/drivers/i2c/i2c-core-slave.c
+++ b/drivers/i2c/i2c-core-slave.c
@@ -22,10 +22,8 @@ int i2c_slave_register(struct i2c_client *client, i2c_slave_cb_t slave_cb)
 {
 	int ret;
 
-	if (!client || !slave_cb) {
-		WARN(1, "insufficient data\n");
+	if (WARN(IS_ERR_OR_NULL(client) || !slave_cb, "insufficient data\n"))
 		return -EINVAL;
-	}
 
 	if (!(client->flags & I2C_CLIENT_SLAVE))
 		dev_warn(&client->dev, "%s: client slave flag not set. You might see address collisions\n",
-- 
2.25.1



