Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99ED224FA6E
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728174AbgHXIfu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:35:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:47222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728169AbgHXIfs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:35:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBF14207D3;
        Mon, 24 Aug 2020 08:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258148;
        bh=NSM0kikoMYd4CitRmeGSudrfPq2pKTmsMTIAOfWWzhc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sr19kNxjKpwRJ/oBMS3QkJqd0B/62vhukwOLvRlmEmI7QOPsN5KJy73G5XPpIHKAr
         oJcY8UwdUqDSSfk2edIO93+z+J3KGlF6g5RKg8uC9cKfI2gX0mg55IneMLNrf3x/Rs
         lVsVE/YrX0Qdjp9TRn3WQ/WZB1ChztLxT3K3AJLk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 093/148] can: j1939: cancel rxtimer on multipacket broadcast session complete
Date:   Mon, 24 Aug 2020 10:29:51 +0200
Message-Id: <20200824082418.501852220@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082413.900489417@linuxfoundation.org>
References: <20200824082413.900489417@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit e8b17653088f28a87c81845fa41a2d295a3b458c ]

If j1939_xtp_rx_dat_one() receive last frame of multipacket broadcast message,
j1939_session_timers_cancel() should be called to cancel rxtimer.

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Link: https://lore.kernel.org/r/1596599425-5534-3-git-send-email-zhangchangzhong@huawei.com
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/j1939/transport.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index 67189b4c482c5..d1a9adde677b0 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -1811,6 +1811,7 @@ static void j1939_xtp_rx_dat_one(struct j1939_session *session,
 	}
 
 	if (final) {
+		j1939_session_timers_cancel(session);
 		j1939_session_completed(session);
 	} else if (do_cts_eoma) {
 		j1939_tp_set_rxtimeout(session, 1250);
-- 
2.25.1



