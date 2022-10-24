Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE1860B113
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234090AbiJXQQO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:16:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234751AbiJXQPJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:15:09 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2D8645057;
        Mon, 24 Oct 2022 08:03:08 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 881551FD8F;
        Mon, 24 Oct 2022 14:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1666623082; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+dUg23q+PqyEUigiheljKeMp2Jq86RyrgNzvaPg053I=;
        b=SCCyA4WbOaNxKLOR870wk7nnEsicFscMCy5iXQmiw0i09p3J5YCFWbrlz5bOw4LEqgTRe2
        DfluN+UDo1mtTyEAJ8N0VH3CXvWobmJcsr9Pm4u6aGy+wVkZiRPL8ahtVuQQ04lLQhSA6q
        74ZejtZ0q5FIy7/13cMRs2u+GTC7T+c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1666623082;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+dUg23q+PqyEUigiheljKeMp2Jq86RyrgNzvaPg053I=;
        b=EwGOXHRUiCvg+oLrhhHjUGFUiZuTWvQU9PX365tB1trMWDVtKGmZwycbMxvQUDK3yawQXc
        2Gvs45WykLcyGbAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6DB9313A79;
        Mon, 24 Oct 2022 14:51:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 4S/GGmqmVmMkLwAAMHmgww
        (envelope-from <jack@suse.cz>); Mon, 24 Oct 2022 14:51:22 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id F1978A06F6; Mon, 24 Oct 2022 16:51:21 +0200 (CEST)
Date:   Mon, 24 Oct 2022 16:51:21 +0200
From:   Jan Kara <jack@suse.cz>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, Thomas Schmitt <scdbackup@gmx.net>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@kernel.org>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] isofs: prevent file time rollover after year 2038
Message-ID: <20221024145121.2dj6sdeqvxndbhpt@quack3>
References: <20221020160037.4002270-1-arnd@kernel.org>
 <20221024122614.bkcehqr7gi3f23ca@quack3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221024122614.bkcehqr7gi3f23ca@quack3>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_SOFTFAIL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon 24-10-22 14:26:14, Jan Kara wrote:
> On Thu 20-10-22 18:00:29, Arnd Bergmann wrote:
> > From: Thomas Schmitt <scdbackup@gmx.net>
> > 
> > Change the return type of function iso_date() from int to time64_t,
> > to avoid truncating to the 1902..2038 date range.
> > 
> > After this patch, the reported timestamps should fall into the
> > range reported in the s_time_min/s_time_max fields.
> > 
> > Signed-off-by: Thomas Schmitt <scdbackup@gmx.net>
> > Cc: stable@vger.kernel.org
> > Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=800627
> > Fixes: 34be4dbf87fc ("isofs: fix timestamps beyond 2027")
> > Fixes: 5ad32b3acded ("isofs: Initialize filesystem timestamp ranges")
> > [arnd: expand changelog text slightly]
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> Thanks! I've added the patch to my tree and will push it to Linus.

Oh, I have noticed Andrew has merged the patch already into his tree. So
dropped from mine.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
