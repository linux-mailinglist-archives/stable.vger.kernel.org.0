Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7369138013
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731045AbgAKKZf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:25:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:56604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730740AbgAKKZd (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:25:33 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A38F205F4;
        Sat, 11 Jan 2020 10:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738333;
        bh=7/bEWBR228SG8GvLa5XKG2h7lDVFYZfEP4V+HyfEkUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ztxeUfrh8Qla4KTBATtXzxyLOScAutYnGQrSxu6O2kwhhzPlbhLxtLAnyd1sw9IsM
         HZJhZqCSnYTSS429ISMxmdY1yijdKVCQQof3x9UvepdSiR2jYsyBoL9VlkW+jqw52F
         QcaytTiEcQWvZGVFDJ4wXvGTPwfXz8+5Hmqf+Gm4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Keerthy <j-keerthy@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 067/165] bus: ti-sysc: Fix missing reset delay handling
Date:   Sat, 11 Jan 2020 10:49:46 +0100
Message-Id: <20200111094926.742694728@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit e709ed70d122e94cb426b1e1f905829eae19a009 ]

We have dts property for "ti,sysc-delay-us", and we're using it, but the
wait after OCP softreset only happens if devices are probed in legacy mode.

Let's add a delay after writing the OCP softreset when specified.

Fixes: e0db94fe87da ("bus: ti-sysc: Make OCP reset work for sysstatus and sysconfig reset bits")
Cc: Keerthy <j-keerthy@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/ti-sysc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index 2b6670daf7fc..34bd9bf4e68a 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -1594,6 +1594,10 @@ static int sysc_reset(struct sysc *ddata)
 	sysc_val |= sysc_mask;
 	sysc_write(ddata, sysc_offset, sysc_val);
 
+	if (ddata->cfg.srst_udelay)
+		usleep_range(ddata->cfg.srst_udelay,
+			     ddata->cfg.srst_udelay * 2);
+
 	if (ddata->clk_enable_quirk)
 		ddata->clk_enable_quirk(ddata);
 
-- 
2.20.1



