Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 222872D9F49
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 19:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408803AbgLNS3W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 13:29:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:47556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502294AbgLNRiC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:38:02 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pankaj Sharma <pankj.sharma@samsung.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 073/105] can: m_can: m_can_dev_setup(): add support for bosch mcan version 3.3.0
Date:   Mon, 14 Dec 2020 18:28:47 +0100
Message-Id: <20201214172558.780037588@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214172555.280929671@linuxfoundation.org>
References: <20201214172555.280929671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pankaj Sharma <pankj.sharma@samsung.com>

[ Upstream commit 5c7d55bded77da6db7c5d249610e3a2eed730b3c ]

Add support for mcan bit timing and control mode according to bosch mcan IP
version 3.3.0. The mcan version read from the Core Release field of CREL
register would be 33. Accordingly the properties are to be set for mcan v3.3.0

Signed-off-by: Pankaj Sharma <pankj.sharma@samsung.com>
Link: https://lore.kernel.org/r/1606366302-5520-1-git-send-email-pankj.sharma@samsung.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/m_can.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index d4030abad935d..61a93b1920379 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1385,6 +1385,8 @@ static int m_can_dev_setup(struct m_can_classdev *m_can_dev)
 						&m_can_data_bittiming_const_31X;
 		break;
 	case 32:
+	case 33:
+		/* Support both MCAN version v3.2.x and v3.3.0 */
 		m_can_dev->can.bittiming_const = m_can_dev->bit_timing ?
 			m_can_dev->bit_timing : &m_can_bittiming_const_31X;
 
-- 
2.27.0



