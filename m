Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7C05F9911
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 09:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbiJJHGM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 03:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231459AbiJJHFc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 03:05:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27111B4B0;
        Mon, 10 Oct 2022 00:04:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBD0D60AB4;
        Mon, 10 Oct 2022 07:04:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDB08C433D6;
        Mon, 10 Oct 2022 07:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665385485;
        bh=xxDHkhWXn9LWoUKnTOuFYR63Zphxmul0hUMh47XisPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uFYS5ls7MO0lzpXIUvMDVcHPV77mAGMNsXxqK3eItYSJJMRf0zXTiFHwTPxMkmAJb
         Gs9N7M1BRm/TLiOggSRfWaeF0eG64IeTHpexcTI9W5lhbLie+3FB9R/0s5TB43eonA
         OZuEDruy2qhNooBVo3kU2zfNsRySg9e2tVyGMRdQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Dmitry Vyukov" <dvyukov@google.com>,
        stable <stable@kernel.org>,
        syzbot+23f57c5ae902429285d7@syzkaller.appspotmail.com,
        Tadeusz Struk <tadeusz.struk@linaro.org>,
        PaX Team <pageexec@freemail.hu>
Subject: [PATCH 6.0 09/17] usb: mon: make mmapped memory read only
Date:   Mon, 10 Oct 2022 09:04:32 +0200
Message-Id: <20221010070330.478301738@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221010070330.159911806@linuxfoundation.org>
References: <20221010070330.159911806@linuxfoundation.org>
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


