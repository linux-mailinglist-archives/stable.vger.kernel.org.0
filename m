Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58DBA7A15B
	for <lists+stable@lfdr.de>; Tue, 30 Jul 2019 08:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727358AbfG3Giq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jul 2019 02:38:46 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53118 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726736AbfG3Giq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jul 2019 02:38:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=YkfJp93d1ohj3Bbmj3d25o5QzlPIkOwC8l2K/xOCTnQ=; b=hQhQ6PBe/YM6WQezX8UNvl2yQ
        LUHQl+a1MJkPFxl8imZ59d6sDF33V0PaBEYu/7B3FEsfbJgl4fjp1ud3qcdACZi8Had/xbzFgQ/o/
        b71aeX3/AbBR8rp2yJEHeP+mH9nNUDDeC+fyy49fhc+LQUW5GvwWRQH/2zwc1tEKJ25iGJJ9Alx2r
        tKme/u+fm+zlZjpoYDxK2DHEO0//iWudSn8ipG6PL6TQo4ZtNnDeF0odXTfk3elkUntH0BWRdm1Ui
        Uz9h7jaiJ8TBHAXRUYos4IWwSxXpbbTfXi13R3EV6FtwjE6vV2z8Q1shLkJRPLu4qfXOZbpgp+l65
        jYmmNstWg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hsLmX-0005jg-6M; Tue, 30 Jul 2019 06:38:45 +0000
Date:   Mon, 29 Jul 2019 23:38:45 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Suganath Prabu <suganath-prabu.subramani@broadcom.com>,
        linux-scsi <linux-scsi@vger.kernel.org>, stable@vger.kernel.org,
        Sathya Prakash <Sathya.Prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>
Subject: Re: [PATCH] mpt3sas: Use 63-bit DMA addressing on SAS35 HBA
Message-ID: <20190730063845.GA16355@infradead.org>
References: <1564135257-33188-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <20190726142706.GA1734@infradead.org>
 <CAK=zhgrWW_vOkXKRYRbiMdHgiT7u=Ra_pCkO_HkmQrCdVXfJBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK=zhgrWW_vOkXKRYRbiMdHgiT7u=Ra_pCkO_HkmQrCdVXfJBQ@mail.gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 29, 2019 at 05:25:35PM +0530, Sreekanth Reddy wrote:
> 
> I agree with your above statement. But it is also possible that
> 0xFFFFFFFF-FFFFFFFF falls under the DMA able range, e.g. SGE's start
> address is 0xFFFFFFFF-FFFF000 and data length is 0x1000 bytes. So when
> HBA tries to DMA the data at 0xFFFFFFFF-FFFFFFFF location then it will
> faults the firmware due to it's hardware design.
> 
> We have observed above example's SGE address and length on AMD systems
> with SME & IOMMU enabled.

Ok.  Please slightly update the changelog to say dma ranges instead
of a dma address, as that implicies the addr field in the sg to me.

Otherwise looks ok:

Reviewed-by: Christoph Hellwig <hch@lst.de>
