Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 406435A49F2
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232244AbiH2LbT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:31:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231237AbiH2LaD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:30:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC0C46BCEE;
        Mon, 29 Aug 2022 04:18:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A945361128;
        Mon, 29 Aug 2022 11:17:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6285C433C1;
        Mon, 29 Aug 2022 11:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771863;
        bh=9GGEEK+29rkGbgMDUIJYkfa5qhQ5CwqP81QP7W3+6jc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jxfnSXOWwSB0yoI5ESkNciXrdC8oTQRWLc5ifir9Nfak0wNR3jYNO/isGkOIQKBPV
         5/fV3v3Q+DIjkZK2EhBQTht+DtauK3ALJfny6+8LqMQI4uBqehhSPH4sspSMe9fYqT
         6/X0rk+on0tRtXWJJv/s9Ujn1kNuG8YF6zTMQCww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.19 115/158] s390/mm: do not trigger write fault when vma does not allow VM_WRITE
Date:   Mon, 29 Aug 2022 12:59:25 +0200
Message-Id: <20220829105813.924839469@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/mm/fault.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -379,7 +379,9 @@ static inline vm_fault_t do_exception(st
 	flags = FAULT_FLAG_DEFAULT;
 	if (user_mode(regs))
 		flags |= FAULT_FLAG_USER;
-	if (access == VM_WRITE || is_write)
+	if (is_write)
+		access = VM_WRITE;
+	if (access == VM_WRITE)
 		flags |= FAULT_FLAG_WRITE;
 	mmap_read_lock(mm);
 


