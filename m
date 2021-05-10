Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3271137856E
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235194AbhEJLAY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:00:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:52778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234178AbhEJK4B (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:56:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B337761464;
        Mon, 10 May 2021 10:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643467;
        bh=+hon7tRePnHNKSbakAjM6yRj1+EL6QAEwD/NoxkqwHg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NyIqweKU9vVubIdvBHKnOADFaMp9qFsEAaLy7wiP4ULc4q5Zf3CMCopiFaqwOguz+
         Ja+aHVnG6SoQefXfPoGVNsF9DrnWexDmMhk0ytsTOf2x1Qhxz0ZxzhvVsOH9GKSKiu
         PdIO0vdy2kSzBvUt0GIYsx3Ulu0nMRGrjev/5IA8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Serge Semin <fancer.lancer@gmail.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.11 027/342] mtd: physmap: physmap-bt1-rom: Fix unintentional stack access
Date:   Mon, 10 May 2021 12:16:57 +0200
Message-Id: <20210510102011.004875267@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
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


