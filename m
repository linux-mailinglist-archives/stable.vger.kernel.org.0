Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 448EC491C1D
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347282AbiARDNf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:13:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353714AbiARDEZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 22:04:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 264D3C0219F5;
        Mon, 17 Jan 2022 18:48:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1823B81136;
        Tue, 18 Jan 2022 02:48:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3D5AC36AF3;
        Tue, 18 Jan 2022 02:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642474087;
        bh=s1zOZaBKK25K2dWFszrxbwGQGSRLpyHYOg5sPtaaNN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qiSpspl8XDY1CjX71qdVix6gta6N+6ytZKVMtpLyNYzKL7mQ3cZ4uinx4YpcMIL0T
         ZXGzgM3ARzT67vkNVIoxQ8hOoKPw0EWvbnv/hKUecBbouGiyRqlwUH9ka+I9lkO0o9
         0m3fAWqJk+RpadbORZZUvYSgwxql5sAXNtTlzs16u/sRVNC3zu8+X32Mv2Fu8fQXD1
         JboTrwH/tE0wVx8i9ts//wSbGDw683W8bujVPBQ3woy+VmtPn7C4QTT0RxsU5Wok0q
         wVVCfORpZ+AGyrV+npoI0P6fkkgolNvmejNozyG6o9wzMzoeSfjpXca0X06noRElzu
         PTO+zaOqpar2Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, mchehab@kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 30/59] media: igorplugusb: receiver overflow should be reported
Date:   Mon, 17 Jan 2022 21:46:31 -0500
Message-Id: <20220118024701.1952911-30-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024701.1952911-1-sashal@kernel.org>
References: <20220118024701.1952911-1-sashal@kernel.org>
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
index f563ddd7f7392..98a13532a5968 100644
--- a/drivers/media/rc/igorplugusb.c
+++ b/drivers/media/rc/igorplugusb.c
@@ -73,9 +73,11 @@ static void igorplugusb_irdata(struct igorplugusb *ir, unsigned len)
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

