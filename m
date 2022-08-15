Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57407594BF9
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344530AbiHPAsO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:48:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349822AbiHPAqq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:46:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76228196845;
        Mon, 15 Aug 2022 13:45:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6BD17B80EAD;
        Mon, 15 Aug 2022 20:45:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD03AC433D7;
        Mon, 15 Aug 2022 20:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596306;
        bh=W5pDJItj94NXUxrK1mfpqh+HdM5JMas3eDHf6EDrFqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GTUKixmbUqR62i8yyNmGEggcRACQwfZWuqL8whzk5bm1/iRSH87XWoXWOjGMhdPKt
         hv99KRUBKQH1ocbu0fMNreTKkL0uZ5ZPafeghAq3Vwd8oqoN+g1/0qQFV/e2N7YkuV
         ZFgU6erFemDSZKdMiPSZgkBajk8Wen7nrcPV+1Ig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 1010/1157] powerpc/spufs: Fix refcount leak in spufs_init_isolated_loader
Date:   Mon, 15 Aug 2022 20:06:06 +0200
Message-Id: <20220815180520.254683760@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 6ac059dacffa8ab2f7798f20e4bd3333890c541c ]

of_find_node_by_path() returns remote device nodepointer with
refcount incremented, we should use of_node_put() on it when done.
Add missing of_node_put() to avoid refcount leak.

Fixes: 0afacde3df4c ("[POWERPC] spufs: allow isolated mode apps by starting the SPE loader")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220603121543.22884-1-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/cell/spufs/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/platforms/cell/spufs/inode.c b/arch/powerpc/platforms/cell/spufs/inode.c
index 34334c32b7f5..320008528edd 100644
--- a/arch/powerpc/platforms/cell/spufs/inode.c
+++ b/arch/powerpc/platforms/cell/spufs/inode.c
@@ -660,6 +660,7 @@ spufs_init_isolated_loader(void)
 		return;
 
 	loader = of_get_property(dn, "loader", &size);
+	of_node_put(dn);
 	if (!loader)
 		return;
 
-- 
2.35.1



