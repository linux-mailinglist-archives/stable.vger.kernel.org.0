Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1691C5482C4
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 11:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbiFMJLZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 05:11:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230369AbiFMJLY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 05:11:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED963F5B4
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 02:11:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0706B80E42
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 09:11:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F9D6C34114;
        Mon, 13 Jun 2022 09:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655111481;
        bh=mZzbMQlKS9GDr/ck9JoDE9FL0bFbykpWNMphJ6P7ATg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gljt8AfLH9UMlCsUm62JEM8tliPOQfCsEg4iy/kn4SGfyoXJvQdByu+gvBTExU8yt
         ROgPdtkPX4bGLKRyaHvcCqEaGkF16/IRlHGsL6P7juKFPirU15IM6jjpW2ntLqMG5I
         uoK7JCbxUUpevoPdSDt2JU+3BZDt3raKwoF+IUPM=
Date:   Mon, 13 Jun 2022 11:11:18 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     stable@vger.kernel.org, echaudro@redhat.com, i.maximets@ovn.org
Subject: Re: net/sched: act_police: more accurate MTU policing
Message-ID: <Yqb/NsKSyDmQoS+h@kroah.com>
References: <YqNcHbk0K20+qfxP@dcaratti.users.ipa.redhat.com>
 <YqNeoTphHJV5jRYy@kroah.com>
 <YqN6oALiUdh7vnCE@dcaratti.users.ipa.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqN6oALiUdh7vnCE@dcaratti.users.ipa.redhat.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 10, 2022 at 07:08:48PM +0200, Davide Caratti wrote:
> hello Greg,
> 
> thanks for looking at this!
> 
> On Fri, Jun 10, 2022 at 05:09:21PM +0200, Greg KH wrote:
> > On Fri, Jun 10, 2022 at 04:58:37PM +0200, Davide Caratti wrote:
> > > hello,
> > > 
> > > Ilya reports bad TCP throughput when GSO packets hit an OVS rule that does
> > > tc MTU policing. According to his observations [1], the problem is fixed
> > > by upstream commit 4ddc844eb81d ("net/sched: act_police: more accurate MTU
> > > policing"). Can we queue this commit for inclusion in stable trees?
> > 
> > Did you test this,
> 
> I tested it on upstream, RHEL8 and RHEL9 kernels. BTW, the kselftest I included
> in the commit only verifies the correct setting for the MTU threshold, not
> the GSO problem (to test GSO, we should use netperf / iperf3 rather than
> mausezahn to generate traffic).
> 
> > and what kernel(s) do you want it applied to?
> 
> the reported bug is in act_police since the very beginning; however, the
> patch should apply cleanly at least on 5.x kernels. On older ones, there
> might be a small conflict due to lack of RCU-ification of struct
> tcf_police_params.
> A conflict that gets fixed easily, but in case we need it I volunteer to
> write a patch for kernels older than 4.20. @Ilya, what is the
> minimum kernel usable for openvswitch with MTU policing?
> 

It does not apply to 5.10 or earlier, so please provide a working
backport for those kernels if you wish it to be applied there.

thanks,

greg k-h
