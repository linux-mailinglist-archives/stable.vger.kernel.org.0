Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3537F543DF4
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 22:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232003AbiFHUzD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 16:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235470AbiFHUyj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 16:54:39 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9358C1DB1E5
        for <stable@vger.kernel.org>; Wed,  8 Jun 2022 13:54:20 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id d123so1245733iof.10
        for <stable@vger.kernel.org>; Wed, 08 Jun 2022 13:54:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2MOYgMvH7/z+WZBAfZGy92HtVeL4lufQ4ZfQJr4ZgeU=;
        b=C6N9DaB8oX9BXFu0GTXuLnPGMyFw04ttNxp/sQ/GAZR5LaOKN5ZtuN8/g3LWNEJ7Oa
         +BPCcXif4UG4nsDacJL+WX4BF9lFXDXDVH/jdlkCAOJU9hW4Uv0i6+ARCxLjT8y8HY3N
         CV2en18B9fLn5/taQGsWdQQGNKD/JInDRaEgBTKiwipEfFTmkmoGRE7VqFCv6YfDvJQI
         YJwQVNKnG8fmHypybyyQCi2BDWOrkJCf9kyVSpO0qJ+17yCLTtbpu7Ul3hpzpkJhm3Se
         0Ro5Cz9eKvzKMiwPq3xY72YqXb+2m9RFbH9OqobQgGQczYxr5lyIrKAS/CiadqXWwQkW
         kaxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2MOYgMvH7/z+WZBAfZGy92HtVeL4lufQ4ZfQJr4ZgeU=;
        b=vVF4XS5bamNkg8+grlOprf51vhDTKXqfe+Z5d3UGlr7BD4EaAuifF83+pjfh9COn/+
         jeeVMChk1R8uf4X1ScvSc/FqwKUS8Fpyoj8ZdvCQgWKrs5OAzewDH2dPPb7cdyYqXvLF
         BUeDhXE7YdJCEs5hG+TYdlG6LpWkTus6TMgKfq/RK+1UNsZXPrna/cB3ZpljF0WIcLXP
         QCqIFzhCRy/LFOYRrCNm8OQ4OM8Po04MmApbc6XFU7+y3Qvi0E9yMtc2a3rsUCiYqaI4
         E4bsGiP4mcNUc5Xem/WpKMSUbSLLyeZ0nCnWStIvC90qWS+7u28P+cvD2cAzKUVzelxW
         4hAA==
X-Gm-Message-State: AOAM531gjBfo8GaJw39Py6w7nZXniX/PIXziBLYOGg9uW4AXl4oRXZ0s
        hMcFqss6a/JOV8JwWPYdcysiK9NkS7HlFg==
X-Google-Smtp-Source: ABdhPJwXy6YX1MPpnH7PUHAVrX/fbwqcPtImQYHLYde7z/Cpm5334mSC7Pv7kFqt/bGmO0EQvZdMKw==
X-Received: by 2002:a05:6638:dd3:b0:331:d98c:9a67 with SMTP id m19-20020a0566380dd300b00331d98c9a67mr4449398jaj.47.1654721658736;
        Wed, 08 Jun 2022 13:54:18 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id a18-20020a6b6d12000000b0066938e02579sm6033370iod.38.2022.06.08.13.54.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 13:54:18 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     stable@vger.kernel.org
Cc:     swboyd@chromium.org, elder@linaro.org, dianders@chromium.org,
        bjorn.andersson@linaro.org, djakov@kernel.org,
        quic_mdtipton@quicinc.com, quic_tdas@quicinc.com
Subject: [PATCH v5.10.x 0/2] Fix SC7180 suspend for v5.10.x
Date:   Wed,  8 Jun 2022 15:54:13 -0500
Message-Id: <20220608205415.185248-1-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
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

These patches were back-ported to v5.15.x, but we might as well
include them in v5.10.x too.

					-Alex

Stephen Boyd (2):
  interconnect: qcom: sc7180: Drop IP0 interconnects
  interconnect: Restore sync state by ignoring ipa-virt in provider
    count

 drivers/interconnect/core.c        |  7 ++++++-
 drivers/interconnect/qcom/sc7180.c | 21 ---------------------
 2 files changed, 6 insertions(+), 22 deletions(-)

-- 
2.34.1

