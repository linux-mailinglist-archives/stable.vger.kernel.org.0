Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDBD544C1A4
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 13:55:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231460AbhKJM6R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 07:58:17 -0500
Received: from verein.lst.de ([213.95.11.211]:54384 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229653AbhKJM6R (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 07:58:17 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9048967373; Wed, 10 Nov 2021 13:55:27 +0100 (CET)
Date:   Wed, 10 Nov 2021 13:55:27 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Andreas Gruenbacher <agruenba@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com,
        stable@vger.kernel.org
Subject: Re: [5.15 REGRESSION] iomap: Fix inline extent handling in
 iomap_readpage
Message-ID: <20211110125527.GA25465@lst.de>
References: <20211110113842.517426-1-agruenba@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211110113842.517426-1-agruenba@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 10, 2021 at 12:38:42PM +0100, Andreas Gruenbacher wrote:
> +	if (iomap->type == IOMAP_INLINE) {
> +		/*
> +		 * The filesystem sets iomap->length to the size of the inline
> +		 * data.  We're at the end of the file, so we know that the
> +		 * rest of the page needs to be zeroed out.
> +		 */
> +		iomap->length = iomap_read_inline_data(iter, page);
> +		return iomap->length;

You can't just change iomap->length here.  Fix the file system to
return the right length, please.
