Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 867063878A4
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 14:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349030AbhERM0Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 08:26:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232915AbhERM0Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 May 2021 08:26:24 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC708C061573
        for <stable@vger.kernel.org>; Tue, 18 May 2021 05:25:04 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id q2so7240633pfh.13
        for <stable@vger.kernel.org>; Tue, 18 May 2021 05:25:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=V+Bd/HFaeS1GNwMmANHqZIk69m3dVyRb6nibgfR29Gg=;
        b=JAJGPK1PUvnJdKX9L6nSJm/44fQnfhSjBtGR/eLFxmr9GjIbztv+NqP5KN5i7i3zkR
         f9+0yJ+6rkJnkaz3Jr1KNgXrvvHZAa+uMhhmUA3I1hSMbgzCgZ9WmTIZ8KPE5w+YZL15
         wcORdvPps6Tzsyfq8ge1cxORSdBDJuN1nft5c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=V+Bd/HFaeS1GNwMmANHqZIk69m3dVyRb6nibgfR29Gg=;
        b=PaTJQh8Q0GQ2YP1EQcpW8EDfEm2avKhT6pj8XilWVV/bC/r9gP8dcpjqFFHOsJu0Gr
         EGy9mOhZqavtZPBipxc6/u1iRVEWxCsEPthN+K3PokNcmWBjSL/HN5+4pxTpy+QN0oJG
         79eVKO7MQs4e1Q2EDoCps2AJ8pC0feE6DkQamm8pdxpHHpcWwO+deDZQPJAdyAAPsopr
         W85pnx1rGWe1sxUKKeLe8a8Pnn7vdVeBRhPhX367VWbEGqDfz496Npg7GkPG/Ua2fOMu
         lcI0M35xVqGUoSIq/EOSdLgwNzbClOFBb8v/hs9n6F1sG1OIQmOvqw4BS5xBFE15jH+2
         SzZA==
X-Gm-Message-State: AOAM531+geqClZv2vIx66S3rxfNhAjUPHjciuZDnqchlujkUVV+vvn+3
        yZwDeXb7e8OaykNDNJljo4DuEw==
X-Google-Smtp-Source: ABdhPJwRNU3BebEPYvQ2pZsl6/7bRaWW2Ba8dXgU325Ki5n+AdladpPyO4U2cmf4gCuUtdz8wTtI6A==
X-Received: by 2002:a62:7ad4:0:b029:2dc:d1a2:b093 with SMTP id v203-20020a627ad40000b02902dcd1a2b093mr4783347pfc.66.1621340704231;
        Tue, 18 May 2021 05:25:04 -0700 (PDT)
Received: from ec3d6f83b95b (110-175-118-133.tpgi.com.au. [110.175.118.133])
        by smtp.gmail.com with ESMTPSA id a16sm12066018pfc.37.2021.05.18.05.25.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 18 May 2021 05:25:03 -0700 (PDT)
Date:   Tue, 18 May 2021 12:24:57 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.12 081/363] net: bridge: propagate error code and
 extack from br_mc_disabled_update
Message-ID: <20210518122449.GA65@ec3d6f83b95b>
References: <20210517140302.508966430@linuxfoundation.org>
 <20210517140305.339768334@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210517140305.339768334@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 17, 2021 at 03:59:07PM +0200, Greg Kroah-Hartman wrote:
> From: Florian Fainelli <f.fainelli@gmail.com>
> 
> [ Upstream commit ae1ea84b33dab45c7b6c1754231ebda5959b504c ]
> 
> Some Ethernet switches might only be able to support disabling multicast
> snooping globally, which is an issue for example when several bridges
> span the same physical device and request contradictory settings.
> 
> Propagate the return value of br_mc_disabled_update() such that this
> limitation is transmitted correctly to user-space.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  net/bridge/br_multicast.c | 28 +++++++++++++++++++++-------
>  net/bridge/br_netlink.c   |  4 +++-
>  net/bridge/br_private.h   |  3 ++-
>  net/bridge/br_sysfs_br.c  |  8 +-------
>  4 files changed, 27 insertions(+), 16 deletions(-)

This patch results in docker failing to start, and a regression between
5.12.4 and 5.12.5-rc1

A working dmesg output is like:

[   11.545255] device eth0 entered promiscuous mode
[   11.693848] process 'docker/tmp/qemu-check643160757/check' started with executable stack
[   17.233059] br-92020c7e3aea: port 1(veth17a0552) entered blocking state
[   17.233065] br-92020c7e3aea: port 1(veth17a0552) entered disabled state
[   17.233098] device veth17a0552 entered promiscuous mode
[   17.292839] docker0: port 2(veth9d227f5) entered blocking state
[   17.292848] docker0: port 2(veth9d227f5) entered disabled state
[   17.292946] device veth9d227f5 entered promiscuous mode
[   17.293070] docker0: port 2(veth9d227f5) entered blocking state
[   17.293075] docker0: port 2(veth9d227f5) entered forwarding state

with this patch "device veth17a0552 entered promiscuous mode" never
shows up.

the docker error itself is:

docker: Error response from daemon: failed to create endpoint
sleepy_dijkstra on network bridge: adding interface veth8cbd8f9 to
bridge docker0 failed: operation not supported.

Regards
Rudi
