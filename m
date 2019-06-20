Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABA344DC75
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 23:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726309AbfFTVZe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 17:25:34 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:54051 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725905AbfFTVZe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jun 2019 17:25:34 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-109.corp.google.com [104.133.0.109] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x5KLPHSK007114
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Jun 2019 17:25:18 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 86C56420484; Thu, 20 Jun 2019 17:25:17 -0400 (EDT)
Date:   Thu, 20 Jun 2019 17:25:17 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Ross Zwisler <zwisler@chromium.org>
Cc:     linux-kernel@vger.kernel.org, Ross Zwisler <zwisler@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Fletcher Woodruff <fletcherw@google.com>,
        Justin TerAvest <teravest@google.com>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 2/3] jbd2: introduce jbd2_inode dirty range scoping
Message-ID: <20190620212517.GC4650@mit.edu>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
        Ross Zwisler <zwisler@chromium.org>, linux-kernel@vger.kernel.org,
        Ross Zwisler <zwisler@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Fletcher Woodruff <fletcherw@google.com>,
        Justin TerAvest <teravest@google.com>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
References: <20190620151839.195506-1-zwisler@google.com>
 <20190620151839.195506-3-zwisler@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190620151839.195506-3-zwisler@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 20, 2019 at 09:18:38AM -0600, Ross Zwisler wrote:
> diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
> index 5c04181b7c6d8..0e0393e7f41a4 100644
> --- a/include/linux/jbd2.h
> +++ b/include/linux/jbd2.h
> @@ -1397,6 +1413,12 @@ extern int	   jbd2_journal_force_commit(journal_t *);
>  extern int	   jbd2_journal_force_commit_nested(journal_t *);
>  extern int	   jbd2_journal_inode_add_write(handle_t *handle, struct jbd2_inode *inode);
>  extern int	   jbd2_journal_inode_add_wait(handle_t *handle, struct jbd2_inode *inode);
> +extern int	   jbd2_journal_inode_ranged_write(handle_t *handle,
> +			struct jbd2_inode *inode, loff_t start_byte,
> +			loff_t length);
> +extern int	   jbd2_journal_inode_ranged_wait(handle_t *handle,
> +			struct jbd2_inode *inode, loff_t start_byte,
> +			loff_t length);
>  extern int	   jbd2_journal_begin_ordered_truncate(journal_t *journal,
>  				struct jbd2_inode *inode, loff_t new_size);
>  extern void	   jbd2_journal_init_jbd_inode(struct jbd2_inode *jinode, struct inode *inode);

You're adding two new functions that are called from outside the jbd2
subsystem.  To support compiling jbd2 as a module, we also need to add
EXPORT_SYMBOL declarations for these two functions.

I'll take care of this when applying this change.

Thanks, applied.

    		     	       	       - Ted
