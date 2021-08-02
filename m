Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86F303DDF8C
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 20:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbhHBSsS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 14:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbhHBSsR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Aug 2021 14:48:17 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C856C06175F
        for <stable@vger.kernel.org>; Mon,  2 Aug 2021 11:48:08 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id a8so3416430pjk.4
        for <stable@vger.kernel.org>; Mon, 02 Aug 2021 11:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jlekstrand-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GfPTHirVH4/s6rg/tvG7E82zmnCVWWXPT3XYQHUIv1k=;
        b=ObGHFO+Lg3vstXjr9IR4vZwG07WFscetbwhF+os2sRhMq2Ew8XSFy20xrY9fju3Hcw
         XybZMptQnaiTW20GQGFz8BsbA+kRBPVP+0peQ94vDTbRgEN6oRc1hz/AJs8ilgi+9Jv7
         ATGtdsyoY/pepfWTIT4Yuq8HO+Y9X+/5QQNA56cSr61Dd7dihzMcm3Q2WUMGxjFJqJEb
         038kUIvoS94d9GSralDqsnNdC49rQA2jRtSy0gMq0wgKSE7kauMfcSFyEKrM0H79dIWH
         0+DvF88ryDD7gF7mCvXgqco1h3mlBzhJFsqtMNuPaKbfpj6WnTSfr8HBuSioqEy3Nx9E
         /wQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GfPTHirVH4/s6rg/tvG7E82zmnCVWWXPT3XYQHUIv1k=;
        b=lAizQ2WYLMiYyqN9yd3WpZE9fYEXEpmZNsz7mKSu/zDl3kOiPhqjuS5R84zXjqkHsR
         0RcyhkRUDupdi++Sb2jpySNvZLwAaXb3z+nmDr2+Z3MO746X5tOXIrfpxWVofL47q4Aj
         gO+yS5r45954BnrpsiJ1auFDjdgDvB/G0UC+kr6BsbGkHn06CVk4lWKYS5HhPCyAppdS
         QITptUu1LHOyC/FW2cdQHa+e9WYDXZEkZgmb4c9KwVjFe4tnWKpYrvaTmG71hOvoMiQi
         KxgZj6FPxc4dyHHJCEsTFGPtn8Ctj2+UoFvkhs4DcYFHVdxwaywjVsE+4fIn/A8ZuhvU
         Vs4g==
X-Gm-Message-State: AOAM531lI1apUxO0isWIldQbrc9JiVqAc39wgxrrWO0+3Q2nVXihFLLT
        NiMp9JhiX8KOUzBgHvvAW7L0N8sloqlZ/9x9
X-Google-Smtp-Source: ABdhPJz+BvQPPXMiOx8TIzRL8WeC5Vpp+yPs+IvO014JgdYrA4xVJp5N/v4YRFT/a+KhJJAeuxqqgw==
X-Received: by 2002:a63:374e:: with SMTP id g14mr377889pgn.170.1627930087448;
        Mon, 02 Aug 2021 11:48:07 -0700 (PDT)
Received: from omlet.lan ([134.134.137.81])
        by smtp.gmail.com with ESMTPSA id w9sm849931pfg.151.2021.08.02.11.48.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 11:48:06 -0700 (PDT)
From:   Jason Ekstrand <jason@jlekstrand.net>
To:     stable@vger.kernel.org
Cc:     Jason Ekstrand <jason@jlekstrand.net>
Subject: [PATCH 0/2] BACKPORT: drm/i915: Get rid of fence error propagation
Date:   Mon,  2 Aug 2021 13:48:00 -0500
Message-Id: <20210802184802.414849-1-jason@jlekstrand.net>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a back-port of the following patches from torvalds/master to 5.10:

 - 686c7c35abc2 ("drm/i915/gem: Asynchronous cmdparser")
 - 9e31c1fe45d5 ("drm/i915: Propagate errors on awaiting already signaled fences")

Jason Ekstrand (2):
  drm/i915: Revert "drm/i915/gem: Asynchronous cmdparser"
  Revert "drm/i915: Propagate errors on awaiting already signaled
    fences"

 .../gpu/drm/i915/gem/i915_gem_execbuffer.c    | 164 +-----------------
 drivers/gpu/drm/i915/i915_cmd_parser.c        |  28 +--
 drivers/gpu/drm/i915/i915_request.c           |   8 +-
 3 files changed, 27 insertions(+), 173 deletions(-)

-- 
2.31.1

