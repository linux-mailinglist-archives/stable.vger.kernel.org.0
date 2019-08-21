Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C720996F10
	for <lists+stable@lfdr.de>; Wed, 21 Aug 2019 03:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726895AbfHUBtR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 21:49:17 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:42616 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726372AbfHUBtR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Aug 2019 21:49:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=SGtyDfOk7ztf7e1zq8UPqa3xUIMnaYAeWahTWcEr7d4=; b=MQBLmHoexH6YgdK4vldQKz4da
        8RAZW2Yi8DxJxQAlpwgczYaEaHM1c41vT1AnkpoCnNqXbGnGTNghSk0fVikznf0kIEi0v+5N5r8g1
        /6oblkV7iXrJ3a45Axj84aDQZSNiq8kQRjY+HUCF8V1Py56nJy0hBCl9/lpFyn+yndcDaRZqJkzVt
        bIi8Pv29Kk3FsfaRxdzwIJpj8AfPIsMMPyFdhswi9/+xmIhUaAbFj+F5czW5zAlG2znKGKTxCbpT/
        UF3RHjXmL4RitId7QozMvfJ4mmRlqlKtKIA6x7b3LDsgzeXJblkyLmEfssdO0Km6aGAzq3az5/zkW
        SJ4UIFkeA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i0FkA-0003gm-R5; Wed, 21 Aug 2019 01:48:58 +0000
Date:   Tue, 20 Aug 2019 18:48:58 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Christoph Hellwig <hch@infradead.org>, dsterba@suse.cz,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        erhard_f@mailbox.org, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-btrfs@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] btrfs: fix allocation of bitmap pages.
Message-ID: <20190821014858.GA9158@infradead.org>
References: <20190817074439.84C6C1056A3@localhost.localdomain>
 <20190819174600.GN24086@twin.jikos.cz>
 <20190820023031.GC9594@infradead.org>
 <6f99b73c-db8f-8135-b827-0a135734d7da@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f99b73c-db8f-8135-b827-0a135734d7da@suse.cz>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 20, 2019 at 01:06:25PM +0200, Vlastimil Babka wrote:
> > The whole point of copy_page is to copy exactly one page and it makes
> > sense to assume that is aligned.  A sane memcpy would use the same
> > underlying primitives as well after checking they fit.  So I think the
> > prime issue here is btrfs' use of copy_page instead of memcpy.  The
> > secondary issue is slub fucking up alignments for no good reason.  We
> > just got bitten by that crap again in XFS as well :(
> 
> Meh, I should finally get back to https://lwn.net/Articles/787740/ right

Yes.  For now Dave came up with an idea for a workaround that will
be forward-compatible with that:

https://www.spinics.net/lists/linux-xfs/msg30521.html
