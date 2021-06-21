Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1753AEDDE
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232017AbhFUQX1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:23:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:42142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231357AbhFUQWJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:22:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4739261261;
        Mon, 21 Jun 2021 16:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292387;
        bh=QWtKINgTOKGQKYzKNcJMx5++0guRoY2R1hh0S4UIlnE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JGmpaGplwtKolf8D38uu8tpi79SEIBJsz07Us5fXqI7bXEZb5GYVeUl7B7MPtJKoZ
         59u4257geUKiPnSv27HMVD+lJ4qrEzwiQBcvOsSBHmrgV59ABJQalQXkYw9VdFWle/
         LHI9MYsKA6frDwy3EO75ypvo5cMUKlYtZQcowVck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Pavel Machek (CIP)" <pavel@denx.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 38/90] cxgb4: fix wrong shift.
Date:   Mon, 21 Jun 2021 18:15:13 +0200
Message-Id: <20210621154905.414853069@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154904.159672728@linuxfoundation.org>
References: <20210621154904.159672728@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Machek <pavel@denx.de>

[ Upstream commit 39eb028183bc7378bb6187067e20bf6d8c836407 ]

While fixing coverity warning, commit dd2c79677375 introduced typo in
shift value. Fix that.

Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>
Fixes: dd2c79677375 ("cxgb4: Fix unintentional sign extension issues")
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
index ccb28182f745..44f86a33ef62 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
@@ -198,7 +198,7 @@ static void set_nat_params(struct adapter *adap, struct filter_entry *f,
 				      WORD_MASK, f->fs.nat_lip[3] |
 				      f->fs.nat_lip[2] << 8 |
 				      f->fs.nat_lip[1] << 16 |
-				      (u64)f->fs.nat_lip[0] << 25, 1);
+				      (u64)f->fs.nat_lip[0] << 24, 1);
 		}
 	}
 
-- 
2.30.2



