Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7BF6891BD
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 09:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232622AbjBCIN2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 03:13:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232405AbjBCINB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 03:13:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51BDF953D7
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 00:12:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DFDAF61E1B
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 08:12:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C83C9C433EF;
        Fri,  3 Feb 2023 08:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675411928;
        bh=Aidqrb56v1GxyIB+bcS6ZfcBfwjSRuhe9XFxKmshCeY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fo0KQZM3hKVCyTe2IsDvKORsDmp4BMJMFZBh51JAHoApLQVmaArtrCc83wAeSIAa7
         q3H+lACf5V7kXmJJVgi8NLedFbfUHMimE7l/npdpBLqpHBgzb+7hKfUjybOKMZkSPs
         U20rSazxDTokkUN2KJB0FBY/AeMKKaP+x5Q8VgLs=
Date:   Fri, 3 Feb 2023 09:12:04 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc:     stable@vger.kernel.org, sashal@kernel.org, x86@kernel.org,
        kernel@gpiccoli.net, kernel-dev@igalia.com,
        Dave Hansen <dave.hansen@intel.com>,
        K Prateek Nayak <kprateek.nayak@amd.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Mario Limonciello <mario.limonciello@amd.com>
Subject: Re: [PATCH 5.10 / 5.15] ACPI: processor idle: Practically limit
 "Dummy wait" workaround to old Intel systems
Message-ID: <Y9zB1LYDB+EMTr/L@kroah.com>
References: <20230201230248.1372903-1-gpiccoli@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201230248.1372903-1-gpiccoli@igalia.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 01, 2023 at 08:02:48PM -0300, Guilherme G. Piccoli wrote:
> From: Dave Hansen <dave.hansen@intel.com>
> 
> commit e400ad8b7e6a1b9102123c6240289a811501f7d9 upstream.
> 
> Old, circa 2002 chipsets have a bug: they don't go idle when they are
> supposed to.  So, a workaround was added to slow the CPU down and
> ensure that the CPU waits a bit for the chipset to actually go idle.
> This workaround is ancient and has been in place in some form since
> the original kernel ACPI implementation.
> 
> But, this workaround is very painful on modern systems.  The "inl()"
> can take thousands of cycles (see Link: for some more detailed
> numbers and some fun kernel archaeology).
> 
> First and foremost, modern systems should not be using this code.
> Typical Intel systems have not used it in over a decade because it is
> horribly inferior to MWAIT-based idle.
> 
> Despite this, people do seem to be tripping over this workaround on
> AMD system today.
> 
> Limit the "dummy wait" workaround to Intel systems.  Keep Modern AMD
> systems from tripping over the workaround.  Remotely modern Intel
> systems use intel_idle instead of this code and will, in practice,
> remain unaffected by the dummy wait.
> 
> Reported-by: K Prateek Nayak <kprateek.nayak@amd.com>
> Suggested-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
> Tested-by: K Prateek Nayak <kprateek.nayak@amd.com>
> Link: https://lore.kernel.org/all/20220921063638.2489-1-kprateek.nayak@amd.com/
> Link: https://lkml.kernel.org/r/20220922184745.3252932-1-dave.hansen@intel.com
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
> ---
> 
> 
> Hi folks, seems the intention was to send this to stable [0], so here it is,
> lemme know if you see any issues with that - build tested in 5.10/5.15, also
> it has been running for a while on Steam Deck's kernel.

Now queued up, thanks.

greg k-h
