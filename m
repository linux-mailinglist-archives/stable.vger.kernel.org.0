Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1476323D63
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:11:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234319AbhBXNJP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:09:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:58102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235221AbhBXNDo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 08:03:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8FF164F5A;
        Wed, 24 Feb 2021 12:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171222;
        bh=p+lxkQWic3CI9G0twMBf/txJ+MWfriResU2klUeS94A=;
        h=From:To:Cc:Subject:Date:From;
        b=JphrkeRDpqQcxN4OJuXGIpzlmEqWCsV5SjPGgOHeG+kYZWsdGPJU6DWtDI4rMpDLP
         bLPUP88A/5MV6DefdHvr6Hc1oVuqNa9lgAUU68Iyu/LhTl0aMSEdr5Javej2ozZc6a
         Jmx5q8I69RPlaWMDtphEJvEtjai0VUNCiDLLSuz6fCS3NOCSpYVYmg4OotSGxpPItP
         ulcQ9te4OTAKgmc4URWCea8HtkzNo/i36swdFF2ihOLkPh0lUKSfzRag5lXmZxt0Qi
         jU0EJvyyHwun4nZjH1IbGOv2WFGGwLqZGM5xZqj2oo9QkDfzKZ99fXuyuLbYLnbRuV
         7N8BQMA2klfjQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 5.4 01/40] staging: fwserial: Fix error handling in fwserial_create
Date:   Wed, 24 Feb 2021 07:53:01 -0500
Message-Id: <20210224125340.483162-1-sashal@kernel.org>
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
index aec0f19597a94..4df6e3c1ea96c 100644
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

