Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3821A819F
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 17:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436866AbgDNPLC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 11:11:02 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:48379 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2436821AbgDNPIa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 11:08:30 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1586876910; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=3Eu+2EsqIxX4Ri9OtZXYaWwduDJVg0YfAuL8SNXYRlM=;
 b=LNaOpEoVgnogtYgv5eRFPGQvbcjdZNa03czHzeM5/0ZjDi82PCjaRhRqfWlJw69EMVRpK7+d
 3AjzBAAmoxRAX9/3MsxaCAjjVb8162wq7kI5VXA0eIDJTZ75ceIWG7sHaTE/avgdQKsVyRxJ
 UuNELHibkAofjNG6kx9lweD10fA=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e95d1ed.7fdb720ae8b8-smtp-out-n04;
 Tue, 14 Apr 2020 15:08:29 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 586F4C433CB; Tue, 14 Apr 2020 15:08:29 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 62B80C4478C;
        Tue, 14 Apr 2020 15:08:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 62B80C4478C
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] b43legacy: Fix case where channel status is corrupted
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200407190043.1686-1-Larry.Finger@lwfinger.net>
References: <20200407190043.1686-1-Larry.Finger@lwfinger.net>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Stable <stable@vger.kernel.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20200414150829.586F4C433CB@smtp.codeaurora.org>
Date:   Tue, 14 Apr 2020 15:08:29 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Larry Finger <Larry.Finger@lwfinger.net> wrote:

> This patch fixes commit 75388acd0cd8 ("add mac80211-based driver for
> legacy BCM43xx devices")
> 
> In https://bugzilla.kernel.org/show_bug.cgi?id=207093, a defect in
> b43legacy is reported. Upon testing, thus problem exists on PPC and
> X86 platforms, is present in the oldest kernel tested (3.2), and
> has been present in the driver since it was first added to the kernel.
> 
> The problem is a corrupted channel status received from the device.
> Both the internal card in a PowerBook G4 and the PCMCIA version
> (Broadcom BCM4306 with PCI ID 14e4:4320) have the problem. Only Rev, 2
> (revision 4 of the 802.11 core) of the chip has been tested. No other
> devices using b43legacy are available for testing.
> 
> Various sources of the problem were considered. Buffer overrun and
> other sources of corruption within the driver were rejected because
> the faulty channel status is always the same, not a random value.
> It was concluded that the faulty data is coming from the device, probably
> due to a firmware bug. As that source is not available, the driver
> must take appropriate action to recover.
> 
> At present, the driver reports the error, and them continues to process
> the bad packet. This is believed that to be a mistake, and the correct
> action is to drop the correpted packet.
> 
> Fixes: 75388acd0cd8 ("add mac80211-based driver for legacy BCM43xx devices")
> Cc: Stable <stable@vger.kernel.org>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Reported-and-tested by: F. Erhard <erhard_f@mailbox.org>

Patch applied to wireless-drivers-next.git, thanks.

ec4d3e3a0545 b43legacy: Fix case where channel status is corrupted

-- 
https://patchwork.kernel.org/patch/11478883/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
