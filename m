Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA8A4B2CBD
	for <lists+stable@lfdr.de>; Sat, 14 Sep 2019 21:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731315AbfINTjF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Sep 2019 15:39:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60648 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730142AbfINTjF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 14 Sep 2019 15:39:05 -0400
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3CD8D46673
        for <stable@vger.kernel.org>; Sat, 14 Sep 2019 19:39:05 +0000 (UTC)
Received: by mail-qk1-f198.google.com with SMTP id x186so17258336qke.13
        for <stable@vger.kernel.org>; Sat, 14 Sep 2019 12:39:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=vaylEgrlIg+lPjH544xVFYytAlsLACbCpY321J/9g4E=;
        b=Low4hFT4mNCToVYRopOYZan8vOOWF5jLXfmBxGArrKk0HiKHMZmqr8haXRfzAw1zJN
         MtmFK3m2OTrDEzIUJzGXftroCF0a2DsfHbJEh4Otk/DGpOQ5UcVHx43NBV1T1E8eCfz1
         xfbw0P22wzSJC3R4/Ib1PZmF0v/OZi1JWzfTAwgyVuECr+sOcfYU+dDyfVhY+nzmM6D3
         CyDLMFBluzcUsjveC3Mpsn/XqsFLtpsOytz5hunYeaDGnpVTC67XLglbEj+7DzN069Pe
         UY3tmtP2c/2+Ep2nxvxPfTVWwQhfA288to5fU+XcEfs/97CH7Q7iDb2vgK7wB4S/6vd1
         iTdw==
X-Gm-Message-State: APjAAAVDriCL1PbpplyA2vhQ5vOk1UU+ZCj/qDEAqEnV9AfzpwLlwt5W
        SDitFA4gIeSMhRVMk0bd7TF2sxxvUhLtWBdLYLfzSHF76Saq3evB6k4bwc23v6ggSfcf6ATWVZm
        m0Oze3NqAvLF2XQh7
X-Received: by 2002:a37:4b97:: with SMTP id y145mr53500326qka.310.1568489944598;
        Sat, 14 Sep 2019 12:39:04 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwD6rz0Xz1EID/JFGdbYv8ZxwisBunlJJE5csAnnPdoREA9Pde8LY2vagubbz6rBIS1caMDgg==
X-Received: by 2002:a37:4b97:: with SMTP id y145mr53500312qka.310.1568489944423;
        Sat, 14 Sep 2019 12:39:04 -0700 (PDT)
Received: from redhat.com (bzq-79-176-40-226.red.bezeqint.net. [79.176.40.226])
        by smtp.gmail.com with ESMTPSA id y17sm17211975qtb.82.2019.09.14.12.39.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Sep 2019 12:39:03 -0700 (PDT)
Date:   Sat, 14 Sep 2019 15:38:59 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, mst@redhat.com
Subject: [PULL] vhost: a last minute revert
Message-ID: <20190914153859-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

So I made a mess of it. Sent a pull before making sure it works on 32
bit too. Hope it's not too late to revert. Will teach me to be way more
careful in the near future.

The following changes since commit 060423bfdee3f8bc6e2c1bac97de24d5415e2bc4:

  vhost: make sure log_num < in_num (2019-09-11 15:15:26 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 0d4a3f2abbef73b9e5bb5f12213c275565473588:

  Revert "vhost: block speculation of translated descriptors" (2019-09-14 15:21:51 -0400)

----------------------------------------------------------------
virtio: a last minute revert

32 bit build got broken by the latest defence in depth patch.
Revert and we'll try again in the next cycle.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Michael S. Tsirkin (1):
      Revert "vhost: block speculation of translated descriptors"

 drivers/vhost/vhost.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)
