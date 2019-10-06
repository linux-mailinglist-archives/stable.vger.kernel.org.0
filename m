Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9AD7CD80A
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 20:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbfJFR4f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:56:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:33740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728970AbfJFRfG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:35:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45CBE2166E;
        Sun,  6 Oct 2019 17:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383305;
        bh=Z1FFPx6rPMa1a37d/+3Howuwq5SBIclNgoWtIm1mxP8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dJPHwnHpGqpAzm7ZCRWxLEchqP+ubOzPMDr1Sr29bS02WXApou4HxiROvQ6IEdgZq
         dls6FSaREm2n+XGWOkG9gk4TNxitfvET3asuyR+mopeZKMmUp++fiAzMmjQHdDzD1G
         IqXoNqPN5R2uc+AHU/6M2phcchk7JFbnT6qLB09g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 038/137] gpu: drm: radeon: Fix a possible null-pointer dereference in radeon_connector_set_property()
Date:   Sun,  6 Oct 2019 19:20:22 +0200
Message-Id: <20191006171212.237302580@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171209.403038733@linuxfoundation.org>
References: <20191006171209.403038733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit f3eb9b8f67bc28783eddc142ad805ebdc53d6339 ]

In radeon_connector_set_property(), there is an if statement on line 743
to check whether connector->encoder is NULL:
    if (connector->encoder)

When connector->encoder is NULL, it is used on line 755:
    if (connector->encoder->crtc)

Thus, a possible null-pointer dereference may occur.

To fix this bug, connector->encoder is checked before being used.

This bug is found by a static analysis tool STCheck written by us.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/radeon_connectors.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_connectors.c b/drivers/gpu/drm/radeon/radeon_connectors.c
index de1745adccccb..c7f2e073a82fd 100644
--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -752,7 +752,7 @@ static int radeon_connector_set_property(struct drm_connector *connector, struct
 
 		radeon_encoder->output_csc = val;
 
-		if (connector->encoder->crtc) {
+		if (connector->encoder && connector->encoder->crtc) {
 			struct drm_crtc *crtc  = connector->encoder->crtc;
 			struct radeon_crtc *radeon_crtc = to_radeon_crtc(crtc);
 
-- 
2.20.1



