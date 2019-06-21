Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC2D4E568
	for <lists+stable@lfdr.de>; Fri, 21 Jun 2019 12:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbfFUKHh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jun 2019 06:07:37 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39504 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbfFUKHh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jun 2019 06:07:37 -0400
Received: by mail-pg1-f195.google.com with SMTP id 196so3138972pgc.6
        for <stable@vger.kernel.org>; Fri, 21 Jun 2019 03:07:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HxGoCOuBbTbftU42WcBzCXCpJOZpH2iZ5ehTTHqmgoI=;
        b=G18dlpzahgGMZ44EC2h9aN/wSpz42VN5QaWfY/HXIdEtUJJZ6muwLm+0zkJmQsLKGD
         Uyymm86Z7LAGvy9sfy6How6//5Wg7HC33dUvbNN9nww2IAt2IlAMofe7HmvwZMaFjne1
         G8IVS3J1CK+G60Sgfb+1wyoXrpG3pAWV0kqy0CtZODHTCJCwzPyUtXv9kmyegz9s6tLg
         wAUzDibL1r+pCtKD87KC1sm7O9ggA9zkrUX8RC+1bt17+Nmp1GtcL/4H4WBPewjlZ5gi
         RozNtrRRGUcq8RDjM56tkwGPZp5cE8oSeGeDkyDGsWE2El+wZ/UZ4s0E1Qqw4GJX/G+b
         v7vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HxGoCOuBbTbftU42WcBzCXCpJOZpH2iZ5ehTTHqmgoI=;
        b=ZTNuM/Z0A7nmV8V3yG+B1GBvspElGRLuSNypEgCzVnQbOEXdAokY5d20JNsc46BAeS
         c++ICOSZkyEUmNxUp+Id84vSC1F3hQx0DFTl0QYoU20lOuMMHCMVnuEaJrK0cdGXs6QD
         syxwM2VFKaGGOK59+iG2SUUWkUh5EJxJycRnW05M2kWxj2PtLjuW0o7ImaSQ0YAfxTz9
         yi9wRIKaM8quJT+DyeFmywjJXGxtHi2KRb7JwGCxq8iWBFv15L1aSiJyRgBtQkvWjp7e
         SOmp3/vODkNwognF7qTTrXLScCplvYTjvS3SIZV11RIYM3mFeN9XAhfQD9yidhm6as9x
         eOyg==
X-Gm-Message-State: APjAAAU3HMEJ4jzxbviVWtKueqm9C+owBeMSeoLYZX0nIEZf8iLS3LZ8
        jB9WRVcprIdmIzoc895daPHHGg==
X-Google-Smtp-Source: APXvYqwlgHibq//YoZTkdz1u6A58/ekGWNBrI/SlFO8Dqpyy47sjl61PbNrEmO9meEKr5F9BTzlIlQ==
X-Received: by 2002:a17:90a:5884:: with SMTP id j4mr5803347pji.142.1561111656211;
        Fri, 21 Jun 2019 03:07:36 -0700 (PDT)
Received: from localhost.localdomain (123-204-46-122.static.seed.net.tw. [123.204.46.122])
        by smtp.gmail.com with ESMTPSA id c18sm2246892pfc.180.2019.06.21.03.07.33
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 21 Jun 2019 03:07:35 -0700 (PDT)
From:   Jian-Hong Pan <jian-hong@endlessm.com>
To:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc:     Imre Deak <imre.deak@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Abhay Kumar <abhay.kumar@intel.com>, tiwai@suse.de,
        hui.wang@canonical.com, linux@endlessm.com,
        Jian-Hong Pan <jian-hong@endlessm.com>
Subject: [PATCH stable-5.1 v2 0/4] drm/i915: Prevent screen from flickering when the CDCLK changes
Date:   Fri, 21 Jun 2019 18:07:12 +0800
Message-Id: <20190621100716.8032-1-jian-hong@endlessm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620141949.GD9832@kroah.com>
References: <20190620141949.GD9832@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

To make it more clearly, I re-send this patch series again.

To fix "the audio playback does not work anymore after suspend & resume"
on ASUS E406MA, we need rediffed commit "drm/i915: Force 2*96 MHz cdclk
on glk/cnl when audio power is enabled".  However, after apply the
commit "drm/i915: Force 2*96 MHz cdclk on glk/cnl when audio power is
enabled", it induces the screen to flicker when the CDCLK changes on the
laptop. [1]

So, we need these commits to prevent that:

commit 48d9f87ddd21 drm/i915: Save the old CDCLK atomic state
commit 2b21dfbeee72 drm/i915: Remove redundant store of logical CDCLK state
commit 59f9e9cab3a1 drm/i915: Skip modeset for cdclk changes if possible

This issue is also reconfirmed on the list. [2][3]

[1] https://bugzilla.kernel.org/show_bug.cgi?id=203623
[2] https://bugs.freedesktop.org/show_bug.cgi?id=110916
[3] https://www.spinics.net/lists/stable/msg310910.html

Thank you,
Jian-Hong Pan

Imre Deak (2):
  drm/i915: Save the old CDCLK atomic state
  drm/i915: Remove redundant store of logical CDCLK state

Ville Syrjälä (2):
  drm/i915: Force 2*96 MHz cdclk on glk/cnl when audio power is enabled
  drm/i915: Skip modeset for cdclk changes if possible

 drivers/gpu/drm/i915/i915_drv.h      |   6 +-
 drivers/gpu/drm/i915/intel_audio.c   |  62 ++++++++-
 drivers/gpu/drm/i915/intel_cdclk.c   | 185 ++++++++++++++++++++-------
 drivers/gpu/drm/i915/intel_display.c |  57 +++++++--
 drivers/gpu/drm/i915/intel_drv.h     |  21 ++-
 5 files changed, 269 insertions(+), 62 deletions(-)

-- 
2.22.0

