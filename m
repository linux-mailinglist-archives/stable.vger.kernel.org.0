Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AEAE491856
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:46:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344642AbiARCqX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:46:23 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58616 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347803AbiARCnA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:43:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32439612D0;
        Tue, 18 Jan 2022 02:43:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3561C36AF4;
        Tue, 18 Jan 2022 02:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473779;
        bh=WPTVkbAlftiPDcELrGcS+39e8k3c46GZhJ5lqBJBBQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j2Vm+8rqj3X8sT8BsgS66fDDZ7hQ6Toi4WQi6DsQSQ+pc+BlVNq0nkVcHM1aEBEmz
         AZRBzG7mimTZOsaSTUnv9poS6QO7PlY1LC5MtWN+S1SJuDZ5+DITx32oR5XzLGpVMY
         272oQNW0GkHnD42ytSFWJ6+0p/WYNsd5IO6yiWirE4jabeDzrEtTEAGWg6t5EREoT2
         u80C8C+lNsXWygjlh77t4OyPw8i9FAN1QNEmSY2jaG+RVbaMLUQQtiSEziamfzK71y
         7SC5kZEsRRr4tMUL4jAnF8QKwt8YZzVF4pKYvGiLopFHDh6aGHVDor/rWE/ZfUaxgB
         3EkrZD7tqDXIg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, mchehab@kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 068/116] media: igorplugusb: receiver overflow should be reported
Date:   Mon, 17 Jan 2022 21:39:19 -0500
Message-Id: <20220118024007.1950576-68-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024007.1950576-1-sashal@kernel.org>
References: <20220118024007.1950576-1-sashal@kernel.org>
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

