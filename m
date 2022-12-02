Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32554640867
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 15:29:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233217AbiLBO3r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 09:29:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiLBO3q (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 09:29:46 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFBF9BDB
        for <stable@vger.kernel.org>; Fri,  2 Dec 2022 06:29:44 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id m14so8041456wrh.7
        for <stable@vger.kernel.org>; Fri, 02 Dec 2022 06:29:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=U1TH1XoK+QZyztyc8Ksm0uOKGe1Ge91V8W1T9eTVWUY=;
        b=QfbCVxwULhgjyZSZriGMAS7jnqD85bnn0cbHpt5QvdYFsNmRdivr4o3QYbkZ0J4lwO
         L4CrS/06/P/q0xR9UaxJkDj+PZBpXvFYHZOAYbllCFE6nLlE61O/uXVbCn9H0onUPwcE
         0Q3w0SJI5fo4f0und5z2Mr9/V+s/eHxJ6oUdilMYM6nqQFIufvlAgT8FWvioj6tbHnUh
         1x1j89xFYnQDOZKAtFfl/C4Z2IoEgjklSOKn+LvQkNcCy4Fpr0VZav7Q6MTvGoVEWB0v
         SZo164lDELcVFXk/zXNrvL7wPTXQEcc5Wr3MBs4UGiws4DXUpCkMu19wGDVXDmrE6gkE
         Gzhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U1TH1XoK+QZyztyc8Ksm0uOKGe1Ge91V8W1T9eTVWUY=;
        b=Hz/YqujNqGHybeLpt8+S+dEcoGPWjjG4h3+vmDmU1tuRljCiFcsoX6CmH3BABAqkUP
         MaBlpBs6zpPcEn6lqhtAGOjBsmJn2aV36FwAevy9V/3HiA7GK++0x9QtGR1OLWbKTEPb
         UeK/I9IK8pSk0mB/oOkDYFzKmdg+C/iwTvBhNhA43Y/rmeQbKUTDw7Un8CYakSVIezLW
         fZoAzCUFuZwiThDykXeklygJxsWEAVGZqo9PMzmoPy/uCMeo5QIlI1YpUdWrsDUhlYcS
         kbYjhm1Z9nW9+OE0XPXWR2tXmbJ3JnhL8oucCOlMeX7CAHsOf4rHF82K+uts0oOBgfdD
         7yqw==
X-Gm-Message-State: ANoB5plC4m31IKOu3sPlE7EYR02Jbxq+E0NBQ4K6WYQV9c5VAAYouvl0
        22qYCGJjASWaSm2emyIaBS594jg5xHs=
X-Google-Smtp-Source: AA0mqf6Ft1ezKGGJWypdI/XaOaMoCA3CvtZoP601mfBkAU5bKUIcRTMf6qZNNXT0N9fTE1J4uAUuvg==
X-Received: by 2002:a5d:5702:0:b0:242:569:3028 with SMTP id a2-20020a5d5702000000b0024205693028mr1774643wrv.435.1669991383036;
        Fri, 02 Dec 2022 06:29:43 -0800 (PST)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:2dd3])
        by smtp.gmail.com with ESMTPSA id n187-20020a1ca4c4000000b003d005aab31asm8956946wme.40.2022.12.02.06.29.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 06:29:42 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH stable-5.15 0/5] io_uring/poll backports for 5.15
Date:   Fri,  2 Dec 2022 14:27:10 +0000
Message-Id: <cover.1669990799.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Recent patches for io_uring polling.

Lin Ma (1):
  io_uring/poll: fix poll_refs race with cancelation

Pavel Begunkov (4):
  io_uring: update res mask in io_poll_check_events
  io_uring: fix tw losing poll events
  io_uring: cmpxchg for poll arm refs release
  io_uring: make poll refs more robust

 fs/io_uring.c | 57 ++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 50 insertions(+), 7 deletions(-)

-- 
2.38.1

