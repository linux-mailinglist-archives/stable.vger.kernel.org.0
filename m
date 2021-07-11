Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 889C73C3B62
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 11:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231987AbhGKKAt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 06:00:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbhGKKAt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 06:00:49 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F404C0613DD
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 02:58:02 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id k16-20020a05600c1c90b02901f4ed0fcfe7so9253455wms.5
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 02:58:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=56+H0JW/2Pf8Zd1MqwXSgnDI7f6wt6P7h2rgDhNLDzw=;
        b=2SWIhAmM/X3Wr1qK+Dv/WefXxS8j/OeK/rYdidcI2C8scWZphuHeyX+27t7ecpw0Yy
         IhDrog9fyOANod3Ks0XB7rUyIRphlclCh+nttWNI0WvJRwJA6CWT2Cv5eqCcr8jPu/P9
         ApimnWJ9MaqywU7Afg3cl3NxCXM4zsIaMmxfjY0aLBZTGt0ZL7XsFR1s0w5bJgLK0h5A
         hNOCCqOl7xDNa+BBrsFu9Rh+PvCkiN1u0mEZIdbJ1F2h1kRC9Tbb1JHWRQbVTa0EBZSe
         Y/w79cyZp7Jkxzz+T8ZkhltkXa6TIPMYIwvGQZxg37W6YjgAgG0xhzwQ8eQVHu479Te8
         h83Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=56+H0JW/2Pf8Zd1MqwXSgnDI7f6wt6P7h2rgDhNLDzw=;
        b=kNViMCIWcEgbHWxd0oBcDfajaIdu1aKWeGHfZ6IZLrNGTQ1ytoV0FEpqL4k9a07m+D
         Wos1ZZDCw3G7zxxKCeGAfakwVCQpRVZjsFq4e0IJs0sjCgcETowJ04tzG5PYAH9uBYzn
         F3jgy8+W0n9g72laz8YTVe/6IpH1DL6uAikLhoiHNrYVh/fuiuUEIKbMWeVQaqH/E4wk
         aF2eKLfLr7vPUcqOljIOvj0cLelSaat0NmbOzna2bJsSyy4Hy7PMtpTUw0Dv791Pof40
         fcBVnNYYayGO3PAQ6M8HheGbV46T3z/3jbpBKzK0odh95P412j+5DDIhZ1T7VM9AF41y
         9KjA==
X-Gm-Message-State: AOAM532KsL2L70HGAPeW1x9Ycn2Ox4t/gAEpUA2/sAZGNFmnf7xB4NPj
        hoyxV0/TUnfbguLztVzevILY8w==
X-Google-Smtp-Source: ABdhPJwSBLwReyDtz2OpqQaw1MV+mnyo5FLW9+AhuJbYvT3hwZIIOotUastfEa+IUTAVKxBKFekZaA==
X-Received: by 2002:a1c:1bd4:: with SMTP id b203mr8725783wmb.171.1625997481209;
        Sun, 11 Jul 2021 02:58:01 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id m18sm9095567wmq.45.2021.07.11.02.58.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 02:58:00 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     stable@vger.kernel.org, roopa@nvidia.com,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net 0/2] net: bridge: multicast: fix automatic router port marking races
Date:   Sun, 11 Jul 2021 12:56:27 +0300
Message-Id: <20210711095629.2986949-1-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Hi,
While working on per-vlan multicast snooping I found two race conditions
when multicast snooping is enabled. They're identical and happen when
the router port list is modified without the multicast lock. One requires
a PIM hello message to be received on a port and the other an MRD
advertisement. To fix them we just need to take the multicast_lock when
adding the ports to the router port list (marking them as router ports).
Tested on an affected setup by generating the required packets while
modifying the port list in parallel.

Thanks,
 Nik

Nikolay Aleksandrov (2):
  net: bridge: multicast: fix PIM hello router port marking race
  net: bridge: multicast: fix MRD advertisement router port marking race

 net/bridge/br_multicast.c | 6 ++++++
 1 file changed, 6 insertions(+)

-- 
2.31.1

