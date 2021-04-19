Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E57E9364350
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240153AbhDSNQ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:16:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:47986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240176AbhDSNO6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:14:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82199613CA;
        Mon, 19 Apr 2021 13:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618837993;
        bh=frpy9pFFENVuKCQSjd1F9mWUJ897Srefs5XZCwo3ZBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MTSkX/RXkBvwzkUUTh19Hpbqc31s/e3U/N5i3ZBaSA2/n/pl2XXqjZj8ZN72J4L16
         YsqlfSYscgABcyI2kd5XyuKOgKHrhtGnfH4XV3IVw//sMk5wnFzIj8HFilnVGGXOKi
         1enmYrg0dCu87Ax7WuXwzT1yCs4TsYTCN9rAjVz4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 107/122] ARM: OMAP2+: Fix uninitialized sr_inst
Date:   Mon, 19 Apr 2021 15:06:27 +0200
Message-Id: <20210419130533.789001650@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130530.166331793@linuxfoundation.org>
References: <20210419130530.166331793@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit fc85dc42a38405099f97aa2af709fe9504a82508 ]

Fix uninitialized sr_inst.

Fixes: fbfa463be8dc ("ARM: OMAP2+: Fix smartreflex init regression after dropping legacy data")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/sr_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/sr_device.c b/arch/arm/mach-omap2/sr_device.c
index 17b66f0d0dee..605925684b0a 100644
--- a/arch/arm/mach-omap2/sr_device.c
+++ b/arch/arm/mach-omap2/sr_device.c
@@ -188,7 +188,7 @@ static const char * const dra7_sr_instances[] = {
 
 int __init omap_devinit_smartreflex(void)
 {
-	const char * const *sr_inst;
+	const char * const *sr_inst = NULL;
 	int i, nr_sr = 0;
 
 	if (soc_is_omap44xx()) {
-- 
2.30.2



