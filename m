Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB4B96EB1AF
	for <lists+stable@lfdr.de>; Fri, 21 Apr 2023 20:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232753AbjDUSeD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Apr 2023 14:34:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232243AbjDUSeC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Apr 2023 14:34:02 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6F901FF3
        for <stable@vger.kernel.org>; Fri, 21 Apr 2023 11:33:56 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id e9e14a558f8ab-32abc2e7da8so6407805ab.3
        for <stable@vger.kernel.org>; Fri, 21 Apr 2023 11:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1682102036; x=1684694036;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QGmpVDlM7szKPAXBXr0QOtmzbtyw9J0tZvTkPv2CLvY=;
        b=T8Md4o6arXMRHG23pV7Y4iXigriN7qMLERHnprvCA6x6vqUi7wR/+4faO4lWrJEpGc
         wc2HG2oFwf6gsWkXjY3dgw0RhX/oifVgUWEh4osU9j5IrrHfEA7I5Uu0C2fi6CMfPmCj
         2EVVbvxZdR3/lEZ5kyTYdAAfgOJPv/7bXYg5I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682102036; x=1684694036;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QGmpVDlM7szKPAXBXr0QOtmzbtyw9J0tZvTkPv2CLvY=;
        b=FuW2NMIzlFqX/2qyzlkawvKbtIuRJFWXsHHQpByANp+YVps2T4m9GXTCyU4jK1+kAr
         YAdkV17tvuaYPa552hkRnVifB51Zz++nUc0WzNZxazMvKHIGJ5OUPigBCFi4HFP65BW2
         x83CGSTGPuhlsiI6C8aa+3b40lkg6toQkVR53b8WW4f8RuvEjerLPNzmpkuY0EfvUTH0
         9Ibsngn4Qx38oqvuWsYJqgg7jX8BWUgyvj6Epeo4qibFyb81GYK/MLeNwFsYXL5Z1PyB
         rPMPdri9NzNQyxqm5s4FPDUfLKaff6AGl721dTNJqiqKyjgcPYlr2vDWQxTG0EvpBbU5
         yGEg==
X-Gm-Message-State: AAQBX9dyTQxVY/VlE1vbgKeL0AIFngKEFbDG+xXo1uxItF9nVjVQfaFD
        3mmUxGJMFJ7QmROK86klNCO/Qo3pV0BD57HHfvA=
X-Google-Smtp-Source: AKy350bIbuSj3n4C5qO4dhX1rxL8JK8i8EE7g5Sj3KiuZHAnqaO48yIxd2rLRmJ9jaGi9/2zNwwtfA==
X-Received: by 2002:a92:c881:0:b0:32b:7258:70f4 with SMTP id w1-20020a92c881000000b0032b725870f4mr4606033ilo.16.1682102036251;
        Fri, 21 Apr 2023 11:33:56 -0700 (PDT)
Received: from markhas1.lan (71-218-48-220.hlrn.qwest.net. [71.218.48.220])
        by smtp.gmail.com with ESMTPSA id y16-20020a92d0d0000000b003248469e5easm1203942ila.43.2023.04.21.11.33.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 11:33:55 -0700 (PDT)
From:   Mark Hasemeyer <markhas@chromium.org>
To:     markhas@google.com
Cc:     stable@vger.kernel.org
Subject: [PATCH] PCI:ASPM: Remove pcie_aspm_pm_state_change()
Date:   Fri, 21 Apr 2023 12:33:52 -0600
Message-ID: <20230421183352.1466582-1-markhas@chromium.org>
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
