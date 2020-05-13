Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2D571D0E98
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 12:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732965AbgEMJvJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:51:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:51594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387603AbgEMJvI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:51:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AE8E20575;
        Wed, 13 May 2020 09:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363467;
        bh=KaBdmx0FEom7Oa5L1jSWEFIFXl5TMxoTKMFAD99rzvk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OAx7GN0SY1Uo24yWRpjLR6JJUU1F6+NDx44Jc4k6K9MqAjAZjkpWqy0TRj8V93GRL
         VeQm9m59sz1g/5+Ldj/J7gXGMof8nq38pWkh5QIY9eQbmXTvHB6WDClPr+YLcfiee/
         rIs6jzzNgEZD4uQ0mASKT+Bswo112pwBSPFQBGJo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>,
        linux-usb@vger.kernel.org, Stephen Boyd <swboyd@chromium.org>,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Peter Chen <peter.chen@nxp.com>
Subject: [PATCH 5.4 47/90] usb: chipidea: msm: Ensure proper controller reset using role switch API
Date:   Wed, 13 May 2020 11:44:43 +0200
Message-Id: <20200513094413.789775786@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094408.810028856@linuxfoundation.org>
References: <20200513094408.810028856@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

commit 91edf63d5022bd0464788ffb4acc3d5febbaf81d upstream.

Currently we check to make sure there is no error state on the extcon
handle for VBUS when writing to the HS_PHY_GENCONFIG_2 register. When using
the USB role-switch API we still need to write to this register absent an
extcon handle.

This patch makes the appropriate update to ensure the write happens if
role-switching is true.

Fixes: 05559f10ed79 ("usb: chipidea: add role switch class support")
Cc: stable <stable@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Peter Chen <peter.chen@nxp.com>
Link: https://lore.kernel.org/r/20200507004918.25975-2-peter.chen@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/chipidea/ci_hdrc_msm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/chipidea/ci_hdrc_msm.c
+++ b/drivers/usb/chipidea/ci_hdrc_msm.c
@@ -114,7 +114,7 @@ static int ci_hdrc_msm_notify_event(stru
 			hw_write_id_reg(ci, HS_PHY_GENCONFIG_2,
 					HS_PHY_ULPI_TX_PKT_EN_CLR_FIX, 0);
 
-		if (!IS_ERR(ci->platdata->vbus_extcon.edev)) {
+		if (!IS_ERR(ci->platdata->vbus_extcon.edev) || ci->role_switch) {
 			hw_write_id_reg(ci, HS_PHY_GENCONFIG_2,
 					HS_PHY_SESS_VLD_CTRL_EN,
 					HS_PHY_SESS_VLD_CTRL_EN);


