Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3E24370B36
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 13:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbhEBLEn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 07:04:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:56310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229676AbhEBLEn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 07:04:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E79B6115B;
        Sun,  2 May 2021 11:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619953430;
        bh=qqwzDJRYzQ6J30dnpdOGDI8YQLu6icgdPM+ICRnd7gs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1/vw1sOH92U6IbHN6W9bOfSJLfwE1277l7ljrDyMZcbokw8PEfs/SMCBFwz+w7yvy
         ijjRN9XXMVNDMQxf/dgGvWi18opYRwDE0KRnXcizYE/jDXd3SO8tSd/iRbFyxn6WwB
         5P9KqUMul33v1xt4Pvtx25Z1Ut0MGPW1QPVAr1JA=
Date:   Sun, 2 May 2021 13:03:48 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jari Ruusu <jariruusu@users.sourceforge.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH 5.10 1/2] iwlwifi: Fix softirq/hardirq disabling in
 iwl_pcie_gen2_enqueue_hcmd()
Message-ID: <YI6HFNNvzuHnv5VU@kroah.com>
References: <20210430141910.473289618@linuxfoundation.org>
 <20210430141910.521897363@linuxfoundation.org>
 <608CFF6A.4BC054A3@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <608CFF6A.4BC054A3@users.sourceforge.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 01, 2021 at 10:12:42AM +0300, Jari Ruusu wrote:
> Greg Kroah-Hartman wrote:
> > From: Jiri Kosina <jkosina@suse.cz>
> > 
> > commit e7020bb068d8be50a92f48e36b236a1a1ef9282e upstream.
> > 
> > Analogically to what we did in 2800aadc18a6 ("iwlwifi: Fix softirq/hardirq
> > disabling in iwl_pcie_enqueue_hcmd()"), we must apply the same fix to
> > iwl_pcie_gen2_enqueue_hcmd(), as it's being called from exactly the same
> > contexts.
> 
> Greg,
> This patch and above mentioned earlier patch
> "iwlwifi: Fix softirq/hardirq disabling in iwl_pcie_enqueue_hcmd()",
> upstream commit 2800aadc18a64c96b051bcb7da8a7df7d505db3f, both need
> to be backported to older kernels too.
> 
> I see that there are trivial context rejects if/when you attempt to
> apply those patches to older kernels. Those trivial context rejects
> should not prevent backporting them. Maybe run both patches through sed?
> 
> sed -e s/iwl_txq_space/iwl_queue_space/ -e s/iwl_txq_get_/iwl_pcie_get_/
> 
> My ability test in-tree iwlwifi is limited. I compile out-of-tree
> iwlwifi source, and testing that is limited to pinging mobile-wifi
> router that does not have SIM-card.

If you could provide backported patches to those kernels you think this
is needed to, I can take them directly.  Otherwise running sed isn't
always the easiest thing to do on my end :)

thanks

greg k-h
