Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22E7628B934
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 16:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731501AbgJLN6Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:58:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:44328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731476AbgJLNk5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:40:57 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFDAE22261;
        Mon, 12 Oct 2020 13:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510046;
        bh=xfPx18DR1Yo1IeyBOmicVze493qZfk5VFd3DR5Muv9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nBP6u5mUG+dFqmUXi6bRwuHEF0+EJNWNlQI0HJjmBfgjU1Xzgg+IoJPaiy8IOrWs2
         PWmTEhZS3+zyeQB8GnFnh8Jw6dXNOFHFIkQzO1hFR9pYeoiYKtFLb868NupxJI3VEN
         ZXEALU0k+of/jBOHsYXZ/C0Ut23Yv3bafEtPg1zg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Karol Herbst <kherbst@redhat.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Dave Airlie <airlied@redhat.com>
Subject: [PATCH 5.4 10/85] drm/nouveau/mem: guard against NULL pointer access in mem_del
Date:   Mon, 12 Oct 2020 15:26:33 +0200
Message-Id: <20201012132633.354399123@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132632.846779148@linuxfoundation.org>
References: <20201012132632.846779148@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Karol Herbst <kherbst@redhat.com>

commit d10285a25e29f13353bbf7760be8980048c1ef2f upstream.

other drivers seems to do something similar

Signed-off-by: Karol Herbst <kherbst@redhat.com>
Cc: dri-devel <dri-devel@lists.freedesktop.org>
Cc: Dave Airlie <airlied@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Dave Airlie <airlied@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201006220528.13925-2-kherbst@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/nouveau_mem.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/nouveau/nouveau_mem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_mem.c
@@ -176,6 +176,8 @@ void
 nouveau_mem_del(struct ttm_mem_reg *reg)
 {
 	struct nouveau_mem *mem = nouveau_mem(reg);
+	if (!mem)
+		return;
 	nouveau_mem_fini(mem);
 	kfree(reg->mm_node);
 	reg->mm_node = NULL;


