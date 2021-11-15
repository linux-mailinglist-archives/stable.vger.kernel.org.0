Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF00452662
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:02:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244492AbhKPCFR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:05:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:46096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239958AbhKOSFL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:05:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BE5A632F4;
        Mon, 15 Nov 2021 17:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998028;
        bh=Y5dNhMld1C90DQZMQOpYZ9zXUZpC4o2B/ib4MnhGsbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sh+taERp1o9p89VrqGSfgsrQAAVTYeoqhQ3J/FwzR0oG16u5hU0nf3b+9m/v/vPV5
         gSaEn4FxwmnVabgz134TkEDUYpxhXrRFxOj4nllUq99vVl5Jh+FPfjCD9oDKksT+/+
         YZ/sEc8XhLoNQFJnYwtyYlYOw5eQi89byS2FsYTM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 328/575] media: ir_toy: assignment to be16 should be of correct type
Date:   Mon, 15 Nov 2021 18:00:53 +0100
Message-Id: <20211115165355.138432862@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Young <sean@mess.org>

[ Upstream commit febfe985fc2ea052a363f6525ff624b8efd5273c ]

commit f0c15b360fb6 ("media: ir_toy: prevent device from hanging during
transmit") removed a cpu_to_be16() cast, which causes a sparse warning.

Fixes: f0c15b360fb6 ("media: ir_toy: prevent device from hanging during transmit")
Reported-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/ir_toy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/ir_toy.c b/drivers/media/rc/ir_toy.c
index 48d52baec1a1c..1aa7989e756cc 100644
--- a/drivers/media/rc/ir_toy.c
+++ b/drivers/media/rc/ir_toy.c
@@ -310,7 +310,7 @@ static int irtoy_tx(struct rc_dev *rc, uint *txbuf, uint count)
 		buf[i] = cpu_to_be16(v);
 	}
 
-	buf[count] = 0xffff;
+	buf[count] = cpu_to_be16(0xffff);
 
 	irtoy->tx_buf = buf;
 	irtoy->tx_len = size;
-- 
2.33.0



