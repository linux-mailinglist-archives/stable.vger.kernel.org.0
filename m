Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3645A4E2D
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 15:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbiH2NeZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 09:34:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiH2NeX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 09:34:23 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91272422F3
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 06:34:22 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id n17so10231855wrm.4
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 06:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=XEx4dTVsbJadVAgMFdUWIqnkNpK3QVrJtw+oPt5kIaM=;
        b=J3F4rhEHL9vHxm7KlitgdT0pxf1i9iykx23P6+ZR8nuiyDLqEPpzC9IE9j7Kajd34V
         2Q3bykvG7vR9qt+t8/ZpSRLCNNjSu1r0CifHrk5vj07Lm7msTMd0y8o/RT0gMqCeVUAm
         SpNB8gt0oRQkx9qmo1ci6DjIGEdShKkKBFlevuMiaSxam/9P0cPRu8vu7Segh6sLxIFD
         0AJWpjylrbPGgHTDwxpN9qXGmsoZEgsDug0FV217052YeXg57Y6vo+2jzdV0e+n5NZbD
         HyO4zUtCa+/S6CVIFPKGDTVTGFnLHmre0cccWQA2ospFAScq8vxsVEsiROWfzy61L7pU
         pLLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=XEx4dTVsbJadVAgMFdUWIqnkNpK3QVrJtw+oPt5kIaM=;
        b=Qr4TgppZf7mhDx8P8aoL1LGYNeEzQAoiYxQr/YZmHe9n+uBAS6QQUOCI1uUBqaNwXb
         Cu5oi6Mtfuaxg/e2P8tBR2vwK99gT/6N0WLGrxhtdPd+EtWPQr1GKHzjzOisQq3Kfpld
         Pw9qqzmfepx769/orRGsKruGcNcA1QSw+EviTE6y9HuWIg/5oWbld1TTeBp9G/PqIjtE
         I+tX8w8ntGGeJrKN3IVmilMOPpFjrflC/w1vwFzTKCVgxDb0/D/HbR6rjDeajy8GdguT
         LNSgmCMYRpb0fDdDDNpF/P8u5oXmxt83yS/nKPe/h5AlPkGRu7FrjQ5LjjmCEYYFHt9M
         jVWg==
X-Gm-Message-State: ACgBeo2JKXbNK83r90F3K2BKe+vMGTdgMHj7J3Ftv6JwCg9f50uNxGQy
        08wxOmVIhFRgB52n4dF8eOa8QN4w6Vw=
X-Google-Smtp-Source: AA6agR4981y8ddc3QQRLAQ0sQsJ9LpsLT1hU+OJbck0qkYmeZRtGOSOqnG3wgAZED0haEdnUXVwSow==
X-Received: by 2002:a5d:64af:0:b0:225:7d80:b3d5 with SMTP id m15-20020a5d64af000000b002257d80b3d5mr6506701wrp.625.1661780060814;
        Mon, 29 Aug 2022 06:34:20 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.126.24.threembb.co.uk. [188.28.126.24])
        by smtp.gmail.com with ESMTPSA id bn6-20020a056000060600b00222ed7ea203sm4897361wrb.100.2022.08.29.06.34.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 06:34:20 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH stable-5.15 00/13] io_uring pollfree
Date:   Mon, 29 Aug 2022 14:30:11 +0100
Message-Id: <cover.1661594698.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
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

5.15 backport of io_uring pollfree patches.

Jens Axboe (2):
  io_uring: remove poll entry from list when canceling all
  io_uring: bump poll refs to full 31-bits

Jiapeng Chong (1):
  io_uring: Remove unused function req_ref_put

Pavel Begunkov (10):
  io_uring: correct fill events helpers types
  io_uring: clean cqe filling functions
  io_uring: refactor poll update
  io_uring: move common poll bits
  io_uring: kill poll linking optimisation
  io_uring: inline io_poll_complete
  io_uring: poll rework
  io_uring: fail links when poll fails
  io_uring: fix wrong arm_poll error handling
  io_uring: fix UAF due to missing POLLFREE handling

 fs/io_uring.c | 746 +++++++++++++++++++++++---------------------------
 1 file changed, 347 insertions(+), 399 deletions(-)

-- 
2.37.2

