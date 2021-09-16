Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2BF040E87B
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 20:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355978AbhIPRon (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:44:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:57088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355400AbhIPRl0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:41:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A51861351;
        Thu, 16 Sep 2021 16:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631811175;
        bh=FRlfRcOfgCtOTdfU3QTC244vJyhczVbj6UOvqJ//CIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qRuoLn8OXisoNocIaCokHitPmQqzyvcFujNp/kLvJjcWz4ABJHbyTxc4LCTqGHPDC
         8FiSGKzggTkLSubvL4wt4VjECnjNzaLgf2RV8KGo+z6EvCtd27EzgBUugFY0Cq+ReF
         PBC/9znbZXPdZvfAbsbfQ76SzIjB9c/y8WsXVKGQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Rui Miguel Silva <rui.silva@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 378/432] usb: isp1760: fix qtd fill length
Date:   Thu, 16 Sep 2021 18:02:07 +0200
Message-Id: <20210916155823.626952602@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rui Miguel Silva <rui.silva@linaro.org>

[ Upstream commit cbfa3effdf5c2d411c9ce9820f3d33d77bc4697d ]

When trying to send bulks bigger than the biggest block size
we need to split them over several qtd. Fix this limiting the
maximum qtd size to largest block size.

Reported-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Tested-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
Link: https://lore.kernel.org/r/20210827131154.4151862-3-rui.silva@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/isp1760/isp1760-hcd.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/isp1760/isp1760-hcd.c b/drivers/usb/isp1760/isp1760-hcd.c
index ffb3a0c8c909..d2d19548241e 100644
--- a/drivers/usb/isp1760/isp1760-hcd.c
+++ b/drivers/usb/isp1760/isp1760-hcd.c
@@ -1826,9 +1826,11 @@ static void packetize_urb(struct usb_hcd *hcd,
 			goto cleanup;
 
 		if (len > mem->blocks_size[ISP176x_BLOCK_NUM - 1])
-			len = mem->blocks_size[ISP176x_BLOCK_NUM - 1];
+			this_qtd_len = mem->blocks_size[ISP176x_BLOCK_NUM - 1];
+		else
+			this_qtd_len = len;
 
-		this_qtd_len = qtd_fill(qtd, buf, len);
+		this_qtd_len = qtd_fill(qtd, buf, this_qtd_len);
 		list_add_tail(&qtd->qtd_list, head);
 
 		len -= this_qtd_len;
-- 
2.30.2



