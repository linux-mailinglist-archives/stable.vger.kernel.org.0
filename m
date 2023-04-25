Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC426EE078
	for <lists+stable@lfdr.de>; Tue, 25 Apr 2023 12:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233745AbjDYKii (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Apr 2023 06:38:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233613AbjDYKig (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Apr 2023 06:38:36 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C33CE35A1;
        Tue, 25 Apr 2023 03:38:32 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 70B271FDA3;
        Tue, 25 Apr 2023 10:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1682419111; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+rgwMsg0iqwF3ZvbiregfC+rqJt77lsoc44e2Yuo34g=;
        b=P4dfuZfoXZlHCnbmcNNf8Nf10qT/DRdG+nnN+HB48qv/3ky8goTZE8AnOF9/nf8sw8yfkC
        MmE5r3KRdzSHBlyVjs4GAyPMeSDMdbzMjbatXXMrHkmOJ9X9WALn8MlxQ41K5REYmwMVTC
        PNRUaATJYVRjKQW7Y5+nX8jYX9mg+74=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1682419111;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+rgwMsg0iqwF3ZvbiregfC+rqJt77lsoc44e2Yuo34g=;
        b=Go4a98BuHZKgv3EQjvx3ZmHz0hPe7q3/M3d1sIAATbNGDV6oAuoD3MeMS441v7QHqqYSAK
        EP6hqUoYCTKK2vAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 62ED4138E3;
        Tue, 25 Apr 2023 10:38:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id xOwOGKetR2SYLwAAMHmgww
        (envelope-from <jack@suse.cz>); Tue, 25 Apr 2023 10:38:31 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id EDC13A0729; Tue, 25 Apr 2023 12:38:30 +0200 (CEST)
Date:   Tue, 25 Apr 2023 12:38:30 +0200
From:   Jan Kara <jack@suse.cz>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org,
        syzbot+4a06d4373fd52f0b2f9c@syzkaller.appspotmail.com
Subject: Re: [PATCH] inotify: Avoid reporting event with invalid wd
Message-ID: <20230425103830.ruszghiqpk3aea2v@quack3>
References: <20230424163219.9250-1-jack@suse.cz>
 <CAOQ4uxjamwMxOXb3j7D8j_KkHLosayn3dnRbGfso9SFfzkSdDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxjamwMxOXb3j7D8j_KkHLosayn3dnRbGfso9SFfzkSdDg@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 25-04-23 09:01:20, Amir Goldstein wrote:
> On Mon, Apr 24, 2023 at 7:32 PM Jan Kara <jack@suse.cz> wrote:
> >
> > When inotify_freeing_mark() races with inotify_handle_inode_event() it
> > can happen that inotify_handle_inode_event() sees that i_mark->wd got
> > already reset to -1 and reports this value to userspace which can
> > confuse the inotify listener. Avoid the problem by validating that wd is
> > sensible (and pretend the mark got removed before the event got
> > generated otherwise).
> >
> > CC: stable@vger.kernel.org
> > Fixes: 7e790dd5fc93 ("inotify: fix error paths in inotify_update_watch")
> > Reported-by: syzbot+4a06d4373fd52f0b2f9c@syzkaller.appspotmail.com
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> Makes sense.
> 
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Thanks. I've pulled the patch into my tree.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
