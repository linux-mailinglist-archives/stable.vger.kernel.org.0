Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 622DC22676B
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387818AbgGTQLe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:11:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:50600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387810AbgGTQL3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:11:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDF2C2176B;
        Mon, 20 Jul 2020 16:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261489;
        bh=xm9UZW9zAD+VA4H6R+EB34yC3IghtWXpFJKcdYMmkao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=anCKpH0UN9GwxK4ntWlC2+TaocjjzIvamMupZcWlFzffV63CmWwz5XYDO9g0tCN9m
         Ps50mbgT8XNVEi/nl520w/wFQ4zbM4/SegCBn56A+n/4m8SnJ+Xsr8Udayd6vrdZ5g
         OYosOMT7jKewlhKdvWez8249aqENKjd4vNa341vk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>,
        Boris Brezillon <boris.brezillon@collabora.com>
Subject: [PATCH 5.7 134/244] mtd: rawnand: marvell: Fix the condition on a return code
Date:   Mon, 20 Jul 2020 17:36:45 +0200
Message-Id: <20200720152832.221673103@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit c27075772d1f1c8aaf276db9943b35adda8a8b65 upstream.

In a previous fix, I changed the condition on which the timeout of an
IRQ is reached from:

    if (!ret)

into:

    if (ret && !pending)

While having a non-zero return code is usual in the Linux kernel, here
ret comes from a wait_for_completion_timeout() which returns 0 when
the waiting period is too long.

Hence, the revised condition should be:

    if (!ret && !pending)

The faulty patch did not produce any error because of the !pending
condition so this change is finally purely cosmetic and does not
change the actual driver behavior.

Fixes: cafb56dd741e ("mtd: rawnand: marvell: prevent timeouts on a loaded machine")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Link: https://lore.kernel.org/linux-mtd/20200424164501.26719-2-miquel.raynal@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/raw/marvell_nand.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/nand/raw/marvell_nand.c
+++ b/drivers/mtd/nand/raw/marvell_nand.c
@@ -707,7 +707,7 @@ static int marvell_nfc_wait_op(struct na
 	 * In case the interrupt was not served in the required time frame,
 	 * check if the ISR was not served or if something went actually wrong.
 	 */
-	if (ret && !pending) {
+	if (!ret && !pending) {
 		dev_err(nfc->dev, "Timeout waiting for RB signal\n");
 		return -ETIMEDOUT;
 	}


