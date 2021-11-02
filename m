Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0F58442F74
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 14:52:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbhKBNyk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 09:54:40 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:43750 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbhKBNyj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Nov 2021 09:54:39 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 1DC641FD3D;
        Tue,  2 Nov 2021 13:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1635861124; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QuhDls7hbN4UKLnf4cjWDbk3jK59u3TGKj6IxVYK1C0=;
        b=Mz70zonVUxIqoOeRaeX5b5iUesoDtqU//LQYeHkDgXEKjZQk4BPwUh8Q16H3FfqeqNwUqG
        Px3SmOC855+OXTRcIH6tJp7WxKC2sHqjGKVlqQLMhnQXvfVydyFhK0UDRonvKC1dYzjzep
        Z1Ha7d1cNAV4S2M5nLHI/2S9uU+il6o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1635861124;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QuhDls7hbN4UKLnf4cjWDbk3jK59u3TGKj6IxVYK1C0=;
        b=DF7kJtMQlHoUDmQXqJHlVbSNLh6MVgIoT2I1y+rquXauor8l5KxpS/H5gNXP7KX88yHphb
        N9rPZG2TjYJCrEAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7E41613D66;
        Tue,  2 Nov 2021 13:52:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id uxBiG4NCgWHKGAAAMHmgww
        (envelope-from <osalvador@suse.de>); Tue, 02 Nov 2021 13:52:03 +0000
Date:   Tue, 2 Nov 2021 14:52:01 +0100
From:   Oscar Salvador <osalvador@suse.de>
To:     Michal Hocko <mhocko@suse.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Alexey Makhalov <amakhalov@vmware.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Oscar Salvador <OSalvador@suse.com>
Subject: Re: [PATCH] mm: fix panic in __alloc_pages
Message-ID: <20211102135201.GA4348@linux>
References: <C69EF2FE-DFF6-492E-AD40-97A53739C3EC@vmware.com>
 <YYD/FkpAk5IvmOux@dhcp22.suse.cz>
 <b2e4a611-45a6-732a-a6d3-6042afd2af6e@redhat.com>
 <E34422F0-A44A-48FD-AE3B-816744359169@vmware.com>
 <b3908fce-6b07-8390-b691-56dd2f85c05f@redhat.com>
 <YYEkqH8l0ASWv/JT@dhcp22.suse.cz>
 <42abfba6-b27e-ca8b-8cdf-883a9398b506@redhat.com>
 <YYEun6s/mF9bE+rQ@dhcp22.suse.cz>
 <e7aed7c0-b7b1-4a94-f323-0bcde2f879d2@redhat.com>
 <YYE8L4gs8/+HH6bf@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYE8L4gs8/+HH6bf@dhcp22.suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 02, 2021 at 02:25:03PM +0100, Michal Hocko wrote:
> I think we want to learn how exactly Alexey brought that cpu up. Because
> his initial thought on add_cpu resp cpu_up doesn't seem to be correct.
> Or I am just not following the code properly. Once we know all those
> details we can get in touch with cpu hotplug maintainers and see what
> can we do.

I am not really familiar with CPU hot-onlining, but I have been taking a look.
As with memory, there are two different stages, hot-adding and onlining (and the
counterparts).

Part of the hot-adding being:

acpi_processor_get_info
 acpi_processor_hotadd_init
  arch_register_cpu
   register_cpu

One of the things that register_cpu() does is to set cpu->dev.bus pointing to
&cpu_subsys, which is:

struct bus_type cpu_subsys = {
	.name = "cpu",
	.dev_name = "cpu",
	.match = cpu_subsys_match,
#ifdef CONFIG_HOTPLUG_CPU
	.online = cpu_subsys_online,
	.offline = cpu_subsys_offline,
#endif
};

Then, the onlining part (in case of a udev rule or someone onlining the device)
would be:

online_store
 device_online
  cpu_subsys_online
   cpu_device_up
    cpu_up
     ...
     online node

Since Alexey disabled the udev rule and no one onlined the CPU, online_store()->
device_online() wasn't really called.

The following only applies to x86_64:
I think we got confused because cpu_device_up() is also called from add_cpu(),
but that is an exported function and x86 does not call add_cpu() unless for
debugging purposes (check kernel/torture.c and arch/x86/kernel/topology.c).
It does the onlining through online_store()...
So we can take add_cpu() off the equation here.


-- 
Oscar Salvador
SUSE Labs
