Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59983404F13
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345692AbhIIMQv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:16:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:52452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350469AbhIIMNu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:13:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54DE561A60;
        Thu,  9 Sep 2021 11:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188147;
        bh=daVJ+CeMTgyPCrr9ROUkuCNJMWaaTuNOkAp138SSNf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p3IjnmHhcXC457bfYF0pG+UjI2QEPwFzwarkeXXE7Y7zuckdwvLIzX/TcQyRyb24q
         vatcPGxw5weKNMrOgyLzJKMilS9lqnpdBoPU4TwLhY4rwr7W3FyN5G3Yrh/Q79VcZp
         qe38x889QOYpzCqFP0/+RgpgqysY+yezhfpgLoN0CWa8qm2QieLVDI+rtijRvL88+H
         HQ8BaIC3GKibJkYwvUf8HT4GdA9dfuZBc7HA5nrxyu++zpTZOW6oAyOJ9r+bdTCi52
         LgBLcVXFqVl7KaI/nSN61Ti5Y/BqOhdw1AHJ6oA+GNtcFanTJZ0xCnxUhXvf6hBbsl
         UumR4XI1+hNfA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sanjay R Mehta <sanju.mehta@amd.com>,
        Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 117/219] thunderbolt: Fix port linking by checking all adapters
Date:   Thu,  9 Sep 2021 07:44:53 -0400
Message-Id: <20210909114635.143983-117-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sanjay R Mehta <sanju.mehta@amd.com>

[ Upstream commit 42716425ad7e1b6529ec61c260c11176841f4b5f ]

In tb_switch_default_link_ports(), while linking of ports,
only odd-numbered ports (1,3,5..) are considered and even-numbered
ports are not considered.

AMD host router has lane adapters at 2 and 3 and link ports at adapter 2
is not considered due to which lane bonding gets disabled.

Hence added a fix such that all ports are considered during
linking of ports.

Signed-off-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Signed-off-by: Sanjay R Mehta <sanju.mehta@amd.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/switch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thunderbolt/switch.c b/drivers/thunderbolt/switch.c
index a82032c081e8..03229350ea73 100644
--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -2308,7 +2308,7 @@ static void tb_switch_default_link_ports(struct tb_switch *sw)
 {
 	int i;
 
-	for (i = 1; i <= sw->config.max_port_number; i += 2) {
+	for (i = 1; i <= sw->config.max_port_number; i++) {
 		struct tb_port *port = &sw->ports[i];
 		struct tb_port *subordinate;
 
-- 
2.30.2

