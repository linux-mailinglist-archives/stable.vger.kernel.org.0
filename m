Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D27B53E7E61
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232020AbhHJRc4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:32:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:33258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229774AbhHJRcm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:32:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DA9B60F94;
        Tue, 10 Aug 2021 17:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628616739;
        bh=d3zBzhSd99CWVBT9rN43GfypKWv50i8yK0avktkkfJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L51+VaNljCuGc/FpU6nDngNVVuZMMgSOQkhA5CZH0Jq+P0RxF6FJMyH4iju/GzntW
         j1v/H48IoUm/lThoHvEjl9rOmZef8hpFZwcF4i+sIH5KFYAw3G+ad7nwg+5eodTMad
         UcP9kagGk6BEfsAMUNOLg7nM6YJjMKrh7hTdcNIU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Anirudh Rayabharam <mail@anirudhrb.com>
Subject: [PATCH 4.19 25/54] firmware_loader: use -ETIMEDOUT instead of -EAGAIN in fw_load_sysfs_fallback
Date:   Tue, 10 Aug 2021 19:30:19 +0200
Message-Id: <20210810172945.006060660@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172944.179901509@linuxfoundation.org>
References: <20210810172944.179901509@linuxfoundation.org>
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
@@ -581,8 +581,6 @@ static int fw_load_sysfs_fallback(struct
 	if (fw_state_is_aborted(fw_priv)) {
 		if (retval == -ERESTARTSYS)
 			retval = -EINTR;
-		else
-			retval = -EAGAIN;
 	} else if (fw_priv->is_paged_buf && !fw_priv->data)
 		retval = -ENOMEM;
 


