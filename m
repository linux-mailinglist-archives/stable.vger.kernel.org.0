Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 005E03904CF
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 17:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbhEYPOz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 11:14:55 -0400
Received: from mx2.suse.de ([195.135.220.15]:39398 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230085AbhEYPOz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 May 2021 11:14:55 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1621955604;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LZagGY2ps2cRa1LmrhFbQSz3/7jutPqaZHEYsRvi/4Y=;
        b=aKdJsRCPD1OWUtvRkgxTcn4akao3g1GREuS4Mh+Q34hHkWZDbvuPRobcKEJ4YAVNC+Jp7g
        Rz7O1ULVoXBPEYWiDNkd/18HrdzSAIAKDsDE0WsMud7vPtG7YWs4iXL9CyS7yf1yLEZwdv
        H4mGafHTa2hsIFuTPnwM/PNbJB+3HAU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1621955604;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LZagGY2ps2cRa1LmrhFbQSz3/7jutPqaZHEYsRvi/4Y=;
        b=KPNojxCG3ORHHZv+9Qy8UjDch4E1mrfpI7bCTwo0iJbpyRiWXDDBwnvUw87lla1ODs1MR1
        o0YITabG6MQORUDg==
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5EB58AEB3;
        Tue, 25 May 2021 15:13:24 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id EB64EDA70B; Tue, 25 May 2021 17:10:47 +0200 (CEST)
Date:   Tue, 25 May 2021 17:10:47 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: do not write supers if we have an fs error
Message-ID: <20210525151047.GY7604@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        stable@vger.kernel.org
References: <58fd56f2942d80bee34108035bd5708a19ac56ed.1621458943.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58fd56f2942d80bee34108035bd5708a19ac56ed.1621458943.git.josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 19, 2021 at 05:15:53PM -0400, Josef Bacik wrote:
> Error injection testing uncovered a pretty severe problem where we could
> end up committing a super that pointed to the wrong tree roots,
> resulting in transid mismatch errors.
> 
> The way we commit the transaction is we update the super copy with the
> current generations and bytenrs of the important roots, and then copy
> that into our super_for_commit.  Then we allow transactions to continue
> again, we write out the dirty pages for the transaction, and then we
> write the super.  If the write out fails we'll bail and skip writing the
> supers.
> 
> However since we've allowed a new transaction to start, we can have a
> log attempting to sync at this point, which would be blocked on
> fs_info->tree_log_mutex.  Once the commit fails we're allowed to do the
> log tree commit, which uses super_for_commit, which now points at fs
> tree's that were not written out.
> 
> Fix this by checking BTRFS_FS_STATE_ERROR once we acquire the
> tree_log_mutex.  This way if the transaction commit fails we're sure to
> see this bit set and we can skip writing the super out.  This patch
> fixes this specific transid mismatch error I was seeing with this
> particular error path.
> 
> cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Added to misc-next, with the suggested comment update. Thanks.
