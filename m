Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED9361CAEB3
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729383AbgEHMqE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:46:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:46672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729379AbgEHMqE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:46:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5723E21974;
        Fri,  8 May 2020 12:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941963;
        bh=g4WT/0Luytmj+bB8cBS0Q6y7yxtIPAPrHbE4ISTax3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GojCOFnbN/4W1bErvhqcUIKRQvLTxxLZVkNZRIi+9zNcbKLZ+ErL8R0eoQ0By9giF
         GGUYZusQUP8Z6T/yx+/KC1rjFGU0x9uSHheNXbjliItT1n2CPB/29ccx++MzmkojvZ
         u/7V2MQj7E8kAnJz0yJGl8YoTWyDPVBLtAZSh2RQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 243/312] net: dsa: mv88e6xxx: unlock DSA and CPU ports
Date:   Fri,  8 May 2020 14:33:54 +0200
Message-Id: <20200508123141.513600992@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>

commit 65fa40276ac1318e75264e5a204547b57c2cf397 upstream.

Locking a port generates an hardware interrupt when a new SA address is
received. This enables CPU directed learning, which is needed for 802.1X
MAC authentication.

To disable automatic learning on a port, the only configuration needed
is to set its Port Association Vector to all zero.

Clear PAV when SA learning should be disabled instead of locking a port.

Fixes: 4c7ea3c0791e ("net: dsa: mv88e6xxx: disable SA learning for DSA and CPU ports")
Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/dsa/mv88e6xxx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/dsa/mv88e6xxx.c
+++ b/drivers/net/dsa/mv88e6xxx.c
@@ -2066,7 +2066,7 @@ static int mv88e6xxx_setup_port(struct d
 	reg = 1 << port;
 	/* Disable learning for DSA and CPU ports */
 	if (dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port))
-		reg = PORT_ASSOC_VECTOR_LOCKED_PORT;
+		reg = 0;
 
 	ret = _mv88e6xxx_reg_write(ds, REG_PORT(port), PORT_ASSOC_VECTOR, reg);
 	if (ret)


