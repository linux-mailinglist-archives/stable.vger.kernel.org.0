Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D814047B363
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 20:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233983AbhLTTFC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 14:05:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233780AbhLTTFC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 14:05:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F3CFC061574;
        Mon, 20 Dec 2021 11:05:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99D4F61253;
        Mon, 20 Dec 2021 19:05:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D444CC36AE2;
        Mon, 20 Dec 2021 19:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640027101;
        bh=wuGnwyqyW/rqFlCTHu1dqQDn2tLUmfEXuC5+uzA6klk=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=TW4+mMHwaYrsyZEc7B9aDNe99yIds6KugBOV/qwRTiMoQxleP18h0r5u9BZ2MVLIZ
         1gX1eX25DoQf9DnHJu/7c94hQjr0KkAlI5Vge0uYTaNk3YhpO5SaG+XPgXszJHe1++
         TF0n8X1m+ceIlYFG5y1qhPNPXTAlilkk5h7c9pJmaTMWOvEQiSxYy+R+RH6Omr1A3f
         FZWZastMNjRWaKO73v5+6C1aZd3GJyIPXw3jhbND6xKZsTGFB1edQVCpXeWnytnurf
         EO/FSSj4ML9aUXrP1mY3yAVGqHRZNSIyr4jVVU3C5I/hTqW648oyOXb4K/ErrvUtGP
         wilLSs9cJds9w==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: rtl8192cu: Fix WARNING when calling
 local_irq_restore() with interrupts enabled
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20211215171105.20623-1-Larry.Finger@lwfinger.net>
References: <20211215171105.20623-1-Larry.Finger@lwfinger.net>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        syzbot+cce1ee31614c171f5595@syzkaller.appspotmail.com,
        stable@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164002709818.16553.13857001750113634649.kvalo@kernel.org>
Date:   Mon, 20 Dec 2021 19:04:59 +0000 (UTC)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Larry Finger <Larry.Finger@lwfinger.net> wrote:

> Syzbot reports the following WARNING:
> 
> [200~raw_local_irq_restore() called with IRQs enabled
> WARNING: CPU: 1 PID: 1206 at kernel/locking/irqflag-debug.c:10
>    warn_bogus_irq_restore+0x1d/0x20 kernel/locking/irqflag-debug.c:10
> 
> Hardware initialization for the rtl8188cu can run for as long as 350 ms,
> and the routine may be called with interrupts disabled. To avoid locking
> the machine for this long, the current routine saves the interrupt flags
> and enables local interrupts. The problem is that it restores the flags
> at the end without disabling local interrupts first.
> 
> This patch fixes commit a53268be0cb9 ("rtlwifi: rtl8192cu: Fix too long
> disable of IRQs").
> 
> Reported-by: syzbot+cce1ee31614c171f5595@syzkaller.appspotmail.com
> Cc: stable@vger.kernel.org
> Fixes: a53268be0cb9 ("rtlwifi: rtl8192cu: Fix too long disable of IRQs")
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Patch applied to wireless-drivers-next.git, thanks.

8b144dedb928 rtlwifi: rtl8192cu: Fix WARNING when calling local_irq_restore() with interrupts enabled

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211215171105.20623-1-Larry.Finger@lwfinger.net/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

