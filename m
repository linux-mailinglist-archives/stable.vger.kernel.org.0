Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 741813C2B7B
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 00:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbhGIWxp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 18:53:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:55024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229542AbhGIWxp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 18:53:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C94A661167;
        Fri,  9 Jul 2021 22:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625871061;
        bh=CZ9vlu8ot7ATJ4GSUWvUwNvpFPD/UIkd8XMXHRimFdY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M052tdprrB7wvEJOQ5kG2fdURHDeCOWT+LvS1saTyLNwulfZb9wFSRermniXIjT7m
         j7VFO1id+EYh2OvdVgxhNRj7AYgDy1//S9YtQDgdEhupIjiXX8vhjJhvdni2qRCA7X
         XcTMp2oE5BVbREFJF07405CGPE7GVXG2yywewEtF9kfAN+obp/Tu+BtZtSjDwMJMOS
         teyBVRTDSrUq+QcTzZkqUxAF15FCqJU82b31I5f6CBi0VVWDt0GiC+F28ttpoFP2Ey
         oEY8DuOSX2yk28WUkP2zJyvFyQimAqJ1SJJTiAXOmPc8OMNbwqjUAnEQFWcUceQQtY
         xNxMwPY8liwTw==
Date:   Fri, 9 Jul 2021 18:50:59 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Luke D. Jones" <luke@ljones.dev>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.13 31/59] platform/x86: asus-nb-wmi: Revert
 "add support for ASUS ROG Zephyrus G14 and G15"
Message-ID: <YOjS08Rc6jO4LO/+@sashalap>
References: <20210705152815.1520546-1-sashal@kernel.org>
 <20210705152815.1520546-31-sashal@kernel.org>
 <c8ecb9c4-d6b7-bff5-e070-2504069d57f5@redhat.com>
 <826c32c5-0b00-b3ad-008f-7264bf5254e6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <826c32c5-0b00-b3ad-008f-7264bf5254e6@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 05, 2021 at 07:09:03PM +0200, Hans de Goede wrote:
>Hi,
>
>On 7/5/21 7:08 PM, Hans de Goede wrote:
>> Hi,
>>
>> On 7/5/21 5:27 PM, Sasha Levin wrote:
>>> From: "Luke D. Jones" <luke@ljones.dev>
>>>
>>> [ Upstream commit 28117f3a5c3c8375a3304af76357d5bf9cf30f0b ]
>>>
>>> The quirks added to asus-nb-wmi for the ASUS ROG Zephyrus G14 and G15 are
>>> wrong, they tell the asus-wmi code to use the vendor specific WMI backlight
>>> interface. But there is no such interface on these laptops.
>>>
>>> As a side effect, these quirks stop the acpi_video driver to register since
>>> they make acpi_video_get_backlight_type() return acpi_backlight_vendor,
>>> leaving only the native AMD backlight driver in place, which is the one we
>>> want. This happy coincidence is being replaced with a new quirk in
>>> drivers/acpi/video_detect.c which actually sets the backlight_type to
>>> acpi_backlight_native fixinf this properly. This reverts
>>> commit 13bceda68fb9 ("platform/x86: asus-nb-wmi: add support for ASUS ROG
>>> Zephyrus G14 and G15").
>>>
>>> Signed-off-by: Luke D. Jones <luke@ljones.dev>
>>> Link: https://lore.kernel.org/r/20210419074915.393433-3-luke@ljones.dev
>>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>>
>> Note this should only be cherry-picked if commit 2dfbacc65d1d
>> ("ACPI: video: use native backlight for GA401/GA502/GA503"):
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=2dfbacc65d1d2eae587ccb6b93f6280542641858
>>
>> Is also being cherry-picked, since the quirk added in that commit
>> replaces the quirks which are being reverted here.
>
>p.s.
>
>The same remark also replies to the 5.12 and 5.10 cherry-picks of
>this commit.

I'll take it too, thanks!

-- 
Thanks,
Sasha
