Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A14D4C78DF
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 20:49:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbiB1Ts0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 14:48:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbiB1TsK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 14:48:10 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6846EF7B4
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 11:46:19 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id p3-20020a17090a680300b001bbfb9d760eso111062pjj.2
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 11:46:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tR+AhlIqjS9XYnLOtynP2EhZ/OV9mCnZ9eIc3MUdC24=;
        b=EEqg7pUkySZVbQvZfJGIVuw0lXwGWG+go3YvVrAhLQgLhiQhNzDWgCAEyKKhK7DPsx
         H1LWnVGxrPGJ5ZGzxfs/DLiWdoAxZu1P28f0+C1qdVWmaheFrUNc+ZjxCmcoA8AqfTkH
         r9Wsbvj+psRVE1ujQo6yM8ftEYCR7mER0tJ+8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tR+AhlIqjS9XYnLOtynP2EhZ/OV9mCnZ9eIc3MUdC24=;
        b=op23m4D3VZv/8ihyShEyomLLueOTKEZDMLaLH3twyNb7Z1KHe9eu3przXEZ682U8Es
         GTGoUSp6INTqHUFJJ7noJlYiHkhEWu/1MQql6vJRuqOPcPW3rlu/R6pOxcCrBOevt9T2
         ad8NPYh8HM8aGIGC+SYwJczDKLCVntcMiRQFLxtoZ1j1TiRSqEIq22ioQhpy0EEzqKb+
         PoQvZIFsgzJLY0tUiMkGUfnp5hOWsaTKJoX+0vX3PlivIXCQN1fM2bvA6e72IT0sUHgE
         CBKvEYveT+HafEDTlDBU6DOcNNybK4VTsXO4X3Ck9vjCUlBVIvP0cqkyJVH+CAGu5Lp1
         RjqA==
X-Gm-Message-State: AOAM532GHRRHhNOzNgEF2nO/T/B6sRa2Uev3srh1KQnNtpPyKeX9iQ0U
        wZbHhIzeqPyQnIn5NIKAJgsrQQ==
X-Google-Smtp-Source: ABdhPJz8yuUY3QLjcjfiLAIH3SgbY2+JCxtn3vQ51x519MkGnccf2G5leuKh/e98pxMWfX9wrbgW2g==
X-Received: by 2002:a17:90a:6688:b0:1bc:5492:6373 with SMTP id m8-20020a17090a668800b001bc54926373mr18053297pjj.161.1646077576522;
        Mon, 28 Feb 2022 11:46:16 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id v10-20020a056a00148a00b004e0f420dd90sm14288692pfu.40.2022.02.28.11.46.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 11:46:16 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     matoro <matoro_mailinglist_kernel@matoro.tk>
Cc:     Kees Cook <keescook@chromium.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Eric Biederman <ebiederm@xmission.com>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        stable@vger.kernel.org,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Anthony Yznaga <anthony.yznaga@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        regressions@lists.linux.dev, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH] binfmt_elf: Avoid total_mapping_size for ET_EXEC
Date:   Mon, 28 Feb 2022 11:46:13 -0800
Message-Id: <20220228194613.1149432-1-keescook@chromium.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3328; h=from:subject; bh=l5ScQA97desVa/cbVIp0ld/aMpV+dI3qivoNgmUT4HY=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBiHSaEHNpWviXuAR7FBfgnykVicWqBdDFz4Mm5Oxru Wk8kzj2JAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYh0mhAAKCRCJcvTf3G3AJvL6D/ 4/8Opfekx+etBVTmmg6BBaHAHA8L48+PvyAvXuTrQcBwmTx6u2kHTlNm05KEHD78I3pPl6WFdLidNX hdHtV9YD4pJtlDXWQYpaKFFRSPyMb1Q+Zr3T3Pcw2ONhm72yKR+w2EWSmncLYr9WVuBMr/sMMYY5y0 d4fUjZ0olF55wDUFE+2rN2CcIU4e8HjqVoo+2yvOLqPh8YDdw86l3Z0q9Vj5iq+gH6eLvU5WxEG/eZ cjgfLahNoXjCP0/dlPZeGn4vO8xP36bTR3heewwP2OUFH6FokRxzK85fJXQuhjeTP9WhSdxUtHSezM tHCWIEPOOULFM4ONKAHuXgfjk4aOsipHcg+5sWqeuzU6H3aQb40AiEIR/X7ToKo74ys1wDl1ZYvu2v c07D7+PJ59abndEeaJhxsqJUfYh2JY7ggnaUD/qTMlV+h+6oYiQ2xfc6fp0mcaO4qduMYvC30ATa4G rBzu0m3FByxUJKRnhZnkt6cNIIovqdDVjUbCt0fboRZUO0OOPjAJDGrGqPeArViNIyUJHYJyU87fIC o6/z5yPlNufXyH4ki0eM09QNq+3oIB+MFcUlvE1VrtB4qJYmqVYosQg35kBCPgpeFH9s9ZaIiEZb6q q00aBsO4vT+xKC6RAmJH89G7YBiDGotMkgw0F44f/jTcOCP3obE29Gyc86/A==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Partially revert commit 5f501d555653 ("binfmt_elf: reintroduce using
MAP_FIXED_NOREPLACE").

At least ia64 has ET_EXEC PT_LOAD segments that are not virtual-address
contiguous (but _are_ file-offset contiguous). This would result in
giant mapping attempts to cover the entire span, including the virtual
address range hole. Disable total_mapping_size for ET_EXEC, which
reduces the MAP_FIXED_NOREPLACE coverage to only the first PT_LOAD:

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

Ironically, this is the reverse of the problem that originally caused
problems with ET_EXEC and MAP_FIXED_NOREPLACE: overlaps. This problem is
with holes. Future work could restore full coverage if load_elf_binary()
were to perform mappings in a separate phase from the loading (where
it could resolve both overlaps and holes).

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org
Reported-by: matoro <matoro_mailinglist_kernel@matoro.tk>
Reported-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Fixes: 5f501d555653 ("binfmt_elf: reintroduce using MAP_FIXED_NOREPLACE")
Link: https://lore.kernel.org/r/a3edd529-c42d-3b09-135c-7e98a15b150f@leemhuis.info
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
matoro (or anyone else) can you please test this?
---
 fs/binfmt_elf.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 9bea703ed1c2..474b44032c65 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1136,14 +1136,25 @@ static int load_elf_binary(struct linux_binprm *bprm)
 			 * is then page aligned.
 			 */
 			load_bias = ELF_PAGESTART(load_bias - vaddr);
-		}
 
-		/*
-		 * Calculate the entire size of the ELF mapping (total_size).
-		 * (Note that first_pt_load is set to false later once the
-		 * initial mapping is performed.)
-		 */
-		if (first_pt_load) {
+			/*
+			 * Calculate the entire size of the ELF mapping
+			 * (total_size), used for the initial mapping,
+			 * due to first_pt_load which is set to false later
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
+			 * some ET_EXEC (e.g. ia64) may have virtual
+			 * memory holes between LOADs.
+			 *
+			 */
 			total_size = total_mapping_size(elf_phdata,
 							elf_ex->e_phnum);
 			if (!total_size) {
-- 
2.32.0

