Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 257669B7E5
	for <lists+stable@lfdr.de>; Fri, 23 Aug 2019 22:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392519AbfHWUwk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Aug 2019 16:52:40 -0400
Received: from ma1-aaemail-dr-lapp03.apple.com ([17.171.2.72]:50576 "EHLO
        ma1-aaemail-dr-lapp03.apple.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388903AbfHWUwk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Aug 2019 16:52:40 -0400
X-Greylist: delayed 14139 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Aug 2019 16:52:38 EDT
Received: from pps.filterd (ma1-aaemail-dr-lapp03.apple.com [127.0.0.1])
        by ma1-aaemail-dr-lapp03.apple.com (8.16.0.27/8.16.0.27) with SMTP id x7NGl67H021488;
        Fri, 23 Aug 2019 09:56:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=sender : date : from :
 to : cc : subject : message-id : references : mime-version : content-type
 : in-reply-to; s=20180706;
 bh=/tjc82cNm90GSgZrWQRnXfPRIfOr22HZzEQE7A6BHWs=;
 b=cEp+bzrYcEmXIIz5n0VSZM/fr4+A7VmKYd8L6fMUb4IjP5VSn+svZ8+YYkWg4QdLYAlU
 QfT8MkQYOmkYx7nvMdWIo/GV+4XZLExSY3jxJ1TPRu1eF0nd4lrWy0QYp8pY9PUFKwmS
 C+7ys/hUwjj4jazJt/+clOopLbGHCLPqmclQ//b8smDoJ+IHOXKAvRvdXnSPRY8Hgf7o
 dPB8w684YlZ1EqVzGW4feOUrc0uXmtpzBKhAc2JAp0jPyv8F98TQ0V91m7XGMhAThfhn
 rwWEZyAQJ9jtLdG3HCfY89ZQqIDz8KM1/3tIBM6cJiolU3CrjfWqZ+TZfOD+UHtjOVYd Vw== 
Received: from mr2-mtap-s02.rno.apple.com (mr2-mtap-s02.rno.apple.com [17.179.226.134])
        by ma1-aaemail-dr-lapp03.apple.com with ESMTP id 2uegk9smu4-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Fri, 23 Aug 2019 09:56:49 -0700
Received: from nwk-mmpp-sz09.apple.com
 (nwk-mmpp-sz09.apple.com [17.128.115.80]) by mr2-mtap-s02.rno.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) with ESMTPS id <0PWP007ZN8EOLK30@mr2-mtap-s02.rno.apple.com>; Fri,
 23 Aug 2019 09:56:48 -0700 (PDT)
Received: from process_milters-daemon.nwk-mmpp-sz09.apple.com by
 nwk-mmpp-sz09.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) id <0PWP001008CD5U00@nwk-mmpp-sz09.apple.com>; Fri,
 23 Aug 2019 09:56:48 -0700 (PDT)
X-Va-A: 
X-Va-T-CD: 8dfacd7d860744253dab6e7e01223206
X-Va-E-CD: 6346fcbc6eba018940f1068423a83824
X-Va-R-CD: d3cd177ea40623cbe9364e7db0a8edec
X-Va-CD: 0
X-Va-ID: 5d8bf003-5b91-4c02-a5b3-106ab8d5bf09
X-V-A:  
X-V-T-CD: 8dfacd7d860744253dab6e7e01223206
X-V-E-CD: 6346fcbc6eba018940f1068423a83824
X-V-R-CD: d3cd177ea40623cbe9364e7db0a8edec
X-V-CD: 0
X-V-ID: 702b5730-8d3e-48b1-9c52-0346125a5260
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,,
 definitions=2019-08-23_07:,, signatures=0
Received: from localhost ([17.192.155.217]) by nwk-mmpp-sz09.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) with ESMTPSA id <0PWP003LP8ENRF40@nwk-mmpp-sz09.apple.com>; Fri,
 23 Aug 2019 09:56:48 -0700 (PDT)
Date:   Fri, 23 Aug 2019 09:56:47 -0700
From:   Christoph Paasch <cpaasch@apple.com>
To:     Tim Froidcoeur <tim.froidcoeur@tessares.net>
Cc:     matthieu.baerts@tessares.net, aprout@ll.mit.edu,
        davem@davemloft.net, edumazet@google.com,
        gregkh@linuxfoundation.org, jonathan.lemon@gmail.com,
        jtl@netflix.com, linux-kernel@vger.kernel.org, mkubecek@suse.cz,
        ncardwell@google.com, sashal@kernel.org, stable@vger.kernel.org,
        ycheng@google.com
Subject: Re: [PATCH] tcp: fix tcp_rtx_queue_tail in case of empty retransmit
 queue
Message-id: <20190823165647.GJ5994@MacBook-Pro-64.local>
References: <529376a4-cf63-f225-ce7c-4747e9966938@tessares.net>
 <20190823125054.30070-1-tim.froidcoeur@tessares.net>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
In-reply-to: <20190823125054.30070-1-tim.froidcoeur@tessares.net>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-23_07:,,
 signatures=0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 23/08/19 - 14:50:54, Tim Froidcoeur wrote:
> Commit 8c3088f895a0 ("tcp: be more careful in tcp_fragment()")
> triggers following stack trace:
> 
> [25244.848046] kernel BUG at ./include/linux/skbuff.h:1406!
> [25244.859335] RIP: 0010:skb_queue_prev+0x9/0xc
> [25244.888167] Call Trace:
> [25244.889182]  <IRQ>
> [25244.890001]  tcp_fragment+0x9c/0x2cf
> [25244.891295]  tcp_write_xmit+0x68f/0x988
> [25244.892732]  __tcp_push_pending_frames+0x3b/0xa0
> [25244.894347]  tcp_data_snd_check+0x2a/0xc8
> [25244.895775]  tcp_rcv_established+0x2a8/0x30d
> [25244.897282]  tcp_v4_do_rcv+0xb2/0x158
> [25244.898666]  tcp_v4_rcv+0x692/0x956
> [25244.899959]  ip_local_deliver_finish+0xeb/0x169
> [25244.901547]  __netif_receive_skb_core+0x51c/0x582
> [25244.903193]  ? inet_gro_receive+0x239/0x247
> [25244.904756]  netif_receive_skb_internal+0xab/0xc6
> [25244.906395]  napi_gro_receive+0x8a/0xc0
> [25244.907760]  receive_buf+0x9a1/0x9cd
> [25244.909160]  ? load_balance+0x17a/0x7b7
> [25244.910536]  ? vring_unmap_one+0x18/0x61
> [25244.911932]  ? detach_buf+0x60/0xfa
> [25244.913234]  virtnet_poll+0x128/0x1e1
> [25244.914607]  net_rx_action+0x12a/0x2b1
> [25244.915953]  __do_softirq+0x11c/0x26b
> [25244.917269]  ? handle_irq_event+0x44/0x56
> [25244.918695]  irq_exit+0x61/0xa0
> [25244.919947]  do_IRQ+0x9d/0xbb
> [25244.921065]  common_interrupt+0x85/0x85
> [25244.922479]  </IRQ>
> 
> tcp_rtx_queue_tail() (called by tcp_fragment()) can call
> tcp_write_queue_prev() on the first packet in the queue, which will trigger
> the BUG in tcp_write_queue_prev(), because there is no previous packet.
> 
> This happens when the retransmit queue is empty, for example in case of a
> zero window.
> 
> Patch is needed for 4.4, 4.9 and 4.14 stable branches.
> 
> Fixes: 8c3088f895a0 ("tcp: be more careful in tcp_fragment()")
> Signed-off-by: Tim Froidcoeur <tim.froidcoeur@tessares.net>
> Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> ---
>  include/net/tcp.h | 4 ++++
>  1 file changed, 4 insertions(+)

Reviewed-by: Christoph Paasch <cpaasch@apple.com>

