Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8871C3C478E
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235784AbhGLGdX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:33:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:46660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235677AbhGLG32 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:29:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E30C761209;
        Mon, 12 Jul 2021 06:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071135;
        bh=qkTLuWn9v0Fw0lbpes4GetSeu3BfGQq21a0g5iaqhkw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tpmUzRCxiKVoN05+p0udW3P5ryCG4+AN+qlJ4Rds/cxOh79JJXmvjmxYJP6U8BuJn
         /ey+f0fMcqGHj+jGmxa8Yu9CQrbjBId1Bej0HVGSZfE76qPsYmKeNE3aCDMHBbfwV3
         Zo9NjB/X7L/PUX76IsE1Y3iPTAijTRts4XMFX0b8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 288/348] char: pcmcia: error out if num_bytes_read is greater than 4 in set_protocol()
Date:   Mon, 12 Jul 2021 08:11:12 +0200
Message-Id: <20210712060741.857560193@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 37188559c610f1b7eec83c8e448936c361c578de ]

Theoretically, it will cause index out of bounds error if
'num_bytes_read' is greater than 4. As we expect it(and was tested)
never to be greater than 4, error out if it happens.

Fixes: c1986ee9bea3 ("[PATCH] New Omnikey Cardman 4000 driver")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20210521120617.138396-1-yukuai3@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/pcmcia/cm4000_cs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/char/pcmcia/cm4000_cs.c b/drivers/char/pcmcia/cm4000_cs.c
index 15bf585af5d3..44117169db91 100644
--- a/drivers/char/pcmcia/cm4000_cs.c
+++ b/drivers/char/pcmcia/cm4000_cs.c
@@ -544,6 +544,10 @@ static int set_protocol(struct cm4000_dev *dev, struct ptsreq *ptsreq)
 		io_read_num_rec_bytes(iobase, &num_bytes_read);
 		if (num_bytes_read >= 4) {
 			DEBUGP(2, dev, "NumRecBytes = %i\n", num_bytes_read);
+			if (num_bytes_read > 4) {
+				rc = -EIO;
+				goto exit_setprotocol;
+			}
 			break;
 		}
 		usleep_range(10000, 11000);
-- 
2.30.2



