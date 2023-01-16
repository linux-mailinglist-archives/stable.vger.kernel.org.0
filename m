Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4B366C486
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231463AbjAPP4B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:56:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231669AbjAPPzl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:55:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1FF6227BB
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:55:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A90E6102F
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:55:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B98DC433EF;
        Mon, 16 Jan 2023 15:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884534;
        bh=G+v7Arj7mrk8/hwC5RJ1tHg1N5wxVNo4pcEpsK2Pm6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=geMkH0cKO0qyI5RdebI0WOBZVWfQop0iXM1wfBGluC4YkRA6wQcviKlA2mSEEPaCT
         n1u5gChlrLglxwQccjh0dw+4sY9Sw4gt0bxbRaO6yh+V83BC7rdZ37PSWrt3OQxy64
         NUWN7q3i14a6pSGBrRGm5JI/xNVB5arOONj9yfg8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>,
        Seth Jenkins <sethjenkins@google.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 6.1 013/183] arm64: mte: Fix double-freeing of the temporary tag storage during coredump
Date:   Mon, 16 Jan 2023 16:48:56 +0100
Message-Id: <20230116154803.962077994@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
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

From: Catalin Marinas <catalin.marinas@arm.com>

commit 736eedc974eaafbf4360e0ea85fc892cea72a223 upstream.

Commit 16decce22efa ("arm64: mte: Fix the stack frame size warning in
mte_dump_tag_range()") moved the temporary tag storage array from the
stack to slab but it also introduced an error in double freeing this
object. Remove the in-loop freeing.

Fixes: 16decce22efa ("arm64: mte: Fix the stack frame size warning in mte_dump_tag_range()")
Cc: <stable@vger.kernel.org> # 5.18.x
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reported-by: Seth Jenkins <sethjenkins@google.com>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20221222181251.1345752-2-catalin.marinas@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/elfcore.c |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/arm64/kernel/elfcore.c
+++ b/arch/arm64/kernel/elfcore.c
@@ -65,7 +65,6 @@ static int mte_dump_tag_range(struct cor
 		mte_save_page_tags(page_address(page), tags);
 		put_page(page);
 		if (!dump_emit(cprm, tags, MTE_PAGE_TAG_STORAGE)) {
-			mte_free_tag_storage(tags);
 			ret = 0;
 			break;
 		}


