Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F533593C52
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346351AbiHOUO0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346233AbiHOULF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:11:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73F6AB851;
        Mon, 15 Aug 2022 11:57:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2EC36B810A2;
        Mon, 15 Aug 2022 18:57:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F002C433D6;
        Mon, 15 Aug 2022 18:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589832;
        bh=gzYtX3jUM3PkHakrG20VtWROjOwHdudeIMY7TqfKmB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eF9+YqtInlOupS+mxqqmxYFJrNBG5bIZhlwP6ImxI0emnSOle/Nrq0zIYPa6VUhm9
         U0ITn0AwismzK8yhE9PPRryQawbLTi0aq7ASQ4MKZjjjFwvwzhyV3dAXjWK2BnNGya
         DKTFE00FAuPYdBLPK2o2xUWMs7e3eUrCM2OIBDKg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.18 0031/1095] KVM: Do not incorporate page offset into gfn=>pfn cache user address
Date:   Mon, 15 Aug 2022 19:50:30 +0200
Message-Id: <20220815180430.657525381@linuxfoundation.org>
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

commit 3ba2c95ea180740b16281fa43a3ee5f47279c0ed upstream.

Don't adjust the userspace address in the gfn=>pfn cache by the page
offset from the gpa.  KVM should never use the user address directly, and
all KVM operations that translate a user address to something else
require the user address to be page aligned.  Ignoring the offset will
allow the cache to reuse a gfn=>hva translation in the unlikely event
that the page offset of the gpa changes, but the gfn does not.  And more
importantly, not having to (un)adjust the user address will simplify a
future bug fix.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220429210025.3293691-6-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/pfncache.c |    2 --
 1 file changed, 2 deletions(-)

--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -274,8 +274,6 @@ int kvm_gfn_to_pfn_cache_refresh(struct
 			ret = -EFAULT;
 			goto out;
 		}
-
-		gpc->uhva += page_offset;
 	}
 
 	/*


