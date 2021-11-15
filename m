Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 525AC4510E8
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237935AbhKOS4Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:56:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:58128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243233AbhKOSxo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:53:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7726F63479;
        Mon, 15 Nov 2021 18:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999836;
        bh=Y5dNhMld1C90DQZMQOpYZ9zXUZpC4o2B/ib4MnhGsbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UucLlEk6Slxsy6A3QJTVWpYxrSA/Ez5rpZXhhdH/15cvkYmCakwJZ1JDB2N7whzU1
         yHD9yOT4pK8k0lxf9uHvVL2+vRz9Botxy+RFX4oW/skVfjUOoRx1DOQScCDKitMJ1/
         MfijNFhD9hNrYEL7ZMFsVgKfmMM2DblzHgTgGEi0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 442/849] media: ir_toy: assignment to be16 should be of correct type
Date:   Mon, 15 Nov 2021 17:58:45 +0100
Message-Id: <20211115165435.233915317@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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



