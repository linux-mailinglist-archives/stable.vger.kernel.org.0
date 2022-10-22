Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED2F6085E1
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbiJVHk0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230522AbiJVHjb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:39:31 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 336112B3AD1;
        Sat, 22 Oct 2022 00:36:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CB5D4CE2C9F;
        Sat, 22 Oct 2022 07:36:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2379C433C1;
        Sat, 22 Oct 2022 07:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424195;
        bh=/2VWHXxCuruU2Yfpldt0LZ8uSfriJfdzL6Wr0+OwWB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AWvwpMjv8oTrbDFqZN7+egBDOF5kbGVZIuYiyYcjssImf/milucUZTdGZZfWlRcB4
         MRG5K6v/MX4kHAsjPEJgw3fYAKUR0hZVy3p3AUJLJP3KDLFNVnsTf5ZLZo6z3KMeLd
         x6fh6TknIncW8UezyLa95EmYwrAgOWjRqKmzmegU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Atish Patra <atishp@rivosinc.com>,
        Andrew Bresticker <abrestic@rivosinc.com>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.19 057/717] riscv: Make VM_WRITE imply VM_READ
Date:   Sat, 22 Oct 2022 09:18:56 +0200
Message-Id: <20221022072425.164960595@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Bresticker <abrestic@rivosinc.com>

commit 7ab72c597356be1e7f0f3d856e54ce78527f43c8 upstream.

RISC-V does not presently have write-only mappings as that PTE bit pattern
is considered reserved in the privileged spec, so allow handling of read
faults in VMAs that have VM_WRITE without VM_READ in order to be consistent
with other architectures that have similar limitations.

Fixes: 2139619bcad7 ("riscv: mmap with PROT_WRITE but no PROT_READ is invalid")
Reviewed-by: Atish Patra <atishp@rivosinc.com>
Signed-off-by: Andrew Bresticker <abrestic@rivosinc.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220915193702.2201018-2-abrestic@rivosinc.com/
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/mm/fault.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/riscv/mm/fault.c
+++ b/arch/riscv/mm/fault.c
@@ -184,7 +184,8 @@ static inline bool access_error(unsigned
 		}
 		break;
 	case EXC_LOAD_PAGE_FAULT:
-		if (!(vma->vm_flags & VM_READ)) {
+		/* Write implies read */
+		if (!(vma->vm_flags & (VM_READ | VM_WRITE))) {
 			return true;
 		}
 		break;


