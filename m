Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8562595EA
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731779AbgIAPoX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:44:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:59410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731765AbgIAPoP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:44:15 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 349ED2078B;
        Tue,  1 Sep 2020 15:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598975054;
        bh=Hy/SOJSKymP9hZrqWCp1kQC+Gkk7VLhfV597FCeJXOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u1X0emPxxjJhSryCqw7LOE7TVdQ9BO8uA3+/uPhf63S7TgeGDzgMh2oXjeCOHV+k+
         R0S9bbYvlsgbbT0TJ10BcYVjV9M2WPp3AZVD3byIP4eTgqsqKswqW7yFx4XhcN1Iv0
         xRWLsKl53yEHmAL4eobedgBAQGoqPq2gwnIaZD58=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, JC Kuo <jckuo@nvidia.com>
Subject: [PATCH 5.8 192/255] usb: host: xhci-tegra: otg usb2/usb3 port init
Date:   Tue,  1 Sep 2020 17:10:48 +0200
Message-Id: <20200901151009.888468229@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: JC Kuo <jckuo@nvidia.com>

commit 316a2868bc269be8c6e69ccc3a1f902a3f518eb9 upstream.

tegra_xusb_init_usb_phy() should initialize "otg_usb2_port" and
"otg_usb3_port" with -EINVAL because "0" is a valid value
represents usb2 port 0 or usb3 port 0.

Signed-off-by: JC Kuo <jckuo@nvidia.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200811093143.699541-1-jckuo@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-tegra.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/host/xhci-tegra.c
+++ b/drivers/usb/host/xhci-tegra.c
@@ -1258,6 +1258,8 @@ static int tegra_xusb_init_usb_phy(struc
 
 	INIT_WORK(&tegra->id_work, tegra_xhci_id_work);
 	tegra->id_nb.notifier_call = tegra_xhci_id_notify;
+	tegra->otg_usb2_port = -EINVAL;
+	tegra->otg_usb3_port = -EINVAL;
 
 	for (i = 0; i < tegra->num_usb_phys; i++) {
 		struct phy *phy = tegra_xusb_get_phy(tegra, "usb2", i);


