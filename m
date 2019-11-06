Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88214F1FFD
	for <lists+stable@lfdr.de>; Wed,  6 Nov 2019 21:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727629AbfKFUis (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Nov 2019 15:38:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:60000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727351AbfKFUir (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Nov 2019 15:38:47 -0500
Received: from pobox.suse.cz (prg-ext-pat.suse.com [213.151.95.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77080214D8;
        Wed,  6 Nov 2019 20:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573072727;
        bh=/ip/yTpASh3/i7Ii2zK/oWBfRPe6FPtpxsKhn6c5/B8=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=O9eq5lWvdgtPR3a0MKtz22DQDnjTDl9dluxnE/bqdBnT8LOM7nqXgB0p3E7j8+lD1
         iPPWZS8wfUKCUReyumpeDTaE2H3XaTBQNsAGzMY/UJj7Wn8RVSKowHllL+frpjStOJ
         5/X5R8AR8i3+b4HMrYYUcPhHfzqvr1Cy4f7p7Y2s=
Date:   Wed, 6 Nov 2019 21:38:43 +0100 (CET)
From:   Jiri Kosina <jikos@kernel.org>
To:     "Gerecke, Jason" <killertofu@gmail.com>
cc:     linux-input@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Ping Cheng <pinglinux@gmail.com>,
        Aaron Armstrong Skomra <skomra@gmail.com>,
        stable@vger.kernel.org, Jason Gerecke <jason.gerecke@wacom.com>,
        Aaron Armstrong Skomra <aaron.skomra@wacom.com>
Subject: Re: [PATCH] HID: wacom: generic: Treat serial number and related
 fields as unsigned
In-Reply-To: <20191106195946.552879-1-jason.gerecke@wacom.com>
Message-ID: <nycvar.YFH.7.76.1911062138270.1799@cbobk.fhfr.pm>
References: <20191106195946.552879-1-jason.gerecke@wacom.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 6 Nov 2019, Gerecke, Jason wrote:

> From: Jason Gerecke <killertofu@gmail.com>
> 
> The HID descriptors for most Wacom devices oddly declare the serial
> number and other related fields as signed integers. When these numbers
> are ingested by the HID subsystem, they are automatically sign-extended
> into 32-bit integers. We treat the fields as unsigned elsewhere in the
> kernel and userspace, however, so this sign-extension causes problems.
> In particular, the sign-extended tool ID sent to userspace as ABS_MISC
> does not properly match unsigned IDs used by xf86-input-wacom and libwacom.
> 
> We introduce a function 'wacom_s32tou' that can undo the automatic sign
> extension performed by 'hid_snto32'. We call this function when processing
> the serial number and related fields to ensure that we are dealing with
> and reporting the unsigned form. We opt to use this method rather than
> adding a descriptor fixup in 'wacom_hid_usage_quirk' since it should be
> more robust in the face of future devices.
> 
> Ref: https://github.com/linuxwacom/input-wacom/issues/134
> Fixes: f85c9dc678 ("HID: wacom: generic: Support tool ID and additional tool types")
> CC: <stable@vger.kernel.org> # v4.10+
> Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
> Reviewed-by: Aaron Armstrong Skomra <aaron.skomra@wacom.com>

Applied to for-5.4/upstream-fixes.

-- 
Jiri Kosina
SUSE Labs

