Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 033201B1DAA
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 06:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbgDUEv0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 21 Apr 2020 00:51:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36612 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbgDUEv0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 00:51:26 -0400
Received: from mail-pl1-f200.google.com ([209.85.214.200])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1jQksV-0005qU-Rb
        for stable@vger.kernel.org; Tue, 21 Apr 2020 04:51:24 +0000
Received: by mail-pl1-f200.google.com with SMTP id c13so10583625plq.22
        for <stable@vger.kernel.org>; Mon, 20 Apr 2020 21:51:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=BLtq2QdjOzCrJMLFZ+hejhyptyhEVzibl60GGDinzt4=;
        b=CKfdt5PJhiS7CG1XbX+gqjspfEMfELUVbZEy+Knr3lOMZg2IWR4eIdK7WUCsfWEDJN
         QLK+Tsx1uzNzQoSyMYJ7NKyj53CH4T2dTBopUmSS9ikJAh6FuzL9ZV1vs0sH+g4oIhcW
         W8ufC6v4/uUdt6cB4qxXov11Y383VGn5b5jn+E/Xqb9rVl6pqS+R+NgxbW+9rxhfM2tM
         O4O4UgnvsfsdKBkj3jEvsfVxGZTPSj0koDySCdszOxl1Yx6NuDPYorWuweCf2YtL6fU5
         JcjQ/L0b2qIXk1yQBMYq+5V9rJSM7aUfupuy3lM8TlVo8FM/u+eTAclqPX4aDeyH6qp0
         KqZA==
X-Gm-Message-State: AGi0Pubu+fPUWSxGDhvO3/q7u/V4sOo8alPl7oBI9kRTgeVXhpcanRp3
        ZBe8KUZtV4ew5H61zJDjZEG6u8IHDhRhIJdguNjX64eDy+Ot4SCE4U/xLyE990TVJEh0Xs/ybqm
        048yX4C+rT/ZwHzqUl6fFDSOqKPkYSyrEgw==
X-Received: by 2002:a17:90a:7349:: with SMTP id j9mr3358497pjs.196.1587444682538;
        Mon, 20 Apr 2020 21:51:22 -0700 (PDT)
X-Google-Smtp-Source: APiQypJDvmMZav1WQf4l8MDQtC6CWJ9V2og5hui0h4wbn2cbAwgyAaVGbvnQ6aHap5W2YJ/VGNCNOQ==
X-Received: by 2002:a17:90a:7349:: with SMTP id j9mr3358482pjs.196.1587444682263;
        Mon, 20 Apr 2020 21:51:22 -0700 (PDT)
Received: from [192.168.1.208] (220-133-187-190.HINET-IP.hinet.net. [220.133.187.190])
        by smtp.gmail.com with ESMTPSA id mq6sm1074269pjb.38.2020.04.20.21.51.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 Apr 2020 21:51:21 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH] nvme/pci: Use Discard instead of Write Zeroes on SK hynix
 SC300
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
In-Reply-To: <20200417125929.GA5053@lst.de>
Date:   Tue, 21 Apr 2020 12:51:18 +0800
Cc:     Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        linux-stable <stable@vger.kernel.org>,
        "open list:NVM EXPRESS DRIVER" <linux-nvme@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <33565F7F-307C-408C-861D-72517F564967@canonical.com>
References: <20200417083641.28205-1-kai.heng.feng@canonical.com>
 <20200417125929.GA5053@lst.de>
To:     Christoph Hellwig <hch@lst.de>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Apr 17, 2020, at 20:59, Christoph Hellwig <hch@lst.de> wrote:
> 
> On Fri, Apr 17, 2020 at 04:36:41PM +0800, Kai-Heng Feng wrote:
>> After commit 6e02318eaea5 ("nvme: add support for the Write Zeroes
>> command"), SK hynix SC300 becomes very slow with the following error
>> message:
>> [  224.567695] blk_update_request: operation not supported error, dev nvme1n1, sector 499384320 op 0x9:(WRITE_ZEROES) flags 0x1000000 phys_seg 0 prio class 0]
>> 
>> Use quirk NVME_QUIRK_DEALLOCATE_ZEROES to workaround this issue.
> 
> Do you have a written guarantee from SK Hynix that it will always zero
> all blocks discarded?

Raised the issue to SK Hynix and waiting for their reply...

Kai-Heng
