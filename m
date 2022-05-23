Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 689AA5317D4
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241235AbiEWR3r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242597AbiEWR1s (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:27:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8BDD7CDF3;
        Mon, 23 May 2022 10:23:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C07346152D;
        Mon, 23 May 2022 17:14:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8B86C385AA;
        Mon, 23 May 2022 17:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326047;
        bh=T2Cjm9bkakNUw9hjDDr+pQFIxIEL7vSENcta9GlgXnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mDa75c40gBsWpjGrTCE18EwI5QtmoWS351UCe0zVEi1p0RLkybiw8cDG6foZkeBp8
         rzkgvd0Riu5wSlvSq7jwOZlBqMhMhiw6fDiuK0ryqJzG/1kGbGb7SHie6qfoHQlWca
         LfpU7VMG7tmk5YtbjQMnTfFmQSWgLv6oYP8qv5/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 47/68] ARM: 9197/1: spectre-bhb: fix loop8 sequence for Thumb2
Date:   Mon, 23 May 2022 19:05:14 +0200
Message-Id: <20220523165810.325794402@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165802.500642349@linuxfoundation.org>
References: <20220523165802.500642349@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit 3cfb3019979666bdf33a1010147363cf05e0f17b ]

In Thumb2, 'b . + 4' produces a branch instruction that uses a narrow
encoding, and so it does not jump to the following instruction as
expected. So use W(b) instead.

Fixes: 6c7cb60bff7a ("ARM: fix Thumb2 regression with Spectre BHB")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/kernel/entry-armv.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index 3d65fa56a0e5..8e8efe28d799 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -1043,7 +1043,7 @@ vector_bhb_loop8_\name:
 
 	@ bhb workaround
 	mov	r0, #8
-3:	b	. + 4
+3:	W(b)	. + 4
 	subs	r0, r0, #1
 	bne	3b
 	dsb
-- 
2.35.1



