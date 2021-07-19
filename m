Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E25F33CD9B8
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244347AbhGSObX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:31:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:38474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244097AbhGSO3T (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:29:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF50761263;
        Mon, 19 Jul 2021 15:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707327;
        bh=XkaSEoRy3urnR+ZfBGZLVTD0IIwMaR9DMVQ2vHi6Aas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JEOVsO09FM6BYxV4qYNLAhSdVLyOnYBGp2uUVZeaVjaOKMi0Cy9HJJ1ElQGiqbwWB
         ndZTbP/P1jyufP/UeeQrynQNZKLmUfwsTysw9B+LVMBnEiNJAnKWfwe7jbO1v2vf2S
         8x/zqUj0zoILLTIqVnBD0IiHVpxOZ/5JN5b8xTB0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephan Gerhold <stephan@gerhold.net>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 116/245] extcon: sm5502: Drop invalid register write in sm5502_reg_data
Date:   Mon, 19 Jul 2021 16:50:58 +0200
Message-Id: <20210719144944.161938886@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.288257948@linuxfoundation.org>
References: <20210719144940.288257948@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephan Gerhold <stephan@gerhold.net>

[ Upstream commit d25b224f8e5507879b36a769a6d1324cf163466c ]

When sm5502_init_dev_type() iterates over sm5502_reg_data to
initialize the registers it is limited by ARRAY_SIZE(sm5502_reg_data).
There is no need to add another empty element to sm5502_reg_data.

Having the additional empty element in sm5502_reg_data will just
result in writing 0xff to register 0x00, which does not really
make sense.

Fixes: 914b881f9452 ("extcon: sm5502: Add support new SM5502 extcon device driver")
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/extcon/extcon-sm5502.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/extcon/extcon-sm5502.c b/drivers/extcon/extcon-sm5502.c
index 9d2d8a6673c8..dbe5fc278f09 100644
--- a/drivers/extcon/extcon-sm5502.c
+++ b/drivers/extcon/extcon-sm5502.c
@@ -92,7 +92,6 @@ static struct reg_data sm5502_reg_data[] = {
 			| SM5502_REG_INTM2_MHL_MASK,
 		.invert = true,
 	},
-	{ }
 };
 
 /* List of detectable cables */
-- 
2.30.2



