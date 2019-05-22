Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61B3727225
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 00:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728024AbfEVWSI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 18:18:08 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39081 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727179AbfEVWSI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 May 2019 18:18:08 -0400
Received: by mail-pg1-f195.google.com with SMTP id w22so2002138pgi.6
        for <stable@vger.kernel.org>; Wed, 22 May 2019 15:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=Jd0RSCXoP1EdL1cjt/xgeuNaQX2V7Ph/JBkgB7uNH0g=;
        b=GXLavN/7grE6LNJqyGhvPPesKBk185WFjgJna7ETOIJBaq1hY/O3DZYH9mqYTRPG6J
         GdFKCMBa8+OJJ7SXTg/NgAmRQpnKKVfSSiZLmo2keKmw0ot67menzPS8qFUMaPrsgUDO
         GNub7HFs2rNTz94sRTH62HK1i3T4MLXdmoCYI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Jd0RSCXoP1EdL1cjt/xgeuNaQX2V7Ph/JBkgB7uNH0g=;
        b=ZD9LTfHphfYB8H02rd6EvB0jK9II8N+IhcxvzHnyblZCzWHaOzl/+KWqDMTWkfKgvz
         wBwqJqVs2YVaz5Sh1Kb2isq53SKvzPA7IGch8zETjwbFvzpxouXjxNAVbn8+aFUyuVtf
         Io/GGYV7AvgHzgomhRH1xfI2Qm3oxBCaA2nLv9FhOw8zlOERdCB1DouPXz53/vXudaUf
         mCjalkQxXNnl7rR26uxBT5o1GmyC2nxiy3q0/GcdlFRjlrIgZ7DN0J31fir+pblNKxrs
         ShuYHtVs4dNHz3p+JsBfun2sZfjGXqTESTBoYdnSr9bpa62MifJlxAIM9iKewMYd7/bg
         Vofg==
X-Gm-Message-State: APjAAAW7QrcMbH2HHkrxciNeLLB46GUzRakHvns4welXTygWntly9p88
        CRKURB6+KSP+Ngd+4KcR0NHyCw==
X-Google-Smtp-Source: APXvYqwYkSpq4sI0OwVnuYJtsng97b6lnFAf2peUNKoiZTQR4ze4ezgmfpK+1cl50ZPOllSPkVklsg==
X-Received: by 2002:a63:6f0b:: with SMTP id k11mr92068194pgc.342.1558563487623;
        Wed, 22 May 2019 15:18:07 -0700 (PDT)
Received: from localhost ([2620:10d:c091:500::e733])
        by smtp.gmail.com with ESMTPSA id l7sm28232045pfl.9.2019.05.22.15.18.06
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 22 May 2019 15:18:06 -0700 (PDT)
Date:   Wed, 22 May 2019 18:18:05 -0400
From:   Chris Down <chris@chrisdown.name>
To:     deepa.kernel@gmail.com
Cc:     akpm@linux-foundation.org, arnd@arndb.de, axboe@kernel.dk,
        dave@stgolabs.net, dbueso@suse.de, e@80x24.org, jbaron@akamai.com,
        linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, oleg@redhat.com,
        omar.kilani@gmail.com, stable@vger.kernel.org, tglx@linutronix.de,
        viro@zeniv.linux.org.uk, linux-mm@kvack.org
Subject: Re: [PATCH v2] signal: Adjust error codes according to
 restore_user_sigmask()
Message-ID: <20190522221805.GA30062@chrisdown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190522032144.10995-1-deepa.kernel@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

+Cc: linux-mm, since this broke mmots tree and has been applied there

This patch is missing a definition for signal_detected in io_cqring_wait, which 
breaks the build.

diff --git fs/io_uring.c fs/io_uring.c
index b785c8d7efc4..b34311675d2d 100644
--- fs/io_uring.c
+++ fs/io_uring.c
@@ -2182,7 +2182,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 {
        struct io_cq_ring *ring = ctx->cq_ring;
        sigset_t ksigmask, sigsaved;
-       int ret;
+       int ret, signal_detected;
 
        if (io_cqring_events(ring) >= min_events)
                return 0;
