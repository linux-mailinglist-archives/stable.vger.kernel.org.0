Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6636BCC3
	for <lists+stable@lfdr.de>; Wed, 17 Jul 2019 15:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725980AbfGQNJD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 09:09:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:23088 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725936AbfGQNJD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 09:09:03 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jul 2019 06:09:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,274,1559545200"; 
   d="scan'208";a="158458802"
Received: from esulliva-mobl.ger.corp.intel.com (HELO [10.251.94.109]) ([10.251.94.109])
  by orsmga007.jf.intel.com with ESMTP; 17 Jul 2019 06:09:01 -0700
Subject: Re: [Intel-gfx] [PATCH 1/5] drm/i915/userptr: Beware recursive
 lock_page()
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
References: <20190716124931.5870-1-chris@chris-wilson.co.uk>
 <bb43c2b5-3513-ef4f-1bc9-887fc2b2e523@linux.intel.com>
 <156329142200.9436.8651620549785965913@skylake-alporthouse-com>
From:   Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Organization: Intel Corporation UK Plc
Message-ID: <d76bdb93-b90b-afe3-841b-95a8de27902d@linux.intel.com>
Date:   Wed, 17 Jul 2019 14:09:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <156329142200.9436.8651620549785965913@skylake-alporthouse-com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 16/07/2019 16:37, Chris Wilson wrote:
> Quoting Tvrtko Ursulin (2019-07-16 16:25:22)
>>
>> On 16/07/2019 13:49, Chris Wilson wrote:
>>> Following a try_to_unmap() we may want to remove the userptr and so call
>>> put_pages(). However, try_to_unmap() acquires the page lock and so we
>>> must avoid recursively locking the pages ourselves -- which means that
>>> we cannot safely acquire the lock around set_page_dirty(). Since we
>>> can't be sure of the lock, we have to risk skip dirtying the page, or
>>> else risk calling set_page_dirty() without a lock and so risk fs
>>> corruption.
>>
>> So if trylock randomly fail we get data corruption in whatever data set
>> application is working on, which is what the original patch was trying
>> to avoid? Are we able to detect the backing store type so at least we
>> don't risk skipping set_page_dirty with anonymous/shmemfs?
> 
> page->mapping???

Would page->mapping work? What is it telling us?

> We still have the issue that if there is a mapping we should be taking
> the lock, and we may have both a mapping and be inside try_to_unmap().

Is this a problem? On a path with mappings we trylock and so solve the 
set_dirty_locked and recursive deadlock issues, and with no mappings 
with always dirty the page and avoid data corruption.

> I think it's lose-lose. The only way to win is not to userptr :)

It's looking more and more like this indeed.

Regards,

Tvrtko

