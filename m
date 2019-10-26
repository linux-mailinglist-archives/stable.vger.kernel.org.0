Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E19FE5B20
	for <lists+stable@lfdr.de>; Sat, 26 Oct 2019 15:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726677AbfJZNUk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Oct 2019 09:20:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:42374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728662AbfJZNUh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 26 Oct 2019 09:20:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0C2E214DA;
        Sat, 26 Oct 2019 13:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572096036;
        bh=UK7m25F9ZMBaMWRSv7Q+Giy/+sHLZXHNYPoDUZnqReA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mgYkX2l7l1I7nPvzxO5v8pnTrxrQvQ6wFf5BTQMtUAy32wW/SKq05NWcJTNH64+Mh
         V/FkipgYTSKLbRqr1Ai0fsBGazX34UVuno6VQ3Sty/O8QKg16KpUNEUrko12ZhZDFp
         EWMYUjkYGYPTfpOhwUeBGoJeWfn2L5lEPIkVASbk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jean Delvare <jdelvare@suse.de>, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 45/59] firmware: dmi: Fix unlikely out-of-bounds read in save_mem_devices
Date:   Sat, 26 Oct 2019 09:18:56 -0400
Message-Id: <20191026131910.3435-45-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026131910.3435-1-sashal@kernel.org>
References: <20191026131910.3435-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jean Delvare <jdelvare@suse.de>

[ Upstream commit 81dde26de9c08bb04c4962a15608778aaffb3cf9 ]

Before reading the Extended Size field, we should ensure it fits in
the DMI record. There is already a record length check but it does
not cover that field.

It would take a seriously corrupted DMI table to hit that bug, so no
need to worry, but we should still fix it.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Fixes: 6deae96b42eb ("firmware, DMI: Add function to look up a handle and return DIMM size")
Cc: Tony Luck <tony.luck@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/dmi_scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index f2483548cde92..0dc0c78f1fdb2 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -407,7 +407,7 @@ static void __init save_mem_devices(const struct dmi_header *dm, void *v)
 		bytes = ~0ull;
 	else if (size & 0x8000)
 		bytes = (u64)(size & 0x7fff) << 10;
-	else if (size != 0x7fff)
+	else if (size != 0x7fff || dm->length < 0x20)
 		bytes = (u64)size << 20;
 	else
 		bytes = (u64)get_unaligned((u32 *)&d[0x1C]) << 20;
-- 
2.20.1

