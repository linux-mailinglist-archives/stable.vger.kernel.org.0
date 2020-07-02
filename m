Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 268FE212F5C
	for <lists+stable@lfdr.de>; Fri,  3 Jul 2020 00:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726228AbgGBWPw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jul 2020 18:15:52 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45562 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbgGBWPv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jul 2020 18:15:51 -0400
Received: by mail-pg1-f194.google.com with SMTP id l63so14102225pge.12;
        Thu, 02 Jul 2020 15:15:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cIIMlqNaO5Unw1RzIf81LBsODZ5TPRnfcppyapVK2+8=;
        b=baCryEPMc2o9h6sPJV2L9WDBPDa7Ab4XG012UyS2Ylkds3kNFpcFhuKQvLxGjFVv70
         3S6PE4plnY6LouzFa5698EgS07womE1Sza+C1/vJCQvZ7nfb0V3TUPFd3pc7aRjmKgER
         C7YUWZDbyAMOPdGPcYA2ZDgLvaeBSyTVZjApltkHiwhQf3LgyrK6Cs+y0yFRuW4kp+hy
         fQ0LddFdaDDr2wJjxrlsJ3/1t/yRt25teh8DdZTW7FmYNXfWBQBVygaJnaLPcZHjVAS6
         8UrQO2ayKIOjPsOCZUpsWBNup8e4Umn7r+2lbsBv0fLpNs0FUTBwuZnvJCB58ZoNNN49
         pDQg==
X-Gm-Message-State: AOAM532W9TwTcqT/IpoUHkMwg2ocaL3JCTYOrosHMf4kDrYS18B1KdH8
        II+J3ukg5v9hLuA8YC/IuYgi07YE
X-Google-Smtp-Source: ABdhPJx0l7QL1nHWSKOp/IBbD2Z+tjawC6rDDB+Qqd61qUaYwon66FNhvOJsrOo9YHIfr5rKiD4lfA==
X-Received: by 2002:a63:d848:: with SMTP id k8mr12692149pgj.119.1593728151066;
        Thu, 02 Jul 2020 15:15:51 -0700 (PDT)
Received: from ?IPv6:2601:647:4802:9070:18f8:9053:b0e3:60d4? ([2601:647:4802:9070:18f8:9053:b0e3:60d4])
        by smtp.gmail.com with ESMTPSA id j17sm9157032pgn.87.2020.07.02.15.15.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jul 2020 15:15:50 -0700 (PDT)
Subject: Re: [PATCH 4.19 082/131] nvme: fix possible deadlock when I/O is
 blocked
To:     Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Anton Eidelman <anton@lightbitslabs.com>,
        Christoph Hellwig <hch@lst.de>
References: <20200629153502.2494656-1-sashal@kernel.org>
 <20200629153502.2494656-83-sashal@kernel.org> <20200702211743.GE5787@amd>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <e05ddf9e-1804-d297-47f4-c422d4f98cfb@grimberg.me>
Date:   Thu, 2 Jul 2020 15:15:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200702211743.GE5787@amd>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


> Hi!
> 
>> From: Sagi Grimberg <sagi@grimberg.me>
>>
>> [ Upstream commit 3b4b19721ec652ad2c4fe51dfbe5124212b5f581 ]
>>
>> Revert fab7772bfbcf ("nvme-multipath: revalidate nvme_ns_head gendisk
>> in nvme_validate_ns")
>>
>> When adding a new namespace to the head disk (via nvme_mpath_set_live)
>> we will see partition scan which triggers I/O on the mpath device node.
>> This process will usually be triggered from the scan_work which holds
>> the scan_lock. If I/O blocks (if we got ana change currently have only
>> available paths but none are accessible) this can deadlock on the head
>> disk bd_mutex as both partition scan I/O takes it, and head disk revalidation
>> takes it to check for resize (also triggered from scan_work on a different
>> path). See trace [1].
>>
>> The mpath disk revalidation was originally added to detect online disk
>> size change, but this is no longer needed since commit cb224c3af4df
>> ("nvme: Convert to use set_capacity_revalidate_and_notify") which already
>> updates resize info without unnecessarily revalidating the disk (the
> 
> Unfortunately, v4.19-stable does not contain cb224c3af4df. According
> to changelog, it seems it should be cherry-picked?

You are absolutely right,

The reference commit is a part of the series:
78317c5d58e6 ("scsi: Convert to use set_capacity_revalidate_and_notify")
cb224c3af4df ("nvme: Convert to use set_capacity_revalidate_and_notify")
3cbc28bb902b ("xen-blkfront.c: Convert to use 
set_capacity_revalidate_and_notify")
662155e2898d ("virtio_blk.c: Convert to use 
set_capacity_revalidate_and_notify")
e598a72faeb5 ("block/genhd: Notify udev about capacity change")

It would be cool if they are cherry picked, although they don't qualify
as stable patches per se...
