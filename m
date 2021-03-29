Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D24434CA53
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234613AbhC2Igx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:36:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:55168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234381AbhC2Ifd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:35:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 635EE619B9;
        Mon, 29 Mar 2021 08:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006907;
        bh=Knma5qnz+dz3inPfmmtNceFH4HfcpVpK4qQ2jqRcOSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kmfkYSNxgVBDIYgvg8acEPkXSK0Mqm+JDELKc+EKUlytyh2mAVec6QwFRhdpp442C
         XJambOsI4SYvGKyD63Ow+trNPQsUfXs58CS7TaUlFPbHaD3O4kdQNauIoZuuezmLOD
         tTt6jj3ca8OViVU0eR10zp0Psq2mkh+P8ALnjS3s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 147/254] can: isotp: isotp_setsockopt(): only allow to set low level TX flags for CAN-FD
Date:   Mon, 29 Mar 2021 09:57:43 +0200
Message-Id: <20210329075638.043401350@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit e4912459bd5edd493b61bc7c3a5d9b2eb17f5a89 ]

CAN-FD frames have struct canfd_frame::flags, while classic CAN frames
don't.

This patch refuses to set TX flags (struct
can_isotp_ll_options::tx_flags) on non CAN-FD isotp sockets.

Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
Link: https://lore.kernel.org/r/20210218215434.1708249-2-mkl@pengutronix.de
Cc: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/isotp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index 3ef7f78e553b..e32d446c121e 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1228,7 +1228,8 @@ static int isotp_setsockopt(struct socket *sock, int level, int optname,
 			if (ll.mtu != CAN_MTU && ll.mtu != CANFD_MTU)
 				return -EINVAL;
 
-			if (ll.mtu == CAN_MTU && ll.tx_dl > CAN_MAX_DLEN)
+			if (ll.mtu == CAN_MTU &&
+			    (ll.tx_dl > CAN_MAX_DLEN || ll.tx_flags != 0))
 				return -EINVAL;
 
 			memcpy(&so->ll, &ll, sizeof(ll));
-- 
2.30.1



