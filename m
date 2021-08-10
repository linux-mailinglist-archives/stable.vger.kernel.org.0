Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2C73E7F01
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233059AbhHJRgj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:36:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:39322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232803AbhHJRfT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:35:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6C6C60F94;
        Tue, 10 Aug 2021 17:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628616897;
        bh=jVggrLsUZFS7UY5poXCnjYHAW+0AunxQpHwxXsK0rnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0FaElzizykUuq/hF048aI4PbYpMIwBb+6CCSukl+QcFoQRhKkf9Cb3d/zhtGAerPj
         ho1DAz1Yf3ZjjLFzJN6iujRCnGV47qNaiAcy+Ikj3M9biI76z8wrO/cWEI4o/V8ptz
         nGVWsJCH9qChtbmYhx23zRgN6l2opIsfT8f8PX0c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Anirudh Rayabharam <mail@anirudhrb.com>
Subject: [PATCH 5.4 40/85] firmware_loader: use -ETIMEDOUT instead of -EAGAIN in fw_load_sysfs_fallback
Date:   Tue, 10 Aug 2021 19:30:13 +0200
Message-Id: <20210810172949.573291047@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172948.192298392@linuxfoundation.org>
References: <20210810172948.192298392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anirudh Rayabharam <mail@anirudhrb.com>

commit 0d6434e10b5377a006f6dd995c8fc5e2d82acddc upstream.

The only motivation for using -EAGAIN in commit 0542ad88fbdd81bb
("firmware loader: Fix _request_firmware_load() return val for fw load
abort") was to distinguish the error from -ENOMEM, and so there is no
real reason in keeping it. -EAGAIN is typically used to tell the
userspace to try something again and in this case re-using the sysfs
loading interface cannot be retried when a timeout happens, so the
return value is also bogus.

-ETIMEDOUT is received when the wait times out and returning that
is much more telling of what the reason for the failure was. So, just
propagate that instead of returning -EAGAIN.

Suggested-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Acked-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Anirudh Rayabharam <mail@anirudhrb.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210728085107.4141-2-mail@anirudhrb.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/firmware_loader/fallback.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/base/firmware_loader/fallback.c
+++ b/drivers/base/firmware_loader/fallback.c
@@ -534,8 +534,6 @@ static int fw_load_sysfs_fallback(struct
 	if (fw_state_is_aborted(fw_priv)) {
 		if (retval == -ERESTARTSYS)
 			retval = -EINTR;
-		else
-			retval = -EAGAIN;
 	} else if (fw_priv->is_paged_buf && !fw_priv->data)
 		retval = -ENOMEM;
 


