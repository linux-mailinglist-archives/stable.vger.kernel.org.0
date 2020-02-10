Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 689721577B1
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:02:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729781AbgBJNCG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:02:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:41190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729776AbgBJMkk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:40:40 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 707F92465D;
        Mon, 10 Feb 2020 12:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338439;
        bh=rbtdMv/dEgoSmR58uOsxLUUC2zt8Sny6B/FmGqk8guQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=juPDiYS2UVGHXwZp71wlclG8eJ7A5F1jRz+IIF0WAncnQCtmw8WzQyJyJe94PKoYT
         G2RTTBMjfFlcH5gXQV4H5SiHhnrR7ETE5QARussDahUYHmiWV3F4oc4je+WqWoRYp4
         DCnA8Axjre66z9Us/3Gc1uHZ9I+zHmnQKNzDyhxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.5 176/367] crypto: sun8i-ce - fix removal of module
Date:   Mon, 10 Feb 2020 04:31:29 -0800
Message-Id: <20200210122441.058973501@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Corentin Labbe <clabbe.montjoie@gmail.com>

commit 93d24ac4b26770f8e5118a731cd9314f3808bd10 upstream.

Removing the driver cause an oops due to the fact we clean an extra
channel.
Let's give the right index to the cleaning function.

Fixes: 06f751b61329 ("crypto: allwinner - Add sun8i-ce Crypto Engine")
Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
@@ -624,7 +624,7 @@ error_alg:
 error_irq:
 	sun8i_ce_pm_exit(ce);
 error_pm:
-	sun8i_ce_free_chanlist(ce, MAXFLOW);
+	sun8i_ce_free_chanlist(ce, MAXFLOW - 1);
 	return err;
 }
 
@@ -638,7 +638,7 @@ static int sun8i_ce_remove(struct platfo
 	debugfs_remove_recursive(ce->dbgfs_dir);
 #endif
 
-	sun8i_ce_free_chanlist(ce, MAXFLOW);
+	sun8i_ce_free_chanlist(ce, MAXFLOW - 1);
 
 	sun8i_ce_pm_exit(ce);
 	return 0;


