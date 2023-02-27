Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E72E6A4065
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 12:14:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbjB0LOt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Feb 2023 06:14:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbjB0LOr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Feb 2023 06:14:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04D303C38;
        Mon, 27 Feb 2023 03:14:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6EDFB80CAD;
        Mon, 27 Feb 2023 11:14:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1638DC433D2;
        Mon, 27 Feb 2023 11:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677496484;
        bh=vzGQTVUAGB0DZHFnytA39OMPU4dd1bZkdB6KQ/tQfak=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bSAbMuZN1m9DajvW1sF5SdpFAKRrHQVqOAZ0l/ZP13cYockUQeGY9tyt2o6cZpr6l
         FK9zvI57Yiwe819VXgBNMUSN7T2uPdWV4TkQHZI+LwuvwAyffU+DFAKba/mpn6Efap
         NobSHXlZK6aNkdUV1YC1/W79L8k0uNbOf+z+/+4JFk29EbBLJePk3QUYP1mhDVzd+O
         nsQl+akWQukxNInnUVMBZZjQPyw9zHsWNUhwGZ969ki3sEJv88xEKahw+sB5HashCD
         RLnXU0sMIrUDR/Kn5Wxi/z5fHhM/p0R+xZI6BsjsBGhRObXD/psggfol6dftbzudYA
         rJCyGfZwlzqFg==
Date:   Mon, 27 Feb 2023 13:14:42 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     James Bottomley <James.Bottomley@hansenpartnership.com>,
        "Jason@zx2c4.com" <Jason@zx2c4.com>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux kernel regressions list <regressions@lists.linux.dev>,
        "Limonciello, Mario" <Mario.Limonciello@amd.com>
Subject: Re: [PATCH 1/1] tpm: disable hwrng for fTPM on some AMD designs
Message-ID: <Y/yQoseTuwRcjV+v@kernel.org>
References: <20230214201955.7461-1-mario.limonciello@amd.com>
 <20230214201955.7461-2-mario.limonciello@amd.com>
 <50b5498c-38fb-e2e8-63f0-3d5bbc047737@leemhuis.info>
 <Y/ABPhpMQrQgQ72l@kernel.org>
 <03c045b5-73f8-0522-9966-472404068949@amd.com>
 <Y/VLYxAqmlF8nbw3@kernel.org>
 <MN0PR12MB610146866686D09CBFEC7AA2E2A59@MN0PR12MB6101.namprd12.prod.outlook.com>
 <2a381d6c-25d9-0027-4951-c0012d09b498@leemhuis.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a381d6c-25d9-0027-4951-c0012d09b498@leemhuis.info>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 27, 2023 at 11:57:15AM +0100, Thorsten Leemhuis wrote:
> Hi, this is your Linux kernel regression tracker. Top-posting for once,
> to make this easily accessible to everyone.
> 
> Jarkko (or James), what is needed to get this regression resolved? More
> people showed up that are apparently affected by this. Sure, 6.2 is out,
> but it's a regression in 6.1 it thus would be good to fix rather sooner
> than later. Ideally this week, if you ask me.

I do not see any tested-by's responded to v2 patch. I.e. we have
an unverified solution, which cannot be applied.

BR, Jarkko
