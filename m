Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2F714DA6F
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 13:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbgA3MKr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 07:10:47 -0500
Received: from forwardcorp1j.mail.yandex.net ([5.45.199.163]:42026 "EHLO
        forwardcorp1j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726873AbgA3MKr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jan 2020 07:10:47 -0500
Received: from mxbackcorp1j.mail.yandex.net (mxbackcorp1j.mail.yandex.net [IPv6:2a02:6b8:0:1619::162])
        by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id 8F1162E14F0;
        Thu, 30 Jan 2020 15:10:44 +0300 (MSK)
Received: from iva4-7c3d9abce76c.qloud-c.yandex.net (iva4-7c3d9abce76c.qloud-c.yandex.net [2a02:6b8:c0c:4e8e:0:640:7c3d:9abc])
        by mxbackcorp1j.mail.yandex.net (mxbackcorp/Yandex) with ESMTP id ZsLSOa0YEL-Agdq1f1g;
        Thu, 30 Jan 2020 15:10:44 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1580386244; bh=sZNt5hSRZ7fVMz75upicYp+ovNFTnCUnRWqGNUuNR1Y=;
        h=Date:Message-ID:Subject:From:To:Cc;
        b=BQOo9onxBfRYBgf9AXnW+PuW7x/CgDOrYl6YHsTDeO8kgSr5Z045I90fmER0Qy+Po
         Wk65fr3H9MH1vcaZw+0ZS8Xop1kOC6WF9q3jPb/bNBNX7XFd378Q0yQx/QYS3WwQpV
         115Lj4xdQNHX2C6gEa7/WDZVcwFvx4lJKUEe4IeU=
Authentication-Results: mxbackcorp1j.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from dynamic-red.dhcp.yndx.net (dynamic-red.dhcp.yndx.net [2a02:6b8:0:40c:8448:fbcc:1dac:c863])
        by iva4-7c3d9abce76c.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id 5gA9AGudWi-AgVOAGSs;
        Thu, 30 Jan 2020 15:10:42 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
To:     Stable <stable@vger.kernel.org>
From:   Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [4.19.y] 32-bit overflow in __blkdev_issue_discard()
Cc:     linux-block <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
        Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>
Message-ID: <ad8d7c2d-9bbe-6d2e-db20-d208b5563c09@yandex-team.ru>
Date:   Thu, 30 Jan 2020 15:10:42 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please consider including into 4.19 upstream commits

ba5d73851e71847ba7f7f4c27a1a6e1f5ab91c79
("block: cleanup __blkdev_issue_discard()")

and

4800bf7bc8c725e955fcbc6191cc872f43f506d3
("block: fix 32 bit overflow in __blkdev_issue_discard()")



Overflow of unsigned long "req_sects" (fixed in second patch)
actually exist here much longer.

And 4.19 commit 744889b7cbb56a64f957e65ade7cb65fe3f35714
("block: don't deal with discard limit in blkdev_issue_discard()")
make it worse by replacing

req_sects = min_t(sector_t, nr_sects, q->limits.max_discard_sectors);

with

unsigned int req_sects = nr_sects;


because now discard length isn't cut by max_discard_sectors it easily overflows.
As a result BLKDISCARD fails unexpectedly:

ioctl(3, BLKDISCARD, [0, 0x20000000000])  = -1 EOPNOTSUPP (Operation not supported)
