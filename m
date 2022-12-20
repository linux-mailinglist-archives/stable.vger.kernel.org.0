Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F908651714
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 01:12:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiLTAMa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 19:12:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiLTAM3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 19:12:29 -0500
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5D1AB26;
        Mon, 19 Dec 2022 16:12:27 -0800 (PST)
Received: (Authenticated sender: m@thi.eu.com)
        by mail.gandi.net (Postfix) with ESMTPSA id E6D6020003;
        Tue, 20 Dec 2022 00:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mathieu.digital;
        s=gm1; t=1671495145;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=TsRN3X06hRa3000BPCxKDTLmss5u2rr0V8HVxqCDmD8=;
        b=YrHJ1Bl1k3yFLCtzsLX3p51PbB7pYVYJt+2c3MwAvQYfFfovC0gJdFcJZHNnHqHa47WLSO
        0yv/hop+yO+sUnFcTSQOjLI7U1Q7CGVdAAS+bYmu7xwzPXX2kgd2HKVQGkzt/oMpvAiIHN
        FbFow6YsedOfuY6pdk1oEMErk9thHgfzEoHB2jVJhVv+WNxUuYs/YKMFod+4bnXnBPdR55
        CMj+SUcJjOwkxSSkshnsVKoqxWliWHUlbtFfDjzc80VWto2bxC0hQo54lwRm+qXfMzU17J
        TAqiucbCfDnH0OAutnNBJbLD+gar5xSBd2GnRtokcSd1P+LXsibSH59PWd8IMA==
Received: by paranoid-android.localdomain (Postfix, from userid 1000)
        id 3F98F40090F40; Tue, 20 Dec 2022 01:12:23 +0100 (CET)
Date:   Tue, 20 Dec 2022 01:12:23 +0100
From:   Mathieu Chouquet-Stringer <me@mathieu.digital>
To:     stable@vger.kernel.org
Cc:     rafael.j.wysocki@intel.com, linux-rtc@vger.kernel.org,
        linux-acpi@vger.kernel.org, rafael@kernel.org,
        mgorman@techsingularity.net, gregkh@linuxfoundation.org,
        alexandre.belloni@bootlin.com
Subject: Fix for rtc driver boot breakage in 6.0.y
Message-ID: <Y6D958DeurSuoCuY@paranoid-android>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

	Hello stable team and Greg,

There are 3 commits in Linus' tree for the rtc driver which should be
merged against stable 6.0.y (they're already in 6.1 / 6.1.y).

Without the first two, a x86-64 machine might panic during boot (Mel saw
a 50% chance of panic at boot - 5 out of 10 tries - and my experience
was identical).
https://lore.kernel.org/linux-acpi/20221010141630.zfzi7mk7zvnmclzy@techsingularity.net/

And after applying the first two, the kernel will not compile anymore
on non ACPI platform, so you need a third one.

The first two commits:

commit 4919d3eb2ec0ee364f7e3cf2d99646c1b224fae8
Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Date:   Wed Oct 12 20:07:01 2022 +0200

    rtc: cmos: Fix event handler registration ordering issue

commit 0782b66ed2fbb035dda76111df0954515e417b24
Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Date:   Tue Oct 18 18:09:31 2022 +0200

    rtc: cmos: Fix wake alarm breakage

And the third one:

commit db4e955ae333567dea02822624106c0b96a2f84f
Author: Alexandre Belloni <alexandre.belloni@bootlin.com>
Date:   Tue Oct 18 22:35:11 2022 +0200

    rtc: cmos: fix build on non-ACPI platforms

Cheers,
-- 
Mathieu Chouquet-Stringer                             me@mathieu.digital
            The sun itself sees not till heaven clears.
	             -- William Shakespeare --
