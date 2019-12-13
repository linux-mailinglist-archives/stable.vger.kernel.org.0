Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6733011E5A7
	for <lists+stable@lfdr.de>; Fri, 13 Dec 2019 15:35:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbfLMOfb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Dec 2019 09:35:31 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21745 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727779AbfLMOfb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Dec 2019 09:35:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576247730;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=K16O3uoMoq1X7RVCymy3uF4s1barxs0V/Dkj4PdUFYc=;
        b=VZN81mWGn6UMlDjdD5lVM69MAc9MLjeoAqmpCugl2vqSwEO5uaxElxuqlWDn8DFntmcG7u
        V8x4Ep937GN9FV5PERYedMo1IBHe4TW/7byQQ/TAzDVtyhrdv4ZW1h1jVyqA5QkgzPFSWD
        X1PEFEnTXRzsM6sTuCOzdKA8YOVCZmk=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-88-JXZZB6mYPseD8gdKd_Xv1w-1; Fri, 13 Dec 2019 09:35:26 -0500
X-MC-Unique: JXZZB6mYPseD8gdKd_Xv1w-1
Received: by mail-qt1-f200.google.com with SMTP id d18so1908178qtp.16
        for <stable@vger.kernel.org>; Fri, 13 Dec 2019 06:35:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=K16O3uoMoq1X7RVCymy3uF4s1barxs0V/Dkj4PdUFYc=;
        b=Jya+osSB5Bap22PHfyTsbMSSRHWfyuYWSkDV5HJmBP7J7q5jHLEVEztfculmCEA2/i
         31sAQkidFsjfd4PUM5WMSQcIKeoV4XlchIxyHPXq25KXTcAUs7hW2XerBF+T5ap9LmCM
         N6ivIbKNLmQF9jXdFJPnJtgG4V45wIPc9Ni3zOkjkS6yAdNC6OuIXaJTKA7zDf81ljlK
         ct+V++dlC6+6Nou2dJW/oXsYz0CBcWNee+/viwMu7XJvrZzqWtCSVOEHUMoYqGw2vJKS
         5LI8mrPrm+2tcH2P2mtdqtNv74wLA98ozmQEvi7RKTXi9GYEJWbzbR4ldTPo/X0z9T/7
         6qjg==
X-Gm-Message-State: APjAAAUi0bssKlPY9aIiqi62CeBY6ND+SwBwfr5wv8kXR9dsxNehKSov
        n7nFxhDvgjaxZD9g5N3f/I2U363EFgtEnIi8/XV6c8F7MGMeQAOaMwFOBLcNOf3S1OGOMbYx387
        FJ8kwELcNBgj0BZKZ
X-Received: by 2002:a37:5d1:: with SMTP id 200mr13575570qkf.492.1576247725618;
        Fri, 13 Dec 2019 06:35:25 -0800 (PST)
X-Google-Smtp-Source: APXvYqxgq1bbRToA9P95foPk8oGS2OI8ibHY6a72vmEjljgya2qgJqTa4/Xh04URKGN+H8Bz4Y3K4g==
X-Received: by 2002:a37:5d1:: with SMTP id 200mr13575555qkf.492.1576247725393;
        Fri, 13 Dec 2019 06:35:25 -0800 (PST)
Received: from redhat.com (bzq-79-181-48-215.red.bezeqint.net. [79.181.48.215])
        by smtp.gmail.com with ESMTPSA id l62sm2885132qke.12.2019.12.13.06.35.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 06:35:24 -0800 (PST)
Date:   Fri, 13 Dec 2019 09:35:19 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, david@redhat.com, imammedo@redhat.com,
        jasowang@redhat.com, liuj97@gmail.com, mst@redhat.com,
        stable@vger.kernel.org, yuhuang@redhat.com
Subject: [PULL] virtio: cleanups and fixes
Message-ID: <20191213093519-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following changes since commit e42617b825f8073569da76dc4510bfa019b1c35a:

  Linux 5.5-rc1 (2019-12-08 14:57:55 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 63b9b80e9f5b2c463d98d6e550e0d0e3ace66033:

  virtio_balloon: divide/multiply instead of shifts (2019-12-11 08:14:07 -0500)

----------------------------------------------------------------
virtio: fixes, cleanups

Some fixes and cleanup patches.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
David Hildenbrand (1):
      virtio-balloon: fix managed page counts when migrating pages between zones

Michael S. Tsirkin (2):
      virtio_balloon: name cleanups
      virtio_balloon: divide/multiply instead of shifts

 drivers/virtio/virtio_balloon.c | 36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

