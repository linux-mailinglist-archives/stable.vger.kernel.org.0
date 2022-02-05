Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 163944AA7F5
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 10:46:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358061AbiBEJqS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 04:46:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232747AbiBEJqR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 04:46:17 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63C8CC061346;
        Sat,  5 Feb 2022 01:46:15 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id k6-20020a05600c1c8600b003524656034cso5219622wms.2;
        Sat, 05 Feb 2022 01:46:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qU07P8b4s3aU3J8L25YSPpPeM9OCHx/a+SiTu8+fsuI=;
        b=aEZ75wmyYlr2tUWJgSM0dFUNoQXiyqTDbiM5XAhiKDc74EUfqyUwA0H8fYxWemHphG
         ZBIfKnkBlnd4mDNDsbnUvFM0+K0UungO3GGXw9nvFGJdjECj9sXsktWmzpUY8THuC7Ud
         lD6U5xDdmhn1paOX0vjMoqYxCzyXoZSwt2zfNaXipv2XV1ip2qNPkbO8SjA5DDl2vpwk
         0gri7d7wZWORI/ScsabGRZJX5B4SiyGirmbOiqiXfCiplwMy3YppaBpH84xTh0GH3N59
         S1pERXJ5EzGwCLpG3AAy+tC5Jspx0NObf/5hAuFNKYoRPm5snzQOzhM23H46ClupZOeF
         hxIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qU07P8b4s3aU3J8L25YSPpPeM9OCHx/a+SiTu8+fsuI=;
        b=i3TYjGSkFfV+EPU0SpMVv5pwo878Qwjv/C9I6aJhkfUF0thDJwSdNiv1i92MwKRkjJ
         40BX6HZHG/1hIuvq02xIYbUvSXpmojO0A27rTVd25I5rkF92sCvot0mXtMWTH2f259Ro
         HcVGUQd7nUtq3F92JkFhBfFmyehNTz8s+BGziPDi8+Md2AdJKJerAHtuXzHxRXTAJgIy
         fYANfppyday3YNlo3p2lq3oI2q7N+mwmA0gAT+PlSHz9fdgsm8ywmONSN8HfWKQj3g3g
         OAEClp57EJjY+jzJWS8msQUFGXvR9ojN5rlAqC7GWwIFoRnEItFOV1dyccwH4AsbWzf9
         HmCQ==
X-Gm-Message-State: AOAM533wu7MXdcsqZpdL/XePB4QdGLnOz2WRan6RC0wODlpS6LI4H+2/
        B737/wN1Don6EuQVXVr5AR0=
X-Google-Smtp-Source: ABdhPJxJaaH6KUScVhffLZs1OWOKJ2bmEM8BAACp+OFqd5p4nwHLDa8NHgE4WvjNAQDcS8x36Z9UAw==
X-Received: by 2002:a05:600c:1d85:: with SMTP id p5mr2388303wms.36.1644054373571;
        Sat, 05 Feb 2022 01:46:13 -0800 (PST)
Received: from hp-power-15.localdomain (mm-89-21-212-37.vitebsk.dynamic.pppoe.byfly.by. [37.212.21.89])
        by smtp.gmail.com with ESMTPSA id n2sm4679828wrx.108.2022.02.05.01.46.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Feb 2022 01:46:13 -0800 (PST)
From:   Siarhei Volkau <lis8215@gmail.com>
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>, linux-mips@vger.kernel.org,
        linux-clk@vger.kernel.org, stable@vger.kernel.org,
        Siarhei Volkau <lis8215@gmail.com>
Subject: [PATCH v3 0/1] clk: jz4725b: fix mmc0 clock gating
Date:   Sat,  5 Feb 2022 12:45:30 +0300
Message-Id: <20220205094531.676371-1-lis8215@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <4FSS6R.0A48V2ZMZD7X1@crapouillou.net>
References: <4FSS6R.0A48V2ZMZD7X1@crapouillou.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The mmc0 clock gate bit was mistakenly assigned to "i2s" clock.
You can find that the same bit is assigned to "mmc0" too.
It leads to mmc0 hang for a long time after any sound activity
also it  prevented PM_SLEEP to work properly.
I guess it was introduced by copy-paste from jz4740 driver
where it is really controls I2S clock gate.

Changelog v2 .. v3:
 - Added tags Fixes and Reviewed-by.
Changelog v1 .. v2:
 - Added useful info above to the commit itself.

Siarhei Volkau (1):
  clk: jz4725b: fix mmc0 clock gating

 drivers/clk/ingenic/jz4725b-cgu.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

-- 
2.35.1

