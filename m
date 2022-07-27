Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21C9D583218
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 20:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233951AbiG0SeO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 14:34:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232918AbiG0Sd6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 14:33:58 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07D8910BFF6;
        Wed, 27 Jul 2022 10:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=FebJFylVckTiyIepFSSk7WIA2wIWss3TlVC3X8R+ZCA=; b=Q1gurOSYXisxVFMmdhcycWtm4X
        zEKQPuTKDGwneodlrqmrfZmbuzSYZIWVSHVBNmG38NSbrnemtw2ZZNIY4ou2C9wrAeiD+MPLJL15d
        pJcqAB6PS7fE5UauStkEeExBRzm/nDoeIvLgk4eRYsdXr36N53rIZc9vjynpzeKdkDoOvGQqPIBHf
        wBffH7xudkUt7yoV9PhHlF5MP2250iIX7l5iedOffK6Pv+XQh1echz2XH6/lXjExTmsjicrVHEnGK
        gnbY0DxZHbQTgOvAVerLkYybqMBY89nd4gomUh0Wv22PFxat8HZLUDpDtxP5ndXWSNGpL1blIt5FN
        wtGQR/mQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oGksj-00G7nJ-AG; Wed, 27 Jul 2022 17:31:37 +0000
Date:   Wed, 27 Jul 2022 10:31:37 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Xiaoming Ni <nixiaoming@huawei.com>,
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
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 040/201] sysctl: move some boundary constants from
 sysctl.c to sysctl_vals
Message-ID: <YuF2eU9SbDDHdqaU@bombadil.infradead.org>
References: <20220727161026.977588183@linuxfoundation.org>
 <20220727161028.534205480@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220727161028.534205480@linuxfoundation.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 27, 2022 at 06:09:04PM +0200, Greg Kroah-Hartman wrote:
> From: Xiaoming Ni <nixiaoming@huawei.com>
> 
> [ Upstream commit 78e36f3b0dae586f623c4a37ec5eb5496f5abbe1 ]
> 
> sysctl has helpers which let us specify boundary values for a min or max
> int value.  Since these are used for a boundary check only they don't
> change, so move these variables to sysctl_vals to avoid adding duplicate
> variables.  This will help with our cleanup of kernel/sysctl.c.
> 
> [akpm@linux-foundation.org: update it for "mm/pagealloc: sysctl: change watermark_scale_factor max limit to 30%"]
> [mcgrof@kernel.org: major rebase]
> 
> Link: https://lkml.kernel.org/r/20211123202347.818157-3-mcgrof@kernel.org
> Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

I'm a bit puzzled. How / why is this a stable fix?

  Luis
