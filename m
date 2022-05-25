Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6237C5337CC
	for <lists+stable@lfdr.de>; Wed, 25 May 2022 09:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235702AbiEYHvi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 May 2022 03:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbiEYHvg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 May 2022 03:51:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A18832AC6D;
        Wed, 25 May 2022 00:51:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5A2E4B81C95;
        Wed, 25 May 2022 07:51:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 863F4C34116;
        Wed, 25 May 2022 07:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653465093;
        bh=B7jZfU7xnbYdmiqmnR6OSx/k5usfd6C6hfkEddKhG8I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EO8vfeD/bbajJYsszjLXknRwgKkyWnF2d86JWY7wa401Qvq3q+kT4J1xRosqHEInq
         VrSkTQotovBuBBWYKFsNb6j/WDxhjx3LvOuut/fLJDKBnJzM2yBy7/pnNpSwGAdh/E
         QIC3wn8L/w16G6d4/6oIgGkQSLWYstyJYbAxN5vk=
Date:   Wed, 25 May 2022 09:51:30 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: Re: [PATCH 5.17 114/158] mptcp: strict local address ID selection
Message-ID: <Yo3gAprjnapHfKar@kroah.com>
References: <20220523165830.581652127@linuxfoundation.org>
 <20220523165849.851212488@linuxfoundation.org>
 <fa953ec-288f-7715-c6fb-47a222e85270@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa953ec-288f-7715-c6fb-47a222e85270@linux.intel.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 23, 2022 at 08:51:52PM -0700, Mat Martineau wrote:
> On Mon, 23 May 2022, Greg Kroah-Hartman wrote:
> 
> > From: Paolo Abeni <pabeni@redhat.com>
> > 
> > [ Upstream commit 4cf86ae84c718333928fd2d43168a1e359a28329 ]
> > 
> > The address ID selection for MPJ subflows created in response
> > to incoming ADD_ADDR option is currently unreliable: it happens
> > at MPJ socket creation time, when the local address could be
> > unknown.
> > 
> > Additionally, if the no local endpoint is available for the local
> > address, a new dummy endpoint is created, confusing the user-land.
> > 
> > This change refactor the code to move the address ID selection inside
> > the rebuild_header() helper, when the local address eventually
> > selected by the route lookup is finally known. If the address used
> > is not mapped by any endpoint - and thus can't be advertised/removed
> > pick the id 0 instead of allocate a new endpoint.
> > 
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> > net/mptcp/pm_netlink.c | 13 --------
> > net/mptcp/protocol.c   |  3 ++
> > net/mptcp/protocol.h   |  3 +-
> > net/mptcp/subflow.c    | 67 ++++++++++++++++++++++++++++++++++++------
> > 4 files changed, 63 insertions(+), 23 deletions(-)
> > 
> 
> Greg, Sasha -
> 
> Is it possible to drop this one patch? It makes one of the mptcp selftests
> fail (mptcp_join.sh, "single address, backup").

Does that mean the backport is incorrect, or that the selftest is wrong?

> Looks like this patch has been included in stable because of this single
> hunk that helps "mptcp: Do TCP fallback on early DSS checksum failure" apply
> cleanly:
> 
> > diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
> > index aec767ee047a..e4413b3e50c2 100644
> > --- a/net/mptcp/protocol.h
> > +++ b/net/mptcp/protocol.h
> > @@ -442,7 +442,8 @@ struct mptcp_subflow_context {
> > 		rx_eof : 1,
> > 		can_ack : 1,        /* only after processing the remote a key */
> > 		disposable : 1,	    /* ctx can be free at ulp release time */
> > -		stale : 1;	    /* unable to snd/rcv data, do not use for xmit */
> > +		stale : 1,	    /* unable to snd/rcv data, do not use for xmit */
> > +		local_id_valid : 1; /* local_id is correctly initialized */
> > 	enum mptcp_data_avail data_avail;
> > 	u32	remote_nonce;
> > 	u64	thmac;
> 
> "mptcp: Do TCP fallback on early DSS checksum failure" also adds a bit to
> that bitfield, but there is no functional dependency between the patches.
> 
> If you need to drop the "mptcp: Do TCP fallback..." patch too, I can send a
> backported version tomorrow that accounts for that bitfield change.

Yes, I had to drop that second patch because of this.  Both are now
dropped from 5.15 and 5.17, can you provide a working backport?

thanks,

greg k-h
