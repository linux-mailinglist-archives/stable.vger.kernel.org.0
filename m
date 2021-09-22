Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8A3414EA1
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 19:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236698AbhIVREC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 13:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236690AbhIVRD5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 13:03:57 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8768DC061762;
        Wed, 22 Sep 2021 10:02:23 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id q68so3344627pga.9;
        Wed, 22 Sep 2021 10:02:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+5/G0wNYSsPonzPykbqlENShLiJ+dcmYAQjyK7QqizU=;
        b=qKVlKCNWFot0H01I3Mo0kJ2wuqRaXpzV4Yvv3ny+wxmdYBFkjz4HLkR7EVfhXPNJMl
         yPKsu+QVdG2fso4cP534byFU0ZSIydYJHYWwc//t0edr9xt6WcvMHWBxa6hFhoPB4VA1
         9ambc9E5nnedPMme8mYyYeuUdf1GuHN1PnObYt3XAANnQIx+53Npfavc6LF8QmVI44kU
         tsdm1EhfQcisonB/OLcL/IbkQiBqY9P8SIY4HSDNOlqBABAQKJrfnc3W9b3SgPbK6hKv
         0341Kw/zMLVNGE3bsEjidzFD3Ivz4PyJkIwisyu5YigJztu6h15up69HD/mLdvSZL3oP
         g4OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+5/G0wNYSsPonzPykbqlENShLiJ+dcmYAQjyK7QqizU=;
        b=5COrryUGjXNjppH8vZxR5QYePqt4OHAnad0i9p4JYsThFHFST+LysTFIvbCHJClW+S
         kBAzW6CbL/ocujXA47raX1vvqBYYzKVxtywrdwVC4NjeGksyn6C/ko/RJ7v5zDKrdfZ4
         5x6BPexGoZ792CUciHnSnk+Um+QWnWuWrPFu/qW1FGlC3U1QoxSETEpDAL7yB9pktDuh
         NKEJbBNxkYgmRDWrYJXFl7iwMPcuM8Mlu8o0gQEv3oIJhAw+4qnIf82EX/1pkrLAtS8q
         67F5txdD2aHI+robhQiW3dELlMKba2SZBvan8wJ1Wez6kRPvDQVqsRHFQHu93OlogUIY
         QR4g==
X-Gm-Message-State: AOAM531KiJdGGRJlX3vT+f6qSXF6m2+J3Yh6AFOB57lV8n/V0U8DHxCp
        9xkSyVNsAgwuR+PJuqzwPsZYVQKD2Z0=
X-Google-Smtp-Source: ABdhPJywg50i4u7wS1zROBXH3T9yBP2SGuE8Lx1UDkAOfSKuSf5AsH8FH1jiRAS7ZxPvhXZts8K1Zg==
X-Received: by 2002:a63:f913:: with SMTP id h19mr615433pgi.351.1632330142698;
        Wed, 22 Sep 2021 10:02:22 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r76sm2796579pfc.2.2021.09.22.10.02.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 10:02:22 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Alex Sverdlin <alexander.sverdlin@nokia.com>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT)
Subject: [PATCH stable 4.14 v2 0/4] ARM: ftrace MODULE_PLTS warning
Date:   Wed, 22 Sep 2021 10:02:06 -0700
Message-Id: <20210922170210.190410-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch series is present in v5.14 and fixes warnings seen at insmod
with FTRACE and MODULE_PLTS enabled on ARM/Linux.

Changes in v2:

- included build fix without DYNAMIC_FTRACE

Alex Sverdlin (4):
  ARM: 9077/1: PLT: Move struct plt_entries definition to header
  ARM: 9078/1: Add warn suppress parameter to arm_gen_branch_link()
  ARM: 9079/1: ftrace: Add MODULE_PLTS support
  ARM: 9098/1: ftrace: MODULE_PLT: Fix build problem without
    DYNAMIC_FTRACE

 arch/arm/include/asm/ftrace.h |  3 +++
 arch/arm/include/asm/insn.h   |  8 +++---
 arch/arm/include/asm/module.h | 10 +++++++
 arch/arm/kernel/ftrace.c      | 46 ++++++++++++++++++++++++++------
 arch/arm/kernel/insn.c        | 19 +++++++-------
 arch/arm/kernel/module-plts.c | 49 +++++++++++++++++++++++++++--------
 6 files changed, 103 insertions(+), 32 deletions(-)

-- 
2.25.1

