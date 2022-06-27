Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4349255D811
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237928AbiF0LvG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237923AbiF0LtT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:49:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B61DD70;
        Mon, 27 Jun 2022 04:43:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4390B80D32;
        Mon, 27 Jun 2022 11:43:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 069A1C3411D;
        Mon, 27 Jun 2022 11:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330189;
        bh=qKL3sDgDBwWBiQCi7BtfyP3+QUW3gUvmmkQeEh0eHoo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pgJwBWvE88p9eipfE08kdNmM+7kwFgyseSA9LJwJonNTBhjzVbHcIz9ooO9TprShA
         ZhG4g5X1RM91K9BDehtif6B3uJxmQ21BlTyxd9/FDE6GKKJmLKEgLK9ja1ZjnsUzyk
         niXGfZtHnRBICs+6zFw2jLVB7bfK4FVQs+4s29TY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Egorenkov <egorenar@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 114/181] s390/crash: make copy_oldmem_page() return number of bytes copied
Date:   Mon, 27 Jun 2022 13:21:27 +0200
Message-Id: <20220627111948.003910220@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Gordeev <agordeev@linux.ibm.com>

[ Upstream commit af2debd58bd769e38f538143f0d332e15d753396 ]

Callback copy_oldmem_page() returns either error code or zero.
Instead, it should return the error code or number of bytes copied.

Fixes: df9694c7975f ("s390/dump: streamline oldmem copy functions")
Reviewed-by: Alexander Egorenkov <egorenar@linux.ibm.com>
Tested-by: Alexander Egorenkov <egorenar@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/crash_dump.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/arch/s390/kernel/crash_dump.c
+++ b/arch/s390/kernel/crash_dump.c
@@ -233,9 +233,10 @@ ssize_t copy_oldmem_page(struct iov_iter
 		rc = copy_oldmem_user(iter->iov->iov_base, src, csize);
 	else
 		rc = copy_oldmem_kernel(iter->kvec->iov_base, src, csize);
-	if (!rc)
-		iov_iter_advance(iter, csize);
-	return rc;
+	if (rc < 0)
+		return rc;
+	iov_iter_advance(iter, csize);
+	return csize;
 }
 
 /*


