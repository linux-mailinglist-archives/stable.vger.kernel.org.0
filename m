Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73E306688BC
	for <lists+stable@lfdr.de>; Fri, 13 Jan 2023 01:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238170AbjAMAyY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 19:54:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232890AbjAMAyJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 19:54:09 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2049E11C32
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 16:54:09 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id 17so21948477pll.0
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 16:54:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xsayLyP7nh0k2HOHnHJ4pw0bqMbBUybwNSC5DyRKIC8=;
        b=bMip9NCrJH3DnbTyVthFl9yIiF3j/16C2WV0j690Wq/w/Ow5h3S79FZMagva/XpF7e
         tXprTN8l54WBgwPZqJBu+hiHHC+UWMy0S1sDG/zAi1P0y/InvPPN7uWHrPBB4hYIiGUO
         0K5gjGa5AztHL5McB0FbEiUggdnsWQcrr3g/I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xsayLyP7nh0k2HOHnHJ4pw0bqMbBUybwNSC5DyRKIC8=;
        b=V/f6yyFE1r0IFu70B6VZaicLOwFw5dk6DYStf8gRhfh4Obzr+BNfzt7xn34ehOe4kg
         VzsZQp4dwhWC/lwS71RKFrkJm4xK6hasfkiGhBG1Ge5MoWOkxxMJl1kdJiJHngO+OUzk
         vAdyc6Nle6ZytSL+7a0amwlez+1OJDz9rIO3MQnyH0a3clBEuEP1i4X8uswKqPuzwTJK
         IIIKWUNI9OkkPTdzMof6a1eLDAbw6Js4INwLB1GJCRgAIlMkYxYieQqRd2u4d/KLD/jB
         UPs9tgWpKSEqX5bb9uRJasIsfDlC2MjS1780zocpeZTlr/SNEyR+JkOAaOICWVUSa5K1
         D8vQ==
X-Gm-Message-State: AFqh2kpyctfw2E4lMKEY1Qr5qC1fwam4klI+/xXTYaq7VwVOkTnKiZad
        b4mJ3wAsd+aaaPXK09Z/1p2oRkTvxynrQQvD
X-Google-Smtp-Source: AMrXdXsLH6UhWCasDyJvsSNInG39OEZLlwb5rDlmlSiORB314t+bQ4mWVdUfo0L9yrPzsFD0DI9lCw==
X-Received: by 2002:a05:6a20:9591:b0:ad:7428:d326 with SMTP id iu17-20020a056a20959100b000ad7428d326mr100677310pzb.30.1673571248151;
        Thu, 12 Jan 2023 16:54:08 -0800 (PST)
Received: from smtp.gmail.com ([2620:15c:11a:201:4652:3752:b9b7:29f9])
        by smtp.gmail.com with ESMTPSA id u11-20020a6540cb000000b0046ff3634a78sm10676614pgp.71.2023.01.12.16.54.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 16:54:07 -0800 (PST)
From:   Stephen Boyd <swboyd@chromium.org>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        Johan Hovold <johan+linaro@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15.y 0/4] phy: qcom-qmp-combo: Backport some stable fixes
Date:   Thu, 12 Jan 2023 16:54:01 -0800
Message-Id: <20230113005405.3992011-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

After the qmp phy driver was split it looks like 5.15.y stable kernels
aren't getting fixes like commit 7a7d86d14d07 ("phy: qcom-qmp-combo: fix
broken power on") which is tagged for stable 5.10. Trogdor boards use
the qmp phy on 5.15.y kernels, so I backported the fixes I could find
that looked like we may possibly trip over at some point.

USB and DP work on my Trogdor.Lazor board with this set.

Johan Hovold (4):
  phy: qcom-qmp-combo: disable runtime PM on unbind
  phy: qcom-qmp-combo: fix memleak on probe deferral
  phy: qcom-qmp-combo: fix broken power on
  phy: qcom-qmp-combo: fix runtime suspend

 drivers/phy/qualcomm/phy-qcom-qmp.c | 72 ++++++++++++++---------------
 1 file changed, 36 insertions(+), 36 deletions(-)

Cc: Johan Hovold <johan+linaro@kernel.org>
Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc: Vinod Koul <vkoul@kernel.org>

base-commit: d57287729e229188e7d07ef0117fe927664e08cb
-- 
https://chromeos.dev

