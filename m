Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0412D451F43
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355859AbhKPAin (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:38:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344070AbhKOTXN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 14:23:13 -0500
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050::465:201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5C12C04993F;
        Mon, 15 Nov 2021 10:28:24 -0800 (PST)
Received: from smtp202.mailbox.org (smtp202.mailbox.org [80.241.60.245])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4HtHkY4tv8zQkj1;
        Mon, 15 Nov 2021 19:28:21 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hauke-m.de; s=MBO0001;
        t=1637000897;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6ix3GSMuJf8J7gxzZMVaehnNDtxrrvGJtZiRi1rggu8=;
        b=LanLbt3rNZwXOA9eFpYW7VJc9FSBYn0BKEXwhWIXkGUeIkBASb5BjkEPDTMrKr8OrP8Ff7
        RFGILYbIZBTZ9pavHkWF5IK012oNFbm6wJhOmnbTndZq01fZ8lVlYcPv6ov/vXEGooXqy5
        m8imowG0mvY3SnlXH+7TYmsz4mU0ojNDmwWZMs/zzpVA/Xwjc7VnmC6TPY3UKNhn4K7oyo
        XWaz7OM3oEChylIPe0wcKBLKM9lsu8UMolOJ74LCb0y9P0he7K0fEmrxbPmIYWFh72SwHl
        F6kqqqeiGtpV1I5LHM0YsImLeSM6Oyw00laxevx6u7uaTuSMMe0Gbvu/t0R4vw==
Subject: Re: [PATCH 5.14 309/849] net: dsa: lantiq_gswip: serialize access to
 the PCE table
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
References: <20211115165419.961798833@linuxfoundation.org>
 <20211115165430.700038680@linuxfoundation.org>
From:   Hauke Mehrtens <hauke@hauke-m.de>
Message-ID: <511fefcb-9cad-bba2-e267-710994874097@hauke-m.de>
Date:   Mon, 15 Nov 2021 19:28:14 +0100
MIME-Version: 1.0
In-Reply-To: <20211115165430.700038680@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/15/21 5:56 PM, Greg Kroah-Hartman wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> [ Upstream commit 49753a75b9a32de4c0393bb8d1e51ea223fda8e4 ]
> 
> Looking at the code, the GSWIP switch appears to hold bridging service
> structures (VLANs, FDBs, forwarding rules) in PCE table entries.
> Hardware access to the PCE table is non-atomic, and is comprised of
> several register reads and writes.
> 
> These accesses are currently serialized by the rtnl_lock, but DSA is
> changing its driver API and that lock will no longer be held when
> calling ->port_fdb_add() and ->port_fdb_del().
> 
> So this driver needs to serialize the access to the PCE table using its
> own locking scheme. This patch adds that.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/net/dsa/lantiq_gswip.c | 28 +++++++++++++++++++++++-----
>   1 file changed, 23 insertions(+), 5 deletions(-)

Hi Greg and Vladimir,

I understood this is only needed when we apply the complete patch series 
from Vladimir. This would only be needed when we also apply this patch:
 > commit 5cdfde49a07f38663c277ddf2e56345ea1706fc2
 > Author: Vladimir Oltean <vladimir.oltean@nxp.com>
 > Date:   Fri Oct 22 21:43:10 2021 +0300
 >
 >     net: dsa: drop rtnl_lock from dsa_slave_switchdev_event_work
This was added in v5.16-rc1.

Without this patch the sections are protected by rtnl_lock().


Hauke
