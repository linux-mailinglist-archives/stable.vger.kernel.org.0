Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8F531BD14
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbhBOPjh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:39:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:49638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231463AbhBOPht (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:37:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 456A664EA3;
        Mon, 15 Feb 2021 15:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403191;
        bh=2d82ML/lsPXn5JpjMp119lFurxZ44IhVjiVuGINp/T8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IOPUSQF8XRdhHPKp9w9xHiWjcAcJtt9WtrHpdxvjJ7dbv4z3eF0Bliq1WX0vPxkCv
         pCcOGDOguooHw9HBNAt+ALeBJ1RMjDKlcBF3OBUd2r0uWhBpbeY/KO1SHGWdcspq/R
         u19Q9mEwTYW+fxkg/C8dWmqU8rXZRfatkvVybFV0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xie He <xie.he.0141@gmail.com>,
        Martin Schiller <ms@dev.tdt.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 062/104] net: hdlc_x25: Return meaningful error code in x25_open
Date:   Mon, 15 Feb 2021 16:27:15 +0100
Message-Id: <20210215152721.473422296@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xie He <xie.he.0141@gmail.com>

[ Upstream commit 81b8be68ef8e8915d0cc6cedd2ac425c74a24813 ]

It's not meaningful to pass on LAPB error codes to HDLC code or other
parts of the system, because they will not understand the error codes.

Instead, use system-wide recognizable error codes.

Fixes: f362e5fe0f1f ("wan/hdlc_x25: make lapb params configurable")
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Xie He <xie.he.0141@gmail.com>
Acked-by: Martin Schiller <ms@dev.tdt.de>
Link: https://lore.kernel.org/r/20210203071541.86138-1-xie.he.0141@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wan/hdlc_x25.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wan/hdlc_x25.c b/drivers/net/wan/hdlc_x25.c
index f52b9fed05931..34bc53facd11c 100644
--- a/drivers/net/wan/hdlc_x25.c
+++ b/drivers/net/wan/hdlc_x25.c
@@ -171,11 +171,11 @@ static int x25_open(struct net_device *dev)
 
 	result = lapb_register(dev, &cb);
 	if (result != LAPB_OK)
-		return result;
+		return -ENOMEM;
 
 	result = lapb_getparms(dev, &params);
 	if (result != LAPB_OK)
-		return result;
+		return -EINVAL;
 
 	if (state(hdlc)->settings.dce)
 		params.mode = params.mode | LAPB_DCE;
@@ -190,7 +190,7 @@ static int x25_open(struct net_device *dev)
 
 	result = lapb_setparms(dev, &params);
 	if (result != LAPB_OK)
-		return result;
+		return -EINVAL;
 
 	return 0;
 }
-- 
2.27.0



