Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4AB1B1DAD
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 06:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbgDUEvt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 21 Apr 2020 00:51:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36623 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbgDUEvt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 00:51:49 -0400
Received: from mail-pg1-f197.google.com ([209.85.215.197])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1jQkss-0005sZ-SW
        for stable@vger.kernel.org; Tue, 21 Apr 2020 04:51:47 +0000
Received: by mail-pg1-f197.google.com with SMTP id q8so12046649pgv.13
        for <stable@vger.kernel.org>; Mon, 20 Apr 2020 21:51:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=yHVBi4+q+DxGUgmkg/YNM3PtmSPedofWtuQ7gpqgf8c=;
        b=KgEI2VsN5SFSdS09e1lpFHmc7O0Np6MAiFe0qQqaiMMvlNJYm5q5d/IVkBkoOx7re6
         7Sp2QpxzWBqhi3tCXWlIMrNRrhYom1uOWzQNSx9bgco7cWlEFMCP+XORezUEb6Gy5DW8
         ifgkGTTPMqm750LopTFHDWc6fRcrml4xoyD2yV2r1avtmxpMCn7uX2y2RpXKiuLGE0mX
         WszlcgPAgysaIyiLFHZLCK+GlNnKsDGE9PG7sMinJ/aYdkl7PSF2ZYlwEpFv0nTP6XUT
         zN3PVaaljjURVqsZm7dx88tTitPN5wsX2d4P05Igjzzjj/Ou+k8hcQwwg7cHOJtpGuo9
         UBhQ==
X-Gm-Message-State: AGi0PubJeZnYP77xXAAaz1UJEEcVMi0uy3HmzUHs5JYHbQc48ioNSRay
        mr0Y0PtY2auMmrs+n+RP3UfH3JdlhkQ26GdgzPP1Wf8x/O6zOdGor0IURB+DZeYkMdcoWlM778L
        OdQqUDYABkAjBSplUw6sQ6xAwu+dOyCoDvQ==
X-Received: by 2002:aa7:969b:: with SMTP id f27mr19363279pfk.116.1587444705578;
        Mon, 20 Apr 2020 21:51:45 -0700 (PDT)
X-Google-Smtp-Source: APiQypLwkVfZvPWVo80wH2SVlwC4/6KQbeXPP33zsYsSRBohoLtwxEhc5LDS6aRVK5+sLiXn4sZWRQ==
X-Received: by 2002:aa7:969b:: with SMTP id f27mr19363264pfk.116.1587444705283;
        Mon, 20 Apr 2020 21:51:45 -0700 (PDT)
Received: from [192.168.1.208] (220-133-187-190.HINET-IP.hinet.net. [220.133.187.190])
        by smtp.gmail.com with ESMTPSA id mq6sm1074269pjb.38.2020.04.20.21.51.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 Apr 2020 21:51:44 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH] nvme/pci: Use Discard instead of Write Zeroes on SK hynix
 SC300
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
In-Reply-To: <BYAPR04MB49658C7772879D7BA5A6E62D86D90@BYAPR04MB4965.namprd04.prod.outlook.com>
Date:   Tue, 21 Apr 2020 12:51:43 +0800
Cc:     "kbusch@kernel.org" <kbusch@kernel.org>,
        "axboe@fb.com" <axboe@fb.com>, "hch@lst.de" <hch@lst.de>,
        "sagi@grimberg.me" <sagi@grimberg.me>,
        "open list:NVM EXPRESS DRIVER" <linux-nvme@lists.infradead.org>,
        linux-stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <39EC5974-AD83-411F-8494-70EC79DBB7ED@canonical.com>
References: <20200417083641.28205-1-kai.heng.feng@canonical.com>
 <BYAPR04MB49658C7772879D7BA5A6E62D86D90@BYAPR04MB4965.namprd04.prod.outlook.com>
To:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Apr 18, 2020, at 03:25, Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com> wrote:
> 
> On 04/17/2020 01:37 AM, Kai-Heng Feng wrote:
>> After commit 6e02318eaea5 ("nvme: add support for the Write Zeroes
>> command"), SK hynix SC300 becomes very slow with the following error
>> message:
>> [  224.567695] blk_update_request: operation not supported error, dev nvme1n1, sector 499384320 op 0x9:(WRITE_ZEROES) flags 0x1000000 phys_seg 0 prio class 0]
>> 
>> Use quirk NVME_QUIRK_DEALLOCATE_ZEROES to workaround this issue.
> Can you share
> nvme id-ctrl -H /dev/nvme0 | grep oncs -A 8
> output?
> 

$ sudo nvme id-ctrl -H /dev/nvme0 | grep oncs -A 8
oncs      : 0x1f
  [7:7] : 0     Verify Not Supported
  [6:6] : 0     Timestamp Not Supported
  [5:5] : 0     Reservations Not Supported
  [4:4] : 0x1   Save and Select Supported
  [3:3] : 0x1   Write Zeroes Supported
  [2:2] : 0x1   Data Set Management Supported
  [1:1] : 0x1   Write Uncorrectable Supported
  [0:0] : 0x1   Compare Supported

