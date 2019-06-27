Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 027BE57881
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 02:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbfF0AcU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 20:32:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:35956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727436AbfF0AcS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jun 2019 20:32:18 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87A6D21726;
        Thu, 27 Jun 2019 00:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595537;
        bh=gmmiuDkbFlzLqd6DkAtNbOiOZKqnv3fzAAXSd+132jg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UaNDmPiK30MN7k2mqyc4DKNguM43HTwosR8ruRYRoAcB/xai69FC86gZ8O7HFxS4U
         LEhaymVTuq2f5zq7K0qeczxWuwvS6IDvIkLVOAytvEBzHmaTYtmJKVBXMKIavwsM65
         eUfGak22PRf/or0f2QmJyZ3odaOe2JxvevlCr73U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Sanyog Kale <sanyog.r.kale@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.1 34/95] soundwire: stream: fix bad unlock balance
Date:   Wed, 26 Jun 2019 20:29:19 -0400
Message-Id: <20190627003021.19867-34-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003021.19867-1-sashal@kernel.org>
References: <20190627003021.19867-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

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

