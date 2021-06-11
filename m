Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C80903A3FBF
	for <lists+stable@lfdr.de>; Fri, 11 Jun 2021 12:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbhFKKGi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Jun 2021 06:06:38 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:27249 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229777AbhFKKGh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Jun 2021 06:06:37 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1623405879; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=ufApYsQGBUVWQroy/mTH2z8XFLX0jRp1NQn7srIhh1Y=;
 b=l+4dVFYdZaR2pn20+P0k3vGkHKGVIICht3TgCDpicPs6iAB4JZxzVBB8sl+8/cTOxwa21vws
 860l4nwpUdmYUPiCBbWGqOi1NSRMPzo+x5uC/Qy4lVqU47wfCtOyojjOU3wK0v3fpUmjYHOj
 2prCiEdYIgJLZX0KbMSuh8JIuGk=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 60c33502e27c0cc77fd427ea (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 11 Jun 2021 10:03:46
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D83C2C433D3; Fri, 11 Jun 2021 10:03:45 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL autolearn=no autolearn_force=no
        version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A0C4EC433F1;
        Fri, 11 Jun 2021 10:03:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A0C4EC433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 5.13] mwifiex: bring down link before deleting interface
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210515024227.2159311-1-briannorris@chromium.org>
References: <20210515024227.2159311-1-briannorris@chromium.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     linux-wireless@vger.kernel.org, <linux-kernel@vger.kernel.org>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Brian Norris <briannorris@chromium.org>,
        stable@vger.kernel.org, Maximilian Luz <luzmaximilian@gmail.com>,
        dave@bewaar.me, Johannes Berg <johannes@sipsolutions.net>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210611100345.D83C2C433D3@smtp.codeaurora.org>
Date:   Fri, 11 Jun 2021 10:03:45 +0000 (UTC)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Brian Norris <briannorris@chromium.org> wrote:

> We can deadlock when rmmod'ing the driver or going through firmware
> reset, because the cfg80211_unregister_wdev() has to bring down the link
> for us, ... which then grab the same wiphy lock.
> 
> nl80211_del_interface() already handles a very similar case, with a nice
> description:
> 
>         /*
>          * We hold RTNL, so this is safe, without RTNL opencount cannot
>          * reach 0, and thus the rdev cannot be deleted.
>          *
>          * We need to do it for the dev_close(), since that will call
>          * the netdev notifiers, and we need to acquire the mutex there
>          * but don't know if we get there from here or from some other
>          * place (e.g. "ip link set ... down").
>          */
>         mutex_unlock(&rdev->wiphy.mtx);
> ...
> 
> Do similarly for mwifiex teardown, by ensuring we bring the link down
> first.
> 
> Sample deadlock trace:
> 
> [  247.103516] INFO: task rmmod:2119 blocked for more than 123 seconds.
> [  247.110630]       Not tainted 5.12.4 #5
> [  247.115796] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  247.124557] task:rmmod           state:D stack:    0 pid: 2119 ppid:  2114 flags:0x00400208
> [  247.133905] Call trace:
> [  247.136644]  __switch_to+0x130/0x170
> [  247.140643]  __schedule+0x714/0xa0c
> [  247.144548]  schedule_preempt_disabled+0x88/0xf4
> [  247.149714]  __mutex_lock_common+0x43c/0x750
> [  247.154496]  mutex_lock_nested+0x5c/0x68
> [  247.158884]  cfg80211_netdev_notifier_call+0x280/0x4e0 [cfg80211]
> [  247.165769]  raw_notifier_call_chain+0x4c/0x78
> [  247.170742]  call_netdevice_notifiers_info+0x68/0xa4
> [  247.176305]  __dev_close_many+0x7c/0x138
> [  247.180693]  dev_close_many+0x7c/0x10c
> [  247.184893]  unregister_netdevice_many+0xfc/0x654
> [  247.190158]  unregister_netdevice_queue+0xb4/0xe0
> [  247.195424]  _cfg80211_unregister_wdev+0xa4/0x204 [cfg80211]
> [  247.201816]  cfg80211_unregister_wdev+0x20/0x2c [cfg80211]
> [  247.208016]  mwifiex_del_virtual_intf+0xc8/0x188 [mwifiex]
> [  247.214174]  mwifiex_uninit_sw+0x158/0x1b0 [mwifiex]
> [  247.219747]  mwifiex_remove_card+0x38/0xa0 [mwifiex]
> [  247.225316]  mwifiex_pcie_remove+0xd0/0xe0 [mwifiex_pcie]
> [  247.231451]  pci_device_remove+0x50/0xe0
> [  247.235849]  device_release_driver_internal+0x110/0x1b0
> [  247.241701]  driver_detach+0x5c/0x9c
> [  247.245704]  bus_remove_driver+0x84/0xb8
> [  247.250095]  driver_unregister+0x3c/0x60
> [  247.254486]  pci_unregister_driver+0x2c/0x90
> [  247.259267]  cleanup_module+0x18/0xcdc [mwifiex_pcie]
> 
> Fixes: a05829a7222e ("cfg80211: avoid holding the RTNL when calling the driver")
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/linux-wireless/98392296-40ee-6300-369c-32e16cff3725@gmail.com/
> Link: https://lore.kernel.org/linux-wireless/ab4d00ce52f32bd8e45ad0448a44737e@bewaar.me/
> Reported-by: Maximilian Luz <luzmaximilian@gmail.com>
> Reported-by: dave@bewaar.me
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> Tested-by: Maximilian Luz <luzmaximilian@gmail.com>
> Tested-by: Dave Olsthoorn <dave@bewaar.me>

Patch applied to wireless-drivers.git, thanks.

1f9482aa8d41 mwifiex: bring down link before deleting interface

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210515024227.2159311-1-briannorris@chromium.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

