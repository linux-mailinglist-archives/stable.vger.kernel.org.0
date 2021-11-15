Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 612B84520BF
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239389AbhKPA4Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:56:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:44628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343567AbhKOTVU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67C8963315;
        Mon, 15 Nov 2021 18:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001737;
        bh=PrdEPdqoU2ByDJkAwM6GkmUYbUmBaSRCUltcFW3KoDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AB1yReKPKE8G6NiiBdZRWcnazAT55eoQhSsovtc3A+dpR+PjaMkyz/HrRrpWnMcn3
         y9k2a10AD/ckEHIXJCokzMvGWFqVIHnDCbRMWLJlfoDrPFDVT0e62kZD8WNR8Dy01X
         VuJEs6fVNkAPanOc8TIGDRLJlDFZ5TIcHV6wRL60=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, dirksche <dirksche@posteo.de>,
        Hui Wang <hui.wang@canonical.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 300/917] ACPI: resources: Add one more Medion model in IRQ override quirk
Date:   Mon, 15 Nov 2021 17:56:35 +0100
Message-Id: <20211115165438.934876003@linuxfoundation.org>
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

From: Hui Wang <hui.wang@canonical.com>

[ Upstream commit 1b26ae40092b43bb6e9c5df376227382b390b953 ]

The Medion s17 series laptops have the same issue on the keyboard
as the s15 series, if skipping to call acpi_get_override_irq(), the
keyboard could work well. So put the DMI info of s17 series in the
IRQ override quirk table as well.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=213031
Tested-by: dirksche <dirksche@posteo.de>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/resource.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index 7bf38652e6aca..3c25ce8c95ba1 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -389,6 +389,13 @@ static const struct dmi_system_id medion_laptop[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "M15T"),
 		},
 	},
+	{
+		.ident = "MEDION S17405",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "MEDION"),
+			DMI_MATCH(DMI_BOARD_NAME, "M17T"),
+		},
+	},
 	{ }
 };
 
-- 
2.33.0



