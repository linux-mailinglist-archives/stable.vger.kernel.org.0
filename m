Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7B82E65CD
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389736AbgL1N1v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:27:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:56314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389730AbgL1N1v (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:27:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B22A22A84;
        Mon, 28 Dec 2020 13:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162055;
        bh=7q5P0DVnbfNw9ADV7sZm/CJEuWx4cypt6stSvoMEWE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yZecQV5noLqGJlheglFo7UOh1uTepJBhLmfxXRa9dw4iqlfaln9+xBGkq9QbH3Bkb
         U85/jIigIdqBLKtR5sviO0ucfiqJlxdH4qk9wtCoMoFNllLHTULbX6MOgV0mYAsbwZ
         ED7JhWFUkhVmEYbtBvfTPrBJj8BQ0TjaN+ZlNK1g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 172/346] media: max2175: fix max2175_set_csm_mode() error code
Date:   Mon, 28 Dec 2020 13:48:11 +0100
Message-Id: <20201228124928.103705120@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 9b1b0cb0636166187478ef68d5b95f5caea062ec ]

This is supposed to return negative error codes but the type is bool so
it returns true instead.

Fixes: b47b79d8a231 ("[media] media: i2c: max2175: Add MAX2175 support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/max2175.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/max2175.c b/drivers/media/i2c/max2175.c
index 008a082cb8ad7..dddc5ef50dd4e 100644
--- a/drivers/media/i2c/max2175.c
+++ b/drivers/media/i2c/max2175.c
@@ -511,7 +511,7 @@ static void max2175_set_bbfilter(struct max2175 *ctx)
 	}
 }
 
-static bool max2175_set_csm_mode(struct max2175 *ctx,
+static int max2175_set_csm_mode(struct max2175 *ctx,
 			  enum max2175_csm_mode new_mode)
 {
 	int ret = max2175_poll_csm_ready(ctx);
-- 
2.27.0



