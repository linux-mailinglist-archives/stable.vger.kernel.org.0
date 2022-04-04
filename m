Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 257BB4F1B52
	for <lists+stable@lfdr.de>; Mon,  4 Apr 2022 23:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379459AbiDDVTo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 17:19:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379420AbiDDRKU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 13:10:20 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8357C40A27
        for <stable@vger.kernel.org>; Mon,  4 Apr 2022 10:08:23 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id p15so21314008ejc.7
        for <stable@vger.kernel.org>; Mon, 04 Apr 2022 10:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=r1zkJrNdBsylC60WvH06cd0bPpn4EnJLrdZZGYAa/sc=;
        b=E9Vlp22XYvkxd7YEPEuFE+wQ25YJpYkx7Qq32CiCiX890h4/54mhUnxPHcBqnV5eP8
         hERzVj/rR3n+8bWRN5xw42YfmBMvhDD+N/so6NnEBy9oYvtDP/awq9JZbEnzCYNsGuRm
         UN2i44rwyAOzgug+pWESqUxxr0wBtRo7PxBSpOcSRfNKm3mr7HgD/J4/hO904T8VpgxC
         A8PmM3rQvTLJLS3S6vCwp8aeWE9wf/F851rMQ1kq+PyUpPTRbDYN0yPXBIZ06WaWEITH
         h4eJrYNHWnpVQ0DNFaK54QRIEAzB+PwAZDnjOdUkDO1U3MVbkpzDv3orgrgD0CuRHyCz
         LrFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r1zkJrNdBsylC60WvH06cd0bPpn4EnJLrdZZGYAa/sc=;
        b=zTtf58Ykf+VP2d+VpyIQZOfkn3h4aG5MNrVf7OS6bEbts6/MCajVF1rjVTIdKleikv
         jEmfY5zDpcGK6Go1ERY3JG7vrwRaeXMHQd4F2OcfM8ZU/OlZSTrGfCMv5/7Jgo7WbJ3B
         GawMzi+49+iMgvphP4fJBXX+FiDpq1B1r7dOlQI2q8JGTwMlbPZvDxUDVd5i8nKU9SMB
         1BfLSUgHAW4v0b0ZFS+bVr+/AieqgHfJ5Y+nwqEDBYY+r3DQHPgIl0TX28POhzL7CEtX
         osHiQMykcvGuSxM1CRzzQvz92z/l2LhJ2Gh/Be3v/7DucELP2c49mdQ/t5sx+6/qU6Zw
         Ahxg==
X-Gm-Message-State: AOAM530HfLXBRR7ChIL2+yePaQGNEkqu4bmEW8AamBASnpYdMbzDG2xV
        kphsqMcL77MBsFiQSnrQM92biT42XU48LmtX
X-Google-Smtp-Source: ABdhPJzMF6ihdQPNitGJDwCXZWdZhtRQGR16dy/3fZHEG6Wk7BbKyFBBz6Ea6jpPeG6R+sSeiCvOCA==
X-Received: by 2002:a17:907:7242:b0:6da:b561:d523 with SMTP id ds2-20020a170907724200b006dab561d523mr1083208ejc.118.1649092102075;
        Mon, 04 Apr 2022 10:08:22 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-201-27.adslplus.ch. [188.155.201.27])
        by smtp.gmail.com with ESMTPSA id u25-20020a170906b11900b006e08588afedsm4565827ejy.132.2022.04.04.10.08.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 10:08:21 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Johan Hovold <johan@kernel.org>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memory: renesas-rpc-if: fix platform-device leak in error path
Date:   Mon,  4 Apr 2022 19:08:15 +0200
Message-Id: <164909209237.1690243.4007351899063550816.b4-ty@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220303180632.3194-1-johan@kernel.org>
References: <20220303180632.3194-1-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
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

On Thu, 3 Mar 2022 19:06:32 +0100, Johan Hovold wrote:
> Make sure to free the flash platform device in the event that
> registration fails during probe.
> 
> 

Applied, thanks!

[1/1] memory: renesas-rpc-if: fix platform-device leak in error path
      commit: b452dbf24d7d9a990d70118462925f6ee287d135

Best regards,
-- 
Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
