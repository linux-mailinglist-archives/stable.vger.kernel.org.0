Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63BB4124B4
	for <lists+stable@lfdr.de>; Fri,  3 May 2019 00:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbfEBWqW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 18:46:22 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:40348 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbfEBWqW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 May 2019 18:46:22 -0400
Received: by mail-ed1-f66.google.com with SMTP id e56so3749589ede.7
        for <stable@vger.kernel.org>; Thu, 02 May 2019 15:46:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GA6AE3nbkJUtYedDned7ovjPAtRn38Gv/WcLw3WyhRM=;
        b=VyGHNfvlwO8ONwk/KifhHlo6j+UxiIO6vZVAJEIh/1HVZiBQdm6hsv7Pe0s7LBhtib
         DYwvUG89sAGEQgMraZsleAVrkfz3yCSF5e3mdty7AI3w8fvGzLvrD6iNdbwKzPPO6tB2
         WB6DAwnVzZVm4VW3ZepbbgIK47+nbIKMwSPeEpBw3fktP/V2czpbTX5jTue1sPbgj/eG
         6O2VZ1pwM/NbdV22t+0aEDCpaSSB5dVP9kd5aYfREuFkFv28OxBKfCldjaWjhv274Pe7
         2KZs9Qw1vLvH2eDnNdOeFw5/7sMhPbarlsTLuWEEHjLPnsnzTcCJN1/Gaatld2q9auYL
         jgjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GA6AE3nbkJUtYedDned7ovjPAtRn38Gv/WcLw3WyhRM=;
        b=TVW14BJSsKcg4vz4AT7CbkCcdyR+npjxY9Ww3qP9t9hZ733ieoYmP4gDrzIXekFB6H
         QsvamXmLOrBvFEEpvXMtPXa5fH5RAEK4yKCkEpYF1Sv1q/PNpampIq5jsEt7Jor4yQlW
         jU/2SvcfebbnywMHrtgehgP+QAkD0bpy+XTksMZ6E4cvAbObVuTUHDKVD0vuFhVia0xP
         48jZbrcCT+Tno3sQ8f1We3AI2J5eqpcDIBiuvOqETXPQ+NSf6yiz8hYeinpzuS7IwXIO
         dwe8Wv6FuPmkPfbm7w5+9qg2gWBII4uZv5WTTx1yHCHoviLXpzch1PBQ//nShK1lPkj/
         aOqA==
X-Gm-Message-State: APjAAAUuEnehIshdf9TEeujs2myyTUkGWcDHo/PpoEX5Q2ef5BzkdVeP
        9W60votEZEJhJ7OlRRCkFbgECajPZSKgEdyJwMi16g==
X-Google-Smtp-Source: APXvYqyxp62Y9u8Dg6nAw9ZEhyrJmqsbIRm9Uomm765huXXDRUc3RQdFsZu/ihmrxpq8Al0EC7JMIkEOIXHtl4sV7+o=
X-Received: by 2002:a50:fb19:: with SMTP id d25mr4513007edq.61.1556837180746;
 Thu, 02 May 2019 15:46:20 -0700 (PDT)
MIME-Version: 1.0
References: <155552633539.2015392.2477781120122237934.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <155552633539.2015392.2477781120122237934.stgit@dwillia2-desk3.amr.corp.intel.com>
From:   Pavel Tatashin <pasha.tatashin@soleen.com>
Date:   Thu, 2 May 2019 18:46:09 -0400
Message-ID: <CA+CK2bBT=goxf5KWLhca7uQutUj9670aL9r02_+BsJ+bLkjj=g@mail.gmail.com>
Subject: Re: [PATCH v6 00/12] mm: Sub-section memory hotplug support
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Toshi Kani <toshi.kani@hpe.com>,
        Jeff Moyer <jmoyer@redhat.com>, Michal Hocko <mhocko@suse.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        stable <stable@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Dan,

How do you test these patches? Do you have any instructions?

I see for example that check_hotplug_memory_range() still enforces
memory_block_size_bytes() alignment.

Also, after removing check_hotplug_memory_range(), I tried to online
16M aligned DAX memory, and got the following panic:

# echo online > /sys/devices/system/memory/memory7/state
[  202.193132] WARNING: CPU: 2 PID: 351 at drivers/base/memory.c:207
memory_block_action+0x110/0x178
[  202.193391] Modules linked in:
[  202.193698] CPU: 2 PID: 351 Comm: sh Not tainted
5.1.0-rc7_pt_devdax-00038-g865af4385544-dirty #9
[  202.193909] Hardware name: linux,dummy-virt (DT)
[  202.194122] pstate: 60000005 (nZCv daif -PAN -UAO)
[  202.194243] pc : memory_block_action+0x110/0x178
[  202.194404] lr : memory_block_action+0x90/0x178
[  202.194506] sp : ffff000016763ca0
[  202.194592] x29: ffff000016763ca0 x28: ffff80016fd29b80
[  202.194724] x27: 0000000000000000 x26: 0000000000000000
[  202.194838] x25: ffff000015546000 x24: 00000000001c0000
[  202.194949] x23: 0000000000000000 x22: 0000000000040000
[  202.195058] x21: 00000000001c0000 x20: 0000000000000008
[  202.195168] x19: 0000000000000007 x18: 0000000000000000
[  202.195281] x17: 0000000000000000 x16: 0000000000000000
[  202.195393] x15: 0000000000000000 x14: 0000000000000000
[  202.195505] x13: 0000000000000000 x12: 0000000000000000
[  202.195614] x11: 0000000000000000 x10: 0000000000000000
[  202.195744] x9 : 0000000000000000 x8 : 0000000180000000
[  202.195858] x7 : 0000000000000018 x6 : ffff000015541930
[  202.195966] x5 : ffff000015541930 x4 : 0000000000000001
[  202.196074] x3 : 0000000000000001 x2 : 0000000000000000
[  202.196185] x1 : 0000000000000070 x0 : 0000000000000000
[  202.196366] Call trace:
[  202.196455]  memory_block_action+0x110/0x178
[  202.196589]  memory_subsys_online+0x3c/0x80
[  202.196681]  device_online+0x6c/0x90
[  202.196761]  state_store+0x84/0x100
[  202.196841]  dev_attr_store+0x18/0x28
[  202.196927]  sysfs_kf_write+0x40/0x58
[  202.197010]  kernfs_fop_write+0xcc/0x1d8
[  202.197099]  __vfs_write+0x18/0x40
[  202.197187]  vfs_write+0xa4/0x1b0
[  202.197295]  ksys_write+0x64/0xd8
[  202.197430]  __arm64_sys_write+0x18/0x20
[  202.197521]  el0_svc_common.constprop.0+0x7c/0xe8
[  202.197621]  el0_svc_handler+0x28/0x78
[  202.197706]  el0_svc+0x8/0xc
[  202.197828] ---[ end trace 57719823dda6d21e ]---

Thank you,
Pasha
