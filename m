Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F55134C912
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233720AbhC2I0i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:26:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:42788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232532AbhC2IYn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:24:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1B50619B1;
        Mon, 29 Mar 2021 08:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006282;
        bh=LtP11KFsRCojbMf2d1B9su3MJUULHpb/epcyz7sE6SA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QZJ9kSefzubSQ5lcrfr6SsPYcMNotcMMA6WwWoP9oa3tqwtDdMAMQ7slDSVums5Ke
         uoJPUvNtkzKaQFs6mRj02DbJ5aAsDvtV4n4pnKdMWze0iQLFha9sBoyi4u4qmV3kY6
         hdH43h15uNb8gItiD79TvSED4ceXWGbhStykDaak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 177/221] xen/x86: make XEN_BALLOON_MEMORY_HOTPLUG_LIMIT depend on MEMORY_HOTPLUG
Date:   Mon, 29 Mar 2021 09:58:28 +0200
Message-Id: <20210329075635.054333643@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roger Pau Monne <roger.pau@citrix.com>

[ Upstream commit 2b514ec72706a31bea0c3b97e622b81535b5323a ]

The Xen memory hotplug limit should depend on the memory hotplug
generic option, rather than the Xen balloon configuration. It's
possible to have a kernel with generic memory hotplug enabled, but
without Xen balloon enabled, at which point memory hotplug won't work
correctly due to the size limitation of the p2m.

Rename the option to XEN_MEMORY_HOTPLUG_LIMIT since it's no longer
tied to ballooning.

Fixes: 9e2369c06c8a18 ("xen: add helpers to allocate unpopulated memory")
Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Link: https://lore.kernel.org/r/20210324122424.58685-2-roger.pau@citrix.com
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/xen/p2m.c  | 4 ++--
 drivers/xen/Kconfig | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 60da7e793385..674b83ffe4d6 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -98,8 +98,8 @@ EXPORT_SYMBOL_GPL(xen_p2m_size);
 unsigned long xen_max_p2m_pfn __read_mostly;
 EXPORT_SYMBOL_GPL(xen_max_p2m_pfn);
 
-#ifdef CONFIG_XEN_BALLOON_MEMORY_HOTPLUG_LIMIT
-#define P2M_LIMIT CONFIG_XEN_BALLOON_MEMORY_HOTPLUG_LIMIT
+#ifdef CONFIG_XEN_MEMORY_HOTPLUG_LIMIT
+#define P2M_LIMIT CONFIG_XEN_MEMORY_HOTPLUG_LIMIT
 #else
 #define P2M_LIMIT 0
 #endif
diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
index 41645fe6ad48..ea0efd290c37 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -50,11 +50,11 @@ config XEN_BALLOON_MEMORY_HOTPLUG
 
 	  SUBSYSTEM=="memory", ACTION=="add", RUN+="/bin/sh -c '[ -f /sys$devpath/state ] && echo online > /sys$devpath/state'"
 
-config XEN_BALLOON_MEMORY_HOTPLUG_LIMIT
+config XEN_MEMORY_HOTPLUG_LIMIT
 	int "Hotplugged memory limit (in GiB) for a PV guest"
 	default 512
 	depends on XEN_HAVE_PVMMU
-	depends on XEN_BALLOON_MEMORY_HOTPLUG
+	depends on MEMORY_HOTPLUG
 	help
 	  Maxmium amount of memory (in GiB) that a PV guest can be
 	  expanded to when using memory hotplug.
-- 
2.30.1



