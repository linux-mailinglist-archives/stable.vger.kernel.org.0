Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7D2498D9D
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346831AbiAXTd5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:33:57 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57134 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242058AbiAXTbv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:31:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9840614F0;
        Mon, 24 Jan 2022 19:31:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95700C340E5;
        Mon, 24 Jan 2022 19:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052710;
        bh=rD5AOzkXpRUJUGlmyD4mjgmBS/IZeXJBNqa5eZZZftQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SiFyuThU5MbVToAAB0c6JJLKtr4Aycv/P6T1gx1xFongMIedCGxgFByAcF1Kf5CCa
         Peg7cPzshqGZTI4+Paj9nl+BpCgIcobKF3OeDN5c+PML9/YjQWrB3V4U3Wb7h80ap+
         95B/W2vgVbYg0s+TNP+v2Dola/9v4nmUOUDPHIEM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Todd Kjos <tkjos@google.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 132/320] binder: fix handling of error during copy
Date:   Mon, 24 Jan 2022 19:41:56 +0100
Message-Id: <20220124183958.155863213@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Todd Kjos <tkjos@google.com>

[ Upstream commit fe6b1869243f23a485a106c214bcfdc7aa0ed593 ]

If a memory copy function fails to copy the whole buffer,
a positive integar with the remaining bytes is returned.
In binder_translate_fd_array() this can result in an fd being
skipped due to the failed copy, but the loop continues
processing fds since the early return condition expects a
negative integer on error.

Fix by returning "ret > 0 ? -EINVAL : ret" to handle this case.

Fixes: bb4a2e48d510 ("binder: return errors from buffer copy functions")
Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Todd Kjos <tkjos@google.com>
Link: https://lore.kernel.org/r/20211130185152.437403-2-tkjos@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/android/binder.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index 0512af0f04646..b9fb2a9269443 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2660,8 +2660,8 @@ static int binder_translate_fd_array(struct binder_fd_array_object *fda,
 		if (!ret)
 			ret = binder_translate_fd(fd, offset, t, thread,
 						  in_reply_to);
-		if (ret < 0)
-			return ret;
+		if (ret)
+			return ret > 0 ? -EINVAL : ret;
 	}
 	return 0;
 }
-- 
2.34.1



