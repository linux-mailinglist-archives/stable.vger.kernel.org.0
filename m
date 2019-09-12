Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34ABCB1685
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 00:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbfILW7Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Sep 2019 18:59:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:51358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726099AbfILW7Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Sep 2019 18:59:24 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EF8C206CD;
        Thu, 12 Sep 2019 22:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568329163;
        bh=E7Wjo59vwo4X7JUl+bLyY2Ld40o1S8bJqr6X+awa6E4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C6mBlz8TNr8Q6F4KYCIqpjKUP0ht2U6qQvTi5Iewa09zIjjhqNYnHbhrD1tjfq0qd
         4l0qnNsUqBgaRAeuKSo5AK/5DkWUsc8s+xIfdAP1jFQ+9cc6h6apN/ZMNUya0pteJf
         MzmCedZZKPJn3NABwQe2olbPfOvqRQ8e3rgTYzxk=
Date:   Thu, 12 Sep 2019 18:59:14 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Zubin Mithra <zsm@chromium.org>
Cc:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        groeck@chromium.org, davej@codemonkey.org.uk, daniel@iogearbox.net
Subject: Re: 6ae81ced3788 ("af_packet: tone down the Tx-ring unsupported
 spew.")
Message-ID: <20190912225914.GF1546@sasha-vm>
References: <20190912192508.GA106326@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190912192508.GA106326@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 12, 2019 at 12:25:10PM -0700, Zubin Mithra wrote:
>Hello,
>
>Syzkaller has triggered a WARNING in packet_set_ring when fuzzing a 4.4 kernel with the following stacktrace.
>Call Trace:
>  __dump_stack lib/dump_stack.c:15 [inline]
>  dump_stack+0xc1/0x124 lib/dump_stack.c:51
>  panic+0x1a7/0x351 kernel/panic.c:115
>  warn_slowpath_common+0x12a/0x140 kernel/panic.c:463
>  warn_slowpath_fmt+0xb0/0xe0 kernel/panic.c:479
>  packet_set_ring+0x13ed/0x19c0 net/packet/af_packet.c:4104
>  packet_setsockopt+0x53e/0x21d0 net/packet/af_packet.c:3578
>  SYSC_setsockopt net/socket.c:1766 [inline]
>  SyS_setsockopt+0x15d/0x240 net/socket.c:1745
>  entry_SYSCALL_64_fastpath+0x12/0x72
>
>
>Could the following patch be applied in v4.4.y? It is present in v4.9.y. Applying this patch could
>allow the fuzzer to explore more codepaths.
>* 6ae81ced3788 ("af_packet: tone down the Tx-ring unsupported spew.")

Queued up for 4.4, thank you.

--
Thanks,
Sasha
