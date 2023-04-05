Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 531586D7BE0
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 13:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237291AbjDELsT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 07:48:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237708AbjDELsS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 07:48:18 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E409010C2
        for <stable@vger.kernel.org>; Wed,  5 Apr 2023 04:48:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1680695293; x=1712231293;
  h=from:to:cc:subject:references:date:in-reply-to:
   message-id:mime-version;
  bh=vyvI49OUnAGQE/Frki4ErHvvcpnttUz3te/BYi41UXU=;
  b=IeQ3TkE/nZZHEJC/41AMOab7+1nyDrPUEd/RXy+GeMmSL7oNmCuuZtp0
   dzuSF/3xhIQJmRAHGXkoQvieJE3s+rJTpo9IBws7ZDNhGzCsI7yMQwuJU
   Ei+sADS4KsXdJayHt/dYqINtRRtT8opI/JjYbi8eATK+MhcsKfS5v5bwT
   c=;
X-IronPort-AV: E=Sophos;i="5.98,319,1673913600"; 
   d="scan'208";a="201193846"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-d2040ec1.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 11:48:09 +0000
Received: from EX19MTAUEA002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-m6i4x-d2040ec1.us-west-2.amazon.com (Postfix) with ESMTPS id 652D840E6D;
        Wed,  5 Apr 2023 11:48:08 +0000 (UTC)
Received: from EX19MTAUEA001.ant.amazon.com (10.252.134.203) by
 EX19MTAUEA002.ant.amazon.com (10.252.134.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 5 Apr 2023 11:47:54 +0000
Received: from dev-dsk-ptyadav-1c-37607b33.eu-west-1.amazon.com (10.15.11.255)
 by mail-relay.amazon.com (10.252.134.102) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Wed, 5 Apr 2023 11:47:54 +0000
Received: by dev-dsk-ptyadav-1c-37607b33.eu-west-1.amazon.com (Postfix, from userid 23027615)
        id 0874A22BC6; Wed,  5 Apr 2023 13:47:52 +0200 (CEST)
From:   Pratyush Yadav <ptyadav@amazon.de>
To:     kernel test robot <lkp@intel.com>
CC:     <stable@vger.kernel.org>, <oe-kbuild-all@lists.linux.dev>
Subject: Re: [PATCH 5.4] cifs/smb3: Fix NULL pointer dereference in
 smb2_query_info_compound()
References: <ZC1fJiHvpbXcysXi@ec83ac1404bb>
Date:   Wed, 5 Apr 2023 13:47:52 +0200
In-Reply-To: <ZC1fJiHvpbXcysXi@ec83ac1404bb> (kernel test robot's message of
        "Wed, 5 Apr 2023 19:44:38 +0800")
Message-ID: <mafs0o7o2h7o7.fsf@amazon.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 05 2023, kernel test robot wrote:

> Hi,
>
> Thanks for your patch.
>
> FYI: kernel test robot notices the stable kernel rule is not satisfied.
>
> Rule: 'Cc: stable@vger.kernel.org' or 'commit <sha1> upstream.'

I think the robot should also learn to look at the 'To:' header :-)

> Subject: [PATCH 5.4] cifs/smb3: Fix NULL pointer dereference in smb2_query_info_compound()
> Link: https://lore.kernel.org/stable/20230405114220.108739-1-ptyadav%40amazon.de
>
> The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
>

-- 
Regards,
Pratyush Yadav



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



