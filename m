Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47D9A2E6639
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388510AbgL1NXd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:23:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:51666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731665AbgL1NXb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:23:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 554CF206ED;
        Mon, 28 Dec 2020 13:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161796;
        bh=xstIiTdL/JaB9tfEibRhQgl3dK49EDZPT8HZkj5uJvk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nkSKRWdGvi5Az3TQvLCcZPQHOXqtnYW6F5rCRlcMnUSEWzw4Gi5H6X6EJa8uGcopF
         dcgBtKz2Gz53bK8SUvEoUHRyn36dyJIYFmVCrLf4Ryq5FacF9tyWrdxks6HYehwazr
         5A57m+bDb39FvYzGFRRi2eVGuNvoMEcHf1XjAvl8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        Peter Chen <peter.chen@nxp.com>
Subject: [PATCH 4.19 083/346] usb: chipidea: ci_hdrc_imx: Pass DISABLE_DEVICE_STREAMING flag to imx6ul
Date:   Mon, 28 Dec 2020 13:46:42 +0100
Message-Id: <20201228124923.814801307@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>

commit c7721e15f434920145c376e8fe77e1c079fc3726 upstream.

According to the i.MX6UL Errata document:
https://www.nxp.com/docs/en/errata/IMX6ULCE.pdf

ERR007881 also affects i.MX6UL, so pass the
CI_HDRC_DISABLE_DEVICE_STREAMING flag to workaround the issue.

Fixes: 52fe568e5d71 ("usb: chipidea: imx: add imx6ul usb support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Peter Chen <peter.chen@nxp.com>
Link: https://lore.kernel.org/r/20201207020909.22483-2-peter.chen@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/chipidea/ci_hdrc_imx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/chipidea/ci_hdrc_imx.c
+++ b/drivers/usb/chipidea/ci_hdrc_imx.c
@@ -57,7 +57,8 @@ static const struct ci_hdrc_imx_platform
 
 static const struct ci_hdrc_imx_platform_flag imx6ul_usb_data = {
 	.flags = CI_HDRC_SUPPORTS_RUNTIME_PM |
-		CI_HDRC_TURN_VBUS_EARLY_ON,
+		CI_HDRC_TURN_VBUS_EARLY_ON |
+		CI_HDRC_DISABLE_DEVICE_STREAMING,
 };
 
 static const struct ci_hdrc_imx_platform_flag imx7d_usb_data = {


