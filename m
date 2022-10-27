Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E600860F5A7
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 12:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234864AbiJ0KqE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 06:46:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234930AbiJ0Kpp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 06:45:45 -0400
Received: from srv6.fidu.org (srv6.fidu.org [IPv6:2a01:4f8:231:de0::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C0D340002
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 03:45:40 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by srv6.fidu.org (Postfix) with ESMTP id 074C5C80091;
        Thu, 27 Oct 2022 12:45:38 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at srv6.fidu.org
Received: from srv6.fidu.org ([127.0.0.1])
        by localhost (srv6.fidu.org [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id OL9TeZMebV1U; Thu, 27 Oct 2022 12:45:37 +0200 (CEST)
Received: from [192.168.178.52] (unknown [24.134.105.141])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: wse@tuxedocomputers.com)
        by srv6.fidu.org (Postfix) with ESMTPSA id 664E1C8008A;
        Thu, 27 Oct 2022 12:45:37 +0200 (CEST)
Message-ID: <d7d5b65d-d2d9-5fc5-c51a-2c2fd5660834@tuxedocomputers.com>
Date:   Thu, 27 Oct 2022 12:45:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v3] ACPI: video: Force backlight native for more TongFang
 devices
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, hdegoede@redhat.com, daniel@ffwll.ch,
        airlied@redhat.com, lenb@kernel.org, rafael.j.wysocki@intel.com
References: <20221026152246.24990-1-wse@tuxedocomputers.com>
 <Y1pdUYkQhifhVUBO@kroah.com>
From:   Werner Sembach <wse@tuxedocomputers.com>
In-Reply-To: <Y1pdUYkQhifhVUBO@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 27.10.22 um 12:28 schrieb Greg KH:
> On Wed, Oct 26, 2022 at 05:22:46PM +0200, Werner Sembach wrote:
>> commit 3dbc80a3e4c55c4a5b89ef207bed7b7de36157b4 upstream.
>>
>> This commit is very different from the upstream commit! It fixes the same
>> issue by adding more quirks, rather then the general fix from the 6.1
>> kernel, because the general fix from the 6.1 kernel is part of a larger
>> refactoring of the backlight code which is not suitable for the stable
>> series.
>>
>> As described in "ACPI: video: Drop NL5x?U, PF4NU1F and PF5?U??
>> acpi_backlight=native quirks" (10212754a0d2) the upstream commit "ACPI:
>> video: Make backlight class device registration a separate step (v2)"
>> (3dbc80a3e4c5) makes these quirks unnecessary. However as mentioned in this
>> bugtracker ticket https://bugzilla.kernel.org/show_bug.cgi?id=215683#c17
>> the upstream fix is part of a larger patchset that is overall too complex
>> for stable.
>>
>> The TongFang GKxNRxx, GMxNGxx, GMxZGxx, and GMxRGxx / TUXEDO
>> Stellaris/Polaris Gen 1-4, have the same problem as the Clevo NL5xRU and
>> NL5xNU / TUXEDO Aura 15 Gen1 and Gen2:
>> They have a working native and video interface for screen backlight.
>> However the default detection mechanism first registers the video interface
>> before unregistering it again and switching to the native interface during
>> boot. This results in a dangling SBIOS request for backlight change for
>> some reason, causing the backlight to switch to ~2% once per boot on the
>> first power cord connect or disconnect event. Setting the native interface
>> explicitly circumvents this buggy behaviour by avoiding the unregistering
>> process.
>>
>> Reviewed-by: Hans de Goede <hdegoede@redhat.com>
>> Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
>> ---
>>   drivers/acpi/video_detect.c | 64 +++++++++++++++++++++++++++++++++++++
>>   1 file changed, 64 insertions(+)
> 
> Now queued up, thanks.
Thanks for bearing my learning process ^^
> 
> greg k-h
