Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD557586AEC
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234658AbiHAMic (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232240AbiHAMiR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:38:17 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 965409EC5C;
        Mon,  1 Aug 2022 05:17:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1659356253; x=1690892253;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ySOxho5n+e29wKv8kNSyg1yqXHN2bw+cAsG5rNSiT8k=;
  b=ddaW4Nh6W3gn0B7l6DnA/f66YqZ1UehqBTinXKg1Z677qUvEgmRU3w/H
   F8jR+XbJPDolS+1ZYerOopp22Vys71J4oWi+P2Z5tp+OClT0vXkIURxl2
   jAKVWVy2R0X2yzRu7b0Sptm5ivvs0hGKeNOBCY8jMRK4RodCB6yJLrodw
   w=;
X-IronPort-AV: E=Sophos;i="5.93,206,1654560000"; 
   d="scan'208";a="114337904"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-d9fba5dd.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2022 12:17:12 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-d9fba5dd.us-west-2.amazon.com (Postfix) with ESMTPS id E0BE24436F;
        Mon,  1 Aug 2022 12:17:11 +0000 (UTC)
Received: from EX13D41UWB001.ant.amazon.com (10.43.161.189) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Mon, 1 Aug 2022 12:17:11 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D41UWB001.ant.amazon.com (10.43.161.189) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Mon, 1 Aug 2022 12:17:11 +0000
Received: from dev-dsk-mheyne-1b-c1362c4d.eu-west-1.amazon.com (10.15.57.183)
 by mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP Server id
 15.0.1497.36 via Frontend Transport; Mon, 1 Aug 2022 12:17:10 +0000
Received: by dev-dsk-mheyne-1b-c1362c4d.eu-west-1.amazon.com (Postfix, from userid 5466572)
        id CEB4A2461; Mon,  1 Aug 2022 12:17:09 +0000 (UTC)
Date:   Mon, 1 Aug 2022 12:17:09 +0000
From:   Maximilian Heyne <mheyne@amazon.de>
To:     SeongJae Park <sj@kernel.org>
CC:     <roger.pau@citrix.com>, <axboe@kernel.dk>,
        <boris.ostrovsky@oracle.com>, <jgross@suse.com>,
        <olekstysh@gmail.com>, <andrii.chepurnyi82@gmail.com>,
        <xen-devel@lists.xenproject.org>, <linux-block@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH v4 0/3] xen-blk{back, front}: Fix two bugs in
 'feature_persistent'
Message-ID: <20220801121709.GA40940@dev-dsk-mheyne-1b-c1362c4d.eu-west-1.amazon.com>
References: <20220715225108.193398-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220715225108.193398-1-sj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 15, 2022 at 10:51:05PM +0000, SeongJae Park wrote:
> 
> Introduction of 'feature_persistent' made two bugs.  First one is wrong
> overwrite of 'vbd->feature_gnt_persistent' in 'blkback' due to wrong
> parameter value caching position, and the second one is unintended
> behavioral change that could break previous dynamic frontend/backend
> persistent feature support changes.  This patchset fixes the issues.
> 
> Changes from v3
> (https://lore.kernel.org/xen-devel/20220715175521.126649-1-sj@kernel.org/)
> - Split 'blkback' patch for each of the two issues
> - Add 'Reported-by: Andrii Chepurnyi <andrii.chepurnyi82@gmail.com>'
> 
> Changes from v2
> (https://lore.kernel.org/xen-devel/20220714224410.51147-1-sj@kernel.org/)
> - Keep the behavioral change of v1
> - Update blkfront's counterpart to follow the changed behavior
> - Update documents for the changed behavior
> 
> Changes from v1
> (https://lore.kernel.org/xen-devel/20220106091013.126076-1-mheyne@amazon.de/)
> - Avoid the behavioral change
>   (https://lore.kernel.org/xen-devel/20220121102309.27802-1-sj@kernel.org/)
> - Rebase on latest xen/tip/linux-next
> - Re-work by SeongJae Park <sj@kernel.org>
> - Cc stable@
> 
> Maximilian Heyne (1):
>   xen-blkback: Apply 'feature_persistent' parameter when connect
> 
> SeongJae Park (2):
>   xen-blkback: fix persistent grants negotiation
>   xen-blkfront: Apply 'feature_persistent' parameter when connect
> 
>  .../ABI/testing/sysfs-driver-xen-blkback      |  2 +-
>  .../ABI/testing/sysfs-driver-xen-blkfront     |  2 +-
>  drivers/block/xen-blkback/xenbus.c            | 20 ++++++++-----------
>  drivers/block/xen-blkfront.c                  |  4 +---
>  4 files changed, 11 insertions(+), 17 deletions(-)
> 
> --
> 2.25.1
> 

Changes look good to me. Thank you for reworking my patch and also fixing the
blkfront driver.

Reviewed-by: Maximilian Heyne <mheyne@amazon.de>



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



