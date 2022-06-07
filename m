Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9097541E3E
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380344AbiFGW1b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:27:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383757AbiFGWZO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:25:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2899426EEBF;
        Tue,  7 Jun 2022 12:22:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE713609D0;
        Tue,  7 Jun 2022 19:22:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B82C7C385A2;
        Tue,  7 Jun 2022 19:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629772;
        bh=9E8DLy1jXcYjYN0wqF0KZRXbQUMR5XhMKZCP7s2JCPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lEjvzEqzSsrZTeAiG93YqHKJHj3wi96zXe2r6D1PytjGLCl8tyY+4y/zVDuC173zi
         g8163PfgXtd84hCQKXwGRqqkV+nyGFQ7ImPbCxAdtGDAKQ8CCaDjUvatlNLsNWONaw
         eEHBfdtlMCOEmn7whRwKHelSKGcPLlzfVEM5OZno=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>
Subject: [PATCH 5.18 761/879] s390/perf: obtain sie_block from the right address
Date:   Tue,  7 Jun 2022 19:04:39 +0200
Message-Id: <20220607165024.953078037@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nico Boehr <nrb@linux.ibm.com>

commit c9bfb460c3e4da2462e16b0f0b200990b36b1dd2 upstream.

Since commit 1179f170b6f0 ("s390: fix fpu restore in entry.S"), the
sie_block pointer is located at empty1[1], but in sie_block() it was
taken from empty1[0].

This leads to a random pointer being dereferenced, possibly causing
system crash.

This problem can be observed when running a simple guest with an endless
loop and recording the cpu-clock event:

  sudo perf kvm --guestvmlinux=<guestkernel> --guest top -e cpu-clock

With this fix, the correct guest address is shown.

Fixes: 1179f170b6f0 ("s390: fix fpu restore in entry.S")
Cc: stable@vger.kernel.org
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/perf_event.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/kernel/perf_event.c
+++ b/arch/s390/kernel/perf_event.c
@@ -30,7 +30,7 @@ static struct kvm_s390_sie_block *sie_bl
 	if (!stack)
 		return NULL;
 
-	return (struct kvm_s390_sie_block *) stack->empty1[0];
+	return (struct kvm_s390_sie_block *)stack->empty1[1];
 }
 
 static bool is_in_guest(struct pt_regs *regs)


