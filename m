Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 610E82DEC11
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 00:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725831AbgLRXdx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Dec 2020 18:33:53 -0500
Received: from plasma4.jpberlin.de ([80.241.57.33]:41827 "EHLO
        plasma4.jpberlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725824AbgLRXdx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Dec 2020 18:33:53 -0500
X-Greylist: delayed 470 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Dec 2020 18:33:52 EST
Received: from spamfilter02.heinlein-hosting.de (spamfilter02.heinlein-hosting.de [80.241.56.116])
        by plasma.jpberlin.de (Postfix) with ESMTP id 2F3F7AAB69;
        Sat, 19 Dec 2020 00:25:19 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from plasma.jpberlin.de ([80.241.56.68])
        by spamfilter02.heinlein-hosting.de (spamfilter02.heinlein-hosting.de [80.241.56.116]) (amavisd-new, port 10030)
        with ESMTP id zj22D1gFzuNA; Sat, 19 Dec 2020 00:25:18 +0100 (CET)
Received: from webmail.opensynergy.com (unknown [217.66.60.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (Client CN "*.opensynergy.com", Issuer "Starfield Secure Certificate Authority - G2" (not verified))
        (Authenticated sender: opensynergy@jpberlin.de)
        by plasma.jpberlin.de (Postfix) with ESMTPSA id 5F3B3AA60B;
        Sat, 19 Dec 2020 00:25:18 +0100 (CET)
Subject: Re: [PATCH RESEND v2] virtio-input: add multi-touch support
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     <virtualization@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>,
        <stable@vger.kernel.org>, Jason Wang <jasowang@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Henrik Rydberg <rydberg@bitmath.org>,
        Mathias Crombez <mathias.crombez@faurecia.com>
References: <20201208210150.20001-1-vasyl.vavrychuk@opensynergy.com>
 <20201209030635-mutt-send-email-mst@kernel.org>
From:   Vasyl Vavrychuk <vasyl.vavrychuk@opensynergy.com>
Message-ID: <84310558-729b-d6d0-cf1a-e48febc3f001@opensynergy.com>
Date:   Sat, 19 Dec 2020 01:25:15 +0200
MIME-Version: 1.0
In-Reply-To: <20201209030635-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SR-MAIL-02.open-synergy.com (10.26.10.22) To
 SR-MAIL-01.open-synergy.com (10.26.10.21)
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -6.50 / 15.00 / 15.00
X-Rspamd-Queue-Id: 2F3F7AAB69
X-Rspamd-UID: 9ec262
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 09.12.20 10:28, Michael S. Tsirkin wrote:
> On Tue, Dec 08, 2020 at 11:01:50PM +0200, Vasyl Vavrychuk wrote:
>> From: Mathias Crombez <mathias.crombez@faurecia.com>
>> Cc: stable@vger.kernel.org
> 
> I don't believe this is appropriate for stable, looks like
> a new feature to me.

Agree, removed.

>>
>> +config VIRTIO_INPUT_MULTITOUCH_SLOTS
>> +     depends on VIRTIO_INPUT
>> +     int "Number of multitouch slots"
>> +     range 0 64
>> +     default 10
>> +     help
>> +      Define the number of multitouch slots used. Default to 10.
>> +      This parameter is unused if there is no multitouch capability.
>> +
>> +      0 will disable the feature.
>> +
> 
> Most people won't be using this config so the defaults matter. So why 10? 10 fingers?
> 
> And where does 64 come from?

I have sent v3 version where number of slots it obtained from the host.

>> +     if (is_mt)
>> +             input_mt_init_slots(vi->idev,
>> +                                 CONFIG_VIRTIO_INPUT_MULTITOUCH_SLOTS,
>> +                                 INPUT_MT_DIRECT);
> 
> 
> Do we need the number in config space maybe? And maybe with a feature
> bit so host can find out whether guest supports MT?

I think it is not applicable in v3 which I sent, because number of slots 
is commit from the host. So, now host controls whether guest support MT.
