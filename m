Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2741327299
	for <lists+stable@lfdr.de>; Sun, 28 Feb 2021 15:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbhB1O3w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Feb 2021 09:29:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbhB1O3v (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Feb 2021 09:29:51 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C45F2C06174A
        for <stable@vger.kernel.org>; Sun, 28 Feb 2021 06:29:10 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id u187so9321847wmg.4
        for <stable@vger.kernel.org>; Sun, 28 Feb 2021 06:29:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qCy+l4W0SN+Qr0q0h1Kr4cn7PGq4wjNf/wKoSbiwHDE=;
        b=l+7csCuZQGg74lRO/aOwfa+azvIzyT13bs+7tEu51cqSR2+YvGM30NAa+8yIwlOIhg
         WRBongyXfTw3qdsbNBhUq8mLclr7VH5G0Krt/dNhPCb0PKFPLEIUMzXsjzXo92DS3/At
         Kx16EKbTlFiD2fWYYMpoTsoBFaKg9C76RRTN6/DIEiXSNi0MBAULu/q0E9PDYL4mp6sR
         uZr3ai/kDpbNMOxVwB03GOvglhpyYY8BfCJugOR5+cap3cdNSv8EHNaVprlDXE3k7lcO
         y1+MP3dlCtntLCrwOZfdzFWcYjLPS5Q9NAjL2XsPAqFA/LhTcnkAW+J2f+RQX2R5rVhk
         WKlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qCy+l4W0SN+Qr0q0h1Kr4cn7PGq4wjNf/wKoSbiwHDE=;
        b=oVtvaAfR0SfO4QF7dHYx1srPUqO1OInND95pvAmKlrvGgTIr4zLuYw6CTnFhFmGDyx
         FzrpSwj7EZxNoMBulG3m4A3GGns/cpj5haiG0V3j49i61WNR+Zkv6unQt05NLPM7/VQu
         x5o2ChMwdUTDdZ3KJPjtLtFdBh2Y4rZ1jPEdW1wlcdvjLIr526hKecpU4mXQ+3Gaf/9Q
         cndWcWojvWIxJcSma8L5rH7v2r1pGTsGvoBJVCM/uoqw9oi6evdw51E4LVtMvG123zIn
         jfjpE1P6WP3/Qz/U2XPBBaPvX+AiRg9G31lNzew3R+kn85c0HKDbgqGJjgzCziR7lGAO
         Vs7w==
X-Gm-Message-State: AOAM533jj2nt+mOujpvVOuiiBG6d33qno1bLcwrW+xDgfBsnJbQQ3Cmk
        iFL6e8GP27vRU+AEUB/YgbjZ0/Y6to0=
X-Google-Smtp-Source: ABdhPJyL5GhlUaJX6hs8PLE0HB6OEqb+oGhN+EkR5+6gYZBYI2Eqeg667g8cA3rHPnT/OjlOG4OfKQ==
X-Received: by 2002:a1c:730a:: with SMTP id d10mr11276577wmb.53.1614522549407;
        Sun, 28 Feb 2021 06:29:09 -0800 (PST)
Received: from archlinux.localnet (80.142.94.90.dynamic.jazztel.es. [90.94.142.80])
        by smtp.gmail.com with ESMTPSA id f126sm7245178wmf.17.2021.02.28.06.29.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Feb 2021 06:29:08 -0800 (PST)
From:   Diego Calleja <diegocg@gmail.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
Subject: -stable regression in Intel graphics, introduced in Linux 5.10.9
Date:   Sun, 28 Feb 2021 15:29:07 +0100
Message-ID: <3423617.kz1aARBMGD@archlinux>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

There is a regression in Linux 5.10.9 that does not happen in 5.10.8. It is still there as
of 5.11.1

This regression consists in graphics artifacts that will *only* start appearing after resuming
from suspend. They don't happen immediately after resuming from suspend either, but
after some minutes.

My system has integrated intel graphics
00:02.0 VGA compatible controller: Intel Corporation 4th Generation Core Processor Family Integrated Graphics Controller (rev 06) (prog-if 00 [VGA controller])                                            
CPU: Intel(R) Core(TM) i3-4170T CPU @ 3.20GHz

For reference, this is the list of i915 commits that went into 5.10.9.


commit ecca0c675bdecebdeb2f2eb76fb33520c441dacf
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Mon Jan 11 22:52:19 2021 +0000

    drm/i915/gt: Restore clear-residual mitigations for Ivybridge, Baytrail
    
    commit 09aa9e45863e9e25dfbf350bae89fc3c2964482c upstream.


commit de3f572607c29f7fdd1bfd754646d08e32db0249
Author: Imre Deak <imre.deak@intel.com>
Date:   Wed Dec 9 17:39:52 2020 +0200

    drm/i915/icl: Fix initing the DSI DSC power refcount during HW readout
    
    commit 2af5268180410b874fc06be91a1b2fbb22b1be0c upstream.


commit 54c9246a47fa8559c3ec6da2048e976a4b8750f6
Author: Hans de Goede <hdegoede@redhat.com>
Date:   Wed Nov 18 13:40:58 2020 +0100

    drm/i915/dsi: Use unconditional msleep for the panel_on_delay when there is no reset-deassert MIPI-sequence
    
    commit 00cb645fd7e29bdd20967cd20fa8f77bcdf422f9 upstream.


commit 0a34addcdbd9e03e3f3d09bcd5a1719d90b2d637
Author: Jani Nikula <jani.nikula@intel.com>
Date:   Fri Jan 8 17:28:41 2021 +0200

    drm/i915/backlight: fix CPU mode backlight takeover on LPT
    
    commit bb83d5fb550bb7db75b29e6342417fda2bbb691c upstream.


commit 48b8c6689efa7cd65a72f620940a4f234b944b73
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Mon Jan 11 22:52:18 2021 +0000

    drm/i915/gt: Limit VFE threads based on GT
    
    commit ffaf97899c4a58b9fefb11534f730785443611a8 upstream.


commit 481e27f050732b8c680f26287dd44967fddf9a79
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Mon Jan 11 22:52:20 2021 +0000

    drm/i915: Allow the sysadmin to override security mitigations
    
    commit 984cadea032b103c5824a5f29d0a36b3e9df6333 upstream.


Regards


