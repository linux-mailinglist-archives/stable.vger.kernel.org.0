Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEF29328FBA
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:01:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242222AbhCAT4z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:56:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:55190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239402AbhCATob (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:44:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C144F64D8F;
        Mon,  1 Mar 2021 17:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620836;
        bh=9LmnSJgiIbo5m6GyjhYCc5cowMtDDxea9vISoySCzrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qjz1Lsi7+FJbXKI7stYEJ867rfJOLc5SV6+swm/jTq+rfZN0jliY3W2O34w4TWva3
         LEaYx6Ntfqza8rXWsouWikour3V6tE1sXL1041eaOrEdm8FKk7mWiMoLZS8XFjqPRR
         dpjzUtm0QqeZkzu8fpX5Psw1uE0f+odDfXjgtDcI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Zhihao Cheng <chengzhihao1@huawei.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 296/775] ubifs: Fix memleak in ubifs_init_authentication
Date:   Mon,  1 Mar 2021 17:07:44 +0100
Message-Id: <20210301161216.251117154@linuxfoundation.org>
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

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 11b8ab3836454a2600e396f34731e491b661f9d5 ]

When crypto_shash_digestsize() fails, c->hmac_tfm
has not been freed before returning, which leads
to memleak.

Fixes: 49525e5eecca5 ("ubifs: Add helper functions for authentication support")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ubifs/auth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ubifs/auth.c b/fs/ubifs/auth.c
index 51a7c8c2c3f0a..e564d5ff87816 100644
--- a/fs/ubifs/auth.c
+++ b/fs/ubifs/auth.c
@@ -327,7 +327,7 @@ int ubifs_init_authentication(struct ubifs_info *c)
 		ubifs_err(c, "hmac %s is bigger than maximum allowed hmac size (%d > %d)",
 			  hmac_name, c->hmac_desc_len, UBIFS_HMAC_ARR_SZ);
 		err = -EINVAL;
-		goto out_free_hash;
+		goto out_free_hmac;
 	}
 
 	err = crypto_shash_setkey(c->hmac_tfm, ukp->data, ukp->datalen);
-- 
2.27.0



