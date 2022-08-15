Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDD6F594281
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242760AbiHOVvu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349871AbiHOVsz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:48:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F2842F65D;
        Mon, 15 Aug 2022 12:32:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B731EB8107A;
        Mon, 15 Aug 2022 19:32:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13883C433C1;
        Mon, 15 Aug 2022 19:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591923;
        bh=gzYtX3jUM3PkHakrG20VtWROjOwHdudeIMY7TqfKmB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eK2fZO45Fr4D7MoUcA0In4H/wCKXBzGAq5jg1a5dBZSMzV82qJkT2hPvnZBnHFBHN
         DJzvhOZI1DSmo+d1ZSjzceyNXYNztl2mWijojMABinAuVPS5VmjwITwlJUoUYXYB70
         0CLYnH5+yOEEQqnzgE8/lwHKjsR+2IihM6Ss7234=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.19 0031/1157] KVM: Do not incorporate page offset into gfn=>pfn cache user address
Date:   Mon, 15 Aug 2022 19:49:47 +0200
Message-Id: <20220815180440.683624915@linuxfoundation.org>
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


