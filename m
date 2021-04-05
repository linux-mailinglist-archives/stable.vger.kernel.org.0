Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0E9353F0B
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238269AbhDEJKA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:10:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:54406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238740AbhDEJIy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:08:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 734476139D;
        Mon,  5 Apr 2021 09:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613727;
        bh=S1pV+yQzFrlhkXSO06HXrBj8jSwAimplDjRtHW2G/wE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iMceGV44X5fMEGnZ4A6AviRN/Vk/AEEDu7oxWChg0Ri0HiFn6j8NwM3NbDdo3DTLw
         kTcH4TJ6fT0JCZmXWOL2arRT4J2NBcP6Bo/P43S1fW62fbma4MZlg5WcLbf6GAE8CU
         Fbf8xueyIB7Cc55D0yyDJUBai9SXsTYlT4SQk5T4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.10 068/126] PM: runtime: Fix ordering in pm_runtime_get_suppliers()
Date:   Mon,  5 Apr 2021 10:53:50 +0200
Message-Id: <20210405085033.303954148@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085031.040238881@linuxfoundation.org>
References: <20210405085031.040238881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit c0c33442f7203704aef345647e14c2fb86071001 upstream.

rpm_active indicates how many times the supplier usage_count has been
incremented. Consequently it must be updated after pm_runtime_get_sync() of
the supplier, not before.

Fixes: 4c06c4e6cf63 ("driver core: Fix possible supplier PM-usage counter imbalance")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: 5.1+ <stable@vger.kernel.org> # 5.1+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/power/runtime.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -1690,8 +1690,8 @@ void pm_runtime_get_suppliers(struct dev
 				device_links_read_lock_held())
 		if (link->flags & DL_FLAG_PM_RUNTIME) {
 			link->supplier_preactivated = true;
-			refcount_inc(&link->rpm_active);
 			pm_runtime_get_sync(link->supplier);
+			refcount_inc(&link->rpm_active);
 		}
 
 	device_links_read_unlock(idx);


