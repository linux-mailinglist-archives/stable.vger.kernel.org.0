Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 153F43904E
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732263AbfFGPvB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:51:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:38284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732259AbfFGPvA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:51:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6DA252146E;
        Fri,  7 Jun 2019 15:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922659;
        bh=uCnlImr1sCXDHtdWF4PMIdW6NHznW4leojAu0sMNET4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lN1KI7cwD2QO/RNqtCF/s6UjKvS+C3Gkpmesc1fho92u9wVhOpGlJfmANiKStzAt0
         /wVfCyxrU4dLhGZG2Bs8wDCHHPnNzonAvCu0ZO7daYJVEt6P/3dDA2r3pT2LoCvVAm
         IOZRkWPXFWBPNl41S4WCvD3+MpZHEcmucM5JM/qA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Hellstrom <thellstrom@vmware.com>,
        Deepak Rawat <drawat@vmware.com>
Subject: [PATCH 5.1 72/85] drm/vmwgfx: Fix user space handle equal to zero
Date:   Fri,  7 Jun 2019 17:39:57 +0200
Message-Id: <20190607153857.107552334@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153849.101321647@linuxfoundation.org>
References: <20190607153849.101321647@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Hellstrom <thellstrom@vmware.com>

commit 8407f8a1d940fe28c4243ad4f0cb6a44dcee88f6 upstream.

User-space handles equal to zero are interpreted as uninitialized or
illegal by some drm systems (most notably kms). This means that a
dumb buffer or surface with a zero user-space handle can never be
used as a kms frame-buffer.

Cc: <stable@vger.kernel.org>
Fixes: c7eae62666ad ("drm/vmwgfx: Make the object handles idr-generated")
Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Reviewed-by: Deepak Rawat <drawat@vmware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/vmwgfx/ttm_object.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/vmwgfx/ttm_object.c
+++ b/drivers/gpu/drm/vmwgfx/ttm_object.c
@@ -174,7 +174,7 @@ int ttm_base_object_init(struct ttm_obje
 	kref_init(&base->refcount);
 	idr_preload(GFP_KERNEL);
 	spin_lock(&tdev->object_lock);
-	ret = idr_alloc(&tdev->idr, base, 0, 0, GFP_NOWAIT);
+	ret = idr_alloc(&tdev->idr, base, 1, 0, GFP_NOWAIT);
 	spin_unlock(&tdev->object_lock);
 	idr_preload_end();
 	if (ret < 0)


