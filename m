Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 744F3697753
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 08:25:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbjBOHZf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 02:25:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233210AbjBOHZe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 02:25:34 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF03128D1A;
        Tue, 14 Feb 2023 23:25:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676445933; x=1707981933;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LjjaY0wanbjM2Voc9Vtc9KSHmGP3+aYOAzgwBVYIhMI=;
  b=KZ2L4ug0m4hsMczolIRkP2SOTRZ8RNLC9poZntUGHueDsEkqWmM/AdtB
   3FgGcZ0TlKLMpVJQzYpKW8IMkt07zDoOTTHofOJFlRoFfoMB7yeUfEWNS
   DVpXs58WFfaJrPY3nb7pbr7luxpof0rjA6IwBPqbblGhtCIzhNhWXZ4XT
   qH2MVgC99XPhbu0R53LpL1zy2vAKnS6JgkuKPzhe4DGjmuKIeB6jGpkY9
   9SGpnE3sWJOuV3EJpUxfcWsdkEsdRhbXzmCqtYifwHwnp8/vrXoa48H8l
   hNmretR+BMU73xfyCV7Gd34pQQiqKNLcLwrwVzfrX8dV1t6sKRNVGFbp4
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="358785066"
X-IronPort-AV: E=Sophos;i="5.97,299,1669104000"; 
   d="scan'208";a="358785066"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 23:25:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="699858490"
X-IronPort-AV: E=Sophos;i="5.97,299,1669104000"; 
   d="scan'208";a="699858490"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga008.jf.intel.com with ESMTP; 14 Feb 2023 23:25:30 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id A1EF61C5; Wed, 15 Feb 2023 09:26:10 +0200 (EET)
Date:   Wed, 15 Feb 2023 09:26:10 +0200
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     Andreas Noever <andreas.noever@gmail.com>,
        Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>, Sanju.Mehta@amd.com,
        stable@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] thunderbolt: Read DROM directly from NVM before
 trying bit banging
Message-ID: <Y+yJEjLa9R1JGlIu@black.fi.intel.com>
References: <20230214154647.874-1-mario.limonciello@amd.com>
 <20230214154647.874-2-mario.limonciello@amd.com>
 <Y+x0cbSpnIPYjZJE@black.fi.intel.com>
 <8f099a80-7fd1-c98a-4990-4a936a5a610a@amd.com>
 <Y+x6pwHKDe2gXNUY@black.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y+x6pwHKDe2gXNUY@black.fi.intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 15, 2023 at 08:24:39AM +0200, Mika Westerberg wrote:
> > I guess something else that might be less detrimental the loss of UUID
> > by reading DROM this way would be to only read DROM this way if any CRC
> > failed.
> 
> Actually we do read UUID for TBT3 devices from link controller registers
> (see tb_lc_read_uuid()) instead so I think perhaps we can limit the
> bitbanging just for older TBT devices with no LC or something like that?

Just make sure UUID stays the same so that users don't need to
re-authorize their devices.
