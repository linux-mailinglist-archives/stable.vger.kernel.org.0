Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9723A378331
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231476AbhEJKmn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:42:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:50010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231802AbhEJKlE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:41:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F1A56191C;
        Mon, 10 May 2021 10:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642715;
        bh=+hon7tRePnHNKSbakAjM6yRj1+EL6QAEwD/NoxkqwHg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KPEzW2mVYih2JXzkaUCcKQcKcPbXl72rcjRgDODXHYSQDwaHvVt0kf8Ooo6DPZspX
         sGNFdaAq5BwPpqJGe3rSs7zLRY7jyYKETYtOjgBj8Pe3/Je1LF0eJWE8EzyFN3hm7Y
         qQWMJqRaahEjzB2JFZ6FYTm5uZabm3QDeq1MVaKU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Serge Semin <fancer.lancer@gmail.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.10 022/299] mtd: physmap: physmap-bt1-rom: Fix unintentional stack access
Date:   Mon, 10 May 2021 12:16:59 +0200
Message-Id: <20210510102005.586549859@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gustavo A. R. Silva <gustavoars@kernel.org>

commit 683313993dbe1651c7aa00bb42a041d70e914925 upstream.

Cast &data to (char *) in order to avoid unintentionally accessing
the stack.

Notice that data is of type u32, so any increment to &data
will be in the order of 4-byte chunks, and this piece of code
is actually intended to be a byte offset.

Fixes: b3e79e7682e0 ("mtd: physmap: Add Baikal-T1 physically mapped ROM support")
Addresses-Coverity-ID: 1497765 ("Out-of-bounds access")
Cc: stable@vger.kernel.org
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Acked-by: Serge Semin <fancer.lancer@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20210212104022.GA242669@embeddedor
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/maps/physmap-bt1-rom.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/maps/physmap-bt1-rom.c
+++ b/drivers/mtd/maps/physmap-bt1-rom.c
@@ -79,7 +79,7 @@ static void __xipram bt1_rom_map_copy_fr
 	if (shift) {
 		chunk = min_t(ssize_t, 4 - shift, len);
 		data = readl_relaxed(src - shift);
-		memcpy(to, &data + shift, chunk);
+		memcpy(to, (char *)&data + shift, chunk);
 		src += chunk;
 		to += chunk;
 		len -= chunk;


