Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 733156E4188
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 09:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbjDQHpD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 03:45:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjDQHpB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 03:45:01 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93BD71982
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 00:44:43 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id ffacd0b85a97d-2f46348728eso742523f8f.3
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 00:44:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681717482; x=1684309482;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q//e7qaqughnPCo1F/i+SeOq6/eX66Ej8mh5j/ct1pw=;
        b=W2mD0MPRAkuFA3FfSr2vuJMF6S3FrJUcuA+8gz/Pfwe5nOBHdp06855HRV/c3AMXBB
         KVUuRdxZ7uwMww2K2XZ0KXCooWYIlU0nx8c6CPANcXuYxfO9f0Dt7qrBL8Aj306lLTLR
         1IYKSmyq1QzG2zovl6y0xqjwEkEJ1Lomu3rCOccWvTM26H+FsglTQ3AX5INCBQY2b/dO
         CNN3nCXOM1H4orljD0v4I5IWURH6RgczeZYWial/x+sBnwZOV3yIydmWnBpTvQprpB/z
         axgmH84N8pIRzICg5yz+cbAaREVhConb3FQ6E0Z+Sq4zh/Mz46GY1UeqjjoXUg+NKVgt
         bVrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681717482; x=1684309482;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q//e7qaqughnPCo1F/i+SeOq6/eX66Ej8mh5j/ct1pw=;
        b=BJ/IbU6WdKuv7/Exal1qfw6XnWs3yJ6mvmQJ/Y4IGZ9mEeWOWC2FfPLon8qtffZFe8
         irGqJPm5+Dh5Aa7zz23F0ws8nTt0z+MXqcvlLUUacmlFYbPSH3hn8r7KjdfwCO0dx48l
         VZlrcfETmeqdhBURYjHYbSy7vhe5AGOuOfAE2fGGl1UwZaxgzdOWq4wZG7aJSQAqwMNb
         MrINpIURInFGo40+xT4+QCxCPN2sTdxuTvNpYCf2bWs/lqEH7JWGxII4umoXmrVwZbqW
         oltmv4uFvR43pzzLppHVnBnZMO97+Cj8wZOozlJcaHG+5+920nxXT/65vX4Mvpy931Qr
         uU5Q==
X-Gm-Message-State: AAQBX9ees/ycQxrGzSfFnR4paTEs6FtKMtEesWa+EZ/BUCQbeMjUYKhE
        1uUIdrk1iBjyVjRxAz3ioAeIVA==
X-Google-Smtp-Source: AKy350ZOVLQAlAzQbeb7qqULkqACRYkBlRFZOitvcvISxwquy2k86KPJKTIUe0y5GgOYg6CQjAjJuA==
X-Received: by 2002:a05:6000:100a:b0:2f6:9368:63c5 with SMTP id a10-20020a056000100a00b002f6936863c5mr4694914wrx.10.1681717482001;
        Mon, 17 Apr 2023 00:44:42 -0700 (PDT)
Received: from arrakeen.starnux.net ([2a01:e0a:982:cbb0:8261:5fff:fe11:bdda])
        by smtp.gmail.com with ESMTPSA id k16-20020adff290000000b002f53fa16239sm9826899wro.103.2023.04.17.00.44.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 00:44:41 -0700 (PDT)
From:   Neil Armstrong <neil.armstrong@linaro.org>
To:     Sam Ravnborg <sam@ravnborg.org>, David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Philippe CORNU <philippe.cornu@st.com>,
        Thierry Reding <treding@nvidia.com>,
        James Cowgill <james.cowgill@blaize.com>
Cc:     stable@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20230412173450.199592-1-james.cowgill@blaize.com>
References: <20230412173450.199592-1-james.cowgill@blaize.com>
Subject: Re: [RESEND PATCH] drm/panel: otm8009a: Set backlight parent to
 panel device
Message-Id: <168171748107.4136849.13756409513746780386.b4-ty@linaro.org>
Date:   Mon, 17 Apr 2023 09:44:41 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Wed, 12 Apr 2023 17:35:07 +0000, James Cowgill wrote:
> This is the logical place to put the backlight device, and it also
> fixes a kernel crash if the MIPI host is removed. Previously the
> backlight device would be unregistered twice when this happened - once
> as a child of the MIPI host through `mipi_dsi_host_unregister`, and
> once when the panel device is destroyed.
> 
> 
> [...]

Thanks, Applied to https://anongit.freedesktop.org/git/drm/drm-misc.git (drm-misc-next-fixes)

[1/1] drm/panel: otm8009a: Set backlight parent to panel device
      https://cgit.freedesktop.org/drm/drm-misc/commit/?id=ab4f869fba6119997f7630d600049762a2b014fa

-- 
Neil

