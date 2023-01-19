Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29A986742F0
	for <lists+stable@lfdr.de>; Thu, 19 Jan 2023 20:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbjASTg7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Jan 2023 14:36:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjASTg5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Jan 2023 14:36:57 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4C204DCEC;
        Thu, 19 Jan 2023 11:36:56 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 6737321EAF;
        Thu, 19 Jan 2023 19:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1674157015;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ngsB5POdlD2n+2OU/cXyQK2GoaQO8aRzLLvD27r7gVM=;
        b=Lixb62zQnVjf4Te8cS5PxZ2UB8o7V+UeaLSf5UxWsQYDSIxSsxni7Mk/vONTK2T9zd6qU+
        jszCpCw6LEbhSgV/ns39hroEqT78DmZceIYKh+tgtEBaTtJl/F8skMr5ElD9/Lh4YAHNsY
        Zo81hHCpyZaMqjwgA+Wb3UpNh8q8K0o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1674157015;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ngsB5POdlD2n+2OU/cXyQK2GoaQO8aRzLLvD27r7gVM=;
        b=A5OCohhlohUlrUAdRGlIVTTpy8uA8icKjCHGUXF0oUETdGs0QbbKviqjdnFXCv6ogX95Pf
        nuHVw2G4vcbZp7DQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4734F134F5;
        Thu, 19 Jan 2023 19:36:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id smSYENebyWMtQwAAMHmgww
        (envelope-from <dsterba@suse.cz>); Thu, 19 Jan 2023 19:36:55 +0000
Date:   Thu, 19 Jan 2023 20:31:16 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: limit device extents to the device size
Message-ID: <20230119193115.GK11562@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <158f8775fb0256a09ab4badb752e2202aa118e1d.1674077707.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158f8775fb0256a09ab4badb752e2202aa118e1d.1674077707.git.josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 18, 2023 at 04:35:13PM -0500, Josef Bacik wrote:
> There was a recent regression in btrfs/177 that started happening with
> the size class patches.  This however isn't a regression introduced by
> those patches, but rather the bug was uncovered by a change in behavior
> in these patches.  The patches triggered more chunk allocations in the
> ^free-space-tree case, which uncovered a race with device shrink.
> 
> The problem is we will set the device total size to the new size, and
> use this to find a hole for a device extent.  However during shrink we
> may have device extents allocated past this range, so we could
> potentially find a hole in a range past our new shrink size.  We don't
> actually limit our found extent to the device size anywhere, we assume
> that we will not find a hole past our device size.  This isn't true with
> shrink as we're relocating block groups and thus creating holes past the
> device size.
> 
> Fix this by making sure we do not search past the new device size, and
> if we wander into any device extents that start after our device size
> simply break from the loop and use whatever hole we've already found.
> 
> cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Added to misc-next, thanks.
