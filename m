Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31D386B84BD
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 23:29:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbjCMW3z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 18:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbjCMW3y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 18:29:54 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91E6769CE4
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 15:29:53 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id y2so13495622pjg.3
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 15:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1678746592;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+cDZBFg4+sLfTVl0lHEWTrnMA1SY40Bzt4Pz1p3665s=;
        b=hq6kVxFAtkrq3Ewqqt9Kyb8JDJsB71QkLXq4YRWCUfPc8nsiGX+ehY+uW2sa7X0woQ
         4Cy+nxh2aVIdRJhlOjSHjMbsOEHj9E4J0batJcyf8gs34jpFaEmF+N258+vCKhdo24Ry
         JfTqLXkp+Sar+jjWV3g7F4BnuxWCO610LFmoE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678746592;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+cDZBFg4+sLfTVl0lHEWTrnMA1SY40Bzt4Pz1p3665s=;
        b=ooFyVqJzGng/34IwVcVHpvO+QvzvXuPIkwodfqYS8vd+9AGwGoqotadUXwlcpR8xIq
         I32nH7DkA4auUK4tZgj0SfhzygFGIBLT1MnbIpGKnXeAUogchDXi9EV0Iy4EygPe7Ver
         Wnr1+IAydBlzfxE4k8T9bVHK/eahP+cFKq5hqTdh6zpTzs91HZaehZOE0PbP8d4pnejk
         fOE0Vl9121c3p0JN5Ki1UcgTwWL+r2K0QoRuqJmNmTp62C+CS1Kvh0nZ5ov2LvkzLu7P
         HLKA2Qfa4CEcMP4AJM0rk7yJM/o4dbVRERFOW0gBCLD+xQpws0+hW53jL7Bzq0cH+34K
         PUCA==
X-Gm-Message-State: AO0yUKW/1nL7Ecquk5pBncoHkrep17PnwOqtej5jAtybwcOKEKdwnJH5
        ogEaBxrQ0WClzYSNcfjou/FBtzCcVGZbcKckl/A=
X-Google-Smtp-Source: AK7set+tsI6mjf1YmgDV7GcGW+bHf/BJP7/foLKzNYnTq8RcMGiGu3XY7oAgJ00CozH69W6A9oLLtQ==
X-Received: by 2002:a17:902:b716:b0:19f:3b86:4715 with SMTP id d22-20020a170902b71600b0019f3b864715mr5590127pls.8.1678746592674;
        Mon, 13 Mar 2023 15:29:52 -0700 (PDT)
Received: from khazhy-linux.svl.corp.google.com ([2620:15c:2d4:203:157:b07d:930a:fb24])
        by smtp.gmail.com with ESMTPSA id km8-20020a17090327c800b0019aa8149cb9sm352440plb.79.2023.03.13.15.29.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 15:29:52 -0700 (PDT)
From:   Khazhismel Kumykov <khazhy@chromium.org>
X-Google-Original-From: Khazhismel Kumykov <khazhy@google.com>
To:     stable@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Khazhismel Kumykov <khazhy@google.com>
Subject: [PATCH v5.10 0/5] bfq bic/cgroup interaction uaf fixes
Date:   Mon, 13 Mar 2023 15:27:52 -0700
Message-Id: <20230313222757.1103179-1-khazhy@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Pulls in uaf fix for bfqq->bic along with fixups. I pulled in the
backport dependencies that were also present in 5.15-lts.

NeilBrown (1):
  block/bfq-iosched.c: use "false" rather than "BLK_RW_ASYNC"

Yu Kuai (4):
  block, bfq: fix possible uaf for 'bfqq->bic'
  block, bfq: fix uaf for bfqq in bfq_exit_icq_bfqq
  block, bfq: replace 0/1 with false/true in bic apis
  block, bfq: fix uaf for bfqq in bic_set_bfqq()

 block/bfq-cgroup.c  |  8 ++++----
 block/bfq-iosched.c | 19 +++++++++++++------
 2 files changed, 17 insertions(+), 10 deletions(-)

-- 
2.40.0.rc1.284.g88254d51c5-goog

