Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36BDD4D3CB
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 18:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbfFTQa4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 12:30:56 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:32943 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbfFTQa4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jun 2019 12:30:56 -0400
Received: by mail-pg1-f193.google.com with SMTP id m4so1252059pgk.0
        for <stable@vger.kernel.org>; Thu, 20 Jun 2019 09:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=SYmQcOhS9WgXdk0pzaHqd/oVUIIoK5M46QRCry6cRJw=;
        b=MrC+WANEAxnII4IF/0rirrWnsNRSsbkt91czmFzB0i++CGwPyYLL+Zm7irtrOUxrLC
         617bcBUgdCPeCglB/VODiHn5F7wcOogMha5K08hPdFIgsDMclTFgd3/oCYw0ILzV9yq3
         KO5xfhAmzjsfZ23lJpHtbxq+0vLxFrgSS1++Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=SYmQcOhS9WgXdk0pzaHqd/oVUIIoK5M46QRCry6cRJw=;
        b=lOBvS0QJG2AXS/Q5Xav6ArwczQcg+TcIOsQwjoCz38sv5OPiLAMEfqKjg41C7ambjO
         Gv6Z1IJYzMog5KO+wbbgyBRmFrRU2KOmLJBtuxsQMsfrNIzoxMdrKVhCbREPs9Ey5yXV
         vWSvPjgLEescquh3yGQja9EoKeqJpLjT9kI4JcG4/yWWOOhW6H8KKV0smnSvwnQyEvAx
         KkGyGgsSHDe0dT5fmJtJz7myEtYGZaRINpLF/JWXGdyZHbwGiRK/ucJuNKsEJn1cARpI
         JclBRmsRpOjvYugVr3g1dNuCcdI3oicXL8skXsZCofVrMrZTx9wdCIHIF/xaggW8RkbP
         XTLg==
X-Gm-Message-State: APjAAAXCmFkL7PGxFFBg372yxAyBMl0n+aY5TLMxR35fiV4CgGEuM+4N
        UrnQ2M87xj3rU3vjE/0rsnoU+a51I9s=
X-Google-Smtp-Source: APXvYqzami6nH+XFYEKnYr0vyehD7AZgweHIqxE4wvYGQd/ibEXGs0YI3hSyFBq2dExkUz+LWjCOWg==
X-Received: by 2002:aa7:9092:: with SMTP id i18mr16332514pfa.101.1561048255195;
        Thu, 20 Jun 2019 09:30:55 -0700 (PDT)
Received: from google.com ([2620:15c:202:201:49ea:b78f:4f04:4d25])
        by smtp.googlemail.com with ESMTPSA id s9sm231030pjp.7.2019.06.20.09.30.53
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 20 Jun 2019 09:30:54 -0700 (PDT)
Date:   Thu, 20 Jun 2019 09:30:49 -0700
From:   Zubin Mithra <zsm@chromium.org>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, groeck@chromium.org,
        alexander.lochmann@tu-dortmund.de, viro@zeniv.linux.org.uk
Subject: f69e749a4935 ("Abort file_remove_privs() for non-reg. files")
Message-ID: <20190620163048.GA189243@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

Syzkaller has triggered a kernel WARNING when fuzzing a 4.14 kernel with the following stacktrace.
Call Trace:
 __dump_stack lib/dump_stack.c:17 [inline]
 dump_stack+0x114/0x1cf lib/dump_stack.c:53
 panic+0x1bb/0x3a0 kernel/panic.c:181
 __warn.cold.9+0x149/0x186 kernel/panic.c:542
 report_bug+0x1f7/0x272 lib/bug.c:186
 fixup_bug arch/x86/kernel/traps.c:177 [inline]
 do_error_trap+0x1c1/0x430 arch/x86/kernel/traps.c:295
 do_invalid_op+0x20/0x30 arch/x86/kernel/traps.c:314
 invalid_op+0x1b/0x40 arch/x86/entry/entry_64.S:944
 __remove_privs fs/inode.c:1805 [inline]
 file_remove_privs+0x291/0x4c0 fs/inode.c:1827
 __generic_file_write_iter+0x166/0x5b0 mm/filemap.c:3096
 blkdev_write_iter+0x1f5/0x3b0 fs/block_dev.c:1905
 call_write_iter include/linux/fs.h:1782 [inline]
 new_sync_write fs/read_write.c:471 [inline]
 __vfs_write+0x53f/0x7d0 fs/read_write.c:484
 vfs_write+0x18c/0x500 fs/read_write.c:546
 SYSC_write fs/read_write.c:593 [inline]
 SyS_write+0xf4/0x230 fs/read_write.c:585
 do_syscall_32_irqs_on arch/x86/entry/common.c:340 [inline]
 do_fast_syscall_32+0x3c1/0xbf1 arch/x86/entry/common.c:403
 entry_SYSENTER_compat+0x84/0x96 arch/x86/entry/entry_64_compat.S:139


Could the following patch be applied to 5.0.y, 4.19.y, 4.14.y? The commit is present in 5.1.y.
* f69e749a4935 ("Abort file_remove_privs() for non-reg. files")


Tests run:
* Syzkaller reproducer
* Chrome OS tryjobs


Thanks,
- Zubin
