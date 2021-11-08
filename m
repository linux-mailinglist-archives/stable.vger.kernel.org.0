Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C67E44A28A
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242940AbhKIBT1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:19:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:44356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243104AbhKIBPF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:15:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C7FC613A6;
        Tue,  9 Nov 2021 01:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419963;
        bh=NEX9F5tlQR/ZiiWHVqR4NwwF82136ZtSd4RehFPZPQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZXaUaHt4CWBzzkhk7IIOJb1YwV3qZOkroL9DFQqxLMLJGG+1wOUI/t/sK/cjcfziG
         G8D6bbw7mJ4aEBNf+yFAL4ErPDY9KGHeeX0xhYiSoaSTDVuC5FK/d+nBKZCUeUqsWT
         lfLWTlXN7VQ2I/eZVx6n/dH1MWi2bWK9fABGgC9ysl6epQQtlI1wPYA6wrIgYc6wap
         Tt19KWD/U/ALPmGLdU1KVZJ//z/YJNuLXJ6kgDRsFOfqgIjf6W6fU28Ke2q/WrxK/3
         lhV3dJuIDWsmJ7UdG/OG6COQ4huGQ+8L1bHwpbEYDeJK9w+Vn44J6Gt+on2pQFHHFp
         5xzl1FdpEFySQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@collabora.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 27/47] ACPI: battery: Accept charges over the design capacity as full
Date:   Mon,  8 Nov 2021 12:50:11 -0500
Message-Id: <20211108175031.1190422-27-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108175031.1190422-1-sashal@kernel.org>
References: <20211108175031.1190422-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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
index 674a0e92b798f..0bbf8b453ebf2 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -198,7 +198,7 @@ static int acpi_battery_is_charged(struct acpi_battery *battery)
 		return 1;
 
 	/* fallback to using design values for broken batteries */
-	if (battery->design_capacity == battery->capacity_now)
+	if (battery->design_capacity <= battery->capacity_now)
 		return 1;
 
 	/* we don't do any sort of metric based on percentages */
-- 
2.33.0

