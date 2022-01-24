Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA0E4990B0
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353456AbiAXUDB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:03:01 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45938 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347434AbiAXUA7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:00:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84943B8122C;
        Mon, 24 Jan 2022 20:00:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0FE7C340E8;
        Mon, 24 Jan 2022 20:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054456;
        bh=WPTVkbAlftiPDcELrGcS+39e8k3c46GZhJ5lqBJBBQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LvcvEoSxSGcYRWBBCR1NM6KmVfxcMQb9e9UWIoxXrYX5tcMUoh4+rfKvxUkW7oV0v
         dpI3scQQWxf3sGRXMitDpAWJUXi2dz5BditzV/FQ08MMkKrJshxHxylPokQ8FvIY7W
         WbdzdkDY4mgB+yoDzTXHl6PaR2NV8fPt5+ZVHkw0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 363/563] media: igorplugusb: receiver overflow should be reported
Date:   Mon, 24 Jan 2022 19:42:08 +0100
Message-Id: <20220124184036.962768088@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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



