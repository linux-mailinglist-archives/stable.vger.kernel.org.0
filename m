Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86CB743516D
	for <lists+stable@lfdr.de>; Wed, 20 Oct 2021 19:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbhJTRjV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 13:39:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:41236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230376AbhJTRjU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Oct 2021 13:39:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9EA7F61038;
        Wed, 20 Oct 2021 17:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634751426;
        bh=VtkBUuhfoZWzmlMlFmXpj5htMx3psZJFJWJah7pZX60=;
        h=Subject:To:From:Date:From;
        b=0YIN4LLy5EbmwBur8Va54FaVItce5vpt1+s/Kml5xeWaFjbp/A5lDwW+qVpD/T7d8
         ZJSt4v+OeVJjLzVl7zF39Thm3xgWueVtgIyxxLeGxu+LWNvlhwtUkVApb4bB/Fvbpr
         5lDidg+IB66jYj7J+XZVLDm0yKARwoDp+zGhWjm0=
Subject: patch "staging: r8188eu: fix memleak in rtw_wx_set_enc_ext" added to staging-testing
To:     martin@kaiser.cx, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 20 Oct 2021 19:36:50 +0200
Message-ID: <1634751410238234@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: r8188eu: fix memleak in rtw_wx_set_enc_ext

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the staging-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 26f448371820cf733c827c11f0c77ce304a29b51 Mon Sep 17 00:00:00 2001
From: Martin Kaiser <martin@kaiser.cx>
Date: Tue, 19 Oct 2021 22:23:56 +0200
Subject: staging: r8188eu: fix memleak in rtw_wx_set_enc_ext

Free the param struct if the caller sets an unsupported algorithm
and we return an error.

Fixes: 2b42bd58b321 ("staging: r8188eu: introduce new os_dep dir for RTL8188eu driver")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Martin Kaiser <martin@kaiser.cx>
Link: https://lore.kernel.org/r/20211019202356.12572-1-martin@kaiser.cx
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/r8188eu/os_dep/ioctl_linux.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/r8188eu/os_dep/ioctl_linux.c b/drivers/staging/r8188eu/os_dep/ioctl_linux.c
index 4f0ae821d193..4e51d5a55985 100644
--- a/drivers/staging/r8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/r8188eu/os_dep/ioctl_linux.c
@@ -1897,7 +1897,7 @@ static int rtw_wx_set_enc_ext(struct net_device *dev,
 	struct ieee_param *param = NULL;
 	struct iw_point *pencoding = &wrqu->encoding;
 	struct iw_encode_ext *pext = (struct iw_encode_ext *)extra;
-	int ret = 0;
+	int ret = -1;
 
 	param_len = sizeof(struct ieee_param) + pext->key_len;
 	param = kzalloc(param_len, GFP_KERNEL);
@@ -1923,7 +1923,7 @@ static int rtw_wx_set_enc_ext(struct net_device *dev,
 		alg_name = "CCMP";
 		break;
 	default:
-		return -1;
+		goto out;
 	}
 
 	strlcpy((char *)param->u.crypt.alg, alg_name, IEEE_CRYPT_ALG_NAME_LEN);
@@ -1950,6 +1950,7 @@ static int rtw_wx_set_enc_ext(struct net_device *dev,
 
 	ret =  wpa_set_encryption(dev, param, param_len);
 
+out:
 	kfree(param);
 	return ret;
 }
-- 
2.33.1


