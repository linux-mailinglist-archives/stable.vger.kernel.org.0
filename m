Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FCE9B8752
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393186AbfISWHU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:07:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:44912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393177AbfISWHQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:07:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 562F3218AF;
        Thu, 19 Sep 2019 22:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568930835;
        bh=fC9zQTXxaXkLzzBujYFrnT6lf8KESuMXzjNmK1gqNEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c5itxUT2tMDlUpj0mVc9CM7cIF+ORrCpeLf7/3as3nNxG8EO9fwjXGNRb8jpyf2dh
         O64aidr1RalFDJnzO7SkrCznjLnCYZwq+2lLReb7AAw6nEdRn4YxmeF17veqm9D7Rm
         0DitzsbC88+Rh2+KK0pk/rfTS+L/qULuIJVIfHeE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roger Quadros <rogerq@ti.com>,
        Suman Anna <s-anna@ti.com>, Keerthy <j-keerthy@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 031/124] bus: ti-sysc: Fix handling of forced idle
Date:   Fri, 20 Sep 2019 00:01:59 +0200
Message-Id: <20190919214820.163461685@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214819.198419517@linuxfoundation.org>
References: <20190919214819.198419517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 6ee8241d17c68b94a91efabfd6bdfe63bb1b79c1 ]

For some devices we can get the following warning on boot:

ti-sysc 48485200.target-module: sysc_disable_module: invalid midlemode

Fix this by treating SYSC_IDLE_FORCE like we do for the other bits
for idlemodes mask.

Fixes: d59b60564cbf ("bus: ti-sysc: Add generic enable/disable functions")
Cc: Roger Quadros <rogerq@ti.com>
Reviewed-by: Suman Anna <s-anna@ti.com>
Tested-by: Keerthy <j-keerthy@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/ti-sysc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index b72741668c927..f5176a5d38cd9 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -853,7 +853,7 @@ static int sysc_best_idle_mode(u32 idlemodes, u32 *best_mode)
 		*best_mode = SYSC_IDLE_SMART_WKUP;
 	else if (idlemodes & BIT(SYSC_IDLE_SMART))
 		*best_mode = SYSC_IDLE_SMART;
-	else if (idlemodes & SYSC_IDLE_FORCE)
+	else if (idlemodes & BIT(SYSC_IDLE_FORCE))
 		*best_mode = SYSC_IDLE_FORCE;
 	else
 		return -EINVAL;
-- 
2.20.1



