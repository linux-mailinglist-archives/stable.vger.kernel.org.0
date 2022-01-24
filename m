Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABB1149A414
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:08:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2369292AbiAYAB2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:01:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1847608AbiAXXUH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:20:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7888AC073204;
        Mon, 24 Jan 2022 13:27:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1595D614B4;
        Mon, 24 Jan 2022 21:27:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE1EEC340E4;
        Mon, 24 Jan 2022 21:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059674;
        bh=WPTVkbAlftiPDcELrGcS+39e8k3c46GZhJ5lqBJBBQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oLuMTb9b2XCUT4uVdp3cCyoYvlnYIoIZthJnIOrvHSaEgeJW+4J8YvrL2PqxhAXMz
         5TWO8frEH8k6roTwl4nEnrS+OIfIEf0NTySwcxvpK11XMN5lVQlHPN4WQBaivk5+3O
         v/ytmFmjwQkyi9DrgXV/xIJEI0thf135Ln0FX6EM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0652/1039] media: igorplugusb: receiver overflow should be reported
Date:   Mon, 24 Jan 2022 19:40:41 +0100
Message-Id: <20220124184147.276927311@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



