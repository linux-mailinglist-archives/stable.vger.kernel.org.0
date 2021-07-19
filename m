Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 358803CDC76
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238731AbhGSOwh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:52:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:40462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343693AbhGSOsc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:48:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 055BA613C0;
        Mon, 19 Jul 2021 15:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708251;
        bh=AaxiyUJgb/wWIUCoEmwa22p47FjVGGBCNWT7ikz188s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SCTESEMIgp+O5DQJgp8cf+0ZoGNBfvVWcml/mNthYB1Pc3+RXScTnvksgTq3vVN4r
         FTWAkYCuwNco9O5Vrcpu2LRZex53frA3afeS4BFW3UFx0HN/6GgQXyXjm9fCK7lgpu
         kw34Ji+9HstxbTrvSwfOeY3HDn7Hnzf85mkl51UE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luiz Sampaio <sampaio.ime@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 239/315] w1: ds2438: fixing bug that would always get page0
Date:   Mon, 19 Jul 2021 16:52:08 +0200
Message-Id: <20210719144951.283448088@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.861561397@linuxfoundation.org>
References: <20210719144942.861561397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luiz Sampaio <sampaio.ime@gmail.com>

[ Upstream commit 1f5e7518f063728aee0679c5086b92d8ea429e11 ]

The purpose of the w1_ds2438_get_page function is to get the register
values at the page passed as the pageno parameter. However, the page0 was
hardcoded, such that the function always returned the page0 contents. Fixed
so that the function can retrieve any page.

Signed-off-by: Luiz Sampaio <sampaio.ime@gmail.com>
Link: https://lore.kernel.org/r/20210519223046.13798-5-sampaio.ime@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/w1/slaves/w1_ds2438.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/w1/slaves/w1_ds2438.c b/drivers/w1/slaves/w1_ds2438.c
index 7c4e33dbee4d..b005dda9c697 100644
--- a/drivers/w1/slaves/w1_ds2438.c
+++ b/drivers/w1/slaves/w1_ds2438.c
@@ -64,13 +64,13 @@ static int w1_ds2438_get_page(struct w1_slave *sl, int pageno, u8 *buf)
 		if (w1_reset_select_slave(sl))
 			continue;
 		w1_buf[0] = W1_DS2438_RECALL_MEMORY;
-		w1_buf[1] = 0x00;
+		w1_buf[1] = (u8)pageno;
 		w1_write_block(sl->master, w1_buf, 2);
 
 		if (w1_reset_select_slave(sl))
 			continue;
 		w1_buf[0] = W1_DS2438_READ_SCRATCH;
-		w1_buf[1] = 0x00;
+		w1_buf[1] = (u8)pageno;
 		w1_write_block(sl->master, w1_buf, 2);
 
 		count = w1_read_block(sl->master, buf, DS2438_PAGE_SIZE + 1);
-- 
2.30.2



