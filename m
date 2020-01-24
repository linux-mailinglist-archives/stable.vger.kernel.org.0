Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 742EE14833D
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:35:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404530AbgAXLe2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:34:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:54334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404390AbgAXLe1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:34:27 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3E0C222C2;
        Fri, 24 Jan 2020 11:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865667;
        bh=UK7m25F9ZMBaMWRSv7Q+Giy/+sHLZXHNYPoDUZnqReA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xnFDemwUJYhsKzvvLL5ggjh0h1Cx5VOKOBXlBPcjCNhhPPKVFC89a52GmAuATRIIs
         dZ0cEvUqhWkkEZTTLeNssFZ1PTvXaxvEtO7hiEicxZ9Hh97mvfLsWe73n4ZugAP6Ya
         pqUOBj5ou+4ItWzS9micvGvfaZ6DxoFM6ZiNDx7Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jean Delvare <jdelvare@suse.de>,
        Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 607/639] firmware: dmi: Fix unlikely out-of-bounds read in save_mem_devices
Date:   Fri, 24 Jan 2020 10:32:57 +0100
Message-Id: <20200124093205.524880961@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



