Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02F684D0C60
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 01:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241839AbiCHAD3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 19:03:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbiCHAD2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 19:03:28 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 008ABE4E
        for <stable@vger.kernel.org>; Mon,  7 Mar 2022 16:02:29 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id 132so14909108pga.5
        for <stable@vger.kernel.org>; Mon, 07 Mar 2022 16:02:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EuPyOGfEKvdmmkdx2+eXzCMxoHYA5c2y/gEEklhVQ8Y=;
        b=w86scsa7q9Xnl0bLj+lNlCk+0DfSqXcgC1XjYdV9JlUD5r33NHVtD/k4Z3i68INFzb
         3PsYjEj7tYILf5c0b0NFC22yaKAvf8VY5Mn0adjjgPE2VSVaktycyrLB7k0WqcRpBjL2
         d4/rmVfelv7b6GNGFQ6MW40e/XSKfqdBGivBVAshyfXPioW6DxsdskGve3t6y4jaq8X7
         LKc+Y1q79NjfAHag8OgcMDBTGxuT2vMUJtn77JbPERpSkhZty1lV1kD34KOYMBUWQKN0
         yzW3tlrmLdcLAwID/vZOCie+5VIEqZ/4N1tPITIlAaHk4qKbpKAAga7Q8NDhjzb7IS2F
         Hxgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EuPyOGfEKvdmmkdx2+eXzCMxoHYA5c2y/gEEklhVQ8Y=;
        b=HYMQhF+HtQE6kMyoASGn0TFnjUsEFyJMZpm8RKDLKKVdacc+/t2yK6pA8EhK1u3us8
         s9mQmq75I8z6cEagbuL6mBl6osiW9NDaqeCXQbbQgnHSeGuwRynSi3/l3YkEvbZwtoHS
         PtI+7NuoBqNm1vofgJdejoiqX8LOE/to8oVawAZoXmQLxbqW0H/VT+nbfNTyLt8GCDnP
         EwvvlCDxXvZAriZ3iN06QC4/x5cm9famZXRMVwsjeMpuwNAaLPrq7iN44xqI1RECO/gL
         CfgRKYa/hTjEmqfoVkoMrDg7JoxinELSkihW/rHEIE98+CRKyOyNxFRl8efmscflwvrF
         ZF1Q==
X-Gm-Message-State: AOAM530HachUHNNLkmX6Ro+uf0iWLKUHjriDbQT8wN4pGVk4tVSV8+DK
        8XE8nsHxkqnwEmQu8zn55ZnujA==
X-Google-Smtp-Source: ABdhPJxykFoZuKmjviuSn9DcWv3yRmnj5s2LUlovrzLZDhDLZZjG8LFtTII2ivb0MrPwguN6v7pB7w==
X-Received: by 2002:a63:1760:0:b0:374:6621:9236 with SMTP id 32-20020a631760000000b0037466219236mr12019521pgx.7.1646697749418;
        Mon, 07 Mar 2022 16:02:29 -0800 (PST)
Received: from localhost.localdomain ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id 23-20020a17090a0d5700b001bc3c650e01sm1383704pju.1.2022.03.07.16.02.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 16:02:29 -0800 (PST)
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
To:     davem@davemloft.net
Cc:     Tadeusz Struk <tadeusz.struk@linaro.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        syzbot+e223cf47ec8ae183f2a0@syzkaller.appspotmail.com
Subject: [PATCH] net: ipv6: fix invalid alloclen in __ip6_append_data
Date:   Mon,  7 Mar 2022 16:01:46 -0800
Message-Id: <20220308000146.534935-1-tadeusz.struk@linaro.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Syzbot found a kernel bug in the ipv6 stack:
LINK: https://syzkaller.appspot.com/bug?id=205d6f11d72329ab8d62a610c44c5e7e25415580

The reproducer triggers it by sending an invalid message via sendmmsg() call,
which triggers skb_over_panic, and crashes the kernel:

skbuff: skb_over_panic: text:ffffffff84647fb4 len:65575 put:65575
head:ffff888109ff0000 data:ffff888109ff0088 tail:0x100af end:0xfec0
dev:<NULL>

------------[ cut here ]------------
kernel BUG at net/core/skbuff.c:113!
PREEMPT SMP KASAN
CPU: 1 PID: 1818 Comm: repro Not tainted 5.17.0-rc7-dirty #9
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1.fc35
RIP: 0010:skb_panic+0x173/0x175
RSP: 0018:ffffc900015bf3b8 EFLAGS: 00010282
RAX: 0000000000000090 RBX: ffff88810e848c80 RCX: 0000000000000000
RDX: ffff88810fd84300 RSI: ffffffff814fa5ef RDI: fffff520002b7e69
RBP: ffffc900015bf420 R08: 0000000000000090 R09: 0000000000000000
R10: ffffffff814f55f4 R11: 203a666675626b73 R12: ffffffff855bff80
R13: ffffffff84647fb4 R14: 0000000000010027 R15: ffffffff855bf420
FS:  0000000000c8b3c0(0000) GS:ffff88811b100000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000040 CR3: 0000000106b68000 CR4: 0000000000150ea0
Call Trace:
 <TASK>
 skb_put.cold+0x23/0x23
 __ip6_append_data.isra.0.cold+0x396/0xe3a
 ip6_append_data+0x1e5/0x320
 rawv6_sendmsg.cold+0x1618/0x2ba9
 inet_sendmsg+0x9e/0xe0
 sock_sendmsg+0xd7/0x130
 ____sys_sendmsg+0x381/0x8a0
 ___sys_sendmsg+0x100/0x170
 __sys_sendmmsg+0x26c/0x3b7
 __x64_sys_sendmmsg+0xb2/0xbd
 do_syscall_64+0x35/0xb0
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The reproducer can be found here:
LINK: https://syzkaller.appspot.com/text?tag=ReproC&x=1648c83fb00000
This can be fixed by increasing the alloclen in case it is smaller than
fraglen in __ip6_append_data().

Cc: David S. Miller <davem@davemloft.net>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: David Ahern <dsahern@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: netdev@vger.kernel.org
Cc: bpf@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org

Reported-by: syzbot+e223cf47ec8ae183f2a0@syzkaller.appspotmail.com
Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
---
 net/ipv6/ip6_output.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 4788f6b37053..622345af323e 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1629,6 +1629,13 @@ static int __ip6_append_data(struct sock *sk,
 				err = -EINVAL;
 				goto error;
 			}
+			if (unlikely(alloclen < fraglen)) {
+				if (printk_ratelimit())
+					pr_warn("%s: wrong alloclen: %d, fraglen: %d",
+						__func__, alloclen, fraglen);
+				alloclen = fraglen;
+			}
+
 			if (transhdrlen) {
 				skb = sock_alloc_send_skb(sk, alloclen,
 						(flags & MSG_DONTWAIT), &err);
-- 
2.35.1
