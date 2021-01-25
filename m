Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2ACE303326
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 05:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727718AbhAZErg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:47:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:58354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729091AbhAYSn6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:43:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26036221E7;
        Mon, 25 Jan 2021 18:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600211;
        bh=8qjc12+8t4VmYze5MIc4+8pyhNwjypWHYI9nnXL0MW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XUJ01FVpBiiKzHEvNYqeAWdi0NpV+5q2pPX3BwCG4oGLoco8EO1m+twASrzQCgqxW
         66T/3/ZWbQe3rec/hQQKzuh94ez3gUdO3OV2CFPKmofsV3XCchDYhBffe6xMh4/uAo
         9z7jU0D/g1aAAjzBEhax02qmoWYLROje6u95LrDY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 5.4 15/86] drm/atomic: put state on error path
Date:   Mon, 25 Jan 2021 19:38:57 +0100
Message-Id: <20210125183201.685178526@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183201.024962206@linuxfoundation.org>
References: <20210125183201.024962206@linuxfoundation.org>
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
@@ -2948,7 +2948,7 @@ int drm_atomic_helper_set_config(struct
 
 	ret = handle_conflicting_encoders(state, true);
 	if (ret)
-		return ret;
+		goto fail;
 
 	ret = drm_atomic_commit(state);
 


