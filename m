Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AFF45FE174
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 20:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231897AbiJMSkN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 14:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232018AbiJMSjs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 14:39:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7D5E17FD71;
        Thu, 13 Oct 2022 11:37:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE05AB82057;
        Thu, 13 Oct 2022 17:59:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 613D9C4347C;
        Thu, 13 Oct 2022 17:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665683948;
        bh=Spdv+2lrJkBqhfsnk88zlDhBAUgIqFGkLfllL7IN2sg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MIaa8bpmYCGfdVNampNXunlKxIHQPlzD2kWR7n8ok/EkhHLoIuONPR/onhk7QIIIv
         ctZY4dnYUOnywKvjsz2bAXwUzG7ZM+bmH0ZBq4VSh9T9rI+IG1PjhzXa78/ewVRq+R
         K0RQ7xo5HX0Pn8CucEX6EFBwmeWgm/Ki89KHJtOX52EOA+QdzsGgRHSMxibYbwGH1D
         +DwXV5F9ZAQ+K+V64W/u633MX2Ca7yuhNi/NRzykrHL4X4Mf3+VaVGpuWV+ywn5jRQ
         DfOd1TUmND2CpaZUj57BYTqgvgx/DgtkCyMoOduZjDyTCg+diu1OmnhRq4TvFWzSj1
         nrY3igcBcs9GQ==
Date:   Thu, 13 Oct 2022 13:59:07 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Arvid Norlander <lkml@vorpal.se>, rafael@kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 06/10] ACPI: video: Change
 disable_backlight_sysfs_if quirks to acpi_backlight=native
Message-ID: <Y0hR65HUnNmGz1B4@sashalap>
References: <20221009235746.1232129-1-sashal@kernel.org>
 <20221009235746.1232129-6-sashal@kernel.org>
 <f634ad7f-92f0-ee22-8a9a-51e1852f6826@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <f634ad7f-92f0-ee22-8a9a-51e1852f6826@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 10, 2022 at 09:36:53AM +0200, Hans de Goede wrote:
>Hi,
>
>On 10/10/22 01:57, Sasha Levin wrote:
>> From: Hans de Goede <hdegoede@redhat.com>
>>
>> [ Upstream commit c5b94f5b7819348c59f9949b2b75c341a114cdd4 ]
>>
>> Some Toshibas have a broken acpi-video interface for brightness control
>> and need a special firmware call on resume to turn the panel back on.
>> So far these have been using the disable_backlight_sysfs_if workaround
>> to deal with this.
>>
>> The recent x86/acpi backlight refactoring has broken this workaround:
>> 1. This workaround relies on acpi_video_get_backlight_type() returning
>>    acpi_video so that the acpi_video code actually runs; and
>> 2. this relies on the actual native GPU driver to offer the sysfs
>>    backlight interface to userspace.
>>
>> After the refactor this breaks since the native driver will no
>> longer register its backlight-device if acpi_video_get_backlight_type()
>> does not return native and making it return native breaks 1.
>>
>> Keeping the acpi_video backlight handling on resume active, while not
>> using it to set the brightness, is necessary because it does a _BCM
>> call on resume which is necessary to turn the panel back on on resume.
>>
>> Looking at the DSDT shows that this _BCM call results in a Toshiba
>> HCI_SET HCI_LCD_BRIGHTNESS call, which turns the panel back on.
>>
>> This kind of special vendor specific handling really belongs in
>> the vendor specific acpi driver. An earlier patch in this series
>> modifies toshiba_acpi to make the necessary HCI_SET call on resume
>> on affected models.
>>
>> With toshiba_acpi taking care of the HCI_SET call on resume,
>> the acpi_video code no longer needs to call _BCM on resume.
>>
>> So instead of using the (now broken) disable_backlight_sysfs_if
>> workaround, simply setting acpi_backlight=native to disable
>> the broken apci-video interface is sufficient fix things now.
>>
>> After this there are no more users of the disable_backlight_sysfs_if
>> flag and as discussed above the flag also no longer works as intended,
>> so remove the disable_backlight_sysfs_if flag entirely.
>>
>> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> Tested-by: Arvid Norlander <lkml@vorpal.se>
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>This patch goes hand in hand with:
>
>commit 3cb1f40dfdc3 ("drivers/platform: toshiba_acpi: Call HCI_PANEL_POWER_ON on resume on some models")
>
>and without that commit also being present it will cause a regression on
>the quirked Toshiba models.
>
>This really is part of the big x86/ACPI backlight handling refactor which
>has landed in 6.1 and as such is not intended for older kernels, please
>drop this from the stable series.

Will do, thanks!

-- 
Thanks,
Sasha
