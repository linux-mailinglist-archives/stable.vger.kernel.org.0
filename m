Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FEE513F2A1
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389822AbgAPRYG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:24:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:57078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390071AbgAPRND (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:13:03 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17E5B246A1;
        Thu, 16 Jan 2020 17:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194782;
        bh=q1ncPLTAFlH3nr9CJUFHxdP7vHGcDmJ0gaWk0Z3OZhY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=riCIdXdu3VQEC1LCS2jT8uQgUmcvMk+27g5WShRaIKL2kGybv1+3TFOEz5n2ouArC
         54C7t0LWG/poHsZASIpco/aln7e3AyXV8v2DIciY13XZXtJgJFylz80QSnNZ+5dWtx
         DF2BslKqjqKEiknRn8cwqHUYHPczz/E1qBjsZxL0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jean Delvare <jdelvare@suse.de>, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 598/671] firmware: dmi: Fix unlikely out-of-bounds read in save_mem_devices
Date:   Thu, 16 Jan 2020 12:03:56 -0500
Message-Id: <20200116170509.12787-335-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
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
index f2483548cde9..0dc0c78f1fdb 100644
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

