Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AABB1CAFB9
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbgEHNTf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:19:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:37602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728867AbgEHMlu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:41:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7AD7124970;
        Fri,  8 May 2020 12:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941709;
        bh=yShE1avA9kFy3YW+Z3J90wWk1PSiq10EV6ZLta9UE6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HaI9vS1EUFYgQ2CEJy6R/gu281eC7PGMNc3LkiX8MiQdqy5hUDTCN31Wkb9vx9y4I
         /2dmzzgdzHN9dK9nlSzBsH/E4oZlkP4jUzf+zwMlaGSZl15hB7QQkoEbpbG8DPNGlN
         tw/8SKtATJWto4sLXhpJgSr4y65Gd9GNte6PLmyE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuanxiao Dong <chuanxiao.dong@intel.com>,
        Pawel Wodkowski <pawelx.wodkowski@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.4 140/312] mmc: debugfs: correct wrong voltage value
Date:   Fri,  8 May 2020 14:32:11 +0200
Message-Id: <20200508123134.331025180@linuxfoundation.org>
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

From: Chuanxiao Dong <chuanxiao.dong@intel.com>

commit 0036e74686344f1051afc3107740140abfd03616 upstream.

Correct the wrong voltage value shown in debugfs for mmc/sd/sdio.

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
Signed-off-by: Pawel Wodkowski <pawelx.wodkowski@intel.com>
Fixes: 42cd95a0603e ("mmc: core: debugfs: Add signal_voltage to ios dump")
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/core/debugfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/core/debugfs.c
+++ b/drivers/mmc/core/debugfs.c
@@ -170,7 +170,7 @@ static int mmc_ios_show(struct seq_file
 		str = "invalid";
 		break;
 	}
-	seq_printf(s, "signal voltage:\t%u (%s)\n", ios->chip_select, str);
+	seq_printf(s, "signal voltage:\t%u (%s)\n", ios->signal_voltage, str);
 
 	switch (ios->drv_type) {
 	case MMC_SET_DRIVER_TYPE_A:


