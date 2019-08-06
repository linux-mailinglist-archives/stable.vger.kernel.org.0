Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4A183D3A
	for <lists+stable@lfdr.de>; Wed,  7 Aug 2019 00:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbfHFWKW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 18:10:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:36420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726902AbfHFWKW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 18:10:22 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21F7321872;
        Tue,  6 Aug 2019 22:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565129421;
        bh=zr+AC2oEeZiny5+/7E2Ef2eKnar4y55dS3Yozf5SRf0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C1q6ZHQd+3xcKPPxybroeJsXM388dNJ+sdWDyJmDoiNwsymggqT/QzU8Ppkz9C7Fn
         BT9Xuj4ZNqRKd1hpjUe4pa01V6KIQfmSBTkpcvuJnQ38jOBLJmM6pvd6X8aeV7thmN
         FcC/mvHcjKeN/7fQaggNcscxo23R0ewYwVO1oBYg=
Date:   Tue, 6 Aug 2019 18:10:20 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Prout <aprout@ll.mit.edu>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Jonathan Looney <jtl@netflix.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH] tcp: be more careful in tcp_fragment()
Message-ID: <20190806221020.GO17747@sasha-vm>
References: <CANn89iKr7vYoLD_o-zhR72rQ8a4OQr=VW6oVRCYBDi1kmN6=dg@mail.gmail.com>
 <20190806150914.8797-1-matthieu.baerts@tessares.net>
 <CANn89iL5au7KJQaw9JvMF9Q6-KqA3yMo-vrff33t7ozRZvyPvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CANn89iL5au7KJQaw9JvMF9Q6-KqA3yMo-vrff33t7ozRZvyPvA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 06, 2019 at 05:25:35PM +0200, Eric Dumazet wrote:
>On Tue, Aug 6, 2019 at 5:09 PM Matthieu Baerts
><matthieu.baerts@tessares.net> wrote:
>>
>> From: Eric Dumazet <edumazet@google.com>
>>
>> commit b617158dc096709d8600c53b6052144d12b89fab upstream.
>>
>> Some applications set tiny SO_SNDBUF values and expect
>> TCP to just work. Recent patches to address CVE-2019-11478
>> broke them in case of losses, since retransmits might
>> be prevented.
>>
>> We should allow these flows to make progress.
>>
>> This patch allows the first and last skb in retransmit queue
>> to be split even if memory limits are hit.
>>
>> It also adds the some room due to the fact that tcp_sendmsg()
>> and tcp_sendpage() might overshoot sk_wmem_queued by about one full
>> TSO skb (64KB size). Note this allowance was already present
>> in stable backports for kernels < 4.15
>>
>> Note for < 4.15 backports :
>>  tcp_rtx_queue_tail() will probably look like :
>>
>> static inline struct sk_buff *tcp_rtx_queue_tail(const struct sock *sk)
>> {
>>         struct sk_buff *skb = tcp_send_head(sk);
>>
>>         return skb ? tcp_write_queue_prev(sk, skb) : tcp_write_queue_tail(sk);
>> }
>>
>> Fixes: f070ef2ac667 ("tcp: tcp_fragment() should apply sane memory limits")
>> Signed-off-by: Eric Dumazet <edumazet@google.com>
>> Reported-by: Andrew Prout <aprout@ll.mit.edu>
>> Tested-by: Andrew Prout <aprout@ll.mit.edu>
>> Tested-by: Jonathan Lemon <jonathan.lemon@gmail.com>
>> Tested-by: Michal Kubecek <mkubecek@suse.cz>
>> Acked-by: Neal Cardwell <ncardwell@google.com>
>> Acked-by: Yuchung Cheng <ycheng@google.com>
>> Acked-by: Christoph Paasch <cpaasch@apple.com>
>> Cc: Jonathan Looney <jtl@netflix.com>
>> Signed-off-by: David S. Miller <davem@davemloft.net>
>> Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
>> ---
>>
>> Notes:
>>     Hello,
>>
>>     Here is the backport for linux-4.14.y branch simply by implementing
>>     functions written by Eric here in the commit message and in this email
>>     thread. It might be valid for older versions, I didn't check.
>>
>>     In my setup with MPTCP, I had the same bug other had where TCP flows
>>     were stalled. The initial fix b6653b3629e5 (tcp: refine memory limit
>>     test in tcp_fragment()) from Eric was helping but the backport in
>>     < 4.15 was not looking safe: 1bc13903773b (tcp: refine memory limit
>>     test in tcp_fragment()).
>>
>>     I then decided to test the new fix and it is working fine in my test
>>     environment, no stalled TCP flows in a few hours.
>>
>>     In this email thread I see that Eric will push a patch for v4.14. I
>>     absolutely do not want to add pressure or steal his work but because I
>>     have the patch here and it is tested, I was thinking it could be a good
>>     idea to share it with others. Feel free to ignore this patch if needed.
>>     But if this patch can reduce a tiny bit Eric's workload, I would be
>>     very glad if it helps :)
>>     Because at the end, it is Eric's work, feel free to change my
>>     "Signed-off-by" by "Tested-By" if it is how it work or nothing if you
>>     prefer to wait for Eric's patch.
>
>This patch is fine, I was simply on vacation last week, and wanted to
>truly take full advantage of them ;)

Queued for 4.14, 4.9, and 4.4. Thanks all!

--
Thanks,
Sasha
