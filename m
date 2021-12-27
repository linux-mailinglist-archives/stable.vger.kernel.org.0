Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0CF748041F
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 20:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233002AbhL0TH0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 14:07:26 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43176 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233006AbhL0TGb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 14:06:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0DC14B81142;
        Mon, 27 Dec 2021 19:06:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 115F0C36AED;
        Mon, 27 Dec 2021 19:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640631988;
        bh=UmbZKoKXCk8AGLF3bv8Ko5PZRmEXy4bbdijletGn9Ns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z+NszGtjVzfb0FRzdekkRvci5O/X8k2NA1aUPHyhdVU2y8I+SMS3gSE06SYNJxekb
         MBYWB/pjReRcj8kT348YItUAqdxWEndJ6iPMwGNHX7m0EDt+xg9w8657TAuuGRAJ5G
         6XratdTSmtR9L9jCNAGFE2QyzlyPwp5Cb3zaqJHJQ5bSbYBBB5vPYTr9vG2nSrA+tM
         SxUadRjZBcUIz34CxsH4dK3NHHgQ2jE5QxB/f7R5blS6yh79qd8Y4w10uu4P2CMwi3
         SJ55DeP2HMH2hQaw3J5BYJoqJYLf2pBk9IfOQPlHlvv4C6f0vWOL66Xjf889/jAXYP
         SaWe5NGtxxaxQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wang Qing <wangqing@vivo.com>, Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, markgross@kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 6/6] platform/x86: apple-gmux: use resource_size() with res
Date:   Mon, 27 Dec 2021 14:06:10 -0500
Message-Id: <20211227190615.1043350-6-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227190615.1043350-1-sashal@kernel.org>
References: <20211227190615.1043350-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Qing <wangqing@vivo.com>

[ Upstream commit eb66fb03a727cde0ab9b1a3858de55c26f3007da ]

This should be (res->end - res->start + 1) here actually,
use resource_size() derectly.

Signed-off-by: Wang Qing <wangqing@vivo.com>
Link: https://lore.kernel.org/r/1639484316-75873-1-git-send-email-wangqing@vivo.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/apple-gmux.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/apple-gmux.c b/drivers/platform/x86/apple-gmux.c
index fd2ffebc868fc..caa03565c139b 100644
--- a/drivers/platform/x86/apple-gmux.c
+++ b/drivers/platform/x86/apple-gmux.c
@@ -628,7 +628,7 @@ static int gmux_probe(struct pnp_dev *pnp, const struct pnp_device_id *id)
 	}
 
 	gmux_data->iostart = res->start;
-	gmux_data->iolen = res->end - res->start;
+	gmux_data->iolen = resource_size(res);
 
 	if (gmux_data->iolen < GMUX_MIN_IO_LEN) {
 		pr_err("gmux I/O region too small (%lu < %u)\n",
-- 
2.34.1

