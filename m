Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D08ED5F2947
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbiJCHRI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:17:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbiJCHQJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:16:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C79F45F7B;
        Mon,  3 Oct 2022 00:13:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D43AA60FA2;
        Mon,  3 Oct 2022 07:13:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E75C5C433C1;
        Mon,  3 Oct 2022 07:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781216;
        bh=lpaqM68iF2A+dnBUkjIFdA/gEKCDcJqoCeNWy5/CwWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S6RsebN3HsNM4IAPUQFZY9zShBY2/P7c4Gu6ogIJQbVwbDwTvrdibQgW3lCtO3nLC
         svKi/oTOf1E2X6XM+/28RjP8ZmqjP0ojpEeF0v9Abfq0FOxedTHUgiSn6RdfvmpGDX
         sLzkecNuwgOaFd/7tV6c0bVYGzE5bhiFA0YlFqUo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Binyi Han <dantengknight@gmail.com>,
        Andrew Morton <akpm@linux-foudation.org>,
        Mike Rapoport <rppt@kernel.org>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Hagen Paul Pfeifer <hagen@jauu.net>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.19 039/101] mm: fix dereferencing possible ERR_PTR
Date:   Mon,  3 Oct 2022 09:10:35 +0200
Message-Id: <20221003070725.443075863@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
References: <20221003070724.490989164@linuxfoundation.org>
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

From: Binyi Han <dantengknight@gmail.com>

commit 4eb5bbde3ccb710d3b85bfb13466612e56393369 upstream.

Smatch checker complains that 'secretmem_mnt' dereferencing possible
ERR_PTR().  Let the function return if 'secretmem_mnt' is ERR_PTR, to
avoid deferencing it.

Link: https://lkml.kernel.org/r/20220904074647.GA64291@cloud-MacBookPro
Fixes: 1507f51255c9f ("mm: introduce memfd_secret system call to create "secret" memory areas")
Signed-off-by: Binyi Han <dantengknight@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foudation.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/secretmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/secretmem.c
+++ b/mm/secretmem.c
@@ -283,7 +283,7 @@ static int secretmem_init(void)
 
 	secretmem_mnt = kern_mount(&secretmem_fs);
 	if (IS_ERR(secretmem_mnt))
-		ret = PTR_ERR(secretmem_mnt);
+		return PTR_ERR(secretmem_mnt);
 
 	/* prevent secretmem mappings from ever getting PROT_EXEC */
 	secretmem_mnt->mnt_flags |= MNT_NOEXEC;


