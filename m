Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B85556CA894
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 17:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232225AbjC0PHO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 11:07:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232636AbjC0PHJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Mar 2023 11:07:09 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A1773AB1
        for <stable@vger.kernel.org>; Mon, 27 Mar 2023 08:07:08 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id ew6so37457998edb.7
        for <stable@vger.kernel.org>; Mon, 27 Mar 2023 08:07:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1679929626;
        h=cc:to:message-id:date:from:content-transfer-encoding:mime-version
         :subject:from:to:cc:subject:date:message-id:reply-to;
        bh=0UFEbGRqt7rcAskYsh6grJN74iOCdchpE+7TjNCjkL4=;
        b=Uk5DlJVQiFOCAyO438dQ7y0Ej9U8TJAs8QHDwkE8teva/DjvMijj58U7AhXnoBjQ/G
         sMbocm7tv2KfAU+4waZe+mvPneY1Q5hEX1Lrpg0DRJGJd1CjrR9Hl3L7lkeZ4wQa8ODj
         aODv3RNO6FnmDWelqP9k6fnKiRWop4LOPMcPY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679929626;
        h=cc:to:message-id:date:from:content-transfer-encoding:mime-version
         :subject:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0UFEbGRqt7rcAskYsh6grJN74iOCdchpE+7TjNCjkL4=;
        b=44CJyAqSrHub6yhzrcHDus11/d/dXdBvRz3GRtbhPj4tbN00NtrFFVXSIu+osTtSZ+
         ATgbY/4tqB9wtAn4HerdDAIg0Strd/hOyr634uxztJyEyciolAKIfrFYkY+j1H7Xc/n2
         blZNYMMN0qw0KGWl/7vCBKSUbPt94bYzaVivambtCNOMGYf2qwb9Qp0gm5KzC/aLX9pu
         5VMJ2Okwc26Zh3M+If/EhBFdeJs3tn6lEtae5ndm0g2e6FbFxaA9DCEO7tEmYt3oNGc8
         AtjDxKkSNv/xJnu51MwUon9zHEbzOpSmOqFpGsc/rfDiyA+YUnidTivy1EVA2HZV554Y
         EH5w==
X-Gm-Message-State: AAQBX9dln12hHyM5LhoYQIrA9Ciqm7vxwKrC2GvmWV6mF3gzMWJe0eAm
        3CcLZFW9D0yjQhWd/oiL5yDJow==
X-Google-Smtp-Source: AKy350actXROnpcdn2lmx5wDV0TPEejAcfimbqFaHL731CO4ATVjrEQu1XuGrt9lvpNKvZKC6/f/Nw==
X-Received: by 2002:aa7:c609:0:b0:4fa:ecdc:e44b with SMTP id h9-20020aa7c609000000b004faecdce44bmr12080742edq.24.1679929626563;
        Mon, 27 Mar 2023 08:07:06 -0700 (PDT)
Received: from alco.roam.corp.google.com ([2620:0:1059:10:ed3c:5e9e:b8e4:8695])
        by smtp.gmail.com with ESMTPSA id t9-20020a50c249000000b005021d1ae6adsm5312428edf.28.2023.03.27.08.07.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 08:07:06 -0700 (PDT)
Subject: [PATCH v4 0/2] kexec: Fix kexec_file_load for llvm16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAyxIWQC/33N3Q6CMAwF4Fchu3Zm3fj1yvcwxkBXYBFGsgnREN
 7dxkujXDWnzfm6ikjBURSnZBWBFhfd5Dmkh0RgX/uOpLOchVbaKKNB3ulJeMOBb5DLNAOF2ljQFQ
 ruNHUk2YTaY88tPw8DL3sXH1N4fX4swOPyj1tAKlkXedmixgJTe8Y+TKObx+MUOnFlbNG7gGbAgq
 LMZlCUefUDMLuAYSBrFeRYWkVl8QVs2/YGHtmubzQBAAA=
From:   Ricardo Ribalda <ribalda@chromium.org>
Date:   Mon, 27 Mar 2023 17:06:52 +0200
Message-Id: <20230321-kexec_clang16-v4-0-1340518f98e9@chromium.org>
To:     Eric Biederman <ebiederm@xmission.com>
Cc:     linux-kernel@vger.kernel.org, Baoquan He <bhe@redhat.com>,
        stable@vger.kernel.org, Ross Zwisler <zwisler@google.com>,
        Ricardo Ribalda <ribalda@chromium.org>,
        Philipp Rudo <prudo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, kexec@lists.infradead.org
