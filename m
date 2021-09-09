Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E42BC404BCE
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 13:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238199AbhIILxO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 07:53:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:55120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241447AbhIILu7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:50:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5092C6135E;
        Thu,  9 Sep 2021 11:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187840;
        bh=6+FigFe1JfRp3EsUrqy4XkTFd6p4WNxKygRAKeaCjxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LiizHbSSrEO9pcSVyKt+0gJj9EBSUIxEt7HKK1VnOA6MYwtTk7/xSE5BdxwnWASDO
         Nolo1VA7IIJQWmaMADuwX5XmRKl6O06K+VM9MZWDtKIYn1FKnUmFQ7L+LqXDmd5Wj7
         o5HRftaQnmJpTPKiRYVRaXDR3wSpeCDrtmGQmnqq0+jblmHEUZ4CV1scQd8mvzTNq0
         P9VdQl/iLEDbW1HygGnuEffPo/c5nfKUB4YhtUdTqfq66PK+TLRjGP9+u34Zg+hy6s
         oZ7yIg5V1EE2xIxInU2SU4cjhdqrDq7NZFcPOWtnYZWCVkcDstvv7wzTTcybzDINVk
         XN96yw2sc8iqg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sanjay R Mehta <sanju.mehta@amd.com>,
        Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 134/252] thunderbolt: Fix port linking by checking all adapters
Date:   Thu,  9 Sep 2021 07:39:08 -0400
Message-Id: <20210909114106.141462-134-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
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

