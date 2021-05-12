Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5B5637CB80
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242759AbhELQfr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:35:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:43696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241410AbhELQ1I (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:27:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48EF761DD5;
        Wed, 12 May 2021 15:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834743;
        bh=VY8Aomw5wmF0rJecknmZ/mqcekwjy0L7Rzf1rujeWnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HMn2rCEBQOSz7GgCwYQk301AfckNX+WPexirYAYMO9jvIjPLd/pZI/o5Fy/ywk5Lg
         KsjprnY3YOaPMnntlpOydw4oKVtIVZAk81Ol4ypyT4Mm1wlaRfaoM0X6hEwcslMY2o
         4iKfPXctwnXxtKgJIzXfQyfPJyiSo1bGPwkQu7KA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.12 065/677] ipw2x00: potential buffer overflow in libipw_wx_set_encodeext()
Date:   Wed, 12 May 2021 16:41:51 +0200
Message-Id: <20210512144839.387140793@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 260a9ad9446723d4063ed802989758852809714d upstream.

The "ext->key_len" is a u16 that comes from the user.  If it's over
SCM_KEY_LEN (32) that could lead to memory corruption.

Fixes: e0d369d1d969 ("[PATCH] ieee82011: Added WE-18 support to default wireless extension handler")
Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Stanislav Yakovlev <stas.yakovlev@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/YHaoA1i+8uT4ir4h@mwanda
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/ipw2x00/libipw_wx.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/intel/ipw2x00/libipw_wx.c
+++ b/drivers/net/wireless/intel/ipw2x00/libipw_wx.c
@@ -633,8 +633,10 @@ int libipw_wx_set_encodeext(struct libip
 	}
 
 	if (ext->alg != IW_ENCODE_ALG_NONE) {
-		memcpy(sec.keys[idx], ext->key, ext->key_len);
-		sec.key_sizes[idx] = ext->key_len;
+		int key_len = clamp_val(ext->key_len, 0, SCM_KEY_LEN);
+
+		memcpy(sec.keys[idx], ext->key, key_len);
+		sec.key_sizes[idx] = key_len;
 		sec.flags |= (1 << idx);
 		if (ext->alg == IW_ENCODE_ALG_WEP) {
 			sec.encode_alg[idx] = SEC_ALG_WEP;


