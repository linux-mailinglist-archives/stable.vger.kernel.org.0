Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC9CF0786
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 22:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbfKEVAT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 16:00:19 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:59142 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725806AbfKEVAT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Nov 2019 16:00:19 -0500
Received: from callcc.thunk.org (ip-12-2-52-196.nyc.us.northamericancoax.com [196.52.2.12])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id xA5L0BC8007191
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 5 Nov 2019 16:00:12 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id B5E30420311; Tue,  5 Nov 2019 16:00:09 -0500 (EST)
Date:   Tue, 5 Nov 2019 16:00:09 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-ext4@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 06/25] ext4: Fix credit estimate for final inode freeing
Message-ID: <20191105210009.GB26959@mit.edu>
References: <20191003215523.7313-1-jack@suse.cz>
 <20191105164437.32602-6-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191105164437.32602-6-jack@suse.cz>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 05, 2019 at 05:44:12PM +0100, Jan Kara wrote:
> @@ -252,8 +257,12 @@ void ext4_evict_inode(struct inode *inode)
>  	if (!IS_NOQUOTA(inode))
>  		extra_credits += EXT4_MAXQUOTAS_DEL_BLOCKS(inode->i_sb);
>  
> +	/*
> +	 * Block bitmap, group descriptor, and inode are accounted in both
> + 	 * ext4_blocks_for_truncate() and extra_credits. So subtract 3.
  ^^^

There was a minor whitespace nit which I fixed up in my tree here.

      	    	  	     	       - Ted
