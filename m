Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 726BB53E648
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239502AbiFFOQx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 10:16:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239518AbiFFOPy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 10:15:54 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FAAC2CDF5
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 07:15:53 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id 15so5740079qki.6
        for <stable@vger.kernel.org>; Mon, 06 Jun 2022 07:15:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xEOis3/9+WNqL+okO/nM+mCE4n6zlpF9a8nmfC3a1Y4=;
        b=Nequnv7Vu2eziwSk9UbcGiZeLibDUHP4/DIVXLMXbVY4XeV7CK1NtAzF75zOpemFg3
         gLorCmrqWA2L05gZ6vwc1Y3yn4ZKfoKmphKvJ4dmNybHbB+Cu+xHIUd+lsh+vBSiLNWq
         9AxgD+zdVjrowADjTzRf5B5d+CddjQF0S21k32FWtMp7z2Z2BCMAaZBYymMN65X5WB+p
         r4PeZyr7bpNhXp/G6W+GKLa4hP5fUEGBLWDo/HyHNqAdVoHsbyr0ZrU7iY3mivNHCCBP
         7pFfk9AoRAmDR8kDBrJeI4D2XaTCuKzPTUJf+X7uxiQtKez/3fTYTBGwGeWyyNRA0OGX
         Hg+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xEOis3/9+WNqL+okO/nM+mCE4n6zlpF9a8nmfC3a1Y4=;
        b=2E5rA0Eq5egh6QG3QgIRRKYAODmj7IFj/JRB/+pYio6hQANcXu0kWzWoNTiik31t79
         52fm64+dxmbw+NUQ6dAn6MeGkQuhd4kbQWiy/WICMTkS65YpQQgtvEs+6Nacjhjvggna
         /mo9E92UIPFBGs4z9Nxw2Bk150SKfhAGsPgYqjh9W75PSBCGjLTdn9AG45WnTKxgQkiP
         r/3awS1Vu2xYk2hEXqsXzBF0P4MC++V/mbIRL33XUqDWdb9hQOImiwXuHy3XcNNWs5xI
         CEvblCIR/QYb1zcp8zOxOqglbNX/4m8iqtASfTcDpxSfXrIu6a/JmrUVSFrgXwMwylQs
         c5CQ==
X-Gm-Message-State: AOAM5335wtq1q//5gTtw2phXYioZ1pHok7/ZKLDCD2Z8ArsmzoKknMTh
        1nhR/6AXyfMz+4dpU9KOQpF2LWjvCK1C1w==
X-Google-Smtp-Source: ABdhPJxGjwH3tCSHa4I0/2dWtRhZQ6SEBoHjBwszPibBqSBcXHMjIMCqLCEjuPSCUuZpUXECTPag3w==
X-Received: by 2002:a05:620a:15b2:b0:6a6:b411:e290 with SMTP id f18-20020a05620a15b200b006a6b411e290mr4800186qkk.364.1654524952039;
        Mon, 06 Jun 2022 07:15:52 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id x12-20020a05620a448c00b006a6d033782fsm447451qkp.63.2022.06.06.07.15.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 07:15:51 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     stable@vger.kernel.org
Cc:     kuba@kernel.org
Subject: [PATCH 0/2] net: ipa: v5.18.2 backport to fix page free
Date:   Mon,  6 Jun 2022 09:15:46 -0500
Message-Id: <20220606141548.724917-1-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This series back-ports two bug fixes that landed very late in v5.18
cycle and didn't make it to the final release.  They're present in
v5.19-rc1, but don't cherry-pick cleanly onto v5.18.2.

					-Alex

Alex Elder (2):
  net: ipa: fix page free in ipa_endpoint_trans_release()
  net: ipa: fix page free in ipa_endpoint_replenish_one()

 drivers/net/ipa/ipa_endpoint.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

-- 
2.32.0

