Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07A4253E925
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239480AbiFFOQw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 10:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239689AbiFFOQ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 10:16:27 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 352B82CDE7
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 07:16:26 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id y15so10422389qtx.4
        for <stable@vger.kernel.org>; Mon, 06 Jun 2022 07:16:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bs46wIkTojshK3qQxH5h34z2IrnCxba/hWkIVn6b9fQ=;
        b=X63TRX8/j42tSQVhPx/COZgrEZlfA8PNwVSSCvR9tr4holzVqxqhMZ8b1/bTSraC3J
         mpJ7M2igXuY66aAkQLzAj4H8GSibMh9q64JZ0cEhpa4wV8uT9vK85yIk922cRlJIZj5j
         SS0uSEoaFMwa0n4TozfJ4Pokchpm0eM/TGUN634BvbLxlTs1Nwxew72+oM27XvOV7W53
         DJF71K9VtR0v1bkvX4arXtWbGcNpbizZR2J26UlTwDeFed1VezDGYh2yvkejdSV2PV2c
         0LrfQKDk6vUQWSHD5xT9U/i72Uua9+KhlL3cl3cfjKOJnBH7sK9llzie7SliuvZ5mEpV
         37Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bs46wIkTojshK3qQxH5h34z2IrnCxba/hWkIVn6b9fQ=;
        b=a6cSCMLbGvp72SSePzOYpHzYbBoYE6lFCQmNxufJ/pRhC7sqj8EOlIquPfRNmWTwLx
         RiVUXthlIULFkjJATa2LbyX+uqSSW6jsRCFBHg2LBG2qXCGFzxbs5HtgcsgU93GR+Utt
         OIuihlW/uOr9+x/tkRRNVYMzsyJuGZZkMvYRV5sm7k50zkz+K6ktxKKFYqs60sAZ/R3i
         +6UuWR7snhm7XRkP+RzeyCWHo68ugPscKAqaX4rmK8z/4hIdXhwGWtJ56wPT4jqzTGVO
         LaJBoubGBf/f3s30xThBGbMKS63C2Zt/+NQJKvuf/3d6CKund3xTJl4dtUltvkO6UJkj
         uv+Q==
X-Gm-Message-State: AOAM532NiNtOJUrrRM6HyYmw7k9H7kEoecxBNVbtOQ9MGJjYM3KNuY9D
        bbYLj5ydTvcBTiiKPl9fKJvCiGSy3jFdVw==
X-Google-Smtp-Source: ABdhPJzipC0VMLOLRu7Ri+UWuEcD8m2gl8v210mbczCJuZN6JYDmq4qhWwrVfvxQHW28qkJj4MWzvw==
X-Received: by 2002:a05:622a:1ba9:b0:304:dfdb:94c4 with SMTP id bp41-20020a05622a1ba900b00304dfdb94c4mr13135999qtb.488.1654524984984;
        Mon, 06 Jun 2022 07:16:24 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id z5-20020a05622a124500b00304efba3d84sm1264901qtx.25.2022.06.06.07.16.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 07:16:24 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     stable@vger.kernel.org
Cc:     kuba@kernel.org
Subject: [PATCH 0/2] net: ipa: older backports to fix page free
Date:   Mon,  6 Jun 2022 09:16:20 -0500
Message-Id: <20220606141622.725027-1-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This series back-ports two bug fixes, which are now in v5.19-rc1 but
do not back-port cleanly to older releases.  This commit applies
cleanly to v5.17.13, v5.15.45, and v5.10.120.

					-Alex

Alex Elder (2):
  net: ipa: fix page free in ipa_endpoint_trans_release()
  net: ipa: fix page free in ipa_endpoint_replenish_one()

 drivers/net/ipa/ipa_endpoint.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

-- 
2.32.0

