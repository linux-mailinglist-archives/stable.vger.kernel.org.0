Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0DE444C839
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 19:57:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234185AbhKJTAN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 14:00:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:54184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234236AbhKJS6Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 13:58:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB17961A0C;
        Wed, 10 Nov 2021 18:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636570243;
        bh=6n0oc5pwIGuAVUEka1Fyf62fWzHqzI+MTpgJGlCkRXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E7n81fb3wYux5bR3feXYXWTYjknCLj9JDO67aK5sM6tD6hh7ddF8d+y8faAWbzLzz
         AOlao844WKIQatl/wo+xhz6O6W3GbR1HS2M6XQsYdbuOpZ8x0a+/2G58DUjDM9waVJ
         FthffB9xdezmKmMKfatetuLnctcThqr9JXfaQNwE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Kaiser <martin@kaiser.cx>
Subject: [PATCH 5.15 24/26] staging: r8188eu: fix memleak in rtw_wx_set_enc_ext
Date:   Wed, 10 Nov 2021 19:44:23 +0100
Message-Id: <20211110182004.454072244@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211110182003.700594531@linuxfoundation.org>
References: <20211110182003.700594531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Kaiser <martin@kaiser.cx>

commit 26f448371820cf733c827c11f0c77ce304a29b51 upstream.

Free the param struct if the caller sets an unsupported algorithm
and we return an error.

Fixes: 2b42bd58b321 ("staging: r8188eu: introduce new os_dep dir for RTL8188eu driver")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Martin Kaiser <martin@kaiser.cx>
Link: https://lore.kernel.org/r/20211019202356.12572-1-martin@kaiser.cx
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/r8188eu/os_dep/ioctl_linux.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/staging/r8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/r8188eu/os_dep/ioctl_linux.c
@@ -1978,7 +1978,7 @@ static int rtw_wx_set_enc_ext(struct net
 	struct ieee_param *param = NULL;
 	struct iw_point *pencoding = &wrqu->encoding;
 	struct iw_encode_ext *pext = (struct iw_encode_ext *)extra;
-	int ret = 0;
+	int ret = -1;
 
 	param_len = sizeof(struct ieee_param) + pext->key_len;
 	param = kzalloc(param_len, GFP_KERNEL);
@@ -2004,7 +2004,7 @@ static int rtw_wx_set_enc_ext(struct net
 		alg_name = "CCMP";
 		break;
 	default:
-		return -1;
+		goto out;
 	}
 
 	strncpy((char *)param->u.crypt.alg, alg_name, IEEE_CRYPT_ALG_NAME_LEN);
@@ -2031,6 +2031,7 @@ static int rtw_wx_set_enc_ext(struct net
 
 	ret =  wpa_set_encryption(dev, param, param_len);
 
+out:
 	kfree(param);
 	return ret;
 }


