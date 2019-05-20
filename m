Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DCF923629
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733065AbfETMni (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:43:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:44710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389754AbfETM2s (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:28:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F97C21479;
        Mon, 20 May 2019 12:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355328;
        bh=+ahlxkje3y2jyBIvC2s6nmMIj2CEAeJyiNprwZ7zUu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vEcUgFSAjmNcqzCDiSFP3tOJqU5fJHG3UjF+DU5fK2PG4uSC8Mhn6qwshc9VhPKl2
         v2d0VgSe9jqOwURkv4a74gX8Ty3xZ05BKAL8oWlv0BtiAIBvCw/q0ePKN9Z1ZcRsEG
         T4mKM8ZH4DCnxu9RBqwbKdyEP7cUDqnMoALNV9SQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.0 077/123] mtd: maps: physmap: Store gpio_values correctly
Date:   Mon, 20 May 2019 14:14:17 +0200
Message-Id: <20190520115249.972923357@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115245.439864225@linuxfoundation.org>
References: <20190520115245.439864225@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Packham <chris.packham@alliedtelesis.co.nz>

commit 64d14c6fe040361ff6aecb825e392cf97837cd9e upstream.

When the gpio-addr-flash.c driver was merged with physmap-core.c the
code to store the current gpio_values was lost. This meant that once a
gpio was asserted it was never de-asserted. Fix this by storing the
current offset in gpio_values like the old driver used to.

Fixes: commit ba32ce95cbd9 ("mtd: maps: Merge gpio-addr-flash.c into physmap-core.c")
Cc: <stable@vger.kernel.org>
Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/maps/physmap-core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/mtd/maps/physmap-core.c
+++ b/drivers/mtd/maps/physmap-core.c
@@ -132,6 +132,8 @@ static void physmap_set_addr_gpios(struc
 
 		gpiod_set_value(info->gpios->desc[i], !!(BIT(i) & ofs));
 	}
+
+	info->gpio_values = ofs;
 }
 
 #define win_mask(order)		(BIT(order) - 1)


