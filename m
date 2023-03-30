Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 975D26D000C
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 11:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbjC3Jp6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 05:45:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230354AbjC3Jph (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 05:45:37 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF2F8A66
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 02:45:15 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id cn12so74126058edb.4
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 02:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1680169513;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AmFm2H2aOAkbQY/h2v5MAmP45SXRmGLw4e1al6CBI2I=;
        b=PGpd/3k73zNpbvHVT1UNSiV5gtK0hy3DPGeYWoIayaboLOGFXTitshD+imYv2Js4WA
         MM1Y6zOlUAy2AFVvLHyZtSslq5XKgyyZG3y39FnjeXLrlTVhDhAjXvJZMQx1Us3QGzMi
         qb6Sl0zeTh2D/1f/uRItg4eljeiJoSj7Y+tCo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680169513;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AmFm2H2aOAkbQY/h2v5MAmP45SXRmGLw4e1al6CBI2I=;
        b=ed416ER1vyQelnGA4kACv3wg6LixraSEuf1qE6Kk4pWG3qq4pLMTBmGND2yfsavnOq
         mzjOdHHN0a8EVbqYAASdxWIxhk3TmOq5lx3sRFRlccvhiygoTUQaCRty+OBNAkx4WFaD
         Vq3HU25HS6jycSKC6tyc+8zbKZLxDnl1WQH8d71D010hhLIajcMwPC7LZxtKeb4C5RB8
         SY19MqwhqEdWMgnxe4Tz1tzYE0JuQJZlsFR9yQLF1JhDv6OIVCQcUruNwoJVb9DovzFu
         R4ibzcKcsCYo+0OPW+s3qsK8MxdcGg3IOWHK//WYmHrdXfYGlKFZlfOpVBWa290pkAIN
         M6CA==
X-Gm-Message-State: AAQBX9e/KYIllTddb2PPfP70qZ3dIW75HssY+x51yqKDeS1+DSlYFXjy
        CA6DV1a6Qb2ChPHAlmcOfFHtEg==
X-Google-Smtp-Source: AKy350ahiWO+Fj4V7FTU9MC6Fk01PllpwoR7WJ4iOZ/5VlJFhikZNy2psVuFakzSi4JpxpkDOWltmw==
X-Received: by 2002:a17:906:5a43:b0:8aa:be5c:b7c5 with SMTP id my3-20020a1709065a4300b008aabe5cb7c5mr24312480ejc.41.1680169513712;
        Thu, 30 Mar 2023 02:45:13 -0700 (PDT)
Received: from alco.roam.corp.google.com ([2620:0:1059:10:1396:ff5d:6e2a:df6d])
        by smtp.gmail.com with ESMTPSA id k9-20020a17090666c900b0092b606cb803sm17683616ejp.140.2023.03.30.02.45.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 02:45:13 -0700 (PDT)
From:   Ricardo Ribalda <ribalda@chromium.org>
Subject: [PATCH v5 0/2] kexec: Fix kexec_file_load for llvm16
Date:   Thu, 30 Mar 2023 11:44:46 +0200
Message-Id: <20230321-kexec_clang16-v5-0-5563bf7c4173@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAA5aJWQC/33OzQrCMAwH8FeRnq00/dg6T76HiGxp5opzg1aHM
 vbuBo+iO4Uk/H/JLDKlSFnsN7NINMUcx4Ebt90I7OrhQjIG7oVW2iijQV7pSXjGnndQSOtAoTY
 BdIWCM02dSTapHrDj1PDoex52Md/H9PrcmIDL8R83gVSyLgvfosYSbThgl8ZbfNx2Y7qIE2OTX
 gU0AwEUueCg9EX1AzCrgGHAtQoK9EGRL38AdhWwDICxyoFvK0/fHyzL8gYkFJwTdQEAAA==
To:     Eric Biederman <ebiederm@xmission.com>
Cc:     Baoquan He <bhe@redhat.com>, Philipp Rudo <prudo@redhat.com>,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ross Zwisler <zwisler@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Simon Horman <horms@kernel.org>,
        Ricardo Ribalda <ribalda@chromium.org>, stable@vger.kernel.org
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1562; i=ribalda@chromium.org;
 h=from:subject:message-id; bh=SayQVLE6H72tjacCmNcmtcnOuUDgjnttSSVkCQO8nwU=;
 b=owEBbQKS/ZANAwAKAdE30T7POsSIAcsmYgBkJVoXZBZQgBE2mt6hnkD3x10Mo+77PbgkqAlUv
 DUrdUN7lMCJAjMEAAEKAB0WIQREDzjr+/4oCDLSsx7RN9E+zzrEiAUCZCVaFwAKCRDRN9E+zzrE
 iAdoD/9iPmpE6/UU41Svse7e7tdRS16SUUtYUJeo/EFBaOCBvwrfjzy8VWZRlbSxOLj6kZtGhxU
 e9QmkiwAYz3MriXFz0LgSFPithiLGCwsyGKGLisVczcoCpN2Mh4gZ7mS0Iugy0rrChSnc0juGYq
 yG2ZrJWuOwycDBefzYLh4UxL08GlvUIP9XC7fBTEcosZQl3k9i3F3F1uUzBqCIUgGDMHmF+9JW+
 VrPi4F2Lz7d2+EVQihLq8QT6IoU+aiwDlHodOl04LQd9a92rzP7UGTqH7idqDJjH6vAXwMh0Qw4
 udF9lMsdLFUqO5ikYkDMtlolratzqThH5Az/A9LFd+c3zpJvTQZ25v1sAKVPnKXUJDZwD2+pIkG
 +KMCpHt02hPHttKKfxolte4FXkQzk1V4hKbdpahadN98uUPVityKckSZvuw5uFFWLJ8j3DRd0tm
 ex5WZCiztgdnpWZ3Z23x7zk+/qVBk9Wn2AYVC8nsgDiJJ9AKa0RKCrDKeh+zIcPPLx/60U5/iDe
 c3MQ7eQqNq1jsrfoET70+HpUDHw4TX7JsWPcMRXgNWjtkBgiRDC79LjlrJOMQoMgfjPMIj/cKCc
 js4lKsxpS5AMD97rqiQKEIybAUTE1U/4s7iGp0UHDdnSaSn5kUJoGok+xMCGMvrrlnygTUIyYO/
 dRH2kKxwSXes4qA==
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

Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
---
Changes in v5:
- Add warning when multiple text sections are found. Thanks Simon!
- Add Fixes tag.
- Link to v4: https://lore.kernel.org/r/20230321-kexec_clang16-v4-0-1340518f98e9@chromium.org

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
 kernel/kexec_file.c                  | 14 ++++++++-
 5 files changed, 87 insertions(+), 8 deletions(-)
---
base-commit: 17214b70a159c6547df9ae204a6275d983146f6b
change-id: 20230321-kexec_clang16-4510c23d129c

Best regards,
-- 
Ricardo Ribalda <ribalda@chromium.org>

