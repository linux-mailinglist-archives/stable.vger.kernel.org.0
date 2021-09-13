Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56131408F91
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242418AbhIMNoM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:44:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:46760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240811AbhIMNmH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:42:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B81186128A;
        Mon, 13 Sep 2021 13:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539812;
        bh=OOscOqLtTwZQiu644CihXV17xrXGCW19bhSfM2xPhy4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F8E7sQM/dIKXwS/If/RRYeONI9wfUm9/j3/54hgh6NlgPgk9F0jxqS1Ii5NIuIxxX
         mIiR2fcP24TjK15TxWTsSmWxmeF9NoLiEPsBdfwL43UF/jSWA+GulLAmUrxemYF7FU
         unxMElZf5jLqdQJyYsG4330yX+va5p5+5X7Y2050=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Syed Nayyar Waris <syednwaris@gmail.com>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 137/236] counter: 104-quad-8: Return error when invalid mode during ceiling_write
Date:   Mon, 13 Sep 2021 15:14:02 +0200
Message-Id: <20210913131105.019593985@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
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
index 78766b6ec271..21bb2bb767a1 100644
--- a/drivers/counter/104-quad-8.c
+++ b/drivers/counter/104-quad-8.c
@@ -1224,12 +1224,13 @@ static ssize_t quad8_count_ceiling_write(struct counter_device *counter,
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



