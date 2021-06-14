Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 908B13A647A
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234712AbhFNLZU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:25:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:52792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235591AbhFNLWe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:22:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2BCF61482;
        Mon, 14 Jun 2021 10:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667978;
        bh=4nV3/BeEgo/DV38BQTjloHoYRjcZGmt8Old9ymBqRC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iP7fRbTarJ+4mwBY0EWIDjj3FFKongBnmSWPlAEZ4pzr+znYbxFMKwltUNhrFgIGh
         kVTHg09MlNyD2TnoiodCqA1SBtVZdakrj0UCL1g7KdYH8zoYWW/zBr/pfxoAS64/XF
         GNQbjymvinEpMn1ppq/cddJuLuAqcnX/XRHruKvs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>,
        Yang Li <yang.lee@linux.alibaba.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.12 148/173] phy: ti: Fix an error code in wiz_probe()
Date:   Mon, 14 Jun 2021 12:28:00 +0200
Message-Id: <20210614102703.096241812@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Li <yang.lee@linux.alibaba.com>

commit b8203ec7f58ae925e10fadd3d136073ae7503a6e upstream.

When the code execute this if statement, the value of ret is 0.
However, we can see from the dev_err() log that the value of
ret should be -EINVAL.

Clean up smatch warning:

drivers/phy/ti/phy-j721e-wiz.c:1216 wiz_probe() warn: missing error code 'ret'

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Fixes: c9f9eba06629 ("phy: ti: j721e-wiz: Manage typec-gpio-dir")
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Link: https://lore.kernel.org/r/1621939832-65535-1-git-send-email-yang.lee@linux.alibaba.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/ti/phy-j721e-wiz.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/phy/ti/phy-j721e-wiz.c
+++ b/drivers/phy/ti/phy-j721e-wiz.c
@@ -894,6 +894,7 @@ static int wiz_probe(struct platform_dev
 
 		if (wiz->typec_dir_delay < WIZ_TYPEC_DIR_DEBOUNCE_MIN ||
 		    wiz->typec_dir_delay > WIZ_TYPEC_DIR_DEBOUNCE_MAX) {
+			ret = -EINVAL;
 			dev_err(dev, "Invalid typec-dir-debounce property\n");
 			goto err_addr_to_resource;
 		}


