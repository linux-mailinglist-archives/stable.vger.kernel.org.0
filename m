Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D36BE3AED8
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 08:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387702AbfFJGCs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 02:02:48 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:44576 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387614AbfFJGCs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jun 2019 02:02:48 -0400
Received: by mail-pf1-f194.google.com with SMTP id t16so4616209pfe.11
        for <stable@vger.kernel.org>; Sun, 09 Jun 2019 23:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oiqyk2fqvY8Wxa+AUW6LBvtulmR3WAAfiFvLluT/yN0=;
        b=V/WQIgKqS6n8RQJYdphxCmnWUd0oLZW8MxFyWGWyuXAw2khv6ZuaGjr5coTXzX7DP2
         JCpHf6YeZQCffEohhMmXN5bzVCjYHy57jM9bnb6RmipKQbRgXaVw3QRA3Jwgowjd7GmT
         +MNgzaxL0+Orcr1ZxgcuLwlgCCXEZwheVIhziq+NBvFKPfnfd6dKWCviM5sJuvpivS6w
         u5xxiJSCBlr8lGfkZ1ef3zWknEys89VCONWd7pljTenP6Y58BqEMr1yYJ6iXdxPgXF9z
         yY6vMFLUJvvsAqrulsxnuMbVz0thwSXOh30mPAlXjy/5on+320RsV0zsGOWh03jspO32
         iJgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oiqyk2fqvY8Wxa+AUW6LBvtulmR3WAAfiFvLluT/yN0=;
        b=E8dbO2bkuIB1Lan01AFKNituZgW9eGSh2pFkkj2M8dz6UBYo9/bLzQAe68C4Br1eGJ
         p32sFzvIvBwg9gihFuAxbkGvyJ6OOqna+XQAy6n/Rd4thCpSFbD/GTuhiN2a5S2d8Qyo
         jY9JiaQjsAIQkpKrAGw/ksUnyHcrIgEDIw5OeObjKbdLpUk4JO39PJE2i1cLY7gjM2WW
         cKWBagtxI+kXkWwRT1RiHWOtcBAdFkAYIiek33NEVK91qt9y/L8M8QXDd6MW7HNsI+zD
         ERFpkO6Rv9RCN3zT09WqTEUQC/OY4qw8DIwBgFcTuATmLUSkrkQmM9q9G0REVpeAWSnW
         2p6w==
X-Gm-Message-State: APjAAAWWSJHKLnHRipmMdvZlgQ5I5ygiUWqh+J+PdczJAwqGCZls4B+I
        RuitvsdpC5Jjl3Lta+fLEeJc2/O8zGxsrIpU1CI3GKbxES9/z51RLO+rJkYUzklNAJNqjkTKJRO
        LXUd+88zfruvkSGMoZ2YmMj9pywQEqwtU6bMwr3Y0U9wfqA52HpZp3tA67WHj45OPKchNSoOPSQ
        ==
X-Google-Smtp-Source: APXvYqxyggShq7axA1il9SLPrTgF6hkHD6PakQ0bRaWFvez8BS39YV0hHlhH6ywIDutrzjip7eqB+A==
X-Received: by 2002:a17:90a:9281:: with SMTP id n1mr18936607pjo.25.1560146567262;
        Sun, 09 Jun 2019 23:02:47 -0700 (PDT)
Received: from localhost.localdomain (123-204-46-122.static.seed.net.tw. [123.204.46.122])
        by smtp.gmail.com with ESMTPSA id x17sm8914263pgk.72.2019.06.09.23.02.45
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 09 Jun 2019 23:02:46 -0700 (PDT)
From:   Jian-Hong Pan <jian-hong@endlessm.com>
To:     stable@vger.kernel.org
Cc:     linux@endlessm.com, hui.wang@canonical.com,
        Jian-Hong Pan <jian-hong@endlessm.com>
Subject: [PATCH stable-5.1 0/3] drm/i915: Prevent screen from flickering when the CDCLK changes
Date:   Mon, 10 Jun 2019 14:01:39 +0800
Message-Id: <20190610060141.5377-1-jian-hong@endlessm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190603100938.5414-1-jian-hong@endlessm.com>
References: <20190603100938.5414-1-jian-hong@endlessm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

After apply the commit "drm/i915: Force 2*96 MHz cdclk on glk/cnl when audio
power is enabled", it induces the screen to flicker when the CDCLK changes on
the laptop like ASUS E406MA. [1]

So, we need these commits to prevent that:
commit 48d9f87ddd21 drm/i915: Save the old CDCLK atomic state
commit 2b21dfbeee72 drm/i915: Remove redundant store of logical CDCLK state
commit 59f9e9cab3a1 drm/i915: Skip modeset for cdclk changes if possible

[1]: https://bugzilla.kernel.org/show_bug.cgi?id=203623#c12

Jian-Hong Pan

Imre Deak (2):
  drm/i915: Save the old CDCLK atomic state
  drm/i915: Remove redundant store of logical CDCLK state

Ville Syrjälä (1):
  drm/i915: Skip modeset for cdclk changes if possible

 drivers/gpu/drm/i915/i915_drv.h      |   3 +-
 drivers/gpu/drm/i915/intel_cdclk.c   | 155 ++++++++++++++++++++++-----
 drivers/gpu/drm/i915/intel_display.c |  48 +++++++--
 drivers/gpu/drm/i915/intel_drv.h     |  18 +++-
 4 files changed, 186 insertions(+), 38 deletions(-)

-- 
2.22.0

