Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 697941D0E7A
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 12:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387748AbgEMKAb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 06:00:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:52986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387712AbgEMJvv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:51:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B47E820753;
        Wed, 13 May 2020 09:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363511;
        bh=Mkl9niGM7Jk9EsYF7+nYIEVraYIF7kyKrRHQwBUWUUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SsMddIzcf6lBnZvJv5AML/lwC1f8M42nQSqIm6RuatGi2kvTm2nlbdeBHH+r2boQR
         dayAvPWw9YMWanjolILhZbEvs+p7YpIZpfEPDqDbdALdFwk/mnsb+wLUc2Gjq8whKY
         eYUeSLcOOBgY64TdmC0y0PStNmnH/Mp9Vsllwh0M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 014/118] devlink: Fix reporters recovery condition
Date:   Wed, 13 May 2020 11:43:53 +0200
Message-Id: <20200513094418.956848092@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094417.618129545@linuxfoundation.org>
References: <20200513094417.618129545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

[ Upstream commit bea0c5c942d3b4e9fb6ed45f6a7de74c6b112437 ]

Devlink health core conditions the reporter's recovery with the
expiration of the grace period. This is not relevant for the first
recovery. Explicitly demand that the grace period will only apply to
recoveries other than the first.

Fixes: c8e1da0bf923 ("devlink: Add health report functionality")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/devlink.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -5029,6 +5029,7 @@ int devlink_health_report(struct devlink
 {
 	enum devlink_health_reporter_state prev_health_state;
 	struct devlink *devlink = reporter->devlink;
+	unsigned long recover_ts_threshold;
 
 	/* write a log message of the current error */
 	WARN_ON(!msg);
@@ -5039,10 +5040,12 @@ int devlink_health_report(struct devlink
 	devlink_recover_notify(reporter, DEVLINK_CMD_HEALTH_REPORTER_RECOVER);
 
 	/* abort if the previous error wasn't recovered */
+	recover_ts_threshold = reporter->last_recovery_ts +
+			       msecs_to_jiffies(reporter->graceful_period);
 	if (reporter->auto_recover &&
 	    (prev_health_state != DEVLINK_HEALTH_REPORTER_STATE_HEALTHY ||
-	     jiffies - reporter->last_recovery_ts <
-	     msecs_to_jiffies(reporter->graceful_period))) {
+	     (reporter->last_recovery_ts && reporter->recovery_count &&
+	      time_is_after_jiffies(recover_ts_threshold)))) {
 		trace_devlink_health_recover_aborted(devlink,
 						     reporter->ops->name,
 						     reporter->health_state,


