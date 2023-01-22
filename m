Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C386676D2D
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 14:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbjAVNoc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 08:44:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbjAVNob (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 08:44:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B938893F0
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 05:44:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 722D7B80AD2
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 13:44:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C501FC433EF;
        Sun, 22 Jan 2023 13:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674395067;
        bh=ctZTOQmjUVof2jaXy4IpI6e15xh1xIrsq4hgFNfy8e8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BFN4TIk8hGCEYBFYZuSqDnJpyZ1JAY/JY2tkKby0dJxAjA7GPnjskgP+zz+8STlgA
         wQC2br0d90pzsXe9weM9y3jE7+o4DVpaINqS+t33qNSOXxRkM/W3aVWiiDmO0G3Jvg
         vC+Y57OKe6pXQUsZdln419+NCWJG6gkIk0xypZ6o=
Date:   Sun, 22 Jan 2023 14:44:24 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Kevin Hao <haokexin@gmail.com>
Cc:     Tom Saeger <tom.saeger@oracle.com>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 5.15] cpufreq: governor: Use kobject release() method to
 free dbs_data
Message-ID: <Y809uFh7F2s7/GN7@kroah.com>
References: <20230120042650.3722921-1-haokexin@gmail.com>
 <20230120214032.uzq6dgpzhfi7quol@oracle.com>
 <Y8tE1fkJN5BvhWym@pek-khao-d2>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y8tE1fkJN5BvhWym@pek-khao-d2>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 21, 2023 at 09:50:13AM +0800, Kevin Hao wrote:
> On Fri, Jan 20, 2023 at 02:40:32PM -0700, Tom Saeger wrote:
> > 
> > applies but has build error:
> > 
> > /home/tsaeger/workspace/linux/linux-5.15.y/drivers/cpufreq/cpufreq_governor.c: In function ‘cpufreq_dbs_data_release’:
> > /home/tsaeger/workspace/linux/linux-5.15.y/drivers/cpufreq/cpufreq_governor.c:393:49: error: implicit declaration of function ‘to_gov_attr_set’ [-Werror=implicit-function-declaration]
> >   393 |         struct dbs_data *dbs_data = to_dbs_data(to_gov_attr_set(kobj));
> >       |                                                 ^~~~~~~~~~~~~~~
> > /home/tsaeger/workspace/linux/linux-5.15.y/drivers/cpufreq/cpufreq_governor.c:393:49: warning: passing argument 1 of ‘to_dbs_data’ makes pointer from integer without a cast [-Wint-conversion]
> >   393 |         struct dbs_data *dbs_data = to_dbs_data(to_gov_attr_set(kobj));
> >       |                                                 ^~~~~~~~~~~~~~~~~~~~~
> >       |                                                 |
> >       |                                                 int
> > In file included from /home/tsaeger/workspace/linux/linux-5.15.y/drivers/cpufreq/cpufreq_governor.c:20:
> > /home/tsaeger/workspace/linux/linux-5.15.y/drivers/cpufreq/cpufreq_governor.h:49:65: note: expected ‘struct gov_attr_set *’ but argument is of type ‘int’
> >    49 | static inline struct dbs_data *to_dbs_data(struct gov_attr_set *attr_set)
> >       |                                            ~~~~~~~~~~~~~~~~~~~~~^~~~~~~~
> > cc1: some warnings being treated as errors
> > 
> > 
> > 5.15.y first with:
> > ae2650865127 ("cpufreq: Move to_gov_attr_set() to cpufreq.h")
> 
> I managed to forget this commit.

Please submit a working patch series that at least attempts to show you
tested this :)

thanks,

greg k-h
