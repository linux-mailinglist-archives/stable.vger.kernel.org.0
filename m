Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88A4224B605
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731327AbgHTKUH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:20:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:44498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728740AbgHTKUE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:20:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49435206DA;
        Thu, 20 Aug 2020 10:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918798;
        bh=KEAipvMjfEorrai6eNDNy7y7VZLzrF8oFi2wdwB+n6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RTUwy/gRBlqe9JtWTyVPOxCihFDNO8TIKzRZSRAJHfXHxdI25+L1/y0aDP3fS0Evm
         ghIRx8jdqQqr79+wycXYxH0MDAZ3I081LEYJPItpgJ5YXXUrSdYtR2qb2v5xR1Uza7
         I4R2HbmF+ZWpnWD6YPTkrw7JZIXMQUQGFNLPnTN8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 041/149] drm/nouveau/fbcon: fix module unload when fbcon init has failed for some reason
Date:   Thu, 20 Aug 2020 11:21:58 +0200
Message-Id: <20200820092127.725934128@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820092125.688850368@linuxfoundation.org>
References: <20200820092125.688850368@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Skeggs <bskeggs@redhat.com>

[ Upstream commit 498595abf5bd51f0ae074cec565d888778ea558f ]

Stale pointer was tripping up the unload path.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_fbcon.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/nouveau/nouveau_fbcon.c b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
index 343476d157266..edb3a23ded5d5 100644
--- a/drivers/gpu/drm/nouveau/nouveau_fbcon.c
+++ b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
@@ -566,6 +566,7 @@ fini:
 	drm_fb_helper_fini(&fbcon->helper);
 free:
 	kfree(fbcon);
+	drm->fbcon = NULL;
 	return ret;
 }
 
-- 
2.25.1



