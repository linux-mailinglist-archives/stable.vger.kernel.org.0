Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56BA876B95
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 16:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727403AbfGZO1H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 10:27:07 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:58188 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726731AbfGZO1H (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jul 2019 10:27:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=nYu9AqARyg1s9xhIySXzwj35RjVZXlDWPNT++weib0Q=; b=L6TPMw34jBusFt1s+qu213+qb
        KGYpi2YSVUoYuGkZ3fazfm/2etpjsXmYTz7h4egt1ZYYYyosg8PjN2teBZ3tFpHQKHEKLZMcGzVUg
        ZyGitzgaYZRugjqFc6rrxndPFB68yIdbMrkmItpFfS8TnGZJ9dzYk6wLTZS6S1zfk7tVvNrhNJQws
        YWeNJngl+hdJ0xmxdwgvAb853vUEyy33B5HzicmU9CTdTk7GQz/tluuNfmTSHIbsF0sDoy3EaVqWl
        EGeFQlMVyCERG7Nqqd3dRiIGE61OoIEgKpQ/ftyEewv/bDBh0iICjZk3QpoeBIeqe7F94grrYQLJV
        lXpuP+f5Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hr1Ba-0000WQ-UX; Fri, 26 Jul 2019 14:27:06 +0000
Date:   Fri, 26 Jul 2019 07:27:06 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Suganath Prabu <suganath-prabu.subramani@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, stable@vger.kernel.org,
        Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com,
        sreekanth.reddy@broadcom.com
Subject: Re: [PATCH] mpt3sas: Use 63-bit DMA addressing on SAS35 HBA
Message-ID: <20190726142706.GA1734@infradead.org>
References: <1564135257-33188-1-git-send-email-suganath-prabu.subramani@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1564135257-33188-1-git-send-email-suganath-prabu.subramani@broadcom.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 26, 2019 at 06:00:57AM -0400, Suganath Prabu wrote:
> Although SAS3 & SAS3.5 IT HBA controllers support
> 64-bit DMA addressing, as per hardware design,
> DMA address with all 64-bits set (0xFFFFFFFF-FFFFFFFF)
> results in a firmware fault.

Linux will never send a dma address with all bits set anyway, as that
is our magic escape for the dma_addr_t error value.  Additionally to
generate that address you'd need a 1-byte sized, 1-byte aligned buffer,
which we never use.
