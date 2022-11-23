Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5BC3636868
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 19:16:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239585AbiKWSNv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 13:13:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240080AbiKWSN3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 13:13:29 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9450F15804
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 10:08:24 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id p5-20020a170902e74500b001884ba979f8so14273709plf.17
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 10:08:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ZhRYpgjyXSj58WhO81SjAEi8hSt+BCz5HFDcwIe8pM8=;
        b=eemCHDnPT999d32SWZB6wMX6suDtePfunnKNAKvzoIn3dNciBQ3Ljfi3yTquKoy4zi
         pcrK20E0xXlpAUqIBXCsUy2HESlz6t7owcjQppn946VULCvKTSBqzveGqfypNqgpNaj6
         iXJJ06APrWP4InCRCTIf8kHE2/VDWVF+MFQq0ndYTrBiNiLs+FjRyPNEHDsG5r2ooIeI
         CsiIDq8CprGQJ677tUo/JkB1kA7RBtQGesqHsnudWvHEOOVStEsMkrcTe8XMdiBbDUUr
         Wvup2PTocsoLNg5b9xVg9/tSx6vcK13d6i/NYpDI5r7NH1ZyRGnIfOvOepA7ESo1xmo0
         LQrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZhRYpgjyXSj58WhO81SjAEi8hSt+BCz5HFDcwIe8pM8=;
        b=pqbPmUQsHByuQsF6X3BRSbV+B8g0jTAjEihrVYhqqpjVwcicDXcRHqBneVBPExw5ty
         4ibAd5zjx4tqJxq5f24QSFBsgRupK09x5fi4qe5OJDYBVVnFGTbi6r4OGs4SnTOgx4mk
         E8/l4WANb9UNrwRbYzaETzmV5HF+FjmKXI4xQTuLsPbweUPpXB4PUuZlAxb8QUGEFvaa
         v8PMIkIZFZZr4aUPtrHOZ5Ngp3OHFYUFVEonoZKRQwoQZmFXQ3Q/9J5Xm0QvfMn2QVxB
         tueoX8HjuSQDGg709qf0RNaUJJ2iAqa5i5xMnAJQlWuyuUGpVA0LSMVtjQTJjivCc1+5
         C27Q==
X-Gm-Message-State: ANoB5pm6Zg5SeoUiFU103lX/WLqXZeXEtuIJ+W73vfmqZoZIohVB829j
        3rnUZXWgZb2Zpv/ppqL3OxhZgedZVsfNuA==
X-Google-Smtp-Source: AA0mqf41K5vmq3rhuByfU4W/AtqvhvmmSD+ilGqHI9sbx2YLgKgUB/+/zYf/bq4bL7Zu31IA6ToFXW/4h0yGow==
X-Received: from xllamas.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5070])
 (user=cmllamas job=sendgmr) by 2002:aa7:83d3:0:b0:56e:8477:1add with SMTP id
 j19-20020aa783d3000000b0056e84771addmr19165796pfn.13.1669226904028; Wed, 23
 Nov 2022 10:08:24 -0800 (PST)
Date:   Wed, 23 Nov 2022 18:08:09 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221123180809.1501779-1-cmllamas@google.com>
Subject: [PATCH 6.0] binder: validate alloc->mm in ->mmap() handler
From:   Carlos Llamas <cmllamas@google.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "=?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?=" <arve@android.com>,
        Todd Kjos <tkjos@android.com>,
        Martijn Coenen <maco@android.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Christian Brauner <brauner@kernel.org>,
        Carlos Llamas <cmllamas@google.com>,
        Suren Baghdasaryan <surenb@google.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc:     linux-kernel@vger.kernel.org, kernel-team@android.com,
        Jann Horn <jannh@google.com>, stable@vger.kernel.org,
        Todd Kjos <tkjos@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 3ce00bb7e91cf57d723905371507af57182c37ef upstream.

Since commit 1da52815d5f1 ("binder: fix alloc->vma_vm_mm null-ptr
dereference") binder caches a pointer to the current->mm during open().
This fixes a null-ptr dereference reported by syzkaller. Unfortunately,
it also opens the door for a process to update its mm after the open(),
(e.g. via execve) making the cached alloc->mm pointer invalid.

Things get worse when the process continues to mmap() a vma. From this
point forward, binder will attempt to find this vma using an obsolete
alloc->mm reference. Such as in binder_update_page_range(), where the
wrong vma is obtained via vma_lookup(), yet binder proceeds to happily
insert new pages into it.

To avoid this issue fail the ->mmap() callback if we detect a mismatch
between the vma->vm_mm and the original alloc->mm pointer. This prevents
alloc->vm_addr from getting set, so that any subsequent vma_lookup()
calls fail as expected.

Fixes: 1da52815d5f1 ("binder: fix alloc->vma_vm_mm null-ptr dereference")
Reported-by: Jann Horn <jannh@google.com>
Cc: <stable@vger.kernel.org> # 5.15+
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Acked-by: Todd Kjos <tkjos@google.com>
Link: https://lore.kernel.org/r/20221104231235.348958-1-cmllamas@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[cmllamas: renamed alloc->mm since missing e66b77e50522]
Signed-off-by: Carlos Llamas <cmllamas@google.com>
---
 drivers/android/binder_alloc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.c
index 9b1778c00610..64999777e0bf 100644
--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -760,6 +760,12 @@ int binder_alloc_mmap_handler(struct binder_alloc *alloc,
 	const char *failure_string;
 	struct binder_buffer *buffer;
 
+	if (unlikely(vma->vm_mm != alloc->vma_vm_mm)) {
+		ret = -EINVAL;
+		failure_string = "invalid vma->vm_mm";
+		goto err_invalid_mm;
+	}
+
 	mutex_lock(&binder_alloc_mmap_lock);
 	if (alloc->buffer_size) {
 		ret = -EBUSY;
@@ -806,6 +812,7 @@ int binder_alloc_mmap_handler(struct binder_alloc *alloc,
 	alloc->buffer_size = 0;
 err_already_mapped:
 	mutex_unlock(&binder_alloc_mmap_lock);
+err_invalid_mm:
 	binder_alloc_debug(BINDER_DEBUG_USER_ERROR,
 			   "%s: %d %lx-%lx %s failed %d\n", __func__,
 			   alloc->pid, vma->vm_start, vma->vm_end,
-- 
2.38.1.584.g0f3c55d4c2-goog

