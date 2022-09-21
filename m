Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 756525E53F8
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 21:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbiIUTv7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 15:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiIUTv5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 15:51:57 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B8C58E988;
        Wed, 21 Sep 2022 12:51:57 -0700 (PDT)
Received: from zn.tnic (p200300ea9733e77f329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e77f:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 6D68D1EC058B;
        Wed, 21 Sep 2022 21:51:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1663789911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=8DJCtm+AGQW+D9iEfDkNEgfP/xvG+kPWvU5Z7Kgh+Pg=;
        b=Zn2ZhEzdpvYtf90dGnrIHXcsjl0swnVCCbqksE8wDq6uZ6VCOOHXGS8io3JvD50Oo3t14b
        GpmL/JJFiGwIVB2K0s54P7sfjRp+uE7AsNdJT0UTU7Wnt7TR86cO345jLw0lTwEawVT6KX
        aPvplQTwkYIbg6i3gvCFzjZ5AoFJY78=
Date:   Wed, 21 Sep 2022 21:51:51 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     K Prateek Nayak <kprateek.nayak@amd.com>,
        linux-kernel@vger.kernel.org, rafael@kernel.org, lenb@kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org,
        dave.hansen@linux.intel.com, tglx@linutronix.de, andi@lisas.de,
        puwen@hygon.cn, mario.limonciello@amd.com, peterz@infradead.org,
        rui.zhang@intel.com, gpiccoli@igalia.com,
        daniel.lezcano@linaro.org, ananth.narayan@amd.com,
        gautham.shenoy@amd.com, Calvin Ong <calvin.ong@amd.com>,
        stable@vger.kernel.org, regressions@lists.linux.dev
Subject: Re: [PATCH] ACPI: processor_idle: Skip dummy wait for processors
 based on the Zen microarchitecture
Message-ID: <YytrV2UMah8555+s@zn.tnic>
References: <20220921063638.2489-1-kprateek.nayak@amd.com>
 <2b6143b6-9db4-05bc-1e8d-c5d129126f99@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2b6143b6-9db4-05bc-1e8d-c5d129126f99@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 21, 2022 at 07:15:07AM -0700, Dave Hansen wrote:
> In the end, the delay is because of buggy, circa 2006 chipsets?  So, we
> use a CPU vendor specific check to approximate that the chipset is
> recent and not affected by the bug?  If so, is there no better way to
> check for a newer chipset than this?

So I did some git archeology but that particular addition is in some
conglomerate, glued-together patch from 2007 which added the cpuidle
tree:

commit 4f86d3a8e297205780cca027e974fd5f81064780
Author: Len Brown <len.brown@intel.com>
Date:   Wed Oct 3 18:58:00 2007 -0400

    cpuidle: consolidate 2.6.22 cpuidle branch into one patch


so the most precise check here should be to limit that dummy read to
that Intel chipset which needed it. Damned if I knew how to figure out
which...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
