Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5317A68D779
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbjBGNAS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:00:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230503AbjBGM77 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 07:59:59 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9403D39B8F
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 04:59:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id ACD09CE1338
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 12:59:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7BF7C433D2;
        Tue,  7 Feb 2023 12:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675774787;
        bh=g+GuI9x79dBEF1Uh25nApxoWAhhhKgYNmbFXQS37x+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vFDBLzTWUQyMdjN3P4evyPmVpPilZhKLldK9WxoAzo/ge2LDljMBptdwSg+2s0+6e
         /+zi2/cMBxtFultCeVx47E4pbtbXB+zCZeKcDV+0lojzMVHUIaMAqZaw+fK0tNT2kR
         kI6FdsgO9un+Nc3LrwYeCHtwOxb6JyHcIv3yul/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 034/208] memcpy_real(): WRITE is "data source", not destination...
Date:   Tue,  7 Feb 2023 13:54:48 +0100
Message-Id: <20230207125635.861496576@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 77729412acde120712f5793e9134c2b1cbd1ee02 ]

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Stable-dep-of: 6dd88fd59da8 ("vhost-scsi: unbreak any layout for response")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/mm/maccess.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/mm/maccess.c b/arch/s390/mm/maccess.c
index 1571cdcb0c50..753b006c8ea5 100644
--- a/arch/s390/mm/maccess.c
+++ b/arch/s390/mm/maccess.c
@@ -128,7 +128,7 @@ int memcpy_real(void *dest, unsigned long src, size_t count)
 
 	kvec.iov_base = dest;
 	kvec.iov_len = count;
-	iov_iter_kvec(&iter, WRITE, &kvec, 1, count);
+	iov_iter_kvec(&iter, READ, &kvec, 1, count);
 	if (memcpy_real_iter(&iter, src, count) < count)
 		return -EFAULT;
 	return 0;
-- 
2.39.0



