Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87B04491C6D
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:16:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356063AbiARDPF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:15:05 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60870 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234974AbiARDJH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 22:09:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CDC25601E3;
        Tue, 18 Jan 2022 03:09:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83149C36AF2;
        Tue, 18 Jan 2022 03:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642475346;
        bh=jfkLL6rXolBMxv55YyFzWn2CWtcA4vLhtAVsUilZUhY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PBUpNlHtIyQUu5GtuD3QE3CWdgAnYmcqDnUPNhhpfq4RX5qGCFrGZGWUknnUA5GwV
         1H97FICqbwZR6x7Bc+gQd8s3/FXaTD1QtWOyAOWWl5jFZRAeZ5TQYCBpE3pkePAiCG
         zi3MO6+uh1Y90LGuHmBa2wjptllZZyn77sdSnl33cJ1qEJGdYZzlQDP0EYKKrCQ8Xj
         9kZI/OdyL6K5uaj9OMA7qDmqDlPANk0cJBzRTjmGR8iFFk5Nq3seAgwOjYsY0lrwzp
         f0FefceVrphkV8mHA9CsLDpdRhpFbcDTSCezj14Zyzuad885b5RcC2oR3OdM9v3fQp
         U5epQ5d9/8hIg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, mchehab@kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 15/29] media: igorplugusb: receiver overflow should be reported
Date:   Mon, 17 Jan 2022 22:08:08 -0500
Message-Id: <20220118030822.1955469-15-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118030822.1955469-1-sashal@kernel.org>
References: <20220118030822.1955469-1-sashal@kernel.org>
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
index b36e51576f8e4..645ea00c472ab 100644
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

