Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D2C14DB33C
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 15:27:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238426AbiCPO25 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 10:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346760AbiCPO24 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 10:28:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B2A93DA66;
        Wed, 16 Mar 2022 07:27:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F6126109E;
        Wed, 16 Mar 2022 14:27:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDD9FC340E9;
        Wed, 16 Mar 2022 14:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647440861;
        bh=762Kh2bHP6hZroubEcQdUZQh9o7s+lhL2V5p8GDbWQM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hPKrN13lvASdiKbX0faq4AjalQy1MhrUJs+7NLOXfY0cPcGVFBht0BBK4ZLGjUOmB
         ON2F9WZLAC9GP3tmHWb7gohc1lO7HjoEMPVFoirI5ga7BST2KS9r9X7GGM0VB6Ee6p
         +x6ohsdNbBbQe8tJQ+0ZfHpHY9YNKTvv1pK/C/JY=
Date:   Wed, 16 Mar 2022 15:27:37 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc:     Zhang Qiao <zhangqiao22@huawei.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Zhao Gongyi <zhaogongyi@huawei.com>,
        Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>
Subject: Re: [PATCH 4.19 01/34] cgroup/cpuset: Fix a race between
 cpuset_attach() and cpu hotplug
Message-ID: <YjHz2bifJBuCs/UK@kroah.com>
References: <20220228172207.090703467@linuxfoundation.org>
 <20220228172208.566431934@linuxfoundation.org>
 <20220308151232.GA21752@blackbody.suse.cz>
 <Yi73dKB10LBTGb+S@kroah.com>
 <aa25447a-f6ff-2ff2-72e9-3bbab1d430e9@huawei.com>
 <20220314111940.GC1035@blackbody.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220314111940.GC1035@blackbody.suse.cz>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 14, 2022 at 12:19:41PM +0100, Michal Koutný wrote:
> Hello.
> 
> In my opinion there are two approaches:
> a) drop this backport (given other races present),

I have no problem with that, want to send a revert patch?

> b) swap the locks compatible with v4.19 as this patch proposes.
> 
> On Mon, Mar 14, 2022 at 05:11:50PM +0800, Zhang Qiao <zhangqiao22@huawei.com> wrote:
> > +       /*
> > +        * It should hold cpus lock because a cpu offline event can
> > +        * cause set_cpus_allowed_ptr() failed.
> > +        */
> > +       cpus_read_lock();
> 
> Maybe just a nit, the old kernels before commit c5c63b9a6a2e ("cgroup:
> Replace deprecated CPU-hotplug functions.") v5.15-rc1~159^2~5
> would be more consistent with get_online_cpus() here (but they're
> equivalent functionally so the locking order is correct).

A fixed up patch would also be appreciated :)

thanks,

greg k-h
