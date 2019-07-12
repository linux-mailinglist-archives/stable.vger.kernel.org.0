Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72C0166E68
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727950AbfGLM2W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:28:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:42076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727530AbfGLM2U (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:28:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7838F2084B;
        Fri, 12 Jul 2019 12:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934500;
        bh=IMQot/HOMIyuIRMyLHqWT19plTn8X5tINhLp925YUBM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CNlok3POrOt7bskEqP1IO2XRhYnvZqoS5w4GAn45InqrUHFZQswnANVtFh78r0eFm
         GOeHEaEVppCi3IWJnKLL9gVvg5oshciuhs+cfVTZy5AZbBoeeiXwNg1+W1em+DOBKP
         mI8ioe7IAqQrcJAUP/U/CGIMAzFaA51hrLbT9QZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Sanyog Kale <sanyog.r.kale@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 031/138] soundwire: stream: fix bad unlock balance
Date:   Fri, 12 Jul 2019 14:18:15 +0200
Message-Id: <20190712121629.888401834@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121628.731888964@linuxfoundation.org>
References: <20190712121628.731888964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 9315d904c7e8f38886e2820fa6cb8d0fa723ea21 ]

the msg lock is taken for multi-link cases only but released
unconditionally, leading to an unlock balance warning for single-link usages
This patch fixes this.

 =====================================
 WARNING: bad unlock balance detected!
 5.1.0-16506-gc1c383a6f0a2-dirty #1523 Tainted: G        W
 -------------------------------------
 aplay/2954 is trying to release lock (&bus->msg_lock) at:
 do_bank_switch+0x21c/0x480
 but there are no more locks to release!

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Acked-by: Sanyog Kale <sanyog.r.kale@intel.com>
[vkoul: edited the change log as suggested by Pierre]
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/stream.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/soundwire/stream.c b/drivers/soundwire/stream.c
index 00618de2ee12..794ced434cf2 100644
--- a/drivers/soundwire/stream.c
+++ b/drivers/soundwire/stream.c
@@ -805,7 +805,8 @@ static int do_bank_switch(struct sdw_stream_runtime *stream)
 			goto error;
 		}
 
-		mutex_unlock(&bus->msg_lock);
+		if (bus->multi_link)
+			mutex_unlock(&bus->msg_lock);
 	}
 
 	return ret;
-- 
2.20.1



