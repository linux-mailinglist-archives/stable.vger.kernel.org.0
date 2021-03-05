Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3002632E856
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbhCEM0U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:26:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:33370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231300AbhCEMZ6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:25:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39A276502A;
        Fri,  5 Mar 2021 12:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947157;
        bh=/rxuu6LmRXOwkLaxMwFznu8dHOi9leJrRWo45P0GUxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zKT3fpECxlfv+BqMeXa03oF/Qexmk9Q/g8lzk6bEKfPWL/Wq+NQJdOKnBhsiZktiT
         5a+c7SaPZ9enFLprhkbM8fMIjSylLzRqsxOAOS/yh5bskVLKM+SIkQYtcrO0JEfpNs
         FLxmOIpAvIll6GTfgrADPhF9lf72huEoCYhfdcNo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 039/104] staging: fwserial: Fix error handling in fwserial_create
Date:   Fri,  5 Mar 2021 13:20:44 +0100
Message-Id: <20210305120905.084528698@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.166929741@linuxfoundation.org>
References: <20210305120903.166929741@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index db83d34cd677..c368082aae1a 100644
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
@@ -2271,6 +2272,7 @@ unregister_ttys:
 
 free_ports:
 	for (--i; i >= 0; --i) {
+		fw_core_remove_address_handler(&serial->ports[i]->rx_handler);
 		tty_port_destroy(&serial->ports[i]->port);
 		kfree(serial->ports[i]);
 	}
-- 
2.30.1



