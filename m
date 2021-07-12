Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADA843C5074
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242545AbhGLHdA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:33:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:43510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343584AbhGLH2g (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:28:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D827A6127C;
        Mon, 12 Jul 2021 07:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074648;
        bh=wpxCS1/3GvN2YASU2eStpfTsM2QfVP03V9ChL91BU10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0F3IAnmLdqilsvsy/9X3kJl6TnkuDRRAXeXreFn/nTiwie+1kVd0E6PXTOLOrardm
         HXeJ66XpU0v9RxsbPtOwBZskgnYKaTRBrhnGY5+JzTy48+HUGxcoJww6NbG+yQfnTu
         QOX3Y8AvKHlki15J+D2dpNED9z40CVA9lCnpnQus=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 650/700] leds: as3645a: Fix error return code in as3645a_parse_node()
Date:   Mon, 12 Jul 2021 08:12:13 +0200
Message-Id: <20210712061045.016392079@linuxfoundation.org>
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

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit 96a30960a2c5246c8ffebe8a3c9031f9df094d97 ]

Return error code -ENODEV rather than '0' when the indicator node can not
be found.

Fixes: a56ba8fbcb55 ("media: leds: as3645a: Add LED flash class driver")
Reported-by: Hulk Robot <hulkci@huawei.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-as3645a.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/leds/leds-as3645a.c b/drivers/leds/leds-as3645a.c
index e8922fa03379..80411d41e802 100644
--- a/drivers/leds/leds-as3645a.c
+++ b/drivers/leds/leds-as3645a.c
@@ -545,6 +545,7 @@ static int as3645a_parse_node(struct as3645a *flash,
 	if (!flash->indicator_node) {
 		dev_warn(&flash->client->dev,
 			 "can't find indicator node\n");
+		rval = -ENODEV;
 		goto out_err;
 	}
 
-- 
2.30.2



