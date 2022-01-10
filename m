Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81F734891DB
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240151AbiAJHgo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:36:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240689AbiAJHe1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:34:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F649C0253F3;
        Sun,  9 Jan 2022 23:29:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1C19611B8;
        Mon, 10 Jan 2022 07:29:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97BDDC36AE9;
        Mon, 10 Jan 2022 07:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799766;
        bh=T4ILPO1fB42eaV/zg5w/6VGIqmncqSWYw9giVFpEtpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IzpW+4B3lfEAQpg6/Q0KXXuWjAvbt3sdqRrVjUcxPFGektBE7ZQsHZ7dBmVenxhD6
         3z4ncF+AhLnDWV/vf57Z/TuMtN/Rut+nv9as0OH80Scy93XmaWW9ySZ7wNuoT08d+z
         qQj39I8otaEAWrbPlex7qvuy/3C+Jw5JBtT/5J+c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunyan Zhang <chunyan.zhang@unisoc.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 5.4 23/34] power: supply: core: Break capacity loop
Date:   Mon, 10 Jan 2022 08:23:18 +0100
Message-Id: <20220110071816.436348315@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071815.647309738@linuxfoundation.org>
References: <20220110071815.647309738@linuxfoundation.org>
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
@@ -742,6 +742,10 @@ power_supply_find_ocv2cap_table(struct p
 		return NULL;
 
 	for (i = 0; i < POWER_SUPPLY_OCV_TEMP_MAX; i++) {
+		/* Out of capacity tables */
+		if (!info->ocv_table[i])
+			break;
+
 		temp_diff = abs(info->ocv_temp[i] - temp);
 
 		if (temp_diff < best_temp_diff) {


