Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB9E72CD76F
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 14:35:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437131AbgLCNeM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 08:34:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:47922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436814AbgLCNa7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Dec 2020 08:30:59 -0500
From:   Sasha Levin <sashal@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 18/23] platform/x86: thinkpad_acpi: Add BAT1 is primary battery quirk for Thinkpad Yoga 11e 4th gen
Date:   Thu,  3 Dec 2020 08:29:30 -0500
Message-Id: <20201203132935.931362-18-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201203132935.931362-1-sashal@kernel.org>
References: <20201203132935.931362-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index f196a3313690f..8c54d3707fba3 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -9697,6 +9697,7 @@ static const struct tpacpi_quirk battery_quirk_table[] __initconst = {
 	TPACPI_Q_LNV3('R', '0', 'B', true), /* Thinkpad 11e gen 3 */
 	TPACPI_Q_LNV3('R', '0', 'C', true), /* Thinkpad 13 */
 	TPACPI_Q_LNV3('R', '0', 'J', true), /* Thinkpad 13 gen 2 */
+	TPACPI_Q_LNV3('R', '0', 'K', true), /* Thinkpad 11e gen 4 celeron BIOS */
 };
 
 static int __init tpacpi_battery_init(struct ibm_init_struct *ibm)
-- 
2.27.0

