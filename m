Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85DE321224C
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 13:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728663AbgGBL26 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jul 2020 07:28:58 -0400
Received: from mga17.intel.com ([192.55.52.151]:17851 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728661AbgGBL26 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jul 2020 07:28:58 -0400
IronPort-SDR: mdM+rUncm4MLNnTzFQCIVuYzAHoDKJiutv3b/M3N2CZ1w/Iqy0KtG7Gsel8ghmzBOngyoDRYPY
 jqFK9ZGDGvQw==
X-IronPort-AV: E=McAfee;i="6000,8403,9669"; a="126948031"
X-IronPort-AV: E=Sophos;i="5.75,304,1589266800"; 
   d="scan'208";a="126948031"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2020 04:28:58 -0700
IronPort-SDR: 9pspgZgUgzf7zRU62SMBhQfnaU/uODCsqnCGJmwULdBs3t7b8znyp7HUUCefXA4c2HsAAYqLai
 Io5U+R/YQi8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,304,1589266800"; 
   d="scan'208";a="481972084"
Received: from yhuang-dev.sh.intel.com (HELO yhuang-dev) ([10.239.159.23])
  by fmsmga005.fm.intel.com with ESMTP; 02 Jul 2020 04:28:55 -0700
From:   "Huang\, Ying" <ying.huang@intel.com>
To:     Dave Hansen <dave.hansen@linux.intel.com>
Cc:     <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <ben.widawsky@intel.com>, <alex.shi@linux.alibaba.com>,
        <dwagner@suse.de>, <tobin@kernel.org>, <cl@linux.com>,
        <akpm@linux-foundation.org>, <dan.j.williams@intel.com>,
        <cai@lca.pw>, <stable@vger.kernel.org>
Subject: Re: [PATCH 1/3] mm/vmscan: restore zone_reclaim_mode ABI
References: <20200701152621.D520E62B@viggo.jf.intel.com>
        <20200701152623.384AF0A7@viggo.jf.intel.com>
Date:   Thu, 02 Jul 2020 19:28:55 +0800
In-Reply-To: <20200701152623.384AF0A7@viggo.jf.intel.com> (Dave Hansen's
        message of "Wed, 1 Jul 2020 08:26:23 -0700")
Message-ID: <87d05ejgug.fsf@yhuang-dev.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dave Hansen <dave.hansen@linux.intel.com> writes:

> From: Dave Hansen <dave.hansen@linux.intel.com>
>
> I went to go add a new RECLAIM_* mode for the zone_reclaim_mode
> sysctl.  Like a good kernel developer, I also went to go update the
> documentation.  I noticed that the bits in the documentation didn't
> match the bits in the #defines.
>
> The VM never explicitly checks the RECLAIM_ZONE bit.  The bit is,
> however implicitly checked when checking 'node_reclaim_mode==0'.
> The RECLAIM_ZONE #define was removed in a cleanup.  That, by itself
> is fine.
>
> But, when the bit was removed (bit 0) the _other_ bit locations also
> got changed.  That's not OK because the bit values are documented to
> mean one specific thing and users surely rely on them meaning that one
> thing and not changing from kernel to kernel.  The end result is that
> if someone had a script that did:
>
> 	sysctl vm.zone_reclaim_mode=1
>
> That script went from doing nothing

Per my understanding, this script would have enabled node reclaim for
clean unmapped pages before commit 648b5cf368e0 ("mm/vmscan: remove
unused RECLAIM_OFF/RECLAIM_ZONE").  So we should revise the description
here?

> to writing out pages during
> node reclaim after the commit in question.  That's not great.
>
> Put the bits back the way they were and add a comment so something
> like this is a bit harder to do again.  Update the documentation to
> make it clear that the first bit is ignored.
>

Best Regards,
Huang, Ying
