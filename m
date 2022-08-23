Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8A359D9D1
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243083AbiHWKC7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352016AbiHWKBF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:01:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6544127B2D;
        Tue, 23 Aug 2022 01:48:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20EEC61386;
        Tue, 23 Aug 2022 08:48:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 262B7C433C1;
        Tue, 23 Aug 2022 08:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244515;
        bh=hG3JMbhdNDO2gZbIp193qOzFN0q0GOPDtuYxgu3A/pg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wmSd4gVelAHIb39fyTlN3tGL3HgPR/IBUNPOnXJZ9xpBUTwg5R/4EOx0w/oo/xaul
         suf+5WHq9YUI85TSeN7wnGjeVrS74heHYmuT0XWMrbZBB0UpGIDFZqCc9Wcrnb3f6/
         bgBB1qI5ovOJtzwafX/xODvrc7JOW2ebaTrpuUug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 5.15 105/244] fs/ntfs3: Dont clear upper bits accidentally in log_replay()
Date:   Tue, 23 Aug 2022 10:24:24 +0200
Message-Id: <20220823080102.523538028@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 926034353d3c67db1ffeab47dcb7f6bdac02a263 upstream.

The "vcn" variable is a 64 bit.  The "log->clst_per_page" variable is a
u32.  This means that the mask accidentally clears out the high 32 bits
when it was only supposed to clear some low bits.  Fix this by adding a
cast to u64.

Fixes: b46acd6a6a62 ("fs/ntfs3: Add NTFS journal")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/fslog.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -5057,7 +5057,7 @@ undo_action_next:
 		goto add_allocated_vcns;
 
 	vcn = le64_to_cpu(lrh->target_vcn);
-	vcn &= ~(log->clst_per_page - 1);
+	vcn &= ~(u64)(log->clst_per_page - 1);
 
 add_allocated_vcns:
 	for (i = 0, vcn = le64_to_cpu(lrh->target_vcn),


