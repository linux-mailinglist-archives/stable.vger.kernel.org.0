Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73D6832885E
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238837AbhCARjC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:39:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:54066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238258AbhCARb5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:31:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9431E650A0;
        Mon,  1 Mar 2021 16:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617580;
        bh=Wy6CkdriB05okBRjB06qcob3lYCnG9TsZJ76asP7uMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RvFTdLX7hx1zamYkWQJ807wlnSWu/Lrmz/0NvUtkEQK8/vTatE4iTb+0mHRHEI3+m
         RrgRMBfrDVa7/nq6J1mC2m9ojTQbfkUaBbEA9kub7IIIfhVghQShFOtlctsiV2F1Ws
         HixCWl+7fm/7F/VRaGv+RZ8JgUapy27iOA6DCogE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Zhihao Cheng <chengzhihao1@huawei.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 123/340] ubifs: Fix memleak in ubifs_init_authentication
Date:   Mon,  1 Mar 2021 17:11:07 +0100
Message-Id: <20210301161054.376237900@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
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
index b10418b5fb719..8be17a7731961 100644
--- a/fs/ubifs/auth.c
+++ b/fs/ubifs/auth.c
@@ -342,7 +342,7 @@ int ubifs_init_authentication(struct ubifs_info *c)
 		ubifs_err(c, "hmac %s is bigger than maximum allowed hmac size (%d > %d)",
 			  hmac_name, c->hmac_desc_len, UBIFS_HMAC_ARR_SZ);
 		err = -EINVAL;
-		goto out_free_hash;
+		goto out_free_hmac;
 	}
 
 	err = crypto_shash_setkey(c->hmac_tfm, ukp->data, ukp->datalen);
-- 
2.27.0



