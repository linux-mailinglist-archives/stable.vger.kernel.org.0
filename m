Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62E4268D76C
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 13:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbjBGM7t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 07:59:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231960AbjBGM7g (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 07:59:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23E977EE4
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 04:59:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4B8961358
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 12:59:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4793C433EF;
        Tue,  7 Feb 2023 12:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675774775;
        bh=wxq/CNBZ7B32kcxG/XrT8d+CRFBZJ+X6J0Cn74psbAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N/FJF49SQG+rkqZri/rJNuLGDqKmObqVLFPnlNUwFf5N1nTS5nIeWMGsqyhCAxA/x
         nP++U23B1i8TNWL0UsTzaMyV1odbefFCs9QwbfCxeU18gwExKqem/HR+KlkaKzfZe0
         vdFJEutWu0P2iSGCmrOCGOEUDu+bY4XmiBVA7ouc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 030/208] copy_oldmem_kernel() - WRITE is "data source", not destination
Date:   Tue,  7 Feb 2023 13:54:44 +0100
Message-Id: <20230207125635.679036267@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 0e1e4a2238d465199e8f11eb7a779bcb224a0505 ]

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Stable-dep-of: 6dd88fd59da8 ("vhost-scsi: unbreak any layout for response")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/crash_dump.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kernel/crash_dump.c b/arch/s390/kernel/crash_dump.c
index e4ef67e4da0a..a19a2763e8d4 100644
--- a/arch/s390/kernel/crash_dump.c
+++ b/arch/s390/kernel/crash_dump.c
@@ -153,7 +153,7 @@ int copy_oldmem_kernel(void *dst, unsigned long src, size_t count)
 
 	kvec.iov_base = dst;
 	kvec.iov_len = count;
-	iov_iter_kvec(&iter, WRITE, &kvec, 1, count);
+	iov_iter_kvec(&iter, READ, &kvec, 1, count);
 	if (copy_oldmem_iter(&iter, src, count) < count)
 		return -EFAULT;
 	return 0;
-- 
2.39.0



