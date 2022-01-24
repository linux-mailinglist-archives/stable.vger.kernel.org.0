Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED4DB49A2F0
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2366033AbiAXXwM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:52:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383095AbiAXXFt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:05:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13B47C029806;
        Mon, 24 Jan 2022 13:16:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7B27614A2;
        Mon, 24 Jan 2022 21:16:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CD62C340E4;
        Mon, 24 Jan 2022 21:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059003;
        bh=b/4IslJBEQd84GWcAJuYmPtCMrf3yVEFUlsk8XYbfeA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uphsUpec/0KhYBHVUtps8afSOuABs0ddABO6DxCIkaa4dZNHHk8P9fHoUrE8KT00+
         4SFEm9CmdRibr7el0cKkLfYruF4yMECMhXYvLULR5xAd2e8IuqArgObN2bhgZffM0F
         PaV4lcsyrbYe0e8zEWleAodEEhqfJ1k/KYML7m+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Todd Kjos <tkjos@google.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0471/1039] binder: fix handling of error during copy
Date:   Mon, 24 Jan 2022 19:37:40 +0100
Message-Id: <20220124184141.109754699@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
index c75fb600740cc..7d29d3d931a79 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2269,8 +2269,8 @@ static int binder_translate_fd_array(struct binder_fd_array_object *fda,
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



