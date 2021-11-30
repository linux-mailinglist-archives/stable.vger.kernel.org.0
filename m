Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46A3A46381F
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:55:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242910AbhK3O6R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:58:17 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:59758 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242668AbhK3O4Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:56:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5FAAFCE1A76;
        Tue, 30 Nov 2021 14:52:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9E30C53FCF;
        Tue, 30 Nov 2021 14:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283972;
        bh=JsgGG7B/KqUw9wC6FuWxsYS1GzJZsMvRNcihS8b7emg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ps6YoDk9Malc2RTmPV8tiInFK6roUOEao7cv6ORRWMZ34IbwT+ByvKsOnzhbEmltV
         gZ+ye2yaViIXwz8kWm1Vo31sZlvg0DAr/BoXQLqIXQ3YxUpIdslW8Kos0JWW9J0w18
         LDcf+MkcuFZIzFYq3est6yUM992IiuZhCmJY5/rNaWyWuwKMIAT2T5h3kuXXsety5z
         Nin0msv+YGP/2gYtJavQtzVrzjZzupenjft8pcwYIUUHaItE+L+yz1JMODilgwoqe+
         3ba+NhXCslRxnvGn/aJ+fmvlxiFrazh3vFLgr7x/6iu7hycdnvUqhgv1MTtfLDQYet
         cOl0OrUB1pxGw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
        Jan Beulich <jbeulich@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sasha Levin <sashal@kernel.org>, xen-devel@lists.xenproject.org
Subject: [PATCH AUTOSEL 4.19 04/17] xen/privcmd: make option visible in Kconfig
Date:   Tue, 30 Nov 2021 09:52:28 -0500
Message-Id: <20211130145243.946407-4-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130145243.946407-1-sashal@kernel.org>
References: <20211130145243.946407-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

[ Upstream commit 897919ad8b42eb8222553838ab82414a924694aa ]

This configuration option provides a misc device as an API to userspace.
Make this API usable without having to select the module as a transitive
dependency.

This also fixes an issue where localyesconfig would select
CONFIG_XEN_PRIVCMD=m because it was not visible and defaulted to
building as module.

[boris: clarified help message per Jan's suggestion]

Based-on-patch-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/20211116143323.18866-1-jgross@suse.com
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/Kconfig | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
index 0505eeb593b5c..8e4fff3cbaf0e 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -258,9 +258,15 @@ config XEN_SCSI_BACKEND
 	  if guests need generic access to SCSI devices.
 
 config XEN_PRIVCMD
-	tristate
+	tristate "Xen hypercall passthrough driver"
 	depends on XEN
 	default m
+	help
+	  The hypercall passthrough driver allows privileged user programs to
+	  perform Xen hypercalls. This driver is normally required for systems
+	  running as Dom0 to perform privileged operations, but in some
+	  disaggregated Xen setups this driver might be needed for other
+	  domains, too.
 
 config XEN_STUB
 	bool "Xen stub drivers"
-- 
2.33.0

