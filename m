Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2401F12C980
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729004AbfL2SJK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 13:09:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:55764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730731AbfL2RqM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:46:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 613C8206DB;
        Sun, 29 Dec 2019 17:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641571;
        bh=pliYlUNXHghI6QwxkH/AydJq0XEv46ot49j8tJd7hec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zuzzw/HQQuUJuyd3zFa7DKCBPIeVvqCF14KFXrVcLCuWPR88Axma+lRHX/e4XmaFQ
         I6gZ8HGLwwHR48yL/9Y+je0Lacyb2yE4eYiUjaNdN25gtQ5uPHe6mapuAkWHsEoKWw
         CpdXZol5XHJgwZS6zUXreW5DQMMxX2F0w8+GdnoY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 121/434] team: call RCU read lock when walking the port_list
Date:   Sun, 29 Dec 2019 18:22:54 +0100
Message-Id: <20191229172709.730653086@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit c17e26ddc79596230834345be80fcad6c619e9ec ]

Before reading the team port list, we need to acquire the RCU read lock.
Also change list_for_each_entry() to list_for_each_entry_rcu().

v2:
repost the patch to net-next and remove fixes flag as this is a cosmetic
change.

Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/team/team.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 8156b33ee3e7..ca70a1d840eb 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -2074,7 +2074,8 @@ static int team_ethtool_get_link_ksettings(struct net_device *dev,
 	cmd->base.duplex = DUPLEX_UNKNOWN;
 	cmd->base.port = PORT_OTHER;
 
-	list_for_each_entry(port, &team->port_list, list) {
+	rcu_read_lock();
+	list_for_each_entry_rcu(port, &team->port_list, list) {
 		if (team_port_txable(port)) {
 			if (port->state.speed != SPEED_UNKNOWN)
 				speed += port->state.speed;
@@ -2083,6 +2084,8 @@ static int team_ethtool_get_link_ksettings(struct net_device *dev,
 				cmd->base.duplex = port->state.duplex;
 		}
 	}
+	rcu_read_unlock();
+
 	cmd->base.speed = speed ? : SPEED_UNKNOWN;
 
 	return 0;
-- 
2.20.1



