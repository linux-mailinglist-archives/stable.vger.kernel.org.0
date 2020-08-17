Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EBCB246421
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 12:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbgHQKJn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 06:09:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:48922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726685AbgHQKJm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 06:09:42 -0400
Received: from pobox.suse.cz (nat1.prg.suse.com [195.250.132.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47D842067C;
        Mon, 17 Aug 2020 10:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597658981;
        bh=XumW++DamzGKuRx1QT1NZGaJJr+n/YIGVu4xzF/Kcb4=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=InZja3MTWGa2wsGmRCnwjhsRBcxb1707nSDQpQF3rZ+nCwUHpzUpMkOuy7GEZi2Hb
         4aPsbtPjISXfD9zRA+FdZtagsFOElkexr4VIX/sOvXUEUXdCWiyLn5n2rrXMjMk+3t
         ziQGTcBuDcff2Z0RY9eyxcHwGVviUiKj3c7zmhRQ=
Date:   Mon, 17 Aug 2020 12:09:38 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Hans de Goede <hdegoede@redhat.com>
cc:     Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        linux-input@vger.kernel.org, stable@vger.kernel.org,
        Andrea Borgia <andrea@borgia.bo.it>
Subject: Re: [PATCH v3] HID: i2c-hid: Always sleep 60ms after I2C_HID_PWR_ON
 commands
In-Reply-To: <20200811133958.355760-1-hdegoede@redhat.com>
Message-ID: <nycvar.YFH.7.76.2008171209250.27422@cbobk.fhfr.pm>
References: <20200811133958.355760-1-hdegoede@redhat.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 11 Aug 2020, Hans de Goede wrote:

> Before this commit i2c_hid_parse() consists of the following steps:
> 
> 1. Send power on cmd
> 2. usleep_range(1000, 5000)
> 3. Send reset cmd
> 4. Wait for reset to complete (device interrupt, or msleep(100))
> 5. Send power on cmd
> 6. Try to read HID descriptor
> 
> Notice how there is an usleep_range(1000, 5000) after the first power-on
> command, but not after the second power-on command.
> 
> Testing has shown that at least on the BMAX Y13 laptop's i2c-hid touchpad,
> not having a delay after the second power-on command causes the HID
> descriptor to read as all zeros.
> 
> In case we hit this on other devices too, the descriptor being all zeros
> can be recognized by the following message being logged many, many times:
> 
> hid-generic 0018:0911:5288.0002: unknown main item tag 0x0
> 
> At the same time as the BMAX Y13's touchpad issue was debugged,
> Kai-Heng was working on debugging some issues with Goodix i2c-hid
> touchpads. It turns out that these need a delay after a PWR_ON command
> too, otherwise they stop working after a suspend/resume cycle.
> According to Goodix a delay of minimal 60ms is needed.
> 
> Having multiple cases where we need a delay after sending the power-on
> command, seems to indicate that we should always sleep after the power-on
> command.
> 
> This commit fixes the mentioned issues by moving the existing 1ms sleep to
> the i2c_hid_set_power() function and changing it to a 60ms sleep.

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs

