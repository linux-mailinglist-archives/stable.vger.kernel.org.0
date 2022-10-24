Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A35C60A279
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 13:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbiJXLor (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 07:44:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiJXLnq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 07:43:46 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCB40112E;
        Mon, 24 Oct 2022 04:40:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7A4A0CE130F;
        Mon, 24 Oct 2022 11:39:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ACE3C433D6;
        Mon, 24 Oct 2022 11:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666611558;
        bh=RN47miuc4QC2GlUe7aKV+8SGfPx1U5VJI+JT1YJIOLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rLt2/YJmMw60J2SyL/fHPszEKUUSj30fdMH8jc23M88AZPS2gF05jXTl7NcfJTENg
         ij2p+BGWimB5fMp+4lXPhAoZFj8N4iHXkgS7ZB++vYzT1DvapqBfF66gdDMhTznApW
         lippoKp7pPFKzn860HubszMJq9A6d25vGvxisWxw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Dmitry Vyukov" <dvyukov@google.com>,
        stable <stable@kernel.org>,
        syzbot+23f57c5ae902429285d7@syzkaller.appspotmail.com,
        Tadeusz Struk <tadeusz.struk@linaro.org>,
        PaX Team <pageexec@freemail.hu>
Subject: [PATCH 4.9 025/159] usb: mon: make mmapped memory read only
Date:   Mon, 24 Oct 2022 13:29:39 +0200
Message-Id: <20221024112950.324575967@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112949.358278806@linuxfoundation.org>
References: <20221024112949.358278806@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -1265,6 +1265,11 @@ static int mon_bin_mmap(struct file *fil
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


