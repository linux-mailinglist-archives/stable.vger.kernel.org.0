Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3211F79841
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389389AbfG2UG2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 16:06:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:56800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388558AbfG2TlV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:41:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06088206DD;
        Mon, 29 Jul 2019 19:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429281;
        bh=VxXnJ/P807ym+51bu1JQ01WrVeUIkkjT5fp71u2lyag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qNUcFTDnPbfVcauKcJAm/0BZFVZr8JvExL0dT2J/1ESXpwY3sfAeJ3DK9aITaf6r3
         HxUANz3n6sVP0/ux6c/PLsexmfWlzb0DVqEC7ORAPiN3fWEO+MTOs6oEVcMtHunvHC
         wLsT+u25F6c2+brSnZxKyHKdFUBcEexqqihI9Awk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Hancock <hancock@sedsystems.ca>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 049/113] mfd: core: Set fwnode for created devices
Date:   Mon, 29 Jul 2019 21:22:16 +0200
Message-Id: <20190729190707.272214674@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190655.455345569@linuxfoundation.org>
References: <20190729190655.455345569@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c176c6d7e932662668bcaec2d763657096589d85 ]

The logic for setting the of_node on devices created by mfd did not set
the fwnode pointer to match, which caused fwnode-based APIs to
malfunction on these devices since the fwnode pointer was null. Fix
this.

Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/mfd-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
index 94e3f32ce935..182973df1aed 100644
--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -179,6 +179,7 @@ static int mfd_add_device(struct device *parent, int id,
 		for_each_child_of_node(parent->of_node, np) {
 			if (of_device_is_compatible(np, cell->of_compatible)) {
 				pdev->dev.of_node = np;
+				pdev->dev.fwnode = &np->fwnode;
 				break;
 			}
 		}
-- 
2.20.1



