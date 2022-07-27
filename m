Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21485583432
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 22:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233916AbiG0UoU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 16:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbiG0UoT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 16:44:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 991F5501A1;
        Wed, 27 Jul 2022 13:44:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1BDFAB821BC;
        Wed, 27 Jul 2022 20:44:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A5BC433C1;
        Wed, 27 Jul 2022 20:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658954655;
        bh=o1bEquRZUISTz+ILsSz7+IiI4+5ykqc4Ff8IODEXRAE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qT4qlCLH1qXrQpOFOAWBYNvwc2nTRY2Qw7hkgpINvTPrf14FwCF/rbu2sGrrSxHs7
         dI/pFs5YPAWup9dlE7o+Nq35+pbBsIHghkmlSsyje85+LSFXgL0A6AcDzahKcrfeMK
         UReoFM/3BHSg9IZpETbleQzFx6zwuA6N/vScZq5Xz1eRZ3gpq8pVv4XSstW0oLnUiq
         SVLM5IVLewuEZ9UaRi610STU9pyoUgWPSrlGAHpk5AVyCs5ztKCzq0w1H/geqP2ec3
         g13l0BImBDpvaz4oGj0HpSdEqUf8+69+kn0fiA3kZYJnfmenhUkO9OIejZQ+a1wIBU
         JRzIck04gkbeA==
Date:   Wed, 27 Jul 2022 16:44:14 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Luis Chamberlain <mcgrof@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Xiaoming Ni <nixiaoming@huawei.com>,
        Kees Cook <keescook@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Amir Goldstein <amir73il@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Benjamin LaHaise <bcrl@kvack.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Iurii Zaikin <yzaikin@google.com>, Jan Kara <jack@suse.cz>,
        Paul Turner <pjt@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Petr Mladek <pmladek@suse.com>, Qing Wang <wangqing@vivo.com>,
        Sebastian Reichel <sre@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Stephen Kitt <steve@sk2.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Antti Palosaari <crope@iki.fi>, Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Clemens Ladisch <clemens@ladisch.de>,
        David Airlie <airlied@linux.ie>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joel Becker <jlbec@evilplan.org>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Julia Lawall <julia.lawall@inria.fr>,
        Lukas Middendorf <kernel@tuxforce.de>,
        Mark Fasheh <mark@fasheh.com>,
        Phillip Potter <phil@philpotter.co.uk>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jani Nikula <jani.nikula@intel.com>,
        John Ogness <john.ogness@linutronix.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Theodore Tso <tytso@mit.edu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 5.15 040/201] sysctl: move some boundary constants from
 sysctl.c to sysctl_vals
Message-ID: <YuGjnm7ePDsgosCV@sashalap>
References: <20220727161026.977588183@linuxfoundation.org>
 <20220727161028.534205480@linuxfoundation.org>
 <YuF2eU9SbDDHdqaU@bombadil.infradead.org>
 <YuF/t6/DtsGPLQVc@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YuF/t6/DtsGPLQVc@kroah.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 27, 2022 at 08:11:03PM +0200, Greg Kroah-Hartman wrote:
>On Wed, Jul 27, 2022 at 10:31:37AM -0700, Luis Chamberlain wrote:
>> On Wed, Jul 27, 2022 at 06:09:04PM +0200, Greg Kroah-Hartman wrote:
>> > From: Xiaoming Ni <nixiaoming@huawei.com>
>> >
>> > [ Upstream commit 78e36f3b0dae586f623c4a37ec5eb5496f5abbe1 ]
>> >
>> > sysctl has helpers which let us specify boundary values for a min or max
>> > int value.  Since these are used for a boundary check only they don't
>> > change, so move these variables to sysctl_vals to avoid adding duplicate
>> > variables.  This will help with our cleanup of kernel/sysctl.c.
>> >
>> > [akpm@linux-foundation.org: update it for "mm/pagealloc: sysctl: change watermark_scale_factor max limit to 30%"]
>> > [mcgrof@kernel.org: major rebase]
>> >
>> > Link: https://lkml.kernel.org/r/20211123202347.818157-3-mcgrof@kernel.org
>> > Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
>> > Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
>> > Reviewed-by: Kees Cook <keescook@chromium.org>
>> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>> > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>> > Signed-off-by: Sasha Levin <sashal@kernel.org>
>>
>> I'm a bit puzzled. How / why is this a stable fix?
>
>I think it's needed by a patch later in the series.  Sasha, can you
>verify?

Yes, about 30 patches in this series need this patch.

-- 
Thanks,
Sasha
