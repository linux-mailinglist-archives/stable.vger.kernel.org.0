Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FFDD593CCB
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233093AbiHOUJs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:09:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240020AbiHOUJF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:09:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7571F2663;
        Mon, 15 Aug 2022 11:55:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2C19B8109E;
        Mon, 15 Aug 2022 18:55:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49302C433C1;
        Mon, 15 Aug 2022 18:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589747;
        bh=hVge2b40hrymoACoRoPHQOleTSb2rRVyOkW4WS8IgBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ubVuyo+HMWd8fssHjtNrvIyrbdpZ51Ym5GNvJEQz8ruZzTFbsTHLT03HsonuB31mU
         E0znBIokEuS+gJGxFUrh/xx2UewWWx2DtyCINFwqTgcusP2B+vmB6TyxggflZRld+B
         hAaE7y31tbSVZzgxa1rAmY08l3hveNRrSetq3Awc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.18 0028/1095] KVM: Put the extra pfn reference when reusing a pfn in the gpc cache
Date:   Mon, 15 Aug 2022 19:50:27 +0200
Message-Id: <20220815180430.527997742@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

commit 3dddf65b4f4c451c345d34ae85bdf1791a746e49 upstream.

Put the struct page reference to pfn acquired by hva_to_pfn() when the
old and new pfns for a gfn=>pfn cache match.  The cache already has a
reference via the old/current pfn, and will only put one reference when
the cache is done with the pfn.

Fixes: 982ed0de4753 ("KVM: Reinstate gfn_to_pfn_cache with invalidation support")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220429210025.3293691-5-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/pfncache.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -206,6 +206,14 @@ int kvm_gfn_to_pfn_cache_refresh(struct
 
 		if (gpc->usage & KVM_HOST_USES_PFN) {
 			if (new_pfn == old_pfn) {
+				/*
+				 * Reuse the existing pfn and khva, but put the
+				 * reference acquired hva_to_pfn_retry(); the
+				 * cache still holds a reference to the pfn
+				 * from the previous refresh.
+				 */
+				gpc_release_pfn_and_khva(kvm, new_pfn, NULL);
+
 				new_khva = old_khva;
 				old_pfn = KVM_PFN_ERR_FAULT;
 				old_khva = NULL;


