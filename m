Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18D8B5BB174
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 19:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbiIPRGX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 13:06:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiIPRGW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 13:06:22 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AD4AB6029;
        Fri, 16 Sep 2022 10:06:21 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id c24so359897plo.3;
        Fri, 16 Sep 2022 10:06:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date;
        bh=3Wa/fw4wW71fQ+xBzkS6YeYWBKqLIyGhivfP++bxPiI=;
        b=fCEudfuUQILhZE4oNHBAjST/pWD21J8kQzBpdyYcRCy9sK2A8O0UGwXcHn3PCLCHLN
         afUuYFlNm/ADOYhKDLuzG/PJKWpnSDAcavaLCJhzu0AfBCvW6cRTE/9BRkJ9XCMMjVht
         tPRaypoj0fNo7AnRTkwDcbCzz/g9eR1J1rcmIw5rCPCeOY4d6UFlVb3YrzIRspGiBmeF
         7VQWtAAEbi96GSUJryVxFtq878UoNr4LDfMyUqZck2bwkgLE1tF+fFT7ep91WbL3BuYx
         735Ywu6v3Yo2PzfNjYYbT7oxEgGwTmhEUtFxt4RBiG91pLqE6w0/gV8C9sps5mIv+bk6
         qdPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date;
        bh=3Wa/fw4wW71fQ+xBzkS6YeYWBKqLIyGhivfP++bxPiI=;
        b=GAAclyTcj/tOTna08CtYihvVjW0b7zhQOGXsgUdks6omSp0fz0ElyK/ntMnbDEfIb0
         IMLVJuleAFHCqs02vKxTFP9/cU2dAE9yumb2jmcfgqZiz4JjhHoXmq91EjNu3gksLhl9
         x6/+kxQDVrPWWJ/NR1HD4xPYvzQkt266Bd0G3GNkmqKQJgAhuU3neCeEtaUJPvpXDds8
         yp3yR1LBJcQuZNomRcUm2WV7LnpryocZN5q/nxHEmjCz62B0tZGs/wQXZ83PerSuoXV4
         K1iUu4yho/YKZXNYjOzw/wct8NZtWE++Sk20nWfNlGIq/GWnAnpKpzUaNFGQWP2/sAd9
         DsyA==
X-Gm-Message-State: ACrzQf2Qg5Z0XsMEQzjXG7IbH7hDLhUw6xqPx3fbhBcrBssHiMzqx3Hg
        jCNYhVMHI2b72B5awRrOvRT6wOr93R9XZAcP1bs=
X-Google-Smtp-Source: AMsMyM5YQ8lTJNxRrgMhzyu8jazAOF+HhFY5GsUMB0OuM+jA2QEyFn7nPADF3Dt7LNsSmtUpcZSXjA==
X-Received: by 2002:a17:90b:3852:b0:202:f891:9ed5 with SMTP id nl18-20020a17090b385200b00202f8919ed5mr6611509pjb.239.1663347980899;
        Fri, 16 Sep 2022 10:06:20 -0700 (PDT)
Received: from localhost.localdomain ([117.176.186.9])
        by smtp.gmail.com with ESMTPSA id z12-20020a170903018c00b00176d4b093e1sm15386677plg.16.2022.09.16.10.06.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Sep 2022 10:06:20 -0700 (PDT)
From:   wangyong <yongw.pur@gmail.com>
X-Google-Original-From: wangyong <wang.yong12@zte.com.cn>
To:     gregkh@linuxfoundation.org
Cc:     jaewon31.kim@samsung.com, linux-kernel@vger.kernel.org,
        mhocko@kernel.org, stable@vger.kernel.org, wang.yong12@zte.com.cn,
        yongw.pur@gmail.com
Subject: [PATCH stable-4.19 0/3] page_alloc: consider highatomic reserve in watermark fast backports to 4.19
Date:   Fri, 16 Sep 2022 10:05:46 -0700
Message-Id: <1663347949-20389-1-git-send-email-wang.yong12@zte.com.cn>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <YyREk5hHs2F0eWiE@kroah.com>
References: <YyREk5hHs2F0eWiE@kroah.com>
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Here are the corresponding backports to 4.19.
And fix classzone_idx context differences causing patch merge conflicts.

Jaewon Kim (2):
  page_alloc: consider highatomic reserve in watermark fast
  page_alloc: fix invalid watermark check on a negative value

Joonsoo Kim (1):
  mm/page_alloc: use ac->high_zoneidx for classzone_idx

 mm/internal.h   |  2 +-
 mm/page_alloc.c | 69 +++++++++++++++++++++++++++++++++------------------------
 2 files changed, 41 insertions(+), 30 deletions(-)

-- 
2.7.4

