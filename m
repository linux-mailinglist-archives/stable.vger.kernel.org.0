Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 440D3111D01
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:50:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729601AbfLCWt1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:49:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:40466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729598AbfLCWt0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:49:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D44C20803;
        Tue,  3 Dec 2019 22:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413365;
        bh=F66DdngBL+vukpTMT7DM9xZJGVecvMvU+cdbojN7Lrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QU8wSzI/7cOk694p7ep0B8KjtoMmB4hub41ud0Z82+r6aTB89fL/CQOuK4WJOFQX9
         rCHtAP/wDYsUVsBdG6xraRqbkxLjtJ9IkAOhp1z2zeqppFWImmzkWdBqXeB3ATOC9M
         L21AIltBlQJBc1GpvApNZffvWXVsdkZCruD0PAIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 101/321] ubi: Do not drop UBI device reference before using
Date:   Tue,  3 Dec 2019 23:32:47 +0100
Message-Id: <20191203223432.409992040@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

[ Upstream commit e542087701f09418702673631a908429feb3eae0 ]

The UBI device reference is dropped but then the device is used as a
parameter of ubi_err. The bug is introduced in changing ubi_err's
behavior. The old ubi_err does not require a UBI device as its first
parameter, but the new one does.

Fixes: 32608703310 ("UBI: Extend UBI layer debug/messaging capabilities")
Signed-off-by: Pan Bian <bianpan2016@163.com>
Reviewed-by: Boris Brezillon <boris.brezillon@bootlin.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/ubi/kapi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/ubi/kapi.c b/drivers/mtd/ubi/kapi.c
index e9e9ecbcedcc3..0b8f0c46268da 100644
--- a/drivers/mtd/ubi/kapi.c
+++ b/drivers/mtd/ubi/kapi.c
@@ -227,9 +227,9 @@ out_unlock:
 out_free:
 	kfree(desc);
 out_put_ubi:
-	ubi_put_device(ubi);
 	ubi_err(ubi, "cannot open device %d, volume %d, error %d",
 		ubi_num, vol_id, err);
+	ubi_put_device(ubi);
 	return ERR_PTR(err);
 }
 EXPORT_SYMBOL_GPL(ubi_open_volume);
-- 
2.20.1



