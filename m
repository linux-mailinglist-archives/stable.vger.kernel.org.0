Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAB64657EDD
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:58:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234205AbiL1P63 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:58:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232081AbiL1P63 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:58:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 596E118697
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:58:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D4CEB81730
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:58:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B347C433D2;
        Wed, 28 Dec 2022 15:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243105;
        bh=2UabSsOlqCYdGnYpJg6lwiZLiazmhh/Z0NoGM4OMvKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gF/jO41YbRGzPVUqd3fudyHXZLCo28tlKgniyQqJjEjnjvRIvXGnj+2qyrrVgsLBc
         ZRIPJkCHcRLIlCAhtjULRaxU+IlxS+K4uR19DKpp8w6UwzFT1vOBoTZ5W51Www2KDN
         nXDpwfFDoOG4CXoesi3TBmJVrjlpkJuEZ81BbauM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Tyler Hicks (Microsoft)" <code@tyhicks.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 684/731] KVM: selftests: Fix build regression by using accessor function
Date:   Wed, 28 Dec 2022 15:43:11 +0100
Message-Id: <20221228144316.296920411@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Tyler Hicks <code@tyhicks.com>

Fix the stable backport of commit 05c2224d4b04 ("KVM: selftests: Fix
number of pages for memory slot in memslot_modification_stress_test"),
which caused memslot_modification_stress_test.c build failures due to
trying to access private members of struct kvm_vm.

v6.0 commit b530eba14c70 ("KVM: selftests: Get rid of
kvm_util_internal.h") and some other commits got rid of the accessors
and made all of the KVM data structures public. Keep using the accessors
in older kernels.

There is no corresponding upstream commit for this change.

Signed-off-by: Tyler Hicks (Microsoft) <code@tyhicks.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kvm/memslot_modification_stress_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
index 1d806b8ffee2..766c1790df66 100644
--- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
+++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
@@ -72,7 +72,7 @@ struct memslot_antagonist_args {
 static void add_remove_memslot(struct kvm_vm *vm, useconds_t delay,
 			       uint64_t nr_modifications)
 {
-	uint64_t pages = max_t(int, vm->page_size, getpagesize()) / vm->page_size;
+	uint64_t pages = max_t(int, vm_get_page_size(vm), getpagesize()) / vm_get_page_size(vm);
 	uint64_t gpa;
 	int i;
 
-- 
2.35.1



