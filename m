Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F184B45BD23
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343965AbhKXMfo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:35:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:53336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344355AbhKXMdi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:33:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0A39611CA;
        Wed, 24 Nov 2021 12:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756445;
        bh=T8kPapjxySRQi2XEtlStghEYlsOPqjHtXX/wn4lH+R0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sxoHh8KELD6Pet2dyefpIkoC21mwD2pjd0KbVpwlWMyIwaU9FUfEHFp1fS8R5Aaf5
         SXcFW/s4cXPhGoG5a+3h9UweP8Cqr5WJ0ITki+9QTPR6d4oBswjdhfoNG7w7sMCoQT
         veW+mqUCYDaxfOsnGPSICkvzqtelxYSIrlNzMmb8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@collabora.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 089/251] ACPI: battery: Accept charges over the design capacity as full
Date:   Wed, 24 Nov 2021 12:55:31 +0100
Message-Id: <20211124115713.342917452@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
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
index 13e7b56e33aeb..30996effc491b 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -193,7 +193,7 @@ static int acpi_battery_is_charged(struct acpi_battery *battery)
 		return 1;
 
 	/* fallback to using design values for broken batteries */
-	if (battery->design_capacity == battery->capacity_now)
+	if (battery->design_capacity <= battery->capacity_now)
 		return 1;
 
 	/* we don't do any sort of metric based on percentages */
-- 
2.33.0



