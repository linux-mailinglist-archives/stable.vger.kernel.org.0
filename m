Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED64569EBA
	for <lists+stable@lfdr.de>; Thu,  7 Jul 2022 11:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233857AbiGGJmh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jul 2022 05:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232615AbiGGJmg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jul 2022 05:42:36 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72FB445070
        for <stable@vger.kernel.org>; Thu,  7 Jul 2022 02:42:35 -0700 (PDT)
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id E73CD3F163
        for <stable@vger.kernel.org>; Thu,  7 Jul 2022 09:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1657186952;
        bh=0/k9jZrw5vV9CBwx2r80FHe2MFjiQPs5GdaiVI7LCog=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=Usf96xA6pKVwLKqvg4O7YjrW7bFPaGVAR5EswAaFGPm9TTQeI4S4HA4ng0w2aJ4Ts
         zELQJ/XfjdLOWpCvtl/jA27VuUk26877Ios+MOGuWCIZE/cyS4cN3JJtTAsdUgpdI8
         85ZUaiAEAipZhlIeVC0r+P7yrAkmMy5+cRQd0+y7UIRq1otOvcOXN/hTxe3Wbb9ZH9
         0urwNaUS+6tzjAndyA7zyknJESAG0V1UF6Er5IV1T3mTk9uxw2kgxWVVmdNNk9M4JM
         f8ZEtQkdVY2lA6WL5PyC0NZchCRv83mfyNnLXcovgU2exSogLc1pJ30n63+/QPzrMK
         MPSuz+EvNvIBw==
Received: by mail-pf1-f199.google.com with SMTP id i21-20020aa79095000000b00528bd947f66so2725621pfa.18
        for <stable@vger.kernel.org>; Thu, 07 Jul 2022 02:42:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0/k9jZrw5vV9CBwx2r80FHe2MFjiQPs5GdaiVI7LCog=;
        b=AnzE4YJiDXhBOtb+AKXCa7v3uO+upf2ua4bBwxXS0zg2XjhuzJRnnHOXRj2wn8mF+A
         Y3k1P3KNvhHMxauVlKLAnc1U7iecUsEcOIX9heSvlRTrHvk++RscpR+Sq3FBJMDdfVde
         GopvR5lRjGb45FmPfsNCUdo68elN2uk5hkWjM8V8Jes8QUvhARtvpJ6lNjbkZ1VjDrjR
         9qoORFeJLdYJBD/gxOc0TiZvTsuh8VgqVDoWBHQvIaUU+5AfgJP5CWS6iVaZXInoAV+7
         +W0uWX3Y1sIvf5Tj1WWheQU/8JjQzhBMCFz20G7kQmZG29oW2HK4dYuQ6TFTNm2jADsC
         FHzg==
X-Gm-Message-State: AJIora+7WmFVwNMhW9XE/r5DeLRW/MTMwgTzRe8XYJ4YpA62vg7Z07uy
        DhPUgXUIBvxSqMQsvk5ctmFWf7M9kZdVuQ5PRC/WDKZ+DHSCwieIp2m/my5KabXNxvnG0E7VbHs
        fn24/k6L+rTDhD03ZZFHEh+KH72MgYeM6
X-Received: by 2002:a17:902:c205:b0:16b:f021:4299 with SMTP id 5-20020a170902c20500b0016bf0214299mr15311593pll.70.1657186951638;
        Thu, 07 Jul 2022 02:42:31 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sXIgj1gZjhjX5O1aSA2f5ZCznB445mcYvPL8KykhClWZybIN58wmPKyPvJtbx4KxW197vKjw==
X-Received: by 2002:a17:902:c205:b0:16b:f021:4299 with SMTP id 5-20020a170902c20500b0016bf0214299mr15311565pll.70.1657186951382;
        Thu, 07 Jul 2022 02:42:31 -0700 (PDT)
Received: from localhost.localdomain (223-137-51-72.emome-ip.hinet.net. [223.137.51.72])
        by smtp.gmail.com with ESMTPSA id w15-20020a1709027b8f00b0016230703ca3sm27085064pll.231.2022.07.07.02.42.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 02:42:30 -0700 (PDT)
From:   Po-Hsu Lin <po-hsu.lin@canonical.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     memxor@gmail.com, linux-kernel@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, shuah@kernel.org, bpf@vger.kernel.org,
        po-hsu.lin@canonical.com
Subject: [PATCH stable 5.15 0/1] Revert "selftests/bpf: Add test for bpf_timer overwriting crash"
Date:   Thu,  7 Jul 2022 17:42:06 +0800
Message-Id: <20220707094207.229875-1-po-hsu.lin@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The bpf_timer overwriting crash test will cause bpf selftest build
fail on the stable 5.15 tree with:

progs/timer_crash.c:8:19: error: field has incomplete type 'struct bpf_timer'
        struct bpf_timer timer;
                         ^
/home/ubuntu/linux/tools/testing/selftests/bpf/tools/include/bpf/bpf_helper_defs.h:39:8:
note: forward declaration of 'struct bpf_timer'
struct bpf_timer;
       ^
1 error generated.

Test shows this can only be built with 5.17 and newer kernels. Let's
revert it for the 5.15 tree.

Po-Hsu Lin (1):
  Revert "selftests/bpf: Add test for bpf_timer overwriting crash"

 .../testing/selftests/bpf/prog_tests/timer_crash.c | 32 -------------
 tools/testing/selftests/bpf/progs/timer_crash.c    | 54 ----------------------
 2 files changed, 86 deletions(-)
 delete mode 100644 tools/testing/selftests/bpf/prog_tests/timer_crash.c
 delete mode 100644 tools/testing/selftests/bpf/progs/timer_crash.c

-- 
2.7.4

