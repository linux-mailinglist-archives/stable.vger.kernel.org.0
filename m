Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 372D030C7E3
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 18:36:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237398AbhBBRdx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 12:33:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:49708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234146AbhBBOMh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:12:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8554365041;
        Tue,  2 Feb 2021 13:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273971;
        bh=C7Q+w/7Bosbo1+/Sb5KbcLR2RmAE9jzclMPxTgrVMSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T4ug3Y9bGu83iUAQgP/DL/FQIje8pJ6hJmZeGOtgmYrwFmcDCgGl0gfyQBp88+ghx
         T17y8GzD3KVVu42LIk11fFA9UuNZgcLjKh5Y/WGUju4xNeQIq9dutI+2HTgzsuS8EM
         4ojPe6JHxVLAPpFQp5xE1kFCH8RO5jQaA3eo2D3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 22/30] can: dev: prevent potential information leak in can_fill_info()
Date:   Tue,  2 Feb 2021 14:39:03 +0100
Message-Id: <20210202132943.055765710@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132942.138623851@linuxfoundation.org>
References: <20210202132942.138623851@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit b552766c872f5b0d90323b24e4c9e8fa67486dd5 ]

The "bec" struct isn't necessarily always initialized. For example, the
mcp251xfd_get_berr_counter() function doesn't initialize anything if the
interface is down.

Fixes: 52c793f24054 ("can: netlink support for bus-error reporting and counters")
Link: https://lore.kernel.org/r/YAkaRdRJncsJO8Ve@mwanda
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
index 1025cfd463ece..0ebee99a3e857 100644
--- a/drivers/net/can/dev.c
+++ b/drivers/net/can/dev.c
@@ -1102,7 +1102,7 @@ static int can_fill_info(struct sk_buff *skb, const struct net_device *dev)
 {
 	struct can_priv *priv = netdev_priv(dev);
 	struct can_ctrlmode cm = {.flags = priv->ctrlmode};
-	struct can_berr_counter bec;
+	struct can_berr_counter bec = { };
 	enum can_state state = priv->state;
 
 	if (priv->do_get_state)
-- 
2.27.0