X-Mailer: b4 0.11.0-dev-696ae
X-Developer-Signature: v=1; a=openpgp-sha256; l=1624; i=ribalda@chromium.org;
 h=from:subject:message-id; bh=c/Cef+C3wMgRslM3TKLYo/Fx7R2kWnifW8QXo2DyqYc=;
 b=owEBbQKS/ZANAwAKAdE30T7POsSIAcsmYgBkIbEOxUf1VwPNCpjkoRxJUrAGmu9A9fnWdmb5L5VA
 wW+pMCGJAjMEAAEKAB0WIQREDzjr+/4oCDLSsx7RN9E+zzrEiAUCZCGxDgAKCRDRN9E+zzrEiOjND/
 9IHDPa+BnNrrVbx15zUGOg/Puq2djPp0nMs1Bjy5OtucU4d8Mm5xg0Q9TwgufJuZ0NqYk8kGbja9Nu
 y6/2suuXEdMr9W0Zi1rxHlYgO2XAklZR15uUjk73Cx97mKWDt68p+VLcnNS967KJjB/6+Pi5uiLQ3l
 3XKSfKrN/XZeqMzbViurzi0mWw7lO8/EwIgd23jYeButR4rSdqUWm3sdVLbm6PSgkAVdfOvP+BFvu9
 1ytum13E5pu08RpMV8Zpj6tA0lcZTnAZ+2y+z2CL9BqemWA2PHfUtuS8jjOpUpmJyyjVQuOmznnEys
 gQ15HtMS2lVAYuG3g5oRk2mPjqEzkfkuql8384sq1uKzJ4HswLj4qRckUb+JQwE8NsNtHWvPXiX73g
 EyNoTPxWWp1I2uLyd9OhEWD1qGyKXhG5o5OuL+lOH7tIOw8P7xsLmKNz0jc5b3ASdjrUEgsWVo2QMF
 0WTg5oXJ+GybniwJaGqZf6tq1LgzBXEtbVLYc4wMPg46eyALDK/pXJkW8mt7snIYk85cVBj6kHWnmH
 DIDC86y0ogc4WKXaqRcg7Srs9pPWWVes9VAKbTthTWMkM+Oev09qbdFB1M9Upic9XYO8kWt7Mz11l9
 cnjS2Lt/NrLGwv14oa5zOpPSV495yV2BSx5ko0aGP+Xy8NdYt+73I0yHsxXg==
X-Developer-Key: i=ribalda@chromium.org; a=openpgp;
 fpr=9EC3BB66E2FC129A6F90B39556A0D81F9F782DA9
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When upreving llvm I realised that kexec stopped working on my test
platform. This patch fixes it.

To: Eric Biederman <ebiederm@xmission.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Philipp Rudo <prudo@redhat.com>
Cc: kexec@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <zwisler@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>

---
Changes in v4:
- Add Cc: stable
- Add linker script for x86
- Add a warning when the kernel image has overlapping sections.
- Link to v3: https://lore.kernel.org/r/20230321-kexec_clang16-v3-0-5f016c8d0e87@chromium.org

Changes in v3:
- Fix initial value. Thanks Ross!
- Link to v2: https://lore.kernel.org/r/20230321-kexec_clang16-v2-0-d10e5d517869@chromium.org

Changes in v2:
- Fix if condition. Thanks Steven!.
- Update Philipp email. Thanks Baoquan.
- Link to v1: https://lore.kernel.org/r/20230321-kexec_clang16-v1-0-a768fc2c7c4d@chromium.org

---
Ricardo Ribalda (2):
      kexec: Support purgatories with .text.hot sections
      x86/purgatory: Add linker script

 arch/x86/purgatory/.gitignore        |  2 ++
 arch/x86/purgatory/Makefile          | 20 +++++++++----
 arch/x86/purgatory/kexec-purgatory.S |  2 +-
 arch/x86/purgatory/purgatory.lds.S   | 57 ++++++++++++++++++++++++++++++++++++
 kernel/kexec_file.c                  | 13 +++++++-
 5 files changed, 86 insertions(+), 8 deletions(-)
---
base-commit: 17214b70a159c6547df9ae204a6275d983146f6b
change-id: 20230321-kexec_clang16-4510c23d129c

Best regards,
-- 
Ricardo Ribalda <ribalda@chromium.org>
