Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0B28421038
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238142AbhJDNls (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:41:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:51592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238284AbhJDNkN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:40:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B05D663251;
        Mon,  4 Oct 2021 13:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353496;
        bh=yV1Umhyi5YtwnfzNNWLC/Qa59ninjl6oXpt8uC/eaXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ywu85c1Z20oydW0etzUxoPPKGeIcftq0yJyCy0JTubCm+9pRrTcaalGlwFACzdf5a
         +lMOzKX1eMURkPy7kfDYYEA/lA/Y7hq7XslWTGQGZKJQWnBqUNI4VDmAYvYXArGEKc
         Og9KRaLLCQXSH8+jApc40Ex7uxMX/xaU1ICXSJZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.14 151/172] ipack: ipoctal: fix missing allocation-failure check
Date:   Mon,  4 Oct 2021 14:53:21 +0200
Message-Id: <20211004125049.847250379@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 445c8132727728dc297492a7d9fc074af3e94ba3 upstream.

Add the missing error handling when allocating the transmit buffer to
avoid dereferencing a NULL pointer in write() should the allocation
ever fail.

Fixes: ba4dc61fe8c5 ("Staging: ipack: add support for IP-OCTAL mezzanine board")
Cc: stable@vger.kernel.org      # 3.5
Acked-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20210917114622.5412-5-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ipack/devices/ipoctal.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/ipack/devices/ipoctal.c
+++ b/drivers/ipack/devices/ipoctal.c
@@ -386,7 +386,9 @@ static int ipoctal_inst_slot(struct ipoc
 
 		channel = &ipoctal->channel[i];
 		tty_port_init(&channel->tty_port);
-		tty_port_alloc_xmit_buf(&channel->tty_port);
+		res = tty_port_alloc_xmit_buf(&channel->tty_port);
+		if (res)
+			continue;
 		channel->tty_port.ops = &ipoctal_tty_port_ops;
 
 		ipoctal_reset_stats(&channel->stats);


