Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5471334CA9A
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234490AbhC2IjL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:39:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:60256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234921AbhC2Ihg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:37:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 099CB61929;
        Mon, 29 Mar 2021 08:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617007052;
        bh=ybjBk6LLyhr+xz1rjzBkqQfJqU0aSoRZsIhrvOoC+xU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BsyOjAw1eMHc7DKFfEYVcFQcMV/hM+4fdK4OOiqNl+5/P+jdANMksGnWpITMJqjQB
         6dPVvfdgnXUwqBxHsK8UDR9vYghnwU2tmf8UMNLZApI+UTDYBE+urdxC0QUeOmkyEi
         XN4sIiBImoKMYjy7o8PA0FPlUniTJc9jVGaI8Yh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ionela Voinescu <ionela.voinescu@arm.com>,
        Lukasz Luba <lukasz.luba@arm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 204/254] PM: EM: postpone creating the debugfs dir till fs_initcall
Date:   Mon, 29 Mar 2021 09:58:40 +0200
Message-Id: <20210329075639.803178376@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukasz Luba <lukasz.luba@arm.com>

[ Upstream commit fb9d62b27ab1e07d625591549c314b7d406d21df ]

The debugfs directory '/sys/kernel/debug/energy_model' is needed before
the Energy Model registration can happen. With the recent change in
debugfs subsystem it's not allowed to create this directory at early
stage (core_initcall). Thus creating this directory would fail.

Postpone the creation of the EM debug dir to later stage: fs_initcall.

It should be safe since all clients: CPUFreq drivers, Devfreq drivers
will be initialized in later stages.

The custom debug log below prints the time of creation the EM debug dir
at fs_initcall and successful registration of EMs at later stages.

[    1.505717] energy_model: creating rootdir
[    3.698307] cpu cpu0: EM: created perf domain
[    3.709022] cpu cpu1: EM: created perf domain

Fixes: 56348560d495 ("debugfs: do not attempt to create a new file before the filesystem is initalized")
Reported-by: Ionela Voinescu <ionela.voinescu@arm.com>
Signed-off-by: Lukasz Luba <lukasz.luba@arm.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/power/energy_model.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/power/energy_model.c b/kernel/power/energy_model.c
index 1358fa4abfa8..0f4530b3a8cd 100644
--- a/kernel/power/energy_model.c
+++ b/kernel/power/energy_model.c
@@ -98,7 +98,7 @@ static int __init em_debug_init(void)
 
 	return 0;
 }
-core_initcall(em_debug_init);
+fs_initcall(em_debug_init);
 #else /* CONFIG_DEBUG_FS */
 static void em_debug_create_pd(struct device *dev) {}
 static void em_debug_remove_pd(struct device *dev) {}
-- 
2.30.1



