Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 329665F995A
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 09:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231909AbiJJHLY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 03:11:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231861AbiJJHKr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 03:10:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C0E25E561;
        Mon, 10 Oct 2022 00:07:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E24E360E8D;
        Mon, 10 Oct 2022 07:06:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3481C433C1;
        Mon, 10 Oct 2022 07:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665385597;
        bh=xxDHkhWXn9LWoUKnTOuFYR63Zphxmul0hUMh47XisPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W8fhaA6jRT6jXhXu4s0jWe9JkJm12b/Xay8c5MxggkgRo3WmBTfV8h5LP1berUzQH
         D5KeCZvBZHQALq7+oywxmIPRVcfoeoBJ+bRY4q3sH8dxnQW2qddX4Vb9QOCpOype2b
         0sel6qyRCQBQXwaCSg5TI8YpxSORhSQVIu71qGxM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Dmitry Vyukov" <dvyukov@google.com>,
        stable <stable@kernel.org>,
        syzbot+23f57c5ae902429285d7@syzkaller.appspotmail.com,
        Tadeusz Struk <tadeusz.struk@linaro.org>,
        PaX Team <pageexec@freemail.hu>
Subject: [PATCH 5.19 38/48] usb: mon: make mmapped memory read only
Date:   Mon, 10 Oct 2022 09:05:36 +0200
Message-Id: <20221010070334.682322724@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221010070333.676316214@linuxfoundation.org>
References: <20221010070333.676316214@linuxfoundation.org>
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

From: Tadeusz Struk <tadeusz.struk@linaro.org>

commit a659daf63d16aa883be42f3f34ff84235c302198 upstream.

Syzbot found an issue in usbmon module, where the user space client can
corrupt the monitor's internal memory, causing the usbmon module to
crash the kernel with segfault, UAF, etc.

The reproducer mmaps the /dev/usbmon memory to user space, and
overwrites it with arbitrary data, which causes all kinds of issues.

Return an -EPERM error from mon_bin_mmap() if the flag VM_WRTIE is set.
Also clear VM_MAYWRITE to make it impossible to change it to writable
later.

Cc: "Dmitry Vyukov" <dvyukov@google.com>
Cc: stable <stable@kernel.org>
Fixes: 6f23ee1fefdc ("USB: add binary API to usbmon")
Suggested-by: PaX Team <pageexec@freemail.hu>	# for the VM_MAYRITE portion
Link: https://syzkaller.appspot.com/bug?id=2eb1f35d6525fa4a74d75b4244971e5b1411c95a
Reported-by: syzbot+23f57c5ae902429285d7@syzkaller.appspotmail.com
Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
Link: https://lore.kernel.org/r/20220919215957.205681-1-tadeusz.struk@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/mon/mon_bin.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/mon/mon_bin.c
+++ b/drivers/usb/mon/mon_bin.c
@@ -1268,6 +1268,11 @@ static int mon_bin_mmap(struct file *fil
 {
 	/* don't do anything here: "fault" will set up page table entries */
 	vma->vm_ops = &mon_bin_vm_ops;
+
+	if (vma->vm_flags & VM_WRITE)
+		return -EPERM;
+
+	vma->vm_flags &= ~VM_MAYWRITE;
 	vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
 	vma->vm_private_data = filp->private_data;
 	mon_bin_vma_open(vma);


