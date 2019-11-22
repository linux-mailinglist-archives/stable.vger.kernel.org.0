Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C92C9106D5B
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:59:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730894AbfKVK7X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:59:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:50328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730906AbfKVK7X (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:59:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28A2A20706;
        Fri, 22 Nov 2019 10:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420362;
        bh=GwUErkfOcTNNe8fJakwxrN+hDieJPLPdT00X3OCbnKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I1ZgLjG1xq5Rx2d6r7x8UvbP7fq8OgjUfhpfcE2qPtYGMRIi0MYAsZ69as7goAu4l
         qrBwYl8AAzjw31dl0l0+w26LNis+gyr+3xLnSWCqL4aloYYO6xC8t+4xZ0Q4Wippte
         EXxAVbBcs9bXgLBiETAwZY5KS4UofE3qeX0gkvxc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Pavel Machek <pavel@ucw.cz>, Chen Yu <yu.c.chen@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 074/220] PM / hibernate: Check the success of generating md5 digest before hibernation
Date:   Fri, 22 Nov 2019 11:27:19 +0100
Message-Id: <20191122100917.596370205@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index c9986041a5e12..6c3ec193a2465 100644
--- a/arch/x86/power/hibernate_64.c
+++ b/arch/x86/power/hibernate_64.c
@@ -266,9 +266,9 @@ static int get_e820_md5(struct e820_table *table, void *buf)
 	return ret;
 }
 
-static void hibernation_e820_save(void *buf)
+static int hibernation_e820_save(void *buf)
 {
-	get_e820_md5(e820_table_firmware, buf);
+	return get_e820_md5(e820_table_firmware, buf);
 }
 
 static bool hibernation_e820_mismatch(void *buf)
@@ -288,8 +288,9 @@ static bool hibernation_e820_mismatch(void *buf)
 	return memcmp(result, buf, MD5_DIGEST_SIZE) ? true : false;
 }
 #else
-static void hibernation_e820_save(void *buf)
+static int hibernation_e820_save(void *buf)
 {
+	return 0;
 }
 
 static bool hibernation_e820_mismatch(void *buf)
@@ -334,9 +335,7 @@ int arch_hibernation_header_save(void *addr, unsigned int max_size)
 
 	rdr->magic = RESTORE_MAGIC;
 
-	hibernation_e820_save(rdr->e820_digest);
-
-	return 0;
+	return hibernation_e820_save(rdr->e820_digest);
 }
 
 /**
-- 
2.20.1



