Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A40E226A61
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732087AbgGTQdt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:33:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:54978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731718AbgGTPzo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:55:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4747F206E9;
        Mon, 20 Jul 2020 15:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260544;
        bh=JU/XJysNcRRu1Kb+zGOfW3a+h/PlB8XuD3Nr/QZazjU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w4CkkHqfdjp61xQgNVTrsIKRE3S9qrKjgkZ9T6QW4MCLgA1xDc+zyUaxmfAigysJo
         BcTAHhtxRzStxMUFzagBwoPmlBpuq+olJPixoK1SH51i05ekzxQkCN92LTMwHsY9Ri
         ehJzSUckJPUdxBwIfUmoBfW2cBPg/N64+R7yaiMk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lingling Xu <ling_ling.xu@unisoc.com>,
        Chunyan Zhang <chunyan.zhang@unisoc.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.19 133/133] spi: sprd: switch the sequence of setting WDG_LOAD_LOW and _HIGH
Date:   Mon, 20 Jul 2020 17:38:00 +0200
Message-Id: <20200720152810.162934377@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152803.732195882@linuxfoundation.org>
References: <20200720152803.732195882@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lingling Xu <ling_ling.xu@unisoc.com>

commit 8bdd79dae1ff5397351b95e249abcae126572617 upstream.

The watchdog counter consists of WDG_LOAD_LOW and WDG_LOAD_HIGH,
which would be loaded to watchdog counter once writing WDG_LOAD_LOW.

Fixes: ac1775012058 ("spi: sprd: Add the support of restarting the system")
Signed-off-by: Lingling Xu <ling_ling.xu@unisoc.com>
Signed-off-by: Chunyan Zhang <chunyan.zhang@unisoc.com>
Link: https://lore.kernel.org/r/20200602082415.5848-1-zhang.lyra@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-sprd-adi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/spi/spi-sprd-adi.c
+++ b/drivers/spi/spi-sprd-adi.c
@@ -358,9 +358,9 @@ static int sprd_adi_restart_handler(stru
 	sprd_adi_write(sadi, sadi->slave_pbase + REG_WDG_LOCK, WDG_UNLOCK_KEY);
 
 	/* Load the watchdog timeout value, 50ms is always enough. */
+	sprd_adi_write(sadi, sadi->slave_pbase + REG_WDG_LOAD_HIGH, 0);
 	sprd_adi_write(sadi, sadi->slave_pbase + REG_WDG_LOAD_LOW,
 		       WDG_LOAD_VAL & WDG_LOAD_MASK);
-	sprd_adi_write(sadi, sadi->slave_pbase + REG_WDG_LOAD_HIGH, 0);
 
 	/* Start the watchdog to reset system */
 	sprd_adi_read(sadi, sadi->slave_pbase + REG_WDG_CTRL, &val);


