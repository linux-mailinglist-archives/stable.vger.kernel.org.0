Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F39D666C4C3
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231589AbjAPP6J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:58:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231578AbjAPP5w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:57:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7681022A39
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:57:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1549E61031
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:57:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28710C433D2;
        Mon, 16 Jan 2023 15:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884670;
        bh=CjnIMz9N+uY5Chp//8tl+ws15CXjGBCQlpsCcuRo4jI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=shbZgAxFibN++GZq/xRxH3guz5ZUTDY4lCPBN98hBeTnY13M3bpDP3cP8Lzl7ZVzP
         sKl7lCQLFqU1PBRFOdHamQA9HT4Hz5+Cwzy2WixcCJbrrOTaM290lQqCeQDfHSJL78
         d/HIG5wbKat7JHSUsVYBBXsP4cAmU0PfVGFjc4pc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        Juergen Gross <jgross@suse.com>,
        "Borislav Petkov (AMD)" <bp@alien8.de>, stable@kernel.org
Subject: [PATCH 6.1 094/183] x86/pat: Fix pat_x_mtrr_type() for MTRR disabled case
Date:   Mon, 16 Jan 2023 16:50:17 +0100
Message-Id: <20230116154807.387494178@linuxfoundation.org>
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

From: Juergen Gross <jgross@suse.com>

commit 90b926e68f500844dff16b5bcea178dc55cf580a upstream.

Since

  72cbc8f04fe2 ("x86/PAT: Have pat_enabled() properly reflect state when running on Xen")

PAT can be enabled without MTRR.

This has resulted in problems e.g. for a SEV-SNP guest running under Hyper-V,
when trying to establish a new mapping via memremap() with WB caching mode, as
pat_x_mtrr_type() will call mtrr_type_lookup(), which in turn is returning
MTRR_TYPE_INVALID due to MTRR being disabled in this configuration.

The result is a mapping with UC- caching, leading to severe performance
degradation.

Fix that by handling MTRR_TYPE_INVALID the same way as MTRR_TYPE_WRBACK
in pat_x_mtrr_type() because MTRR_TYPE_INVALID means MTRRs are disabled.

  [ bp: Massage commit message. ]

Fixes: 72cbc8f04fe2 ("x86/PAT: Have pat_enabled() properly reflect state when running on Xen")
Reported-by: Michael Kelley (LINUX) <mikelley@microsoft.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Tested-by: Michael Kelley <mikelley@microsoft.com>
Cc: <stable@kernel.org>
Link: https://lore.kernel.org/r/20230110065427.20767-1-jgross@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/pat/memtype.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/mm/pat/memtype.c
+++ b/arch/x86/mm/pat/memtype.c
@@ -434,7 +434,8 @@ static unsigned long pat_x_mtrr_type(u64
 		u8 mtrr_type, uniform;
 
 		mtrr_type = mtrr_type_lookup(start, end, &uniform);
-		if (mtrr_type != MTRR_TYPE_WRBACK)
+		if (mtrr_type != MTRR_TYPE_WRBACK &&
+		    mtrr_type != MTRR_TYPE_INVALID)
 			return _PAGE_CACHE_MODE_UC_MINUS;
 
 		return _PAGE_CACHE_MODE_WB;


