Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A85ECA6DEF
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728860AbfICQTX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:19:23 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:34218 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727810AbfICQTW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Sep 2019 12:19:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=z5XTZr7KAHvUQ4zGXGR/ag1TGXf5dCpTr/unRHYAJ7g=; b=Bur85jcXN6qdZR7BAaREK0n9B
        zf3aQl5Asp9yOMHp8LiA/lGecRINQL1AtQC2NakcoqnpxdzqWH6YOveapcPtu90WSEaAR1JOIVq40
        GvSqYZueFIGopfL35Usck7GGsNEn2j/h/k/M07Tu8yufkvEOsVQ5CBbaGm+vYuxllWwfN12me2hob
        M7OqeqSL5c0QhdGvA0qHdv7wJn9CcsAGaw0pETuU2f3MMuCp6KB4qRZk+M9iAvAxij+LZXXK/I8oV
        un3lg4mEomBDYDv1UPuLbSYXpVLU0SospuZYymNEqy5HSSeCXNxA9LsQWxKAiSDa5FZSgVJo4M50F
        OP3qp4+SQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i5BWX-00068r-Tm; Tue, 03 Sep 2019 16:19:17 +0000
Date:   Tue, 3 Sep 2019 09:19:17 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Mike Travis <mike.travis@hpe.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>,
        Dimitri Sivanich <dimitri.sivanich@hpe.com>,
        Russ Anderson <russ.anderson@hpe.com>,
        Hedi Berriche <hedi.berriche@hpe.com>,
        Steve Wahl <steve.wahl@hpe.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 8/8] x86/platform/uv: Account for UV Hubless in
 is_uvX_hub Ops
Message-ID: <20190903161917.GA23281@infradead.org>
References: <20190903001815.504418099@stormcage.eag.rdlabs.hpecorp.net>
 <20190903001816.705097213@stormcage.eag.rdlabs.hpecorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190903001816.705097213@stormcage.eag.rdlabs.hpecorp.net>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 02, 2019 at 07:18:23PM -0500, Mike Travis wrote:
> +#ifdef	UV1_HUB_IS_SUPPORTED

All these ifdefs are dead code, please just remove them.

Also it seems like at least the various mmr macros just check
for a specific version, I think you are much better off just
using a switch statement for the possible revisions there.

> +		return (uv_hub_info->hub_revision == UV4A_HUB_REVISION_BASE);

And none of these braces are required.
