Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8B73CB979
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 17:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237326AbhGPPPn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 11:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233094AbhGPPPn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Jul 2021 11:15:43 -0400
Received: from srv6.fidu.org (srv6.fidu.org [IPv6:2a01:4f8:231:de0::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46704C06175F
        for <stable@vger.kernel.org>; Fri, 16 Jul 2021 08:12:47 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by srv6.fidu.org (Postfix) with ESMTP id AD837C80092;
        Fri, 16 Jul 2021 17:12:44 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at srv6.fidu.org
Received: from srv6.fidu.org ([127.0.0.1])
        by localhost (srv6.fidu.org [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id vuNQgeqHHRye; Fri, 16 Jul 2021 17:12:44 +0200 (CEST)
Received: from [IPv6:2003:e3:7f20:9b00:b399:8628:5a95:572c] (p200300E37F209B00B39986285a95572c.dip0.t-ipconnect.de [IPv6:2003:e3:7f20:9b00:b399:8628:5a95:572c])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: wse@tuxedocomputers.com)
        by srv6.fidu.org (Postfix) with ESMTPSA id 38D95C8006F;
        Fri, 16 Jul 2021 17:12:44 +0200 (CEST)
Subject: Re: [SRU][H][PATCH v2 1/1] usb: pci-quirks: disable D3cold on xhci
 suspend for s2idle on AMD Renoir
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     kernel-team@lists.ubuntu.com,
        Mario Limonciello <mario.limonciello@amd.com>,
        Prike Liang <Prike.Liang@amd.com>,
        stable <stable@vger.kernel.org>
References: <20210716104010.4889-1-wse@tuxedocomputers.com>
 <20210716104010.4889-2-wse@tuxedocomputers.com> <YPGAq1zdem2QVTsb@kroah.com>
From:   Werner Sembach <wse@tuxedocomputers.com>
Message-ID: <b5ba1134-d557-565c-ba45-556984a66e7b@tuxedocomputers.com>
Date:   Fri, 16 Jul 2021 17:12:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YPGAq1zdem2QVTsb@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: de-DE
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Am 16.07.21 um 14:50 schrieb Greg Kroah-Hartman:
> On Fri, Jul 16, 2021 at 12:40:10PM +0200, Werner Sembach wrote:
>> From: Mario Limonciello <mario.limonciello@amd.com>
>>
>> BugLink: https://bugs.launchpad.net/bugs/1936583
>>
>> The XHCI controller is required to enter D3hot rather than D3cold for AMD
>> s2idle on this hardware generation.
>>
>> Otherwise, the 'Controller Not Ready' (CNR) bit is not being cleared by
>> host in resume and eventually this results in xhci resume failures during
>> the s2idle wakeup.
>>
>> Link: https://lore.kernel.org/linux-usb/1612527609-7053-1-git-send-email-Prike.Liang@amd.com/
>> Suggested-by: Prike Liang <Prike.Liang@amd.com>
>> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
>> Cc: stable <stable@vger.kernel.org> # 5.11+
>> Link: https://lore.kernel.org/r/20210527154534.8900-1-mario.limonciello@amd.com
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> (cherry picked from commit d1658268e43980c071dbffc3d894f6f6c4b6732a)
>> Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
>> ---
>>  drivers/usb/host/xhci-pci.c | 7 ++++++-
>>  drivers/usb/host/xhci.h     | 1 +
>>  2 files changed, 7 insertions(+), 1 deletion(-)
>>
> Any reason you resent us a patch that is already in a stable release?
>
> And why not just use the stable kernel trees as-is?  Why attempt to
> cherry-pick random portions of them?
>
> thanks,
>
> greg k-h

I didn't add the mailing list as recipent for my last replies so here again:

I only checked the Ubuntu 5.11 tree where the patch is actually missing.

The 5.8 kernel has other issues because of outdated amdgpu, that's why we never checked the 5.4 kernel.

Testing for 5.4: often hangs on boot before display manager shows up

5.4 + amdgpu-dkms from here: https://www.amd.com/en/support/kb/release-notes/rn-amdgpu-unified-linux-21-20 : Hang on
boot issue gone, but does not suspend anymore, and has graphic glitches.

Should I add these findings to the SRU?

