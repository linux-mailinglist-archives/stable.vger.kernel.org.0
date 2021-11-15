Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E903245208B
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:52:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345756AbhKPAzi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:55:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:44648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245720AbhKOTVF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0237163287;
        Mon, 15 Nov 2021 18:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001608;
        bh=U6fQnsNKbPTE11NFNlm0+xZgCeG7JwAaZO672gNR+qs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VEUiCdYzBz2Ivn9mldFtBKKss5UAwxHj8KIc6q2J5pa+gWEC2DcD+KHs4oaCSoosm
         vln6Daf/9lYFE5CnfGP76HLCKduPeRXJAWs+uMkW++W0YuFI5n+i4PmGLbzL6KzeeB
         rSlXEZmNQnaUGAk6aTgzIB01qNFY/ceO8i28/744=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@collabora.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 254/917] ACPI: battery: Accept charges over the design capacity as full
Date:   Mon, 15 Nov 2021 17:55:49 +0100
Message-Id: <20211115165437.397894404@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: André Almeida <andrealmeid@collabora.com>

[ Upstream commit 2835f327bd1240508db2c89fe94a056faa53c49a ]

Some buggy firmware and/or brand new batteries can support a charge that's
slightly over the reported design capacity. In such cases, the kernel will
report to userspace that the charging state of the battery is "Unknown",
when in reality the battery charge is "Full", at least from the design
capacity point of view. Make the fallback condition accepts capacities
over the designed capacity so userspace knows that is full.

Signed-off-by: André Almeida <andrealmeid@collabora.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/battery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index dae91f906cea9..8afa85d6eb6a7 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -169,7 +169,7 @@ static int acpi_battery_is_charged(struct acpi_battery *battery)
 		return 1;
 
 	/* fallback to using design values for broken batteries */
-	if (battery->design_capacity == battery->capacity_now)
+	if (battery->design_capacity <= battery->capacity_now)
 		return 1;
 
 	/* we don't do any sort of metric based on percentages */
-- 
2.33.0



