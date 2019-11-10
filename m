Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53EDDF62A6
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 03:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728574AbfKJCoc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:44:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:43916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727549AbfKJCob (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:44:31 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE29D21848;
        Sun, 10 Nov 2019 02:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353870;
        bh=8YwN1mIPCq0li5Fv10AaqXAk7tANchOV30SvSfyabI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JHG3rCPgP6Pk3voZK1r4IQ8tSdJI3+Cf9Z6EkTuM98PvbZStLr/wGO50T7q4gGJyG
         3sV86Qlvt+nHgse103iyN7x4TufnqgsNOIircR3W6QVlHeGiwSl9lztgQL9ZbUTVyq
         /Ow/zeAdxIjHwtocmuG0BkoysJYo7FYHbyWfzXjo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Justin Ernst <justin.ernst@hpe.com>, Borislav Petkov <bp@suse.de>,
        Russ Anderson <russ.anderson@hpe.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-edac@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 150/191] EDAC: Raise the maximum number of memory controllers
Date:   Sat,  9 Nov 2019 21:39:32 -0500
Message-Id: <20191110024013.29782-150-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Justin Ernst <justin.ernst@hpe.com>

[ Upstream commit 6b58859419554fb824e09cfdd73151a195473cbc ]

We observe an oops in the skx_edac module during boot:

  EDAC MC0: Giving out device to module skx_edac controller Skylake Socket#0 IMC#0
  EDAC MC1: Giving out device to module skx_edac controller Skylake Socket#0 IMC#1
  EDAC MC2: Giving out device to module skx_edac controller Skylake Socket#1 IMC#0
  ...
  EDAC MC13: Giving out device to module skx_edac controller Skylake Socket#0 IMC#1
  EDAC MC14: Giving out device to module skx_edac controller Skylake Socket#1 IMC#0
  EDAC MC15: Giving out device to module skx_edac controller Skylake Socket#1 IMC#1
  Too many memory controllers: 16
  EDAC MC: Removed device 0 for skx_edac Skylake Socket#0 IMC#0

We observe there are two memory controllers per socket, with a limit
of 16. Raise the maximum number of memory controllers from 16 to 2 *
MAX_NUMNODES (1024).

[ bp: This is just a band-aid fix until we've sorted out the whole issue
  with the bus_type association and handling in EDAC and can get rid of
  this arbitrary limit. ]

Signed-off-by: Justin Ernst <justin.ernst@hpe.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Russ Anderson <russ.anderson@hpe.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-edac@vger.kernel.org
Link: https://lkml.kernel.org/r/20180925143449.284634-1-justin.ernst@hpe.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/edac.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/edac.h b/include/linux/edac.h
index bffb97828ed67..958d69332c1d5 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -17,6 +17,7 @@
 #include <linux/completion.h>
 #include <linux/workqueue.h>
 #include <linux/debugfs.h>
+#include <linux/numa.h>
 
 #define EDAC_DEVICE_NAME_LEN	31
 
@@ -670,6 +671,6 @@ struct mem_ctl_info {
 /*
  * Maximum number of memory controllers in the coherent fabric.
  */
-#define EDAC_MAX_MCS	16
+#define EDAC_MAX_MCS	2 * MAX_NUMNODES
 
 #endif
-- 
2.20.1

