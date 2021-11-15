Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41D1F451056
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:43:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242625AbhKOSq0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:46:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:50450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242331AbhKOSmy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:42:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2EC063314;
        Mon, 15 Nov 2021 18:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999542;
        bh=PrdEPdqoU2ByDJkAwM6GkmUYbUmBaSRCUltcFW3KoDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o/t42dGL5tBUdHbtyu+/rWBoUbkhGwJw75Gn5X1cEVhisp8X9rVRUy3L3sbf/HZ/w
         MDCGLJlk8knABGQi5o8QXEmEm/niobWwtD8fEhZM3LR165q0LxaNf6hr4hUb853VHb
         XQYdUBKZPkM6CjrRSilYX/QhIp+AyEQe9Rchba4o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, dirksche <dirksche@posteo.de>,
        Hui Wang <hui.wang@canonical.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 318/849] ACPI: resources: Add one more Medion model in IRQ override quirk
Date:   Mon, 15 Nov 2021 17:56:41 +0100
Message-Id: <20211115165431.000503288@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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



