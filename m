Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E74C13F74C
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:11:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387756AbgAPTKx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 14:10:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:49966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387748AbgAPRAY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:00:24 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26C3820728;
        Thu, 16 Jan 2020 17:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194023;
        bh=LyAd5DpyHj1XRDmuD4E3Uim2Q2Y30JGK/Z/7Gwdy5po=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B0e5ajOOp7YYgQKT2WzTU4oyyCmterh+lbxtrOWD/lN4AvNoa+0Urcv/PmkgTzuxu
         zO9KSHllbnfsfRViKJ/a17+tw1jwC9MC1199/P3pnNUEJxcmF0a5fOuTTayiPr9jb1
         qb4ikZ41ZwC1AOKgqMPZmiGq7WSCeBxOf8UCq/SI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 144/671] driver core: Do not resume suppliers under device_links_write_lock()
Date:   Thu, 16 Jan 2020 11:50:53 -0500
Message-Id: <20200116165940.10720-27-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit 5db25c9eb893df8f6b93c1d97b8006d768e1b6f5 ]

It is incorrect to call pm_runtime_get_sync() under
device_links_write_lock(), because it may end up trying to take
device_links_read_lock() while resuming the target device and that
will deadlock in the non-SRCU case, so avoid that by resuming the
supplier device in device_link_add() before calling
device_links_write_lock().

Fixes: 21d5c57b3726 ("PM / runtime: Use device links")
Fixes: baa8809f6097 ("PM / runtime: Optimize the use of device links")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/core.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 562385c47fa4..c228b4ebf554 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -201,12 +201,21 @@ struct device_link *device_link_add(struct device *consumer,
 				    struct device *supplier, u32 flags)
 {
 	struct device_link *link;
+	bool rpm_put_supplier = false;
 
 	if (!consumer || !supplier ||
 	    (flags & DL_FLAG_STATELESS &&
 	     flags & (DL_FLAG_AUTOREMOVE_CONSUMER | DL_FLAG_AUTOREMOVE_SUPPLIER)))
 		return NULL;
 
+	if (flags & DL_FLAG_PM_RUNTIME && flags & DL_FLAG_RPM_ACTIVE) {
+		if (pm_runtime_get_sync(supplier) < 0) {
+			pm_runtime_put_noidle(supplier);
+			return NULL;
+		}
+		rpm_put_supplier = true;
+	}
+
 	device_links_write_lock();
 	device_pm_lock();
 
@@ -250,13 +259,8 @@ struct device_link *device_link_add(struct device *consumer,
 
 	if (flags & DL_FLAG_PM_RUNTIME) {
 		if (flags & DL_FLAG_RPM_ACTIVE) {
-			if (pm_runtime_get_sync(supplier) < 0) {
-				pm_runtime_put_noidle(supplier);
-				kfree(link);
-				link = NULL;
-				goto out;
-			}
 			link->rpm_active = true;
+			rpm_put_supplier = false;
 		}
 		pm_runtime_new_link(consumer);
 		/*
@@ -328,6 +332,10 @@ struct device_link *device_link_add(struct device *consumer,
  out:
 	device_pm_unlock();
 	device_links_write_unlock();
+
+	if (rpm_put_supplier)
+		pm_runtime_put(supplier);
+
 	return link;
 }
 EXPORT_SYMBOL_GPL(device_link_add);
-- 
2.20.1

