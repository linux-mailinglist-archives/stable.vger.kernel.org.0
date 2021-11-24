Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C236E45BB5B
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:16:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241542AbhKXMTT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:19:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:48834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242172AbhKXMQo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:16:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6066761074;
        Wed, 24 Nov 2021 12:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755832;
        bh=Ti0Ej9r8HZ8VAMUFsVuclQHzQJQ2MpLqfWNEcax3uI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XnmaLj72GoI854LX0klcFUCONbemnNbeQvOuGxdtINgX+Lfd6qriV759UybhZXrc1
         I9YzMMChjklWa2TimFXD5PSiu582Wh2M3h5FdHg92cbllX2gUvpjJ5+MlyAHJElmLq
         5aHYtLOJIT6Y0H+CvyinDj1cj7mBcvqBfZd0UEAg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@collabora.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 074/207] ACPI: battery: Accept charges over the design capacity as full
Date:   Wed, 24 Nov 2021 12:55:45 +0100
Message-Id: <20211124115706.309795379@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115703.941380739@linuxfoundation.org>
References: <20211124115703.941380739@linuxfoundation.org>
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
index 93ecae55fe6a0..69c6f02f16b5b 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -187,7 +187,7 @@ static int acpi_battery_is_charged(struct acpi_battery *battery)
 		return 1;
 
 	/* fallback to using design values for broken batteries */
-	if (battery->design_capacity == battery->capacity_now)
+	if (battery->design_capacity <= battery->capacity_now)
 		return 1;
 
 	/* we don't do any sort of metric based on percentages */
-- 
2.33.0



