Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AAB93C559B
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbhGLILM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:11:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:55666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353796AbhGLIDA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:03:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAB296198E;
        Mon, 12 Jul 2021 07:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076654;
        bh=1NtSEUPRcHjsVNC3E33gn449fZInaicK/kZfthlSH5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZiJ1jPXwWGsA+h4e9htEWJFVZhGlSRPxkekljKMjLMxFC7V7aemrvWy8NfbneBFom
         xA3KLPbJ6Si6WCgPJgQs0lchyIjv5iQDeM+NGV3UCcSYl49BezLVyFl1ZIZhUEvlTR
         JkOWxuRdy+s9hefnf4ZgFVoa3nowIfmm1MYjj+fU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephan Gerhold <stephan@gerhold.net>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 735/800] extcon: sm5502: Drop invalid register write in sm5502_reg_data
Date:   Mon, 12 Jul 2021 08:12:38 +0200
Message-Id: <20210712061044.969227529@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
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
index db41d1c58efd..c3e4b220e66f 100644
--- a/drivers/extcon/extcon-sm5502.c
+++ b/drivers/extcon/extcon-sm5502.c
@@ -88,7 +88,6 @@ static struct reg_data sm5502_reg_data[] = {
 			| SM5502_REG_INTM2_MHL_MASK,
 		.invert = true,
 	},
-	{ }
 };
 
 /* List of detectable cables */
-- 
2.30.2



