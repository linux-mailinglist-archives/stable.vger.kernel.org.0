Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 489F0FA3FA
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:16:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729718AbfKMB5S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:57:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:50334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728664AbfKMB5R (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:57:17 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43BC82247A;
        Wed, 13 Nov 2019 01:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610237;
        bh=lFxxBxjXHU5mvLq0/vlgvYPguApXQkNTD64lNsNZdvk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AXEW6sBN7qEHe5jZTblr3TMe9n8/RdGLpHTDKJd3mf+h5Eg+OpDmg58K4LyfwzbkJ
         +ZdMrql9huHOUSp1lYYqPuo+SYtMOH14VWYFFZ71YGFYVyDyDbxOblrrJiwTQbW/ZO
         aBBE7Hao1whqCKmXWAwfnA8zJx8BjKWqak9BJeH8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chen Yu <yu.c.chen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pavel Machek <pavel@ucw.cz>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 037/115] PM / hibernate: Check the success of generating md5 digest before hibernation
Date:   Tue, 12 Nov 2019 20:55:04 -0500
Message-Id: <20191113015622.11592-37-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015622.11592-1-sashal@kernel.org>
References: <20191113015622.11592-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Yu <yu.c.chen@intel.com>

[ Upstream commit 749fa17093ff67b31dea864531a3698b6a95c26c ]

Currently if get_e820_md5() fails, then it will hibernate nevertheless.
Actually the error code should be propagated to upper caller so that
the hibernation could be aware of the result and terminates the process
if md5 digest fails.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Chen Yu <yu.c.chen@intel.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/power/hibernate_64.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/power/hibernate_64.c b/arch/x86/power/hibernate_64.c
index 9c80966c80bae..692a179b1ba32 100644
--- a/arch/x86/power/hibernate_64.c
+++ b/arch/x86/power/hibernate_64.c
@@ -250,9 +250,9 @@ static int get_e820_md5(struct e820_table *table, void *buf)
 	return ret;
 }
 
-static void hibernation_e820_save(void *buf)
+static int hibernation_e820_save(void *buf)
 {
-	get_e820_md5(e820_table_firmware, buf);
+	return get_e820_md5(e820_table_firmware, buf);
 }
 
 static bool hibernation_e820_mismatch(void *buf)
@@ -272,8 +272,9 @@ static bool hibernation_e820_mismatch(void *buf)
 	return memcmp(result, buf, MD5_DIGEST_SIZE) ? true : false;
 }
 #else
-static void hibernation_e820_save(void *buf)
+static int hibernation_e820_save(void *buf)
 {
+	return 0;
 }
 
 static bool hibernation_e820_mismatch(void *buf)
@@ -318,9 +319,7 @@ int arch_hibernation_header_save(void *addr, unsigned int max_size)
 
 	rdr->magic = RESTORE_MAGIC;
 
-	hibernation_e820_save(rdr->e820_digest);
-
-	return 0;
+	return hibernation_e820_save(rdr->e820_digest);
 }
 
 /**
-- 
2.20.1

