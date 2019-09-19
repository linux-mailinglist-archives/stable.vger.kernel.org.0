Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4D5CB8428
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393384AbfISWIV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:08:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:46252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393402AbfISWIV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:08:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C258821928;
        Thu, 19 Sep 2019 22:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568930900;
        bh=BJV4xn+dCqPEYrNnYRxOCtNh4EYW7nfGMGy0JjAm954=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FpicqyFAD+P8riHC88Y8TizX8prVdJoBWcL/qoTtMgunuKSc6h9YEoGc2Ne7OsImf
         +YZ1Dv7/TuHP9McA05U7JTLR6iRDl0VaApRMWnbJoErf/CcI+rdAnNJFnt0XybkcI4
         iV1SN/QJL8LG3ArQSb2LcUkgxjks5+RrZMl+6lBE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 055/124] xdp: unpin xdp umem pages in error path
Date:   Fri, 20 Sep 2019 00:02:23 +0200
Message-Id: <20190919214821.003628809@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214819.198419517@linuxfoundation.org>
References: <20190919214819.198419517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>

[ Upstream commit fb89c39455e4b49881c5a42761bd71f03d3ef888 ]

Fix mem leak caused by missed unpin routine for umem pages.

Fixes: 8aef7340ae9695 ("xsk: introduce xdp_umem_page")
Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xdp/xdp_umem.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index 9c6de4f114f84..9bd7b96027c12 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -368,7 +368,7 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 	umem->pages = kcalloc(umem->npgs, sizeof(*umem->pages), GFP_KERNEL);
 	if (!umem->pages) {
 		err = -ENOMEM;
-		goto out_account;
+		goto out_pin;
 	}
 
 	for (i = 0; i < umem->npgs; i++)
@@ -376,6 +376,8 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 
 	return 0;
 
+out_pin:
+	xdp_umem_unpin_pages(umem);
 out_account:
 	xdp_umem_unaccount_pages(umem);
 	return err;
-- 
2.20.1



