Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F785DE1AF
	for <lists+stable@lfdr.de>; Mon, 21 Oct 2019 03:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbfJUBIp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Oct 2019 21:08:45 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:37751 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726681AbfJUBIp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Oct 2019 21:08:45 -0400
Received: from callcc.thunk.org (pool-72-93-95-157.bstnma.fios.verizon.net [72.93.95.157])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x9L18eLY030904
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 20 Oct 2019 21:08:40 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id E8CAE420458; Sun, 20 Oct 2019 21:08:39 -0400 (EDT)
Date:   Sun, 20 Oct 2019 21:08:39 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-ext4@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 01/22] jbd2: Fix possible overflow in
 jbd2_log_space_left()
Message-ID: <20191021010839.GC6799@mit.edu>
References: <20191003215523.7313-1-jack@suse.cz>
 <20191003220613.10791-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191003220613.10791-1-jack@suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 04, 2019 at 12:05:47AM +0200, Jan Kara wrote:
> When number of free space in the journal is very low, the arithmetic in
> jbd2_log_space_left() could underflow resulting in very high number of
> free blocks and thus triggering assertion failure in transaction commit
> code complaining there's not enough space in the journal:
> 
> J_ASSERT(journal->j_free > 1);
> 
> Properly check for the low number of free blocks.
> 
> CC: stable@vger.kernel.org
> Signed-off-by: Jan Kara <jack@suse.cz>

Looks good, you can add:

Reviewed-by: Theodore Ts'o <tytso@mit.edu>
