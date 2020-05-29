Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1A211E72B5
	for <lists+stable@lfdr.de>; Fri, 29 May 2020 04:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391592AbgE2CoM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 22:44:12 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:52229 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2391576AbgE2CoL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 May 2020 22:44:11 -0400
Received: from callcc.thunk.org (pool-100-0-195-244.bstnma.fios.verizon.net [100.0.195.244])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 04T2i1qi019181
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 May 2020 22:44:02 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 49FCB420304; Thu, 28 May 2020 22:44:01 -0400 (EDT)
Date:   Thu, 28 May 2020 22:44:01 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-ext4@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] jbd2: Avoid leaking transaction credits when
 unreserving handle
Message-ID: <20200529024401.GH228632@mit.edu>
References: <20200520133119.1383-1-jack@suse.cz>
 <20200520133119.1383-3-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520133119.1383-3-jack@suse.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 20, 2020 at 03:31:19PM +0200, Jan Kara wrote:
> When reserved transaction handle is unused, we subtract its reserved
> credits in __jbd2_journal_unreserve_handle() called from
> jbd2_journal_stop(). However this function forgets to remove reserved
> credits from transaction->t_outstanding_credits and thus the transaction
> space that was reserved remains effectively leaked. The leaked
> transaction space can be quite significant in some cases and leads to
> unnecessarily small transactions and thus reducing throughput of the
> journalling machinery. E.g. fsmark workload creating lots of 4k files
> was observed to have about 20% lower throughput due to this when ext4 is
> mounted with dioread_nolock mount option.
> 
> Subtract reserved credits from t_outstanding_credits as well.
> 
> CC: stable@vger.kernel.org
> Fixes: 8f7d89f36829 ("jbd2: transaction reservation support")
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
