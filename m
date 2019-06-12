Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6E4429D1
	for <lists+stable@lfdr.de>; Wed, 12 Jun 2019 16:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732578AbfFLOrv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jun 2019 10:47:51 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:33315 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732557AbfFLOrv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jun 2019 10:47:51 -0400
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1hb4XT-0006mN-FT; Wed, 12 Jun 2019 16:47:47 +0200
Date:   Wed, 12 Jun 2019 16:47:47 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     Soeren Moch <smoch@web.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, tglx@linutronix.de
Subject: Re: [PATCH] Revert "usb: core: remove local_irq_save() around
 ->complete() handler"
Message-ID: <20190612144747.mf7hwunsl2zi3uxo@linutronix.de>
References: <fb64b378-57a1-19f4-0fd2-1689fc3d8540@web.de>
 <Pine.LNX.4.44L0.1906121033550.1557-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1906121033550.1557-100000@iolanthe.rowland.org>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2019-06-12 10:38:11 [-0400], Alan Stern wrote:
> > 
> > When stopping hostapd after it hangs:
> > [  903.504475] ieee80211 phy0: rt2x00queue_flush_queue: Warning - Queue
> > 14 failed to flush
> 
> Instead of reverting the original commit, can you prevent the problem 
> by adding local_irq_save() and local_irq_restore() to the URB 
> completion routines in that wireless driver?
> 
> Probably people who aren't already pretty familiar with the driver code
> won't easily be able to locate the race.  Still, a little overkill may
> be an acceptable solution.

Not from RT point of view because you do
	local_irq_save() -> spin_lock()

but it might be worth checking if the local_irq_save() within that
wireless driver avoids the race or not.

> Alan Stern

Sebastian
