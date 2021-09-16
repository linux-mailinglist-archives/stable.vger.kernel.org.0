Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 130FF40E786
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353457AbhIPRdz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:33:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:50250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244752AbhIPRbv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:31:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D5D361A61;
        Thu, 16 Sep 2021 16:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810825;
        bh=6+FigFe1JfRp3EsUrqy4XkTFd6p4WNxKygRAKeaCjxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qoNdNFNNL5544OXUeFyo59SaNwQaKGXVW0eZQAz4umyzT8albjSHtfMEGCTq5Ym09
         qKVdQB+UEzAGXTSLHo8L6WcScOH/8PooXbsjUUV69+nIYp9XmuEYIe8hR65TYWVIeM
         Y8o9bY/Si6CIALeU2GNTzyARwZjC7bXceUsJ9moQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
        Sanjay R Mehta <sanju.mehta@amd.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 282/432] thunderbolt: Fix port linking by checking all adapters
Date:   Thu, 16 Sep 2021 18:00:31 +0200
Message-Id: <20210916155820.371039093@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 10d6b228cc94..eec59030c3a7 100644
--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -2443,7 +2443,7 @@ static void tb_switch_default_link_ports(struct tb_switch *sw)
 {
 	int i;
 
-	for (i = 1; i <= sw->config.max_port_number; i += 2) {
+	for (i = 1; i <= sw->config.max_port_number; i++) {
 		struct tb_port *port = &sw->ports[i];
 		struct tb_port *subordinate;
 
-- 
2.30.2



