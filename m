Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 466BD3DD8E9
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235896AbhHBN43 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:56:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:58758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235398AbhHBNxM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:53:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14DAA60F6D;
        Mon,  2 Aug 2021 13:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912332;
        bh=19MS8kvwxsF3b3xQuAZ1NvLXusGWe0aGzbA3foiWk9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hzfxG7ajcjUFvadglyW2NkhWK2Z/lfhRNmYiEju3tkuHTXvWk1TqU5d7TD1Yji2wR
         TOIowQ6D4eFhyRte7o2p3ude+QjHrfIo2qy7ctgCjuCkVDdXWT8q7Tfe6rM+jWrMmp
         R0HtELcYR8dPCbqxWqQY4mWH5gf4aEOUMrHR+naY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.10 12/67] can: j1939: j1939_xtp_rx_dat_one(): fix rxtimer value between consecutive TP.DT to 750ms
Date:   Mon,  2 Aug 2021 15:44:35 +0200
Message-Id: <20210802134339.433892557@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134339.023067817@linuxfoundation.org>
References: <20210802134339.023067817@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>

commit c6eea1c8bda56737752465a298dc6ce07d6b8ce3 upstream.

For receive side, the max time interval between two consecutive TP.DT
should be 750ms.

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Link: https://lore.kernel.org/r/1625569210-47506-1-git-send-email-zhangchangzhong@huawei.com
Cc: linux-stable <stable@vger.kernel.org>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/j1939/transport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -1869,7 +1869,7 @@ static void j1939_xtp_rx_dat_one(struct
 		if (!session->transmission)
 			j1939_tp_schedule_txtimer(session, 0);
 	} else {
-		j1939_tp_set_rxtimeout(session, 250);
+		j1939_tp_set_rxtimeout(session, 750);
 	}
 	session->last_cmd = 0xff;
 	consume_skb(se_skb);


