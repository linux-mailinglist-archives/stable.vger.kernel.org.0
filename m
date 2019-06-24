Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F05E51008
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 17:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728172AbfFXPMV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 11:12:21 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:44248 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730580AbfFXPMV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jun 2019 11:12:21 -0400
Received: by mail-io1-f67.google.com with SMTP id s7so120615iob.11
        for <stable@vger.kernel.org>; Mon, 24 Jun 2019 08:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=i6RP5sEIUQVe7K2Xxca+vDWdrwxXZnb7gXo4fjhFOrI=;
        b=jvgv4lXqQaoTaUCCgSqFt7dA1UG8exJvGDZ8+KtKxJ/F1Y3nXoRjm3mDxBFqek2yPa
         6+vxZZK7y20j65gwxGP1TZgLx/GKaAMRMeotexYhGiKkgr37FscTGeHpnWfkup4MQBr7
         kVxvBPx8VMwMyBZCYCSMzStUhOKfpSYUOOQNP1hG5P9YNsNt6Hqx3aziwKkU0BVMlqW5
         XwuM0TSzS42G1XJIYxd1+xd1q7vW9P7SovoLT4e4ilPznQYjhpoSBkE7NXsIzj1AHE0l
         W1m+hPlUxfwPUS1qbPsmfFXhOaK94yklTADYhpuaQtZALjOAMeIsSx6O8N77qkEgoEW0
         dCVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=i6RP5sEIUQVe7K2Xxca+vDWdrwxXZnb7gXo4fjhFOrI=;
        b=lRnFYmQFZdp4YR2OviT4N1KNvzAhdc2K4KxU8Q4nUR89UbZc+zaz/CsGvzXQVQlnXP
         U/Wuo2snxFMq8PUCfkl2L7Xut9dxBzIB95d/y1/Dn+a9TXmqKK/AZgjJPeCWqWw1XLnQ
         4FnO/eYQGHOdjYwr8/unxZNYttaPs/Me+6UqnaD/OqM/eY6SNIIw7WiehCRiiqSqK2ko
         2MiRCxke/CtSDJYXa4YtRpRXKU5fQW99cITM/AeYNmq3lfZ2OzE40qTqaHsyKFImqM1H
         jCkFrdNUtDo3A7GkuPNQ+Q3nshQJXtrGfjpa0dwiKvpObRZqvqubTFHWInkdl5dDQfQq
         U59Q==
X-Gm-Message-State: APjAAAVRIUPMTmtSI/FGk81hU5+r4KGNRPh1nFCVcrNmF3QD5n+CDizx
        3Lf/PQlaGGQJ6OGROtntozAQ+g==
X-Google-Smtp-Source: APXvYqxhCdDitnoCJq15metdrBXJXKIUUa7soKbJdiR2x1Uo/Def9XZLDCqSPhNc0JhCX6SVb8UL6w==
X-Received: by 2002:a02:2a8f:: with SMTP id w137mr127594244jaw.50.1561389140370;
        Mon, 24 Jun 2019 08:12:20 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:855f:8919:84a7:4794])
        by smtp.gmail.com with ESMTPSA id f17sm25760614ioc.2.2019.06.24.08.12.19
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 24 Jun 2019 08:12:19 -0700 (PDT)
Date:   Mon, 24 Jun 2019 09:12:17 -0600
From:   Ross Zwisler <zwisler@google.com>
To:     kbuild test robot <lkp@intel.com>
Cc:     Ross Zwisler <zwisler@chromium.org>, kbuild-all@01.org,
        linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Fletcher Woodruff <fletcherw@google.com>,
        Justin TerAvest <teravest@google.com>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 3/3] ext4: use jbd2_inode dirty range scoping
Message-ID: <20190624151217.GA249955@google.com>
References: <20190620151839.195506-4-zwisler@google.com>
 <201906240244.12r4nktI%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201906240244.12r4nktI%lkp@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 24, 2019 at 02:54:49AM +0800, kbuild test robot wrote:
> Hi Ross,
> 
> Thank you for the patch! Yet something to improve:
> 
> [auto build test ERROR on linus/master]
> [also build test ERROR on v5.2-rc6 next-20190621]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Ross-Zwisler/mm-add-filemap_fdatawait_range_keep_errors/20190623-181603
> config: x86_64-rhel-7.6 (attached as .config)
> compiler: gcc-7 (Debian 7.3.0-1) 7.3.0
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=x86_64 
> 
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
> >> ERROR: "jbd2_journal_inode_ranged_wait" [fs/ext4/ext4.ko] undefined!
> >> ERROR: "jbd2_journal_inode_ranged_write" [fs/ext4/ext4.ko] undefined!

Yep, this is caused by the lack of EXPORT_SYMBOL() calls for these two new
jbd2 functions.  Ted also pointed this out and fixed this up when he was
committing:

https://patchwork.kernel.org/patch/11007139/#22717091

Thank you for the report!
