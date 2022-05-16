Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3048252851F
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 15:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiEPNQq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 09:16:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbiEPNQq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 09:16:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 383B524589
        for <stable@vger.kernel.org>; Mon, 16 May 2022 06:16:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8FAFB81210
        for <stable@vger.kernel.org>; Mon, 16 May 2022 13:16:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B9B0C385AA;
        Mon, 16 May 2022 13:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652707002;
        bh=tkG1B0wkq4zmdSOETSJcL1xup9qVXolJiaLwRNEAMFc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HvzPGo05u0zY0Lnk8bNWx1IjhFq5YEY9fsLO4qaFImGmdTbOW+7EyW8Gzlc03bjtj
         IHxnZZdfVg/2ALqHX+QMNmNSbErNGx9o7T11H5NnQNi55jkureHrIBJoCwVCVru4yL
         YesDJooMKf34PK6hWK76jNk03mupWMxME7N5FaUE=
Date:   Mon, 16 May 2022 15:16:39 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, David Ahern <dsahern@kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4-stable] ping: fix address binding wrt vrf
Message-ID: <YoJOt+AhvS/XR39B@kroah.com>
References: <165268897847204@kroah.com>
 <20220516125229.32188-1-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220516125229.32188-1-nicolas.dichtel@6wind.com>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 16, 2022 at 02:52:29PM +0200, Nicolas Dichtel wrote:
> commit e1a7ac6f3ba6e157adcd0ca94d92a401f1943f56 upstream.
> 
> When ping_group_range is updated, 'ping' uses the DGRAM ICMP socket,
> instead of an IP raw socket. In this case, 'ping' is unable to bind its
> socket to a local address owned by a vrflite.
> 
> Before the patch:
> $ sysctl -w net.ipv4.ping_group_range='0  2147483647'
> $ ip link add blue type vrf table 10
> $ ip link add foo type dummy
> $ ip link set foo master blue
> $ ip link set foo up
> $ ip addr add 192.168.1.1/24 dev foo
> $ ip addr add 2001::1/64 dev foo
> $ ip vrf exec blue ping -c1 -I 192.168.1.1 192.168.1.2
> ping: bind: Cannot assign requested address
> $ ip vrf exec blue ping6 -c1 -I 2001::1 2001::2
> ping6: bind icmp socket: Cannot assign requested address
> 
> CC: stable@vger.kernel.org
> Fixes: 1b69c6d0ae90 ("net: Introduce L3 Master device abstraction")
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> Reviewed-by: David Ahern <dsahern@kernel.org>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> ---
> 
> The patch applies also on 4.19, 4.14 and 4.9 stable trees, but I didn't test or
> compile it on these trees.

now all queued up, thanks.

greg k-h
