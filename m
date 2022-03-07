Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C34254CF8D7
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238765AbiCGKCn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:02:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240825AbiCGKBS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:01:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D9176D383;
        Mon,  7 Mar 2022 01:50:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA68960929;
        Mon,  7 Mar 2022 09:50:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9591C340F3;
        Mon,  7 Mar 2022 09:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646657;
        bh=J+/jw8k4zKjtveZbhrOnbT76RkWaWlpLCcmkq5W6CFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zjc2i/SWH0wbuuFD9OcsMlC0QzHhvoBqv8F9p+yx7mlvaSVmRNrDWHVSIuC0iaYEZ
         eZp4CpWP1MzW/vMIKjDaLahPT+oeD/yWOiwXUBegWqD/YYdEcigTNcm1K4aCEITM0I
         TSQAuUsOKAOrhILvL0pp/xykKU/tvOxXrUZLJmSg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biederman <ebiederm@xmission.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        matoro <matoro_bugzilla_kernel@matoro.tk>,
        matoro <matoro_mailinglist_kernel@matoro.tk>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.16 050/186] binfmt_elf: Avoid total_mapping_size for ET_EXEC
Date:   Mon,  7 Mar 2022 10:18:08 +0100
Message-Id: <20220307091655.493807730@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
References: <20220307091654.092878898@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit 439a8468242b313486e69b8cc3b45ddcfa898fbf upstream.

Partially revert commit 5f501d555653 ("binfmt_elf: reintroduce using
MAP_FIXED_NOREPLACE"), which applied the ET_DYN "total_mapping_size"
logic also to ET_EXEC.

At least ia64 has ET_EXEC PT_LOAD segments that are not virtual-address
contiguous (but _are_ file-offset contiguous). This would result in a
giant mapping attempting to cover the entire span, including the virtual
address range hole, and well beyond the size of the ELF file itself,
causing the kernel to refuse to load it. For example:

$ readelf -lW /usr/bin/gcc
...
Program Headers:
  Type Offset   VirtAddr           PhysAddr           FileSiz  MemSiz   ...
...
  LOAD 0x000000 0x4000000000000000 0x4000000000000000 0x00b5a0 0x00b5a0 ...
  LOAD 0x00b5a0 0x600000000000b5a0 0x600000000000b5a0 0x0005ac 0x000710 ...
...
       ^^^^^^^^ ^^^^^^^^^^^^^^^^^^                    ^^^^^^^^ ^^^^^^^^

File offset range     : 0x000000-0x00bb4c
			0x00bb4c bytes

Virtual address range : 0x4000000000000000-0x600000000000bcb0
			0x200000000000bcb0 bytes

Remove the total_mapping_size logic for ET_EXEC, which reduces the
ET_EXEC MAP_FIXED_NOREPLACE coverage to only the first PT_LOAD (better
than nothing), and retains it for ET_DYN.

Ironically, this is the reverse of the problem that originally caused
problems with MAP_FIXED_NOREPLACE: overlapping PT_LOAD segments. Future
work could restore full coverage if load_elf_binary() were to perform
mappings in a separate phase from the loading (where it could resolve
both overlaps and holes).

Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org
Reported-by: matoro <matoro_bugzilla_kernel@matoro.tk>
Fixes: 5f501d555653 ("binfmt_elf: reintroduce using MAP_FIXED_NOREPLACE")
Link: https://lore.kernel.org/r/a3edd529-c42d-3b09-135c-7e98a15b150f@leemhuis.info
Tested-by: matoro <matoro_mailinglist_kernel@matoro.tk>
Link: https://lore.kernel.org/lkml/ce8af9c13bcea9230c7689f3c1e0e2cd@matoro.tk
Tested-By: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Link: https://lore.kernel.org/lkml/49182d0d-708b-4029-da5f-bc18603440a6@physik.fu-berlin.de
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/binfmt_elf.c |   25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1135,14 +1135,25 @@ out_free_interp:
 			 * is then page aligned.
 			 */
 			load_bias = ELF_PAGESTART(load_bias - vaddr);
-		}
 
-		/*
-		 * Calculate the entire size of the ELF mapping (total_size).
-		 * (Note that load_addr_set is set to true later once the
-		 * initial mapping is performed.)
-		 */
-		if (!load_addr_set) {
+			/*
+			 * Calculate the entire size of the ELF mapping
+			 * (total_size), used for the initial mapping,
+			 * due to load_addr_set which is set to true later
+			 * once the initial mapping is performed.
+			 *
+			 * Note that this is only sensible when the LOAD
+			 * segments are contiguous (or overlapping). If
+			 * used for LOADs that are far apart, this would
+			 * cause the holes between LOADs to be mapped,
+			 * running the risk of having the mapping fail,
+			 * as it would be larger than the ELF file itself.
+			 *
+			 * As a result, only ET_DYN does this, since
+			 * some ET_EXEC (e.g. ia64) may have large virtual
+			 * memory holes between LOADs.
+			 *
+			 */
 			total_size = total_mapping_size(elf_phdata,
 							elf_ex->e_phnum);
 			if (!total_size) {


