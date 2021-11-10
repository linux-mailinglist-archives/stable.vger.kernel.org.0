Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8F044BD87
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 10:03:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbhKJJFo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 04:05:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:45520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230461AbhKJJFl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 04:05:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03441610CF;
        Wed, 10 Nov 2021 09:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636534958;
        bh=ORDhAEl6GvObkHycfaW2s5XoI16XYZX+9LCUa21opIc=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=T3DGFyx/ifmXJCkSCZkmSf0O/qN4kEcPPxVDFHGoDES20Glh40zKRiF9yCDSSDXj7
         mCXa4XMrXGRu1ROEDkc65a8IdPCi05ILaE4nS7so7X6ydecUIJWBPX0iO6ePTazUAl
         hcdrL9+R2yDZqQgVPLMrq7lsx0Q9uNHWS24w0XRTvvKy6rChT2oYaEIKbKOUK2u7rD
         2dAwDVI+aFKHgwICwLJzFYJQdEQlI2vbNwA3H1FHt+v0NL2Mo637BXbxLIf6qLqRoD
         kdnPjNzh8tCsn4VkO6O6fcmJh3vX2ff65ADFmuGj9O2HpGgCVcolrChWYHeCof8eop
         AsSLAJQGqOezw==
Date:   Wed, 10 Nov 2021 10:02:35 +0100 (CET)
From:   Jiri Kosina <jikos@kernel.org>
To:     Jason Gerecke <killertofu@gmail.com>
cc:     linux-input@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Ping Cheng <pinglinux@gmail.com>,
        Aaron Armstrong Skomra <skomra@gmail.com>,
        Joshua Dickens <Joshua@Joshua-Dickens.com>,
        Jason Gerecke <jason.gerecke@wacom.com>,
        Joshua Dickens <joshua.dickens@wacom.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] HID: wacom: Use "Confidence" flag to prevent reporting
 invalid contacts
In-Reply-To: <20211109003101.425207-1-jason.gerecke@wacom.com>
Message-ID: <nycvar.YFH.7.76.2111101002260.12554@cbobk.fhfr.pm>
References: <20211109003101.425207-1-jason.gerecke@wacom.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 8 Nov 2021, Jason Gerecke wrote:

> The HID descriptor of many of Wacom's touch input devices include a
> "Confidence" usage that signals if a particular touch collection contains
> useful data. The driver does not look at this flag, however, which causes
> even invalid contacts to be reported to userspace. A lucky combination of
> kernel event filtering and device behavior (specifically: contact ID 0 ==
> invalid, contact ID >0 == valid; and order all data so that all valid
> contacts are reported before any invalid contacts) spare most devices from
> any visibly-bad behavior.
> 
> The DTH-2452 is one example of an unlucky device that misbehaves. It uses
> ID 0 for both the first valid contact and all invalid contacts. Because
> we report both the valid and invalid contacts, the kernel reports that
> contact 0 first goes down (valid) and then goes up (invalid) in every
> report. This causes ~100 clicks per second simply by touching the screen.
> 
> This patch inroduces new `confidence` flag in our `hid_data` structure.
> The value is initially set to `true` at the start of a report and can be
> set to `false` if an invalid touch usage is seen.
> 
> Link: https://github.com/linuxwacom/input-wacom/issues/270
> Fixes: f8b6a74719b5 ("HID: wacom: generic: Support multiple tools per report")
> Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
> Tested-by: Joshua Dickens <joshua.dickens@wacom.com>
> Cc: <stable@vger.kernel.org>

Applied, thanks Jason.

-- 
Jiri Kosina
SUSE Labs

