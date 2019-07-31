Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE1367C55E
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 16:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387953AbfGaOwM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 10:52:12 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:33898 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387945AbfGaOwL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Jul 2019 10:52:11 -0400
Received: by mail-io1-f67.google.com with SMTP id k8so136925312iot.1
        for <stable@vger.kernel.org>; Wed, 31 Jul 2019 07:52:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=EIQbB2zgXphNhV7qrszr5PCCFMAd5NNV0AVDvZDtQIY=;
        b=w5PNd0Oyg/E4hXSbxfvWzwDASd18H5hGr1WPuqn6x9JkzxAwMO5M4PwFnsWEV8u0Mn
         Z+7bXvfVF4WF6st+1vDCd0fdxuP05KjVqvU4UsZ1f8DeVvMT5WloCrS+6FJ45yBs+V2N
         jdFs5+xkoKU13Rv+zCSRJk79Kexzqkilh3GUoyqDfblCZXdr4POkWQoQIoELpP0yfuCt
         VTA7ATIKZ2FUZ2xsPsu4/MNNrCvX1JnpUEOR21x2xd/vz093ubat96QBlN+TSX2AlC7g
         FBOpG294Bi3M5k4pjAexrtU+zQdxs6uVOBMum/As04W+q3X5jWtJjm8RcgusSbFdocxX
         E5+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EIQbB2zgXphNhV7qrszr5PCCFMAd5NNV0AVDvZDtQIY=;
        b=iB/tLQ5ovyw6jDe6JFgWU3Zqcs5dQ7/SxHIe/BFB/bkzePt5SRtDCWvMzbwQv+6wzn
         eImqibOA0dwtgoL2IVWop3Rd1Y1UZ4owZPNkIj747NL2SYl3v5u1z/IrkYau0BYVEz/U
         uUgL+VLueXSl+fVcfM91uMYNTrq89aSgR9Cf2q/tIfrR0G1ARESf69zJu/ULbceAGIuT
         ydSD6e9OUjDLYVBraLU7vcyh1RP//HIM6OuImS63Rl/+EI2cOQvUGECmUMFD4NfNXJxr
         rTjffsH+q0DLqq+oY+XSEuaGyXC1fndnFtaOAKvr2HtuvO0o/nQEmUeiv/UlZYBH8zST
         G7VQ==
X-Gm-Message-State: APjAAAWOFqWGT34F6ExWoqacIfou0CHwp2r2FBp21zQCBhU5oglTYpAh
        dJAwxrBFw1ARCAVRAX5kDlY=
X-Google-Smtp-Source: APXvYqzGTKAm/77GYVRlS+dpkqPeW8l/Pd4ZwGUtpE7m7NKS5bwuzo9CN+a6M86+KtzKEnQ59JgzPA==
X-Received: by 2002:a6b:6b14:: with SMTP id g20mr83413865ioc.28.1564584731100;
        Wed, 31 Jul 2019 07:52:11 -0700 (PDT)
Received: from [192.168.1.57] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id j14sm57989996ioa.78.2019.07.31.07.52.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 07:52:10 -0700 (PDT)
Subject: Re: [PATCH v2] nbd: replace kill_bdev() with __invalidate_device()
 again
To:     SunKe <sunke32@huawei.com>, josef@toxicpanda.com,
        linux-block@vger.kernel.org, nbd@other.debian.org,
        linux-kernel@vger.kernel.org, kamatam@amazon.com,
        manoj.br@gmail.com, stable@vger.kernel.org, dwmw@amazon.com
References: <1564575190-132357-1-git-send-email-sunke32@huawei.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2b77d06d-3610-b2f7-d95f-8925b6bd49bf@kernel.dk>
Date:   Wed, 31 Jul 2019 08:52:09 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1564575190-132357-1-git-send-email-sunke32@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/31/19 6:13 AM, SunKe wrote:
> From: Munehisa Kamata <kamatam@amazon.com>
> 
> Commit abbbdf12497d ("replace kill_bdev() with __invalidate_device()")
> once did this, but 29eaadc03649 ("nbd: stop using the bdev everywhere")
> resurrected kill_bdev() and it has been there since then. So buffer_head
> mappings still get killed on a server disconnection, and we can still
> hit the BUG_ON on a filesystem on the top of the nbd device.
> 
>    EXT4-fs (nbd0): mounted filesystem with ordered data mode. Opts: (null)
>    block nbd0: Receive control failed (result -32)
>    block nbd0: shutting down sockets
>    print_req_error: I/O error, dev nbd0, sector 66264 flags 3000
>    EXT4-fs warning (device nbd0): htree_dirblock_to_tree:979: inode #2: lblock 0: comm ls: error -5 reading directory block
>    print_req_error: I/O error, dev nbd0, sector 2264 flags 3000
>    EXT4-fs error (device nbd0): __ext4_get_inode_loc:4690: inode #2: block 283: comm ls: unable to read itable block
>    EXT4-fs error (device nbd0) in ext4_reserve_inode_write:5894: IO failure
>    ------------[ cut here ]------------
>    kernel BUG at fs/buffer.c:3057!
>    invalid opcode: 0000 [#1] SMP PTI
>    CPU: 7 PID: 40045 Comm: jbd2/nbd0-8 Not tainted 5.1.0-rc3+ #4
>    Hardware name: Amazon EC2 m5.12xlarge/, BIOS 1.0 10/16/2017
>    RIP: 0010:submit_bh_wbc+0x18b/0x190
>    ...
>    Call Trace:
>     jbd2_write_superblock+0xf1/0x230 [jbd2]
>     ? account_entity_enqueue+0xc5/0xf0
>     jbd2_journal_update_sb_log_tail+0x94/0xe0 [jbd2]
>     jbd2_journal_commit_transaction+0x12f/0x1d20 [jbd2]
>     ? __switch_to_asm+0x40/0x70
>     ...
>     ? lock_timer_base+0x67/0x80
>     kjournald2+0x121/0x360 [jbd2]
>     ? remove_wait_queue+0x60/0x60
>     kthread+0xf8/0x130
>     ? commit_timeout+0x10/0x10 [jbd2]
>     ? kthread_bind+0x10/0x10
>     ret_from_fork+0x35/0x40
> 
> With __invalidate_device(), I no longer hit the BUG_ON with sync or
> unmount on the disconnected device.

Applied, thanks.

-- 
Jens Axboe

