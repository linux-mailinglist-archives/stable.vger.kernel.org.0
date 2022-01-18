Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00558491B43
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:06:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241810AbiARDCv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:02:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350184AbiARC5j (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:57:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4283C061365;
        Mon, 17 Jan 2022 18:45:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70D5561312;
        Tue, 18 Jan 2022 02:45:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FFCBC36AF2;
        Tue, 18 Jan 2022 02:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473955;
        bh=brX5qYXObnA5ZMaKED0orH5yXmiH2X/NMgB9WdDLijI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ic8XngfexP88LriPjLQJ4apMZcYB49dPQ2OWW9krul95fxwQSIF6C0PHt9Rmw9A0g
         7bw9ZEsQqaofMDptbxq3yuo8wA+ICByqEEN0OWdnUk17oe4FEbN0Kn+s+TIl6VTmo5
         96jwwSOI1/Wg07nBE0NnKfQaxYh1+huurRRPzy/w09Z7Ula73MsKWuZNH4CGc7IdbW
         RWg9ddPrc4U1vb/yocglTZ2xstYjwVt3umyCFg2Gez2Xv5oUHWkUJ7cpxwKNJwmVHK
         Js/aggiROWhWVoXhRMxBmxuaareXTtXteC6ApwyJ0kBuXeRvYYXUHrtixcYoV/zFaM
         BzVe5mL9p49zg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, mchehab@kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 40/73] media: igorplugusb: receiver overflow should be reported
Date:   Mon, 17 Jan 2022 21:43:59 -0500
Message-Id: <20220118024432.1952028-40-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024432.1952028-1-sashal@kernel.org>
References: <20220118024432.1952028-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Young <sean@mess.org>

[ Upstream commit 8fede658e7ddb605bbd68ed38067ddb0af033db4 ]

Without this, some IR will be missing mid-stream and we might decode
something which never really occurred.

Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/igorplugusb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/igorplugusb.c b/drivers/media/rc/igorplugusb.c
index b981f7290c1b2..1e8276040ea5b 100644
--- a/drivers/media/rc/igorplugusb.c
+++ b/drivers/media/rc/igorplugusb.c
@@ -64,9 +64,11 @@ static void igorplugusb_irdata(struct igorplugusb *ir, unsigned len)
 	if (start >= len) {
 		dev_err(ir->dev, "receive overflow invalid: %u", overflow);
 	} else {
-		if (overflow > 0)
+		if (overflow > 0) {
 			dev_warn(ir->dev, "receive overflow, at least %u lost",
 								overflow);
+			ir_raw_event_reset(ir->rc);
+		}
 
 		do {
 			rawir.duration = ir->buf_in[i] * 85333;
-- 
2.34.1

