Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB18278597
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 13:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727290AbgIYLPQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 07:15:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:35974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727132AbgIYLPQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 07:15:16 -0400
Received: from pobox.suse.cz (nat1.prg.suse.com [195.250.132.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02CEF221E5;
        Fri, 25 Sep 2020 11:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601032515;
        bh=pJom88A0bi1RdO+KCgx4Zz7zv2oiMPcqlDl14hZcJTc=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=ZRFi3B3peB0lwaeLfeYuy8+6ToP0Xp1TV4/k6i8uICo2upYIGmp4lN/s8/VLRFQgr
         6oG6E8kMg1LWujltFG9o3SuOS3RtRRTYhffd/S7BnE7Fp2iV2ggXngK7uERN+YSeKj
         n+OteMPYYjpgZArK0bfh7o2KNyqiQnT5CFY+2LRc=
Date:   Fri, 25 Sep 2020 13:15:10 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     "Gerecke, Jason" <killertofu@gmail.com>
cc:     linux-input@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Ping Cheng <pinglinux@gmail.com>,
        Aaron Armstrong Skomra <skomra@gmail.com>,
        Jason Gerecke <jason.gerecke@wacom.com>,
        stable@vger.kernel.org, Ping Cheng <ping.cheng@wacom.com>
Subject: Re: [PATCH] HID: wacom: Avoid entering wacom_wac_pen_report for pad
 / battery
In-Reply-To: <20200923201456.25912-1-jason.gerecke@wacom.com>
Message-ID: <nycvar.YFH.7.76.2009251314520.3336@cbobk.fhfr.pm>
References: <20200923201456.25912-1-jason.gerecke@wacom.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 23 Sep 2020, Gerecke, Jason wrote:

> From: Jason Gerecke <jason.gerecke@wacom.com>
> 
> It has recently been reported that the "heartbeat" report from devices
> like the 2nd-gen Intuos Pro (PTH-460, PTH-660, PTH-860) or the 2nd-gen
> Bluetooth-enabled Intuos tablets (CTL-4100WL, CTL-6100WL) can cause the
> driver to send a spurious BTN_TOUCH=0 once per second in the middle of
> drawing. This can result in broken lines while drawing on Chrome OS.
> 
> The source of the issue has been traced back to a change which modified
> the driver to only call `wacom_wac_pad_report()` once per report instead
> of once per collection. As part of this change, pad-handling code was
> removed from `wacom_wac_collection()` under the assumption that the
> `WACOM_PEN_FIELD` and `WACOM_TOUCH_FIELD` checks would not be satisfied
> when a pad or battery collection was being processed.
> 
> To be clear, the macros `WACOM_PAD_FIELD` and `WACOM_PEN_FIELD` do not
> currently check exclusive conditions. In fact, most "pad" fields will
> also appear to be "pen" fields simply due to their presence inside of
> a Digitizer application collection. Because of this, the removal of
> the check from `wacom_wac_collection()` just causes pad / battery
> collections to instead trigger a call to `wacom_wac_pen_report()`
> instead. The pen report function in turn resets the tip switch state
> just prior to exiting, resulting in the observed BTN_TOUCH=0 symptom.
> 
> To correct this, we restore a version of the `WACOM_PAD_FIELD` check
> in `wacom_wac_collection()` and return early. This effectively prevents
> pad / battery collections from being reported until the very end of the
> report as originally intended.
> 
> Fixes: d4b8efeb46d9 ("HID: wacom: generic: Correct pad syncing")
> Cc: stable@vger.kernel.org # v4.17+
> Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
> Reviewed-by: Ping Cheng <ping.cheng@wacom.com>
> Tested-by: Ping Cheng <ping.cheng@wacom.com>

Applied.

-- 
Jiri Kosina
SUSE Labs

