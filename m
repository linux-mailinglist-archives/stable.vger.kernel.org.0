Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC611491587
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244613AbiARC2i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:28:38 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40148 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343651AbiARC0g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:26:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 816EFB81249;
        Tue, 18 Jan 2022 02:26:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99EADC36AF6;
        Tue, 18 Jan 2022 02:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472793;
        bh=WPTVkbAlftiPDcELrGcS+39e8k3c46GZhJ5lqBJBBQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U8letCoFF8X+NbnjxC7DRbpvmvrHosTc15zC79BxbHhUl9r7ALPihPl1WRIwyNity
         MTH224Bu3M26T1KeuDkI2/ZK9tdVGnyf8WDdhASjUOmtabyHOTRZrjb2Ltd9NflGxZ
         9c4003doSPggbZQ5au44nOOU+U0MMuZMiDdzxlDToNvjnZwfbWmcqXMT1STERfa7YJ
         uIaSRUyYyg8K9J4B8/WDhcH8eh63XqVlTeFenukRsiR81xUfsbMbJIha5ebfTrnGT4
         6BgbdnRqtYGI9uKqyYlDaSJrlgbHDPgK5Y7MXc0R3JyUlL/rihP20/y5C+kkz85Aji
         glXxJcaGXDolw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, mchehab@kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 134/217] media: igorplugusb: receiver overflow should be reported
Date:   Mon, 17 Jan 2022 21:18:17 -0500
Message-Id: <20220118021940.1942199-134-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
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
index effaa5751d6c9..3e9988ee785f0 100644
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
 			rawir.duration = ir->buf_in[i] * 85;
-- 
2.34.1

