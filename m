Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16D281016C0
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731441AbfKSFxn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:53:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:51644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727888AbfKSFxl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:53:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 451EF21783;
        Tue, 19 Nov 2019 05:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142820;
        bh=UupwU4breSByp96+YTz2uZ3ED3NUHaAkfOoof3kWAeI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tPR8l6KIhQSdak79Qr/RjEVkNj1gw229oW0EJAFYQbuEc3zLfNBpC+8h7qHP7Xzxg
         6gAEXypwdJCHH6n4xVv7jFwANYFWvthfATY/FaxHFpmSN2Ipn9eda8IXLMccp5BYqL
         NdzDkvTYVovAJJs1dxDiSwIHz0IWv7KQ6pD/Hdf8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Justin Ernst <justin.ernst@hpe.com>,
        Borislav Petkov <bp@suse.de>,
        Russ Anderson <russ.anderson@hpe.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-edac@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 209/239] EDAC: Raise the maximum number of memory controllers
Date:   Tue, 19 Nov 2019 06:20:09 +0100
Message-Id: <20191119051337.711593264@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index cd75c173fd00b..90f72336aea66 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -17,6 +17,7 @@
 #include <linux/completion.h>
 #include <linux/workqueue.h>
 #include <linux/debugfs.h>
+#include <linux/numa.h>
 
 #define EDAC_DEVICE_NAME_LEN	31
 
@@ -667,6 +668,6 @@ struct mem_ctl_info {
 /*
  * Maximum number of memory controllers in the coherent fabric.
  */
-#define EDAC_MAX_MCS	16
+#define EDAC_MAX_MCS	2 * MAX_NUMNODES
 
 #endif
-- 
2.20.1



