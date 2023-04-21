Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2BE6EB1CA
	for <lists+stable@lfdr.de>; Fri, 21 Apr 2023 20:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232592AbjDUSnA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Apr 2023 14:43:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233372AbjDUSmz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Apr 2023 14:42:55 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 138982728
        for <stable@vger.kernel.org>; Fri, 21 Apr 2023 11:42:53 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id ca18e2360f4ac-7606e2d0376so213376039f.3
        for <stable@vger.kernel.org>; Fri, 21 Apr 2023 11:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1682102572; x=1684694572;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QGmpVDlM7szKPAXBXr0QOtmzbtyw9J0tZvTkPv2CLvY=;
        b=Iqd+gRMXC8bIX/PnDbdUnywKo9Baed3b7i7SrvbMxaJ8isr0Drob0XeYPnn6fRpnjx
         lFgVwRKjbnx5Qn08D60ETTUwj8eeEOnu7enlsx3/AB1/hPtgnrEB4kIoN0M7ahcBhVQh
         FIGDtiHcKoMohGNNcAUt9zXQhZKaUAucA8Kz0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682102572; x=1684694572;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QGmpVDlM7szKPAXBXr0QOtmzbtyw9J0tZvTkPv2CLvY=;
        b=IO5/AxxEMSigaTlJ7xV5oZEPNgwlEjEJfxFhmaQQAale2uL7MYIgvueHlFfZI3ap7w
         /cX2tzoPFlQZH/yfqUcK3SD8mnl9dqptuef57ofYRgRgwyxzTD4gWYvu4ZzwKinud2gg
         NqT67A8TZ8CNHEE5FH4swYcTFAIo1u9u93p9xrJwP1VLUswxWtzPgDHMDO0kPBnW1/1g
         wmU8rrhcHUa/YRgk1Z9+VL+U3qvOQgDJAwQpVNQLakjPP2n/gneLn7VfE8J9CplXl4u/
         vGzAxZlc2uVVclmW1Xv0YhBPtImfHIuAOQckkcQXV6teeNVLLBZjMT4kgctOiBi/Qy3W
         optw==
X-Gm-Message-State: AAQBX9dgndhia26kvxAtQyuQy/aK5japwcvrDt0ZEGjUGARsOJgxHiKG
        ViifNBjoQLIGKAsZtubOAS8z0iF/fViWtXjLi94=
X-Google-Smtp-Source: AKy350YocU+4MXJDH09PteCY46AW8J8CSCMx1Q4upKddyigRY7hAmDGOdYGCKWyMbAC46QipJ27lxg==
X-Received: by 2002:a92:c992:0:b0:328:adff:570a with SMTP id y18-20020a92c992000000b00328adff570amr5749376iln.3.1682102572195;
        Fri, 21 Apr 2023 11:42:52 -0700 (PDT)
Received: from markhas1.lan (71-218-48-220.hlrn.qwest.net. [71.218.48.220])
        by smtp.gmail.com with ESMTPSA id k32-20020a056638372000b0040da046d6fasm1444249jav.146.2023.04.21.11.42.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 11:42:51 -0700 (PDT)
From:   Mark Hasemeyer <markhas@chromium.org>
To:     stable@vger.kernel.org
Cc:     bhelgaas@google.com, kai.heng.feng@canonical.com
Subject: [PATCH] PCI:ASPM: Remove pcie_aspm_pm_state_change()
Date:   Fri, 21 Apr 2023 12:42:30 -0600
Message-ID: <20230421184230.1468609-1-markhas@chromium.org>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 08d0cc5f34265d1a1e3031f319f594bd1970976c upstream.

This change is desired because without it, it has been observed that
re-applying aspm settings can cause the system to crash with certain pci
devices (ie. Genesys GL9755).

Tested by issuing 100 suspend/resume cycles on a symptomatic system running
5.15.107.

L1 settings looked identical before and after:
```
localhost ~ # lspci -vvv -d 0x17a0: | grep L1Sub
                L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.1+ L1_PM_Substates+
                L1SubCtl1: PCI-PM_L1.2- PCI-PM_L1.1+ ASPM_L1.2- ASPM_L1.1+
                L1SubCtl2: T_PwrOn=3100us
```

Cc: <stable@vger.kernel.org> # 5.15.y
