Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 390FE491865
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:47:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348843AbiARCqh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:46:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347870AbiARCnS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:43:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 054E5C08E859;
        Mon, 17 Jan 2022 18:37:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D161B612CC;
        Tue, 18 Jan 2022 02:37:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B21CC36AF5;
        Tue, 18 Jan 2022 02:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473432;
        bh=WPTVkbAlftiPDcELrGcS+39e8k3c46GZhJ5lqBJBBQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J+vuK+LbjA9a3TVucVGRxGE9D1fSQOxNyafMNdoRBi5HBmQkc2iWrowTD+LADHInl
         4hSeN4NgX/rKhyDZBM1Vh3b6W27qztp7vmQ+6y89bCIZ4aRdjFwe+MFV48Zw8yPcT2
         aVVoaxZNAZgJqcNtLiwr9ST1GiEX52fK+bOV41Ndr/Ztr6c6jATfW+C7n1kHCYI+Ta
         ihTFkOxMSeRAKosB+1o4Cbj0YC+UYwNTpXeTCP1UxqvfpmIWf+PhwM0ThZrxa8L9iW
         ncOSCFp1qqaGyi1SkXFb3Li3BgtvA0XOSSaWCwvcmlU1nwfmMc3W+DIqCK6+vKhXbS
         cDPAuysdm7Dtg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, mchehab@kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 114/188] media: igorplugusb: receiver overflow should be reported
Date:   Mon, 17 Jan 2022 21:30:38 -0500
Message-Id: <20220118023152.1948105-114-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
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

