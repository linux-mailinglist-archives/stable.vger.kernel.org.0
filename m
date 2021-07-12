Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3B383C4F70
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239249AbhGLHZz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:25:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:60628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240593AbhGLHWn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:22:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E850A611CB;
        Mon, 12 Jul 2021 07:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074395;
        bh=7lAdnIC+IS9y3dqbml/aSQCH1+mOE6hdrUUPm9pLZf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fuZfAZYvnm0m2p7lO1vqKfaI5+JYIyGMmhOp5+Ii6FK+kyvwrUoNG9xvDovhWr0rZ
         v2fnu46r+M2lYEmOrvQ0fl61njuSeqTZ9sbguYBfYjMUL2nypNdQF4ia7owyUIleAM
         0o98LpvKqKW9VNAIVa/XMd0Fns9yDoxi+nLwIuxE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 565/700] char: pcmcia: error out if num_bytes_read is greater than 4 in set_protocol()
Date:   Mon, 12 Jul 2021 08:10:48 +0200
Message-Id: <20210712061036.283146248@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
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
index 89681f07bc78..9468e9520cee 100644
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



