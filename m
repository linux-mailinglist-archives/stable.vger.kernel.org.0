Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAB693430D8
	for <lists+stable@lfdr.de>; Sun, 21 Mar 2021 05:29:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbhCUE2c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Mar 2021 00:28:32 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:41344 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229556AbhCUE2H (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Mar 2021 00:28:07 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 12L4S2iM007192
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 21 Mar 2021 00:28:02 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id E78B015C39CA; Sun, 21 Mar 2021 00:28:01 -0400 (EDT)
Date:   Sun, 21 Mar 2021 00:28:01 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-ext4@vger.kernel.org,
        syzbot+628472a2aac693ab0fcd@syzkaller.appspotmail.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] ext4: Fix timer use-after-free on failed mount
Message-ID: <YFbLUUL8f5RMHY96@mit.edu>
References: <20210315165906.2175-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315165906.2175-1-jack@suse.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 15, 2021 at 05:59:06PM +0100, Jan Kara wrote:
> When filesystem mount fails because of corrupted filesystem we first
> cancel the s_err_report timer reminding fs errors every day and only
> then we flush s_error_work. However s_error_work may report another fs
> error and re-arm timer thus resulting in timer use-after-free. Fix the
> problem by first flushing the work and only after that canceling the
> s_err_report timer.
> 
> Reported-by: syzbot+628472a2aac693ab0fcd@syzkaller.appspotmail.com
> Fixes: 2d01ddc86606 ("ext4: save error info to sb through journal if available")
> CC: stable@vger.kernel.org
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
