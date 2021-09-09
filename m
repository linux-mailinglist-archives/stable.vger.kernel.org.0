Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D34B4051C2
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349376AbhIIMia (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:38:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:38736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352554AbhIIMdC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:33:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6117E61B50;
        Thu,  9 Sep 2021 11:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188402;
        bh=wUMljGhgc5yPRcPZeHQ2QtxN4l0omWgDnImvqWZCzSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HaLUzkwkuGxCo/hO6jxktpcT89pwvYQ6D6g9QR2ofw0OAgT/DgK6c4wL3C4Gketpz
         IXhWXn8vugwo2JPUR3nIsMoICd3QzZtE4D086MwvJUcS3AJt3aUcT7w8yyb+1niBkj
         z77QitjDZ03kUGo5WYbhtTOd9zg/ITG66NinJZkG14YvnC9kLLHq1Pp2cVAyZ4b0qu
         QShscklxhQKwy/guP62rYIYme4xHjE1x7qP7aH4t0K374LOJhgRjTZ0s8muK6bP3mf
         oWTTpjQne3YUlCEI8Ix9Qy3KGxu41+tufRCMMy9UFiRAaGn1k6uqb2ZNf6c8eUCc4n
         1gmACGeuT/9yg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sanjay R Mehta <sanju.mehta@amd.com>,
        Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 096/176] thunderbolt: Fix port linking by checking all adapters
Date:   Thu,  9 Sep 2021 07:49:58 -0400
Message-Id: <20210909115118.146181-96-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115118.146181-1-sashal@kernel.org>
References: <20210909115118.146181-1-sashal@kernel.org>
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
index 9a272a516b2d..c4b157c29af7 100644
--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -2204,7 +2204,7 @@ static void tb_switch_default_link_ports(struct tb_switch *sw)
 {
 	int i;
 
-	for (i = 1; i <= sw->config.max_port_number; i += 2) {
+	for (i = 1; i <= sw->config.max_port_number; i++) {
 		struct tb_port *port = &sw->ports[i];
 		struct tb_port *subordinate;
 
-- 
2.30.2

