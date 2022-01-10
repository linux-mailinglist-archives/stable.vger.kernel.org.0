Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8134891E4
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240882AbiAJHhH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:37:07 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41338 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241095AbiAJHep (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:34:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1346A61192;
        Mon, 10 Jan 2022 07:34:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7ACBC36AED;
        Mon, 10 Jan 2022 07:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641800083;
        bh=zENv4HK7dy6g+eUa3yM2KKt4TG/axtrDyosh4Wfu/bc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=haLgdJpsuYepRWj90RrH32WATPi1ls8+akQoKZpL0yR8csysu4EQ5pus/uyBkJ0z6
         h9wF+My/jBRDdaBDnx6RDQo4tQyMcLEkcKOamSGMAnhT3OrahhWZl7ayb39noGgq6i
         bwqJwqWGA91DkBWOyJJcOIeKbNzjqVfULODaSazo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunyan Zhang <chunyan.zhang@unisoc.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 5.15 41/72] power: supply: core: Break capacity loop
Date:   Mon, 10 Jan 2022 08:23:18 +0100
Message-Id: <20220110071822.952583458@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071821.500480371@linuxfoundation.org>
References: <20220110071821.500480371@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

commit 51c7b6a0398f54b9120795796a4cff4fc9634f7d upstream.

We should not go on looking for more capacity tables after
we realize we have looked at the last one in
power_supply_find_ocv2cap_table().

Fixes: 3afb50d7125b ("power: supply: core: Add some helpers to use the battery OCV capacity table")
Cc: Chunyan Zhang <chunyan.zhang@unisoc.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/power_supply_core.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/power/supply/power_supply_core.c
+++ b/drivers/power/supply/power_supply_core.c
@@ -853,6 +853,10 @@ power_supply_find_ocv2cap_table(struct p
 		return NULL;
 
 	for (i = 0; i < POWER_SUPPLY_OCV_TEMP_MAX; i++) {
+		/* Out of capacity tables */
+		if (!info->ocv_table[i])
+			break;
+
 		temp_diff = abs(info->ocv_temp[i] - temp);
 
 		if (temp_diff < best_temp_diff) {


