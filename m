Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D39BB2B651F
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731992AbgKQNbG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:31:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:40344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731826AbgKQNbF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:31:05 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 689E920781;
        Tue, 17 Nov 2020 13:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619864;
        bh=6iPDGywv2BdeJXCuQXGiKLHy/KWmsTl3yxjvIAgIiTs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=an/o1ajrehJGbToV6JYSF1Qb7YZ7sagPnaRQ1vwMxGgoop0FY4pX0J8AlUXt2BHSZ
         WvcARKjC35hMDWGBCM+jw8iDNTW5vZ2RADN3RbnMu/24BogZT9CLep1cnnRMJh3+6g
         sog5FZDcH5zRgBXCmswQufuvzLAdPkj4gbvKWk64=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olaf Hering <olaf@aepfle.de>,
        Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 009/255] hv_balloon: disable warning when floor reached
Date:   Tue, 17 Nov 2020 14:02:29 +0100
Message-Id: <20201117122139.389275270@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olaf Hering <olaf@aepfle.de>

[ Upstream commit 2c3bd2a5c86fe744e8377733c5e511a5ca1e14f5 ]

It is not an error if the host requests to balloon down, but the VM
refuses to do so. Without this change a warning is logged in dmesg
every five minutes.

Fixes:  b3bb97b8a49f3 ("Drivers: hv: balloon: Add logging for dynamic memory operations")

Signed-off-by: Olaf Hering <olaf@aepfle.de>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/20201008071216.16554-1-olaf@aepfle.de
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/hv_balloon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
index 32e3bc0aa665a..0f50295d02149 100644
--- a/drivers/hv/hv_balloon.c
+++ b/drivers/hv/hv_balloon.c
@@ -1275,7 +1275,7 @@ static void balloon_up(struct work_struct *dummy)
 
 	/* Refuse to balloon below the floor. */
 	if (avail_pages < num_pages || avail_pages - num_pages < floor) {
-		pr_warn("Balloon request will be partially fulfilled. %s\n",
+		pr_info("Balloon request will be partially fulfilled. %s\n",
 			avail_pages < num_pages ? "Not enough memory." :
 			"Balloon floor reached.");
 
-- 
2.27.0



