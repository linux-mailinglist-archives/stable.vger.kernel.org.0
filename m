Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E805363DFF6
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:52:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231503AbiK3SwV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:52:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231531AbiK3SwJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:52:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 866A863D5E
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:52:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 561EC61D76
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:52:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61802C433D7;
        Wed, 30 Nov 2022 18:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834323;
        bh=o0uxAipM25by0a+gwbClrNqPdRAEy9a5R+C3h/9t9Dw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HdEJMy1RvHjPS3lVdzb7e324FivfLZEgrj4E3Oa+DO8s7GtiQdfSDhT+ZZQ4wcvpZ
         NZcF29fzHQG+5o6qhD18ZfgtK6nrKpjrNXx3eHdd4D+IWKrCRFLghh9hwq1U85IcH3
         1E17x6ZpopfEvjHy1UMslD4tRki9tlPL50HEaMJA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, David Woodhouse <dwmw@amazon.co.uk>,
        Paul Durrant <paul@xen.org>,
        Sean Christopherson <seanjc@google.com>, stable@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.0 212/289] KVM: Update gfn_to_pfn_cache khva when it moves within the same page
Date:   Wed, 30 Nov 2022 19:23:17 +0100
Message-Id: <20221130180548.925232534@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

From: David Woodhouse <dwmw@amazon.co.uk>

commit 8332f0ed4f187c7b700831bd7cc83ce180a944b9 upstream.

In the case where a GPC is refreshed to a different location within the
same page, we didn't bother to update it. Mostly we don't need to, but
since the ->khva field also includes the offset within the page, that
does have to be updated.

Fixes: 3ba2c95ea180 ("KVM: Do not incorporate page offset into gfn=>pfn cache user address")
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Paul Durrant <paul@xen.org>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Cc: stable@kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/pfncache.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -297,7 +297,12 @@ int kvm_gfn_to_pfn_cache_refresh(struct
 	if (!gpc->valid || old_uhva != gpc->uhva) {
 		ret = hva_to_pfn_retry(kvm, gpc);
 	} else {
-		/* If the HVA→PFN mapping was already valid, don't unmap it. */
+		/*
+		 * If the HVA→PFN mapping was already valid, don't unmap it.
+		 * But do update gpc->khva because the offset within the page
+		 * may have changed.
+		 */
+		gpc->khva = old_khva + page_offset;
 		old_pfn = KVM_PFN_ERR_FAULT;
 		old_khva = NULL;
 		ret = 0;


