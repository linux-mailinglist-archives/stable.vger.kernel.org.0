Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74C1F452530
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356117AbhKPBrK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:47:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:57164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1381877AbhKPBoe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 20:44:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C943461A89;
        Tue, 16 Nov 2021 01:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637026898;
        bh=/IMeNNmpgriqHv7AYfD9hxG7Zv1o80fjykMme8VZni8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Dhqf8NCjkCJmLyb7ucHw6bPmtVAPZuU9t6dGCSm0w/eLfngU8FHaNR2EZZucee5V7
         hNCzDl01tP6HWGOJpTTD0IthtfFaVH1FNCvERR0/XXjBzL/JuSbqu11Levrp/o/51N
         pkr24ikWE7Tr+UYi4R/6p4RvX3pMmLzbnLy45YOvfb5Mc9SiJxU2uBY/mYdoFf15nw
         /MwQeTfpdCHO6M9ibQLQulY9hPolXEqwnTIz0E5QsLzNcBAvD3ZhgPve7BxOmC73Cg
         myObJhQo1UuqA/h7VSmMv7Fb9pSE3VkXLJtlhhGoRNIVIMKMv8MJeRZ/PiPpNg7vsv
         P/UcFulZ2EZ9A==
Date:   Mon, 15 Nov 2021 20:41:36 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 5.15 301/917] net: dsa: flush switchdev workqueue when
 leaving the bridge
Message-ID: <YZMMUGniCoi5I5p7@sashalap>
References: <20211115165428.722074685@linuxfoundation.org>
 <20211115165438.966642608@linuxfoundation.org>
 <20211115233358.u6n44mop73le7rkw@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20211115233358.u6n44mop73le7rkw@skbuf>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 15, 2021 at 11:33:59PM +0000, Vladimir Oltean wrote:
>On Mon, Nov 15, 2021 at 05:56:36PM +0100, Greg Kroah-Hartman wrote:
>> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>>
>> [ Upstream commit d7d0d423dbaa73fd0506e25971dfdab6bf185d00 ]
>>
>> DSA is preparing to offer switch drivers an API through which they can
>> associate each FDB entry with a struct net_device *bridge_dev. This can
>> be used to perform FDB isolation (the FDB lookup performed on the
>> ingress of a standalone, or bridged port, should not find an FDB entry
>> that is present in the FDB of another bridge).
>>
>> In preparation of that work, DSA needs to ensure that by the time we
>> call the switch .port_fdb_add and .port_fdb_del methods, the
>> dp->bridge_dev pointer is still valid, i.e. the port is still a bridge
>> port.
>>
>> This is not guaranteed because the SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE API
>> requires drivers that must have sleepable context to handle those events
>> to schedule the deferred work themselves. DSA does this through the
>> dsa_owq.
>>
>> It can happen that a port leaves a bridge, del_nbp() flushes the FDB on
>> that port, SWITCHDEV_FDB_DEL_TO_DEVICE is notified in atomic context,
>> DSA schedules its deferred work, but del_nbp() finishes unlinking the
>> bridge as a master from the port before DSA's deferred work is run.
>>
>> Fundamentally, the port must not be unlinked from the bridge until all
>> FDB deletion deferred work items have been flushed. The bridge must wait
>> for the completion of these hardware accesses.
>>
>> An attempt has been made to address this issue centrally in switchdev by
>> making SWITCHDEV_FDB_DEL_TO_DEVICE deferred (=> blocking) at the switchdev
>> level, which would offer implicit synchronization with del_nbp:
>>
>> https://patchwork.kernel.org/project/netdevbpf/cover/20210820115746.3701811-1-vladimir.oltean@nxp.com/
>>
>> but it seems that any attempt to modify switchdev's behavior and make
>> the events blocking there would introduce undesirable side effects in
>> other switchdev consumers.
>>
>> The most undesirable behavior seems to be that
>> switchdev_deferred_process_work() takes the rtnl_mutex itself, which
>> would be worse off than having the rtnl_mutex taken individually from
>> drivers which is what we have now (except DSA which has removed that
>> lock since commit 0faf890fc519 ("net: dsa: drop rtnl_lock from
>> dsa_slave_switchdev_event_work")).
>>
>> So to offer the needed guarantee to DSA switch drivers, I have come up
>> with a compromise solution that does not require switchdev rework:
>> we already have a hook at the last moment in time when the bridge is
>> still an upper of ours: the NETDEV_PRECHANGEUPPER handler. We can flush
>> the dsa_owq manually from there, which makes all FDB deletions
>> synchronous.
>>
>> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>> Signed-off-by: David S. Miller <davem@davemloft.net>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  net/dsa/port.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/net/dsa/port.c b/net/dsa/port.c
>> index 616330a16d319..3947537ed46ba 100644
>> --- a/net/dsa/port.c
>> +++ b/net/dsa/port.c
>> @@ -380,6 +380,8 @@ void dsa_port_pre_bridge_leave(struct dsa_port *dp, struct net_device *br)
>>  	switchdev_bridge_port_unoffload(brport_dev, dp,
>>  					&dsa_slave_switchdev_notifier,
>>  					&dsa_slave_switchdev_blocking_notifier);
>> +
>> +	dsa_flush_workqueue();
>>  }
>>
>>  void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br)
>> --
>> 2.33.0
>>
>>
>>
>
>This patch represents preparation work for a new feature. Unless it
>constitutes a dependency for some other bugfix patches (which I doubt),
>my suggestion is to not backport it. Thanks.

Dropped, thanks!

-- 
Thanks,
Sasha
