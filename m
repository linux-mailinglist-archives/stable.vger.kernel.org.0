Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6AC323E1F
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236625AbhBXNZJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:25:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:59874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234593AbhBXNN7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 08:13:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4BFAA64FB2;
        Wed, 24 Feb 2021 12:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171362;
        bh=nNV1j6p9x8t4HfKqU6mkrYAitIv6CCoRdjNrp01kbGA=;
        h=From:To:Cc:Subject:Date:From;
        b=KrbVa3ZaBKKn7LC/M7AVALH2PtmLt8bHA6H2XX+fdPdzggDALwgfsWyscWummiTjC
         OAeR094uh6QcKBjq0klufi6LgP6HuCZjKSzF3scuGUJDnpGEPJN+DVkJxoHEGH5riJ
         +x2eczpvSoTDWjDDrgy2bDFRxOg5XakxGwpXfPSLTJmvz6BZZwl2THDaMVu/lGEC5A
         tPYnwlJmZuiYOC6arUxCsbPy5pd0Z2WPkzFvo99ODOo0T3F+uRRMN6PkzzYknlcLsj
         YNd+nA4+SVYCQAyJ0qbofBWdsKfyrfLr1NsZz114r0zRBUBq1KlvZsG4d5ltu3hSbc
         9pFq5DwrXZLvg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 4.4 01/11] staging: fwserial: Fix error handling in fwserial_create
Date:   Wed, 24 Feb 2021 07:55:49 -0500
Message-Id: <20210224125600.484437-1-sashal@kernel.org>
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
index b3ea4bb54e2c7..68ed97398fafb 100644
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

