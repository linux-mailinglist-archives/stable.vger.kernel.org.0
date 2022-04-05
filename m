Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13AF84F2B41
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238774AbiDEIoY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241254AbiDEIc6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00C7262C9;
        Tue,  5 Apr 2022 01:30:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 920DF609D0;
        Tue,  5 Apr 2022 08:30:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E8E9C385A0;
        Tue,  5 Apr 2022 08:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147443;
        bh=LxOndK3xUi3E/pPKh0wsCPb8uywQyc6fS8zHAp77ieM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ub6lIl2mUNgwso+jb3Yrmw5+W5abeblR79Z7aDtHbkfwSRT1QkeplOYwgC/ey3I4t
         DWo83AwBH3L4eVl5IUMgaV2OX2eetEiNaYUAoqk2ShQi3QUlhFcK876VFynduHaf7y
         pgU1OjPxIyFqajufRDN+EYknC+JUZ/Ysf7H3TqVE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Kees Cook <keescook@chromium.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 5.17 1124/1126] coredump: Remove the WARN_ON in dump_vma_snapshot
Date:   Tue,  5 Apr 2022 09:31:11 +0200
Message-Id: <20220405070440.417712317@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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
@@ -1139,12 +1139,6 @@ static bool dump_vma_snapshot(struct cor
 
 	mmap_write_unlock(mm);
 
-	if (WARN_ON(i != cprm->vma_count)) {
-		kvfree(cprm->vma_meta);
-		return false;
-	}
-
-
 	for (i = 0; i < cprm->vma_count; i++) {
 		struct core_vma_metadata *m = cprm->vma_meta + i;
 


