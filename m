Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C04BC1990C0
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730482AbgCaJOT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:14:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:34088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730452AbgCaJOS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:14:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D72420675;
        Tue, 31 Mar 2020 09:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585646058;
        bh=xluyj0zuzesqOXbJY4Nak2oA9OlTyRQhQwI56NsHeus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gd5Z1YNbP2eA30xgjvS3Z5EiBdXwVu+UrcDUCwHMWBUhf0K4brarQhJA1sXE3MPJC
         Vy1M4f0kpSjsaEhQsKhWV8jCk/Kh+3znhh6v9pU1IzQ6IM+VXoms5cDokQx+6nf5br
         y6P6WRJchxeYu0sVf9/o9FEGuSY5UakxPwUA21Ao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Czarnota <dominik.b.czarnota@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 071/155] sxgbe: Fix off by one in samsung driver strncpy size arg
Date:   Tue, 31 Mar 2020 10:58:31 +0200
Message-Id: <20200331085426.355997346@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085418.274292403@linuxfoundation.org>
References: <20200331085418.274292403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dominik Czarnota <dominik.b.czarnota@gmail.com>

[ Upstream commit f3cc008bf6d59b8d93b4190e01d3e557b0040e15 ]

This patch fixes an off-by-one error in strncpy size argument in
drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c. The issue is that in:

        strncmp(opt, "eee_timer:", 6)

the passed string literal: "eee_timer:" has 10 bytes (without the NULL
byte) and the passed size argument is 6. As a result, the logic will
also accept other, malformed strings, e.g. "eee_tiXXX:".

This bug doesn't seem to have any security impact since its present in
module's cmdline parsing code.

Signed-off-by: Dominik Czarnota <dominik.b.czarnota@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
index c56fcbb370665..38767d7979147 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
@@ -2279,7 +2279,7 @@ static int __init sxgbe_cmdline_opt(char *str)
 	if (!str || !*str)
 		return -EINVAL;
 	while ((opt = strsep(&str, ",")) != NULL) {
-		if (!strncmp(opt, "eee_timer:", 6)) {
+		if (!strncmp(opt, "eee_timer:", 10)) {
 			if (kstrtoint(opt + 10, 0, &eee_timer))
 				goto err;
 		}
-- 
2.20.1



