Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87D8A66A451
	for <lists+stable@lfdr.de>; Fri, 13 Jan 2023 21:45:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbjAMUpz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Jan 2023 15:45:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjAMUpy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Jan 2023 15:45:54 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80D378793C
        for <stable@vger.kernel.org>; Fri, 13 Jan 2023 12:45:52 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id o18so2390422pji.1
        for <stable@vger.kernel.org>; Fri, 13 Jan 2023 12:45:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oBsnza7SjgnXFTIjLQUDwUcM1ztzwvsDYDJycxWPRuM=;
        b=fuxKQIX4GR/eDBiDhjV4CW0niwbhXkxfJ/TM8VnS3wi8/N4+NaR71L5t1VxEjktnvl
         +5S2NjYa9zX/G5bYUyXsJyx4c4KSw2TWkzpNecUl19IS0+x8fXpIzufoQbgaXE6sQm9t
         e/zSqznM+RQYAIQZOOpFaKliJdXqtCr2M/x0c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oBsnza7SjgnXFTIjLQUDwUcM1ztzwvsDYDJycxWPRuM=;
        b=0fq7wvROyTyWPI+m8pXQ/8yJ6My8XrTp/NuHokjEZQXCMGq6bR0oc1YkPH7/m1OSmQ
         q31K2Ras7XMZuq08L3Fiy12KbylXC8fJNjh26WsdGOlvoXoVUWA+xoqC7mC2uSlOZaJ3
         mG00VWHu2zo5FjQ5vM1ZWFWLFYocY4V1eNkgqxPkwilr+p83qQMdGkkAeqbk0IWYOKc7
         LNoddDjT935fBreaR+Y8mm3uVHhiH1xs6/K0RCCbtddB4CqGMcq5CDPLrEYNE0C96p70
         1ZZ26Ek6gUXhIOCcAnNizeBz9n235vw7Hwnvw0TQL0z/sPtpI8MqDUw/HEPdlbtui/FJ
         Y/wg==
X-Gm-Message-State: AFqh2kovSiifL/RTkOab2XO3ZQ/rkAnJmKNkbwN8xkI4g3iorwmj98Fp
        m5ARtEOkvvm1JHIJF91wxiDDw0ZxplLAzkIW
X-Google-Smtp-Source: AMrXdXuPPgSWqm02NFgZb/rwdZksyLT26TQx05NI4EC+9K85sk+xYfvLjW2F/eEZQHMlVPhY5ovpNw==
X-Received: by 2002:a05:6a20:93a7:b0:b0:42a5:fe24 with SMTP id x39-20020a056a2093a700b000b042a5fe24mr104817648pzh.4.1673642751435;
        Fri, 13 Jan 2023 12:45:51 -0800 (PST)
Received: from smtp.gmail.com ([2620:15c:11a:201:4652:3752:b9b7:29f9])
        by smtp.gmail.com with ESMTPSA id f21-20020a170902e99500b001945b984341sm4010081plb.100.2023.01.13.12.45.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 12:45:50 -0800 (PST)
From:   Stephen Boyd <swboyd@chromium.org>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        Johan Hovold <johan+linaro@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15.y v2 0/5] phy: qcom-qmp-combo: Backport some stable fixes
Date:   Fri, 13 Jan 2023 12:45:43 -0800
Message-Id: <20230113204548.578798-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

Changes from v1 (https://lore.kernel.org/r/20230113005405.3992011-1-swboyd@chromium.org):
 * New patch for memleak on probe deferal to avoid compat issues
 * Update "fix broken power on" patch for pcie/ufs phy

Johan Hovold (5):
  phy: qcom-qmp-combo: disable runtime PM on unbind
  phy: qcom-qmp-combo: fix memleak on probe deferral
  phy: qcom-qmp-usb: fix memleak on probe deferral
  phy: qcom-qmp-combo: fix broken power on
  phy: qcom-qmp-combo: fix runtime suspend

 drivers/phy/qualcomm/phy-qcom-qmp.c | 97 ++++++++++++++++++-----------
 1 file changed, 61 insertions(+), 36 deletions(-)

Cc: Johan Hovold <johan+linaro@kernel.org>
Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc: Vinod Koul <vkoul@kernel.org>

base-commit: d57287729e229188e7d07ef0117fe927664e08cb
-- 
https://chromeos.dev

