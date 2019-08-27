Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD3BE9E16C
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730404AbfH0H7d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 03:59:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:53074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731232AbfH0H7c (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 03:59:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B94FE206BF;
        Tue, 27 Aug 2019 07:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892772;
        bh=isvN1jFcyXGNsRWOLMIIqbt9jrnVO/ZAKkLb+61Kmrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZIXJovVBZPfdOz6f0QU9kirrZjLmcpZ9gl2gMHu5M02/tVLNXOk9g5c/mdASwBEjW
         NokzwDEUw5Iv25qvejbbMmfLVxdKXuQxD4/Lvn77qOmrINtEyGo+xLYKZTy4VnS3Gy
         93SGWgAYPbYak10ZVG/hi8vsyu6OpebjW0jTlQxg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 001/162] ASoC: simple_card_utils.h: care NULL dai at asoc_simple_debug_dai()
Date:   Tue, 27 Aug 2019 09:48:49 +0200
Message-Id: <20190827072738.194602192@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 52db6685932e326ed607644ab7ebdae8c194adda ]

props->xxx_dai might be NULL when DPCM.
This patch cares it for debug.

Fixes: commit 0580dde59438 ("ASoC: simple-card-utils: add asoc_simple_debug_info()")
Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://lore.kernel.org/r/87o922gw4u.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/simple_card_utils.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/sound/simple_card_utils.h b/include/sound/simple_card_utils.h
index 3429888347e7c..b3609e4c46e0f 100644
--- a/include/sound/simple_card_utils.h
+++ b/include/sound/simple_card_utils.h
@@ -149,6 +149,10 @@ inline void asoc_simple_debug_dai(struct asoc_simple_priv *priv,
 {
 	struct device *dev = simple_priv_to_dev(priv);
 
+	/* dai might be NULL */
+	if (!dai)
+		return;
+
 	if (dai->name)
 		dev_dbg(dev, "%s dai name = %s\n",
 			name, dai->name);
-- 
2.20.1



