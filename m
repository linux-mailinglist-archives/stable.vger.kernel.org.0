Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF68480046
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:44:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239209AbhL0PoS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:44:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239155AbhL0PmI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:42:08 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99345C061A72;
        Mon, 27 Dec 2021 07:41:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 18B54CE1070;
        Mon, 27 Dec 2021 15:41:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06276C36AEB;
        Mon, 27 Dec 2021 15:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619659;
        bh=nl8JDsMbNHJg8XZ13pDD6RgrLeNPNrzNU3oDnm9Gw0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dDREHz2lhZxIluHoyW+OfmK8IGEqEg2K5K/8J46af7LyPoVFZQZ6pZ/u4hGp9Y4DD
         eztXaKjOUFRUMsYgl+CW/X6noeiWRW6G4tI4HaPeaDUnBWWlgerIuD1tyMlcmyWnQX
         B4uf7hXajlZU9MuUyzjg8VNbodBizapwypmjKhwE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 025/128] net: marvell: prestera: fix incorrect return of port_find
Date:   Mon, 27 Dec 2021 16:30:00 +0100
Message-Id: <20211227151332.364789712@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yevhen Orlov <yevhen.orlov@plvision.eu>

[ Upstream commit 8b681bd7c301c423fbe97a6b23388a2180ff04ca ]

In case, when some ports is in list and we don't find requested - we
return last iterator state and not return NULL as expected.

Fixes: 501ef3066c89 ("net: marvell: prestera: Add driver for Prestera family ASIC devices")
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
Link: https://lore.kernel.org/r/20211216170736.8851-1-yevhen.orlov@plvision.eu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/marvell/prestera/prestera_main.c    | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index 44c670807fb3c..f6d2f928c5b83 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -54,12 +54,14 @@ int prestera_port_pvid_set(struct prestera_port *port, u16 vid)
 struct prestera_port *prestera_port_find_by_hwid(struct prestera_switch *sw,
 						 u32 dev_id, u32 hw_id)
 {
-	struct prestera_port *port = NULL;
+	struct prestera_port *port = NULL, *tmp;
 
 	read_lock(&sw->port_list_lock);
-	list_for_each_entry(port, &sw->port_list, list) {
-		if (port->dev_id == dev_id && port->hw_id == hw_id)
+	list_for_each_entry(tmp, &sw->port_list, list) {
+		if (tmp->dev_id == dev_id && tmp->hw_id == hw_id) {
+			port = tmp;
 			break;
+		}
 	}
 	read_unlock(&sw->port_list_lock);
 
@@ -68,12 +70,14 @@ struct prestera_port *prestera_port_find_by_hwid(struct prestera_switch *sw,
 
 struct prestera_port *prestera_find_port(struct prestera_switch *sw, u32 id)
 {
-	struct prestera_port *port = NULL;
+	struct prestera_port *port = NULL, *tmp;
 
 	read_lock(&sw->port_list_lock);
-	list_for_each_entry(port, &sw->port_list, list) {
-		if (port->id == id)
+	list_for_each_entry(tmp, &sw->port_list, list) {
+		if (tmp->id == id) {
+			port = tmp;
 			break;
+		}
 	}
 	read_unlock(&sw->port_list_lock);
 
-- 
2.34.1



