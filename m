Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72F0B323D0F
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:06:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234158AbhBXNCy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:02:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:54798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233784AbhBXM5v (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 07:57:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0731264EEC;
        Wed, 24 Feb 2021 12:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171135;
        bh=eCfR+cBHLD+jMgzOIVNBlxgpUeCyGZEkdHxa5BAiMec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l4zBUeOQG8tW5khDx3zdMhbTPm7VONYq2NQrIsZTsJbyLtWtdZxFItAWLg2DcBV+O
         K5g+SVC2c0Ph5GBMKYEdL9ShiOqXlu1c+3qvtQMI4WuPPQ5w4igCFqWgxyWpI8qkzc
         P1JIpkT9sg/fjfJxa48V2tAzdccuq6tA59pilMWWUp3ljRa18EnvnDDRiBZ4RYy2UZ
         5ixQ+rGAdMJwQfXBfRlEvbcOdrSQjMPcEzK8HJJqLi/UCG4GpvA4ErAxxfdaIzV3Zy
         810w7HgOyMhcVd2SzFvk76rMYzfgQUnVEntQ+8tcFsNFn8ZNtJ/7wy1/wKCO9JIHq6
         Wz1HTK0++dD1Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 5.10 02/56] staging: fwserial: Fix error handling in fwserial_create
Date:   Wed, 24 Feb 2021 07:51:18 -0500
Message-Id: <20210224125212.482485-2-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125212.482485-1-sashal@kernel.org>
References: <20210224125212.482485-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit f31559af97a0eabd467e4719253675b7dccb8a46 ]

When fw_core_add_address_handler() fails, we need to destroy
the port by tty_port_destroy(). Also we need to unregister
the address handler by fw_core_remove_address_handler() on
failure.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Link: https://lore.kernel.org/r/20201221122437.10274-1-dinghao.liu@zju.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/fwserial/fwserial.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/fwserial/fwserial.c b/drivers/staging/fwserial/fwserial.c
index db83d34cd6779..c368082aae1aa 100644
--- a/drivers/staging/fwserial/fwserial.c
+++ b/drivers/staging/fwserial/fwserial.c
@@ -2189,6 +2189,7 @@ static int fwserial_create(struct fw_unit *unit)
 		err = fw_core_add_address_handler(&port->rx_handler,
 						  &fw_high_memory_region);
 		if (err) {
+			tty_port_destroy(&port->port);
 			kfree(port);
 			goto free_ports;
 		}
@@ -2271,6 +2272,7 @@ static int fwserial_create(struct fw_unit *unit)
 
 free_ports:
 	for (--i; i >= 0; --i) {
+		fw_core_remove_address_handler(&serial->ports[i]->rx_handler);
 		tty_port_destroy(&serial->ports[i]->port);
 		kfree(serial->ports[i]);
 	}
-- 
2.27.0

