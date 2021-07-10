Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96E2B3C2CF7
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232267AbhGJCVS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:21:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:37760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231918AbhGJCVJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:21:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF7AA613DC;
        Sat, 10 Jul 2021 02:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883505;
        bh=O9+YOua0G9KnyA2M8OLH87WPhPFNQl5D35Y7gWGQ2s4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hYMZResBV67p2CsEm7QqkWWPEDAX+0bLKCM2ule2VLLrjlgOllE0Ozx0Ygx2DvICs
         Hc6ULd0eiLi1fklcAlonTPu9Gjrd/pJ96G5nvG3hG70vJ1Adv1PmUCvLjCy+XgmzzB
         qgbkCJplzi69nPnKRYPklJsVXqVmSi4gD7Bz0PntfKBHcG1JYha6kp42HBntpdGS/2
         VbBmbscJTS+TTkD6Jgjct4lFwP58y1RQxY+3BRa8UcdPs6Hnu2Yp0+zKpPAvo9G68d
         DE9S6G4hiz1u5LXLz7c1uTcjz2/ivyo7vfamPztJCHroSzDAOqYp56IqwxK4Sy+w/C
         COxepaHFXGbLg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luiz Sampaio <sampaio.ime@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.13 026/114] w1: ds2438: fixing bug that would always get page0
Date:   Fri,  9 Jul 2021 22:16:20 -0400
Message-Id: <20210710021748.3167666-26-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710021748.3167666-1-sashal@kernel.org>
References: <20210710021748.3167666-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 5cfb0ae23e91..5698566b0ee0 100644
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

