Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF0B2D9F7B
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 19:46:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387906AbgLNSoP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 13:44:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:48120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502287AbgLNRh5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:37:57 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 067/105] platform/x86: thinkpad_acpi: Add BAT1 is primary battery quirk for Thinkpad Yoga 11e 4th gen
Date:   Mon, 14 Dec 2020 18:28:41 +0100
Message-Id: <20201214172558.495273574@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214172555.280929671@linuxfoundation.org>
References: <20201214172555.280929671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit c986a7024916c92a775fc8d853fba3cae1d5fde4 ]

The Thinkpad Yoga 11e 4th gen with the N3450 / Celeron CPU only has
one battery which is named BAT1 instead of the expected BAT0, add a
quirk for this. This fixes not being able to set the charging tresholds
on this model; and this alsoe fixes the following errors in dmesg:

ACPI: \_SB_.PCI0.LPCB.EC__.HKEY: BCTG evaluated but flagged as error
thinkpad_acpi: Error probing battery 2
battery: extension failed to load: ThinkPad Battery Extension
battery: extension unregistered: ThinkPad Battery Extension

Note that the added quirk is for the "R0K" BIOS versions which are
used on the Thinkpad Yoga 11e 4th gen's with a Celeron CPU, there
is a separate "R0L" BIOS for the i3/i5 based versions. This may also
need the same quirk, but if that really is necessary is unknown.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20201109103550.16265-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/thinkpad_acpi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index cd7e782791c71..c7e9c0d29ed93 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -9704,6 +9704,7 @@ static const struct tpacpi_quirk battery_quirk_table[] __initconst = {
 	TPACPI_Q_LNV3('R', '0', 'B', true), /* Thinkpad 11e gen 3 */
 	TPACPI_Q_LNV3('R', '0', 'C', true), /* Thinkpad 13 */
 	TPACPI_Q_LNV3('R', '0', 'J', true), /* Thinkpad 13 gen 2 */
+	TPACPI_Q_LNV3('R', '0', 'K', true), /* Thinkpad 11e gen 4 celeron BIOS */
 };
 
 static int __init tpacpi_battery_init(struct ibm_init_struct *ibm)
-- 
2.27.0



