Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D61344C7B0D
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 21:55:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbiB1U4C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 15:56:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiB1U4B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 15:56:01 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E3AB28991
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 12:55:21 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id i1so11764688plr.2
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 12:55:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2qwFbvKJjNJ9kpfcP7L3gRz+/TG5jg+66rcMLtLBvv4=;
        b=ff9E0q28t0GzeZEuRCp0VtckplJiu7j4uIeaV6bdOm7ghaJm89mJIZPnzNMj8fovBy
         otsh61Z9SR8BIRgs9KuTz6MNqME9md3OHpgAwbBqdRaGk51ZfOWyGw4qAVRoreXK4Waw
         +FbcreXgduArlgwr4unBjONh3KsjkahFYGetE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2qwFbvKJjNJ9kpfcP7L3gRz+/TG5jg+66rcMLtLBvv4=;
        b=Sv3qsW+Q92QZoehbWlFkmsr1znBJGGsVC3oX54UTziG77QZMstImHe83OTYE1Vhykv
         7psTLq8xwN7/g/zANlM5nS7zgK0sIQ5FAxUeX07f6BWZCZd3R8EtUABXCezNWqA+OJUP
         477068Du0HCZDvEjk9R2XdHBnIgvcUYq7qm0OOeTh6pfDx7GfRHxhSknh9xXhrKho8et
         wCw+nsFkw96iD9W3/XhPULHeHR6CnS9l7/nK7seV94fMNVRhDoeq0OjW6cmVlgYFHvDP
         AyIPfiBqILb03fCt8G968fQApHttQ9iVbHQC4Yoshah8qjKqxh5ecD8PoLWYrkbGwmhb
         ABJw==
X-Gm-Message-State: AOAM5331f9rlnecJC9X6ugGVlS3OJ6MCSoVBpV9PuVMlOunN06Oo9N+7
        NM3M/C/wdCdU228hOCNLvN+4Hg==
X-Google-Smtp-Source: ABdhPJxImix0fJRbyysJc7Nx9/ba9NG3PQGtuWbbtO1AUoABEsbpBwa0o41DdoV+qBjNjFIhgFL7lA==
X-Received: by 2002:a17:902:7e08:b0:151:65dd:a2d1 with SMTP id b8-20020a1709027e0800b0015165dda2d1mr7402370plm.66.1646081720781;
        Mon, 28 Feb 2022 12:55:20 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id g5-20020a056a001a0500b004def10341e5sm14210537pfv.22.2022.02.28.12.55.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 12:55:20 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     matoro <matoro_mailinglist_kernel@matoro.tk>
Cc:     Kees Cook <keescook@chromium.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Eric Biederman <ebiederm@xmission.com>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        stable@vger.kernel.org,
        =?UTF-8?q?Magnus=20Gro=C3=9F?= <magnus.gross@rwth-aachen.de>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Anthony Yznaga <anthony.yznaga@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        regressions@lists.linux.dev, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH 5.16 v2] binfmt_elf: Avoid total_mapping_size for ET_EXEC
Date:   Mon, 28 Feb 2022 12:55:18 -0800
Message-Id: <20220228205518.1265798-1-keescook@chromium.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3305; h=from:subject; bh=nRNo15K3hJuAVDiGF83XkTVmsLJsCzBX2BzA2FzRxm0=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBiHTa1ANO98FNtLPs7aIRDGx95+p/oXmw8ZVB+kZiA 8jGqVTCJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYh02tQAKCRCJcvTf3G3AJrcxEA CdH3+/jXtdsBD+3LBqGP8b+KEE/9CwpSUu2UNa3iYKWULsI0FjASo9KlrMoIXHvpJk/ciiZpqeenE4 6afM+9NLoZiUVY5x661OtJozMCC5jjJK3B/JAMB+tK279DQorn9+DmGqe35UmQCUupmw2AjuyxNfCH OoviSdY0NjhqPn5jnI4zfpmj2qdLiMhMcYmAv2sGzGv8pA7KRts3V5mDSi587rmpKghWPkSZENAe6n O1AjtQTxJqUf5QT7Td9rhxEhlaNEW0AL3HOYI27+ZV66EjDf7NyFVt4cFwmqVtSW2ypXgsxDRQAX2k 4JS5ZuHSKnM40nKdWWyg4oO/esdlW3g53RrEkaHS4Tc/jrjbDB3+ZpwWaucIehOIBKm/zWd7FE+fLR KgXsutjfAeLcGrB65/jKeJ4Iv0AXcY0XbEC7tc7nBesY7ZPxqzP+2ULDWb3Jakzl7oD/ZuGtK2MkxZ aK6lbPLb8pg1vKIvQkyS9u6LXfMUkzE/VBvIGlEHdrcUlTZcpURWqU+E8JfM29BoPwbfyos4+3290j B9pi6+etW9ID/dMsnLfKCGCdSVYYpAAgJIWQHRF6El35GzxPHGIFQ9ZvlRIrTPtPcqVO7LOCA/PCER 2Wx2LSHlWBDy8VaB0x5yPa5O6X9BHvWXrxPMMSsH9B+GIfX/vVm2ob9q/7CQ==
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
Here's the v5.16 backport.
---
 fs/binfmt_elf.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index f8c7f26f1fbb..911a9e7044f4 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1135,14 +1135,25 @@ static int load_elf_binary(struct linux_binprm *bprm)
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

