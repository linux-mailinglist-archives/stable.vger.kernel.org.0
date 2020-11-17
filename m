Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4490F2B61C6
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730030AbgKQNWY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:22:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:56508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731137AbgKQNWV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:22:21 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 721BF2463D;
        Tue, 17 Nov 2020 13:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619341;
        bh=ft3m36Fa78UiYrqDTyTqUtvIkzAJHmBOA0ea50o185U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cn+w9RITXWPG+iHfsnhlUNk1gFZBozl/YY2dMp6KxqCeg01GcfrGjY3kFWoG+3sEY
         ZsBqVkZcO+O/rZ8jaddYlrTB/jprctC4uFXXuUvR5Zj4tGxYtzFc/CYgis6a1gdaIE
         5HBO19m2XoWESaMjMzGKRRaFQALaiHwJEtja8KbI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.19 080/101] mmc: renesas_sdhi_core: Add missing tmio_mmc_host_free() at remove
Date:   Tue, 17 Nov 2020 14:05:47 +0100
Message-Id: <20201117122117.020259288@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122113.128215851@linuxfoundation.org>
References: <20201117122113.128215851@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

commit e8973201d9b281375b5a8c66093de5679423021a upstream.

The commit 94b110aff867 ("mmc: tmio: add tmio_mmc_host_alloc/free()")
added tmio_mmc_host_free(), but missed the function calling in
the sh_mobile_sdhi_remove() at that time. So, fix it. Otherwise,
we cannot rebind the sdhi/mmc devices when we use aliases of mmc.

Fixes: 94b110aff867 ("mmc: tmio: add tmio_mmc_host_alloc/free()")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Tested-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/1604654730-29914-1-git-send-email-yoshihiro.shimoda.uh@renesas.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/renesas_sdhi_core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mmc/host/renesas_sdhi_core.c
+++ b/drivers/mmc/host/renesas_sdhi_core.c
@@ -764,6 +764,7 @@ int renesas_sdhi_remove(struct platform_
 
 	tmio_mmc_host_remove(host);
 	renesas_sdhi_clk_disable(host);
+	tmio_mmc_host_free(host);
 
 	return 0;
 }


