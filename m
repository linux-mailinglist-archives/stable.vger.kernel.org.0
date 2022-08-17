Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8D8F596919
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 08:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbiHQGA6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 02:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231362AbiHQGA5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 02:00:57 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DD1474343;
        Tue, 16 Aug 2022 23:00:56 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5568868AA6; Wed, 17 Aug 2022 08:00:47 +0200 (CEST)
Date:   Wed, 17 Aug 2022 08:00:45 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Michal Hocko <mhocko@suse.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        john.p.donnelly@oracle.com, david@redhat.com, bhe@redhat.com
Subject: Re: + dma-pool-do-not-complain-if-dma-pool-is-not-allocated.patch
 added to mm-hotfixes-unstable branch
Message-ID: <20220817060045.GA29227@lst.de>
References: <20220810013308.5E23AC433C1@smtp.kernel.org> <20220810140030.GA24195@lst.de> <YvP9YITH0RpgpblG@dhcp22.suse.cz> <20220811092911.GA22246@lst.de> <YvTRFxkmSuDAyVdI@dhcp22.suse.cz> <20220813062913.GA10523@lst.de> <YvoG2YeaiwYsxg9y@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvoG2YeaiwYsxg9y@dhcp22.suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 15, 2022 at 10:42:01AM +0200, Michal Hocko wrote:
> Anyway, you seem to be not thrilled about the __GFP_NOWARN approach and
> I won't push it. But is the existing inconsistency really desirable? I
> mean we can get pretty vocal warning if the allocation fails but no
> information when the zone doesn't have any managed memory. Why should we
> treat them differently? 

How could we end up having ZONE_DMA without any managed memory to start
with except for the case where the total memory is smaller than what
fits into ZONE_DMA?  If we have such a case we really should warn about
it as well.
