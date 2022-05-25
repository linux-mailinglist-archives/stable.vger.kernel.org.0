Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AFF05337CE
	for <lists+stable@lfdr.de>; Wed, 25 May 2022 09:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234319AbiEYHwC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 May 2022 03:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbiEYHwB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 May 2022 03:52:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF7BA3FBE9
        for <stable@vger.kernel.org>; Wed, 25 May 2022 00:52:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92D0CB81CBA
        for <stable@vger.kernel.org>; Wed, 25 May 2022 07:51:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 045B8C385B8;
        Wed, 25 May 2022 07:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653465118;
        bh=X8fhvSba/AuBjjBwZK/suOybf9Q61kPHZ1p8yrZiUCg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uPCiVlhFtIii1ammefAQVGQ78nDPXbFSqRTFW2n+TX1UqXYgAohC0lxek7LmD0B5K
         apSVlEw1/XBnp97GzBXq6JygJfrUHWplFFP+p4xHptRvWNkaD8W9/F47Ss4rFTWfs3
         jjv7bnjjvqI2MRbvxuOulZnWcc7sChVu9RFhkUpM=
Date:   Wed, 25 May 2022 09:51:55 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     stable@vger.kernel.org, sashal@kernel.org,
        matthieu.baerts@tessares.net, Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH] mptcp: Do TCP fallback on early DSS checksum failure
Message-ID: <Yo3gG9H8Sw/w7baR@kroah.com>
References: <20220524181041.19543-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220524181041.19543-1-mathew.j.martineau@linux.intel.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 24, 2022 at 11:10:41AM -0700, Mat Martineau wrote:
> [ Upstream commit ae66fb2ba6c3dcaf8b9612b65aa949a1a4bed150 ]
> 
> RFC 8684 section 3.7 describes several opportunities for a MPTCP
> connection to "fall back" to regular TCP early in the connection
> process, before it has been confirmed that MPTCP options can be
> successfully propagated on all SYN, SYN/ACK, and data packets. If a peer
> acknowledges the first received data packet with a regular TCP header
> (no MPTCP options), fallback is allowed.
> 
> If the recipient of that first data packet finds a MPTCP DSS checksum
> error, this provides an opportunity to fail gracefully with a TCP
> fallback rather than resetting the connection (as might happen if a
> checksum failure were detected later).
> 
> This commit modifies the checksum failure code to attempt fallback on
> the initial subflow of a MPTCP connection, only if it's a failure in the
> first data mapping. In cases where the peer initiates the connection,
> requests checksums, is the first to send data, and the peer is sending
> incorrect checksums (see
> https://github.com/multipath-tcp/mptcp_net-next/issues/275), this allows
> the connection to proceed as TCP rather than reset.
> 
> Cc: <stable@vger.kernel.org> # 5.17.x
> Cc: <stable@vger.kernel.org> # 5.15.x
> Fixes: dd8bcd1768ff ("mptcp: validate the data checksum")
> Acked-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> [mathew.j.martineau: backport: Resolved bitfield conflict in protocol.h]
> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> ---
> 
> This patch is already in 5.17.10-rc1 and 5.15.42-rc1, but involves a
> context dependency on upstream commit 4cf86ae84c71 which I have
> requested to be dropped from the stable queues.
> 
> I'm posting this backport without the protocol.h conflict to
> (hopefully?) make it easier for the stable maintainers to drop
> 4cf86ae84c71.
> 
> For context see https://lore.kernel.org/stable/fa953ec-288f-7715-c6fb-47a222e85270@linux.intel.com/

THanks, will take this after this round of releases.

greg k-h
