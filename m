Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03303353E51
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238228AbhDEJF3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:05:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:48202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238400AbhDEJEx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:04:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B172613A0;
        Mon,  5 Apr 2021 09:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613486;
        bh=a8Kb9Xf8LuO6+W+hPON8tDpCxxbUb/pMtetHiKm7N90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vrqY3ImPhDjvCQ63TANPVUVz3FCAZiYsQore7vpUqHrOXzmioIU6mvPpfkiUDnn2p
         V/ijG3iF0MkLwODmaXwMSBO2WPDq0JLhUyN7s71BN8+lEGkGAl3ai/FocemJciGWHI
         FnadgVRpKZyvM/7ed9RZk2YWj/FgwzsHwS7kGyQw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 48/74] PM: runtime: Fix ordering in pm_runtime_get_suppliers()
Date:   Mon,  5 Apr 2021 10:54:12 +0200
Message-Id: <20210405085026.299268888@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085024.703004126@linuxfoundation.org>
References: <20210405085024.703004126@linuxfoundation.org>
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
@@ -1663,8 +1663,8 @@ void pm_runtime_get_suppliers(struct dev
 				device_links_read_lock_held())
 		if (link->flags & DL_FLAG_PM_RUNTIME) {
 			link->supplier_preactivated = true;
-			refcount_inc(&link->rpm_active);
 			pm_runtime_get_sync(link->supplier);
+			refcount_inc(&link->rpm_active);
 		}
 
 	device_links_read_unlock(idx);


