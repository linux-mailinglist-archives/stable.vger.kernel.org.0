Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92B39409213
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244125AbhIMOHs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:07:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:56002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344587AbhIMOFL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:05:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A23361A55;
        Mon, 13 Sep 2021 13:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540378;
        bh=/Bt1WLdub7QGdmo7tcpUjJSyt/+wCyLZmJuPXJN8XhI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fRi29TUpThH2p3oyg8rWDEpyjRYlV1Mv1d0WWj22FimjXG+tVRTN6CpHurBreAMsj
         NeRNmePMRAxaUdtAw8ez/dzlVx819uOThsQfGi7BlAlMyjGv/0EPeCqbz+GJnrbIT+
         j2nPN5r8IU6Tmg92vP+8VOLZPYOXwM+j0bU5dzk0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Syed Nayyar Waris <syednwaris@gmail.com>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 169/300] counter: 104-quad-8: Return error when invalid mode during ceiling_write
Date:   Mon, 13 Sep 2021 15:13:50 +0200
Message-Id: <20210913131115.118904807@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
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
index 9691f8612be8..8de776f3b142 100644
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



