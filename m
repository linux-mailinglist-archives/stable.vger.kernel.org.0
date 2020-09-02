Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF6225AC88
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 16:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbgIBOHF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 10:07:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727935AbgIBOGP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Sep 2020 10:06:15 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A46EEC061258
        for <stable@vger.kernel.org>; Wed,  2 Sep 2020 07:05:57 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id q21so5066221edv.1
        for <stable@vger.kernel.org>; Wed, 02 Sep 2020 07:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wKCaTDiN4ta/y8Zq6Cx61ZhYRClgqJd4G2H2pspsSBc=;
        b=Tq/lIGreZyzBta8jpiSh/MMth/noJOnjTFclLyt4k3XcY56CCJBss69Sd1xTzIbqrQ
         kiDOjO+NGC5xf24koQEZy0Cq1t+klLa1tMdSF/Pv9XCpMe7zDtuppooLxT+gDZkXt1J9
         PGEvr6QUnt4S8H9GWo+m5wd9UACHwn/VUY0hSqGxR7Ra7+M88bTpMgTgk6///W9DBaCD
         QIokEmHDt5q1hqRACYCssczEEUe76fIn6YHMUSKLm8qWW1jjjnx/mmL0lVhoC6ZjX0jV
         jFHw8HuCf3gMwi5EWhUAUpooWIYHUWPvDOaFXAJNPDkuWm/gdgBOR+8a+u4mCuSpLh8k
         xnlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wKCaTDiN4ta/y8Zq6Cx61ZhYRClgqJd4G2H2pspsSBc=;
        b=p6I654zfcC/I0FR7mQjjyEY4mKvARIIiUzpCH07LCP5qfrCUT2p3DoFpOhdtypjZLq
         tqsPhbraQFXZ2nV0jsHtDX4eIuSt5bkJrvnsCBqPA/4HNpuZRoqJGlsoNN9naUeEYvJ1
         ut17N6Gk17gSfhVw1NrMzKJTr3I3dzQEBGRv3XGqq7/rPrFzR0mKS3AFVNNbGbf0EgK+
         SZtrTVR3N3vFc2oAIX3K5pdMswvRilxQ4vXT2A/Rq13hZg92U30OVr118Lp03aOdDFAw
         ivcGSH3FoWF/R1PyEGK3up0Fhr9dkRgBKbW11njXkQ0c7iJnRCF+/EFQqQaZ6HCBcsLR
         5W6g==
X-Gm-Message-State: AOAM532r7loSSVzSQkCdNoluOaWovds/BmJCT2J0NASgiacAv+9OoyfY
        oKIerppbSBijGWL70hO4rkgrMg==
X-Google-Smtp-Source: ABdhPJw63+s1mn/EDgaa/DWNwgguf64Cdy3vM/HLO7Xu86jRaaB/0GA8q/ZlnHU+KT/Dw+yg1pFjfw==
X-Received: by 2002:a50:954d:: with SMTP id v13mr192227eda.337.1599055556314;
        Wed, 02 Sep 2020 07:05:56 -0700 (PDT)
Received: from tim.froidcoeur.net (ptr-7tznw14oqa3w7cibjsc.18120a2.ip6.access.telenet.be. [2a02:1811:50e:f0f0:8cba:3abe:17e1:aaec])
        by smtp.gmail.com with ESMTPSA id r15sm4119296edv.94.2020.09.02.07.05.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 07:05:55 -0700 (PDT)
From:   Tim Froidcoeur <tim.froidcoeur@tessares.net>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        matthieu.baerts@tessares.net, davem@davemloft.net,
        Tim Froidcoeur <tim.froidcoeur@tessares.net>
Subject: [PATCH 4.9 0/2] net: initialize fastreuse on inet_inherit_port
Date:   Wed,  2 Sep 2020 16:05:43 +0200
Message-Id: <20200902140545.867718-1-tim.froidcoeur@tessares.net>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix for TPROXY initialization of fastreuse flag.
upstream patch was backported by Greg K-H to 4.14 and higher stable version.

see also https://lore.kernel.org/stable/20200818072007.GA9254@kroah.com/

code in inet_csk_get_port for 4.9 (and 4.4) is different from
the upstream version, so these backports had to be adapted (a bit)

Tim Froidcoeur (2):
  net: refactor bind_bucket fastreuse into helper
  net: initialize fastreuse on inet_inherit_port

 include/net/inet_connection_sock.h |  4 ++++
 net/ipv4/inet_connection_sock.c    | 37 ++++++++++++++++++++----------
 net/ipv4/inet_hashtables.c         |  1 +
 3 files changed, 30 insertions(+), 12 deletions(-)

--
2.25.1
