Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B975C1F2D09
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730102AbgFHXPs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:15:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:36806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730096AbgFHXPq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:15:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 035532076A;
        Mon,  8 Jun 2020 23:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658146;
        bh=pNG7nCbZTBcfSnQUkieiIrezRj/QK1xnrLnvjIBIVhA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uTE1BiUwoROoMPnUF1eIhcHRSL3XLglW1PUi/z1W9WeXhpLglMnzWYKmFimq2i/tY
         zFQa6s6IfTJp7kHLfbTDXgusb6Aab9KNsbIKXeiOrDU6fgD4dmAOMdQVJEfi+yX75r
         gnvbaLBFAAkpsqnKsw39eA3fliLZFp4JrbzM7lWU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Saravana Kannan <saravanak@google.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH AUTOSEL 5.6 179/606] driver core: Fix handling of SYNC_STATE_ONLY + STATELESS device links
Date:   Mon,  8 Jun 2020 19:05:04 -0400
Message-Id: <20200608231211.3363633-179-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Saravana Kannan <saravanak@google.com>

commit 44e960490ddf868fc9135151c4a658936e771dc2 upstream.

Commit 21c27f06587d ("driver core: Fix SYNC_STATE_ONLY device link
implementation") didn't completely fix STATELESS + SYNC_STATE_ONLY
handling.

What looks like an optimization in that commit is actually a bug that
causes an if condition to always take the else path. This prevents
reordering of devices in the dpm_list when a DL_FLAG_STATELESS device
link is create on top of an existing DL_FLAG_SYNC_STATE_ONLY device
link.

Fixes: 21c27f06587d ("driver core: Fix SYNC_STATE_ONLY device link implementation")
Signed-off-by: Saravana Kannan <saravanak@google.com>
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://lore.kernel.org/r/20200520043626.181820-1-saravanak@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/core.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 7fb7ffdeb015..68277687c160 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -360,12 +360,14 @@ struct device_link *device_link_add(struct device *consumer,
 
 		if (flags & DL_FLAG_STATELESS) {
 			kref_get(&link->kref);
-			link->flags |= DL_FLAG_STATELESS;
 			if (link->flags & DL_FLAG_SYNC_STATE_ONLY &&
-			    !(link->flags & DL_FLAG_STATELESS))
+			    !(link->flags & DL_FLAG_STATELESS)) {
+				link->flags |= DL_FLAG_STATELESS;
 				goto reorder;
-			else
+			} else {
+				link->flags |= DL_FLAG_STATELESS;
 				goto out;
+			}
 		}
 
 		/*
-- 
2.25.1

