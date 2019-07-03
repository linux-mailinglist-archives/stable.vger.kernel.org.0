Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 792375DB6C
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 04:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727549AbfGCCPY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 22:15:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:53718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727543AbfGCCPX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 22:15:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1660F2189E;
        Wed,  3 Jul 2019 02:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562120122;
        bh=ELkTw3wZi3L1EYVVesXt+nSyIepduEEIfGOW6PxZqIc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xhCju3dTby1h3aEBZuWID49PLKnoNtXzPFOHkGK/DKPINAKcuo9LWfshQZS03KT+9
         HXu0/xXMBOwfax5ng+8nOuANuoE+6Q+y4Hz9wUm4rxhmt1UqVueL5hJF3dev5rdkLF
         HxfOmJLN5w6AmtP4hSZ0EMcKOH03rAxo4vKvkV2s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-efi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 07/39] efi/bgrt: Drop BGRT status field reserved bits check
Date:   Tue,  2 Jul 2019 22:14:42 -0400
Message-Id: <20190703021514.17727-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190703021514.17727-1-sashal@kernel.org>
References: <20190703021514.17727-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit a483fcab38b43fb34a7f12ab1daadd3907f150e2 ]

Starting with ACPI 6.2 bits 1 and 2 of the BGRT status field are no longer
reserved. These bits are now used to indicate if the image needs to be
rotated before being displayed.

The first device using these bits has now shown up (the GPD MicroPC) and
the reserved bits check causes us to reject the valid BGRT table on this
device.

Rather then changing the reserved bits check, allowing only the 2 new bits,
instead just completely remove it so that we do not end up with a similar
problem when more bits are added in the future.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/efi-bgrt.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/firmware/efi/efi-bgrt.c b/drivers/firmware/efi/efi-bgrt.c
index a2384184a7de..b07c17643210 100644
--- a/drivers/firmware/efi/efi-bgrt.c
+++ b/drivers/firmware/efi/efi-bgrt.c
@@ -47,11 +47,6 @@ void __init efi_bgrt_init(struct acpi_table_header *table)
 		       bgrt->version);
 		goto out;
 	}
-	if (bgrt->status & 0xfe) {
-		pr_notice("Ignoring BGRT: reserved status bits are non-zero %u\n",
-		       bgrt->status);
-		goto out;
-	}
 	if (bgrt->image_type != 0) {
 		pr_notice("Ignoring BGRT: invalid image type %u (expected 0)\n",
 		       bgrt->image_type);
-- 
2.20.1

