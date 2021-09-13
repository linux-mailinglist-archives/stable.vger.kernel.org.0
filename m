Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88C07409478
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241112AbhIMOb1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:31:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:51898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346878AbhIMO3y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:29:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E227961B6F;
        Mon, 13 Sep 2021 13:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541041;
        bh=W/9OyMCIBDkFYitsxHS1MSsc19iKakqmMhUb9EfZU2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KYq6KDz2eD9aDFzY7EAEuFbPxt/YBBHM2hMKTmGqs2OF0QT5P25nTU//kNOkOeaFt
         qfsiP0EWHVctmYN5XHOraYvAB/Dnqn1HZUjKCqIZ+5B2R9l+gnOYf2rtaOZjxSkQuJ
         niq6XvREqgcIh6TlGRo3lI9WHk7Pq1xaSXjiAHAU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steven Price <steven.price@arm.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 095/334] drm/of: free the iterator object on failure
Date:   Mon, 13 Sep 2021 15:12:29 +0200
Message-Id: <20210913131116.591897448@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Price <steven.price@arm.com>

[ Upstream commit 6f9223a56fabc840836b49de27dc7b27642c6a32 ]

When bailing out due to the sanity check the iterator value needs to be
freed because the early return prevents for_each_child_of_node() from
doing the dereference itself.

Fixes: 6529007522de ("drm: of: Add drm_of_lvds_get_dual_link_pixel_order")
Signed-off-by: Steven Price <steven.price@arm.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210714143300.20632-1-steven.price@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_of.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_of.c b/drivers/gpu/drm/drm_of.c
index 197c57477344..997b8827fed2 100644
--- a/drivers/gpu/drm/drm_of.c
+++ b/drivers/gpu/drm/drm_of.c
@@ -331,8 +331,10 @@ static int drm_of_lvds_get_remote_pixels_type(
 		 * configurations by passing the endpoints explicitly to
 		 * drm_of_lvds_get_dual_link_pixel_order().
 		 */
-		if (!current_pt || pixels_type != current_pt)
+		if (!current_pt || pixels_type != current_pt) {
+			of_node_put(endpoint);
 			return -EINVAL;
+		}
 	}
 
 	return pixels_type;
-- 
2.30.2



