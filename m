Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5AA5304B0F
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 22:14:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728758AbhAZEvo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:51:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:33404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730482AbhAYSrD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:47:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30E01224D4;
        Mon, 25 Jan 2021 18:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600375;
        bh=K2xc2xit7HVlr8dwqiW8Aa4nPKfltkIqn/hGi4GTTUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gp6wsh2uxdOezZI51ClDu7OVvBthEi0FDUVdA6Zu98XdI5XSWAL56xoZUFZsuTtnB
         lQuXVdkxNMlTHiKX7Wbq/sVwe0NaxcfiXZ7dU7D51G7cZ5YhwLbHyoK+SfXVMWrHcP
         MrSHiU0Bpt5j2zHpTfIjsKifFVExsVE4KxaQFm70=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 47/86] platform/x86: intel-vbtn: Drop HP Stream x360 Convertible PC 11 from allow-list
Date:   Mon, 25 Jan 2021 19:39:29 +0100
Message-Id: <20210125183203.054104237@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183201.024962206@linuxfoundation.org>
References: <20210125183201.024962206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 070222731be52d741e55d8967b1764482b81e54c ]

THe HP Stream x360 Convertible PC 11 DSDT has the following VGBS function:

            Method (VGBS, 0, Serialized)
            {
                If ((^^PCI0.LPCB.EC0.ROLS == Zero))
                {
                    VBDS = Zero
                }
                Else
                {
                    VBDS = Zero
                }

                Return (VBDS) /* \_SB_.VGBI.VBDS */
            }

Which is obviously wrong, because it always returns 0 independent of the
2-in-1 being in laptop or tablet mode. This causes the intel-vbtn driver
to initially report SW_TABLET_MODE = 1 to userspace, which is known to
cause problems when the 2-in-1 is actually in laptop mode.

During earlier testing this turned out to not be a problem because the
2-in-1 would do a Notify(..., 0xCC) or Notify(..., 0xCD) soon after
the intel-vbtn driver loaded, correcting the SW_TABLET_MODE state.

Further testing however has shown that this Notify() soon after the
intel-vbtn driver loads, does not always happen. When the Notify
does not happen, then intel-vbtn reports SW_TABLET_MODE = 1 resulting in
a non-working touchpad.

IOW the tablet-mode reporting is not reliable on this device, so it
should be dropped from the allow-list, fixing the touchpad sometimes
not working.

Fixes: 8169bd3e6e19 ("platform/x86: intel-vbtn: Switch to an allow-list for SW_TABLET_MODE reporting")
Link: https://lore.kernel.org/r/20210114143432.31750-1-hdegoede@redhat.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel-vbtn.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/platform/x86/intel-vbtn.c b/drivers/platform/x86/intel-vbtn.c
index bc8b0098d4f32..37035dca469cf 100644
--- a/drivers/platform/x86/intel-vbtn.c
+++ b/drivers/platform/x86/intel-vbtn.c
@@ -191,12 +191,6 @@ static const struct dmi_system_id dmi_switches_allow_list[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Venue 11 Pro 7130"),
 		},
 	},
-	{
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "HP Stream x360 Convertible PC 11"),
-		},
-	},
 	{
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-- 
2.27.0



