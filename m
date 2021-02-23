Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE1F63227D2
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 10:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbhBWJab (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 04:30:31 -0500
Received: from esa2.hc3370-68.iphmx.com ([216.71.145.153]:51329 "EHLO
        esa2.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232338AbhBWJ2c (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 04:28:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1614072512;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=elkiEyw/x+p4Mzp82r1PU6gv61RdX2VzYrI0EcXBgiE=;
  b=eqEccJJBKQpSd2e8VyT0zHZJLliOTtawknOrTNw9y22VO/7wJmybd6gr
   lvX2jRKqsCdMDQmBMtPaJ85Mp95iwEd8YuJaKkKZJTGcqVX1OK8IHn/aj
   rju+2Iyvh8SEwRHL29X09P8q1f72uyKmPpdwlU3BIYpu3qj4JgPvRp0R4
   U=;
Authentication-Results: esa2.hc3370-68.iphmx.com; dkim=none (message not signed) header.i=none
IronPort-SDR: r+v2a+pAcLkDXkvtq+LmVooxIXl9Yi1OFFOUqXQVl7OPoBQ/F1wR39/aL26u9L65xhinLzNmzD
 IkM5sCEPjCfpmf9zzrGZh3QpaL3V+Q5QWq+TyAXm2mwA4eOOjMRr16+CUyDyewQEuJfODY5MbN
 wFE9A627oR/uIUpbMpS8JESAt4rQ0ZHYTeHTVyqMz0CtZl4/Eu4i5+crISP29PhiJDm9wpiP9E
 8gWCC28x4GMlXuCPvXKvUr/Ak6638Jo/O1FCh/AH4ug72oJzWRID7AuaDHkXLapWfmKY7SqObb
 oGk=
X-SBRS: 5.1
X-MesageID: 37826829
X-Ironport-Server: esa2.hc3370-68.iphmx.com
X-Remote-IP: 162.221.158.21
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.81,199,1610427600"; 
   d="scan'208";a="37826829"
Subject: Re: [PATCH v3 2/8] xen/events: don't unmask an event channel when an
 eoi is pending
To:     Juergen Gross <jgross@suse.com>, <xen-devel@lists.xenproject.org>,
        <linux-kernel@vger.kernel.org>
CC:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        <stable@vger.kernel.org>, Julien Grall <julien@xen.org>
References: <20210219154030.10892-1-jgross@suse.com>
 <20210219154030.10892-3-jgross@suse.com>
From:   Ross Lagerwall <ross.lagerwall@citrix.com>
Message-ID: <d368a948-17d6-4e64-110e-bede3158f49f@citrix.com>
Date:   Tue, 23 Feb 2021 09:26:49 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210219154030.10892-3-jgross@suse.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-02-19 15:40, Juergen Gross wrote:
> An event channel should be kept masked when an eoi is pending for it.
> When being migrated to another cpu it might be unmasked, though.
> 
> In order to avoid this keep three different flags for each event channel
> to be able to distinguish "normal" masking/unmasking from eoi related
> masking/unmasking and temporary masking. The event channel should only
> be able to generate an interrupt if all flags are cleared.
> 
> Cc: stable@vger.kernel.org
> Fixes: 54c9de89895e0a36047 ("xen/events: add a new late EOI evtchn framework")
> Reported-by: Julien Grall <julien@xen.org>
> Signed-off-by: Juergen Gross <jgross@suse.com>

I tested this patch series backported to a 4.19 kernel and found that
when doing a reboot loop of Windows with PV drivers, occasionally it will
end up in a state with some event channels pending and masked in dom0
which breaks networking in the guest.

The issue seems to have been introduced with this patch, though at first
glance it appears correct. I haven't yet looked into why it is happening.
Have you seen anything like this with this patch?

Thanks,
Ross
