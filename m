Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED0AE5AB0F9
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 15:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238391AbiIBNBY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 09:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238395AbiIBM7v (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:59:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8BE1FE357;
        Fri,  2 Sep 2022 05:41:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1BACB82A94;
        Fri,  2 Sep 2022 12:40:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D703C433C1;
        Fri,  2 Sep 2022 12:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662122432;
        bh=HvJAvfahX2qMcHfJMcbUzlT+p01VbVQuQu0FwetkayU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rgAYcY/nyYZxsvkJWn0YEfoVU1MyFCpZjvaRhC0rAtOTsGUrCMCF4iVwATOE1tfnf
         ba54n1oGZF0TCY3FB3Z+z/rbic1V2lJaMimrKLTztTdv2RexyYm9Buxxk3wRFr3KFO
         8oTy4FZM0VzbygrFWfdVkDOVBqIq2atiBTICPaic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.10 05/37] s390/mm: do not trigger write fault when vma does not allow VM_WRITE
Date:   Fri,  2 Sep 2022 14:19:27 +0200
Message-Id: <20220902121359.338498863@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121359.177846782@linuxfoundation.org>
References: <20220902121359.177846782@linuxfoundation.org>
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
@@ -429,7 +429,9 @@ static inline vm_fault_t do_exception(st
 	flags = FAULT_FLAG_DEFAULT;
 	if (user_mode(regs))
 		flags |= FAULT_FLAG_USER;
-	if (access == VM_WRITE || (trans_exc_code & store_indication) == 0x400)
+	if ((trans_exc_code & store_indication) == 0x400)
+		access = VM_WRITE;
+	if (access == VM_WRITE)
 		flags |= FAULT_FLAG_WRITE;
 	mmap_read_lock(mm);
 


