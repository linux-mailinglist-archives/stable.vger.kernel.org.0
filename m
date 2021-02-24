Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3CCE323DC0
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233529AbhBXNPv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:15:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:58102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235899AbhBXNIB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 08:08:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3DC9C64F86;
        Wed, 24 Feb 2021 12:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171277;
        bh=g9d5o9CMSORlYs0gjGK9mmhQhciTilxiXlvuspDOZhE=;
        h=From:To:Cc:Subject:Date:From;
        b=I0tqgeU7DQ7WHUivY72+2lYetfdsy5uTzbxjcTEBWB0QctPb3zry+EXGPcKoW7reg
         ccH8IGT98bv6ELpxuKt970r5KBQmctTNnFazRLNzZDVI9i06siE8BwV9xb0/MraQ+2
         UvYrD4ijOKphqK/7RpIxIhGQiVfxm8S3A/sNFQLmD1sWmSPYYei8nz17Ho/Zr6t9Vx
         Iy9qqf5qg//Ay2B28vG4u3NQ7bOAt2Ll+fdUFK+2Ab8wOnCAinKBifDw1QMueo0YIQ
         G1BnfGo6ah7HLthnuZKOQK+FJ/u1vUy5PFG8uueKzJDRK2HM/LG5yyYoFrUpYKQ4UY
         N4Ud8o+SATsjQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 4.19 01/26] staging: fwserial: Fix error handling in fwserial_create
Date:   Wed, 24 Feb 2021 07:54:09 -0500
Message-Id: <20210224125435.483539-1-sashal@kernel.org>
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
index fa0dd425b4549..cd062628a46b0 100644
--- a/drivers/staging/fwserial/fwserial.c
+++ b/drivers/staging/fwserial/fwserial.c
@@ -2219,6 +2219,7 @@ static int fwserial_create(struct fw_unit *unit)
 		err = fw_core_add_address_handler(&port->rx_handler,
 						  &fw_high_memory_region);
 		if (err) {
+			tty_port_destroy(&port->port);
 			kfree(port);
 			goto free_ports;
 		}
@@ -2301,6 +2302,7 @@ static int fwserial_create(struct fw_unit *unit)
 
 free_ports:
 	for (--i; i >= 0; --i) {
+		fw_core_remove_address_handler(&serial->ports[i]->rx_handler);
 		tty_port_destroy(&serial->ports[i]->port);
 		kfree(serial->ports[i]);
 	}
-- 
2.27.0

