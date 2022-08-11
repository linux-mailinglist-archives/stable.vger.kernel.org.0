Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16DF358FBAC
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 13:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235075AbiHKLyb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 07:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235124AbiHKLyR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 07:54:17 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2106596772
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 04:54:16 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id gk3so33037079ejb.8
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 04:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=8/gCuLlq6u8R+QBHgUAn5VbxmKFRH8bhtzANmUPMWgM=;
        b=ePWPE73+Rzhz+4AjtKGAQg7Kz07Qku8FzQXLrA5eN6XIG5oURfO+p4k1kboLV3RsgL
         diejA4CNqRTAWOLgeuFuU5BMWOswXdWfflEOb7gP8cU8OYCkZKUqY0jY7fMFkcCvZNkU
         RR4MGsDGwVu6j+DiaaKOc0WnrkE+Octe+k1TdzvNZKkKC2sJXYX1o3net/2MQoula6+f
         6WhYREceqNCSkjPkrhrWDTOD8+HoCRjOR8BE4Ba0TKGmkByoqx9ZDlYbnmN154oqzdm9
         5HWirxU5rC8WMzRggRWOdxjG2doXN4fmscX4xIKvvLTsWkpI9B7yqHk3mO4bGty9F8Rn
         Q3mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=8/gCuLlq6u8R+QBHgUAn5VbxmKFRH8bhtzANmUPMWgM=;
        b=00k/rO5s54aSObMchK8wNKBYSJh6yqrL34WW2q0NhQQSWgHKZ9kKseumbGnWJzGqmm
         d12L397kN5/2gpFMiuNB6+U5aNnFRajDxtARVjyTxZ+47l+Tcogfn+1sNnSPLj0kDxyn
         0UsQlKuj2SQoHtKmoZKOIPvpsfnN2jCuJ6itIh4gaQoAyPG71uLxQbLntXxjuIj7YAXe
         0QMmhaFJvYZuiPt+4EIVzhpeGEI3HSIVRZpnysbu6i3/MHVoKpNe/C47l6zbnzPpxm91
         RS/tV5LeL2p9tdbfAW8Tq3FKPgmWU4EjXmmTyJ9D5OncIqbq+4CeLYG5+HdNl+cZRfuX
         ebVA==
X-Gm-Message-State: ACgBeo0QOXAet1XGF1rQWOdBBpJLKzFZ3FH/GX8KvNOXoiEofJyT0Mtz
        5EXbfjyHSmudc3zU1szpXgdFU9XGoF8=
X-Google-Smtp-Source: AA6agR7gR1RL/6+HhlzNm17hcP1LE2CJgg0F3nGifMlo6snuHRvlcxTgv8mYnFzFiX4fSIjqdSdWHA==
X-Received: by 2002:a17:907:7f23:b0:731:4dc7:9843 with SMTP id qf35-20020a1709077f2300b007314dc79843mr15031238ejc.152.1660218854700;
        Thu, 11 Aug 2022 04:54:14 -0700 (PDT)
Received: from alex-Mint.fritz.box (p200300f6af09a700e423d3e6c12e483e.dip0.t-ipconnect.de. [2003:f6:af09:a700:e423:d3e6:c12e:483e])
        by smtp.googlemail.com with ESMTPSA id mb11-20020a170906eb0b00b0072f4f4dc038sm3396049ejb.42.2022.08.11.04.54.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Aug 2022 04:54:14 -0700 (PDT)
From:   Alexander Grund <theflamefire89@gmail.com>
To:     stable@vger.kernel.org
Cc:     Alexander Grund <theflamefire89@gmail.com>
Subject: [PATCH 4.9 0/1] LSM: Initialize security_hook_heads upon registration.
Date:   Thu, 11 Aug 2022 13:53:39 +0200
Message-Id: <20220811115340.137901-1-theflamefire89@gmail.com>
X-Mailer: git-send-email 2.25.1
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

This patch replaces some error-prone ~350 line long C&P initialization
code with a simple for-loop doing the same.

Conflict resolution was required due to commits missing in 4.9:
- ca97d939 (security: mark LSM hooks as __ro_after_init)
- 791ec491 (prlimit,security,selinux: add a security hook for prlimit)
- d69dece5 (LSM: Add /sys/kernel/security/lsm)

Those add new (security) features and hence are now allowed according to
the stable kernel rules. See e.g. rejection of the first patch for 4.9 in
https://lore.kernel.org/all/YsrfDfe3urGkepvJ@kroah.com/

If any of the above commits are reconsidered for 4.9 I can provide
backports of those.

Tetsuo Handa (1):
  LSM: Initialize security_hook_heads upon registration.

 security/security.c | 359 +-------------------------------------------
 1 file changed, 7 insertions(+), 352 deletions(-)

-- 
2.25.1

