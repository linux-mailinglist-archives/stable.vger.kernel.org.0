Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 257BB4D87F8
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 16:22:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237681AbiCNPXq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 11:23:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231531AbiCNPXp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 11:23:45 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B736D140D7;
        Mon, 14 Mar 2022 08:22:34 -0700 (PDT)
Received: from ip4d144895.dynamic.kabel-deutschland.de ([77.20.72.149] helo=[192.168.66.200]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1nTmWm-0006nk-I1; Mon, 14 Mar 2022 16:22:32 +0100
Message-ID: <a8a62dd3-fe45-9745-f332-9815ecef52f7@leemhuis.info>
Date:   Mon, 14 Mar 2022 16:22:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] PCI: xgene: Revert "PCI: xgene: Use inbound resources for
 setup"
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kernel-team@android.com, Rob Herring <robh@kernel.org>,
        Toan Le <toan@os.amperecomputing.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        =?UTF-8?Q?Krzysztof_Wilczy=c5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?Q?St=c3=a9phane_Graber?= <stgraber@ubuntu.com>,
        dann frazier <dann.frazier@canonical.com>,
        stable@vger.kernel.org
References: <20220314144429.1947610-1-maz@kernel.org>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <20220314144429.1947610-1-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1647271354;1d5d7c18;
X-HE-SMSGID: 1nTmWm-0006nk-I1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 14.03.22 15:44, Marc Zyngier wrote:
> Commit 6dce5aa59e0b ("PCI: xgene: Use inbound resources for setup")
> killed PCIe on my XGene-1 box (a Mustang board). The machine itself
> is still alive, but half of its storage (over NVMe) is gone, and the
> NVMe driver just times out.
> 
> Note that this machine boots with a device tree provided by the
> UEFI firmware (2016 vintage), which could well be non conformant
> with the spec, hence the breakage.
> 
> With the patch reverted, the box boots 5.17-rc8 with flying colors.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: Rob Herring <robh@kernel.org>
> Cc: Toan Le <toan@os.amperecomputing.com>
> Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> Cc: Krzysztof Wilczyński <kw@linux.com>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Stéphane Graber <stgraber@ubuntu.com>
> Cc: dann frazier <dann.frazier@canonical.com>
> Cc: Thorsten Leemhuis <regressions@leemhuis.info>

Feel free to drop me there. But could you please instead add a 'Link:'
tag pointing to the report for anyone wanting to look into the backstory
in the future, as explained in
'Documentation/process/submitting-patches.rst' and
'Documentation/process/5.Posting.rst'? E.g. like this:

"Link: https://lore.kernel.org/r/Yf2wTLjmcRj%2BAbDv@xps13.dannf/"

FWIW, I care for another reason: I'm tracking this regression with
regzbot, my regression tracking bot. Proper "Link:" tags allow the bot
to connect regression reports with fixes being posted or applied to
resolve the regression -- which makes regression tracking a whole lot
easier.

While at it, let me tell regzbot about this thread:
#regzbot ^backmonitor:
https://lore.kernel.org/r/Yf2wTLjmcRj%2BAbDv@xps13.dannf/

> Cc: stable@vger.kernel.org>

Typo, missing a "<"

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)

P.S.: As the Linux kernel's regression tracker I'm getting a lot of
reports on my table. I can only look briefly into most of them and lack
knowledge about most of the areas they concern. I thus unfortunately
will sometimes get things wrong or miss something important. I hope
that's not the case here; if you think it is, don't hesitate to tell me
in a public reply, it's in everyone's interest to set the public record
straight.

-- 
Additional information about regzbot:

If you want to know more about regzbot, check out its web-interface, the
getting start guide, and the references documentation:

https://linux-regtracking.leemhuis.info/regzbot/
https://gitlab.com/knurd42/regzbot/-/blob/main/docs/getting_started.md
https://gitlab.com/knurd42/regzbot/-/blob/main/docs/reference.md

The last two documents will explain how you can interact with regzbot
yourself if your want to.

Hint for reporters: when reporting a regression it's in your interest to
CC the regression list and tell regzbot about the issue, as that ensures
the regression makes it onto the radar of the Linux kernel's regression
tracker -- that's in your interest, as it ensures your report won't fall
through the cracks unnoticed.

Hint for developers: you normally don't need to care about regzbot once
it's involved. Fix the issue as you normally would, just remember to
include 'Link:' tag in the patch descriptions pointing to all reports
about the issue. This has been expected from developers even before
regzbot showed up for reasons explained in
'Documentation/process/submitting-patches.rst' and
'Documentation/process/5.Posting.rst'.
