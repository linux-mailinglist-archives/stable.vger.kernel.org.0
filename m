Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 094D5EEDA0
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:08:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390227AbfKDWI3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:08:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:41288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387934AbfKDWIY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:08:24 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57B90205C9;
        Mon,  4 Nov 2019 22:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905303;
        bh=ehCd2uKuzcKZKMe7PXCnQAaDe+V/GG9EgLqTY/lcbkw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jynx4T0+lY4MQK7G5g5yIk1iER/qFCbX94J2AyZXiCZ6qey4nz23WEJ68odBwULv+
         Wn4bxlIYVKHdzt1andPLDwkciJ6+gqKu2cZupnmYgQe6hQ4kc9J2BeWhEh7xRdELoH
         bneS34NHrY8dhfPEE0/SKYh2AADkXRrpy/31UUII=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rajmohan Mani <rajmohan.mani@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 092/163] thunderbolt: Correct path indices for PCIe tunnel
Date:   Mon,  4 Nov 2019 22:44:42 +0100
Message-Id: <20191104212146.842453698@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit ce19f91eae43e39d5a1da55344756ab5a3c7e8d1 ]

PCIe tunnel path indices got mixed up when we added support for tunnels
between switches that are not adjacent. This did not affect the
functionality as it is just an index but fix it now nevertheless to make
the code easier to understand.

Reported-by: Rajmohan Mani <rajmohan.mani@intel.com>
Fixes: 8c7acaaf020f ("thunderbolt: Extend tunnel creation to more than 2 adjacent switches")
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Yehezkel Bernat <YehezkelShB@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/tunnel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/thunderbolt/tunnel.c b/drivers/thunderbolt/tunnel.c
index 31d0234837e45..5a99234826e73 100644
--- a/drivers/thunderbolt/tunnel.c
+++ b/drivers/thunderbolt/tunnel.c
@@ -211,7 +211,7 @@ struct tb_tunnel *tb_tunnel_alloc_pci(struct tb *tb, struct tb_port *up,
 		return NULL;
 	}
 	tb_pci_init_path(path);
-	tunnel->paths[TB_PCI_PATH_UP] = path;
+	tunnel->paths[TB_PCI_PATH_DOWN] = path;
 
 	path = tb_path_alloc(tb, up, TB_PCI_HOPID, down, TB_PCI_HOPID, 0,
 			     "PCIe Up");
@@ -220,7 +220,7 @@ struct tb_tunnel *tb_tunnel_alloc_pci(struct tb *tb, struct tb_port *up,
 		return NULL;
 	}
 	tb_pci_init_path(path);
-	tunnel->paths[TB_PCI_PATH_DOWN] = path;
+	tunnel->paths[TB_PCI_PATH_UP] = path;
 
 	return tunnel;
 }
-- 
2.20.1



