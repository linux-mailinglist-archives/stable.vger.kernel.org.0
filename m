Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E63A753C9F1
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 14:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233071AbiFCMRf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 08:17:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232874AbiFCMRf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 08:17:35 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FCE522F
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 05:17:34 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id n185so4006636wmn.4
        for <stable@vger.kernel.org>; Fri, 03 Jun 2022 05:17:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FfC685ky4sH9MZVP5IpRjIR/YNciXf/dVumA+hZ1v8Y=;
        b=PeP3n9cP9ySmlELMldQ/DqnSD2bUvcuMinpRoUMmb9RfvqJM617tZU5v6f41UyfapM
         wALY825eqk+KT1PAby1IOJXMtcTbADLJXDxRCb31iDm+VNSeHRAi/4CGUIFnd7s/0DIm
         p/lEPfV/QC6FADYmECNFEgv9nnzQeLDbYrWE3ciYk5aihAIqJ1wj1VEa5sJPI8Y++uo3
         TC3mJ5CC1lb6p35hf7S9b9b3m06JmDKN7t8s94FQwbUMTNp2P2D5DIeAp+21YS4RhzVc
         BJY1c7rW75UFoivAODB9Hzfl42Zbq4P9yoOHbY7N8MyKmG5K6FebJPQRlhbu8S6Ll9+y
         rd3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FfC685ky4sH9MZVP5IpRjIR/YNciXf/dVumA+hZ1v8Y=;
        b=vtBXUOQwzr4Epp21/ODRoJzZIfGIZil6xFlPZjaT/Q5Z4XwyKSrwJvxr/YD2X40h6H
         lEBQ/TVrYlEq5/A19tiA3pZFfIV4a6Ze5Wu93wx3ClYoc1Yd8XLkXi7g++KWKRP0mr64
         KogF8GffbgGfYJXPk1i3IEZJ3b4oXxdZ3KfVZM/xKOuUB84o84fzLyokIl9doFhffCrQ
         c+LK54zdJIcEWEqp1hxycbKDJ8o0UMNh04JSmD4oTX+Se0g22zeiluMnglyl67s5U2Uj
         7lF31ZT8Uk/ffur0tBupdSxcePRfC7ZIoDAPhjQrXUaziC/XMlwNmjDrRAscyufLElh/
         thgg==
X-Gm-Message-State: AOAM532eeqGWD2xo51GetHkFlFB6911zP42I1xooAYEjBAwDtX5aMq84
        X3XpakeeCCCwJgmyiRNKBTnDTNhk6mCAwg==
X-Google-Smtp-Source: ABdhPJz076MGczUfU1rwWsBoA9XODIeZ1vtWZseVaLA3maE+hZ8El3OanhzSccSOcOEbM5+xqBQsvw==
X-Received: by 2002:a05:600c:3b29:b0:397:4f6d:5119 with SMTP id m41-20020a05600c3b2900b003974f6d5119mr8638918wms.129.1654258652339;
        Fri, 03 Jun 2022 05:17:32 -0700 (PDT)
Received: from 127.0.0.fr ([193.52.24.5])
        by smtp.gmail.com with ESMTPSA id c16-20020a056000105000b002100aa69469sm7240362wrx.2.2022.06.03.05.17.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 05:17:31 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 0/2] io_uring iter_revert issues 
Date:   Fri,  3 Jun 2022 13:17:03 +0100
Message-Id: <cover.1654258554.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

5.10 fixup for 89c2b3b7491820 ("io_uring: reexpand under-reexpanded iters").
We can't just directly cherry-pick them as the code base is quite different,
so we also need patch 1/2. Previous attempts to backport 2/2 directly
were pulling in too many dependencies only adding more problems.

Pavel Begunkov (2):
  io_uring: don't re-import iovecs from callbacks
  io_uring: fix using under-expanded iters

 fs/io_uring.c | 47 ++++++-----------------------------------------
 1 file changed, 6 insertions(+), 41 deletions(-)

-- 
2.36.1

