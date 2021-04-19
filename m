Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1552B3643DF
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241377AbhDSNWp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:22:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:56216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241519AbhDSNUu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:20:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33F8C613F3;
        Mon, 19 Apr 2021 13:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838226;
        bh=frpy9pFFENVuKCQSjd1F9mWUJ897Srefs5XZCwo3ZBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qSXixIYSugh0RiG1F+SplLNFcytMdg1pGC81He/59yzw64+GzhhAcae/BsZHx5Pvw
         AurPOyuLiXpD4YS0FDQNTFKocs/urLUYFWTPiySitNrWb4NUdmFoIsBxTJjTarKiHN
         zXhn4kHro/rhkUtKcBaEUmUFKOXhcpSsso+xdDLQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 089/103] ARM: OMAP2+: Fix uninitialized sr_inst
Date:   Mon, 19 Apr 2021 15:06:40 +0200
Message-Id: <20210419130530.853841636@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130527.791982064@linuxfoundation.org>
References: <20210419130527.791982064@linuxfoundation.org>
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



