Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94410404D8A
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245334AbhIIMDL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:03:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:43172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244556AbhIIMBE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:01:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85C2C61504;
        Thu,  9 Sep 2021 11:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187978;
        bh=FRlfRcOfgCtOTdfU3QTC244vJyhczVbj6UOvqJ//CIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a8R4HU19NYWPD/GaAYT+gqb7yCeu2s7auiTJmliG4BKxOQjrScsmWDjZ2A82RsGCi
         XaRBbeu/J3QZxcUF8q3xIQ8i438+8xS6IRzn5b2RinDrxy6d2AwpmZi42GN7hq659U
         qInhGrRlVhJ2UB5CGXiJkhpdUTtv1QTCwAkHfVlVFQRlK8Z/TodPYe8aLKu4QjMCFl
         IOTtaMkBFNvuhSuYQ+xCjZNziyQnb54Ov2RuNkQ5r1HBVRzXTRiXyPuwq8IvZydTX7
         Pj/3eih71fpS/T4vCORVwqvbH/Jtl/GcApS6V9MaPytO8ya7dbz1582ICSVVKkqJzR
         pyMxZQeld/GLA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rui Miguel Silva <rui.silva@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 240/252] usb: isp1760: fix qtd fill length
Date:   Thu,  9 Sep 2021 07:40:54 -0400
Message-Id: <20210909114106.141462-240-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

