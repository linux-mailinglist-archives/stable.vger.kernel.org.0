Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78E8F2B61FA
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730983AbgKQNYP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:24:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:59212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730816AbgKQNYM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:24:12 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6406320781;
        Tue, 17 Nov 2020 13:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619452;
        bh=hEogCxXzH85eSFxBfZIrJ2xpfFDACoX9NVPH/03eZps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i4Thln3nc6Bbour5a3LlccZkhbVXOyiFy0HH9YwIu9jWzWYgCSj8H8bvsvphTNzar
         /eMULUnct2Lw8rI++PWdwNffelcisdRZLvsOX6fHLhJnNvaAA0lZWMsBbh8yCx8lC9
         nkO8umuc0V9kZ8YSGyiwVKSaNiWV2LjIU/wsNrUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olaf Hering <olaf@aepfle.de>,
        Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 013/151] hv_balloon: disable warning when floor reached
Date:   Tue, 17 Nov 2020 14:04:03 +0100
Message-Id: <20201117122122.053136085@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
References: <20201117122121.381905960@linuxfoundation.org>
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
index 930674117533e..bd4e72f6dfd49 100644
--- a/drivers/hv/hv_balloon.c
+++ b/drivers/hv/hv_balloon.c
@@ -1277,7 +1277,7 @@ static void balloon_up(struct work_struct *dummy)
 
 	/* Refuse to balloon below the floor. */
 	if (avail_pages < num_pages || avail_pages - num_pages < floor) {
-		pr_warn("Balloon request will be partially fulfilled. %s\n",
+		pr_info("Balloon request will be partially fulfilled. %s\n",
 			avail_pages < num_pages ? "Not enough memory." :
 			"Balloon floor reached.");
 
-- 
2.27.0



