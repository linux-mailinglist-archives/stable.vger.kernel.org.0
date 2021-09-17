Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23E8C40F6D9
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 13:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343960AbhIQLv3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Sep 2021 07:51:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:34226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242201AbhIQLv0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Sep 2021 07:51:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E2C66124B;
        Fri, 17 Sep 2021 11:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631879404;
        bh=dxQVor6via8qaIPEeT2EAuvdI213+neBSW22eKTnxFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e52ADprY8RAbcLDuMT2AbpJNxa+G8cV5SeAQE/aiS5rleGTXW9bNidFH3sSm8R7oy
         opb1sJV8J5RfP+VKfoj0gmIftEZifFDx8n/3StDdPmlo1WMx2OjTbHyZs/Y664kJHS
         eg8+wZHnXdGY4VvTmwIbcwnLTjmUPsWT4wZPgyoAdmc6phYCFBNckHna3GkAbkByHM
         f4BOFo+9j852/sBL0uV/yYLuDnmNJGemBCdrWesTU1czJ6rjjYW+TdeP8PFw0wfe5G
         oTE8ETKJO0R35ib+pBcDFJ2vcqEfxbKuLxzU9e1YC0yrNQ9CBOdVLXqQHO6h2iM1Z6
         0HsgF4zM7Iiiw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mRCNZ-0001RW-T7; Fri, 17 Sep 2021 13:50:05 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     industrypack-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH 4/6] ipack: ipoctal: fix missing allocation-failure check
Date:   Fri, 17 Sep 2021 13:46:20 +0200
Message-Id: <20210917114622.5412-5-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210917114622.5412-1-johan@kernel.org>
References: <20210917114622.5412-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add the missing error handling when allocating the transmit buffer to
avoid dereferencing a NULL pointer in write() should the allocation
ever fail.

Fixes: ba4dc61fe8c5 ("Staging: ipack: add support for IP-OCTAL mezzanine board")
Cc: stable@vger.kernel.org      # 3.5
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/ipack/devices/ipoctal.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/ipack/devices/ipoctal.c b/drivers/ipack/devices/ipoctal.c
index d6875aa6a295..61c41f535510 100644
--- a/drivers/ipack/devices/ipoctal.c
+++ b/drivers/ipack/devices/ipoctal.c
@@ -385,7 +385,9 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 
 		channel = &ipoctal->channel[i];
 		tty_port_init(&channel->tty_port);
-		tty_port_alloc_xmit_buf(&channel->tty_port);
+		res = tty_port_alloc_xmit_buf(&channel->tty_port);
+		if (res)
+			continue;
 		channel->tty_port.ops = &ipoctal_tty_port_ops;
 
 		ipoctal_reset_stats(&channel->stats);
-- 
2.32.0

