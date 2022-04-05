Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 357694F2E42
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356227AbiDEKXa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:23:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235497AbiDEJap (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:30:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B12A1E7F61;
        Tue,  5 Apr 2022 02:17:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65D25B818F3;
        Tue,  5 Apr 2022 09:17:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C99F0C385A0;
        Tue,  5 Apr 2022 09:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150268;
        bh=vK/yrbUh/EhxBu261dRYQfC4zTET2FQj/zRa7+VU4/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WfwqLLvWRrCPUW6IHd1/uXjD/Zw64AEsNMTj4AhHlwwnBZgMjVkBphebj9ORQV779
         bzOj8w92iNowf2m1LdROI7Cbf7zPdcpX9GytYlzbd145YxXHiU+3ajBjC/5z7BsZOl
         IAmX60X2BkV0T/hco9sTBvlhoZve2Kl/I4vcC4Vg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Kees Cook <keescook@chromium.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 5.16 1015/1017] coredump: Remove the WARN_ON in dump_vma_snapshot
Date:   Tue,  5 Apr 2022 09:32:08 +0200
Message-Id: <20220405070424.324180474@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

commit 49c1866348f364478a0c4d3dd13fd08bb82d3a5b upstream.

The condition is impossible and to the best of my knowledge has never
triggered.

We are in deep trouble if that conditions happens and we walk past
the end of our allocated array.

So delete the WARN_ON and the code that makes it look like the kernel
can handle the case of walking past the end of it's vma_meta array.

Reviewed-by: Jann Horn <jannh@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/coredump.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -1085,12 +1085,6 @@ static bool dump_vma_snapshot(struct cor
 
 	mmap_write_unlock(mm);
 
-	if (WARN_ON(i != cprm->vma_count)) {
-		kvfree(cprm->vma_meta);
-		return false;
-	}
-
-
 	for (i = 0; i < cprm->vma_count; i++) {
 		struct core_vma_metadata *m = cprm->vma_meta + i;
 


