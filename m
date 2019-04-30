Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A09710321
	for <lists+stable@lfdr.de>; Wed,  1 May 2019 01:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbfD3XLW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 19:11:22 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:43583 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726086AbfD3XLW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Apr 2019 19:11:22 -0400
Received: by mail-pl1-f196.google.com with SMTP id n8so7423010plp.10;
        Tue, 30 Apr 2019 16:11:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:in-reply-to
         :references:date:mime-version:content-transfer-encoding;
        bh=FXARXwM4QgylrliYg9gnUX5NvhFipcGymsRDeHVQDJI=;
        b=EEszlnFYLyXHCGK5hVK0TR7ZzvNEwOdDnqYjozZAoFe0xvR+BEdJQ+532/3wiY6FY6
         DeRVqssAglwf/rRWBeEYZIsKlpmkd6bMRhRwch9y+Rafnu3vxla7k21A0PokIBopxIBP
         uRTcWVfcs2jIEZIIyQOFCTMbl4KpSOxP6NQcG1oLIgO/tyOyywokqoYOND/mwl4a+unc
         VX3yoLh2Wn+miEdMT5ij82k7TM0AUIIGoguSXyDkG4+6hrzw2LXBo+x4dB4S6C50Jjrh
         wcel9QF6oYT776DK/Uqm+UQ9o6ZXKFqlU0wRP/GO4oC1ytO/25tIkjSJ8mHKwbg4Y/Fn
         LQ5w==
X-Gm-Message-State: APjAAAWT+ChIYm4EN5V5lxORfhYwBGM6etgb93iylUqXL1Dw9zUmovzi
        MrnQSfxKEoNzpjA+45v7HzOCNbBu52Q=
X-Google-Smtp-Source: APXvYqys1BucDtRUXPE4Fmk0HX7m44pS+2KC6COLjJjMw17jqNuDtWeHvo+lbF0SCeqblFlEPlmj1g==
X-Received: by 2002:a17:902:b715:: with SMTP id d21mr73635351pls.103.1556665881547;
        Tue, 30 Apr 2019 16:11:21 -0700 (PDT)
Received: from ?IPv6:2620:15c:2cd:203:5cdc:422c:7b28:ebb5? ([2620:15c:2cd:203:5cdc:422c:7b28:ebb5])
        by smtp.gmail.com with ESMTPSA id f63sm62903342pfc.180.2019.04.30.16.11.19
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 30 Apr 2019 16:11:20 -0700 (PDT)
Message-ID: <1556664925.161891.183.camel@acm.org>
Subject: Re: [PATCH 1/2] block: Fix a NULL pointer dereference in 
 generic_make_request()
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Guilherme G. Piccoli" <gpiccoli@canonical.com>,
        linux-block@vger.kernel.org, linux-raid@vger.kernel.org
Cc:     dm-devel@redhat.com, axboe@kernel.dk, gavin.guo@canonical.com,
        jay.vosburgh@canonical.com, kernel@gpiccoli.net,
        stable@vger.kernel.org
In-Reply-To: <20190430223722.20845-1-gpiccoli@canonical.com>
References: <20190430223722.20845-1-gpiccoli@canonical.com>
Content-Type: text/plain; charset="UTF-7"
Date:   Tue, 30 Apr 2019 15:55:25 -0700
Mime-Version: 1.0
X-Mailer: Evolution 3.26.2-1 
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2019-04-30 at 19:37 -0300, Guilherme G. Piccoli wrote:
+AD4 Commit 37f9579f4c31 (+ACI-blk-mq: Avoid that submitting a bio concurrently
+AD4 with device removal triggers a crash+ACI) introduced a NULL pointer
+AD4 dereference in generic+AF8-make+AF8-request(). The patch sets q to NULL and
+AD4 enter+AF8-succeeded to false+ADs right after, there's an 'if (enter+AF8-succeeded)'
+AD4 which is not taken, and then the 'else' will dereference q in
+AD4 blk+AF8-queue+AF8-dying(q).
+AD4 
+AD4 This patch just moves the 'q +AD0 NULL' to a point in which it won't trigger
+AD4 the oops, although the semantics of this NULLification remains untouched.
+AD4 
+AD4 A simple test case/reproducer is as follows:
+AD4 a) Build kernel v5.1-rc7 with CONFIG+AF8-BLK+AF8-CGROUP+AD0-n.
+AD4 
+AD4 b) Create a raid0 md array with 2 NVMe devices as members, and mount it
+AD4 with an ext4 filesystem.
+AD4 
+AD4 c) Run the following oneliner (supposing the raid0 is mounted in /mnt):
+AD4 (dd of+AD0-/mnt/tmp if+AD0-/dev/zero bs+AD0-1M count+AD0-999 +ACY)+ADs sleep 0.3+ADs
+AD4 echo 1 +AD4 /sys/block/nvme0n1/device/device/remove
+AD4 (whereas nvme0n1 is the 2nd array member)

Reviewed-by: Bart Van Assche +ADw-bvanassche+AEA-acm.org+AD4


