Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0AEB3A6132
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232890AbhFNKpb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:45:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:45358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233863AbhFNKmD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:42:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B497661440;
        Mon, 14 Jun 2021 10:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623666924;
        bh=uO4dyww9HqWEH+ir6OUdMrbH/D28e7nPwHWB7LH7R/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RK3bkRfFsgr9BqkXCEp4rXdNj16Sz6x+Ju9TE1Vlur+/Kr2jBxoHs+92xhNpesCuW
         J/H6CD+0aZR48bsSlRZ70tRL7dLzTH0/AOUhTJdB5f6531MpRVK3XHoZm6gamyumqO
         lE0oToMC0CulKDkCY4dhlSifmRxLBLW/YFLiMg2o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 4.19 30/67] drm: Lock pointer access in drm_master_release()
Date:   Mon, 14 Jun 2021 12:27:13 +0200
Message-Id: <20210614102644.785964590@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102643.797691914@linuxfoundation.org>
References: <20210614102643.797691914@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>

commit c336a5ee984708db4826ef9e47d184e638e29717 upstream.

This patch eliminates the following smatch warning:
drivers/gpu/drm/drm_auth.c:320 drm_master_release() warn: unlocked access 'master' (line 318) expected lock '&dev->master_mutex'

The 'file_priv->master' field should be protected by the mutex lock to
'&dev->master_mutex'. This is because other processes can concurrently
modify this field and free the current 'file_priv->master'
pointer. This could result in a use-after-free error when 'master' is
dereferenced in subsequent function calls to
'drm_legacy_lock_master_cleanup()' or to 'drm_lease_revoke()'.

An example of a scenario that would produce this error can be seen
from a similar bug in 'drm_getunique()' that was reported by Syzbot:
https://syzkaller.appspot.com/bug?id=148d2f1dfac64af52ffd27b661981a540724f803

In the Syzbot report, another process concurrently acquired the
device's master mutex in 'drm_setmaster_ioctl()', then overwrote
'fpriv->master' in 'drm_new_set_master()'. The old value of
'fpriv->master' was subsequently freed before the mutex was unlocked.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20210609092119.173590-1-desmondcheongzx@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_auth.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_auth.c
+++ b/drivers/gpu/drm/drm_auth.c
@@ -265,9 +265,10 @@ int drm_master_open(struct drm_file *fil
 void drm_master_release(struct drm_file *file_priv)
 {
 	struct drm_device *dev = file_priv->minor->dev;
-	struct drm_master *master = file_priv->master;
+	struct drm_master *master;
 
 	mutex_lock(&dev->master_mutex);
+	master = file_priv->master;
 	if (file_priv->magic)
 		idr_remove(&file_priv->master->magic_map, file_priv->magic);
 


