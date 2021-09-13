Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49224408EF0
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240766AbhIMNiR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:38:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:37648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241299AbhIMNgQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:36:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E67E8610FE;
        Mon, 13 Sep 2021 13:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539643;
        bh=7IiXsDjGteExINZcndnmgC91TIRkv8xhMZey/zp+I2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yiNo3BZkgCSWauSulQ62apqbg3djEX9F2zmbyz9rxQl1r1dv2OwERhJhzOU1h4jCK
         z6yDDtx9b07i554RggSaX0x6wDPcz4oNpS8424uxX0igDUVx7Z3P27XAGgeembRdbh
         yPDVVkfmoot9dz3OGAxwY+tsE1gBFVNAj4P5NW7M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Harshvardhan Jha <harshvardhan.jha@oracle.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 070/236] drm/gma500: Fix end of loop tests for list_for_each_entry
Date:   Mon, 13 Sep 2021 15:12:55 +0200
Message-Id: <20210913131102.738844806@linuxfoundation.org>
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

From: Harshvardhan Jha <harshvardhan.jha@oracle.com>

[ Upstream commit ea9a897b8affa0f7b4c90182b785dded74e434aa ]

The list_for_each_entry() iterator, "connector" in this code, can never be
NULL.  If we exit the loop without finding the correct  connector then
"connector" points invalid memory that is an offset from the list head.
This will eventually lead to memory corruption and presumably a kernel
crash.

Fixes: 9bd81acdb648 ("gma500: Convert Oaktrail to work with new output handling")
Signed-off-by: Harshvardhan Jha <harshvardhan.jha@oracle.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20210709073959.11443-1-harshvardhan.jha@oracle.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/gma500/oaktrail_lvds.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/gma500/oaktrail_lvds.c b/drivers/gpu/drm/gma500/oaktrail_lvds.c
index 2828360153d1..30b949d6856c 100644
--- a/drivers/gpu/drm/gma500/oaktrail_lvds.c
+++ b/drivers/gpu/drm/gma500/oaktrail_lvds.c
@@ -117,7 +117,7 @@ static void oaktrail_lvds_mode_set(struct drm_encoder *encoder,
 			continue;
 	}
 
-	if (!connector) {
+	if (list_entry_is_head(connector, &mode_config->connector_list, head)) {
 		DRM_ERROR("Couldn't find connector when setting mode");
 		gma_power_end(dev);
 		return;
-- 
2.30.2



