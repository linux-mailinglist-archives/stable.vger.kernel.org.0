Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DBF21134A9
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728525AbfLDR6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 12:58:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:59832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728512AbfLDR6B (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 12:58:01 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 056C92073B;
        Wed,  4 Dec 2019 17:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482280;
        bh=5/TVwNIqOMPC0hJD8mcKohuZlGI+alU8s9sJLiAANV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eE2J74sW3dcdzfcLXDbU+eCTcSGMsoerk1vcrYY17TibZbGzZ3zl9ZC8o/hZSw0yX
         IqqWdcbGpWybmhI47rAjco6q3qw//QEmymk2+n4Ou2HVMQO0YlAQu8u+/vl9R6obKa
         d5DEjyf25yDIphBlJ9HO9U34LvWsqSffsHIKCTMc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 23/92] ubi: Put MTD device after it is not used
Date:   Wed,  4 Dec 2019 18:49:23 +0100
Message-Id: <20191204174331.454409380@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204174327.215426506@linuxfoundation.org>
References: <20191204174327.215426506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

[ Upstream commit b95f83ab762dd6211351b9140f99f43644076ca8 ]

The MTD device reference is dropped via put_mtd_device, however its
field ->index is read and passed to ubi_msg. To fix this, the patch
moves the reference dropping after calling ubi_msg.

Signed-off-by: Pan Bian <bianpan2016@163.com>
Reviewed-by: Boris Brezillon <boris.brezillon@bootlin.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/ubi/build.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index c9f5ae424af75..ae8e55b4f6f93 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -1141,10 +1141,10 @@ int ubi_detach_mtd_dev(int ubi_num, int anyway)
 	ubi_wl_close(ubi);
 	ubi_free_internal_volumes(ubi);
 	vfree(ubi->vtbl);
-	put_mtd_device(ubi->mtd);
 	vfree(ubi->peb_buf);
 	vfree(ubi->fm_buf);
 	ubi_msg(ubi, "mtd%d is detached", ubi->mtd->index);
+	put_mtd_device(ubi->mtd);
 	put_device(&ubi->dev);
 	return 0;
 }
-- 
2.20.1



