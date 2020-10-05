Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04EF1283972
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbgJEPYA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:24:00 -0400
Received: from mga04.intel.com ([192.55.52.120]:47242 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725960AbgJEPX7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:23:59 -0400
IronPort-SDR: xG+5vFiCkvo3Ce3wnaybX8zqMyGzfJ6NLciY5K2HRqBQs6hra5yvpHn+AWWdAy5JceZ6Gw3Sw2
 zNdxdxf0P+zA==
X-IronPort-AV: E=McAfee;i="6000,8403,9764"; a="161084064"
X-IronPort-AV: E=Sophos;i="5.77,338,1596524400"; 
   d="scan'208";a="161084064"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2020 08:17:15 -0700
IronPort-SDR: TzXcd7v2KJSJxmiFWWMwe/W82T68Xm+5qZdA0Feo9L8z9aC3gQGheevjSb7KqNlVLXG9i0oDZq
 er9PeaLrP3PA==
X-IronPort-AV: E=Sophos;i="5.77,338,1596524400"; 
   d="scan'208";a="417279735"
Received: from gmeszaro-mobl2.amr.corp.intel.com (HELO [10.212.242.54]) ([10.212.242.54])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2020 08:16:32 -0700
Subject: Re: [PATCH 0/3] [backport] nvme: Consolidate chunk_sectors settings
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org, hch@lst.de, kbusch@kernel.org,
        damien.lemoal@wdc.com
References: <20200923025808.14698-1-revanth.rajashekar@intel.com>
 <20201005132344.GB1506031@kroah.com>
From:   "Rajashekar, Revanth" <revanth.rajashekar@intel.com>
Message-ID: <68de150e-23f0-56a1-3f33-3f89bd6ad017@intel.com>
Date:   Mon, 5 Oct 2020 09:16:29 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201005132344.GB1506031@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 10/5/2020 7:23 AM, Greg KH wrote:
> On Tue, Sep 22, 2020 at 08:58:05PM -0600, Revanth Rajashekar wrote:
>> Backport commit 38adf94e166e3cb4eb89683458ca578051e8218d and it's
>> dependencies to linux-stable 5.4.y.
>>
>> Dependent commits:
>> 314d48dd224897e35ddcaf5a1d7d133b5adddeb7
>> e08f2ae850929d40e66268ee47e443e7ea56eeb7
>>
>> When running test cases to stress NVMe device, a race condition / deadlocks is
>> seen every couple of days or so where multiple threads are trying to acquire
>> ctrl->subsystem->lock or ctrl->scan_lock.
>>
>> The test cases send a lot nvme-cli requests to do Sanitize, Format, FW Download,
>> FW Activate, Flush, Get Log, Identify, and reset requests to two controllers
>> that share a namespace. Some of those commands target a namespace, some target
>> a controller.  The commands are sent in random order and random mix to the two
>> controllers.
>>
>> The test cases does not wait for nvme-cli requests to finish before sending more.
>> So for example, there could be multiple reset requests, multiple format requests,
>> outstanding at the same time as a sanitize, on both paths at the same time, etc.
>> Many of these test cases include combos that don't really make sense in the
>> context of NVMe, however it is used to create as much stress as possible.
>>
>> This patchset fixes this issue.
>>
>> Similar issue with a detailed call trace/log was discussed in the LKML
>> Link: https://lore.kernel.org/linux-nvme/04580CD6-7652-459D-ABDD-732947B4A6DF@javigon.com/
>>
>> Revanth Rajashekar (3):
>>   nvme: Cleanup and rename nvme_block_nr()
>>   nvme: Introduce nvme_lba_to_sect()
>>   nvme: consolidate chunk_sectors settings
>>
>>  drivers/nvme/host/core.c | 40 +++++++++++++++++++---------------------
>>  drivers/nvme/host/nvme.h | 16 +++++++++++++---
>>  2 files changed, 32 insertions(+), 24 deletions(-)
> For some reason you forgot to credit, and cc: all of the people on the
> original patches, which isn't very nice, don't you think?
>
> Next time please be more careful.
>
> greg k-h
I'm really sorry for missing out a few people from the cc list who are on the original patch.
Thought only the signed-off names go in there.
Will make sure this won't happen again and thanks for pointing it out :)

Thanks!
Revanth

