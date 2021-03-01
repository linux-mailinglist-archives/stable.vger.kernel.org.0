Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA19329130
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:23:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243006AbhCAUVM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:21:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:39932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238029AbhCAUNx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:13:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF22B653CE;
        Mon,  1 Mar 2021 18:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621723;
        bh=W1hm5GIBYobn9uPDOazvxq3tsbEPdmM9atw7OTl5GQk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nsyGJkhEVz9MqsLQLjnyHr6Itw4hAlErZYtLhjIgzBTHG2cN8Rsg+D5GoxdMDF9NN
         mQGYAuuSMTWepbk6G7EXWoqGF90S8ZI3TzakG9KyblZR5KU0wC3WIQOj7MyIGzwS3f
         hIkftktxJem5iVvI/v0VhgdrusuQwFvR+grwrxdk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, xinhui pan <xinhui.pan@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Subject: [PATCH 5.11 620/775] drm/ttm: Fix a memory leak
Date:   Mon,  1 Mar 2021 17:13:08 +0100
Message-Id: <20210301161232.033918458@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: xinhui pan <xinhui.pan@amd.com>

commit 7a8a4b0729a8807e37196e44629b31ee03f88872 upstream.

Free the memory on failure.
Also no need to re-alloc memory on retry.

Signed-off-by: xinhui pan <xinhui.pan@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210219042547.44855-1-xinhui.pan@amd.com
Reviewed-by: Christian König <christian.koenig@amd.com>
CC: stable@vger.kernel.org # 5.11
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/ttm/ttm_bo.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -967,8 +967,10 @@ static int ttm_bo_bounce_temp_buffer(str
 		return ret;
 	/* move to the bounce domain */
 	ret = ttm_bo_handle_move_mem(bo, &hop_mem, false, ctx, NULL);
-	if (ret)
+	if (ret) {
+		ttm_resource_free(bo, &hop_mem);
 		return ret;
+	}
 	return 0;
 }
 
@@ -1000,18 +1002,19 @@ static int ttm_bo_move_buffer(struct ttm
 	 * stop and the driver will be called to make
 	 * the second hop.
 	 */
-bounce:
 	ret = ttm_bo_mem_space(bo, placement, &mem, ctx);
 	if (ret)
 		return ret;
+bounce:
 	ret = ttm_bo_handle_move_mem(bo, &mem, false, ctx, &hop);
 	if (ret == -EMULTIHOP) {
 		ret = ttm_bo_bounce_temp_buffer(bo, &mem, ctx, &hop);
 		if (ret)
-			return ret;
+			goto out;
 		/* try and move to final place now. */
 		goto bounce;
 	}
+out:
 	if (ret)
 		ttm_resource_free(bo, &mem);
 	return ret;


