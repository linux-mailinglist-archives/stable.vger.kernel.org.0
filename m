Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C49974D822B
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240154AbiCNMBI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240200AbiCNMAr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:00:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FC2648E70;
        Mon, 14 Mar 2022 04:58:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6280A6120D;
        Mon, 14 Mar 2022 11:58:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31DDAC340E9;
        Mon, 14 Mar 2022 11:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259111;
        bh=MAIlccY/RJd+CCFZzl14X9+ucrvVWEJotG4GzCGGkX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2eTnrXTxpVJmQqLvBCJ3Y2R09nM7ppD+wcA76qqbcJ1/oR73TrNBPqgJFjJBGa6QO
         SVLTvNaY1irLoD7gHW4ruAtdXgWWinoYm/XCZPww/KqFsKbUC4ZwkUXQbap19ekDMy
         Z0WOt1VyFRawHeYzI1LjXyciWde2J/nxBzdRnz6M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Borislav Petkov <bp@suse.de>,
        Liam Merwick <liam.merwick@oracle.com>
Subject: [PATCH 5.4 42/43] x86/mm/pat: Dont flush cache if hardware enforces cache coherency across encryption domnains
Date:   Mon, 14 Mar 2022 12:53:53 +0100
Message-Id: <20220314112735.599916628@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112734.415677317@linuxfoundation.org>
References: <20220314112734.415677317@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krish Sadhukhan <krish.sadhukhan@oracle.com>

commit 75d1cc0e05af579301ce4e49cf6399be4b4e6e76 upstream.

In some hardware implementations, coherency between the encrypted and
unencrypted mappings of the same physical page is enforced. In such a
system, it is not required for software to flush the page from all CPU
caches in the system prior to changing the value of the C-bit for the
page. So check that bit before flushing the cache.

 [ bp: Massage commit message. ]

Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/20200917212038.5090-3-krish.sadhukhan@oracle.com
Signed-off-by: Liam Merwick <liam.merwick@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/pageattr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -1967,7 +1967,7 @@ static int __set_memory_enc_dec(unsigned
 	/*
 	 * Before changing the encryption attribute, we need to flush caches.
 	 */
-	cpa_flush(&cpa, 1);
+	cpa_flush(&cpa, !this_cpu_has(X86_FEATURE_SME_COHERENT));
 
 	ret = __change_page_attr_set_clr(&cpa, 1);
 


