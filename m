Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43DC53E80A6
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235880AbhHJRvL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:51:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:58770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236918AbhHJRtw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:49:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0465861184;
        Tue, 10 Aug 2021 17:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617319;
        bh=p+gzQ+WKbIpItmotzJJu2xF1GeLryVr5wMxaDXE+aKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r/jTwvO0ZjeAXR/Klz3ZEz3+lbV/MUUzR1juIyXu0vTnVgTWyARM9hVMwiFG07Gye
         uUu+cWNbS51m0Z+3BUUjc3zbunOUJbtrnxeRfn2ikTZdelhSJlNpsrgVFbSr+M5RGD
         FhU4H297EqKsfKv9WWRm3FDJarMlRFHJihB5AJaI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Georgi Djakov <djakov@kernel.org>
Subject: [PATCH 5.10 115/135] interconnect: Fix undersized devress_alloc allocation
Date:   Tue, 10 Aug 2021 19:30:49 +0200
Message-Id: <20210810172959.703172302@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

commit 85b1ebfea2b0d8797266bcc6f04b6cc87e38290a upstream.

The expression sizeof(**ptr) for the void **ptr is just 1 rather than
the size of a pointer. Fix this by using sizeof(*ptr).

Addresses-Coverity: ("Wrong sizeof argument")
Fixes: e145d9a184f2 ("interconnect: Add devm_of_icc_get() as exported API for users")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Link: https://lore.kernel.org/r/20210730075408.19945-1-colin.king@canonical.com
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/interconnect/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/interconnect/core.c
+++ b/drivers/interconnect/core.c
@@ -403,7 +403,7 @@ struct icc_path *devm_of_icc_get(struct
 {
 	struct icc_path **ptr, *path;
 
-	ptr = devres_alloc(devm_icc_release, sizeof(**ptr), GFP_KERNEL);
+	ptr = devres_alloc(devm_icc_release, sizeof(*ptr), GFP_KERNEL);
 	if (!ptr)
 		return ERR_PTR(-ENOMEM);
 


