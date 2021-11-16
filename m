Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B09F2452DBD
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 10:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232784AbhKPJUI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 04:20:08 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:41392 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232764AbhKPJUH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 04:20:07 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id D81CD212BA;
        Tue, 16 Nov 2021 09:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1637054229; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AIbvDzruXDpiz6o3C+vMRbbHQk4h/5m45mBuGjw+Bc4=;
        b=vPXOYsZ+YGsdnTvLdoviWTzMHpBOs8vIr1ssujT58Xu4bpxz0lXV3v5OTE7y3I6P/lnoEC
        WcFwW5YORxz7jMShxLrwdrGPzmtLxE987oPrx61ukpfz5CCSvtlhcqMpbabYjNgIVPERXQ
        ahh2LtMWmUAL3sSkf/LiekhW+FAapsc=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id A452DA3B83;
        Tue, 16 Nov 2021 09:17:09 +0000 (UTC)
Date:   Tue, 16 Nov 2021 10:17:07 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     Alexey Makhalov <amakhalov@vmware.com>
Cc:     Dennis Zhou <dennis@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Oscar Salvador <osalvador@suse.de>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v3] mm: fix panic in __alloc_pages
Message-ID: <YZN3ExwL7BiDS5nj@dhcp22.suse.cz>
References: <908909e0-4815-b580-7ff5-d824d36a141c@redhat.com>
 <20211108202325.20304-1-amakhalov@vmware.com>
 <2e191db3-286f-90c6-bf96-3f89891e9926@gmail.com>
 <YYqstfX8PSGDfWsn@dhcp22.suse.cz>
 <YYrGpn/52HaLCAyo@fedora>
 <YYrSC7vtSQXz652a@dhcp22.suse.cz>
 <BAE95F0C-FAA7-40C6-A0D6-5049B1207A27@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BAE95F0C-FAA7-40C6-A0D6-5049B1207A27@vmware.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 16-11-21 01:31:44, Alexey Makhalov wrote:
[...]
> diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.c
> index 6737b1cbf..bbc1a70d5 100644
> --- a/drivers/acpi/acpi_processor.c
> +++ b/drivers/acpi/acpi_processor.c
> @@ -200,6 +200,10 @@ static int acpi_processor_hotadd_init(struct acpi_processor *pr)
>          * gets online for the first time.
>          */
>         pr_info("CPU%d has been hot-added\n", pr->id);
> +       {
> +               int nid = cpu_to_node(pr->id);
> +               printk("%s:%d cpu %d, node %d, online %d, ndata %p\n", __FUNCTION__, __LINE__, pr->id, nid, node_online(nid), NODE_DATA(nid));
> +       }
>         pr->flags.need_hotplug_init = 1;

OK, IIUC you are adding a processor which is outside of
possible_cpu_mask and that means that the node is not allocated for such
a future to be hotplugged cpu and its memory node. init_cpu_to_node
would have done that initialization otherwise. I think you want to talk
to x86 maintainers and people who have introduced a support for
memoryless nodes for x86.

To me it seems like you are trying to use a functionality that has
never been properly implemented. I do not remember how other acpi based
architectures handle this and maybe we need a generic solution and that
would bring up the node as soon as a new cpu is hot added.
-- 
Michal Hocko
SUSE Labs
