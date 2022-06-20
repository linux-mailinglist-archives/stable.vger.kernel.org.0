Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7BCB5517C4
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 13:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241489AbiFTLuN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 07:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235342AbiFTLuH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 07:50:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0987717062
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 04:50:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99ADB61314
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 11:50:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AABDC3411C;
        Mon, 20 Jun 2022 11:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655725806;
        bh=a0kWx+1gh40sZrJ4Q4Ma0SlwwU77Z4kC0hMb/pXH/FU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e4g1WvSZ0BDFdF+gXHkaB64Wiq1aJmc8RCNKuM5cjUVGhuy7ZGQV9gK0HpFGz3Ltz
         SSpxTrYKMRAkNi1uSaYWWDPOfRC0eQq8K54Ix7KOKs1rOglptbNhzh9OnIOPCEaWSe
         F+1NaCCZy92Nqm1hUggFuHhIc3Zlt/rtT4e3Th/o=
Date:   Mon, 20 Jun 2022 13:50:03 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ilya Maximets <i.maximets@ovn.org>
Cc:     stable@vger.kernel.org,
        Frode Nordahl <frode.nordahl@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 5.10] net: openvswitch: fix misuse of the cached
 connection on tuple changes
Message-ID: <YrBe6+4tF/00PE+F@kroah.com>
References: <20220617155649.238255-1-i.maximets@ovn.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220617155649.238255-1-i.maximets@ovn.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 17, 2022 at 05:56:49PM +0200, Ilya Maximets wrote:
> commit 2061ecfdf2350994e5b61c43e50e98a7a70e95ee upstream
> 
> [Backport to 5.10: minor rebase in ovs_ct_clear function.
>  This version also applicable to and tested on 5.4 and 4.19.]
> 
> If packet headers changed, the cached nfct is no longer relevant
> for the packet and attempt to re-use it leads to the incorrect packet
> classification.
> 
> This issue is causing broken connectivity in OpenStack deployments
> with OVS/OVN due to hairpin traffic being unexpectedly dropped.
> 
> The setup has datapath flows with several conntrack actions and tuple
> changes between them:
> 
>   actions:ct(commit,zone=8,mark=0/0x1,nat(src)),
>           set(eth(src=00:00:00:00:00:01,dst=00:00:00:00:00:06)),
>           set(ipv4(src=172.18.2.10,dst=192.168.100.6,ttl=62)),
>           ct(zone=8),recirc(0x4)
> 
> After the first ct() action the packet headers are almost fully
> re-written.  The next ct() tries to re-use the existing nfct entry
> and marks the packet as invalid, so it gets dropped later in the
> pipeline.
> 
> Clearing the cached conntrack entry whenever packet tuple is changed
> to avoid the issue.
> 
> The flow key should not be cleared though, because we should still
> be able to match on the ct_state if the recirculation happens after
> the tuple change but before the next ct() action.
> 
> Cc: stable@vger.kernel.org
> Fixes: 7f8a436eaa2c ("openvswitch: Add conntrack action")
> Reported-by: Frode Nordahl <frode.nordahl@canonical.com>
> Link: https://mail.openvswitch.org/pipermail/ovs-discuss/2022-May/051829.html
> Link: https://bugs.launchpad.net/ubuntu/+source/ovn/+bug/1967856
> Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
> Link: https://lore.kernel.org/r/20220606221140.488984-1-i.maximets@ovn.org
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> 
> The patch was already backported down to 5.15.
> This version was adjusted to work on 5.10, 5.4 and 4.19.

Now queued up, thanks!

greg k-h
