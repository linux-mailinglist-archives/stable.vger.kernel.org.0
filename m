Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B844860A401
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbiJXMFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232286AbiJXMCU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:02:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EEE32495B;
        Mon, 24 Oct 2022 04:49:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D4A6612C9;
        Mon, 24 Oct 2022 11:46:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CACCC433D7;
        Mon, 24 Oct 2022 11:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666611998;
        bh=qRqcUUTGz48ylilhA9AgVfT7w9HHuLUTCmZjZVP6zcQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MVGIaP64f15RCwlyI38wVCDZ8zr0316twfNnAnQ3wk066eDjUsWpU9yp5BiMT2bHX
         hlUYPnvleVQc04w6sl+BlISAllTUXOt54BCJQAG4r+Fu7P4sFvV5TJMLuzQ4b/dxo9
         oWMs46EhtthhvzfR+cebjdr0vbIpTAzcKGFjXphs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Dmitry Vyukov" <dvyukov@google.com>,
        stable <stable@kernel.org>,
        syzbot+23f57c5ae902429285d7@syzkaller.appspotmail.com,
        Tadeusz Struk <tadeusz.struk@linaro.org>,
        PaX Team <pageexec@freemail.hu>
Subject: [PATCH 4.14 030/210] usb: mon: make mmapped memory read only
Date:   Mon, 24 Oct 2022 13:29:07 +0200
Message-Id: <20221024112957.939635963@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
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
@@ -1267,6 +1267,11 @@ static int mon_bin_mmap(struct file *fil
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


