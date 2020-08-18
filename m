Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEB082484B3
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 14:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbgHRM0M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 08:26:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60786 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726650AbgHRM0L (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Aug 2020 08:26:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597753568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=57TjqxhkQ8QjiWbPTIO4eMpJo8mKz2chCjyWEwsYBB0=;
        b=FNFS3qujCC+wtoQT7tPilW3Dsn3AlL7Bn04uJYiZTdnpRgAFXUGvLhRzLR9iJkP4T2YW26
        0XVuocl6xnfipRWNTL1nTAnJxGEd1aZ1KO42ngY8NBnSKChTF0W9IirGbJ05r4L+rISrXG
        JVDAVf2CfDAwQ1B6B18C0m2F5snlj4Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-6-cKd5Un22MFGnr-MlnpxZqA-1; Tue, 18 Aug 2020 08:26:06 -0400
X-MC-Unique: cKd5Un22MFGnr-MlnpxZqA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0B1F9100CA8C;
        Tue, 18 Aug 2020 12:26:05 +0000 (UTC)
Received: from [10.36.113.168] (ovpn-113-168.ams2.redhat.com [10.36.113.168])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7446F7DFD1;
        Tue, 18 Aug 2020 12:26:03 +0000 (UTC)
Subject: Re: [PATCH STABLE 4.9] mm: Avoid calling build_all_zonelists_init
 under hotplug context
To:     Oscar Salvador <osalvador@suse.de>, stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com,
        vbabka@suse.com, Vlastimil Babka <vbabka@suse.cz>
References: <20200818110046.6664-1-osalvador@suse.de>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
 WNyWQQ==
Organization: Red Hat GmbH
Message-ID: <4c604399-8a92-16e4-8fea-682bb0abb1dc@redhat.com>
Date:   Tue, 18 Aug 2020 14:26:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200818110046.6664-1-osalvador@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 18.08.20 13:00, Oscar Salvador wrote:
> Recently a customer of ours experienced a crash when booting the
> system while enabling memory-hotplug.
> 
> The problem is that Normal zones on different nodes don't get their private
> zone->pageset allocated, and keep sharing the initial boot_pageset.
> The sharing between zones is normally safe as explained by the comment for
> boot_pageset - it's a percpu structure, and manipulations are done with
> disabled interrupts, and boot_pageset is set up in a way that any page placed
> on its pcplist is immediately flushed to shared zone's freelist, because
> pcp->high == 1.
> However, the hotplug operation updates pcp->high to a higher value as it
> expects to be operating on a private pageset.
> 
> The problem is in build_all_zonelists(), which is called when the first range
> of pages is onlined for the Normal zone of node X or Y:
> 
> 	if (system_state == SYSTEM_BOOTING) {
> 		build_all_zonelists_init();
> 	} else {
> 	#ifdef CONFIG_MEMORY_HOTPLUG
> 		if (zone)
> 			setup_zone_pageset(zone);
> 	#endif
> 		/* we have to stop all cpus to guarantee there is no user
> 		of zonelist */
> 		stop_machine(__build_all_zonelists, pgdat, NULL);
> 		/* cpuset refresh routine should be here */
> 	}
> 
> When called during hotplug, it should execute the setup_zone_pageset(zone)
> which allocates the private pageset.
> However, with memhp_default_state=online, this happens early while
> system_state == SYSTEM_BOOTING is still true, hence this step is skipped.
> (and build_all_zonelists_init() is probably unsafe anyway at this point).
> 
> Another hotplug operation on the same zone then leads to zone_pcp_update(zone)
> called from online_pages(), which updates the pcp->high for the shared
> boot_pageset to a value higher than 1.
> At that point, pages freed from Node X and Y Normal zones can end up on the same
> pcplist and from there they can be freed to the wrong zone's freelist,
> leading to the corruption and crashes.
> 
> Please, note that upstream has fixed that differently (and unintentionally) by
> adding another boot state (SYSTEM_SCHEDULING), which is set before smp_init().
> That should happen before memory hotplug events even with memhp_default_state=online.
> Backporting that would be too intrusive.
> 
> Signed-off-by: Oscar Salvador <osalvador@suse.de>
> Debugged-by: Vlastimil Babka <vbabka@suse.cz>

So, we have ACPI running and already adding DIMMs while booting? Crazy.

Looks sane to me. Thanks!


-- 
Thanks,

David / dhildenb

