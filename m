Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42BBF323E03
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:26:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232181AbhBXNWI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:22:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:59160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236101AbhBXNNo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 08:13:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B42D664EDD;
        Wed, 24 Feb 2021 12:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171342;
        bh=5GewBWUgrh+lEdBurMpNqciipCz2WPSaxpgR1SNUK/o=;
        h=From:To:Cc:Subject:Date:From;
        b=b5z/9IRVmipn2jGTk6rZCHa+LY6eJ8y/RYeYAAh1eeaT82M6FOwEyS0Bq6R8uT17K
         39/EFWeSpIcTXZUiGkwOJmquJxew2/WGQkqSfyEP86bva+3QAGKcGYX1x+7b32yxVE
         Aa0wsstalWqhGQCrVimGqvj8sx92IKPaFn8lnM5d/7G2DF7soQuJbrONwii+VnMA0J
         DaE5Px6ky9AS4NKlObhaPKExbJcMLY04bz+NivOAu4GsNSCnkspwIWZv9B8pK1Ff8l
         uUiMqrUvZFBgm1nN7CGXqxUNd51plimKZQpC9BlP+tfEfSfJfVIQE3UXB87AslfWA1
         9OQCsbOsE/niA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 4.9 01/12] staging: fwserial: Fix error handling in fwserial_create
Date:   Wed, 24 Feb 2021 07:55:29 -0500
Message-Id: <20210224125540.484221-1-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
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
index 49c718b91e55a..16f6f35954fb5 100644
--- a/drivers/staging/fwserial/fwserial.c
+++ b/drivers/staging/fwserial/fwserial.c
@@ -2255,6 +2255,7 @@ static int fwserial_create(struct fw_unit *unit)
 		err = fw_core_add_address_handler(&port->rx_handler,
 						  &fw_high_memory_region);
 		if (err) {
+			tty_port_destroy(&port->port);
 			kfree(port);
 			goto free_ports;
 		}
@@ -2337,6 +2338,7 @@ static int fwserial_create(struct fw_unit *unit)
 
 free_ports:
 	for (--i; i >= 0; --i) {
+		fw_core_remove_address_handler(&serial->ports[i]->rx_handler);
 		tty_port_destroy(&serial->ports[i]->port);
 		kfree(serial->ports[i]);
 	}
-- 
2.27.0

