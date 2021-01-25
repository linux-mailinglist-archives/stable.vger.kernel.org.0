Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E88953032E6
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 05:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbhAZEkZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:40:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:58352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726825AbhAYSmF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:42:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74064206B2;
        Mon, 25 Jan 2021 18:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600045;
        bh=7k2Jx5mwTCLd1j081OKwOqxCgp0APbM47qafwSfCgVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mrMJe5WZaNByOGpy2I7mcrY7MAT5c/JKuiwo/qdM299QGTSf24mRqHxoB2rGPoyzE
         A9TM4ps9paJmotxa6ALPDeM5dmd3IoC5Oeti2Yzo07g/kMWvp9mFdl4eHXjlk6nE63
         ndb45JXB/x+kKY+Cc0PTQbcq9Sxf4ixNwar/zL8w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 4.19 10/58] drm/atomic: put state on error path
Date:   Mon, 25 Jan 2021 19:39:11 +0100
Message-Id: <20210125183157.137181286@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183156.702907356@linuxfoundation.org>
References: <20210125183156.702907356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

commit 43b67309b6b2a3c08396cc9b3f83f21aa529d273 upstream.

Put the state before returning error code.

Fixes: 44596b8c4750 ("drm/atomic: Unify conflicting encoder handling.")
Signed-off-by: Pan Bian <bianpan2016@163.com>
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20210119121127.84127-1-bianpan2016@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_atomic_helper.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_atomic_helper.c
+++ b/drivers/gpu/drm/drm_atomic_helper.c
@@ -2938,7 +2938,7 @@ int drm_atomic_helper_set_config(struct
 
 	ret = handle_conflicting_encoders(state, true);
 	if (ret)
-		return ret;
+		goto fail;
 
 	ret = drm_atomic_commit(state);
 


