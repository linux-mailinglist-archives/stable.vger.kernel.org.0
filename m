Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67A0330C846
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 18:48:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237553AbhBBRqn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 12:46:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:48736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233998AbhBBOKL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:10:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE77E65036;
        Tue,  2 Feb 2021 13:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273864;
        bh=aLBL23LaxH9P3pVYWkKwhr4kiH82NIFBDEh00Ysp4Ao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kSIpiqx120ECp3pFdtawStbn4AQ7jiUmF2FrzI39LRhanflq4CdaTHbP2uxE/H7iI
         fBJjMEgxJHBsnBaA4kZ2Fd/AiOhbQnvLArL9d3VXWloTf3Epkcup+QBoHfUtDPEiir
         TGpt9bcDrCBoK+E95yYJ2qQ3oBCh14i1IAb2IsHQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 28/32] can: dev: prevent potential information leak in can_fill_info()
Date:   Tue,  2 Feb 2021 14:38:51 +0100
Message-Id: <20210202132943.134421993@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132942.035179752@linuxfoundation.org>
References: <20210202132942.035179752@linuxfoundation.org>
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
 drivers/net/can/dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/can/dev.c
+++ b/drivers/net/can/dev.c
@@ -1017,7 +1017,7 @@ static int can_fill_info(struct sk_buff
 {
 	struct can_priv *priv = netdev_priv(dev);
 	struct can_ctrlmode cm = {.flags = priv->ctrlmode};
-	struct can_berr_counter bec;
+	struct can_berr_counter bec = { };
 	enum can_state state = priv->state;
 
 	if (priv->do_get_state)


