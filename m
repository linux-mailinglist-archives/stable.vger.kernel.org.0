Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 442DB5AAE81
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236291AbiIBMY2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236293AbiIBMXu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:23:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8D63D91D8;
        Fri,  2 Sep 2022 05:22:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA9C8620EB;
        Fri,  2 Sep 2022 12:21:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1EDCC433C1;
        Fri,  2 Sep 2022 12:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121309;
        bh=XxsNR4FPcXRUdwg6ca8TZN1PIrBZLP+n3UGnOVKXkAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lx9YtOvqzU79hu/R/Ox768kjUNeJBpO3IHq7fC37YPUqLP2A7+6bdXYhOtC3yrWyH
         Z5dasqohuJavpLtUnuFgNW/rr7vvruy3BP5M3VZDnDWFtkisOOK/e+kw7actwjn5TY
         7FxVu397HepgU51XzccHg7zttbTssxWBJxlMZ1oA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 4.9 18/31] s390/mm: do not trigger write fault when vma does not allow VM_WRITE
Date:   Fri,  2 Sep 2022 14:18:44 +0200
Message-Id: <20220902121357.431340840@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121356.732130937@linuxfoundation.org>
References: <20220902121356.732130937@linuxfoundation.org>
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

From: Gerald Schaefer <gerald.schaefer@linux.ibm.com>

commit 41ac42f137080bc230b5882e3c88c392ab7f2d32 upstream.

For non-protection pXd_none() page faults in do_dat_exception(), we
call do_exception() with access == (VM_READ | VM_WRITE | VM_EXEC).
In do_exception(), vma->vm_flags is checked against that before
calling handle_mm_fault().

Since commit 92f842eac7ee3 ("[S390] store indication fault optimization"),
we call handle_mm_fault() with FAULT_FLAG_WRITE, when recognizing that
it was a write access. However, the vma flags check is still only
checking against (VM_READ | VM_WRITE | VM_EXEC), and therefore also
calling handle_mm_fault() with FAULT_FLAG_WRITE in cases where the vma
does not allow VM_WRITE.

Fix this by changing access check in do_exception() to VM_WRITE only,
when recognizing write access.

Link: https://lkml.kernel.org/r/20220811103435.188481-3-david@redhat.com
Fixes: 92f842eac7ee3 ("[S390] store indication fault optimization")
Cc: <stable@vger.kernel.org>
Reported-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/mm/fault.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -409,7 +409,9 @@ static inline int do_exception(struct pt
 	flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
 	if (user_mode(regs))
 		flags |= FAULT_FLAG_USER;
-	if (access == VM_WRITE || (trans_exc_code & store_indication) == 0x400)
+	if ((trans_exc_code & store_indication) == 0x400)
+		access = VM_WRITE;
+	if (access == VM_WRITE)
 		flags |= FAULT_FLAG_WRITE;
 	down_read(&mm->mmap_sem);
 


