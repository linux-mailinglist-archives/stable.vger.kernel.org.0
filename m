Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5155E5E3A5
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 14:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725944AbfGCMRo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 08:17:44 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:33644 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfGCMRo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jul 2019 08:17:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=hc324U3gAsxTQ/xr9GNXQHJJuTwkj9Ztqk5d0xFNlFU=; b=Xj2zv+NLMKqcrDj7CARx0zOVI
        jJK06jsuo+7e0kGWyVsxlo9JpCRcFvB70RUcxc76zUpG5U8ZMGyFvIObD6VE1TsfdpdgsvZhGdWFZ
        3vKAdB1dzqzis3/L2txNhzx46f8QXrWRy0dYKjBKiFxHq3dZAxgiQCItF9xKq7V/WZXyz+Pxa6gC9
        lxaJgQUtqqeiKyI1pjLnOiLEvaDiKkW/mQc6JeWowqfBpEQcuiPXAoV1PhCVx+RpVimMl2NcX+Q7n
        fDLBWQsDHhwFnZcYUCn75x+jq0vtuq8cF1nAbAOALi8y6bGYnc4QT8GquQ/xpHG8pqAEUvHzvSFVu
        a4VGSS+pA==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hieCl-0000Gy-GK; Wed, 03 Jul 2019 12:17:43 +0000
Date:   Wed, 3 Jul 2019 05:17:43 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Boaz Harrosh <openosd@gmail.com>, stable@vger.kernel.org,
        Robert Barror <robert.barror@intel.com>,
        Seema Pandit <seema.pandit@intel.com>,
        linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dax: Fix missed PMD wakeups
Message-ID: <20190703121743.GH1729@bombadil.infradead.org>
References: <156213869409.3910140.7715747316991468148.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156213869409.3910140.7715747316991468148.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 03, 2019 at 12:24:54AM -0700, Dan Williams wrote:
> This fix may increase waitqueue contention, but a fix for that is saved
> for a larger rework. In the meantime this fix is suitable for -stable
> backports.

I think this is too big for what it is; just the two-line patch to stop
incorporating the low bits of the PTE would be more appropriate.
