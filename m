Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 384224F330C
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237660AbiDEInD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:43:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241006AbiDEIcn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82927AFAE2;
        Tue,  5 Apr 2022 01:25:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D870560FF7;
        Tue,  5 Apr 2022 08:25:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC68C385A1;
        Tue,  5 Apr 2022 08:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147152;
        bh=tKl8Rar6xGkNX+SNXpGptpyUaVGPaBj0bQ16qgQWdwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ORavolQsCDkkbMNOMxauUiG24WSoBinzUqnlBSYymlXvQe8t7TghPBF/UGzKxHmxc
         YcSXNAaz6RB1lGhlhWudrC3fteXtpyqULzkgIbdos+UGsqw1HdXmqzTaHSOU9jooj8
         ypnGIOHfpJg5eHHZAvjVn7GAEJWV2cQSi5Y6ie7k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.17 1003/1126] KVM: avoid double put_page with gfn-to-pfn cache
Date:   Tue,  5 Apr 2022 09:29:10 +0200
Message-Id: <20220405070436.931601245@linuxfoundation.org>
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

From: David Woodhouse <dwmw@amazon.co.uk>

commit 79593c086eb95eb2886f36ee6f78a1d6845e1bdf upstream.

If the cache's user host virtual address becomes invalid, there
is still a path from kvm_gfn_to_pfn_cache_refresh() where __release_gpc()
could release the pfn but the gpc->pfn field has not been overwritten
with an error value.  If this happens, kvm_gfn_to_pfn_cache_unmap will
call put_page again on the same page.

Cc: stable@vger.kernel.org
Fixes: 982ed0de4753 ("KVM: Reinstate gfn_to_pfn_cache with invalidation support")
Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/pfncache.c |    1 +
 1 file changed, 1 insertion(+)

--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -191,6 +191,7 @@ int kvm_gfn_to_pfn_cache_refresh(struct
 		gpc->uhva = gfn_to_hva_memslot(gpc->memslot, gfn);
 
 		if (kvm_is_error_hva(gpc->uhva)) {
+			gpc->pfn = KVM_PFN_ERR_FAULT;
 			ret = -EFAULT;
 			goto out;
 		}


