Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 378E2A94D9
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 23:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727722AbfIDVUo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 17:20:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:45018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726358AbfIDVUo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 17:20:44 -0400
Received: from localhost (unknown [209.117.102.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C354F20828;
        Wed,  4 Sep 2019 21:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567632043;
        bh=Ojqy8ivmyKF5BkwEZLUHZkZNdboqGhLpouawdNXUclQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=To9BkXo/HIhtWlCLEliRLzA2HuJEM6u4Mxb8PHP8wPNMzVKs9a+iU650d2oxPR7aV
         J2/LL4Tx9YRHFlGHovgPjTlm17Rd0axoECwDoSveJpTfOHePAfJJPOjy+X/rlV1S1p
         /YrWcJgOY5A00o4poMoD5XjBXIZHZJMLNgSpEVm4=
Date:   Wed, 4 Sep 2019 17:20:40 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+c6167ec3de7def23d1e8@syzkaller.appspotmail.com,
        Arvid Brodin <arvid.brodin@alten.se>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 5.2 143/143] hsr: implement dellink to clean up resources
Message-ID: <20190904212040.GA1616@sasha-vm>
References: <20190904175314.206239922@linuxfoundation.org>
 <20190904175320.090038891@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190904175320.090038891@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 04, 2019 at 07:54:46PM +0200, Greg Kroah-Hartman wrote:
>From: Cong Wang <xiyou.wangcong@gmail.com>
>
>commit b9a1e627405d68d475a3c1f35e685ccfb5bbe668 upstream.
>
>hsr_link_ops implements ->newlink() but not ->dellink(),
>which leads that resources not released after removing the device,
>particularly the entries in self_node_db and node_db.
>
>So add ->dellink() implementation to replace the priv_destructor.
>This also makes the code slightly easier to understand.
>
>Reported-by: syzbot+c6167ec3de7def23d1e8@syzkaller.appspotmail.com
>Cc: Arvid Brodin <arvid.brodin@alten.se>
>Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
>Signed-off-by: David S. Miller <davem@davemloft.net>
>Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

If the airport gods cooperate, I'm going to queue:

edf070a0fb45a ("hsr: fix a NULL pointer deref in hsr_dev_xmit()")
311633b604063 ("hsr: switch ->dellink() to ->ndo_uninit()")

as fixes for this commit.

--
Thanks,
Sasha
