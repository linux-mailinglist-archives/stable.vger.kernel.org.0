Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91F1833C43D
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 18:33:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234432AbhCORcu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 13:32:50 -0400
Received: from mail-pj1-f45.google.com ([209.85.216.45]:42908 "EHLO
        mail-pj1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234144AbhCORcX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 13:32:23 -0400
Received: by mail-pj1-f45.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so15181336pjv.1
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 10:32:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TKAZ8aAZDyNLoSV/Ynuhjm6MhzlMkhJJwED9weuVm/8=;
        b=Ne1Ai5yisiAKzeQfBcDxRuYFs9pZqE5t7+x1u/RN0QHdPeI9OTJg05SVSakLuyVYi0
         9c935UDzTO084u22hZaLFdH/BpKN95283W+neyPavoXv2YVmHk6sC3GEDfD9E50NOjSo
         0CIh1rQ07S3IB2A5UFazR/NCzHQg+CB8t9KWyyplGaoFxMuvAxX1UXoJ15y4/o3Pr8B9
         RAo+aAm5oggx354ugoVBjUOP0IRG3poWNHTtO+s72Yg0X72AtQ5rZe3TR4ro1OsIOzSD
         YcDvQ0uDly+aqcKIS1nT638Tm8mIy9cdjboRsI2dHejj6Ak+XBkssBTxk90wwLHinAkz
         bEHw==
X-Gm-Message-State: AOAM531vISjeU8FwCK3fJP6Dx3BTZhpeLxHZy3xfTtyZrPA5PoiyeSTv
        91S3S8Dqf4YpcWXpQz1cFzQAiSpkBHU=
X-Google-Smtp-Source: ABdhPJxRrEXRYxa1r8W5GiMkR+bYXMuuCfa+sqZKucJE2/kUOBNqt0m/wLzdqhVJgKxtYDCOoDdeAA==
X-Received: by 2002:a17:90a:bb02:: with SMTP id u2mr139681pjr.175.1615829542107;
        Mon, 15 Mar 2021 10:32:22 -0700 (PDT)
Received: from ?IPv6:2601:647:4802:9070:4faf:1598:b15b:7e86? ([2601:647:4802:9070:4faf:1598:b15b:7e86])
        by smtp.gmail.com with ESMTPSA id b9sm13593432pgn.42.2021.03.15.10.32.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Mar 2021 10:32:21 -0700 (PDT)
Subject: Re: [PATCH] nvmet-tcp: finish receiving before send back response if
 nvmet_req_init() failed.
To:     Hou Pu <houpu.main@gmail.com>, hch@lst.de,
        chaitanya.kulkarni@wdc.com
Cc:     linux-nvme@lists.infradead.org, stable@vger.kernel.org
References: <20210315100928.87596-1-houpu.main@gmail.com>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <3a5bd33b-32c2-24c4-3880-883e33bfe282@grimberg.me>
Date:   Mon, 15 Mar 2021 10:32:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210315100928.87596-1-houpu.main@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


> When receiving a pdu, if nvmet_req_init() failed (for example a ns is
> not found), the queue->rcv_state could be moved to NVMET_TCP_RECV_DATA
> by nvmet_tcp_handle_req_failure(). We should return 0 here to continue
> to consume the possible remaining inline write out data in
> nvmet_tcp_try_recv_one(). Otherwise, the response to this request would
> be sent and iov would be freed. Next time in nvmet_tcp_try_recv_one(),
> we would go to the receiving data phase and the iov is used again.
> 
> A panic happend with a 5.4 kernel installed as below:

Can you please try to reproduce this with upstream? and with latest
stable 5.4? there have been some fixes in this area. We may need
to help backported patches to stable if needed.

> 
> [  169.906573] nvmet_tcp: failed cmd 0000000027717054 id 106 opcode 1, data_len: 1024
> [  169.908131] general protection fault: 0000 [#1] SMP NOPTI
> [  169.908884] CPU: 0 PID: 122 Comm: kworker/0:1H Kdump: loaded Tainted: G           OE [...]
> [  169.910328] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), [...]
> [  169.911943] Workqueue: nvmet_tcp_wq nvmet_tcp_io_work [nvmet_tcp]
> [  169.912815] RIP: 0010:__memcpy+0x12/0x20
> [  169.913393] Code: e3 97 ff 0f 31 48 c1 e2 20 48 09 d0 48 31 c3 e9 79 ff [...]
> [  169.915819] RSP: 0018:ffffc9000026bbc8 EFLAGS: 00010246
> [  169.916547] RAX: ebf4958c4fda661b RBX: ffff888119613096 RCX: 0000000000000080
> [  169.917511] RDX: 0000000000000000 RSI: ffff888119613096 RDI: ebf4958c4fda661b
> [  169.918469] RBP: 0000000000000400 R08: 0000000000000000 R09: 0000000000000400
> [  169.919435] R10: 0000000000000000 R11: 000000000000003e R12: ffff888114244068
> [  169.920398] R13: 0000000000000400 R14: 0000000000000400 R15: ffff888118c37cb0
> [  169.921378] FS:  0000000000000000(0000) GS:ffff88813fc00000(0000) knlGS:0000000000000000
> [  169.922473] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  169.923269] CR2: 0000555eb19943e0 CR3: 00000001186fc000 CR4: 00000000000006f0
> [  169.924245] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  169.925214] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  169.926184] Call Trace:
> [  169.926569]  _copy_to_iter+0x26f/0x440
> [  169.927112]  ? __check_object_size+0x70/0x230
> [  169.927724]  __skb_datagram_iter+0x15a/0x290
> [  169.928327]  ? skb_kill_datagram+0x60/0x60
> [  169.928921]  skb_copy_datagram_iter+0x3b/0x90
> [  169.929545]  tcp_recvmsg+0x759/0xc50
> [  169.930081]  ? ksoftirqd_running+0x2c/0x30
> [  169.930668]  ? free_unref_page_commit+0x95/0x120
> [  169.931331]  inet_recvmsg+0x55/0xc0
> [  169.931834]  nvmet_tcp_io_work+0x685/0xb23 [nvmet_tcp]
> [  169.932549]  process_one_work+0x18c/0x370
> [  169.933118]  worker_thread+0x4f/0x3b0
> [  169.933654]  ? rescuer_thread+0x340/0x340
> [  169.934223]  kthread+0xf6/0x130
> [  169.934682]  ? kthread_create_worker_on_cpu+0x70/0x70
> [  169.935393]  ret_from_fork+0x1f/0x30
> 
> Cc: <stable@vger.kernel.org> # 5.0
> Signed-off-by: Hou Pu <houpu.main@gmail.com>
> ---
>   drivers/nvme/target/tcp.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
> index 8b0485ada315..da1c667e21ba 100644
> --- a/drivers/nvme/target/tcp.c
> +++ b/drivers/nvme/target/tcp.c
> @@ -961,7 +961,7 @@ static int nvmet_tcp_done_recv_pdu(struct nvmet_tcp_queue *queue)
>   			le32_to_cpu(req->cmd->common.dptr.sgl.length));
>   
>   		nvmet_tcp_handle_req_failure(queue, queue->cmd, req);
> -		return -EAGAIN;
> +		return 0;

What guarantees that you will actually have more to consume?
