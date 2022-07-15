Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C36F576A84
	for <lists+stable@lfdr.de>; Sat, 16 Jul 2022 01:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231783AbiGOXQF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 19:16:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbiGOXQE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 19:16:04 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A53CD90D91
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 16:16:03 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d13-20020a170903230d00b0016c1efef9ecso2757849plh.6
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 16:16:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Xh2DC/YgxhibtpkiyuO6Hap31qolbl+mPh1o7AUypM8=;
        b=o0GEQ5tWgXLBv+bWIAwrSR7ihN4Vr+vQxJTzijIaf54KW+i+BhXxyqnea5ittwniBG
         dlOnfMafYpKOTDNiYCaR37xyBfcTLg8VMZY6BibG+gMMO19KEzUHWbE18O6ny6Af1tVi
         5fIPgS1MZ0A44gL9na8+WJaDXFsWzNid6yFWUgicNzVzr+muGwy3B0G4KOoFsJP2FPmz
         F4PAdnN0NE6+KrS970lbeXJGV3e3xX55v6sUbRtP3MHwF58hywYGhomFa/fXEZo3ou3g
         5M0hfeinkYzB/tEGA6D/XynSEhfDZGT8UdwYTjnJW7BJESH7gS/06AwLNIDrBQPX1T1Q
         hUUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Xh2DC/YgxhibtpkiyuO6Hap31qolbl+mPh1o7AUypM8=;
        b=St+r7k5lS0MG8HjYAbHwvp+O1rtUcQp0BWY3MYmIXRQphWbYmm4k4SJGSt2zfT9UEc
         WnwcsYDhPPumUG4eNbFy3T5b4Crg/Irktn7RUpyd2vIQMoeFipjsvqZesoN7or/mn/lx
         gVg2Z6jn+WlHyYexCVG9IE3Gn00Z9YbJXCWTfDkw5q1YGGNxsBfjlPgz/TqqwZH8sokT
         usODoHsRX59e1SbdKMW8jgdAxfpX4EkJ/FSKKMGysmiplZsYVZOiZEdDB+w0HfSGLrku
         Beigwohq48YgYpQdMc6eHnv7TXf6WJNfK932UntIky4inwJwBA61E1YubhAQE59so0mx
         oQpQ==
X-Gm-Message-State: AJIora8vejyg2x3BdInGAiK4Ob8zsD2WR37KzK0A0hMQh9LZmn3C79rk
        PlXjZvPYf38rwtiMucRRzdndQ+k=
X-Google-Smtp-Source: AGRyM1vZ9eZf3vuHSiBtOUvoYn/2A1iA36zvBQis/FrssuEzVfFJ19aXl4+nYgGN/V6e44GH6A5QkZY=
X-Received: from hmarynka.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:925])
 (user=ovt job=sendgmr) by 2002:a17:903:2452:b0:16c:18f4:7997 with SMTP id
 l18-20020a170903245200b0016c18f47997mr15964546pls.68.1657926963221; Fri, 15
 Jul 2022 16:16:03 -0700 (PDT)
Date:   Fri, 15 Jul 2022 23:15:40 +0000
Message-Id: <20220715231542.2169650-1-ovt@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH 0/2] Fix vm kselftest build
From:   Oleksandr Tymoshenko <ovt@google.com>
To:     gregkh@linuxfoundation.org
Cc:     sidhartha.kumar@oracle.com, stable@vger.kernel.org,
        Oleksandr Tymoshenko <ovt@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patchset reverts duplicates of two backported commits that created
exact copies of functions added by the original backports.

Oleksandr Tymoshenko (2):
  Revert "selftest/vm: verify remap destination address in mremap_test"
  Revert "selftest/vm: verify mmap addr in mremap_test"

 tools/testing/selftests/vm/mremap_test.c | 53 ------------------------
 1 file changed, 53 deletions(-)

-- 
2.37.0.170.g444d1eabd0-goog

