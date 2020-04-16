Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10EBE1AC288
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896038AbgDPN3i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:29:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:39496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896029AbgDPN3g (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:29:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F822208E4;
        Thu, 16 Apr 2020 13:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587043776;
        bh=+IihUw+6SGwkdQnmsD8FiVqQUmXU2ZZTpB7TR3Hzxjw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UzUcVDDCMeY/HxBT76hGT6NLpR/1AcaMqCrJ5KQraAUCe7rNF7pXdk5LijFdmvzII
         +q+EWpqygeKD8FPmu81B7QQU16+wb/F1pOQ9FbmdpMhIVmm43gO+rPvl4bb7EMrRtJ
         XGuvRz/6OwNJOowrrI0TGig7eeupnUjGwL6BMU6k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Gao Xiang <gaoxiang25@huawei.com>
Subject: [PATCH 4.19 095/146] erofs: correct the remaining shrink objects
Date:   Thu, 16 Apr 2020 15:23:56 +0200
Message-Id: <20200416131255.773411526@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131242.353444678@linuxfoundation.org>
References: <20200416131242.353444678@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gao Xiang <gaoxiang25@huawei.com>

commit 9d5a09c6f3b5fb85af20e3a34827b5d27d152b34 upstream.

The remaining count should not include successful
shrink attempts.

Fixes: e7e9a307be9d ("staging: erofs: introduce workstation for decompression")
Cc: <stable@vger.kernel.org> # 4.19+
Link: https://lore.kernel.org/r/20200226081008.86348-1-gaoxiang25@huawei.com
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/staging/erofs/utils.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/erofs/utils.c
+++ b/drivers/staging/erofs/utils.c
@@ -309,7 +309,7 @@ unsigned long erofs_shrink_scan(struct s
 		sbi->shrinker_run_no = run_no;
 
 #ifdef CONFIG_EROFS_FS_ZIP
-		freed += erofs_shrink_workstation(sbi, nr, false);
+		freed += erofs_shrink_workstation(sbi, nr - freed, false);
 #endif
 
 		spin_lock(&erofs_sb_list_lock);


