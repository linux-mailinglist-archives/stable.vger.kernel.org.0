Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36BAF1C07C
	for <lists+stable@lfdr.de>; Tue, 14 May 2019 04:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbfENCHp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 May 2019 22:07:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:42692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726327AbfENCHp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 May 2019 22:07:45 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A5342085A;
        Tue, 14 May 2019 02:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557799664;
        bh=+pBz5bX+Abp53EKDMp6lhcf9APouMaidOW9s5ke6FHI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z+phe0ILq3WWbZHFIpnBHpUqh3tbuWg5MzOoODkoetELC6SWo+BYSgMVFMqbbak7x
         BXo0mw8JWoWP1+nHWf7bqQd/BlrT1HKemnwhtOJrKoDotG8zTUvpCLch7ZpOmgz1vC
         JmbFtp6wIHlLuzYwavd2X2mA3qstYVqve21o2+kQ=
Date:   Mon, 13 May 2019 22:07:42 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     "George G. Davis" <george_davis@mentor.com>
Cc:     Fabio Estevam <festevam@gmail.com>, stable@vger.kernel.org,
        shawnguo@kernel.org, andrew@lunn.ch, baruch@tkos.co.il,
        ken.lin@advantech.com, smoch@web.de, stwiss.opensource@diasemi.com,
        linux-imx@nxp.com, kernel@pengutronix.de,
        Marc Kleine-Budde <mkl@pengutronix.de>, aford173@gmail.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3] ARM: dts: imx: Fix the AR803X phy-mode
Message-ID: <20190514020742.GJ11972@sasha-vm>
References: <20190403221241.4753-1-festevam@gmail.com>
 <20190513171826.GA18591@mam-gdavis-lt>
 <20190514004539.GG11972@sasha-vm>
 <20190514011606.GA18528@mam-gdavis-lt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190514011606.GA18528@mam-gdavis-lt>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 13, 2019 at 09:16:07PM -0400, George G. Davis wrote:
>On Mon, May 13, 2019 at 08:45:39PM -0400, Sasha Levin wrote:
>> On Mon, May 13, 2019 at 01:18:27PM -0400, George G. Davis wrote:
>> >Hello,
>> >
>> >On Wed, Apr 03, 2019 at 07:12:41PM -0300, Fabio Estevam wrote:
>> >>Commit 6d4cd041f0af ("net: phy: at803x: disable delay only for RGMII mode")
>> >>exposed an issue on imx DTS files using AR8031/AR8035 PHYs.
>> >>
>> >>The end result is that the boards can no longer obtain an IP address
>> >>via UDHCP, for example.
>> >>
>> >>Quoting Andrew Lunn:
>> >>
>> >>"The problem here is, all the DTs were broken since day 0. However,
>> >>because the PHY driver was also broken, nobody noticed and it
>> >>worked. Now that the PHY driver has been fixed, all the bugs in the
>> >>DTs now become an issue"
>> >>
>> >>To fix this problem, the phy-mode property needs to be "rgmii-id",  which
>> >>has the following meaning as per
>> >>Documentation/devicetree/bindings/net/ethernet.txt:
>> >>
>> >>"RGMII with internal RX and TX delays provided by the PHY, the MAC should
>> >>not add the RX or TX delays in this case)"
>> >>
>> >>Tested on imx6-sabresd, imx6sx-sdb and imx7d-pico boards with
>> >>successfully restored networking.
>> >>
>> >>Based on the initial submission from Steve Twiss for the
>> >>imx6qdl-sabresd.
>> >>
>> >>Signed-off-by: Fabio Estevam <festevam@gmail.com>
>> >>Tested-by: Baruch Siach <baruch@tkos.co.il>
>> >>Tested-by: Soeren Moch <smoch@web.de>
>> >>Tested-by: Steve Twiss <stwiss.opensource@diasemi.com>
>> >>Tested-by: Adam Thomson <Adam.Thomson@diasemi.com>
>> >>Signed-off-by: Steve Twiss <stwiss.opensource@diasemi.com>
>> >>Tested-by: Marc Kleine-Budde <mkl@pengutronix.de>
>> >>Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
>> >>---
>> >>Changes since v2:
>> >>- Also fixed imx6q-ba16
>> >>- Removed stable tag as it does not apply cleanly on older
>> >>stable trees. I can manually generate versions for stable
>> >>trees after this one hits mainline.
>> >
>> >Please add this commit to the v5.1.x stable queue to resolve NFS root breakage
>> >in v5.1. I can confirm that it applies cleanly to v5.1.1 and resolves NFS root
>> >breakage that occurs on i.MX6 boards in v5.1.x, tested on imx6q-sabreauto.dts
>> >and imx6q-sabresd.dts. Although the fix should be backported to pre-v5.1.x
>> >stable series as well, it does not cause problems for pre-v5.1 but results in
>> >NFS root breakage for v5.1.x.
>>
>> What's the commit id in Linus's tree? I don't see it.
>
>Er, um, sorry, it was deferred to linux-next commit 68e9c97161b3 ("serial:
>sh-sci: disable DMA for uart_console"), which quite frankly rather annoyed me
>personally since linux-next commit 68e9c97161b3 is required to fix a regression
>caused by v5.1 commit 6d4cd041f0af. In my opinion, linux-next commit
>68e9c97161b3 really should have been pushed to the v5.1 release, earlier, due
>to the noted regression, but I'm happy to wait for linux-next commit
>68e9c97161b3 to make it to Linus's tree before propagating it to linux-stable.

We'll happily take it once it makes it into Linus's tree and into a
release.

>Meanwhile, I wanted to let you know that v5.1.x is rather broken, in this
>regard, on i.MX6 as-is for now.

This would be something we can't do much about, but given it's an
important fix it should make it into Linus's tree very soon, right?

--
Sasha
