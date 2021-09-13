Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C691D4094F0
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344059AbhIMOge (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:36:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:53786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344574AbhIMOdw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:33:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C1B661BB1;
        Mon, 13 Sep 2021 13:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541165;
        bh=x0NJmNBpyU3laTS5E8kyiwcrKoQ/viyrT+AH9vqMvzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WPpzahhJFOiiZd9grtevEk2CQgj1KmmIXpPf/AiCGR+RTEE9a+aOHByPry8LGYK3D
         n/HOmwMeX02+2X6nHNsitMTuV48mrcRs3P/2Pc4zf0s3cIbH/4bEfrE1m0mtdzryCr
         4YjAKgwUlm98PR7+n6E4hJnxdZAul7vpX0Vva9NE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Syed Nayyar Waris <syednwaris@gmail.com>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 189/334] counter: 104-quad-8: Return error when invalid mode during ceiling_write
Date:   Mon, 13 Sep 2021 15:14:03 +0200
Message-Id: <20210913131119.743797713@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: William Breathitt Gray <vilhelm.gray@gmail.com>

[ Upstream commit 728246e8f7269ecd35a2c6e6795323e6d8f48db7 ]

The 104-QUAD-8 only has two count modes where a ceiling value makes
sense: Range Limit and Modulo-N. Outside of these two modes, setting a
ceiling value is an invalid operation -- so let's report it as such by
returning -EINVAL.

Fixes: fc069262261c ("counter: 104-quad-8: Add lock guards - generic interface")
Acked-by: Syed Nayyar Waris <syednwaris@gmail.com>
Signed-off-by: William Breathitt Gray <vilhelm.gray@gmail.com>
Link: https://lore.kernel.org/r/a2147f022829b66839a1db5530a7fada47856847.1627990337.git.vilhelm.gray@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/counter/104-quad-8.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/counter/104-quad-8.c b/drivers/counter/104-quad-8.c
index 09a9a77cce06..81f9642777fb 100644
--- a/drivers/counter/104-quad-8.c
+++ b/drivers/counter/104-quad-8.c
@@ -715,12 +715,13 @@ static ssize_t quad8_count_ceiling_write(struct counter_device *counter,
 	case 1:
 	case 3:
 		quad8_preset_register_set(priv, count->id, ceiling);
-		break;
+		mutex_unlock(&priv->lock);
+		return len;
 	}
 
 	mutex_unlock(&priv->lock);
 
-	return len;
+	return -EINVAL;
 }
 
 static ssize_t quad8_count_preset_enable_read(struct counter_device *counter,
-- 
2.30.2



