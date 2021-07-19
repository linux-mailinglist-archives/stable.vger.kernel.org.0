Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E73E3CDF2F
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345149AbhGSPIF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:08:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:38868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344450AbhGSPFl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:05:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D8E6601FD;
        Mon, 19 Jul 2021 15:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709581;
        bh=VyUYoGc0fRI9HeQs++m8Dx7lc69ovuKcRA88FLLpTxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YH5myaGX8tTF2gxcXIAPoWG5NbGXNWvimfFcrYdPS6Ljfx+9gKuneeySioWK6Orkx
         LCufrfiLNKezC6g7mtHOOCVrpOPTcaUkoDJwZsvxihItfHp6HfqR8w1mCjrSS5OBuy
         WfStOfnXnEyIuBPk6RmyVN0MzJq912f1FfJLGgj0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luiz Sampaio <sampaio.ime@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 018/149] w1: ds2438: fixing bug that would always get page0
Date:   Mon, 19 Jul 2021 16:52:06 +0200
Message-Id: <20210719144905.789831079@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144901.370365147@linuxfoundation.org>
References: <20210719144901.370365147@linuxfoundation.org>
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
index d199e5a25cc0..404dacb15004 100644
--- a/drivers/w1/slaves/w1_ds2438.c
+++ b/drivers/w1/slaves/w1_ds2438.c
@@ -62,13 +62,13 @@ static int w1_ds2438_get_page(struct w1_slave *sl, int pageno, u8 *buf)
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



