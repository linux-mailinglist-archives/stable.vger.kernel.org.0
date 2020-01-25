Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD2514959C
	for <lists+stable@lfdr.de>; Sat, 25 Jan 2020 14:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725812AbgAYND6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jan 2020 08:03:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:52064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725710AbgAYND6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 25 Jan 2020 08:03:58 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 186F320709;
        Sat, 25 Jan 2020 13:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579957437;
        bh=+gtyl+CGVlNYngfH6PVU9bmZaS/zNCsGp0kkW+9xVIo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XRgJk4gwQiT30zbU1yh/HT7VOI76+F+bhVazcoIIkQzKXGjiuaxdhJawQvu8eR9Oi
         03MDPWlSXBZHZfDI1Pzoturavsdv5Mbbd6xhXkm8oJk7X9JMtSyc+LQmlODiH35rYo
         tkg401VqKEIy/+A+95tHoRGOwq6jqLJOooEBt3sU=
Date:   Sat, 25 Jan 2020 08:03:55 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Sunil Muthuswamy <sunilmut@microsoft.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH stable v4.19.99]: net: hv_sock: Remove the accept port
 restriction
Message-ID: <20200125130355.GJ1706@sasha-vm>
References: <SN4PR2101MB08801E39B5E814956A4F5708C00E0@SN4PR2101MB0880.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <SN4PR2101MB08801E39B5E814956A4F5708C00E0@SN4PR2101MB0880.namprd21.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 24, 2020 at 03:08:18AM +0000, Sunil Muthuswamy wrote:
>commit c742c59e1fbd ("hv_sock: Remove the accept port restriction")
>
>Currently, hv_sock restricts the port the guest socket can accept
>connections on. hv_sock divides the socket port namespace into two parts
>for server side (listening socket), 0-0x7FFFFFFF & 0x80000000-0xFFFFFFFF
>(there are no restrictions on client port namespace). The first part
>(0-0x7FFFFFFF) is reserved for sockets where connections can be accepted.
>The second part (0x80000000-0xFFFFFFFF) is reserved for allocating ports
>for the peer (host) socket, once a connection is accepted.
>This reservation of the port namespace is specific to hv_sock and not
>known by the generic vsock library (ex: af_vsock). This is problematic
>because auto-binds/ephemeral ports are handled by the generic vsock
>library and it has no knowledge of this port reservation and could
>allocate a port that is not compatible with hv_sock (and legitimately so).
>The issue hasn't surfaced so far because the auto-bind code of vsock
>(__vsock_bind_stream) prior to the change 'VSOCK: bind to random port for
>VMADDR_PORT_ANY' would start walking up from LAST_RESERVED_PORT (1023) and
>start assigning ports. That will take a large number of iterations to hit
>0x7FFFFFFF. But, after the above change to randomize port selection, the
>issue has started coming up more frequently.
>There has really been no good reason to have this port reservation logic
>in hv_sock from the get go. Reserving a local port for peer ports is not
>how things are handled generally. Peer ports should reflect the peer port.
>This fixes the issue by lifting the port reservation, and also returns the
>right peer port. Since the code converts the GUID to the peer port (by
>using the first 4 bytes), there is a possibility of conflicts, but that
>seems like a reasonable risk to take, given this is limited to vsock and
>that only applies to all local sockets.
>
>Signed-off-by: Sunil Muthuswamy <sunilmut@microsoft.com>
>Signed-off-by: David S. Miller <davem@davemloft.net>

I'll queue it up when the current release is out in a day or so, thanks!

-- 
Thanks,
Sasha
