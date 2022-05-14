Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A278B52721B
	for <lists+stable@lfdr.de>; Sat, 14 May 2022 16:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233419AbiENOlm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 May 2022 10:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230337AbiENOlm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 May 2022 10:41:42 -0400
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [IPv6:2a01:e0c:1:1599::14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63E4A2CDED
        for <stable@vger.kernel.org>; Sat, 14 May 2022 07:41:40 -0700 (PDT)
Received: from geek500.localdomain (unknown [82.65.8.64])
        (Authenticated sender: casteyde.christian@free.fr)
        by smtp5-g21.free.fr (Postfix) with ESMTPSA id EB1D25FFA9;
        Sat, 14 May 2022 16:41:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=free.fr;
        s=smtp-20201208; t=1652539298;
        bh=RVUXgeNXqlyrexHEFCz9+8klDgtdwYVM274LVBDdlG8=;
        h=From:To:Cc:Subject:Date:From;
        b=Udnzf2F8L35lxGLDoyygbcKRDHt0A2TLy70dsZNdTUGrqVtQJvWW0ozWcBeo2vvoE
         T1MsmH+BJn9pNzHd1Zie6jtcnJ5TdvFjJRtAB6IxLxEXiYg0xzNjHuNpKFhW/ZnoFZ
         vrDkgQJkT9mjSmulkRZadUTJCU4KxlhVKSXB28geKZ6bfgjtuQkL39ws5fjaEu2C44
         0h5gUkljqOhOOGGH4g6xdlKF4z3pVpF2WL9Ev3WR6gWDyj9gaiM7GGbklXQV4CNsiq
         UZiyXNIDeqUlMdqmOdG3g+3Hsb06HzuykGLlCyGPMTPO0W8BSzNYUw/b26IoUUu+O+
         i7ZXXLuo6ePYA==
From:   Christian Casteyde <casteyde.christian@free.fr>
To:     stable@vger.kernel.org
Cc:     regressions@lists.linux.dev, kai.heng.feng@canonical.com,
        alexander.deucher@amd.com, gregkh@linuxfoundation.org
Subject: [REGRESSION] Laptop with Ryzen 4600H fails to resume video since 5.17.4 (works 5.17.3)
Date:   Sat, 14 May 2022 16:41:19 +0200
Message-ID: <2584945.lGaqSPkdTl@geek500.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

#regzbot introduced v5.17.3..v5.17.4
#regzbot introduced: 001828fb3084379f3c3e228b905223c50bc237f9

Hello
Since 5.17.4 my laptop doesn't resume from suspend anymore. At resume, 
symptoms are variable:
- either the laptop freezes;
- either the screen keeps blank;
- either the screen is OK but mouse is frozen;
- either display lags with several logs in dmesg:
[  228.275492] [drm] Fence fallback timer expired on ring gfx
[  228.395466] [drm:amdgpu_dm_atomic_commit_tail] *ERROR* Waiting for fences 
timed out!
[  228.779490] [drm] Fence fallback timer expired on ring gfx
[  229.283484] [drm] Fence fallback timer expired on ring sdma0
[  229.283485] [drm] Fence fallback timer expired on ring gfx
[  229.787487] [drm] Fence fallback timer expired on ring gfx
...

I've bisected the problem.

Please note this laptop has a strange behaviour on suspend:
The first suspend request always fails (this point has never been fixed and 
plagues us when trying to diagnose another regression on touchpad not resuming 
in the past). The screen goes blank and I can get it OK when pressing the 
power button, this seems to reset it. After that all suspend/resume works OK.

Since 5.17.4, it is not possible anymore to get the laptop working again after 
the first suspend failure.

HW : HP Pavilion / Ryzen 4600H with AMD graphics integrated + NVidia 1650Ti 
(turned off with ACPI call in order to get more battery, I'm not using NVidia 
driver).



